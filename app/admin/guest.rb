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

  actions :all, except: [:new, :edit]
  permit_params :name, :email, :editable, :attending, :list_order

  scope :all, default: true
  scope :attending
  scope :not_attending
  scope :rsvp_pending

  # index page
  index do
    selectable_column
    column :name
    column 'Attending' do |guest|
      status_tag_bool guest.attending
    end
    column :email
    column :editable
    column :invitation
    column 'Invitation seen' do |guest|
      status_tag_bool guest.invitation.seen
    end
    actions
  end
end
