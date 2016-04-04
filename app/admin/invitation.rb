def status_tag_bool(bool)
  if bool.nil?
    '?'
  elsif bool
    status_tag 'yes', :ok
  else
    status_tag 'no'
  end
end

ActiveAdmin.register Invitation do

  permit_params :email_name, guests_attributes: [:name, :email, :editable, :list_order, :id, :_destroy]

  # ok, few things.
  # 1) invitations need a "sent" column.  don't want to send immediately upon creation.
  #    (in fact, probably won't auto-send at all :/ well, nah, maybe we like how sinai-evals does?)

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
      invite.guests.first.name
    end
    column 'Response' do |invite|
      "#{invite.responded ? invite.guests.attending.count : '_'} / #{invite.guests.count}"
    end
    column :seen
    column :responded
    column :access_code
    actions
  end
end
