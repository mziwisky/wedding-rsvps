ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: "Dashboard"

  content title: "Dashboard" do
    panel "Overview" do
      total = Guest.all.count
      para "Total invitees -- #{total}"

      seen = Guest.seen_invite.count
      para "Seen invite -- #{seen} (#{total - seen})"

      responded = total - Guest.rsvp_pending.count
      para "Responded -- #{responded} (#{total - responded})"

      coming = Guest.attending.count
      para "Coming -- #{coming} (#{total - coming})"
    end
  end
end
