# Ursus Chat

An Urbit chat application for iOS.

Work in progress; first project using my [UrsusAirlock](https://github.com/dclelland/UrsusAirlock) HTTP/`%eyre` client library.

## Todo list

Tasks are managed on the [Ursus Chat kanban board](https://github.com/dclelland/UrsusChat/projects/1).

### Questions

- [ ] What do we use the `Synced` data from the `chat-hook` subscription for?
- [ ] Same goes for the permissions data; need to read the landscape frontend code
    - Permissions swapped with groups in the [new groups refactor](https://github.com/urbit/urbit/compare/lf/groups-refactor#diff-516b27b1aa5e14dab4867795e7f50203R166)

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
- [ ] Disable 'Continue' button until form is filled out and validated
- [ ] Add root app version number (+ which base hash was current when this release went out; unfortunately compatibility will be tied to a given base hash)
- [ ] Fetching the access key from the web credentials keychain causes the URL field to be cleared

### Chat row

- [ ] Experiment with bubbs/nobubbs
    - Experiment with circular avatar views
    - Experiment with grey background/light bubble foreground
    - Possibly need cell transparency for things like highlighting/context menu previews to work correctly
- [ ] Display custom avatar in avatar view
- [ ] Display custom username in avatar view
    - Tapping should show ship name...?
    - Copy paste support for ship names?
- [ ] Messages from self should be right-aligned, with no avatar or username
    - Also, different gray
- [ ] Time should be visible when swiping to the left
- [ ] Context menu with option to copy the letter text
