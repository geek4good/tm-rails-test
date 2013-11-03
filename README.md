## Trademob Rails Assignment

### Part 1: Platforms for campaigns

It's now possible (for superusers, see below) to manage platforms for
campaigns. Every campaign has to have at least one platform.

### Part 2: Authorization and roles

For authorization I've used CanCan, because ActiveAdmin already comes
with an appropriate built-in adapter. Since, for now, there are only two
roles, I didn't build a role model but have instead just added a
`superuser` flag to the `AdminUser` class / table. Non-superusers (aka
campaign managers) can only manage campaigns, their own user properties
and comment on campaigns. For anything else superuser privileges are
needed.

### Part 3: Audit trail for platform changes

For simplicity I've used the `ActiveAdmin::Comment` model to do the
logging. All users are are able to view the comments (read: log). The
log entries are displayed with their corresponding campaign. Thus,
everything that belongs together is kept together nicely.

### Wrapping up

Once you are done with your implementation, send us a link. A bit of documentation about your implementation probably won't hurt either. Good luck!
