class MediaMention < ApplicationRecord
  belongs_to :mentionable, polymorphic: true, touch: true

  validates :body, presence: true
  validates :mentionable, presence: true
  validates :published_on, date: { allow_blank: true }

  after_initialize :set_published_on

  def domain
    return '' unless self.url.present?
    URI.parse(self.url).host.gsub('www.','')
    rescue
      nil
  end

  private

  def set_published_on
    return if self.published_on.present? or self.persisted?
    self.published_on = Date.current
  end
end
