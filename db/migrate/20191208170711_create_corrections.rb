class CreateCorrections < ActiveRecord::Migration[6.0]
  def change
    create_table :corrections do |t|
      t.text :body
      t.text :name
      t.text :email_address

      t.timestamps
    end
  end
end
