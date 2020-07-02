# Ursus Chat

An Urbit chat application for iOS.

Work in progress; first project using my [Ursus](https://github.com/dclelland/Ursus) HTTP/`%eyre` client library.

## Todo list

### Actions

- [ ] Build out `AppLaunchAction`
    - Set up secure keychain storage and use [Shared Web Credentials](https://github.com/kishikawakatsumi/KeychainAccess#shared_web_credentials) to store/retrieve the `+code`
    - Clear keychain on logout...?
    - LoginView doesn't refresh when the credentials change
- [ ] Finish `sessionThunk`: More granular `SessionAction` cases and error handling

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

