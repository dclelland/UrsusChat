# Ursus

An Urbit HTTP/`%eyre` client for iOS/macOS in Swift.

## Usage

Ursus is very much a work in progress - better documentation and a demo app to come. Here's a quick sketch for now:

```swift
let ursus = Ursus(url: URL(string: "http://localhost")!, code: "fipfes-fipfes-fipfes-fipfes")
ursus.authenticationRequest().response { response in
    ursus.subscribeRequest(
        ship: "fipfes-fipfes-fipfes-fipfes--fipfes-fipfes-fipfes-fipfes",
        app: "chat-view",
        path: "/primary",
        handler: { event in
            print("On subscribe event:", event)
        }
    )
}
```

## Installation

Ursus can be installed using Cocoapods by adding `pod 'Ursus', '~> 1.0'` to your `Podfile`.

I can probably help set up Carthage or Swift Package Manager support if you need it.

## Todo list

Things that would make this codebase nicer:

- [ ] Test `AckRequest`, `UnsubscribeRequest`, `DeleteRequest` properly.
- [ ] Add `kebab-case` instance for [`JSONDecoder.KeyDecodingStrategy`](https://developer.apple.com/documentation/foundation/jsondecoder/keydecodingstrategy) (there does exist a `snake_case` instance).
- [ ] Write Combine publishers for pokes and subscribes (see the [donnywals writeup](https://www.donnywals.com/using-promises-and-futures-in-combine/)). Should be able to include type safe JSON decoding as part of this work.
- [ ] Split off test chat client into its own repository and work on providing chat app coverage.
- [ ] Better documentation/examples.

## Other clients

- [channel.js](https://github.com/urbit/urbit/blob/master/pkg/arvo/app/launch/js/channel.js)
- [urlock.py](https://github.com/baudtack/urlock-py/blob/master/urlock/urlock.py)

## Other utilities

- [util.js](https://github.com/urbit/urbit/blob/master/pkg/interface/chat/src/js/lib/util.js)
- [urbit-ob](https://github.com/urbit/urbit-ob)
- [urbit-hob](https://github.com/urbit/urbit-hob)

## Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [IKEventSource](https://github.com/inaka/EventSource)
- [UInt128](https://github.com/Jitsusama/UInt128)
