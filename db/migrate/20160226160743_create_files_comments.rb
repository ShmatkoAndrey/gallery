class CreateFilesComments < ActiveRecord::Migration
  def change
    create_table :files_comments do |t|
      t.string :file
      t.integer :comment_id

      t.timestamps null: false
    end
  end
end
