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

Open your iOS Xcode project, such as
`ios/Runner.xcworkspace` for full-Flutter apps.

## 2단계 - 앱 클립 대상 추가 {:#step-2-add-an-app-clip-target}

**2.1**

Click on your project in the Project Navigator to show
the project settings.

Press **+** at the bottom of the target list to add a new target.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/add-target.png" %}

**2.2**

Select the **App Clip** type for your new target.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/add-app-clip.png" %}

**2.3**

Enter your new target detail in the dialog.

Select **Storyboard** for Interface.

Select the same language as your original target for **Language**.

(In other words, to simplify the setup,
don't create a Swift App Clip target for
an Objective-C main target, and vice versa.)

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/app-clip-details.png" %}

**2.4**

In the following dialog,
activate the new scheme for the new target.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/activate-scheme.png" %}

**2.5**

Back in the project settings, open the **Build Phases** tab.
Drag **Embedded App Clips** to above **Thin Binary**.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/embedded-app-clips.png" %}

<a id="step-3"></a>
## 3단계 - 불필요한 파일 제거 {:#step-3-remove-unneeded-files}

**3.1**

In the Project Navigator, in the newly created App Clip group,
delete everything except `Info.plist` and
`<app clip target>.entitlements`.

:::tip
For add-to-app users, it's up to the reader to decide
how much of this template to keep to invoke
`FlutterViewController` or `FlutterEngine` APIs
from this code later.
:::

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/clean-files.png" %}

Move files to trash.

**3.2**

If you don't use the `SceneDelegate.swift` file,
remove the reference to it in the `Info.plist`.

Open the `Info.plist` file in the App Clip group.
Delete the entire dictionary entry for
**Application Scene Manifest**.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/scene-manifest.png" %}

## 4단계 - 빌드 구성 공유 {:#step-4-share-build-configurations}

This step isn't necessary for add-to-app projects
since add-to-app projects have their custom build
configurations and versions.

**4.1**

Back in the project settings,
select the project entry now rather than any targets.

In the **Info** tab, under the **Configurations**
expandable group, expand the
**Debug**, **Profile**, and **Release** entries.

For each, select the same value from the drop-down menu
for the App Clip target as the entry selected for the
normal app target.

This gives your App Clip target access to Flutter's
required build settings.

Set **iOS Deployment Target** to at least **16.0** to take advantage of the
15MB size limit.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/configuration.png" %}

**4.2**

In the App Clip group's `Info.plist` file, set:

* `Build version string (short)` to `$(FLUTTER_BUILD_NAME)`
* `Bundle version` to `$(FLUTTER_BUILD_NUMBER)`

## 5단계 - 코드 및 assets 공유 {:#step-5-share-code-and-assets}

### 옵션 1 - 모든 것을 공유 {:#option-1-share-everything}

Assuming the intent is to show the same Flutter UI
in the standard app as in the App Clip,
share the same code and assets.

For each of the following: `Main.storyboard`, `Assets.xcassets`,
`LaunchScreen.storyboard`, `GeneratedPluginRegistrant.m`, and
`AppDelegate.swift` (and `Supporting Files/main.m` if using Objective-C),
select the file, then in the first tab of the inspector,
also include the App Clip target in the `Target Membership`
checkbox group.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/add-target-membership.png" %}

### 옵션 2 - 앱 클립을 위한 Flutter 실행 커스터마이즈 {:#option-2-customize-flutter-launch-for-app-clip}

