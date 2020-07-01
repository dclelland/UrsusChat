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

let appStoreReducer: Reducer<AppState> = { action, state in
    let state = state ?? .login(LoginState(url: "http://192.168.1.78:8080", code: "lacnyd-morped-pilbel-pocnep"))
    switch action {
    case let action as AppAction:
        return appReducer(action, state)
    default:
        return state
    }
}

let appStore = Store<AppState>(reducer: appStoreReducer, state: nil, middleware: [createLoggerMiddleware(), createThunkMiddleware()])

//// MARK: ObservableState
//
//public class ObservableState<T>: ObservableObject where T: StateType {
//
//    // MARK: Public properties
//
//    @Published public var current: T
//
//    // MARK: Private properties
//
//    private var store: Store<T>
//
//    // MARK: Lifecycle
//
//    public init(store: Store<T>) {
//        self.store = store
//        self.current = store.state
//
//        store.subscribe(self)
//    }
//
//    deinit {
//        store.unsubscribe(self)
//    }
//
//    // MARK: Public methods
//
//    public func dispatch(_ action: Action) {
//        store.dispatch(action)
//    }
//
//    public func dispatch(_ action: Action) -> () -> Void {
//        {
//            self.store.dispatch(action)
//        }
//    }
//}
//
//extension ObservableState: StoreSubscriber {
//
//    // MARK: - <StoreSubscriber>
//
//    public func newState(state: T) {
//        DispatchQueue.main.async {
//            self.current = state
//        }
//    }
//}

//extension Store {
//  func dispatch(_ action: AppAction) {
//    dispatch(action as Action)
//  }
//
//  subscript(_ action: AppAction) -> (() -> Void) {
//    { [weak self] in self?.dispatch(action as Action) }
//  }
//}
