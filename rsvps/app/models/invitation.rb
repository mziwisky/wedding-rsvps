class Invitation < ActiveRecord::Base
  has_many :guests

  validates_presence_of :seen, :responded, :access_code
  validates_uniqueness_of :access_code

  before_create :set_access_code

  private

  def set_access_code
    self.access_code = unique_access_code
  end

  def unique_access_code
    loop do
      code = generate_access_code
      break code unless self.class.where(access_code: code).exists?
    end
  end

  # four random characters that are each a-z, A-Z, or 0-9
  def generate_access_code
    SecureRandom.urlsafe_base64.chars.select{|c| /[a-zA-Z0-9]/ =~ c }.take(4).join
  end
end
