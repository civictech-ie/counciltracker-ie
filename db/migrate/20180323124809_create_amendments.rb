class CreateAmendments < ActiveRecord::Migration[5.1]
  def change
    create_table :amendments do |t|
      t.references :motion, foreign_key: true
      t.text :body
      t.text :position, null: false
      t.text :official_reference, null: false
      t.bigint :proposers_ids, array: true, default: []

      t.timestamps
    end

    add_index :motions, :official_reference, unique: true
    add_index :amendments, :official_reference, unique: true
    add_index :amendments, :position, unique: false
  end
end
