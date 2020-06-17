# Ursus Chat

An Urbit chat client for iOS.

Work in progress; first project using my [Ursus](https://github.com/dclelland/Ursus) HTTP/`%eyre` client library.

## Todo list

### Data

- [ ] Write chat client Ursus wrapper
    - Reference:
        - Subscription: https://github.com/urbit/urbit/blob/master/pkg/interface/chat/src/js/subscription.js
        - Reducers: https://github.com/urbit/urbit/tree/master/pkg/interface/chat/src/js/reducers
    - Questions
        - Why do the subscriptions [need to be sequential](https://github.com/urbit/urbit/blob/master/pkg/interface/chat/src/js/subscription.js#L60)?
        - Is [this](https://github.com/urbit/urbit/blob/master/pkg/interface/chat/src/js/subscription.js#L68) for pagination?

### Authentication

- [ ] Set up secure keychain storage and use [Shared Web Credentials](https://github.com/kishikawakatsumi/KeychainAccess#shared_web_credentials) to store/retrieve the `+code`

### Architecture

- [ ] Decide on design pattern
    - Coordinator pattern?
    - Generic view controller pattern?
    - SwiftUI?
    - Combine?

### Interface

- [ ] Add tab view
- [ ] Add split view
- [ ] Add authentication view
- [ ] Add chat list view
- [ ] Add chat view
- [ ] Add settings view

### Features

- [ ] Sign out function
- [ ] Open Landscape function

### Design

- [ ] Better icon
- [ ] Better splash screen

