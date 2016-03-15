class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :model_name
      t.string :action_name
      t.references :role, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
