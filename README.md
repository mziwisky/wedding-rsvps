Wedding RSVP Manager
===

I made this to manage e-invites for my wedding.

I'm about to push it to my github so I don't lose it.

Hopefully there are no secrets in it. If there are, well the site is no longer
hosted, so 🤷

## Configuration

Used to have my email address hardcoded in here, but then I replaced every
instance of it with `ENV['MY_EMAIL_ADDRESS']`. So, figure out how to set that.
I mean if anyone besides me is using this, there's more stuff they'll have to
change, like all the Ziwisky's.

Anyway, the only other two env vars I configured this with were `SMTP_PASSWORD`
and `DATABASE_URL`.
