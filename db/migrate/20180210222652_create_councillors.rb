class CreateCouncillors < ActiveRecord::Migration[5.1]
  def change
    create_table :councillors do |t|
      t.text :given_name
      t.text :family_name
      t.text :full_name
      t.text :gender
      t.date :born_on
      t.text :sort_name, null: false
      t.text :slug, null: false

      t.timestamps
    end

    add_index :councillors, :sort_name
    add_index :councillors, :full_name
    add_index :councillors, :born_on
    add_index :councillors, :slug, unique: true
  end
end
