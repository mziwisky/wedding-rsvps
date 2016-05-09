def status_tag_bool(bool)
  if bool.nil?
    '?'
  elsif bool
    status_tag 'yes', :ok
  else
    status_tag 'no'
  end
end

def send_invitation(invite)
  InvitationMailer.invitation_email(invite).deliver
  invite.update(sent: true)
end

def send_reminder(invite)
  InvitationMailer.reminder_email(invite).deliver
end

ActiveAdmin.register Invitation do

  permit_params :email_name, guests_attributes: [:name, :email, :editable, :list_order, :id, :_destroy]

  member_action :deliver, method: :post do
    unless resource.guests.first.email.include? '@'
      redirect_to admin_invitation_path, flash: { error: "Can't send email to #{resource.guests.first.email}" }
      return
    end
    send_invitation(resource)
    redirect_to admin_invitation_path, notice: "Email sent to #{resource.guests.first.email}"
  end

  member_action :deliver_reminder, method: :post do
    unless resource.guests.first.email.include? '@'
      redirect_to admin_invitation_path, flash: { error: "Can't send email to #{resource.guests.first.email}" }
      return
    end
    send_reminder(resource)
    redirect_to admin_invitation_path, notice: "Reminder email sent to #{resource.guests.first.email}"
  end

  action_item :deliver, only: :show do
    link_to 'Deliver', deliver_admin_invitation_path, method: :post
  end

  action_item :send_reminder, only: :show do
    link_to 'Send Reminder', deliver_reminder_admin_invitation_path, method: :post
  end

  collection_action :deliver_all, method: :post do
    invites = Invitation.where(sent: false)
      .to_a.select { |i| i.guests.first.email.include? '@' }
    invites.each do |invite|
      send_invitation(invite)
    end
    redirect_to admin_invitations_path, notice: "Emails sent for #{invites.length} invitations"
  end

  collection_action :remind_all, method: :post do
    invites = Invitation.where(responded: false)
      .to_a.select { |i| i.guests.first.email.include? '@' }
    invites.each do |invite|
      send_reminder(invite)
    end
    redirect_to admin_invitations_path, notice: "Reminders sent for #{invites.length} invitations"
  end

  action_item :deliver_all, only: :index do
    count = Invitation.where(sent: false)
      .to_a.select { |i| i.guests.first.email.include? '@' }
      .count
    link_to "DANGER!!! Deliver All Unsent (#{count})", deliver_all_admin_invitations_path, method: :post
  end

  action_item :remind_all, only: :index do
    count = Invitation.where(responded: false)
      .to_a.select { |i| i.guests.first.email.include? '@' }
      .count
    link_to "DANGER!!! Remind All Unresponded (#{count})", remind_all_admin_invitations_path, method: :post
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :email_name
      f.has_many :guests, sortable: :list_order, allow_destroy: true do |g|
        g.input :name
        g.input :email
        g.input :editable, label: 'Name Editable?'
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :sent
      row :seen
      row :responded
      row :access_code
      row :email_name
      row :guests do |invite|
        table do
          thead do
            tr do
              th 'Name'
              th 'Attending'
              th 'Email'
              th 'List order'
            end
          end
          tbody do
            invite.guests.each do |g|
              tr do
                td g.name
                td status_tag_bool(g.attending)
                td g.email
                td g.list_order
              end
            end
          end
        end
      end
      row 'Attendance' do |invite|
        invite.responded ? invite.guests.attending.count : '?'
      end
      row :song
    end
  end

  index do
    selectable_column
    id_column
    column :email_name
    column 'Primary' do |invite|
      primary = invite.guests.first
      "#{primary.name} <#{primary.email}>"
    end
    column 'Response' do |invite|
      "#{invite.responded ? invite.guests.attending.count : '_'} / #{invite.guests.count}"
    end
    column :sent
    column :seen
    column :responded
    column :access_code
    actions
  end
end
