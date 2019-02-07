class CreateMotions < ActiveRecord::Migration[5.1]
  def change
    create_table :motions do |t|
      t.text :official_reference
      t.text :body
      t.bigint :local_electoral_area_ids, array: true, default: []
      t.text :executive_recommendation
      t.references :meeting, foreign_key: true

      t.timestamps
    end
  end
end
