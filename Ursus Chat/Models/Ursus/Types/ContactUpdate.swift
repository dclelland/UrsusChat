//
//  ContactUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock

enum ContactUpdate: Decodable {
    
    case initial(ContactUpdateInitial)
    case create(ContactUpdateCreate)
    case delete(ContactUpdateDelete)
    case add(ContactUpdateAdd)
    case remove(ContactUpdateRemove)
    case edit(ContactUpdateEdit)
    case contacts(ContactUpdateContacts)
    
    enum CodingKeys: String, CodingKey {
        
        case initial
        case create
        case delete
        case add
        case remove
        case edit
        case contacts
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.initial]:
            self = .initial(try container.decode(ContactUpdateInitial.self, forKey: .initial))
        case [.create]:
            self = .create(try container.decode(ContactUpdateCreate.self, forKey: .create))
        case [.delete]:
            self = .delete(try container.decode(ContactUpdateDelete.self, forKey: .delete))
        case [.add]:
            self = .add(try container.decode(ContactUpdateAdd.self, forKey: .add))
        case [.remove]:
            self = .remove(try container.decode(ContactUpdateRemove.self, forKey: .remove))
        case [.edit]:
            self = .edit(try container.decode(ContactUpdateEdit.self, forKey: .edit))
        case [.contacts]:
            self = .contacts(try container.decode(ContactUpdateContacts.self, forKey: .contacts))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

#warning("TODO: Fix this type; should be Rolodex")

typealias ContactUpdateInitial = [Path: [String: Contact]]

typealias ContactUpdateCreate = Path

typealias ContactUpdateDelete = Path

struct ContactUpdateAdd: Decodable {
    
    var path: Path
    var ship: Ship
    var contact: Contact
    
}

struct ContactUpdateRemove: Decodable {
    
    var path: Path
    var ship: Ship
    
}

struct ContactUpdateEdit: Decodable {
    
    var path: Path
    var ship: Ship
    var editField: ContactEdit
    
    enum CodingKeys: String, CodingKey {
        
        case path
        case ship
        case editField = "edit-field"
        
    }
    
}

struct ContactUpdateContacts: Decodable {
    
    var path: Path
    var contacts: Contacts
    
}

typealias Rolodex = [Path: Contacts]

typealias Contacts = [Ship: Contact]

struct Contact: Decodable {
    
    var nickname: String
    var email: String
    var phone: String
    var website: String
    var notes: String
    var color: String
    var avatar: ContactAvatar?
    
}

typealias ContactAvatar = String

enum ContactEdit: Decodable {
    
    case nickname(String)
    case email(String)
    case phone(String)
    case website(String)
    case notes(String)
    case color(String)
    case avatar(ContactAvatar?)
    
    enum CodingKeys: String, CodingKey {
        
        case nickname
        case email
        case phone
        case website
        case notes
        case color
        case avatar
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.nickname]:
            self = .nickname(try container.decode(String.self, forKey: .nickname))
        case [.email]:
            self = .email(try container.decode(String.self, forKey: .email))
        case [.phone]:
            self = .phone(try container.decode(String.self, forKey: .phone))
        case [.website]:
            self = .website(try container.decode(String.self, forKey: .website))
        case [.notes]:
            self = .notes(try container.decode(String.self, forKey: .notes))
        case [.color]:
            self = .color(try container.decode(String.self, forKey: .color))
        case [.avatar]:
            self = .avatar(try container.decode(ContactAvatar?.self, forKey: .avatar))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}
