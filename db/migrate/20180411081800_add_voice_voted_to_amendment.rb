class AddVoiceVotedToAmendment < ActiveRecord::Migration[5.1]
  def change
    add_column :amendments, :vote_ruleset, :text, null: false, default: 'plurality'
    add_column :amendments, :vote_method, :text, null: false, default: 'rollcall'
    add_column :amendments, :vote_result, :text, null: false, default: 'error'

    add_index :amendments, :vote_result, unique: false
  end
end