In this case,
do not delete everything listed in [Step 3](#step-3).
Instead, use the scaffolding and the [iOS add-to-app APIs][]
to perform a custom launch of Flutter.
For example to show a [custom Flutter route][].

[custom Flutter route]: /add-to-app/ios/add-flutter-screen#route
[iOS add-to-app APIs]: /add-to-app/ios/add-flutter-screen

## 6단계 - 앱 클립 관련 도메인 추가 {:#step-6-add-app-clip-associated-domains}

This is a standard step for App Clip development.
See the [official Apple documentation][].

[official Apple documentation]: {{site.apple-dev}}/documentation/app_clips/creating_an_app_clip_with_xcode#3604097

**6.1**

Open the `<app clip target>.entitlements` file.
Add an `Associated Domains` Array type.
Add a row to the array with `appclips:<your bundle id>`.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/app-clip-entitlements.png" %}

**6.2**

The same associated domains entitlement needs to be added
to your main app, as well.

Copy the `<app clip target>.entitlements` file from your
App Clip group to your main app group and rename it to
the same name as your main target
such as `Runner.entitlements`.

Open the file and delete the
`Parent Application Identifiers`
entry for the main app's entitlement file
(leave that entry for the App Clip's entitlement file).

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/main-app-entitlements.png" %}

**6.3**

Back in the project settings, select the main app's target,
open the **Build Settings** tab.
Set the **Code Signing Entitlements** setting to the
relative path of the second entitlements file
created for the main app.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/main-app-entitlements-setting.png" %}

## 7단계 - Flutter 통합 {:#step-7-integrate-flutter}

These steps are not necessary for add-to-app.

**7.1**

For the Swift target,
set the `Objective-C Bridging Header`
build setting to `Runner/Runner-Bridging-Header.h`

In other words,
the same as the main app target's build settings.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/bridge-header.png" %}

**7.2**

Now open the **Build Phases** tab. Press the **+** sign
and select **New Run Script Phase**.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/new-build-phase.png" %}

Drag that new phase to below the **Dependencies** phase.

Expand the new phase and add this line to the script content:

```bash
/bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
```

Uncheck **Based on dependency analysis**.

In other words,
the same as the main app target's build phases.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/xcode-backend-build.png" %}

This ensures that your Flutter Dart code is compiled
when running the App Clip target.

**7.3**

Press the **+** sign and select **New Run Script Phase** again.
Leave it as the last phase.

This time, add:

```bash
/bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" embed_and_thin
```

Uncheck **Based on dependency analysis**.

In other words,
the same as the main app target's build phases.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/xcode-backend-embed.png" %}

This ensures that your Flutter app and engine are embedded
into the App Clip bundle.

## 8단계 - 플러그인 통합 {:#step-8-integrate-plugins}

**8.1**

Open the `Podfile` for your Flutter project
or add-to-app host project.

For full-Flutter apps, replace the following section:

```ruby
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end
```

with:

```ruby
use_frameworks!
use_modular_headers!
flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

target 'Runner'
target '<name of your App Clip target>'
```

At the top of the file,
also uncomment `platform :ios, '12.0'` and set the
version to the lowest of the two target's iOS
Deployment Target.

For add-to-app, add to:

```ruby
target 'MyApp' do
  install_all_flutter_pods(flutter_application_path)
end
```

with:

```ruby
target 'MyApp' do
  install_all_flutter_pods(flutter_application_path)
end

target '<name of your App Clip target>'
  install_all_flutter_pods(flutter_application_path)
end
```

**8.2**

From the command line,
enter your Flutter project directory
and then install the pod:

```console
cd ios
pod install
```

## 실행 {:#run}

You can now run your App Clip target from Xcode by
selecting your App Clip target from the scheme drop-down,
selecting an iOS 16 or higher device and pressing run.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/run-select.png" %}

To test launching an App Clip from the beginning,
also consult Apple's doc on
[Testing Your App Clip's Launch Experience][testing].

[testing]: {{site.apple-dev}}/documentation/app_clips/testing_your_app_clip_s_launch_experience

## 디버깅, 핫 리로드 {:#debugging-hot-reload}

Unfortunately `flutter attach` cannot auto-discover
the Flutter session in an App Clip due to
networking permission restrictions.

In order to debug your App Clip and use functionalities
like hot reload, you must look for the Observatory URI
from the console output in Xcode after running.

{% render docs/app-figure.md, image:"development/platform-integration/ios-app-clip/observatory-uri.png" %}

You must then copy and paste it back into the
`flutter attach` command to connect.

For example:

```console
flutter attach --debug-uri <copied URI>
```
