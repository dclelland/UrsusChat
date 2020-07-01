# Ursus Chat

An Urbit chat application for iOS.

Work in progress; first project using my [Ursus](https://github.com/dclelland/Ursus) HTTP/`%eyre` client library.

## Todo list

### Architecture

- [ ] Find better place to store the client
    - ...on the reducer?
    - See: https://swiftwithmajid.com/2019/09/18/redux-like-state-container-in-swiftui
- [ ] Switch actions from `enum`s to `structs`
- [ ] Flesh out login/logout actions/thunks
    - Will need to also flesh out `AuthenticatedState` and `LoginState` (might not need the latter)
- [ ] Clean up `SubscribeEvent` decomposition
    - Add `SubscriptionState`, `SubscriptionEventAction` etc
    - Be sure not to throw away errors

### Authentication

- [ ] Set up secure keychain storage and use [Shared Web Credentials](https://github.com/kishikawakatsumi/KeychainAccess#shared_web_credentials) to store/retrieve the `+code`

### Data

- [ ] Write chat client Ursus wrapper
    - Reference:
        - Reducers: https://github.com/urbit/urbit/tree/master/pkg/interface/src/reducers
        - Store: https://github.com/urbit/urbit/blob/master/pkg/interface/src/store/chat.js
        - API: https://github.com/urbit/urbit/blob/master/pkg/interface/src/api/chat.js
            - Pagination: https://github.com/urbit/urbit/blob/master/pkg/interface/src/subscription/chat.js#L17

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

