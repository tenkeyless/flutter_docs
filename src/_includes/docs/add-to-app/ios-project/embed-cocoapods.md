### CocoaPods와 Flutter SDK 사용 {:#method-a .no_toc}

#### 접근법 {:#method-a-approach}

이 첫 번째 방법은 CocoaPods를 사용하여, Flutter 모듈을 임베드합니다. 
CocoaPods는 Flutter 코드와 플러그인을 포함하여 Swift 프로젝트의 종속성을 관리합니다. 
Xcode가 앱을 빌드할 때마다, CocoaPods는 Flutter 모듈을 임베드합니다.

이렇게 하면 Xcode 외부에서 추가 명령을 실행하지 않고도, 
최신 버전의 Flutter 모듈로 빠르게 반복할 수 있습니다.

CocoaPods에 대해 자세히 알아보려면 [CocoaPods 시작 가이드][CocoaPods getting started guide]를 참조하세요.

#### 비디오 보기 {:#watch-the-video}

비디오를 시청하여 학습하는 데 도움이 된다면, 이 비디오에서는 iOS 앱에 Flutter를 추가하는 방법을 다룹니다.

{% ytEmbed 'IIcrfrTshTs', '기존 iOS 앱에 Flutter를 추가하는 방법에 대한 단계별 설명' %}

#### 요구 사항 {:#method-a-reqs}

프로젝트에 참여하는 모든 개발자는 Flutter SDK와 CocoaPods의 로컬 버전을 설치해야 합니다.

#### 프로젝트 구조 예시 {:#method-a-structure}

이 섹션에서는 기존 앱과 Flutter 모듈이 형제 디렉토리에 있다고 가정합니다. 
디렉토리 구조가 다른 경우, 상대 경로를 조정합니다. 
예제 디렉토리 구조는 다음과 유사합니다.

```plaintext
/path/to/MyApp
├── my_flutter/
│   └── .ios/
│       └── Flutter/
│         └── podhelper.rb
└── MyApp/
    └── Podfile
```

#### Podfile 업데이트 {:#update-your-podfile}

Flutter 모듈을 Podfile 구성 파일에 추가합니다. 
이 섹션에서는 Swift 앱을 `MyApp`이라고 부른다고 가정합니다.

1. _(선택 사항)_ 기존 앱에 `Podfile` 구성 파일이 없는 경우, 앱 디렉토리의 루트로 이동합니다. 
   `pod init` 명령을 사용하여 `Podfile` 파일을 만듭니다.

   :::warning
   CocoaPods(1.15.2 버전 기준)는 Xcode 16을 지원하지 않습니다. 
   `pod init` 명령 오류가 발생하면 Xcode 15 이하 버전을 사용하여 Xcode 프로젝트를 다시 만드는 것을 고려하세요.

   CocoaPods 문제에 대해 자세히 알아보려면, [CocoaPods#12456](https://github.com/CocoaPods/CocoaPods/issues/12456)을 확인하세요.
   :::

2. `Podfile` 구성 파일을 업데이트합니다.

   1. `platform` 선언 뒤에 다음 줄을 추가합니다.

      ```ruby title="MyApp/Podfile"
      flutter_application_path = '../my_flutter'
      load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
      ```

   2. Flutter를 임베드해야 하는 각 [Podfile target][]에 대해, 
      `install_all_flutter_pods(flutter_application_path)` 메서드에 호출을 추가합니다. 
      이전 단계의 설정 뒤에 이러한 호출을 추가합니다.

      ```ruby title="MyApp/Podfile"
      target 'MyApp' do
        install_all_flutter_pods(flutter_application_path)
      end
      ```

   3. `Podfile`의 `post_install` 블록에서, 
      `flutter_post_install(installer)`에 대한 호출을 추가합니다. 
      이 블록은 `Podfile` 구성 파일의 마지막 블록이어야 합니다.

      ```ruby title="MyApp/Podfile"
      post_install do |installer|
        flutter_post_install(installer) if defined?(flutter_post_install)
      end
      ```

`Podfile` 예제를 검토하려면 이 [Flutter Podfile 샘플][Flutter Podfile sample]을 참조하세요.

#### 프레임워크 임베드 {:#embed-your-frameworks}

빌드 시, Xcode는 Dart 코드, 각 Flutter 플러그인, Flutter 엔진을 자체 `*.xcframework` 번들로 패키징합니다. 
그런 다음 CocoaPod의 `podhelper.rb` 스크립트가 이러한 `*.xcframework` 번들을 프로젝트에 임베드합니다.

* `Flutter.xcframework`에는 Flutter 엔진이 포함됩니다.
* `App.xcframework`에는 이 프로젝트에 대한 컴파일된 Dart 코드가 포함됩니다.
* `<plugin>.xcframework`에는 하나의 Flutter 플러그인이 포함됩니다.

Flutter 엔진, Dart 코드, Flutter 플러그인을 iOS 앱에 임베드하려면, 다음 절차를 완료하세요.

1. Flutter 플러그인을 새로 고칩니다.

   `pubspec.yaml` 파일에서 Flutter 종속성을 변경하는 경우, 
   Flutter 모듈 디렉토리에서 `flutter pub get`을 실행합니다. 
   이렇게 하면 `podhelper.rb` 스크립트가 읽는 플러그인 리스트가 새로 고침됩니다.

   ```console
   flutter pub get
   ```

2. CocoaPods로 플러그인과 프레임워크를 임베드합니다.

   1. `/path/to/MyApp/MyApp`에서 iOS 앱 프로젝트로 이동합니다.

   2. `pod install` 명령을 사용합니다.

      ```console
      pod install
      ```

   iOS 앱의 **Debug** 및 **Release** 빌드 구성에는, 
   해당 [빌드 모드에 대한 Flutter 구성 요소][build-modes]가 포함됩니다.

3. 프로젝트를 빌드합니다.

   1. Xcode에서 `MyApp.xcworkspace`를 엽니다.

      `MyApp.xcworkspace`를 열고, `MyApp.xcodeproj`를 열지 않는지 확인합니다. 
      `.xcworkspace` 파일에는 CocoaPod 종속성이 있지만, `.xcodeproj`에는 없습니다.

   2. **Product** > **Build**를 선택하거나, <kbd>Cmd</kbd> + <kbd>B</kbd>를 누릅니다.

[build-modes]: /testing/build-modes
[CocoaPods getting started guide]: https://guides.cocoapods.org/using/using-cocoapods.html
[Podfile target]: https://guides.cocoapods.org/syntax/podfile.html#target
[Flutter Podfile sample]: https://github.com/flutter/samples/blob/main/add_to_app/plugin/ios_using_plugin/Podfile
