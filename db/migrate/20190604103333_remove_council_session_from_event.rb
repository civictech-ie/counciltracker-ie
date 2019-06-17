class RemoveCouncilSessionFromEvent < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :council_session_id
  end
end
