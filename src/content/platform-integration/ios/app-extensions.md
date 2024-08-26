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

To add an app extension to your Flutter app,
add the extension point *target* to your Xcode project.

1. Open the default Xcode workspace in your project by running
   `open ios/Runner.xcworkspace` in a terminal window from your
   Flutter project directory.
1. In Xcode, select **File -> New -> Target** from the menu bar. 

    <figure class="site-figure">
    <div class="site-figure-container">
        <img src='/assets/images/docs/development/platform-integration/app-extensions/xcode-new-target.png' alt='Opening the File -> New menu, then selecting Target in Xcode.' height='300'>
    </div>
    </figure>
1. Select the app extension you intend to add.
   This selection generates extension-specific code 
   within a new folder in your project.
   To learn more about the generated code and the SDKs for each
   extension point, check out the resources in
   [Apple's documentation][].

To learn how to add a home screen widget to your iOS device,
check out the 
[Adding a Home Screen Widget to your Flutter app][lab]
codelab.

## Flutter 앱은 앱 확장 프로그램과 어떻게 상호작용하나요? {:#how-do-flutter-apps-interact-with-app-extensions} 

Flutter apps interact with app extensions using the same
techniques as UIKit or SwiftUI apps.
The containing app and the app extension don't communicate directly.
The containing app might not be running while the device user
interacts with the extension.
The app and your extension can read and write to
shared resources or use higher-level APIs
to communicate with each other.

### 높은 레벨 API 사용 {:#using-higher-level-apis}

Some extensions have APIs. For example, 
the [Core Spotlight][] framework indexes your app,
allowing users to search from Spotlight and Safari.
The [WidgetKit][] framework can trigger an update
of your home screen widget.

To simplify how your app communicates with extensions,
Flutter plugins wrap these APIs.
To find plugins that wrap extension APIs,
check out [Leveraging Apple's System APIs and Frameworks][leverage]
or search [pub.dev][].

### 리소스 공유 {:#sharing-resources}

To share resources between your Flutter app
and your app extension, put the `Runner` app target
and the extension target in the same [App Group][].

:::note
You must be signed in to your Apple Developer account.
:::

To add a target to an App Group:

1. Open the target settings in Xcode.
1. Navigate to the **Signing & Capabilities** tab.
1. Select **+ Capability** then **App Groups**.
1. Choose which App Group you want to add the target from
   one of two options:

    {: type="a"}
    1. Select an App Group from the list.
    1. Click **+** to add a new App Group.

{% render docs/app-figure.md, image:"development/platform-integration/app-extensions/xcode-app-groups.png", alt:"Selecting an App Group within an Xcode Runner target configuration." %}

When two targets belong to the same App Group,
they can read from and write to the same source.
Choose one of the following sources for your data.

* **Key/value:** Use the [`shared_preference_app_group`][]
  plugin to read or write to `UserDefaults` within the same App Group.
* **File:** Use the App Group container path from the
  [`path_provider`][] plugin to [read and write files][].
* **Database:** Use the App Group container path from
  the [`path_provider`][] plugin to create a database with the
  [`sqflite`][] plugin.

### 백그라운드 업데이트 {:#background-updates}

Background tasks provide a means to update your extension
through code regardless of the status of your app.

To schedule background work from your Flutter app,
use the [`workmanager`][] plugin.

### 딥 링크 {:#deep-linking}

You might want to direct users from an
app extension to a specific page in your Flutter app.
To open a specific route in your app,
you can use [Deep Linking][].

## Flutter로 앱 확장 UI 만들기 {:#creating-app-extension-uis-with-flutter}

Some app extensions display a user interface.

For example, share extensions allow users to conveniently
share content with other apps,
such as sharing a picture to create
a new post on a social media app.

<figure class="site-figure">
    <div class="site-figure-container">
        <img src='/assets/images/docs/development/platform-integration/app-extensions/share-extension.png' alt='An example of an entry added to the share menu by a Flutter app' height='300'>
    </div>
</figure>

As of the 3.16 release, you can build
Flutter UI for an app extension,
though you must use an extension-safe
`Flutter.xcframework` and embed the
`FlutterViewController` as described in
the following section.

:::note
Due to the memory limitations of app extensions,
use Flutter to build an app extension UI for extension
types that have memory limits larger than 100MB.
For example, Share extensions have a 120MB memory limit.

In addition, Flutter uses extra memory in debug mode.
Therefore, Flutter doesn't fully support running
app extensions in debug mode on physical devices
when used to build extension UI; it might run out of memory.
As an alternative,
use an iOS simulator to test your extension in debug mode.
:::

1. Locate the extension-safe `Flutter.xcframework` file,
   at `<path_to_flutter_sdk>/bin/cache/artifacts/engine/ios/extension_safe/Flutter.xcframework`.
   
    * To build for release or profile modes,
      find the framework file under the
      `ios-release` or `ios-profile` folder, respectively.

1. Drag and drop the `Flutter.xcframework` file into your
   share extension's frameworks and libraries list.
   Make sure the embed column says "Embed & Sign".

   <figure class="site-figure">
       <div class="site-figure-container">
           <img src='/assets/images/docs/development/platform-integration/app-extensions/embed-framework.png' alt='The Flutter.xcframework file being marked as Embed & Sign in Xcode.' height='300'>
       </div>
   </figure>

1. Open the Flutter app project settings in Xcode
   to share build configurations. 

   {: type="a"}
   1. Navigate to the **Info** tab.
   1. Expand the **Configurations** group. 
   1. Expand the **Debug**, **Profile**, and **Release** entries.
   1. For each of these configurations, make sure the value in the
      **Based on configuration file** drop-down menu for your
      extension matches the one selected for the normal app target.

    <figure class="site-figure">
        <div class="site-figure-container">
            <img src='/assets/images/docs/development/platform-integration/app-extensions/xcode-configurations.png' alt='An example Xcode Runner configuration with each property set to: Based on configuration file.' height='300'>
        </div>
    </figure>

1. (Optional) Replace any storyboard files with an extension class, if needed.

    {: type="a"}
    1. In the `Info.plist` file,
       delete the **NSExtensionMainStoryboard** property.
    1. Add the **NSExtensionPrincipalClass** property.
    1. Set the value for this property to the entry point of the extension.
       For example, for share extensions, it's usually
       `<YourShareExtensionTargetName>.ShareViewController`.
       If you use Objective-C to implement the extension,
       you should omit the `<YourShareExtensionTargetName>.`
       portion.<br>

    <figure class="site-figure">
        <div class="site-figure-container">
            <img src='/assets/images/docs/development/platform-integration/app-extensions/share-extension-info.png' alt='Setting the NSExtensionPrincipalClass property in the Info.plist file within Xcode.' height='300'>
        </div>
    </figure>

1. Embed the `FlutterViewController` as described in
   [Adding a Flutter Screen][]. For example, you can display a
   specific route in your Flutter app within a share extension.

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

Testing extensions on simulators and physical devices
have slightly different procedures.

{% comment %}
The different procedures are necessary due to bugs(which bugs?) in Xcode.
Revisit these docs after future Xcode releases to see if they are fixed.
{% endcomment -%}

### 시뮬레이터에서 테스트 {:#test-on-a-simulator}

1. Build and run the main application target.
1. After the app is launched on the simulator,
   press <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd>
   to minimize the app, which switches to the home screen.
1. Launch an app that supports the share extension,
   such as the Photos app.
1. Select a photo, tap the share button, then tap
   on the share extension icon of your app.

### 실제 장치에서 테스트 {:#test-on-a-physical-device}

You can use the following procedure or the
[Testing on simulators](#test-on-a-simulator) instructions
to test on physical devices.

1. Launch the share extension target.
1. In the popup window that says "Choose an app to run",
   select an app that can be used to test share extension,
   such as the Photos app.
1. Select a photo, tap the share button,
   then tap on the share extension icon of your app.

## 튜토리얼 {:#tutorials}

For step-by-step instruction for using app
extensions with your Flutter iOS app, check out the
[Adding a Home Screen Widget to your Flutter app][lab]
codelab.

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
