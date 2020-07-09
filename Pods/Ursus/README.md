# Ursus

An Urbit HTTP/`%eyre` client for iOS/macOS in Swift.

See my [Ursus Chat](https://github.com/dclelland/UrsusChat) repository for a demo project.

## Ursus

Ursus is very much a work in progress - better documentation and a demo app to come. Here's a quick sketch for now:

```swift
let ursus = Ursus(url: URL(string: "http://localhost")!, code: "fipfes-fipfes-fipfes-fipfes")
ursus.loginRequest() { ship in
    ursus.subscribeRequest(ship: ship, app: "chat-view", path: "/primary") { event in
        print("On subscribe event:", event)
    }
}
```

### Ursus Atom

Ursus contains a submodule for working with [atoms and auras](https://urbit.org/docs/tutorials/hoon/atoms-auras-and-simple-cell-types/), with support for the urbit phonetic base:

```swift
let ship = try! PatP(string: "~lanrus-rinfep")
let point = Int(ship) // 328448
```

There is an `Aura` protocol with an associated type `Atom` which can be any `UnsignedInteger` type, but in practice we use `BigUInt` types.

Current implementations:

- `PatP` (`@p`)
- `PatQ` (`@q`)
- `PatUV` (`@uv`)

## Installation

Ursus can be installed using Cocoapods by adding the following lines to your podfile:

```ruby
pod 'Ursus', '~> 1.2'
pod 'Ursus/Atom', '~> 1.2'
```

I can probably help set up Carthage or Swift Package Manager support if you need it.

## Todo list

Things that would make this codebase nicer:

- [ ] Unit tests for `@p` obfuscation/deobfuscation - I think `~fipfes-fipfes-fipfes-fipfes` doesn't survive a round trip 🙀 while other similar values do...
- [ ] Add support for new `%scry` endpoint
- [ ] Should the new `%logout` endpoint clear the `urbauth` cookie?
- [ ] Pass IDs back through to the event handlers so unsubscribe requests can be made.
- [ ] Test `AckRequest`, `UnsubscribeRequest`, `DeleteRequest` properly.
- [ ] Better documentation/examples.

## Other clients

- [channel.js](https://github.com/urbit/urbit/blob/master/pkg/arvo/app/launch/js/channel.js)
- [urlock-py](https://github.com/baudtack/urlock-py)
- [urbit-airlock-ts](https://github.com/liam-fitzgerald/urbit-airlock-ts)

## Other utilities

- [util.js](https://github.com/urbit/urbit/blob/master/pkg/interface/src/lib/util.js)
- [urbit-ob](https://github.com/urbit/urbit-ob)
- [urbit-hob](https://github.com/urbit/urbit-hob)

## Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [BigInt](https://github.com/attaswift/BigInt)
- [Parity](https://github.com/dclelland/Parity)
