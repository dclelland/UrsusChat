# Ursus Chat

An Urbit chat client for iOS.

Work in progress; first project using my [Ursus](https://github.com/dclelland/Ursus) HTTP/`%eyre` client library.

## Todo list

### Authentication

- [ ] Set up secure keychain storage and use [Shared Web Credentials](https://github.com/kishikawakatsumi/KeychainAccess#shared_web_credentials) to store/retrieve the `+code`
- [ ] Check cookie storage to see if we have a valid `urbauth` cookie stored for our planet, and authenticate automatically

### Data

- [ ] Write chat client Ursus wrapper
    - Think about how best to represent an "app" within Ursus

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

