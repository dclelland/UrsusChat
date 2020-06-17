# Ursus

An Urbit HTTP/`%eyre` client for iOS/macOS in Swift.

See my [Ursus Chat](https://github.com/dclelland/UrsusChat) repository for a demo project.

## Usage

Ursus is very much a work in progress - better documentation and a demo app to come. Here's a quick sketch for now:

```swift
let ursus = Ursus(url: URL(string: "http://localhost")!, code: "fipfes-fipfes-fipfes-fipfes")
ursus.authenticationRequest() { ship in
    ursus.subscribeRequest(ship: ship, app: "chat-view", path: "/primary") { event in
        print("On subscribe event:", event)
    }
}
```

## Installation

Ursus can be installed using Cocoapods by adding `pod 'Ursus', '~> 1.0'` to your `Podfile`.

I can probably help set up Carthage or Swift Package Manager support if you need it.

## Todo list

Things that would make this codebase nicer:

- [ ] Pass IDs back through to the event handlers so unsubscribe requests can be made.
- [ ] Test `AckRequest`, `UnsubscribeRequest`, `DeleteRequest` properly.
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
- [BigInt](https://github.com/attaswift/BigInt)
