# NavigationManager

NavigationManager는 SwiftUI의 `NavigationStack`과 Combine을 활용해 선언적으로 라우팅을 관리할 수 있도록 도와주는 라이브러리입니다. 이 패키지는 iOS 16.0 이상을 타겟으로 하며, 간결하고 확장 가능한 방식으로 앱의 라우팅 상태를 관리할 수 있도록 설계되었습니다.

## 설명

- **Path 관리:**  
  NavigationStack을 활용하여 URL 형태의 Path 관리

- **NavigationRouter 제공:**  
  NavigationRouter를 통해 경로 추가, 뒤로가기, 특정 경로로의 대체(pop & push) 등의 라우팅 동작을 제어

- **경로와 뷰의 매핑:**  
  `RouteEntry`를 사용해 경로 이름과 해당 경로에 연결된 뷰(클로저)를 매핑할 수 있습니다.

- **예정된 업데이트:**  
  Route Guard, Animation 등

## 설치

NavigationManager는 Swift Package Manager(SPM)를 통해 쉽게 설치할 수 있습니다.

1. **Xcode에서 프로젝트 열기:**  
   Xcode 메뉴 **File > Add Package Dependency…**를 선택합니다.

2. **패키지 URL 입력:**  
   아래와 같이 GitHub 리포지토리 URL을 입력합니다.
    https://github.com/Kim-Min-Hyeok/NavigationManager.git

3. **버전 선택:**  
   최신 버전을 선택하고 **Next**를 클릭합니다.

4. **패키지 추가 완료:**  
   설치가 완료되면 프로젝트의 “Swift Package Dependencies” 목록에 NavigationManager가 추가됩니다.

## 사용법

NavigationManager를 사용하면 별도의 NavigationStack을 구성할 필요 없이, 선언적으로 초기 루트와 경로들을 설정할 수 있습니다. 또한, 내부의 NavigationRouter를 환경 객체로 주입하여 각 하위 뷰에서 라우팅 동작(예, 화면 전환, 뒤로 가기 등)을 제어할 수 있습니다.

### 예제 코드

다음은 기본적인 사용 예제입니다.

```swift
import SwiftUI
import NavigationManager

// 홈 화면 예제
struct HomeView: View {
 @EnvironmentObject var router: NavigationRouter
 
 var body: some View {
     VStack(spacing: 20) {
         Text("홈 화면")
             .font(.largeTitle)
         
         // 상세 화면으로 이동
         Button("상세 화면으로 이동") {
             router.toNamed("/detail")
         }
     }
     .padding()
 }
}

// 상세 화면 예제
struct DetailView: View {
 @EnvironmentObject var router: NavigationRouter
 
 var body: some View {
     VStack(spacing: 20) {
         Text("상세 화면")
             .font(.largeTitle)
         
         // 뒤로 가기
         Button("뒤로 가기") {
             router.back()
         }
     }
     .padding()
 }
}

// ContentView에 NavigationManager 사용
struct ContentView: View {
 var body: some View {
     NavigationManager(
         initialRoute: "/",
         routes: [
             RouteEntry(name: "/") { _ in HomeView() },
             RouteEntry(name: "/detail") { _ in DetailView() }
         ]
     )
 }
}
