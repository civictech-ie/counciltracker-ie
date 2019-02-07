class CreateCoOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :co_options do |t|
      t.references :outgoing_seat, index: true, foreign_key: { to_table: :seats }
      t.references :incoming_councillor, index: true, foreign_key: { to_table: :councillors }
      t.references :incoming_party, index: true, foreign_key: { to_table: :parties }
      t.text :reason

      t.timestamps
    end
  end
end
