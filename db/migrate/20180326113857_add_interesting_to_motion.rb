class AddInterestingToMotion < ActiveRecord::Migration[5.1]
  def change
    add_column :motions, :interesting, :boolean
    add_index :motions, :interesting
  end
end
