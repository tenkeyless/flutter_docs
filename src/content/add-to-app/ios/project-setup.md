---
# title: Integrate a Flutter module into your iOS project
title: iOS 프로젝트에 Flutter 모듈 통합
# short-title: Integrate Flutter
short-title: Flutter 통합
# description: Learn how to integrate a Flutter module into your existing iOS project.
description: 기존 iOS 프로젝트에 Flutter 모듈을 통합하는 방법을 알아보세요.
---

Flutter UI 구성 요소는 기존 iOS 애플리케이션에 임베디드 프레임워크로 점진적으로 추가할 수 있습니다. 
기존 애플리케이션에 Flutter를 임베디드하려면 다음 세 가지 방법 중 하나를 고려하세요.

| 임베딩 방법 | 방법론 | 이익 |
|---|---|---|
| CocoaPods 사용 _(권장됨)_ | Flutter SDK와 CocoaPods를 설치하고 사용합니다. Flutter는 Xcode가 iOS 앱을 빌드할 때마다 소스에서 `flutter_module`을 컴파일합니다. | 앱에 Flutter를 내장하는 가장 간단한 방법입니다. |
| [iOS frameworks][] 사용 | Flutter 구성 요소용 iOS 프레임워크를 만들고, 이를 iOS에 내장하고, 기존 앱의 빌드 설정을 업데이트합니다. | 모든 개발자가 로컬 머신에 Flutter SDK와 CocoaPods를 설치할 필요는 없습니다. |
| iOS frameworks 및 CocoaPods 사용 | iOS 앱과 플러그인을 Xcode에 내장하고, Flutter 엔진은 CocoaPods podspec으로 배포합니다. | 대규모 Flutter 엔진(`Flutter.xcframework`) 라이브러리를 배포하는 것에 대한 대안을 제공합니다. |

{:.table .table-striped}

[iOS frameworks]: {{site.apple-dev}}/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WhatAreFrameworks.html

기존 iOS 앱에 Flutter를 추가하면, [iOS 앱의 크기][app-size]가 증가합니다.

UIKit으로 빌드된 앱을 사용하는 예는 [add_to_app 코드 샘플][add_to_app code samples]의 iOS 디렉토리를 참조하세요. 
SwiftUI를 사용하는 예는 [뉴스 피드 앱][News Feed App]의 iOS 디렉토리를 참조하세요.

## 개발 시스템 요구 사항 {:#development-system-requirements}

개발 환경은 [Xcode가 설치된][Xcode installed] [Flutter용 macOS 시스템 요구 사항][macOS system requirements for Flutter]을 충족해야 합니다. 
Flutter는 Xcode {{site.appmin.xcode}} 이상 및 [CocoaPods][] {{site.appmin.cocoapods}} 이상을 지원합니다.

## Flutter 모듈 생성 {:#create-a-flutter-module}

기존 애플리케이션에 모든 메서드로 Flutter를 임베드하려면 먼저 Flutter 모듈을 만듭니다. 
다음 명령을 사용하여 Flutter 모듈을 만듭니다.

```console
$ cd /path/to/my_flutter
$ flutter create --template module my_flutter
```

Flutter는 `/path/to/my_flutter/` 아래에 모듈 프로젝트를 생성합니다. 
[CocoaPods 메서드][CocoaPods method]를 사용하는 경우, 기존 iOS 앱과 동일한 부모 디렉토리에 모듈을 저장합니다.

[CocoaPods method]: /add-to-app/ios/project-setup/?tab=embed-using-cocoapods

Flutter 모듈 디렉토리에서, 다른 Flutter 프로젝트에서와 같은 `flutter` 명령(예: `flutter run` 또는 `flutter build ios`)을 실행할 수 있습니다. 
Flutter 및 Dart 플러그인을 사용하여 [VS Code][] 또는 [Android Studio/IntelliJ][]에서 모듈을 실행할 수도 있습니다. 
이 프로젝트에는 기존 iOS 앱에 임베드하기 전에 모듈의 단일 뷰 예제 버전이 포함되어 있습니다. 
이는 코드의 Flutter 전용 부분을 테스트할 때 도움이 됩니다.

