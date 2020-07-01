//
//  AppStore.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 29/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftThunk

typealias StateReducer<ReducerAction: Action, ReducerStateType: StateType> = (_ action: ReducerAction, _ state: ReducerStateType) -> ReducerStateType

let appStoreReducer: Reducer<AppState> = { action, state in
    switch (action, state) {
    case (let action as AppAction, .some(let state)):
        return appReducer(action, state)
    default:
        fatalError("State not initialized")
    }
}

let appStore = Store<AppState>(
    reducer: appStoreReducer,
    state: .login(LoginState(url: "http://192.168.1.78:8080", code: "lacnyd-morped-pilbel-pocnep")),
    middleware: [
        createLoggerMiddleware(),
        createThunkMiddleware()
    ]
)

class ObservableState<State: StateType>: ObservableObject {
    
    @Published var state: State
    
    private var store: Store<State>
    
    init(store: Store<State>) {
        self.store = store
        self.state = store.state
        store.subscribe(self)
    }
    
    deinit {
        store.unsubscribe(self)
    }
    
}

extension ObservableState {
    
    func dispatch(_ action: Action) {
        store.dispatch(action)
    }

    subscript(_ action: Action) -> () -> Void {
        return { [weak self] in
            self?.store.dispatch(action)
        }
    }
    
}

extension ObservableState: StoreSubscriber {
    
    func newState(state: State) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
    
}
