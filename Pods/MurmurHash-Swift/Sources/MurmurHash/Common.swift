//
//  Common.swift
//  MurmurHash
//
//  Created by Daisuke T on 2019/03/04.
//  Copyright © 2019 MurmurHash. All rights reserved.
//

import Foundation
import CoreFoundation

final class Common {

	// MARK: - Enum, Const
	enum Endian {
		case little
		case big
	}
	
}



// MARK: - Utility
extension Common {
	
	static func endian() -> Endian {
		if CFByteOrderGetCurrent() == Int(CFByteOrderLittleEndian.rawValue) {
			return Endian.little
		}
		
		return Endian.big
	}
	
	
	static func rotl<T: FixedWidthInteger>(_ x: T, r: Int) -> T {
		return (x << r) | (x >> (T.bitWidth - r))
	}
	
}



// MARK: - Utility(Swap)
extension Common {
	
	static func swap<T: FixedWidthInteger>(_ x: T) -> T {
		var res: T = 0
		var mask: T = 0xff
		var bit = 0
		
		bit = (MemoryLayout<T>.size - 1) * 8
		for _ in 0..<MemoryLayout<T>.size / 2 {
			res |= (x & mask) << bit
			mask = mask << 8
			bit -= 16
		}
		
		bit = 8
		for _ in 0..<MemoryLayout<T>.size / 2 {
			res |= (x & mask) >> bit
			mask = mask << 8
			bit += 16
		}
		
		return res
	}
	
}



// MARK: - Utility(Convert)
extension Common {

	static private func UInt8ArrayToUInt<T: FixedWidthInteger>(_ array: [UInt8], index: Int) -> T {
		var block: T = 0
		
		for i in 0..<MemoryLayout<T>.size {
			block |= T(array[index * MemoryLayout<T>.size + i]) << (i * 8)
		}
		
		return block
	}
	
	static func UInt8ArrayToUInt<T: FixedWidthInteger>(_ array: [UInt8], index: Int, endian: Common.Endian) -> T {
		var block: T = UInt8ArrayToUInt(array, index: index)
		
		if endian == Common.Endian.little {
			return block
		}
		
		
		// Big Endian
		block = swap(block)
		
		return block
	}

	
	static func UInt32ArrayToHex(_ array: [UInt32]) -> String {
		var hex = ""
		for val in array {
			hex += String.init(format: "%08x", val)
		}
		return hex
	}
	
	static func UInt64ArrayToHex(_ array: [UInt64]) -> String {
		var hex = ""
		for val in array {
			hex += String.init(format: "%016lx", val)
		}
		return hex
	}
	
}



// MARK: - Utility(Mix)
extension Common {
	
	static func fmix32(_ h: UInt32) -> UInt32 {
		var h2 = h
		
		h2 ^= h2 >> 16
		h2 &*= 0x85ebca6b
		h2 ^= h2 >> 13
		h2 &*= 0xc2b2ae35
		h2 ^= h2 >> 16
		
		return h2
	}
	
	static func fmix64(_ k: UInt64) -> UInt64 {
		var k2 = k
		
		k2 ^= k2 >> 33
		k2 &*= 0xff51afd7ed558ccd
		k2 ^= k2 >> 33
		k2 &*= 0xc4ceb9fe1a85ec53
		k2 ^= k2 >> 33
		
		return k2
	}
	
}
