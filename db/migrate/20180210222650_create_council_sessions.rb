class CreateCouncilSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :council_sessions do |t|
      t.date :commenced_on
      t.date :concluded_on

      t.timestamps
    end

    add_index :council_sessions, :commenced_on
    add_index :council_sessions, :concluded_on
  end
end
