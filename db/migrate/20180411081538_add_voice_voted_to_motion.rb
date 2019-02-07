class AddVoiceVotedToMotion < ActiveRecord::Migration[5.1]
  def change
    add_column :motions, :vote_ruleset, :text, null: false, default: 'plurality'
    add_column :motions, :vote_method, :text, null: false, default: 'rollcall'
    add_column :motions, :vote_result, :text, null: false, default: 'error'

    add_index :motions, :vote_result, unique: false
  end
end
