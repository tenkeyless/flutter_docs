---
# title: Create flavors of a Flutter app
title: Flutter 앱의 플레이버 만들기
# short-title: Flavors
short-title: 플레이버(Flavors)
# description: >
#   How to create build flavors specific to different
#   release types or development environments.
description: >
  다양한 릴리스 타입이나 개발 환경에 맞는 빌드 플레이버를 만드는 방법.
---

## 플레이버란 무엇인가요? {:#what-are-flavors}

Flutter 앱에서 다양한 환경을 설정하는 방법에 대해 궁금해 본 적이 있나요? 
플레이버(iOS 및 macOS에서 _빌드 구성(build configurations)_ 이라고 함)를 사용하면, 
개발자가 동일한 코드 베이스를 사용하여 앱에 대해 별도의 환경을 만들 수 있습니다. 
예를 들어, 본격적인 프로덕션 앱에 대한 플레이버 하나, 
제한된 "무료" 앱으로 다른 플레이버 하나, 실험적 기능을 테스트하는 플레이버 하나 등을 사용할 수 있습니다.

Flutter 앱의 무료 및 유료 버전을 모두 만들고 싶다고 가정해 보겠습니다. 
두 개의 별도 앱을 작성하지 않고도, 플레이버를 사용하여 두 앱 버전을 설정할 수 있습니다. 
예를 들어, 앱의 무료 버전에는 기본 기능과 광고가 있습니다. 
반면, 유료 버전에는 기본 앱 기능, 추가 기능, 유료 사용자를 위한 다양한 스타일, 광고 없음이 있습니다.

기능 개발에도 플레이버를 사용할 수 있습니다. 
새 기능을 빌드하고 시도해 보고 싶다면, 플레이버를 설정하여 테스트할 수 있습니다. 
새 기능을 배포할 준비가 될 때까지, 프로덕션 코드는 영향을 받지 않습니다.

플레이버를 사용하면 컴파일 타임 구성을 정의하고, 
런타임에 읽히는 매개변수를 설정하여 앱의 동작을 커스터마이즈 할 수 있습니다.

이 문서는 iOS, macOS 및 Android용 Flutter 플레이버를 설정하는 방법을 안내합니다.

## 환경 설정 {:#environment-set-up}

필수 조건:

* Xcode 설치
* 기존 Flutter 프로젝트

iOS 및 macOS에서 플레이버를 설정하려면, Xcode에서 빌드 구성을 정의합니다.

## iOS 및 macOS에서 플레이버 만들기 {:#creating-flavors-in-ios-and-macos}

<ol>
<li>

Xcode에서 프로젝트를 엽니다.

</li>
<li>

메뉴에서 **Product** > **Scheme** > **New Scheme**을 선택하여 새 `Scheme`을 추가합니다.

* 스킴은 Xcode가 다양한 작업을 실행하는 방식을 설명합니다. 
  이 가이드의 목적을 위해, 예제 _flavor_ 와 _scheme_ 은 `free`로 명명되었습니다. 
  `free` 스킴의 빌드 구성에는 `-free` 접미사가 붙습니다.

</li>
<li>

이미 사용 가능한 기본 구성과 `free` 스키마의 새 구성을 구분하기 위해, 빌드 구성을 복제합니다.

* **Configurations** 드롭다운 리스트의 끝에 있는 **Info** 탭에서, 더하기 버튼을 클릭하고, 
  각 구성 이름(Debug, Release 및 Profile)을 복제합니다. 각 환경에 대해 한 번씩 기존 구성을 복제합니다.

![Step 3 Xcode image](/assets/images/docs/flavors/step3-ios-build-config.png){:width="100%"}

:::note
구성(configurations)은 **Pods-Runner.xcconfigs**가 아닌, 
**Debug.xconfig** 또는 **Release.xcconfig** 파일을 기반으로 해야 합니다. 
구성 이름을 확장하여 확인할 수 있습니다.
:::

</li>
<li>

free 플레이버와 맞추려면, 각각의 새로운 구성 이름 끝에 `-free`를 추가합니다.

</li>
<li>

`free` 스킴을 이미 생성된 빌드 구성과 일치하도록 변경합니다.

* **Runner** 프로젝트에서, **Manage Schemes…** 를 클릭하면 팝업 창이 열립니다.
* free 스킴을 두 번 클릭합니다. 
  다음 단계(스크린샷에 표시된 대로)에서, 각 스킴을 수정하여 free 빌드 구성과 일치시킵니다.

![Step 5 Xcode image](/assets/images/docs/flavors/step-5-ios-scheme-free.png){:width="100%"}

</li>
</ol>

## iOS 및 macOS에서 플레이버 사용 {:#using-flavors-in-ios-and-macos}

