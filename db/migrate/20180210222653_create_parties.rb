class CreateParties < ActiveRecord::Migration[5.1]
  def change
    create_table :parties do |t|
      t.text :name, null: false
      t.text :slug, null: false
      t.text :colour_hex

      t.timestamps
    end

    add_index :parties, :slug, unique: true
    add_index :parties, :name, unique: true
  end
end