## 모듈을 구성하세요 {:#organize-your-module}

`my_flutter` 모듈 디렉토리 구조는 일반적인 Flutter 앱과 비슷합니다.

```plaintext
my_flutter/
├── .ios/
│   ├── Runner.xcworkspace
│   └── Flutter/podhelper.rb
├── lib/
│   └── main.dart
├── test/
└── pubspec.yaml
```

Dart 코드는 `lib/` 디렉토리에 추가해야 합니다. 
Flutter 종속성, 패키지 및 플러그인은 `pubspec.yaml` 파일에 추가해야 합니다.

`.ios/` 숨겨진 하위 폴더에는 모듈의 독립 실행형 버전을 실행할 수 있는 Xcode workspace가 있습니다. 
이 래퍼 프로젝트는 Flutter 코드를 부트스트랩합니다. 
프레임워크를 빌드하거나, CocoaPods로 기존 애플리케이션에 모듈을 임베드하는 것을 용이하게 하는, 
도우미 스크립트가 포함되어 있습니다.

:::note

* 커스텀 iOS 코드를 모듈의 `.ios/` 디렉토리가 아닌 기존 애플리케이션 프로젝트나 플러그인에 추가하세요. 
  모듈의 `.ios/` 디렉토리에서 변경한 내용은 모듈을 사용하는 기존 iOS 프로젝트에 나타나지 않으며,
  Flutter에서 덮어쓸 수 있습니다.

* `.ios/` 디렉토리는 자동 생성되므로 소스 제어에서 제외하세요.

* 새 컴퓨터에서 모듈을 빌드하기 전에, 
  `my_flutter` 디렉토리에서 `flutter pub get`을 실행하세요. 
  이렇게 하면 Flutter 모듈을 사용하는 iOS 프로젝트를 빌드하기 전에, 
  `.ios/` 디렉토리가 다시 생성됩니다.

:::

## iOS 앱에 Flutter 모듈 임베드 {:#embed-a-flutter-module-in-your-ios-app}

Flutter 모듈을 개발한 후, 페이지 상단의 표에 설명된 방법을 사용하여 모듈을 임베드할 수 있습니다.

시뮬레이터나 실제 기기에서 **Debug** 모드로 실행하고, 
실제 기기에서 **Release** 모드로 실행할 수 있습니다.

:::note
[Flutter의 빌드 모드][build modes of Flutter]에 대해 자세히 알아보세요.

핫 리로드와 같은 Flutter 디버깅 기능을 사용하려면, [앱 추가(add-to-app) 모듈 디버깅][Debugging your add-to-app module]을 참조하세요.
:::

{% tabs %}
{% tab "CocoaPods 사용" %}

{% render docs/add-to-app/ios-project/embed-cocoapods.md %}

{% endtab %}
{% tab "프레임워크 사용" %}

{% render docs/add-to-app/ios-project/embed-frameworks.md %}

{% endtab %}
{% tab "프레임워크 및 CocoaPods 사용" %}

{% render docs/add-to-app/ios-project/embed-split.md %}

{% endtab %}
{% endtabs %}


## 로컬 네트워크 개인 정보 보호 권한 설정 {:#set-local-network-privacy-permissions}

iOS 14 이상에서는 iOS 앱의 **Debug** 버전에서 Dart 멀티캐스트 DNS 서비스를 활성화합니다. 
이렇게 하면 `flutter attach`를 사용하여, [핫 리로드 및 DevTools와 같은 디버깅 기능][debugging functionalities such as hot-reload and DevTools]이 추가됩니다.

:::warning
앱의 **Release** 버전에서 이 서비스를 활성화하지 마십시오. 
Apple 앱 스토어에서 앱을 거부할 수 있습니다.
:::

