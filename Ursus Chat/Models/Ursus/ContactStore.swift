//
//  ContactStore.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import Alamofire
import Ursus

class ContactStore: UrsusApp {
    
    typealias Rolodex = [String: Contacts]
    
    typealias Contacts = [String: Contact]
    
    struct Contact: Decodable {
        
        var nickname: String
        var email: String
        var phone: String
        var website: String
        var notes: String
        var color: String
        var avatar: URL?
        
    }
    
    struct ContactUpdate: Decodable {
        
        #warning("Implement decoder for ContactStore.ContactUpdate")
        
    }
    
}
