# Ursus Chat

An Urbit chat application for iOS.

Work in progress; first project using my [Ursus](https://github.com/dclelland/Ursus) HTTP/`%eyre` client library.

## Todo list

### Authentication

- [ ] Fetching the access key from the web credentials keychain causes the URL field to be cleared
- [ ] `LoginView` should just show a splash if attempting login with successful `getCredentials`
- [ ] `LoginView` should display errors and re-enable the form on login failure
- [ ] `AppStore.startSession` should employ more granular `SessionState` cases (e.g. '`.authenticating`')
- [ ] `Credentials` should be cleared on logout

### Interface

- [ ] Add tab view
- [ ] Add split view
- [ ] Add authentication view
- [ ] Add chat list view
- [ ] Add chat view
- [ ] Add settings view

### Features

- [ ] Open Landscape function
- [ ] Open support/discussion channel function

### Design

- [ ] Better icon
- [ ] Better splash screen

