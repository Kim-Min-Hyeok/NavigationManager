import XCTest
@testable import NavigationManager
import SwiftUI

@MainActor
@available(iOS 16.0, *)
final class NavigationManagerTests: XCTestCase {
    
    // NavigationRouter 단위 테스트
    func testNavigationRouterFunctions() async throws {
        let router = NavigationRouter()
        
        // toNamed 테스트
        router.toNamed("/home")
        XCTAssertEqual(router.path.count, 1)
        XCTAssertEqual(router.path.last?.name, "/home")
        
        // back 테스트
        router.toNamed("/detail")
        XCTAssertEqual(router.path.count, 2)
        router.back()
        XCTAssertEqual(router.path.count, 1)
        XCTAssertEqual(router.path.last?.name, "/home")
        
        // offNamed 테스트
        router.toNamed("/detail")
        router.offNamed("/profile")
        XCTAssertEqual(router.path.count, 2)
        XCTAssertEqual(router.path.last?.name, "/profile")
        
        // offAll 테스트
        router.toNamed("/detail")
        router.offAll("/login")
        XCTAssertEqual(router.path.count, 1)
        XCTAssertEqual(router.path.last?.name, "/login")
    }
    
    // NavigationManager 통합 테스트
    func testInitialRouteOnAppear() async throws {
        let testRouter = NavigationRouter()
        
        let navManager = NavigationManager(
            initialRoute: "/",
            routes: [
                RouteEntry(name: "/") { _ in Text("Home View") },
                RouteEntry(name: "/detail") { _ in Text("Detail View") }
            ],
            router: testRouter
        )
        
        let hostingController = UIHostingController(rootView: navManager)
        _ = hostingController.view
        
        hostingController.beginAppearanceTransition(true, animated: false)
        hostingController.endAppearanceTransition()
        
        let expectation = XCTestExpectation(description: "onAppear triggered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0, enforceOrder: false)
        
        XCTAssertEqual(testRouter.path.count, 1)
        XCTAssertEqual(testRouter.path.first?.name, "/")
    }
}
