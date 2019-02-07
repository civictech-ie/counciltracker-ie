class CreateSeats < ActiveRecord::Migration[5.1]
  def change
    create_table :seats do |t|
      t.references :council_session, foreign_key: true, index: true
      t.references :local_electoral_area, foreign_key: true, index: true
      t.references :councillor, foreign_key: true, index: true
      t.references :party, foreign_key: true, index: true

      t.date :commenced_on
      t.date :concluded_on

      t.timestamps
    end

    add_index :seats, :commenced_on
    add_index :seats, :concluded_on
  end
end
