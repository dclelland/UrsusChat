//
//  SigilView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import SwiftUI
import UrsusAirlock
import UrsusSigil

struct SigilView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var ship: Ship
    
    var color: UIColor
    
    var size: CGSize
    
    init(ship: Ship, color: UIColor = .label, size: CGSize = CGSize(width: 24.0, height: 24.0)) {
        self.ship = ship
        self.color = color
        self.size = size
    }
    
    var body: some View {
        Image(uiImage: Sigil(ship: ship, color: color).image(with: size))
    }
    
}
