//
//  Route.swift
//  NavigationManager
//
//  Created by Minhyeok Kim on 4/11/25.
//

import Foundation

/// URL 경로와 인자(선택적)를 저장하는 모델
/// iOS 13.0 이상에서만 사용 가능
@available(iOS 16.0, *)
public struct Route: Hashable {
    let name: String
    let arguments: AnyHashable? // String key/value 형식
    
    public init(name: String, arguments: AnyHashable? = nil) {
        self.name = name
        self.arguments = arguments
    }
}
