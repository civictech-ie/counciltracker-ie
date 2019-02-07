class CreateMeetings < ActiveRecord::Migration[5.1]
  def change
    create_table :meetings do |t|
      t.references :council_session
      t.text :meeting_type
      t.date :occurred_on

      t.timestamps
    end

    add_index :meetings, :occurred_on
  end
end
