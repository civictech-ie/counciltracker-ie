class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.references :attendable, polymorphic: true
      t.text :status
      t.references :councillor, foreign_key: true

      t.timestamps
    end

    add_index :attendances, :status, unique: false
  end
end
