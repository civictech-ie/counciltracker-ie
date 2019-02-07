class AddDccIdToCouncillorAndMeeting < ActiveRecord::Migration[5.1]
  def change
    add_column :councillors, :dcc_id, :text
    add_column :meetings, :dcc_id, :text

    add_index :councillors, :dcc_id, unique: true
    add_index :meetings, :dcc_id, unique: true
  end
end
