//
//  PatParser.swift
//  Alamofire
//
//  Created by Daniel Clelland on 26/06/20.
//

import Foundation
import Parity

public enum PhoneticBaseParserError: LocalizedError {
    
    case noSyllables(inString: String)
    case invalidPrefix(String, inString: String)
    case invalidSuffix(String, inString: String)
    
    public var errorDescription: String? {
        switch self {
        case .noSyllables:
            return "No phonetic base syllables found"
        case .invalidPrefix:
            return "Invalid phonetic base prefix syllable"
        case .invalidSuffix:
            return "Invalid phonetic base suffix syllable"
        }
    }
    
}

public struct PhoneticBaseParser {

    public enum Spacing {
        
        case long(separator: String = "-")
        case short(separator: String = "-")
        
        internal var separator: String {
            switch self {
            case .long(let separator):
                return separator
            case .short(let separator):
                return separator
            }
        }
        
        internal var longSeparator: String {
            switch self {
            case .long(let separator):
                return separator + separator
            case .short(let separator):
                return separator
            }
        }
        
    }

    public static func parse(_ string: String) throws -> [PhoneticBaseSyllable] {
        let syllables = string.replacingOccurrences(of: "[\\^~-]", with: "", options: .regularExpression).chunked(by: 3)
        guard syllables.isEmpty == false else {
            throw PhoneticBaseParserError.noSyllables(inString: string)
        }
        
        return try syllables.reversed().enumerated().reduce([]) { result, element in
            let (index, syllable) = element
            switch index.parity {
            case .even:
                guard let suffix = PhoneticBaseSyllable.suffix(rawValue: syllable) else {
                    throw PhoneticBaseParserError.invalidSuffix(syllable, inString: string)
                }
                
                return [suffix] + result
            case .odd:
                guard let prefix = PhoneticBaseSyllable.prefix(rawValue: syllable) else {
                    throw PhoneticBaseParserError.invalidPrefix(syllable, inString: string)
                }
                
                return [prefix] + result
            }
        }
    }
    
    public static func render(syllables: [PhoneticBaseSyllable], spacing: Spacing) -> String {
        return syllables.reversed().enumerated().reduce("") { result, element in
            let (index, syllable) = element
            
            let glue: String = {
                guard index.isMultiple(of: 8) == false else {
                    return index == 0 ? "" : spacing.longSeparator
                }
                
                switch index.parity {
                case .even:
                    return spacing.separator
                case .odd:
                    return ""
                }
            }()
            
            return syllable.rawValue + glue + result
        }
    }
    
}
