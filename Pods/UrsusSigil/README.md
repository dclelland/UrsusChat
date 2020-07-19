# Ursus Sigil

A library for generating Urbit sigils.

## Usage

Generating sigil images is a one-liner in `UrsusSigil`:

```swift
let sigilImage = Sigil(ship: "~lanrus-rinfep", color: .black).image(with: CGSize(width: 24.0, height: 24.0))
```

Sigils render with a transparent background.

## Installation

Ursus Sigil can be installed using Cocoapods by adding the following line to your podfile:

```ruby
pod 'UrsusSigil', '~> 1.2'
```

I can probably help set up Carthage or Swift Package Manager support if you need it.

## Todo list

Things that would make this codebase nicer:

- [ ] Add SwiftUI `SigilView` component
- [ ] macOS support

## Other utilities

- [sigil-js](https://github.com/urbit/sigil-js)
- [sigil-figma-plugin](https://github.com/urbit/sigil-figma-plugin)

## References

- [Creating Sigils](https://urbit.org/blog/creating-sigils/)
- [Sigil Generator](http://sigil.azimuth.network)
- [urbit.live/explore](https://urbit.live/explore) 

## Dependencies

- [SwiftSVG](https://github.com/mchoe/SwiftSVG)
- [UrsusAtom](https://github.com/dclelland/UrsusAtom)
