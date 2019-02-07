class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.date :occurred_on
      t.references :council_session, index: true
      t.references :eventable, polymorphic: true, index: true
      t.bigint :related_seat_ids, array: true, default: []

      t.timestamps
    end
  end
end
