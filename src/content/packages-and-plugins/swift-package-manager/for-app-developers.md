---
# title: Swift Package Manager for app developers
title: 앱 개발자를 위한 Swift Package Manager
# description: How to use Swift Package Manager for native iOS or macOS dependencies
description: 네이티브 iOS 또는 macOS 종속성에 Swift Package Manager를 사용하는 방법
---

:::warning
Flutter는 iOS 및 macOS 네이티브 종속성을 관리하기 위해 [Swift Package Manager][]로 마이그레이션하고 있습니다. Flutter의 Swift Package Manager 지원은 개발 중입니다. 구현은 향후 변경될 수 있습니다. Swift Package Manager 지원은 [`main` 채널][`main` channel]에서만 제공됩니다. Flutter는 CocoaPods를 계속 지원합니다.
:::

Flutter의 Swift Package Manager 통합에는 여러 가지 이점이 있습니다.

1. **Swift 패키지 생태계에 대한 액세스를 제공합니다.**
   Flutter 플러그인은 [Swift 패키지][Swift packages]의 성장하는 생태계를 사용할 수 있습니다.
2. **Flutter 설치를 간소화합니다.**
   Xcode에는 Swift Package Manager가 포함되어 있습니다. 
   프로젝트에서 Swift Package Manager를 사용하는 경우, 
   Ruby와 CocoaPods를 설치할 필요가 없습니다.

Flutter의 Swift Package Manager 지원에서 버그를 발견하면, [문제를 엽니다][open an issue].

[Swift Package Manager]: https://www.swift.org/documentation/package-manager/
[`main` channel]: /release/upgrade#switching-flutter-channels
[Swift packages]: https://swiftpackageindex.com/
[open an issue]: {{site.github}}/flutter/flutter/issues/new?template=2_bug.yml

{% include docs/swift-package-manager/how-to-enable-disable.md %}

## Swift Package Manager 통합을 추가하는 방법 {:#how-to-add-swift-package-manager-integration}

### Flutter 앱에 추가 {:#add-to-a-flutter-app}

{% tabs %}
{% tab "iOS 프로젝트" %}

{% include docs/swift-package-manager/migrate-ios-project.md %}

{% endtab %}
{% tab "macOS 프로젝트" %}

{% include docs/swift-package-manager/migrate-macos-project.md %}

{% endtab %}
{% endtabs %}

### Flutter 앱에 _수동으로_ 추가 {:#add-to-a-flutter-app-manually}

{% tabs %}
{% tab "iOS 프로젝트" %}

{% include docs/swift-package-manager/migrate-ios-project-manually.md %}

{% endtab %}
{% tab "macOS 프로젝트" %}

{% include docs/swift-package-manager/migrate-macos-project-manually.md %}

{% endtab %}
{% endtabs %}

### 기존 앱에 추가 (add-to-app) {:#add-to-an-existing-app-add-to-app}

Flutter의 Swift Package Manager 지원은 앱 추가(add-to-app) 시나리오에서는 작동하지 않습니다.

상태 업데이트를 최신 상태로 유지하려면, [flutter#146957][]을 참조하세요.

[flutter#146957]: https://github.com/flutter/flutter/issues/146957

### 커스텀 Xcode 대상에 추가 {:#add-to-a-custom-xcode-target}

Flutter Xcode 프로젝트는 (프레임워크나 유닛 테스트와 같은) 추가 제품을 빌드하기 위한, 
커스텀 [Xcode 대상][Xcode targets]을 가질 수 있습니다. 
이러한 커스텀 Xcode 대상에 Swift Package Manager 통합을 추가할 수 있습니다.

[프로젝트에 Swift Package Manager 통합을 _수동으로_ 추가하는 방법][manualIntegration]의 단계를 따르세요.

[1단계][manualIntegrationStep1]에서, 리스트 아이템 6은 `Flutter` 대상 대신 커스텀 대상을 사용합니다.

[2단계][manualIntegrationStep2]에서, 리스트 아이템 6은 `Flutter` 대상 대신 커스텀 대상을 사용합니다.

[Xcode targets]: https://developer.apple.com/documentation/xcode/configuring-a-new-target-in-your-project
[manualIntegration]: /packages-and-plugins/swift-package-manager/for-app-developers/#how-to-add-swift-package-manager-integration-to-a-flutter-app-manually
[manualIntegrationStep1]: /packages-and-plugins/swift-package-manager/for-app-developers/#step-1-add-fluttergeneratedpluginswiftpackage-package-dependency
[manualIntegrationStep2]: /packages-and-plugins/swift-package-manager/for-app-developers/#step-2-add-run-prepare-flutter-framework-script-pre-action

## Swift Package Manager 통합을 제거하는 방법 {:#how-to-remove-swift-package-manager-integration}

Swift Package Manager 통합을 추가하기 위해, Flutter CLI는 프로젝트를 마이그레이션합니다. 
이 마이그레이션은 Flutter 플러그인 종속성을 추가하기 위해 Xcode 프로젝트를 업데이트합니다.

이 마이그레이션을 실행 취소하려면:

1. [Swift Package Manager 끄기][Turn off Swift Package Manager].

2. 프로젝트를 정리합니다:

   ```sh
   flutter clean
   ```

3. Xcode에서 앱(`ios/Runner.xcworkspace` 또는 `macos/Runner.xcworkspace`)을 엽니다.

4. 프로젝트의 **Package Dependencies**으로 이동합니다.

5. `FlutterGeneratedPluginSwiftPackage` 패키지를 클릭한 다음, 
   <span class="material-symbols-outlined">remove</span>를 클릭합니다.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/remove-generated-package.png",
   caption:"제거할 `FlutterGeneratedPluginSwiftPackage`" %}

6. `Runner` 대상의 **Frameworks, Libraries, and Embedded Content**로 이동합니다.

7. `FlutterGeneratedPluginSwiftPackage`를 클릭한 다음, 
   <span class="material-symbols-outlined">remove</span>를 클릭합니다.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/remove-generated-framework.png",
   caption:"제거할 `FlutterGeneratedPluginSwiftPackage`" %}

8. **Product > Scheme > Edit Scheme**으로 이동합니다.

9. 왼쪽 사이드바에서 **Build** 섹션을 확장합니다.

10. **Pre-actions**을 클릭합니다.

11. **Run Prepare Flutter Framework Script**을 확장합니다.

12. **<span class="material-symbols">delete</span>** 를 클릭합니다.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/remove-flutter-pre-action.png",
   caption:"제거하기 위한 빌드 사전 작업(pre-action)" %}

[Turn off Swift Package Manager]: /packages-and-plugins/swift-package-manager/for-app-developers/#how-to-turn-off-swift-package-manager

## 더 높은 OS 버전이 필요한 Swift Package Manager Flutter 플러그인을 사용하는 방법 {:#how-to-use-a-swift-package-manager-flutter-plugin-that-requires-a-higher-os-version}

Swift Package Flutter Manager 플러그인에 프로젝트보다 높은 OS 버전이 필요한 경우, 다음과 같은 오류가 발생할 수 있습니다.

```plaintext
Target Integrity (Xcode): The package product 'plugin_name_ios' requires minimum platform version 14.0 for the iOS platform, but this target supports 12.0
```

플러그인을 사용하려면, 앱 대상의 **Minimum Deployments**를 늘리세요.

{% render docs/captioned-image.liquid,
image:"development/packages-and-plugins/swift-package-manager/minimum-deployments.png",
caption:"대상의 **Minimum Deployments** 설정" %}
