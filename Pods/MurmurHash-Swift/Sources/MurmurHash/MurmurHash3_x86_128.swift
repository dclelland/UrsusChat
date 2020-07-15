//
//  MurmurHash3_x86_128.swift
//  MurmurHash
//
//  Created by Daisuke T on 2019/03/04.
//  Copyright © 2019 MurmurHash. All rights reserved.
//

import Foundation

extension MurmurHash3 {
	
	/// MurmurHash3 x86_128 class
	public class x86_128 {

		// MARK: - Enum, Const
		static private let c1: UInt32 = 0x239b961b
		static private let c2: UInt32 = 0xab0e9789
		static private let c3: UInt32 = 0x38b34ae5
		static private let c4: UInt32 = 0xa1e38b93


		// MARK: - Property
		private let endian = Common.endian()
		private var state = State()
		public var seed: UInt32 {
			didSet {
				reset()
			}
		}


		// MARK: - Life cycle

		/// Creates a new instance with the seed.
		///
		/// - Parameter seed: A seed for generate digest. Default is 0.
		public init(_ seed: UInt32 = 0) {
			self.seed = seed
			reset()
		}

	}
}



// MARK: - State
extension MurmurHash3.x86_128 {
	private struct State {
		var totalLen: Int = 0
		var mem = [UInt8](repeating: 0, count: 15)
		var memSize: Int = 0
		var tail = MurmurHash3Tail(15)
		var h = [UInt32](repeating: 0, count: 4)
	}
}



// MARK: - Utility
extension MurmurHash3.x86_128 {

	static private func body(_ h: [UInt32], array: [UInt8]) -> [UInt32] {
		let nblocks = array.count / 16
		var h1: UInt32 = h[0]
		var h2: UInt32 = h[1]
		var h3: UInt32 = h[2]
		var h4: UInt32 = h[3]

		for i in 0..<nblocks {
			
			var k1: UInt32 = Common.UInt8ArrayToUInt(array, index: i * 4, endian: Common.endian())
			var k2: UInt32 = Common.UInt8ArrayToUInt(array, index: i * 4 + 1, endian: Common.endian())
			var k3: UInt32 = Common.UInt8ArrayToUInt(array, index: i * 4 + 2, endian: Common.endian())
			var k4: UInt32 = Common.UInt8ArrayToUInt(array, index: i * 4 + 3, endian: Common.endian())
			
			k1 &*= c1
			k1 = Common.rotl(k1, r: 15)
			k1 &*= c2
			h1 ^= k1
			
			h1 = Common.rotl(h1, r: 19)
			h1 &+= h2
			h1 = h1 &* 5 &+ 0x561ccd1b
			
			k2 &*= c2
			k2 = Common.rotl(k2, r: 16)
			k2 &*= c3
			h2 ^= k2
			
			h2 = Common.rotl(h2, r: 17)
			h2 &+= h3
			h2 = h2 &* 5 &+ 0x0bcaa747
			
			k3 &*= c3
			k3 = Common.rotl(k3, r: 17)
			k3 &*= c4
			h3 ^= k3
			
			h3 = Common.rotl(h3, r: 15)
			h3 &+= h4
			h3 = h3 &* 5 &+ 0x96cd1c35
			
			k4 &*= c4
			k4 = Common.rotl(k4, r: 18)
			k4 &*= c1
			h4 ^= k4
			
			h4 = Common.rotl(h4, r: 13)
			h4 &+= h1
			h4 = h4 &* 5 &+ 0x32ac3b17
		}
		
		return [h1, h2, h3, h4]
	}

	static private func tailAndFinalize(_ h: [UInt32], tail: [UInt8], len: Int) -> [UInt32] {
		var k1: UInt32 = 0
		var k2: UInt32 = 0
		var k3: UInt32 = 0
		var k4: UInt32 = 0
		var h1: UInt32 = h[0]
		var h2: UInt32 = h[1]
		var h3: UInt32 = h[2]
		var h4: UInt32 = h[3]

		/**
		 * tail
		 */
		switch len & 15 {
		case 15:
			k4 ^= UInt32(tail[14]) << 16
			fallthrough

		case 14:
			k4 ^= UInt32(tail[13]) << 8
			fallthrough

		case 13:
			k4 ^= UInt32(tail[12]) << 0
			k4 &*= c4
			k4 = Common.rotl(k4, r: 18)
			k4 &*= c1
			h4 ^= k4
			fallthrough


		case 12:
			k3 ^= UInt32(tail[11]) << 24
			fallthrough

		case 11:
			k3 ^= UInt32(tail[10]) << 16
			fallthrough

		case 10:
			k3 ^= UInt32(tail[9]) << 8
			fallthrough

		case 9:
			k3 ^= UInt32(tail[8]) << 0
			k3 &*= c3
			k3 = Common.rotl(k3, r: 17)
			k3 &*= c4
			h3 ^= k3
			fallthrough


		case 8:
			k2 ^= UInt32(tail[7]) << 24
			fallthrough

		case 7:
			k2 ^= UInt32(tail[6]) << 16
			fallthrough

		case 6:
			k2 ^= UInt32(tail[5]) << 8
			fallthrough

		case 5:
			k2 ^= UInt32(tail[4]) << 0
			k2 &*= c2
			k2 = Common.rotl(k2, r: 16)
			k2 &*= c3
			h2 ^= k2
			fallthrough


		case 4:
			k1 ^= UInt32(tail[3]) << 24
			fallthrough

		case 3:
			k1 ^= UInt32(tail[2]) << 16
			fallthrough

		case 2:
			k1 ^= UInt32(tail[1]) << 8
			fallthrough

		case 1:
			k1 ^= UInt32(tail[0]) << 0
			k1 &*= c1
			k1 = Common.rotl(k1, r: 15)
			k1 &*= c2
			h1 ^= k1

		default:
			break
		}


		/**
		 * finalization
		 */
		h1 ^= UInt32(len)
		h2 ^= UInt32(len)
		h3 ^= UInt32(len)
		h4 ^= UInt32(len)

		h1 &+= h2
		h1 &+= h3
		h1 &+= h4
		h2 &+= h1
		h3 &+= h1
		h4 &+= h1

		h1 = Common.fmix32(h1)
		h2 = Common.fmix32(h2)
		h3 = Common.fmix32(h3)
		h4 = Common.fmix32(h4)

		h1 &+= h2
		h1 &+= h3
		h1 &+= h4
		h2 &+= h1
		h3 &+= h1
		h4 &+= h1

		return [h1, h2, h3, h4]
	}

}



