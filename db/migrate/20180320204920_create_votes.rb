class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.references :voteable, polymorphic: true
      t.text :status
      t.references :councillor, foreign_key: true

      t.timestamps
    end

    add_index :votes, :status, unique: false
  end
end
