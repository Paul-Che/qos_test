class CreateSensorValues < ActiveRecord::Migration[5.1]
  def change
    create_table :sensor_values do |t|
      t.integer :time_unix, null: false
      t.integer :value, null: false
      t.boolean :deleted, default: false
      t.references :sensor, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
