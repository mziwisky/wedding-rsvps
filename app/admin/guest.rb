def status_tag_bool(bool)
  if bool.nil?
    '?'
  elsif bool
    status_tag 'yes', :ok
  else
    status_tag 'no'
  end
end

ActiveAdmin.register Guest do

  permit_params :name, :email, :invitation_id, :editable, :attending, :list_order # TODO: delete.

  scope :all, default: true
  scope :attending
  scope :not_attending
  scope :rsvp_pending

  # index page
  index do
    selectable_column
    column :name
    column :email
    column :editable
    column 'Attending' do |guest|
      status_tag_bool guest.attending
    end
    actions
  end
end
