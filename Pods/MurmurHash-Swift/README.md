<img src="https://raw.githubusercontent.com/daisuke-t-jp/MurmurHash-Swift/master/images/header.png" width="700"></br>
------
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20Linux-blue.svg)
[![Language Swift%204.2,%205.0](https://img.shields.io/badge/Language-Swift%204.2,%205.0-orange.svg)](https://developer.apple.com/swift)
[![CocoaPods](https://img.shields.io/cocoapods/v/MurmurHash-Swift.svg)](https://cocoapods.org/pods/MurmurHash-Swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-green.svg)](https://github.com/Carthage/Carthage)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-green.svg)](https://github.com/apple/swift-package-manager)
[![Build Status](https://travis-ci.org/daisuke-t-jp/MurmurHash-Swift.svg?branch=master)](https://travis-ci.org/daisuke-t-jp/MurmurHash-Swift)


# Introduction

**MurmurHash** framework in Swift.  
A framework includes MurmurHash3's x86_32/x86_128/x64_128 functions.  
  
[Documentation](https://daisuke-t-jp.github.io/MurmurHash-Swift/)


# Requirements
- Platforms
  - iOS 10.0+
  - macOS 10.12+
  - tvOS 12.0+
  - Linux
- Swift 4.2, 5.0


# Installation
## CocoaPods
```
use_frameworks!

target 'target' do
pod 'MurmurHash-Swift'
end
```

## Carthage
`github "daisuke-t-jp/MurmurHash-Swift"`

## Swift Package Manager
```swift
import PackageDescription

let package = Package(
    name: "YOUR_PACKAGE_NAME",
    targets: [],
    dependencies: [
        // Swift 4.2
        .package(url: "https://github.com/daisuke-t-jp/MurmurHash-Swift.git", .exact("1.0.11"))
        
        // Swift 5.0
        .package(url: "https://github.com/daisuke-t-jp/MurmurHash-Swift.git", from: "1.0.12")
    ]
    targets: [
        .target(
            name: "YOUR_TARGET_NAME",
            dependencies: ["MurmurHash-Swift"]),
	]
)
```


# Usage

## Import framework

```swift
import MurmurHash_Swift
```

## Generate digest(One-shot)
### x86_32
```swift
let digest = MurmurHash3.x86_32.digest("Hello World! Hello World!")
// digest -> 0x0be480fc

// Using seed.
let digest = MurmurHash3.x86_32.digest("Hello World! Hello World!", seed: 0x7fffffff)
// digest -> 0x47fcc800
```

### x86_128
```swift
let digest = MurmurHash3.x86_128.digestHex("Hello World! Hello World!")
// digest -> "86163d2b245b8ee23c4d056024166d77"

// Using seed.
let digest = MurmurHash3.x86_128.digestHex("Hello World! Hello World!", seed: 0x7fffffff)
// digest -> "d1ab28e6f4fc514c5e0df753b015261f"
```

### x64_128
```swift
let digest = MurmurHash3.x64_128.digestHex("Hello World! Hello World!")
// digest -> "e881a28e49269b1e8d0d724eecb72e66"

// Using seed.
let digest = MurmurHash3.x64_128.digestHex("Hello World! Hello World!", seed: 0x7fffffff)
// digest -> "6028586a8c3df476fbd535aec6551aab"
```


## Generate digest(Streaming)
### x86_32
```swift
let mmh = MurmurHash3.x86_32() // if using seed, e.g. "MurmurHash3.x86_32(0x7fffffff)"

let bundle = Bundle(for: type(of: self))
let path = bundle.path(forResource: "alice29", ofType: "txt")!
let data = NSData(contentsOfFile: path)! as Data

let bufSize = 1024
var index = 0

repeat {
    var lastIndex = index + bufSize
    if lastIndex > data.count {
        lastIndex = index + data.count - index
    }

    let data2 = data[index..<lastIndex]
    mmh.update(data2)

    index += data2.count
    if index >= data.count {
        break
    }
} while(true)

let digest = mmh.digest()
// digest -> 0xcae14481
```

### x86_128
```swift
let mmh = MurmurHash3.x86_128() // if using seed, e.g. "MurmurHash3.x86_128(0x7fffffff)"

let bundle = Bundle(for: type(of: self))
let path = bundle.path(forResource: "alice29", ofType: "txt")!
let data = NSData(contentsOfFile: path)! as Data

let bufSize = 1024
var index = 0

repeat {
    var lastIndex = index + bufSize
    if lastIndex > data.count {
        lastIndex = index + data.count - index
    }

    let data2 = data[index..<lastIndex]
    mmh.update(data2)

    index += data2.count
    if index >= data.count {
        break
    }
} while(true)

let digest = mmh.digestHex()
// digest -> "f3d9739244076beaaaa983c7cc4c7251"
```

### x64_128
```swift
let mmh = MurmurHash3.x64_128() // if using seed, e.g. "MurmurHash3.x64_128(0x7fffffff)"

let bundle = Bundle(for: type(of: self))
let path = bundle.path(forResource: "alice29", ofType: "txt")!
let data = NSData(contentsOfFile: path)! as Data

let bufSize = 1024
var index = 0

repeat {
    var lastIndex = index + bufSize
    if lastIndex > data.count {
        lastIndex = index + data.count - index
    }

    let data2 = data[index..<lastIndex]
    mmh.update(data2)

    index += data2.count
    if index >= data.count {
        break
    }
} while(true)

let digest = mmh.digestHex()
// digest -> "ef12617f3e2a5f9a44b3598f2e09cd50"
```


# Demo

There are demos.

- [iOS](https://github.com/daisuke-t-jp/MurmurHash-Swift/tree/master/demo/MurmurHashDemoiOS) 
- [macOS](https://github.com/daisuke-t-jp/MurmurHash-Swift/tree/master/demo/MurmurHashDemoMacOS) 
- [tvOS](https://github.com/daisuke-t-jp/MurmurHash-Swift/tree/master/demo/MurmurHashDemoTvOS) 