이제 free 플레이버를 설정했으므로, 예를 들어, 플레이버마다 다른 제품 번들 식별자를 추가할 수 있습니다. 
_번들 식별자_ 는 애플리케이션을 고유하게 식별합니다. 
이 예에서, 우리는 **Debug-free** 값을 `com.flavor-test.free`와 같게 설정합니다.

<ol>
<li>

앱 번들 식별자를 변경하여 스키마를 구분합니다.
**Product Bundle Identifier**에서, 각 -free 스키마 값에 `.free`를 추가합니다.

![Step 1 using flavors image.](/assets/images/docs/flavors/step-1-using-flavors-free.png){:width="100%"}

</li>
<li>

**Build Settings**에서, **Product Name** 값을 각 플레이버와 일치하도록 설정합니다. 
예를 들어, Debug Free를 추가합니다.

![Step 2 using flavors image.](/assets/images/docs/flavors/step-2-using-flavors-free.png){:width="100%"}

</li>
<li>

**Info.plist**에 표시 이름을 추가합니다. 
**Bundle Display Name** 값을 `$(PRODUCT_NAME)`로 업데이트합니다.

![Step 3 using flavors image.](/assets/images/docs/flavors/step3-using-flavors.png){:width="100%"}

</li>
</ol>

이제 Xcode에서 `free` 스킴을 만들고, 해당 스킴에 대한 빌드 구성을 설정하여 플레이버를 설정했습니다.

자세한 내용은, 이 문서의 끝에 있는 [앱 플레이버 시작][Launching your app flavors] 섹션으로 건너뛰세요.

### 플러그인 구성 {:#plugin-configurations}

앱이 Flutter 플러그인을 사용하는 경우, 
`ios/Podfile`(iOS용으로 개발하는 경우) 및 `macos/Podfile`(macOS용으로 개발하는 경우)을 업데이트해야 합니다.

1. `ios/Podfile` 및 `macos/Podfile`에서, 
   `free` 스킴에 대한 Xcode 빌드 구성과 일치하도록,
   **Debug**, **Profile** 및 **Release**의 기본값을 변경합니다.

```ruby
project 'Runner', {
  'Debug-free' => :debug,
  'Profile-free' => :release,
  'Release-free' => :release,
}
```

## Android에서 플레이버 사용 {:#using-flavors-in-android}

Android에서 플레이버를 설정하는 작업은 프로젝트의 **build.gradle** 파일에서 수행할 수 있습니다.

1. Flutter 프로젝트 내에서, **android**/**app**/**build.gradle**로 이동합니다.

1. 추가한 제품 플레이버를 그룹화하기 위해 [`flavorDimension`][]을 만듭니다. 
   Gradle은 동일한 `dimension`을 공유하는 제품 플레이버를 결합하지 않습니다.

2. 원하는 플레이버와 함께 다음의 값을 포함하는 `productFlavors` 객체를 추가합니다.
   **dimension**, **resValue**, **applicationId** 또는 **applicationIdSuffix** 

   * 각 빌드의 애플리케이션 이름은 **resValue**에 있습니다.
   * **applicationId** 대신 **applicationIdSuffix**를 지정하면, "base" 애플리케이션 ID에 추가됩니다.

{% tabs "android-build-language" %}
{% tab "Kotlin" %}

```kotlin title="build.gradle.kts"
android {
    // ...
    flavorDimensions += "default"

    productFlavors {
        create("free") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "free flavor example")
            applicationIdSuffix = ".free"
        }
    }
}
```

{% endtab %}
{% tab "Groovy" %}

```groovy title="build.gradle"
android {
    // ...
    flavorDimensions "default"

    productFlavors {
        free {
            dimension "default"
            resValue "string", "app_name", "free flavor example"
            applicationIdSuffix ".free"
        }
    }
}
```

{% endtab %}
{% endtabs %}

[`flavorDimension`]: {{site.android-dev}}/studio/build/build-variants#flavor-dimensions

## 시작(launch) 구성 설정 {:#setting-up-launch-configurations}

다음으로, **launch.json** 파일을 추가합니다. 
이렇게 하면, `flutter run --flavor [environment name]` 명령을 실행할 수 있습니다.

VSCode에서, 다음과 같이 실행 구성을 설정합니다.

