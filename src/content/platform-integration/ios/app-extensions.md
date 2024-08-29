---
# title: Adding iOS app extensions
title: iOS 앱 확장 프로그램 추가
# description: Learn how to add app extensions to your Flutter apps
description: Flutter 앱에 앱 확장 기능을 추가하는 방법을 알아보세요
---

iOS 앱 확장을 사용하면 앱 외부에서 기능을 확장할 수 있습니다. 
앱은 홈 화면 위젯으로 표시되거나, 앱의 일부를 다른 앱 내에서 사용할 수 있습니다.

앱 확장에 대해 자세히 알아보려면 [Apple 문서][Apple's documentation]를 ​​확인하세요.

:::note
앱 확장을 포함하는 iOS 앱을 빌드할 때 빌드 오류가 발생하는 경우, 열려 있는 버그가 있다는 것을 알아두십시오. 
해결 방법은 빌드 프로세스 순서를 변경하는 것입니다. 
자세한 내용은, [문제 #9690][Issue #9690] 및 [문제 #135056][Issue #135056]을 확인하십시오.
:::

[Issue #9690]:   {{site.github}}/flutter/website/issues/9690
[Issue #135056]: {{site.github}}/flutter/flutter/issues/135056

2024년 9월에 출시되고, 현재 베타 버전인 iOS 18 릴리스에서는, 여러 페이지를 만드는 것을 포함하여, 
기기의 제어 센터를 커스터마이즈 하기 위한 새로운 기능이 추가되었습니다. 
또한 [`ControlCenter`] API를 사용하여, 제어 센터에 대한 새로운 토글을 만들어, 앱을 특징으로 할 수 있습니다.

[`ControlCenter`]: {{site.apple-dev}}/documentation/widgetkit/controlcenter

## Flutter 앱에 앱 확장 기능을 추가하려면 어떻게 해야 하나요? {:#how-do-you-add-an-app-extension-to-your-flutter-app}

Flutter 앱에 앱 확장을 추가하려면, 확장 지점 *대상*을 Xcode 프로젝트에 추가합니다.

1. Flutter 프로젝트 디렉토리의 터미널 창에서 `open ios/Runner.xcworkspace`를 실행하여, 
   프로젝트의 기본 Xcode workspace를 엽니다.
2. Xcode에서 메뉴 바에서 **File -> New -> Target**을 선택합니다.

    <figure class="site-figure">
    <div class="site-figure-container">
        <img src='/assets/images/docs/development/platform-integration/app-extensions/xcode-new-target.png' alt='Opening the File -> New menu, then selecting Target in Xcode.' height='300'>
    </div>
    </figure>

3. 추가하려는 앱 확장 프로그램을 선택합니다. 
   이 선택은 프로젝트의 새 폴더 내에 확장 프로그램별 코드를 생성합니다. 
   생성된 코드와 각 확장 지점의 SDK에 대해 자세히 알아보려면, 
   [Apple 문서][Apple's documentation]의 리소스를 확인하세요.

iOS 기기에 홈 화면 위젯을 추가하는 방법을 알아보려면, 
[Flutter 앱에 홈 화면 위젯 추가][lab] 코드랩을 확인하세요.

## Flutter 앱은 앱 확장 프로그램과 어떻게 상호작용하나요? {:#how-do-flutter-apps-interact-with-app-extensions} 

Flutter 앱은 UIKit 또는 SwiftUI 앱과 동일한 기술을 사용하여, 앱 확장 프로그램과 상호 작용합니다. 
포함하는 앱과 앱 확장 프로그램은 직접 통신하지 않습니다. 
포함하는 앱은 기기 사용자가 확장 프로그램과 상호 작용하는 동안 실행되지 않을 수 있습니다. 
앱과 확장 프로그램은 공유 리소스를 읽고 쓰거나, 높은 레벨 API를 사용하여 서로 통신할 수 있습니다.

### 높은 레벨 API 사용 {:#using-higher-level-apis}

일부 확장 프로그램에는 API가 있습니다. 
예를 들어, [Core Spotlight][] 프레임워크는 앱을 인덱싱하여, 
사용자가 Spotlight 및 Safari에서 검색할 수 있도록 합니다. 
[WidgetKit][] 프레임워크는 홈 화면 위젯의 업데이트를 트리거할 수 있습니다.

앱이 확장 프로그램과 통신하는 방식을 간소화하기 위해, 
Flutter 플러그인은 이러한 API를 래핑합니다. 
확장 프로그램 API를 래핑하는 플러그인을 찾으려면, 
[Apple의 시스템 API 및 프레임워크 활용][leverage]을 확인하거나, 
[pub.dev][]를 검색하세요.

### 리소스 공유 {:#sharing-resources}

Flutter 앱과 앱 확장 프로그램 간에 리소스를 공유하려면, 
`Runner` 앱 대상과 확장 프로그램 대상을 동일한 [앱 그룹][App Group]에 넣으세요.

:::note
Apple 개발자 계정에 로그인해야 합니다.
:::

앱 그룹에 대상을 추가하려면:

1. Xcode에서 대상 설정을 엽니다.

2. **Signing & Capabilities** 탭으로 이동합니다.

3. **+ Capability**을 선택한 다음 **App Groups**을 선택합니다.

4. 두 옵션 중 하나에서 대상을 추가할 앱 그룹을 선택합니다.

    {: type="a"}
    1. 리스트에서 앱 그룹을 선택합니다.

    2. **+**를 클릭하여 새 앱 그룹을 추가합니다.

{% render docs/app-figure.md, image:"development/platform-integration/app-extensions/xcode-app-groups.png", alt:"Selecting an App Group within an Xcode Runner target configuration." %}

두 대상이 동일한 앱 그룹에 속하면 동일한 소스에서 읽고 쓸 수 있습니다. 
데이터에 대해 다음 소스 중 하나를 선택하세요.

* **키/값:** [`shared_preference_app_group`][] 플러그인을 사용하여, 
  동일한 앱 그룹 내에서 `UserDefaults`를 읽거나 씁니다.
* **파일:** [`path_provider`][] 플러그인의 앱 그룹 컨테이너 경로를 사용하여, [파일을 읽고 씁니다][read and write files].
* **데이터베이스:** [`path_provider`][] 플러그인의 앱 그룹 컨테이너 경로를 사용하여, [`sqflite`][] 플러그인으로 데이터베이스를 만듭니다.

### 백그라운드 업데이트 {:#background-updates}

백그라운드 작업은 앱의 상태와 관계없이 코드를 통해 확장 프로그램을 업데이트하는 수단을 제공합니다.

Flutter 앱에서 백그라운드 작업을 예약하려면, [`workmanager`][] 플러그인을 사용하세요.

### 딥 링크 {:#deep-linking}

앱 확장 프로그램에서 사용자를 Flutter 앱의 특정 페이지로 안내하고 싶을 수 있습니다. 
앱에서 특정 경로를 열려면, [딥 링크][Deep Linking]를 사용할 수 있습니다.

## Flutter로 앱 확장 UI 만들기 {:#creating-app-extension-uis-with-flutter}

일부 앱 확장 프로그램은 사용자 인터페이스를 표시합니다.

예를 들어, 공유 확장 프로그램을 사용하면 사용자가 다른 앱과 편리하게 콘텐츠를 공유할 수 있습니다.
(예: 소셜 미디어 앱에서 새 게시물을 만들기 위해 사진을 공유)

<figure class="site-figure">
    <div class="site-figure-container">
        <img src='/assets/images/docs/development/platform-integration/app-extensions/share-extension.png' alt='An example of an entry added to the share menu by a Flutter app' height='300'>
    </div>
</figure>

3.16 릴리스부터, 앱 확장을 위한 Flutter UI를 빌드할 수 있지만, 
다음 섹션에 설명된 대로 확장 기능이 안전한 `Flutter.xcframework`를 사용하고, 
`FlutterViewController`를 임베드해야 합니다.

:::note
앱 확장 프로그램의 메모리 제한으로 인해, 
Flutter를 사용하여 메모리 제한이 100MB보다 큰 확장 프로그램 타입에 대한 앱 확장 프로그램 UI를 빌드합니다. 
예를 들어, Share 확장 프로그램의 메모리 제한은 120MB입니다.

또한, Flutter는 디버그 모드에서 추가 메모리를 사용합니다. 
따라서, Flutter는 확장 프로그램 UI를 빌드하는 데 사용될 때, 
물리적 장치에서 디버그 모드에서 앱 확장 프로그램을 실행하는 것을 완전히 지원하지 않습니다. 
메모리가 부족할 수 있습니다. 
대안으로 iOS 시뮬레이터를 사용하여 디버그 모드에서 확장 프로그램을 테스트합니다.
:::

1. `<path_to_flutter_sdk>/bin/cache/artifacts/engine/ios/extension_safe/Flutter.xcframework`에서, 확장 기능 안전 `Flutter.xcframework` 파일을 찾습니다.

   * 릴리스 또는 프로필 모드로 빌드하려면, 
     각각 `ios-release` 또는 `ios-profile` 폴더에서 프레임워크 파일을 찾습니다.

1. `Flutter.xcframework` 파일을 공유 확장 기능의 프레임워크 및 라이브러리 리스트로 끌어다 놓습니다. 
   임베드 열에 "Embed & Sign"이라고 표시되어 있는지 확인합니다.

   <figure class="site-figure">
       <div class="site-figure-container">
           <img src='/assets/images/docs/development/platform-integration/app-extensions/embed-framework.png' alt='The Flutter.xcframework file being marked as Embed & Sign in Xcode.' height='300'>
       </div>
   </figure>

2. Xcode에서 Flutter 앱 프로젝트 설정을 열어, 빌드 구성을 공유합니다.

    {: type="a"}
    1. **Info** 탭으로 이동합니다.
    2. **Configurations** 그룹을 확장합니다.
    3. **Debug**, **Profile**, **Release** 항목을 확장합니다.
    4. 이러한 각 구성에 대해 확장 프로그램의 **Based on configuration file** 드롭다운 메뉴에 있는 값이, 
       일반 앱 대상에 대해 선택한 값과 일치하는지 확인합니다.

    <figure class="site-figure">
        <div class="site-figure-container">
            <img src='/assets/images/docs/development/platform-integration/app-extensions/xcode-configurations.png' alt='An example Xcode Runner configuration with each property set to: Based on configuration file.' height='300'>
        </div>
    </figure>

3. (선택 사항) 필요한 경우, 스토리보드 파일을 확장 클래스로 바꿉니다.

    {: type="a"}
    1. `Info.plist` 파일에서 **NSExtensionMainStoryboard** 속성을 삭제합니다.
    2. **NSExtensionPrincipalClass** 속성을 추가합니다.
    3. 이 속성의 값을 확장의 진입점으로 설정합니다. 
       예를 들어, 공유 확장의 경우, 일반적으로 `<YourShareExtensionTargetName>.ShareViewController`입니다. 
       Objective-C를 사용하여 확장을 구현하는 경우, `<YourShareExtensionTargetName>.` 부분을 생략해야 합니다.<br>

    <figure class="site-figure">
        <div class="site-figure-container">
            <img src='/assets/images/docs/development/platform-integration/app-extensions/share-extension-info.png' alt='Setting the NSExtensionPrincipalClass property in the Info.plist file within Xcode.' height='300'>
        </div>
    </figure>

4. [Flutter 화면 추가][Adding a Flutter Screen]에 설명된 대로, `FlutterViewController`를 임베드합니다. 
   예를 들어, 공유 확장 내에서 Flutter 앱의 특정 경로를 표시할 수 있습니다.

    ```swift
    import UIKit
    import Flutter

    class ShareViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            showFlutter()
        }

        func showFlutter() {
            let flutterViewController = FlutterViewController(project: nil, nibName: nil, bundle: nil)
            addChild(flutterViewController)
            view.addSubview(flutterViewController.view)
            flutterViewController.view.frame = view.bounds
        }
    }
    ```

## 확장 테스트 {:#test-extensions}

시뮬레이터와 실제 장치에서 확장 프로그램을 테스트하는 절차는 약간 다릅니다.

{% comment %}
The different procedures are necessary due to bugs(which bugs?) in Xcode.
Revisit these docs after future Xcode releases to see if they are fixed.
{% endcomment -%}

### 시뮬레이터에서 테스트 {:#test-on-a-simulator}

1. 메인 애플리케이션 타겟을 빌드하고 실행합니다.
2. 시뮬레이터에서 앱을 실행한 후, <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd>를 눌러 앱을 최소화하면, 
   홈 화면으로 전환됩니다.
3. (사진 앱과 같이) 공유 확장 기능을 지원하는 앱을 실행합니다.
4. 사진을 선택하고, 공유 버튼을 탭한 다음, 앱의 공유 확장 기능 아이콘을 탭합니다.

### 실제 장치에서 테스트 {:#test-on-a-physical-device}

다음 절차나 [시뮬레이터에서 테스트](#test-on-a-simulator) 지침을 사용하여, 실제 장치에서 테스트할 수 있습니다.

1. 공유 확장 대상을 시작합니다.
1. "실행할 앱 선택"이라는 팝업 창에서, 사진 앱과 같이 공유 확장을 테스트하는 데 사용할 수 있는 앱을 선택합니다.
1. 사진을 선택하고 공유 버튼을 탭한 다음, 앱의 공유 확장 아이콘을 탭합니다.

## 튜토리얼 {:#tutorials}

Flutter iOS 앱에서 앱 확장 기능을 사용하기 위한 단계별 지침은, 
[Flutter 앱에 홈 화면 위젯 추가][lab] 코드랩을 확인하세요.

[Adding a Flutter Screen]: /add-to-app/ios/add-flutter-screen?tab=vc-uikit-swift-tab#alternatively-create-a-flutterviewcontroller-with-an-implicit-flutterengine
[App Group]: {{site.apple-dev}}/documentation/xcode/configuring-app-groups
[Apple's documentation]: {{site.apple-dev}}/app-extensions/
[Core Spotlight]: {{site.apple-dev}}/documentation/corespotlight
[Deep Linking]:/ui/navigation/deep-linking
[lab]: {{site.codelabs}}/flutter-home-screen-widgets
[leverage]: /platform-integration/ios/apple-frameworks
[`path_provider`]: {{site.pub-pkg}}/path_provider
[pub.dev]: {{site.pub-pkg}}
[read and write files]: /cookbook/persistence/reading-writing-files
[`shared_preference_app_group`]: {{site.pub-pkg}}/shared_preference_app_group
[`sqflite`]: {{site.pub-pkg}}/sqflite
[WidgetKit]: {{site.apple-dev}}/documentation/widgetkit
[`workmanager`]: {{site.pub-pkg}}/workmanager
