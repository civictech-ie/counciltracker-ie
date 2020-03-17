class AddMayorsVoteToMotion < ActiveRecord::Migration[6.0]
  def change
    add_column :motions, :mayors_vote, :text, index: true
    add_column :amendments, :mayors_vote, :text, index: true
  end
end
