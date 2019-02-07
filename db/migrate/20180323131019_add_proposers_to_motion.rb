class AddProposersToMotion < ActiveRecord::Migration[5.1]
  def change
    add_column :motions, :proposers_ids, :bigint, array: true, default: []
    add_column :motions, :position, :integer
    add_index :motions, :position
    add_index :motions, :proposers_ids
    add_index :amendments, :proposers_ids
  end
end
