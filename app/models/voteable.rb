class Voteable < ApplicationRecord
  self.abstract_class = true
  has_many :votes, as: :voteable, dependent: :destroy
  has_many :councillors, through: :votes

  validates :vote_ruleset , presence: true
  validates :vote_ruleset, inclusion: %w(plurality absolute_majority super_majority), allow_blank: false
  
  validates :vote_method, presence: true
  validates :vote_method, inclusion: %w(voice rollcall), allow_blank: false
  validates :vote_result, presence: true
  validates :vote_result, inclusion: %w(pass fail error), allow_blank: false

  after_validation :set_vote_result, if: -> (m) { m.rollcall? }
  after_save :clean_votes, if: -> (m) { m.rollcall? }
  after_save :destroy_votes, if: -> (m) { !m.rollcall? }

  scope :has_countable_votes, -> { joins(:votes).merge(Vote.countable).distinct }
  scope :voted_on_by, -> (c) { joins(:votes).merge(Vote.countable.where(councillor: c)) }

  def result
    self.vote_result
  end

  def result
    self.vote_result
  end

  def rollcall?
    (self.vote_method == 'rollcall')
  end

  def redetermine_vote_result!
    return true unless rollcall?
    return true if self.votes.where(status: 'exception').any?
    self.vote_result = determine_vote_result
    return true unless self.vote_result_changed?
    self.save!
  end

  private

  def set_vote_result
    self.vote_result = determine_vote_result
  end

  def determine_vote_result
    case self.vote_ruleset
    when 'plurality'
      if self.votes.in_favour.count > self.votes.in_opposition.count
        return 'pass'
      else
        return 'fail'
      end
    when 'absolute_majority'
      if self.votes.in_favour.count >= 32 # todo: make dynamic based on councillor count
        return 'pass'
      else
        return 'fail'
      end
    when 'super_majority'
      if self.votes.in_favour.count >= 42 # todo: make dynamic based on councillor count
        return 'pass'
      else
        return 'fail'
      end
    else
      return nil
    end
  end

  def clean_votes
    expected_councillor_ids = self.meeting.councillors.pluck(:id).sort
    voted_councillor_ids = self.votes.pluck(:councillor_id).sort

    # delete votes that shouldn't exist
    (voted_councillor_ids - expected_councillor_ids).each do |councillor_id|
      self.votes.where(councillor_id: councillor_id).each do |vote|
        vote.destroy!
      end
    end

    # create votes that shouldn exist
    (expected_councillor_ids - voted_councillor_ids).each do |councillor_id|
      a = self.meeting.attendances.find_by!(councillor_id: councillor_id)
      vote_status = (a.status == 'absent') ? 'absent' : 'exception'
      Vote.create!(voteable: self, councillor_id: councillor_id, status: vote_status)
    end
  end

  def destroy_votes # if it's not a rollcall vote, destroy uncountable votes
    return true if self.votes.countable.any? # don't destroy countable ones, these take work to enter!
    self.votes.destroy_all
  end
end