//
//  LoginReducer.swift
//  {{PROJECT_NAME}}
//
//  Created by {{keunwoo.park}} on {{2025.07.12}}
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct LoginReducer {
    
    var body: some Reducer<LoginState, LoginAction> {
        BindingReducer() // 바인딩 액션은 여기서 처리
        
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none
                
            case .view(.decrementButtonTapped):
                state.count -= 1
                return .none
                
            case .view(.incrementButtonTapped):
                state.count += 1
                return .none
                
            default:
                return .none
            }
        }
    }
    
}
