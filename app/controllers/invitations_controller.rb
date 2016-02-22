class InvitationsController < ApplicationController

  before_action :load_invitation

  def show
    render 'edit' unless @invitation.responded?
  end

  def update
    redirect_to invitation_path and return if @invitation.responded?

    @invitation.respond(response_params)
    if @invitation.responded?
      render 'show'
    else
      render 'edit'
    end
  end

  private

  def response_params
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
      # raise something that will cause a not_found and not trigger other actions
    end
  end

  def not_found
    # TODO:
    # render something like "couldn't find that, sorry, mike probably screwed something up. if you're having trouble seeing or submitting your RSVP, please email postman@mikeandkate.wedding about it, and mike will sort it out.  you can also just send your rsvp information there."
  end
end
