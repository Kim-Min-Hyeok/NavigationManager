//
//  NavigationError.swift
//  NavigationManager
//
//  Created by Minhyeok Kim on 4/12/25.
//

import Foundation

/// 네비게이션 관련 에러 관리 enum
public enum NavigationError: Error, CustomStringConvertible {
    case unknownRouteError(String)
    
    public var description: String {
        switch self {
        case .unknownRouteError(let routeName):
            return "🚨Error: Unknown route encountered: \(routeName)"
        }
    }
}
