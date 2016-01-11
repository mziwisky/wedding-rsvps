class Invitation < ActiveRecord::Base
  has_many :guests, -> { order(:list_order) }

  validates :seen, :responded, inclusion: { in: [true, false] }
  validates :access_code, presence: true, uniqueness: true

  before_validation :set_access_code

  private

  def set_access_code
    self.access_code = unique_access_code
  end

  def unique_access_code
    loop do
      code = generate_access_code
      break code unless code_in_use?(code) || code_is_dirty?(code)
    end
  end

  # three random characters that are each a-z, A-Z, or 0-9
  def generate_access_code
    SecureRandom.urlsafe_base64.chars.select{|c| /[a-zA-Z0-9]/ =~ c }.take(3).join
  end

  def code_in_use?(access_code)
    self.class.where(access_code: access_code).exists?
  end

  def code_is_dirty?(access_code)
    /(ass|fuk|poo|tit|cok)/i =~ access_code
  end
end
