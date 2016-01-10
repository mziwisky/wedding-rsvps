class Guest < ActiveRecord::Base
  belongs_to :invitation

  validates_presence_of :name, :editable, :list_order
end
