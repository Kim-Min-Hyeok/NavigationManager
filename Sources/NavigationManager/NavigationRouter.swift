//
//  NavigationRouter.swift
//  NavigationManager
//
//  Created by Minhyeok Kim on 4/11/25.
//

import SwiftUI
import Combine

/// Combine과 NavigationStack을 활용한 라우팅 상태 관리 클래스
/// iOS 13.0 이상에서만 사용 가능
@available(iOS 16.0, *)
public final class NavigationRouter: ObservableObject {
    /// NavigationStack에서 관리할 경로 배열
    @Published public var path: [Route] = []
    
    /// 애니메이션 관련
//    public var defaultTransitionAnimation: Animation?
    
    public init(/*animation: Animation? = .default*/) {
//        self.defaultTransitionAnimation = animation
    }
    
    /// 해당 경로로 이동 (push)
    public func toNamed(_ route: String, arguments: AnyHashable? = nil/*, animation: Animation? = nil*/) {
        let newRoute = Route(name: route, arguments: arguments)
//        withAnimation(animation ?? defaultTransitionAnimation) {
            path.append(newRoute)
//        }
    }
    
    /// 뒤로가기 (pop)
    public func back(/*animation: Animation? = nil*/) {
//        withAnimation(animation ?? defaultTransitionAnimation) {
            _ = path.popLast()
//        }
    }
    
    /// 현재 화면을 제거하고 해당 경로로 이동 (replace)
    public func offNamed(_ route: String, arguments: AnyHashable? = nil/*, animation: Animation? = nil*/) {
//        withAnimation(animation ?? defaultTransitionAnimation) {
            if !path.isEmpty { _ = path.popLast() }
            path.append(Route(name: route, arguments: arguments))
//        }
    }
    
    /// 전체 스택을 비우고 해당 경로를 새 루트로 설정
    public func offAll(_ route: String, arguments: AnyHashable? = nil/*, animation: Animation? = nil*/) {
//        withAnimation(animation ?? defaultTransitionAnimation) {
            path.removeAll()
            path.append(Route(name: route, arguments: arguments))
//        }
    }
}


