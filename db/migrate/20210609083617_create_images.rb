class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.integer :imagable_id
      t.string :imagable_type
      t.boolean :is_published

      t.timestamps
    end
  end
end
