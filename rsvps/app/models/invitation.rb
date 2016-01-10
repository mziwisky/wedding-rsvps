class Invitation < ActiveRecord::Base
  has_many :guests

  validates_presence_of :seen, :responded, :access_code
end
