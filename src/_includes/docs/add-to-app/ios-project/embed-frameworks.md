### Xcode에서 프레임워크 연결 및 임베드 {:#method-b .no_toc}

#### 접근법 {:#method-b-approach}

두 번째 방법에서는, 기존 Xcode 프로젝트를 편집하고, 필요한 프레임워크를 생성한 다음 앱에 임베드합니다. 
Flutter는 Flutter 자체, 컴파일된 Dart 코드 및 각 Flutter 플러그인에 대한 iOS 프레임워크를 생성합니다. 
이러한 프레임워크를 임베드하고 기존 애플리케이션의 빌드 설정을 업데이트합니다.

#### 요구 사항 {:#method-b-reqs}

이 방법에는 추가 소프트웨어 또는 하드웨어 요구 사항이 필요하지 않습니다. 
다음 사용 사례에서 이 방법을 사용하세요.

* 팀원이 Flutter SDK와 CocoaPods를 설치할 수 없는 경우
* 기존 iOS 앱에서 CocoaPods를 종속성 관리자로 사용하고 싶지 않은 경우

#### 제한 사항 {:#method-b-limits}

{% render docs/add-to-app/ios-project/limits-common-deps.md %}

#### 프로젝트 구조 예시 {:#method-b-structure}

{% render docs/add-to-app/ios-project/embed-framework-directory-tree.md %}

#### 절차

생성된 프레임워크를 Xcode에서 기존 앱에 연결, 임베드 또는 둘 다 하는 방법은, 
프레임워크 타입에 따라 달라집니다.

* 동적 프레임워크를 연결하고 임베드합니다.
* 정적 프레임워크를 연결합니다. [절대 임베드하지 마세요][static-framework].

{% render docs/add-to-app/ios-project/link-and-embed.md %}

[static-framework]: https://developer.apple.com/library/archive/technotes/tn2435/_index.html
