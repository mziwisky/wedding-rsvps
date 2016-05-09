class InvitationMailer < ActionMailer::Base
  default from: %{"Mike Ziwisky" <#{ENV['MY_EMAIL_ADDRESS']}>}

  def invitation_email(invitation)
    @name_of_dearness = invitation.email_name
    # wanted to do "vanity domains" with a `/` separator, but that didn't
    # render the proper layout, so i changed it, but actually i like the look
    # of the `?g=` better anyway.
    @rsvp_link = "#{invitation_url(invitation.access_code)}?g=#{parameterize(invitation.email_name)}"
    mail(to: invitation.guests.first.email, subject: "Your invitation to Mike and Kate's wedding")
  end

  def reminder_email(invitation)
    @name_of_dearness = invitation.email_name
    @rsvp_link = "#{invitation_url(invitation.access_code)}?g=#{parameterize(invitation.email_name)}"
    mail(to: invitation.guests.first.email, subject: "Mike and Kate await your RSVP")
  end

  private

  # Stolen (and modified) from activesupport/lib/active_support/inflector/transliterate.rb, line 80
    def parameterize(string, sep = '_')
      # replace accented chars with their ascii equivalents
      parameterized_string = ActiveSupport::Inflector.transliterate(string)
      # Turn unwanted chars into the separator
      parameterized_string.gsub!(/[^a-zA-Z0-9\-_]+/, sep)
      unless sep.nil? || sep.empty?
        re_sep = Regexp.escape(sep)
        # No more than one of the separator in a row.
        parameterized_string.gsub!(/#{re_sep}{2,}/, sep)
        # Remove leading/trailing separator.
        parameterized_string.gsub!(/^#{re_sep}|#{re_sep}$/, '')
      end
      parameterized_string
    end
end
