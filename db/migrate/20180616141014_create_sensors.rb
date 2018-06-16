class CreateSensors < ActiveRecord::Migration[5.1]
  def change
    create_table :sensors do |t|
      t.string :name, null: false
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
