//
//  SigilView.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 18/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import UrsusAirlock
import UrsusSigil

struct SigilView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var ship: Ship
    
    var color: UIColor
    
    init(ship: Ship, color: UIColor = .label, size: CGSize = CGSize(width: 24.0, height: 24.0)) {
        self.ship = ship
        self.color = color
    }
    
    var body: some View {
        GeometryReader { geometry in
            Image(uiImage: Sigil(ship: self.ship, color: self.color).image(with: geometry.size, titles: Ship.allTitles))
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
    
}
