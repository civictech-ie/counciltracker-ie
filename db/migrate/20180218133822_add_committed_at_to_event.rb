class AddCommittedAtToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :committed_at, :datetime
    add_index :events, :committed_at, unique: false
  end
end
