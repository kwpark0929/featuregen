//
//  LoginView.swift
//  {{PROJECT_NAME}}
//
//  Created by {{keunwoo.park}} on {{2025.07.12}}
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: LoginReducer.self)
struct LoginView: View {
    @Bindable var store: StoreOf<LoginReducer>
    
    // 바인딩 안쓸때
    // let store: StoreOf<LoginReducer>

    var body: some View {
        HStack {
            Button {
                send(.decrementButtonTapped)
            } label: {
                Image(systemName: "minus")
            }
            
            Text("\(store.count)")
                .monospacedDigit()
            
            Button {
                send(.incrementButtonTapped)
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView(
            store: Store(initialState: LoginState()) {
                LoginReducer()
            }
        )
    }
}
