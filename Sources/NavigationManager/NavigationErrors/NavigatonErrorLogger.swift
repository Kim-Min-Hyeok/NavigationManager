//
//  NavigatonErrorLogger.swift
//  NavigationManager
//
//  Created by Minhyeok Kim on 4/12/25.
//

import SwiftUI

/// 로그 관련 protocol
public protocol NavigationErrorLogger {
    /// 에러 로깅 함수
    func logError(_ error: NavigationError)
}

/// 기본 에러 로깅 struct
public struct DefaultNavigationErrorLogger: NavigationErrorLogger {
    public init() {}
    
    public func logError(_ error: NavigationError) {
        print("🚨Navigation Error: \(error.description)")
    }
}
