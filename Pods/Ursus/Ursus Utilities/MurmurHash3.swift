// https://en.wikipedia.org/wiki/MurmurHash#MurmurHash3
// Based on https://github.com/antlr/antlr4/blob/master/runtime/Swift/Sources/Antlr4/misc/MurmurHash.swift
// Originally written by Sam Harwell

internal struct MurmurHash3 {

    internal static func hash(bytes: [UInt8], seed: UInt32) -> UInt32 {
        let byteCount = bytes.count
        var hash = seed

        for i in stride(from: 0, to: byteCount - 3, by: 4) {
            var word = UInt32(bytes[i])
            word |= UInt32(bytes[i + 1]) << 8
            word |= UInt32(bytes[i + 2]) << 16
            word |= UInt32(bytes[i + 3]) << 24

            hash = updateInternal(hash, word)
        }

        let remaining = byteCount & 3

        if remaining != 0 {
            var lastWord = UInt32(0)
            for r in 0 ..< remaining {
                lastWord |= UInt32(bytes[byteCount - 1 - r]) << (8 * (remaining - 1 - r))
            }

            let k = calcK(lastWord)
            hash ^= k
        }

        return finish(hash, byteCount: byteCount)
    }
    
}

extension MurmurHash3 {
    
    private static let c1 = UInt32(0xCC9E2D51)
    private static let c2 = UInt32(0x1B873593)
    private static let r1 = UInt32(15)
    private static let r2 = UInt32(13)
    private static let m = UInt32(5)
    private static let n = UInt32(0xE6546B64)

    private static let finish1 = UInt32(0x85EBCA6B)
    private static let finish2 = UInt32(0xC2B2AE35)

    private static func calcK(_ value: UInt32) -> UInt32 {
        var k = value
        k = k &* c1
        k = (k << r1) | (k >> (32 - r1))
        k = k &* c2
        return k
    }

    private static func updateInternal(_ hashIn: UInt32, _ value: UInt32) -> UInt32 {
        let k = calcK(value)
        var hash = hashIn
        hash = hash ^ k
        hash = (hash << r2) | (hash >> (32 - r2))
        hash = hash &* m &+ n
        return hash
    }

    private static func finish(_ hashin: UInt32, byteCount byteCountInt: Int) -> UInt32 {
        let byteCount = UInt32(truncatingIfNeeded: byteCountInt)
        var hash = hashin
        hash ^= byteCount
        hash ^= (hash >> 16)
        hash = hash &* finish1
        hash ^= (hash >> 13)
        hash = hash &* finish2
        hash ^= (hash >> 16)
        return hash
    }
    
}
