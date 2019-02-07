class CreateChangeOfAffiliations < ActiveRecord::Migration[5.1]
  def change
    create_table :change_of_affiliations do |t|
      t.references :councillor, index: true
      t.references :outgoing_party, index: true, foreign_key: { to_table: :parties }
      t.references :incoming_party, index: true, foreign_key: { to_table: :parties }

      t.timestamps
    end
  end
end
