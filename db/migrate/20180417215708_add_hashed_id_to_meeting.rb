class AddHashedIdToMeeting < ActiveRecord::Migration[5.1]
  def change
    add_column :meetings, :hashed_id, :text
    add_index :meetings, :hashed_id, unique: true
    Meeting.all.each(&:save)
  end
end
