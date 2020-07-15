//
//  MurmurHash3_x64_128.swift
//  MurmurHash
//
//  Created by Daisuke T on 2019/03/04.
//  Copyright © 2019 MurmurHash. All rights reserved.
//

import Foundation

extension MurmurHash3 {
	
	/// MurmurHash3 x64_128 class
	public class x64_128 {
		
		// MARK: - Enum, Const
		static private let c1: UInt64 = 0x87c37b91114253d5
		static private let c2: UInt64 = 0x4cf5ad432745937f
		
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
extension MurmurHash3.x64_128 {
	private struct State {
		var totalLen: Int = 0
		var mem = [UInt8](repeating: 0, count: 15)
		var memSize: Int = 0
		var tail = MurmurHash3Tail(15)
		var h = [UInt64](repeating: 0, count: 2)
	}
}



// MARK: - Utility
extension MurmurHash3.x64_128 {
	
	static private func body(_ h: [UInt64], array: [UInt8]) -> [UInt64] {
		let nblocks = array.count / 16
		var h1: UInt64 = h[0]
		var h2: UInt64 = h[1]
		
		for i in 0..<nblocks {
			
			var k1: UInt64 = Common.UInt8ArrayToUInt(array, index: i * 2 + 0, endian: Common.endian())
			var k2: UInt64 = Common.UInt8ArrayToUInt(array, index: i * 2 + 1, endian: Common.endian())

			k1 &*= c1
			k1 = Common.rotl(k1, r: 31)
			k1 &*= c2
			h1 ^= k1
			
			h1 = Common.rotl(h1, r: 27)
			h1 &+= h2
			h1 = h1 &* 5 &+ 0x52dce729
			
			k2 &*= c2
			k2 = Common.rotl(k2, r: 33)
			k2 &*= c1
			h2 ^= k2
			
			h2 = Common.rotl(h2, r: 31)
			h2 &+= h1
			h2 = h2 &* 5 &+ 0x38495ab5
		}
		
		return [h1, h2]
	}
	
	static private func tailAndFinalize(_ h: [UInt64], tail: [UInt8], len: Int) -> [UInt64] {
		var k1: UInt64 = 0
		var k2: UInt64 = 0
		var h1: UInt64 = h[0]
		var h2: UInt64 = h[1]
		
		/**
		 * tail
		 */
		switch len & 15 {
		case 15:
			k2 ^= UInt64(tail[14]) << 48
			fallthrough
			
		case 14:
			k2 ^= UInt64(tail[13]) << 40
			fallthrough
			
		case 13:
			k2 ^= UInt64(tail[12]) << 32
			fallthrough
			
		case 12:
			k2 ^= UInt64(tail[11]) << 24
			fallthrough
			
		case 11:
			k2 ^= UInt64(tail[10]) << 16
			fallthrough
			
		case 10:
			k2 ^= UInt64(tail[9]) << 8
			fallthrough
			
		case 9:
			k2 ^= UInt64(tail[8]) << 0
			k2 &*= c2
			k2 = Common.rotl(k2, r: 33)
			k2 &*= c1
			h2 ^= k2
			fallthrough
			
			
		case 8:
			k1 ^= UInt64(tail[7]) << 56
			fallthrough
			
		case 7:
			k1 ^= UInt64(tail[6]) << 48
			fallthrough
			
		case 6:
			k1 ^= UInt64(tail[5]) << 40
			fallthrough
			
		case 5:
			k1 ^= UInt64(tail[4]) << 32
			fallthrough
			
		case 4:
			k1 ^= UInt64(tail[3]) << 24
			fallthrough
			
		case 3:
			k1 ^= UInt64(tail[2]) << 16
			fallthrough
			
		case 2:
			k1 ^= UInt64(tail[1]) << 8
			fallthrough
			
		case 1:
			k1 ^= UInt64(tail[0]) << 0
			k1 &*= c1
			k1 = Common.rotl(k1, r: 31)
			k1 &*= c2
			h1 ^= k1
			
		default:
			break
		}
		
		
		/**
		 * finalization
		 */
		h1 ^= UInt64(len)
		h2 ^= UInt64(len)
		
		h1 &+= h2
		h2 &+= h1
		
		h1 = Common.fmix64(h1)
		h2 = Common.fmix64(h2)
		
		h1 &+= h2
		h2 &+= h1
		
		return [h1, h2]
	}
	
}



// MARK: - Digest(One-shot)
extension MurmurHash3.x64_128 {
	
	/// Generate digest(One-shot)
	///
	/// - Parameters:
	///   - array: A source data for hash.
	///   - seed: A seed for generate digest. Default is 0.
	/// - Returns: An array of generated digest.
	static public func digest(_ array: [UInt8], seed: UInt32 = 0) -> [UInt64] {
		
		/**
		 * body
		 */
		var h = body([UInt64](repeating: UInt64(seed), count: 2), array: array)
		
		
		
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
	static public func digest(_ string: String, seed: UInt32 = 0) -> [UInt64] {
		return digest(Array(string.utf8), seed: seed)
	}
	
	/// Overload func for "digest(_ array: [UInt8], seed: UInt32 = 0)".
	static public func digest(_ data: Data, seed: UInt32 = 0) -> [UInt64] {
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
		return Common.UInt64ArrayToHex(h)
	}
	
	/// Overload func for "digestHex(_ array: [UInt8], seed: UInt32 = 0)".
	static public func digestHex(_ string: String, seed: UInt32 = 0) -> String {
		let h = digest(string, seed: seed)
		return Common.UInt64ArrayToHex(h)
	}
	
	/// Overload func for "digestHex(_ array: [UInt8], seed: UInt32 = 0)".
	static public func digestHex(_ data: Data, seed: UInt32 = 0) -> String {
		let h = digest(data, seed: seed)
		return Common.UInt64ArrayToHex(h)
	}
	
}



// MARK: - Digest(Streaming)
extension MurmurHash3.x64_128 {
	
	/// Reset current streaming state to initial.
	public func reset() {
		state = MurmurHash3.x64_128.State()
		state.h = [UInt64](repeating: UInt64(self.seed), count: 2)
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
		state.h = MurmurHash3.x64_128.body(state.h, array: array2)
		
		
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
	public func digest() -> [UInt64] {
		/**
		 * tail and finalize
		 */
		var tail2 = Array(state.tail.rawArray())
		tail2.removeFirst(tail2.count - state.totalLen % 16)
		
		let h = MurmurHash3.x64_128.tailAndFinalize(state.h,
													tail: tail2,
													len: state.totalLen)
		
		return h
	}
	
	
	/// Generate digest's hex string(Streaming)
	///
	/// - Returns: A generated digest's hex string from current streaming state.
	public func digestHex() -> String {
		let h = digest()
		return Common.UInt64ArrayToHex(h)
	}
	
}
