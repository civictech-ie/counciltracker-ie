class CreateMediaMentions < ActiveRecord::Migration[5.1]
  def change
    create_table :media_mentions do |t|
      t.text :body
      t.text :url
      t.text :source
      t.references :mentionable, polymorphic: true
      t.date :published_on

      t.timestamps
    end
  end
end
