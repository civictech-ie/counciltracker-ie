class FixPositionForAmendmentAndMotion < ActiveRecord::Migration[5.1]
  def change
    remove_column :amendments, :position, :text
    remove_column :motions, :position, :text

    add_column :amendments, :position, :integer
    add_column :motions, :position, :integer
    add_index :amendments, :position
    add_index :motions, :position
  end
end
