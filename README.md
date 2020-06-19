# Ursus Chat

An Urbit chat client for iOS.

Work in progress; first project using my [Ursus](https://github.com/dclelland/Ursus) HTTP/`%eyre` client library.

## Todo list

### Data

- [ ] Write chat client Ursus wrapper
    - Reference:
        - Note: The following has probable changes due to the Landscape rearchitecture being [merged](https://github.com/urbit/urbit/pull/3025)
        - Subscription: https://github.com/urbit/urbit/blob/master/pkg/interface/chat/src/js/subscription.js
            - Questions:
                - Why do the subscriptions [need to be sequential](https://github.com/urbit/urbit/blob/master/pkg/interface/chat/src/js/subscription.js#L60)?
                - Is [this](https://github.com/urbit/urbit/blob/master/pkg/interface/chat/src/js/subscription.js#L68) for pagination?
        - Reducers: https://github.com/urbit/urbit/tree/master/pkg/interface/chat/src/js/reducers

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
- [ ] Open support/discussion channel function

### Design

- [ ] Better icon
- [ ] Better splash screen

