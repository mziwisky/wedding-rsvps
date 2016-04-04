class AddSongToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :song, :string
  end
end
