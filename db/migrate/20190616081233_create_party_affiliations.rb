class CreatePartyAffiliations < ActiveRecord::Migration[5.2]
  def change
    create_table :party_affiliations do |t|
      t.references :seat, foreign_key: true
      t.references :party, foreign_key: true
      t.date :commenced_on

      t.timestamps
    end
  end
end
