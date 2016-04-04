class Invitation < ActiveRecord::Base
  has_many :guests, -> { order(:list_order) }
  accepts_nested_attributes_for :guests, allow_destroy: true

  validates :seen, :responded, inclusion: { in: [true, false] }
  validates :access_code, presence: true, uniqueness: true

  before_validation :set_access_code

  def respond(guests_params, song)
    transaction do
      self.song = song
      guest_updates = guests.map { |g| g.respond(guests_params[g.id.to_s]) }
      raise ActiveRecord::Rollback unless guest_updates.all?
      update(responded: true)
    end
  end

  def set_access_code
    self.access_code ||= unique_access_code
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
