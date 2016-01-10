class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.references :invitation, index: true, foreign_key: true
      t.string :name,           null: false
      t.string :email
      t.boolean :editable,      null: false, default: false
      t.boolean :attending
      t.integer :list_order,    null: false

      t.timestamps null: false
    end
  end
end
