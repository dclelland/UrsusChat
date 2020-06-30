# Ursus Chat

An Urbit chat application for iOS.

Work in progress; first project using my [Ursus](https://github.com/dclelland/Ursus) HTTP/`%eyre` client library.

## Todo list

### Data

- [ ] Write chat client Ursus wrapper
    - Reference:
        - Reducers: https://github.com/urbit/urbit/tree/master/pkg/interface/src/reducers
        - Store: https://github.com/urbit/urbit/blob/master/pkg/interface/src/store/chat.js
        - API: https://github.com/urbit/urbit/blob/master/pkg/interface/src/api/chat.js
            - Pagination: https://github.com/urbit/urbit/blob/master/pkg/interface/src/subscription/chat.js#L17

### Authentication

- [ ] Set up secure keychain storage and use [Shared Web Credentials](https://github.com/kishikawakatsumi/KeychainAccess#shared_web_credentials) to store/retrieve the `+code`

### Architecture

- [ ] ReSwift and SwiftUI
    - Ideas:
        - https://github.com/ReSwift/ReSwift/issues/424#issuecomment-532050246
        - https://github.com/gilbox/Cloe#optionally-add-some-convenience-extensions-to-the-store
    - Other posts:
        - https://tech.mercari.com/entry/2019/12/11/150000
        - https://medium.com/better-programming/making-a-real-world-application-with-swiftui-cb40884c1056
        - https://wojciechkulik.pl/ios/swift-how-to-handle-network-async-calls-using-redux
        - https://swiftwithmajid.com/2019/09/18/redux-like-state-container-in-swiftui

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

