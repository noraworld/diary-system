class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.string  :site_title,       null: false
      t.string  :site_description, null: true
      t.integer :launched_since,   null: true

      t.timestamps
    end
  end
end
