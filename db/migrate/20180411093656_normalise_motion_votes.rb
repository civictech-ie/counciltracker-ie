class NormaliseMotionVotes < ActiveRecord::Migration[5.1]
  def change
    add_column :motions, :hashed_id, :text
    add_index :motions, :hashed_id, unique: true
    add_column :amendments, :hashed_id, :text
    add_index :amendments, :hashed_id, unique: true

    Motion.all.each do |motion|
      if motion.is_votable? and motion.votes.countable.any?
        motion.vote_ruleset = 'plurality'
        motion.vote_method = 'rollcall'
      else
        motion.vote_ruleset = 'plurality'
        motion.vote_method = 'voice'
        motion.vote_result = 'error'
      end

      motion.save!
    end

    Amendment.all.each do |amendment|
      if amendment.votes.countable.any?
        amendment.vote_ruleset = 'plurality'
        amendment.vote_method = 'rollcall'
      else
        amendment.vote_ruleset = 'plurality'
        amendment.vote_method = 'voice'
        amendment.vote_result = 'error'
      end

      amendment.save!
    end
  end
end
