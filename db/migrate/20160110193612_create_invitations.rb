class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.boolean :seen,       null: false, default: false
      t.boolean :responded,  null: false, default: false
      t.string :access_code, null: false

      t.timestamps null: false
    end
  end
end
