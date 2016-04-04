class AddEmailNameToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :email_name, :string
  end
end