앱의 디버그 버전에서만 로컬 네트워크 개인 정보 보호 권한을 설정하려면, 
빌드 구성당 별도의 `Info.plist`를 만듭니다. 
SwiftUI 프로젝트는 `Info.plist` 파일 없이 시작합니다. 
속성 리스트를 만들어야 하는 경우, Xcode 또는 텍스트 편집기를 통해 만들 수 있습니다. 
다음 지침에서는 기본 **Debug** 및 **Release**를 가정합니다. 
앱의 빌드 구성에 따라 필요에 따라 이름을 조정합니다.

1. 새 속성 리스트를 만듭니다.

   1. Xcode에서 프로젝트를 엽니다.

   2. **Project Navigator**에서 프로젝트 이름을 클릭합니다.

   3. 편집기 창의 **Targets** 목록에서 앱을 클릭합니다.

   4. **Info** 탭을 클릭합니다.

   5. **Custom iOS Target Properties**를 확장합니다.

   6. 리스트를 마우스 오른쪽 버튼으로 클릭하고 **Add Row**를 선택합니다.

   7. 드롭다운 메뉴에서 **Bonjour Services**를 선택합니다. 
      그러면 프로젝트 디렉토리에 `Info`라는 새 속성 리스트가 생성됩니다. 
      Finder에서는 `Info.plist`로 표시됩니다.

2. `Info.plist`의 이름을 `Info-Debug.plist`로 변경합니다.

   1. 왼쪽의 프로젝트 목록에서 **Info** 파일을 클릭합니다.

   2. 오른쪽의 **Identity and Type** 패널에서, 
      **Name**을 `Info.plist`에서 `Info-Debug.plist`로 변경합니다.

3. Release property 리스트를 만듭니다.

   1. **Project Navigator**에서 `Info-Debug.plist`를 클릭합니다.

   2. **File** > **Duplicate...** 를 선택합니다. 
      <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd>를 누를 수도 있습니다.

   3. 대화 상자에서 **Save As:** 필드를 `Info-Release.plist`로 설정하고, 
      **Save**을 클릭합니다.

4. **Debug** 속성 리스트에 필요한 속성을 추가합니다.

   1. **Project Navigator**에서, `Info-Debug.plist`를 클릭합니다.

   2. String 값 `_dartVmService._tcp`를 **Bonjour Services** 배열에 추가합니다.

   3. _(선택 사항)_ 원하는 커스터마이즈된 권한 대화 상자 텍스트를 설정하려면, 
      **Privacy - Local Network Usage Description** 키를 추가합니다.

      {% render docs/captioned-image.liquid,
      image:"development/add-to-app/ios/project-setup/debug-plist.png",
      caption:"**Bonjour Services** 및 **Privacy - Local Network Usage Description** 키가 추가된 `Info-Debug` 속성 리스트" %}

5. 다른 빌드 모드에 대해 다른 속성 리스트를 사용하도록 대상을 설정합니다.

   1. **Project Navigator**에서, 프로젝트를 클릭합니다.

   2. **Build Settings** 탭을 클릭합니다.

   3. **All** 및 **Combined** 하위 탭을 클릭합니다.

   4. 검색 상자에 `plist`를 입력합니다. 
      이렇게 하면 속성 리스트가 포함된 설정으로 제한됩니다.

   5. **Packaging**이 보일 때까지 리스트를 스크롤합니다.

   6. **Info.plist File** 설정을 클릭합니다.

   7. **Info.plist File** 값을 `path/to/Info.plist`에서, 
      `path/to/Info-$(CONFIGURATION).plist`로 변경합니다.

      {%- render docs/captioned-image.liquid,
      image:"development/add-to-app/ios/project-setup/set-plist-build-setting.png",
      caption:"빌드 모드별 속성 리스트를 사용하도록 `Info.plist` 빌드 설정 업데이트" %}

      이는 **Debug**의 **Info-Debug.plist** 경로와, 
      **Release**의 **Info-Release.plist** 경로로 확인됩니다.

      {% render docs/captioned-image.liquid,
      image:"development/add-to-app/ios/project-setup/plist-build-setting.png",
      caption:"구성 변형을 표시하는 업데이트된 **Info.plist File** 빌드 설정" %}

