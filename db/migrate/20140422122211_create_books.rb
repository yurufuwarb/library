class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :type
      t.string :name
      t.string :outline

      t.timestamps
    end
  end
end
