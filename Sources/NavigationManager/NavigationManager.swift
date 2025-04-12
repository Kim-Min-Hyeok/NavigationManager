// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Combine

/// Combine과 NavigationStack을 활용한 라우팅 상태 관리 클래스
/// iOS 13.0 이상에서만 사용 가능
@available(iOS 16.0, *)
public struct NavigationManager: View {
    private let initialRoute: String
    private let routes: [RouteEntry]
    
    // MARK: 에러 관련
    private let unknownRouteHandler: UnknownRouteHandler
    
    @StateObject private var router = NavigationRouter()
    
    // 배포용 (내부 router 사용)
    public init(initialRoute: String,
                routes: [RouteEntry],
                unknownRouteHandler: UnknownRouteHandler = DefaultUnknownRouteHandler(),
                transitionAnimation: Animation? = .default) {
        self.initialRoute = initialRoute
        self.routes = routes
        self.unknownRouteHandler = unknownRouteHandler
        _router = StateObject(wrappedValue: NavigationRouter(animation: transitionAnimation))
    }
    
    // 테스트용 (외부 router 주입)
    public init(initialRoute: String,
                routes: [RouteEntry],
                router: NavigationRouter,
                unknownRouteHandler: UnknownRouteHandler = DefaultUnknownRouteHandler()) {
        self.initialRoute = initialRoute
        self.routes = routes
        self.unknownRouteHandler = unknownRouteHandler
        _router = StateObject(wrappedValue: router)
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            // 초기 화면을 표시 (initialRoute)
            view(for: initialRoute)
                .navigationDestination(for: Route.self) { route in
                    // 해당 경로에 등록된 뷰 반환, 없는 경우 에러 메시지 뷰 표시
                    view(for: route.name, arguments: route.arguments)
                }
        }
        .environmentObject(router)
        .onAppear {
            // 초기 루트로 설정
            router.offAll(initialRoute)
        }
    }
    
    @ViewBuilder
    internal func view(for routeName: String, arguments: AnyHashable? = nil) -> some View {
        if let entry = routes.first(where: { $0.name == routeName }) {
            entry.viewBuilder(arguments)
        } else {
            unknownRouteHandler.handleUnknownRoute(for: routeName)
        }
    }
}


