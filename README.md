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
    - Implementations:
        - https://github.com/ReSwift/ReSwift
            - https://github.com/ReSwift/ReSwift/issues/424
            - https://github.com/ReSwift/ReSwift/tree/mjarvis/swiftui
        - https://github.com/Dimillian/SwiftUIFlux
        - https://github.com/kitasuke/SwiftUI-Redux
        - https://github.com/StevenLambion/SwiftDux
        - https://github.com/ReCombine/ReCombine
    - 'Clean architecture':
        - https://nalexn.github.io/clean-architecture-swiftui/
            - https://github.com/nalexn/clean-architecture-swiftui
    - Other posts:
        - https://tech.mercari.com/entry/2019/12/11/150000
        - https://medium.com/better-programming/making-a-real-world-application-with-swiftui-cb40884c1056
        - https://wojciechkulik.pl/ios/swift-how-to-handle-network-async-calls-using-redux
        - https://swiftwithmajid.com/2019/09/18/redux-like-state-container-in-swiftui/
- [ ] ReSwift thoughts
    - How to manage top-level state?
        - `AppState` `.unauthenticated`, `.authenticating`, `.authenticated`...?
            - `AuthenticationState(url:code:)`
            - `ChatState(client:store:)`
    - Where to manage top-level state? (`SceneDelegate`...?)
    - Can we use a router?
    - How to manage asynchronous actions?

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

