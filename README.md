# Ursus Chat

An Urbit chat application for iOS.

Work in progress; first project using my [Ursus](https://github.com/dclelland/Ursus) HTTP/`%eyre` client library.

## Todo list

### General

- [ ] Fix the SwiftUI Xcode previews
- [ ] Build out **Ursus Sigil**, as this will be needed for chat views. See [`sigil-js`](https://github.com/urbit/sigil-js) for reference.
    - Perhaps time to split up the Ursus work off into its own organisation with separate repos?
    - Might need to fix the obfuscation issues at the same time
        - Wasn't there a bug found in the `++mud` implementation recently...?
- [ ] Try a basic `%poke` request, as haven't done that yet really. For example, to `chat-hook`: `{"message": {"path: "/~/~zod/mc", "envelope": {"uid": "0v3.l14pg.36jh8.mh9dl.ps65v.4lujh", "number": 1, "author: "~zod", "when": 15942876211449, "letter": {"text": "Hello world"}}}}`
- [ ] Current set of type extensions are messy as hell; `ChatListView.ViewModel` also needs to go.
    - Look at how the current chat app aggregates this data
- [ ] I spotted some JSON decoding errors when parsing a set of `MetadataUpdate` instances; need to recreate this issue

### Authentication

- [ ] Fetching the access key from the web credentials keychain causes the URL field to be cleared
- [ ] `LoginView` should just show a splash if attempting login with successful `getCredentials`
- [ ] `LoginView` should display errors and re-enable the form on login failure
- [ ] `AppStore.startSession` should employ more granular `SessionState` cases (e.g. '`.authenticating`')
- [ ] `Credentials` should be cleared on logout

### Login view

- [ ] Redesign this; get rid of the table view

### Chat list view

- [ ] Cells need a set fixed height; also hide the table view separators until the content is loaded
- [ ] Test whether the split view works on iPad

### Chat list row

- [ ] Look into: Grouping chats by group; perhaps separate view, one up the hierarchy (will also need DMs, 'all chats' etc.)
- [ ] Look into: Different sorting modes
- [ ] Look into: Filters (e.g. search)

### Chat view

- [ ] Set up scroll view offset state
    - Should 'stick' to the bottom of the window 
    - When new chats are inserted the scroll view jumps around

### Chat row

- [ ] Decide: Chat bubbles vs. plain text
    - With chat bubbles; DMs can omit certain information like usernames and avatars 
- [ ] This will need to support inline formatting

### Settings view

- [ ] Add meta/session information ("signed in as ~lanrus-rinfep on http://localhost")
    - Ship name + sigil
- [ ] 'Open Landscape' link
- [ ] 'Open Bridge' link
- [ ] 'Support/discussion channel' link
- [ ] 'Bug reports' link (to GitHub)

### Design

- [ ] Better icon
- [ ] Better splash screen

