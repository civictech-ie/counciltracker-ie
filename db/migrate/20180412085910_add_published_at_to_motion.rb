class AddPublishedAtToMotion < ActiveRecord::Migration[5.1]
  def change
    add_column :motions, :published_at, :datetime
    add_index :motions, :published_at

    Motion.has_countable_votes.each { |m| m.publish! }
    Motion.interesting.each { |m| m.publish! }
    Motion.where(vote_method: 'voice').where.not(vote_result: 'error').each { |m| m.publish! }
  end
end
