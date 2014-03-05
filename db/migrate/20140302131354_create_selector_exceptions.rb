class CreateSelectorExceptions < ActiveRecord::Migration
  def change
    create_table :selector_exceptions do |t|
      t.integer :store_id
      t.text :message
      t.string :status

      t.timestamps
    end
  end
end
