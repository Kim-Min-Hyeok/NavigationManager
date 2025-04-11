//
//  RouteEntry.swift
//  NavigationManager
//
//  Created by Minhyeok Kim on 4/11/25.
//

import SwiftUI
import Combine

/// 각 경로에 대한 정보를 담는 구조체
@available(iOS 16.0, *)
public struct RouteEntry {
    public let name: String
    /// 사용자가 지정한 뷰 클로저. 인자가 필요한 경우 AnyHashable?를 전달받아 사용할 수 있음
    public let viewBuilder: (AnyHashable?) -> AnyView

    public init<V: View>(name: String, view: @escaping (AnyHashable?) -> V) {
        self.name = name
        self.viewBuilder = { arguments in AnyView(view(arguments)) }
    }
}
