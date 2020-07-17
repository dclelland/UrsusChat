//
//  EventSourceParser.swift
//  EventSource
//
//  Created by Andres on 30/05/2019.
//  Copyright © 2019 inaka. All rights reserved.
//

import Foundation

internal class EventSourceParser {
    
    private let delimiter: Data = "\n\n".data(using: .utf8)!
    
    private var buffer = Data()

    internal func append(data: Data) -> [EventSourceMessage] {
        buffer.append(data)
        return extractMessagesFromBuffer().compactMap(EventSourceMessage.init(parsing:))
    }
    
}

extension EventSourceParser {

    private func extractMessagesFromBuffer() -> [String] {
        var messages = [String]()
        var searchRange: Range<Data.Index> = buffer.startIndex..<buffer.endIndex
        
        while let delimiterRange = buffer.range(of: delimiter, in: searchRange) {
            let subdata = buffer.subdata(in: searchRange.startIndex..<delimiterRange.endIndex)

            if let message = String(bytes: subdata, encoding: .utf8) {
                messages.append(message)
            }

            searchRange = delimiterRange.endIndex..<buffer.endIndex
        }

        buffer.removeSubrange(buffer.startIndex..<searchRange.startIndex)

        return messages
    }
    
}
