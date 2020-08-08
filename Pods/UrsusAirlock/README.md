# Ursus Airlock

An Urbit HTTP/`%eyre` client for iOS/macOS in Swift.

See my [Ursus Chat](https://github.com/dclelland/UrsusChat) repository for a demo project.

## Usage

Ursus Airlock is very much a work in progress - better documentation and a demo app to come. Here's a quick sketch for now:

```swift
let airlock = Airlock(url: URL(string: "http://localhost")!, code: "fipfes-fipfes-fipfes-fipfes")
airlock.loginRequest() { result in
    switch result {
    case .success(let ship):
        airlock.connect()
        airlock.subscribeRequest(ship: ship, app: "chat-view", path: "/primary") { event in
            print(event)
        }
    case .failure(let error):
        print(error)
    }
}
```

## Installation

Ursus can be installed using Cocoapods by adding the following line to your podfile:

```ruby
pod 'UrsusAirlock', '~> 1.8'
```

I can probably help set up Carthage or Swift Package Manager support if you need it.

## Todo list

Things that would make this codebase nicer:

- [ ] Should the new `%logout` endpoint clear the `urbauth` cookie?
- [ ] Pass IDs back through to the event handlers so unsubscribe requests can be made.
- [ ] Test `UnsubscribeRequest`, `DeleteRequest` properly.
- [ ] Better documentation/examples.

## Other clients

- [channel.js](https://github.com/urbit/urbit/blob/master/pkg/arvo/app/launch/js/channel.js)
- [urlock-py](https://github.com/baudtack/urlock-py)
- [urbit-airlock-ts](https://github.com/liam-fitzgerald/urbit-airlock-ts)

## Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [AlamofireEventSource](https://github.com/dclelland/AlamofireEventSource)
- [UrsusAtom](https://github.com/dclelland/UrsusAtom)
