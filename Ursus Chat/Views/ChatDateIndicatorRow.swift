//
//  ChatDateIndicatorRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 3/08/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI

struct ChatDateIndicatorRow: View {
    
    var date: Date
    
    var body: some View {
        Text(date.formattedDateWithToday)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
}