1. 프로젝트의 루트 디렉토리에, **.vscode**라는 폴더를 추가합니다.
2. **.vscode** 폴더 내부에, **launch.json**이라는 파일을 만듭니다.
3. **launch.json** 파일에서, 각 플레이버에 대한 구성 객체를 추가합니다. 
   각 구성에는 **name**, **request**, **type**, **program**, **args** 키가 있습니다.

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "free",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_development.dart",
      "args": ["--flavor", "free", "--target", "lib/main_free.dart" ]
    }
  ],
  "compounds": []
}
```

이제 터미널 명령어 `flutter run --flavor free`를 실행하거나 IDE에서 실행 구성을 설정할 수 있습니다.

{% comment %}
TODO: When available, add an app sample.
{% endcomment -%}

## 앱 플레이버 출시 {:#launching-your-app-flavors}

1. 플레이버가 설정되면, **lib** / **main.dart**에 있는 Dart 코드를 수정하여 플레이버를 사용합니다.
2. 명령줄이나 IDE에서 `flutter run --flavor free`를 사용하여 설정을 테스트합니다.

[iOS][], [macOS][], [Android][]에 대한 빌드 플레이버의 예는, 
[Flutter repo][]에서 통합 테스트 샘플을 확인하세요.

## 런타임에 앱의 플레이버 검색 {:#retrieving-your-apps-flavor-at-runtime}

Dart 코드에서, [`appFlavor`][] API를 사용하여 앱이 어떤 플레이버로 빌드되었는지 확인할 수 있습니다.

## 플레이버에 따라 assets을 조건부로 번들링 {:#conditionally-bundling-assets-based-on-flavor}

앱에 assets을 추가하는 방법을 잘 모르는 경우, [자산 및 이미지 추가][Adding assets and images]를 참조하세요.

앱에서 특정 플레이버에서만 사용되는 assets이 있는 경우, 
해당 플레이버를 빌드할 때만 앱에 번들로 포함되도록 구성할 수 있습니다. 
이렇게 하면 사용하지 않는 assets으로 인해 앱 번들 크기가 커지는 것을 방지할 수 있습니다.

다음은 예입니다.

```yaml
flutter:
  assets:
    - assets/common/
    - path: assets/free/
      flavors:
        - free
    - path: assets/premium/
      flavors:
        - premium
```

이 예에서, `assets/common/` 디렉토리 내의 파일은 `flutter run` 또는 `flutter build` 중에 앱이 빌드될 때 항상 번들로 묶입니다. 
`assets/free/` 디렉토리 내의 파일은 `--flavor` 옵션이 `free`로 설정된 경우에만 번들로 묶입니다. 
마찬가지로, `assets/premium` 디렉토리 내의 파일은 `--flavor`가 `premium`으로 설정된 경우에만 번들로 묶입니다.

## 더 많은 정보 {:#more-information}

플레이버 생성 및 사용에 대한 자세한 내용은 다음 리소스를 확인하세요.

* [플레이버당 다른 Firebase 프로젝트로 Flutter(Android 및 iOS)에서 플레이버 빌드 Flutter Ready to Go][Build flavors in Flutter (Android and iOS) with different Firebase projects per flavor Flutter Ready to Go]
* [Flutter 애플리케이션 플레이버(Android 및 iOS)][Flavoring Flutter Applications (Android & iOS)]
* [FlutterFire 및 Very Good CLI를 사용하여 여러 Firebase 환경에서 Flutter 플레이버 설정][Flutter Flavors Setup with multiple Firebase Environments using FlutterFire and Very Good CLI]

### 패키지 {:#packages}

플레이버 생성을 지원하는 패키지는 다음을 확인하세요.

* [`flutter_flavor`][]
* [`flutter_flavorizr`][]

[Launching your app flavors]: /deployment/flavors/#launching-your-app-flavors
[Flutter repo]: {{site.repo.flutter}}/blob/master/dev/integration_tests/flavors/lib/main.dart
[iOS]: {{site.repo.flutter}}/tree/master/dev/integration_tests/flavors/ios
[macOS]: {{site.repo.flutter}}/tree/master/dev/integration_tests/flavors/macos
[iOS (Xcode)]: {{site.repo.flutter}}/tree/master/dev/integration_tests/flavors/ios
[`appFlavor`]: {{site.api}}/flutter/services/appFlavor-constant.html
[Android]: {{site.repo.flutter}}/tree/master/dev/integration_tests/flavors/android
[Adding assets and images]: /ui/assets/assets-and-images
[Build flavors in Flutter (Android and iOS) with different Firebase projects per flavor Flutter Ready to Go]: {{site.medium}}/@animeshjain/build-flavors-in-flutter-android-and-ios-with-different-firebase-projects-per-flavor-27c5c5dac10b
[Flavoring Flutter Applications (Android & iOS)]: {{site.medium}}/flutter-community/flavoring-flutter-applications-android-ios-ea39d3155346
[Flutter Flavors Setup with multiple Firebase Environments using FlutterFire and Very Good CLI]: https://codewithandrea.com/articles/flutter-flavors-for-firebase-apps/
[`flutter_flavor`]: {{site.pub}}/packages/flutter_flavor
[`flutter_flavorizr`]: {{site.pub}}/packages/flutter_flavorizr
