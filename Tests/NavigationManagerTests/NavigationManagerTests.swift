import XCTest
@testable import NavigationManager
import SwiftUI

@MainActor
@available(iOS 16.0, *)
final class NavigationManagerTests: XCTestCase {
    
    // MARK: - 에러 관련 테스트
    
    // 1. 커스텀 뷰 반환 여부를 확인하기 위한 Mock UnknownRouteHandler
    final class MockUnknownRouteHandler: UnknownRouteHandler {
        var handledRouteName: String?
        var customView: AnyView
        
        init(customView: AnyView) {
            self.customView = customView
        }
        
        func handleUnknownRoute(for routeName: String) -> AnyView {
            handledRouteName = routeName
            return customView
        }
    }
    
    // 2. 에러 로그가 정상적으로 기록되는지 확인하기 위한 Mock NavigationErrorLogger
    final class MockNavigationErrorLogger: NavigationErrorLogger {
        var loggedError: NavigationError?
        func logError(_ error: NavigationError) {
            loggedError = error
        }
    }
    
    /// 커스텀 UnknownRouteHandler를 통해 알 수 없는 경로 호출 시 지정한 커스텀 뷰가 반환되는지 테스트합니다.
    func testCustomUnknownRouteView() async throws {
        // Arrange: 커스텀 뷰 반환하는 MockUnknownRouteHandler 생성
        let expectedText = "Custom Unknown Route: /unknown"
        let customView = AnyView(Text(expectedText))
        let mockHandler = MockUnknownRouteHandler(customView: customView)
        
        // 테스트용 NavigationRouter 생성 (애니메이션은 무시)
        let testRouter = NavigationRouter(animation: nil)
        
        // NavigationManager 생성 시 커스텀 에러 핸들러로 mockHandler를 주입
        let navManager = NavigationManager(
            initialRoute: "/home",
            routes: [RouteEntry(name: "/home") { _ in Text("Home View") }],
            router: testRouter,
            unknownRouteHandler: mockHandler
        )
        
        // Act: 알 수 없는 경로("/unknown")에 대한 뷰를 요청
        _ = navManager.view(for: "/unknown")
        
        // Assert: mockHandler에 올바른 경로가 전달되었는지 확인
        XCTAssertEqual(mockHandler.handledRouteName, "/unknown")
    }
    
    /// DefaultUnknownRouteHandler를 사용했을 때, 디폴트 뷰가 반환되고 에러 로그가 기록되는지 테스트합니다.
    func testDefaultUnknownRouteViewAndErrorLog() async throws {
        // Arrange: Mock logger를 이용해 기본 핸들러의 에러 로깅을 검증
        let mockLogger = MockNavigationErrorLogger()
        let defaultHandler = DefaultUnknownRouteHandler(errorLogger: mockLogger)
        let testRouter = NavigationRouter(animation: nil)
        
        let navManager = NavigationManager(
            initialRoute: "/home",
            routes: [RouteEntry(name: "/home") { _ in Text("Home View") }],
            router: testRouter,
            unknownRouteHandler: defaultHandler
        )
        
        // Act: 존재하지 않는 경로("/notExist") 호출
        _ = navManager.view(for: "/notExist")
        
        // Assert: 모의 에러 로그가 기록되었는지 확인
        XCTAssertNotNil(mockLogger.loggedError)
        if case .unknownRouteError(let routeName) = mockLogger.loggedError! {
            XCTAssertEqual(routeName, "/notExist")
        } else {
            XCTFail("Logged error is not unknownRouteError")
        }
    }
    
    // MARK: - 애니메이션 관련 테스트
    
    /// NavigationRouter 생성 시 기본 애니메이션(.default)이 설정되는지 테스트합니다.
    func testDefaultTransitionAnimation() async throws {
        // Arrange: 애니메이션 인자를 생략하면 기본 애니메이션(.default)이 할당됨
        let router = NavigationRouter()
        // Assert: defaultTransitionAnimation이 nil이 아니며 Animation.default와 동일한지 확인
        XCTAssertNotNil(router.defaultTransitionAnimation)
        XCTAssertEqual(router.defaultTransitionAnimation?.debugDescription, Animation.default.debugDescription)
    }
    
    /// 커스텀 애니메이션을 지정한 후, 각 라우터 함수(toNamed, back, offNamed, offAll) 호출 시 상태 변경이 올바르게 이루어지는지 테스트합니다.
    func testCustomTransitionAnimationAndRouterFunctions() async throws {
        // Arrange: 커스텀 애니메이션 지정 (.easeInOut(duration: 0.5))
        let customAnimation: Animation = .easeInOut(duration: 0.5)
        let router = NavigationRouter(animation: customAnimation)
        
        // Assert: customAnimation이 router의 defaultTransitionAnimation에 할당되었는지 확인
        XCTAssertEqual(router.defaultTransitionAnimation?.debugDescription, customAnimation.debugDescription)
        
        // Act & Assert: 각 라우팅 함수 호출 후 상태 변경 검증
        
        // toNamed 테스트: 새로운 경로 push
        router.toNamed("/customTest")
        XCTAssertEqual(router.path.count, 1)
        XCTAssertEqual(router.path.first?.name, "/customTest")
        
        // 두 번째 경로 push
        router.toNamed("/secondTest")
        XCTAssertEqual(router.path.count, 2)
        XCTAssertEqual(router.path.last?.name, "/secondTest")
        
        // back 테스트: 마지막 경로 pop
        router.back()
        XCTAssertEqual(router.path.count, 1)
        XCTAssertEqual(router.path.first?.name, "/customTest")
        
        // offNamed 테스트: 현재 경로 대체
        router.offNamed("/replaceTest")
        XCTAssertEqual(router.path.count, 1)
        XCTAssertEqual(router.path.first?.name, "/replaceTest")
        
        // offAll 테스트: 전체 스택 초기화 후 새 경로 push
        router.toNamed("/anotherRoute")
        XCTAssertEqual(router.path.count, 2)
        router.offAll("/allTest")
        XCTAssertEqual(router.path.count, 1)
        XCTAssertEqual(router.path.first?.name, "/allTest")
    }
}
