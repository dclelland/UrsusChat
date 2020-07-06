# Ursus Chat

An Urbit chat application for iOS.

Work in progress; first project using my [Ursus](https://github.com/dclelland/Ursus) HTTP/`%eyre` client library.

## Todo list

### Actions

- [ ] Build out `AppLaunchAction`
    - Set up secure keychain storage and use [Shared Web Credentials](https://github.com/kishikawakatsumi/KeychainAccess#shared_web_credentials) to store/retrieve the `+code`
    - Clear keychain on logout...?
    - LoginView doesn't refresh when the credentials change
    - `getCredentialsThunk` and `setCredentialsThunk`
- [ ] Finish `sessionThunk`: More granular `SessionAction` cases and error handling

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

