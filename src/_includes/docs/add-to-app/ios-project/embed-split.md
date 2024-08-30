### Xcode 및 Flutter 프레임워크의 프레임워크를 podspec으로 사용 {:#method-c .no_toc}

#### 접근법 {:#method-c-approach}

이 방법은 다른 개발자, 머신 또는 연속 통합 시스템에 큰 `Flutter.xcframework`를 배포하는 대신, 
Flutter를 CocoaPods podspec으로 생성합니다. 
Flutter는 여전히 컴파일된 Dart 코드와 각 Flutter 플러그인에 대한 iOS 프레임워크를 생성합니다. 
이러한 프레임워크를 임베드하고 기존 애플리케이션의 빌드 설정을 업데이트합니다.

#### 요구 사항 {:#method-c-reqs}

이 방법에는 추가 소프트웨어 또는 하드웨어 요구 사항이 필요하지 않습니다. 
다음 사용 사례에서 이 방법을 사용하세요.

* 팀원이 Flutter SDK와 CocoaPods를 설치할 수 없는 경우
* 기존 iOS 앱에서 CocoaPods를 종속성 관리자로 사용하고 싶지 않은 경우

#### 제한 사항 {:#method-c-limits}

{% render docs/add-to-app/ios-project/limits-common-deps.md %}

이 방법은 `beta` 또는 `stable` [릴리스 채널][release channels]에서만 작동합니다.

[release channels]: /release/upgrade#switching-flutter-channels

#### 프로젝트 구조 예시 {:#method-c-structure}

{% render docs/add-to-app/ios-project/embed-framework-directory-tree.md %}

#### Podfile에 Flutter 엔진 추가 (Add Flutter engine to your Podfile)

CocoaPods를 사용하는 호스트 앱은 Flutter 엔진을 Podfile에 추가할 수 있습니다.

```ruby title="MyApp/Podfile"
pod 'Flutter', :podspec => '/path/to/MyApp/Flutter/[![build mode]!]/Flutter.podspec'
```

:::note
`[build mode]` 값은 하드 코딩해야 합니다. 
예를 들어, `flutter attach`를 사용해야 하는 경우 `Debug`를 사용하고, 
배송할 준비가 되면 `Release`를 사용합니다.
:::

#### 앱 및 플러그인 프레임워크를 연결하고 임베드 (Link and embed app and plugin frameworks)

{% render docs/add-to-app/ios-project/link-and-embed.md %}
