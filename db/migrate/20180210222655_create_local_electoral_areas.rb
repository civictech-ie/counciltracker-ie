class CreateLocalElectoralAreas < ActiveRecord::Migration[5.1]
  def change
    create_table :local_electoral_areas do |t|
      t.text :name
      t.text :slug, null: false

      t.timestamps
    end

    add_index :local_electoral_areas, :slug, unique: true
    add_index :local_electoral_areas, :name, unique: true
  end
end
