class InvitationsController < ApplicationController

  class InvitationNotFound < StandardError; end

  rescue_from InvitationNotFound, with: :not_found

  before_action :load_invitation

  def show
    render 'edit' unless @invitation.responded?
  end

  def update
    redirect_to invitation_path and return if @invitation.responded?

    @invitation.respond(guest_params, song)
    if @invitation.responded?
      render 'show'
    else
      render 'edit'
    end
  end

  private

  def song
    params.require(:invitation)[:song]
  end

  def guest_params
    params_per_guest = [:attending, :name]
    guest_ids = @invitation.guest_ids.map(&:to_s)
    guest_params = guest_ids.reduce({}) do |hash, id|
      hash.tap { |h| h[id] = params_per_guest }
    end
    params.require(:invitation).require(:guests).permit(guest_params)
  end

  def load_invitation
    code = params[:id] || params[:invitation_id] # cuz of vanity urls
    @invitation = Invitation.find_by(access_code: code)
    if @invitation.present?
      @invitation.update(seen: true) # mark as 'seen'
    else
      raise InvitationNotFound
    end
  end

  def not_found
    render 'not_found'
  end
end
