# Ursus Chat

An Urbit chat application for iOS.

Work in progress; first project using my [UrsusAirlock](https://github.com/dclelland/UrsusAirlock) HTTP/`%eyre` client library.

## Todo list

### General

- [ ] Ursus should pause the connection when the app is backgrounded, and resume when the app reenters foreground
- [ ] Try a basic `%poke` request, as haven't done that yet really. For example, to `chat-hook`: `{"message": {"path: "/~/~zod/mc", "envelope": {"uid": "0v3.l14pg.36jh8.mh9dl.ps65v.4lujh", "number": 1, "author: "~zod", "when": 15942876211449, "letter": {"text": "Hello world"}}}}`

### Store and reducers

- [ ] What do we use the `Synced` data from the `chat-hook` subscription for?
- [ ] Same goes for the permissions data; need to read the landscape frontend code
    - Permissions swapped with groups in the [new groups refactor](https://github.com/urbit/urbit/compare/lf/groups-refactor#diff-516b27b1aa5e14dab4867795e7f50203R166)
- [ ] I spotted some JSON decoding errors when parsing a set of `MetadataUpdate` instances; need to recreate this issue
- [ ] Current set of type extensions are messy as hell
    - Look at how the current chat app aggregates this data

### Authentication

- [ ] `Credentials` should be cleared on logout

### App view

- [ ] Fade animation, spinner on login (this is where `SessionState` should be handled, see below)
- [ ] The tab view might be incompatible with `ChatView` on iPad; make it part of `ChatListView`...?

### Login view

- [ ] Redesign this
    - Possibly: get rid of the table view
        - Custom keyboard dodging if we don't use a table view (does this work anyway?)
    - Nicer text input fields
        - Highlight with red border and display validation message when an invalid URL or code is input
        - URL input field needs message explaining what your URL is for newbies
            - Unfortunately this app might be first port of call for people who've only just heard what Urbit is and search the app store to see if they "have an app"; will need to support this
            - So, this message should link to urbit.org, at the very least
    - Nicer background aligned with splash and icon
- [ ] Finish the login flow
    - Hide the form if initially logging in from keychain; see notes above about more granular `SessionState` cases
    - Disable the form while logging in; re-enable it on failure; perhaps show a spinner of some kind
    - Error messages not being handled currently
- [ ] Disable 'Continue' button until form is filled out and validated
- [ ] Add root app version number (+ which base hash was current when this release went out; unfortunately compatibility will be tied to a given base hash)
- [ ] Fetching the access key from the web credentials keychain causes the URL field to be cleared

### Chat list view

- [ ] Add button with own sigil
    - Fix action sheet constraint issues
    - remove/revisit Settings view functionality; perhaps make most of that post v1
    - Make sigil button correct size for Apple HIG; circular background
        - Will need fallback sigil image for moons and comets
- [ ] Look into: Grouping chats by group (with table view headers...?)
    - Perhaps use a second list view, one up the hierarchy (will also need DMs, 'all chats' etc.)
- [ ] Look into: Different sorting modes
- [ ] Look into: Filters (e.g. search)
- [ ] DM/New chat/Join chat
    - Popover modal for chat name...?
- [ ] Will eventually need to display invites
- [ ] Need to retain the selected chat list row; it pops automatically on chat update

### Chat list row

- [ ] Is this finished...? Do we need swipe to delete? Context menus? Swipe to mark as read/unread

### Chat view

- [ ] Set up scroll view offset state
    - Initially; scroll to bottom
    - Should 'stick' to the bottom of the window
    - When new chats are inserted the scroll view jumps around
- [ ] Display group name/DM host name if available in addition to chat name
- [ ] Display chat/group metadata (separate view)
- [ ] Text input view/send message button

### Chat row

- [ ] Display custom avatar in avatar view
- [ ] Display custom username in avatar view
    - Tapping should show ship name...?
    - Copy paste support for ship names?
- [ ] Messages from self should be right-aligned, with no avatar or username
    - Also, different gray
- [ ] Sequential messages from same user should be grouped
    - Username only visible on the first message
    - Avatar only visible on the last message
- [ ] Add accessory view timestamps once per day
- [ ] Time should be visible when swiping to the left
- [ ] Pending message handling
- [ ] Context menu with option to copy the letter text

### Letter view

- [ ] `.text`: Add support for inline formatting
- [ ] `.url`: Fix the way the underlying cell view highlights on tap
- [ ] `.code`: Divider should not stretch the bubble to full width

### Settings view

- [ ] Add meta/session information ("signed in as ~lanrus-rinfep on http://localhost")
    - Ship name + sigil
    - App version + base hash (see above)
- [ ] Dark mode device setting override (like the way Twitter does it)
- [ ] Custom sigil/nickname disabling
- [ ] 'Open Landscape' link
- [ ] 'Open Bridge' link
- [ ] 'Support/discussion channel' link
- [ ] 'Bug reports' link (to GitHub)

### Design

- [ ] Better icon
- [ ] Better splash screen
- [ ] Better window `tintColor` aligned with icon and splash