6. **Build Phases**에서 **Release** 속성 리스트를 제거합니다.

   1. **Project Navigator**에서, 프로젝트를 클릭합니다.

   2. **Build Phases** 탭을 클릭합니다.

   3. **Copy Bundle Resources**를 확장합니다.

   4. 이 목록에 `Info-Release.plist`가 포함되어 있으면, 
      클릭한 다음 그 아래에 있는 **-**(빼기 기호)를 클릭하여, 리소스 목록에서 속성 리스트를 제거합니다.

      {% render docs/captioned-image.liquid,
      image:"development/add-to-app/ios/project-setup/copy-bundle.png",
      caption:"**Info-Release.plist** 설정을 표시하는 **Copy Bundle** 빌드 단계. 이 설정을 제거합니다." %}

7. 디버그 앱이 로드하는 첫 번째 Flutter 화면에서 로컬 네트워크 권한을 묻습니다.

   **OK**를 클릭합니다.

   _(선택 사항)_ 앱이 로드되기 전에 권한을 부여하려면, 
   **Settings > Privacy > Local Network > Your App**을 활성화합니다.

## Apple Silicon Mac의 알려진 문제 완화 {:#mitigate-known-issue-with-apple-silicon-macs}

[Apple Silicon을 실행하는 Mac][apple-silicon]에서, 
호스트 앱은 `arm64` 시뮬레이터를 빌드합니다. 
Flutter는 `arm64` 시뮬레이터를 지원하지만, 일부 플러그인은 지원하지 않을 수 있습니다. 
이러한 플러그인 중 하나를 사용하는 경우, 
**Undefined symbols for architecture arm64**과 같은 컴파일 오류가 표시될 수 있습니다. 
이 경우 호스트 앱의 시뮬레이터 아키텍처에서 `arm64`를 제외합니다.

1. **Project Navigator**에서 프로젝트를 클릭합니다.

1. **Build Settings** 탭을 클릭합니다.

1. **All** 및 **Combined** 하위 탭을 클릭합니다.

1. **Architectures**에서 **Excluded Architectures**를 클릭합니다.

1. 확장하여 사용 가능한 빌드 구성을 확인합니다.

1. **Debug**를 클릭합니다.

1. **+**(더하기 기호)를 클릭합니다.

1. **iOS Simulator**를 선택합니다.

1. **Any iOS Simulator SDK**의 값 열을 두 번 클릭합니다.

1. **+** (더하기 기호)를 클릭합니다.

1. **Debug > Any iOS Simulator SDK** 대화 상자에 `arm64`를 입력합니다.

   {% render docs/captioned-image.liquid,
   image:"development/add-to-app/ios/project-setup/excluded-archs.png",
   caption:"앱의 제외 아키텍처로 `arm64`를 추가합니다." %}  

2. <kbd>Esc</kbd>를 눌러 이 대화 상자를 닫습니다.

3. **Release** 빌드 모드에 대해 이 단계를 반복합니다.

4. 모든 iOS 유닛 테스트 대상에 대해 반복합니다.

## 다음 단계 {:#next-steps}

이제 기존 iOS 앱에 [Flutter 화면을 추가][add a Flutter screen]할 수 있습니다.

[add_to_app code samples]: {{site.repo.samples}}/tree/main/add_to_app
[add a Flutter screen]: /add-to-app/ios/add-flutter-screen
[Android Studio/IntelliJ]: /tools/android-studio
[build modes of Flutter]: /testing/build-modes
[CocoaPods]: https://cocoapods.org/
[debugging functionalities such as hot-reload and DevTools]: /add-to-app/debugging
[app-size]: /resources/faq#how-big-is-the-flutter-engine
[macOS system requirements for Flutter]: /get-started/install/macos/mobile-ios#verify-system-requirements
[VS Code]: /tools/vs-code
[Xcode installed]: /get-started/install/macos/mobile-ios#install-and-configure-xcode
[News Feed app]: https://github.com/flutter/put-flutter-to-work/tree/022208184ec2623af2d113d13d90e8e1ce722365
[Debugging your add-to-app module]: /add-to-app/debugging/
[apple-silicon]: https://support.apple.com/en-us/116943
