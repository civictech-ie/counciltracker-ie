class AddFieldsToMotion < ActiveRecord::Migration[5.1]
  def change
    add_column :motions, :votable, :boolean, default: true
    rename_column :motions, :body, :title
    add_column :motions, :body, :text
    add_column :motions, :executive_vote, :text

    add_index :motions, :votable
    add_index :motions, :executive_vote
  end
end
