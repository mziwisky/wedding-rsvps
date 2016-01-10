class Guest < ActiveRecord::Base
  belongs_to :invitation

  validates :name, :list_order, presence: true
  validates :editable, inclusion: { in: [true, false] }
end
