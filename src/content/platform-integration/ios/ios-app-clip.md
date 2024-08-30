---
# title: Adding an iOS App Clip target
title: iOS 앱 클립 대상 추가
# description: How to add an iOS App Clip target to your Flutter project.
description: Flutter 프로젝트에 iOS 앱 클립 대상을 추가하는 방법.
---

:::important
iOS 16을 타겟팅하면 압축되지 않은 IPA 페이로드 크기 제한이 15MB로 늘어납니다. 
앱 크기에 따라 제한에 도달할 수 있습니다. ([#71098][]).
:::

이 가이드에서는 기존 Flutter 프로젝트나 [add-to-app][] 프로젝트에, 
다른 Flutter 렌더링 iOS 앱 클립 대상을 수동으로 추가하는 방법을 설명합니다.

[#71098]: {{site.repo.flutter}}/issues/71098
[add-to-app]: /add-to-app

:::warning
이 가이드는 고급 가이드이며 iOS 개발에 대한 실무 지식이 있는 독자를 대상으로 합니다.
:::

실제 샘플을 보려면 GitHub의 [앱 클립 샘플][App Clip sample]을 참조하세요.

[App Clip sample]: {{site.repo.samples}}/tree/main/ios_app_clip

## 1단계 - 프로젝트 열기 {:#step-1-open-project}

전체 Flutter 앱의 경우 `ios/Runner.xcworkspace`와 같은, iOS Xcode 프로젝트를 엽니다.

## 2단계 - 앱 클립 대상 추가 {:#step-2-add-an-app-clip-target}

**2.1**

프로젝트 내비게이터에서 프로젝트를 클릭하여 프로젝트 설정을 표시합니다.

대상 리스트 하단에서 **+** 를 눌러 새 대상을 추가합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/add-target.png" %}

**2.2**

새로운 타겟에 대한 **App Clip** 타입을 선택하세요.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/add-app-clip.png" %}

**2.3**

대화 상자에 새 대상 세부 정보를 입력합니다.

인터페이스에 **Storyboard**를 선택합니다.

**Language**에 원래 대상과 동일한 언어를 선택합니다.

(즉, 설정을 간소화하려면, Objective-C 기본 대상에 대한 Swift App Clip 대상을 만들지 말고, 그 반대도 마찬가지입니다.)

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/app-clip-details.png" %}

**2.4**

다음 대화 상자에서, 새 대상에 대한 새 스킴(scheme)을 활성화합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/activate-scheme.png" %}

**2.5**

프로젝트 설정으로 돌아가서, **Build Phases** 탭을 엽니다.
**Embedded App Clips**를 **Thin Binary** 위로 드래그합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/embedded-app-clips.png" %}

<a id="step-3"></a>
## 3단계 - 불필요한 파일 제거 {:#step-3-remove-unneeded-files}

**3.1**

프로젝트 네비게이터에서, 새로 만든 App Clip 그룹에서, 
`Info.plist` 및 `<app clip target>.entitlements`를 제외한 모든 항목을 삭제합니다.

:::tip
앱에 추가한(add-to-app) 사용자의 경우, 
나중에 이 코드에서 `FlutterViewController` 또는 `FlutterEngine` API를 호출하기 위해, 
이 템플릿을 얼마나 보존할지 결정하는 것은 독자의 몫입니다.
:::

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/clean-files.png" %}

파일을 휴지통으로 이동합니다.

**3.2**

`SceneDelegate.swift` 파일을 사용하지 않는 경우, 
`Info.plist`에서 해당 파일에 대한 참조를 제거합니다.

App Clip 그룹에서 `Info.plist` 파일을 엽니다. 
**Application Scene Manifest**에 대한 전체 사전 항목을 삭제합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/scene-manifest.png" %}

## 4단계 - 빌드 구성 공유 {:#step-4-share-build-configurations}

add-to-app 프로젝트에는 커스텀 빌드 구성과 버전이 있으므로, 
add-to-app 프로젝트에 대해서는 이 단계가 필요하지 않습니다.

**4.1**

프로젝트 설정으로 돌아가서, 이제 모든 대상이 아닌 프로젝트 항목을 선택합니다.

**Info** 탭에서, **Configurations** 확장 가능 그룹 아래에서, 
**Debug**, **Profile** 및 **Release** 항목을 확장합니다.

각각에 대해, 일반 앱 대상에 대해 선택한 항목과 동일한 값을, 
App Clip 대상의 드롭다운 메뉴에서 선택합니다.

이렇게 하면 App Clip 대상이 Flutter의 필수 빌드 설정에 액세스할 수 있습니다.

15MB 크기 제한을 활용하려면, **iOS Deployment Target**을 최소 **16.0**으로 설정합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/configuration.png" %}

**4.2**

App Clip 그룹의 `Info.plist` 파일에서, 다음을 설정합니다.

* `Build version string (short)`를 `$(FLUTTER_BUILD_NAME)`로
* `Bundle version`를 `$(FLUTTER_BUILD_NUMBER)`로

## 5단계 - 코드 및 assets 공유 {:#step-5-share-code-and-assets}

### 옵션 1 - 모든 것을 공유 {:#option-1-share-everything}

표준 앱에서 App Clip과 동일한 Flutter UI를 표시하는 것이 의도(intent)라고 가정하면, 
동일한 코드와 assets을 공유합니다.

다음 각각에 대해: `Main.storyboard`, `Assets.xcassets`, `LaunchScreen.storyboard`, `GeneratedPluginRegistrant.m`, `AppDelegate.swift`(Objective-C를 사용하는 경우, `Supporting Files/main.m`도 포함) 파일을 선택한 다음, 
검사기의 첫 번째 탭에서 `Target Membership` 체크박스 그룹에 App Clip 대상을 포함합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/add-target-membership.png" %}

### 옵션 2 - 앱 클립을 위한 Flutter 실행 커스터마이즈 {:#option-2-customize-flutter-launch-for-app-clip}

이 경우, [3단계](#step-3)에 나열된 모든 내용을 삭제하지 마세요. 
대신, 스캐폴딩(scaffolding)과 [iOS 앱 추가 API][iOS add-to-app APIs]를 사용하여, 
Flutter의 커스텀 실행을 수행하세요. 
예를 들어 [커스텀 Flutter 경로][custom Flutter route]를 표시하려면 다음과 같이 하세요.

[custom Flutter route]: /add-to-app/ios/add-flutter-screen#route
[iOS add-to-app APIs]: /add-to-app/ios/add-flutter-screen

## 6단계 - 앱 클립 관련 도메인 추가 {:#step-6-add-app-clip-associated-domains}

이는 App Clip 개발을 위한 표준 단계입니다. [공식 Apple 문서][official Apple documentation]를 ​​참조하세요.

[official Apple documentation]: {{site.apple-dev}}/documentation/app_clips/creating_an_app_clip_with_xcode#3604097

**6.1**

`<app clip target>.entitlements` 파일을 엽니다. 
`Associated Domains` Array 타입을 추가합니다. 
`appclips:<your bundle ID>`가 있는 배열에 행을 추가합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/app-clip-entitlements.png" %}

**6.2**

동일한 관련 도메인 자격(entitlement)도 메인 앱에 추가해야 합니다.

App Clip 그룹에서 `<app clip target>.entitlements` 파일을 메인 앱 그룹으로 복사하고, 
메인 대상과 같은 이름(예: `Runner.entitlements`)으로 이름을 바꿉니다.

파일을 열고 메인 앱의 자격 파일(entitlement file)에 대한 `Parent Application Identifiers` 항목을 삭제합니다.
(App Clip의 자격 파일에 대한 항목은 그대로 둡니다)

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/main-app-entitlements.png" %}

**6.3**

프로젝트 설정으로 돌아가서, 
메인 앱의 타겟을 선택하고 **Build Settings** 탭을 엽니다. 
**Code Signing Entitlements** 설정을 메인 앱에 대해 생성된 두 번째 자격 파일의 상대 경로로 설정합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/main-app-entitlements-setting.png" %}

## 7단계 - Flutter 통합 {:#step-7-integrate-flutter}

이러한 단계는 앱에 추가(add-to-app)하는 데 필요하지 않습니다.

**7.1**

Swift 대상의 경우, 
`Objective-C Bridging Header` 빌드 설정을 `Runner/Runner-Bridging-Header.h`로 설정합니다.

즉, 메인 앱 대상의 빌드 설정과 동일합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/bridge-header.png" %}

**7.2**

이제 **Build Phases** 탭을 엽니다. **+** 기호를 누르고 **New Run Script Phase**를 선택합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/new-build-phase.png" %}

새로운 단계를 **Dependencies** 단계 아래로 드래그합니다.

새로운 단계를 확장하고 스크립트 콘텐츠에 다음 줄을 추가합니다.

```bash
/bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
```

**Based on dependency analysis**의 체크를 해제합니다.

즉, 메인 앱 타겟의 빌드 단계와 동일합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/xcode-backend-build.png" %}

이렇게 하면 App Clip 대상을 실행할 때 Flutter Dart 코드가 컴파일됩니다.

**7.3**

**+** 기호를 누르고 **New Run Script Phase**를 다시 선택합니다.
마지막 단계로 둡니다.

이번에는 다음을 추가하세요.

```bash
/bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" embed_and_thin
```

**Based on dependency analysis**의 체크를 해제합니다.

즉, 메인 앱 타겟의 빌드 단계와 동일합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/xcode-backend-embed.png" %}

이렇게 하면 Flutter 앱과 엔진이 App Clip 번들에 포함됩니다.

## 8단계 - 플러그인 통합 {:#step-8-integrate-plugins}

**8.1**

Flutter 프로젝트 또는 앱 추가 호스트 프로젝트의 `Podfile`을 엽니다.

전체 Flutter 앱의 경우, 다음 섹션을 바꿉니다.

```ruby
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end
```

이렇게 변경합니다.

```ruby
use_frameworks!
use_modular_headers!
flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

target 'Runner'
target '<name of your App Clip target>'
```

파일 맨 위에서, `platform :ios, '12.0'` 주석 처리를 해제하고, 
두 대상의 iOS 배포 대상 중 가장 낮은 버전으로 설정합니다.

add-to-app의 경우, 다음을 추가합니다.

```ruby
target 'MyApp' do
  install_all_flutter_pods(flutter_application_path)
end
```

이렇게 추가합니다.

```ruby
target 'MyApp' do
  install_all_flutter_pods(flutter_application_path)
end

target '<name of your App Clip target>'
  install_all_flutter_pods(flutter_application_path)
end
```

**8.2**

명령줄에서, Flutter 프로젝트 디렉토리를 입력한 다음 Pod를 설치합니다.

```console
cd ios
pod install
```

## 실행 {:#run}

이제 Xcode에서 App Clip 대상을 실행할 수 있습니다. 
스키마 드롭다운에서 App Clip 대상을 선택하고, iOS 16 이상 기기를 선택한 다음 실행을 누르세요.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/run-select.png" %}

처음부터 App Clip 실행을 테스트하려면, 
Apple의 [App Clip 실행 경험 테스트][testing] 문서도 참조하세요.

[testing]: {{site.apple-dev}}/documentation/app_clips/testing_your_app_clip_s_launch_experience

## 디버깅, 핫 리로드 {:#debugging-hot-reload}

불행히도 `flutter attachment`는 네트워크 권한 제한으로 인해, 
App Clip에서 Flutter 세션을 자동으로 검색할 수 없습니다.

App Clip을 디버깅하고 핫 리로드와 같은 기능을 사용하려면, 
실행 후 Xcode의 콘솔 출력에서 ​​Observatory URI를 찾아야 합니다.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/observatory-uri.png" %}

그런 다음 `flutter attachment` 명령에 다시 복사하여 붙여넣어 연결해야 합니다.

예를 들어, 다음과 같습니다:

```console
flutter attach --debug-uri <copied URI>
```
