class CreateLines < ActiveRecord::Migration[6.0]
  def change
    create_table :lines do |t|
      t.string :type
      t.integer :user_id
      t.date :applies_on
      t.string :electricity_metric
      t.string :water_metric

      t.timestamps
    end
  end
end
