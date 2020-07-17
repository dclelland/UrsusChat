//
//  Event.swift
//  EventSource
//
//  Created by Andres on 01/06/2019.
//  Copyright © 2019 inaka. All rights reserved.
//

import Foundation

public struct EventSourceMessage {
    
    public var event: String?
    public var id: String?
    public var data: String?
    public var retry: String?
    
    internal init?(parsing string: String) {
        let fields = string.components(separatedBy: "\n").compactMap(EventSourceMessageField.init(parsing:))
        for field in fields {
            switch field.key {
            case .event:
                self.event = self.event.map { $0 + "\n" + field.value } ?? field.value
            case .id:
                self.id = self.id.map { $0 + "\n" + field.value } ?? field.value
            case .data:
                self.data = self.data.map { $0 + "\n" + field.value } ?? field.value
            case .retry:
                self.retry = self.retry.map { $0 + "\n" + field.value } ?? field.value
            }
        }
    }

}
