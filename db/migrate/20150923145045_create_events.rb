class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :name
      t.string :eventable_content
      t.integer :eventable_id
      t.string :eventable_type

      t.timestamps null: false
    end
  end
end
