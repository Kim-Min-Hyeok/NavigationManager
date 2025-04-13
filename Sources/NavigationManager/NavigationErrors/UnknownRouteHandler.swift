//
//  UnknownRouteHandler.swift
//  NavigationManager
//
//  Created by Minhyeok Kim on 4/12/25.
//

import SwiftUI

/// 알 수 없는 경로 상황에서 보여줄 뷰를 제공하기 위한 프로토콜
public protocol UnknownRouteHandler {
    //// 알 수 없는 경로일 때 호출되어 뷰를 반환
    func handleUnknownRoute(for routeName: String) -> AnyView
}

public struct CustomUnknownRouteHandler: UnknownRouteHandler {
    let customView: AnyView
    private let errorLogger: NavigationErrorLogger
    
    public init(customView: AnyView, errorLogger: NavigationErrorLogger = DefaultNavigationErrorLogger()) {
        self.errorLogger = errorLogger
        self.customView = customView
    }
    
    public func handleUnknownRoute(for routeName: String) -> AnyView {
        let error = NavigationError.unknownRouteError(routeName)
        errorLogger.logError(error)
        return customView
    }
}

/// 기본 구현체: 에러 로그를 기록한 후 단순 텍스트 뷰 반환
public struct DefaultUnknownRouteHandler: UnknownRouteHandler {
    private let errorLogger: NavigationErrorLogger
    
    public init(errorLogger: NavigationErrorLogger = DefaultNavigationErrorLogger()) {
        self.errorLogger = errorLogger
    }
    
    public func handleUnknownRoute(for routeName: String) -> AnyView {
        let error = NavigationError.unknownRouteError(routeName)
        errorLogger.logError(error)
        return AnyView(Text("Unknown route encountered: \(routeName)"))
    }
}
