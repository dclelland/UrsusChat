//
//  ContactUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Ursus

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

typealias ContactUpdateInitial = Rolodex

typealias ContactUpdateCreate = String

typealias ContactUpdateDelete = String

struct ContactUpdateAdd: Decodable {
    
    var path: String
    var ship: PatP
    var contact: Contact
    
}

struct ContactUpdateRemove: Decodable {
    
    var path: String
    var ship: PatP
    
}

struct ContactUpdateEdit: Decodable {
    
    var path: String
    var ship: PatP
    var editField: ContactEdit
    
}

struct ContactUpdateContacts: Decodable {
    
    var path: String
    var contacts: Contacts
    
}

typealias Rolodex = [String: Contacts]

typealias Contacts = [PatP: Contact]

struct Contact: Decodable {
    
    var nickname: String
    var email: String
    var phone: String
    var website: String
    var notes: String
    var color: String
    var avatar: ContactAvatar?
    
}

enum ContactAvatar: Decodable {
    
    enum CodingKeys: String, CodingKey {
        
        case url
        case octs
        
    }
    
    case url(ContactAvatarURL)
    case octs(ContactAvatarOcts)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.url]:
            self = .url(try container.decode(ContactAvatarURL.self, forKey: .url))
        case [.octs]:
            self = .octs(try container.decode(ContactAvatarOcts.self, forKey: .octs))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

typealias ContactAvatarURL = URL

typealias ContactAvatarOcts = String

enum ContactEdit: Decodable {
    
    enum CodingKeys: String, CodingKey {
        
        case nickname
        case email
        case phone
        case website
        case notes
        case color
        case avatar
        
    }
    
    case nickname(String)
    case email(String)
    case phone(String)
    case website(String)
    case notes(String)
    case color(String)
    case avatar(ContactAvatar?)
    
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
