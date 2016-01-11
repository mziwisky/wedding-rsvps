class InvitationsController < ApplicationController

  def show
    code = params[:id] || params[:invitation_id] # cuz of vanity urls
    @invitation = Invitation.find_by(access_code: code)
  end

  def edit
    # this template will send you to `show` if you've already submitted, along with a flash message that's like "you already submitted -- here's waht you said.  if you need to change anything, please email postman@..."
  end

  def update
    debugger
    # not allowed if you've already submitted
  end

  private

  def not_found
    # render something like "couldn't find that, sorry, mike probably screwed something up. if you're having trouble seeing or submitting your RSVP, please email postman@mikeandkate.wedding about it, and mike will sort it out.  you can also just send your rsvp information there."
  end
end
