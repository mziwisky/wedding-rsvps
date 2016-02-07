class Guest < ActiveRecord::Base
  belongs_to :invitation

  validates :name, :list_order, presence: true
  validates :editable, inclusion: { in: [true, false] }

  attr_accessor :guest_responding
  validates :attending, inclusion: { in: [true, false], message: 'required' }, if: -> { self.guest_responding }

  def respond(params)
    params ||= {}
    self.guest_responding = true
    attrs = params.slice(*response_whitelist)
    self.update(attrs)
  end

  private

  def response_whitelist
    whitelist = [:attending]
    whitelist << :name if self.editable?
    whitelist
  end
end