// MARK: - Digest(One-shot)
extension MurmurHash3.x86_128 {
	
	/// Generate digest(One-shot)
	///
	/// - Parameters:
	///   - array: A source data for hash.
	///   - seed: A seed for generate digest. Default is 0.
	/// - Returns: An array of generated digest.
	static public func digest(_ array: [UInt8], seed: UInt32 = 0) -> [UInt32] {
		
		/**
		 * body
		 */
		var h = body([UInt32](repeating: seed, count: 4), array: array)
		
		
		
		/**
		 * tail and finalize
		 */
		let nblocks = array.count / 16
		let tail = MurmurHash3Tail(15)
		for i in 0..<array.count % 16 {
			tail.add(array[nblocks * 16 + i])
		}
		
		h = tailAndFinalize(h, tail: tail.rawArray(), len: array.count)
		
		return h
	}
	
	/// Overload func for "digest(_ array: [UInt8], seed: UInt32 = 0)".
	static public func digest(_ string: String, seed: UInt32 = 0) -> [UInt32] {
		return digest(Array(string.utf8), seed: seed)
	}
	
	/// Overload func for "digest(_ array: [UInt8], seed: UInt32 = 0)".
	static public func digest(_ data: Data, seed: UInt32 = 0) -> [UInt32] {
		return digest([UInt8](data), seed: seed)
	}
	
	
	/// Generate digest's hex string(One-shot)
	///
	/// - Parameters:
	///   - array: A source data for hash.
	///   - seed: A seed for generate digest. Default is 0.
	/// - Returns: A generated digest's hex string.
	static public func digestHex(_ array: [UInt8], seed: UInt32 = 0) -> String {
		let h = digest(array, seed: seed)
		return Common.UInt32ArrayToHex(h)
	}
	
	/// Overload func for "digestHex(_ array: [UInt8], seed: UInt32 = 0)".
	static public func digestHex(_ string: String, seed: UInt32 = 0) -> String {
		let h = digest(string, seed: seed)
		return Common.UInt32ArrayToHex(h)
	}
	
	/// Overload func for "digestHex(_ array: [UInt8], seed: UInt32 = 0)".
	static public func digestHex(_ data: Data, seed: UInt32 = 0) -> String {
		let h = digest(data, seed: seed)
		return Common.UInt32ArrayToHex(h)
	}
	
}



// MARK: - Digest(Streaming)
extension MurmurHash3.x86_128 {

	/// Reset current streaming state to initial.
	public func reset() {
		state = MurmurHash3.x86_128.State()
		state.h = [UInt32](repeating: self.seed, count: 4)
	}
	
	/// Update streaming state.
	///
	/// - Parameter array: A source data for hash.
	public func update(_ array: [UInt8]) {
		let len = array.count
		state.totalLen += len
		
		if state.memSize + len < 16 {
			// fill in tmp buffer
			state.mem.replaceSubrange(state.memSize..<state.memSize + len, with: array)
			state.memSize += len
			
			for i in 0..<len {
				state.tail.add(array[i])
			}
			
			return
		}
		
		let array2 = Array(state.mem[0..<state.memSize]) + array
		
		
		/**
		 * body
		 */
		state.h = MurmurHash3.x86_128.body(state.h, array: array2)
		
		
		// fill in tmp buffer
		state.memSize = array2.count % 16
		state.mem.replaceSubrange(0..<state.memSize,
								  with: array2[array2.count - state.memSize..<array2.count])
		
		for i in 0..<15 {
			state.tail.add(array2[array2.count - (15 - i)])
		}
	}
	
	/// Overload func for "update(_ array: [UInt8])".
	public func update(_ string: String) {
		return update(Array(string.utf8))
	}
	
	/// Overload func for "update(_ array: [UInt8])".
	public func update(_ data: Data) {
		return update([UInt8](data))
	}
	
	
	
	/// Generate digest(Streaming)
	///
	/// - Returns: A generated digest from current streaming state.
	public func digest() -> [UInt32] {
		/**
		 * tail and finalize
		 */
		var tail2 = Array(state.tail.rawArray())
		tail2.removeFirst(tail2.count - state.totalLen % 16)
		
		let h = MurmurHash3.x86_128.tailAndFinalize(state.h,
													tail: tail2,
													len: state.totalLen)
		
		return h
	}
	
	
	/// Generate digest's hex string(Streaming)
	///
	/// - Returns: A generated digest's hex string from current streaming state.
	public func digestHex() -> String {
		let h = digest()
		return Common.UInt32ArrayToHex(h)
	}
	
}
