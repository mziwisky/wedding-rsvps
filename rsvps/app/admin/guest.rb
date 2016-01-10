ActiveAdmin.register Guest do

  permit_params :name, :email, :invitation_id, :editable, :attending, :list_order # TODO: delete.
end
