//
//  ChatViewRow.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 3/08/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import SwiftUI
import NonEmpty

enum ChatViewRowModel: Hashable, Identifiable {
    
    case loadingIndicator(loading: Bool)
    case readIndicator(unread: Int)
    case dateIndicator(date: Date)
    case envelopes(viewModel: NonEmpty<[ChatEnvelopesRowModel]>)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .loadingIndicator(let loading):
            hasher.combine("loadingIndicator")
            hasher.combine(loading)
        case .readIndicator(let unread):
            hasher.combine("readIndicator")
            hasher.combine(unread)
        case .dateIndicator(let date):
            hasher.combine("dateIndicator")
            hasher.combine(date)
        case .envelopes(let viewModel):
            hasher.combine("envelopes")
            hasher.combine(viewModel)
        }
    }
    
    var id: Int {
        return hashValue
    }
    
}

struct ChatViewRow: View {
    
    var viewModel: ChatViewRowModel
    
    var body: some View {
        switch viewModel {
        case .loadingIndicator(let loading):
            return AnyView(
                ChatLoadingIndicatorRow(loading: loading)
            )
        case .readIndicator(let unread):
            return AnyView(
                ChatReadIndicatorRow(unread: unread)
            )
        case .dateIndicator(let date):
            return AnyView(
                ChatDateIndicatorRow(date: date)
            )
        case .envelopes(let viewModel):
            return AnyView(
                ChatEnvelopesRow(viewModel: viewModel)
            )
        }
    }
    
}
