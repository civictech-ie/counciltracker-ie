class AddTagsToMotion < ActiveRecord::Migration[5.1]
  def change
    add_column :motions, :tags, :text, array: true, default: []
    add_index :motions, :tags
  end
end
