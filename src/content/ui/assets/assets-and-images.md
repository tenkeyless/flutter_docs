---
# title: Adding assets and images
title: assets 및 이미지 추가
# description: How to use images (and other assets) in your Flutter app.
description: Flutter 앱에서 이미지(및 기타 assets)를 사용하는 방법.
# short-title: Assets and images
short-title: Assets 및 이미지
---

<?code-excerpt path-base="ui/assets_and_images/lib"?>

플러터 앱은 코드와 _assets_ (때로는 리소스라고도 함)을 모두 포함할 수 있습니다. 
asset은 앱과 함께 번들로 제공되고 배포되는 파일이며, 런타임에 액세스할 수 있습니다. 
일반적인 타입의 자산에는 static 데이터(예: JSON 파일), 구성 파일, 아이콘 및 이미지
(JPEG, WebP, GIF, 애니메이션 WebP/GIF, PNG, BMP 및 WBMP)가 포함됩니다.

## assets 지정 {:#specifying-assets}

Flutter는 프로젝트의 루트에 있는 [`pubspec.yaml`][] 파일을 사용하여 앱에 필요한 assets을 식별합니다.

다음은 예입니다.

```yaml
flutter:
  assets:
    - assets/my_icon.png
    - assets/background.png
```

디렉토리 아래의 모든 assets을 포함하려면, 디렉토리 이름 끝에 `/` 문자를 지정합니다.

```yaml
flutter:
  assets:
    - directory/
    - directory/subdirectory/
```

:::note
디렉토리에 직접 위치한 파일만 포함됩니다. 
[해상도 인식 asset 이미지 변형](#resolution-aware)은 유일한 예외입니다. 
하위 디렉토리에 있는 파일을 추가하려면, 디렉토리당 엔트리를 만듭니다.
:::

### Asset 번들링 {:#asset-bundling}

`flutter` 섹션의 `assets` 하위 섹션은 앱에 포함되어야 하는 파일을 지정합니다. 
각 asset은 asset 파일이 있는 명시적 경로(`pubspec.yaml` 파일 기준 상대적 경로)로 식별됩니다. 
assets이 선언되는 순서는 중요하지 않습니다. 
사용된 실제 디렉토리 이름(첫 번째 예에서는 `assets`, 위의 예에서는 `directory`)은 중요하지 않습니다.

빌드하는 동안, Flutter는 앱이 런타임에 읽는 _asset bundle_ 이라는 특수 아카이브에 assets을 저장합니다.

### 빌드 시에 asset 파일의 자동 변환 {:#automatic-transformation-of-asset-files-at-build-time}

Flutter는 앱을 빌드할 때 asset 파일을 변환하기 위해 Dart 패키지를 사용하는 것을 지원합니다. 
이를 위해, pubspec 파일에 asset 파일과 transformer 패키지를 지정합니다. 
이를 수행하고 자체 asset-transforming 패키지를 작성하는 방법을 알아보려면, 
[빌드 시 assets 변환][Transforming assets at build time]을 참조하세요.

### 앱 플레이버에 따른 assets의 조건부 번들링 {:#conditional-bundling-of-assets-based-on-app-flavor}

프로젝트에서 [플레이버 기능][flavors feature]을 활용하는 경우, 
개별 assets을 앱의 특정 플레이버에만 번들로 구성하도록 구성할 수 있습니다. 
자세한 내용은, [플레이버에 따라 assets 조건부 번들링][Conditionally bundling assets based on flavor]을 확인하세요.

## assets 로딩 {:#loading-assets}

앱은 [`AssetBundle`][] 객체를 통해 assets에 액세스할 수 있습니다.

asset 번들의 두 가지 메인 메서드를 사용하면, 
논리적 키(logical key)가 주어진 경우, 
번들에서 문자열/텍스트 asset(`loadString()`) 또는 이미지/바이너리 asset(`load()`)을 로드할 수 있습니다. 
논리적 키는 빌드 시 `pubspec.yaml` 파일에 지정된 asset 경로에 매핑됩니다.

### 텍스트 assets 로딩 {:#loading-text-assets}

각 Flutter 앱에는 메인 asset 번들에 쉽게 액세스할 수 있는 [`rootBundle`][] 객체가 있습니다. 
`package:flutter/services.dart`에서 `rootBundle` 글로벌 static을 사용하여 assets을 직접 로드할 수 있습니다.

그러나, 앱과 함께 빌드된 기본 asset 번들 대신, 
[`DefaultAssetBundle`][]을 사용하여 현재 `BuildContext`에 대한 `AssetBundle`을 가져오는 것이 좋습니다. 
이 접근 방식을 사용하면 부모 위젯이 런타임에 다른 `AssetBundle`을 대체할 수 있어, 
현지화(localization) 또는 테스트 시나리오에 유용할 수 있습니다.

일반적으로, `DefaultAssetBundle.of()`를 사용하여, 
앱의 런타임 `rootBundle`에서 JSON 파일과 같은 asset을 간접적으로 로드합니다.

{% comment %}
  Need example here to show obtaining the AssetBundle for the current
  BuildContext using DefaultAssetBundle.of
{% endcomment %}

`Widget` 컨텍스트 외부에서, 또는 `AssetBundle`에 대한 핸들을 사용할 수 없는 경우, 
`rootBundle`을 사용하여 이러한 assets을 직접 로드할 수 있습니다. 예를 들어:

<?code-excerpt "main.dart (root-bundle-load)"?>
```dart
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}
```

### 이미지 로딩 {:#loading-images}

이미지를 로드하려면, 위젯의 `build()` 메서드에서 [`AssetImage`][] 클래스를 사용합니다.

예를 들어, 앱은 이전 예제의 asset 선언에서 배경 이미지를 로드할 수 있습니다.

<?code-excerpt "main.dart (background-image)"?>
```dart
return const Image(image: AssetImage('assets/background.png'));
```

### 해상도 인식 이미지 assets {:#resolution-aware}

Flutter는 현재 [기기 픽셀 비율][device pixel ratio]에 적합한 해상도 이미지를 로드할 수 있습니다.

[`AssetImage`][]는 논리적으로 요청된 asset을 
현재 [기기 픽셀 비율][device pixel ratio]과 가장 일치하는 asset에 매핑합니다.

이 매핑이 작동하려면, assets을 특정 디렉토리 구조에 따라 정렬해야 합니다.

```plaintext
.../image.png
.../Mx/image.png
.../Nx/image.png
...etc.
```

여기서 _M_ 과 _N_ 은 포함된 이미지의 명목 해상도(nominal resolution)에 해당하는 숫자 식별자입니다. 
즉, 이미지가 의도된 장치 픽셀 비율(device pixel ratio)을 지정합니다.

이 예에서, `image.png`는 *주요 자산(main asset)* 으로 간주되고, 
`Mx/image.png`와 `Nx/image.png`는 *변형(variants)* 으로 간주됩니다.

주요 asset은 해상도 1.0에 해당하는 것으로 가정합니다. 
예를 들어, `my_icon.png`라는 이미지에 대한 다음 asset 레이아웃을 고려합니다.

```plaintext
.../my_icon.png       (mdpi baseline)
.../1.5x/my_icon.png  (hdpi)
.../2.0x/my_icon.png  (xhdpi)
.../3.0x/my_icon.png  (xxhdpi)
.../4.0x/my_icon.png  (xxxhdpi)
```

기기 픽셀 비율이 1.8인 기기에서는, asset `.../2.0x/my_icon.png`가 선택됩니다. 
기기 픽셀 비율이 2.7인 경우, asset `.../3.0x/my_icon.png`가 선택됩니다.

렌더링된 이미지의 너비와 높이가 `Image` 위젯에 지정되지 않은 경우, 
명목 해상도를 사용하여 asset의 크기를 조정하여 메인 asset과 동일한 화면 공간을 차지하지만 해상도는 더 높습니다. 
즉, `.../my_icon.png`가 72px x 72px인 경우 `.../3.0x/my_icon.png`는 216px x 216px여야 하지만, 
너비와 높이가 지정되지 않은 경우 둘 다 72px x 72px(논리적 픽셀)로 렌더링됩니다.

:::note
[장치 픽셀 비율][Device pixel ratio]은 [MediaQueryData.size][]에 따라 달라지며, 
이를 위해서는 [`AssetImage`][]의 조상으로, [MaterialApp][] 또는 [CupertinoApp][]이 필요합니다.
:::

#### 해상도 인식 이미지 assets 번들링 {:#resolution-aware-bundling}

`pubspec.yaml`의 `assets` 섹션에서 메인 asset이나 상위 디렉토리만 지정하면 됩니다. 
Flutter가 변형을 번들로 제공합니다. 
각 엔트리는 메인 asset 엔트리를 제외하고, 실제 파일에 해당해야 합니다. 
메인 asset 엔트리가 실제 파일에 해당하지 않으면, 
해상도가 가장 낮은 asset이 해당 해상도보다 낮은 기기 픽셀 비율을 가진 기기의 대체 항목으로 사용됩니다. 
그러나, 엔트리는 여전히 ​​`pubspec.yaml` 매니페스트에 포함되어야 합니다.

기본 asset 번들을 사용하는 모든 것은 이미지를 로드할 때 해상도 인식을 상속합니다. 
([`ImageStream`][] 또는 [`ImageCache`][]와 같은 낮은 레벨 클래스로 작업하는 경우, 
스케일과 관련된 매개변수도 알 수 있습니다.)

### 패키지 종속성의 assets 이미지 {:#from-packages}

[package][] 종속성에서 이미지를 로드하려면, `package` 인수를 [`AssetImage`][]에 제공해야 합니다.

예를 들어, 애플리케이션이 다음과 같은 디렉토리 구조를 가진 `my_icons`라는 패키지에 종속되어 있다고 가정해 보겠습니다.

```plaintext
.../pubspec.yaml
.../icons/heart.png
.../icons/1.5x/heart.png
.../icons/2.0x/heart.png
...etc.
```

이미지를 로드하려면 다음을 사용하세요.

<?code-excerpt "main.dart (package-image)"?>
```dart
return const AssetImage('icons/heart.png', package: 'my_icons');
```

패키지 자체에서 사용되는 assets도 위와 같이 `package` 인수를 사용하여 가져와야 합니다.

#### 패키지 assets 번들링 {:#bundling-of-package-assets}

원하는 에셋이 패키지의 `pubspec.yaml` 파일에 지정되어 있으면, 애플리케이션과 함께 자동으로 번들로 묶입니다. 
특히, 패키지 자체에서 사용하는 assets은 `pubspec.yaml`에 지정해야 합니다.

패키지는 `pubspec.yaml` 파일에 지정되지 않은 assets을 `lib/` 폴더에 포함하도록 선택할 수도 있습니다. 
이 경우, 번들로 묶을 이미지에 대해, 애플리케이션은 `pubspec.yaml`에 포함할 이미지를 지정해야 합니다. 
예를 들어, `fancy_backgrounds`라는 패키지에는 다음 파일이 있을 수 있습니다.

```plaintext
.../lib/backgrounds/background1.png
.../lib/backgrounds/background2.png
.../lib/backgrounds/background3.png
```

예를 들어, 첫 번째 이미지를 포함하려면, 애플리케이션의 `pubspec.yaml`에서 `assets` 섹션에 이를 지정해야 합니다.

```yaml
flutter:
  assets:
    - packages/fancy_backgrounds/backgrounds/background1.png
```

`lib/`는 암묵적으로 포함되므로, asset 경로에 포함되어서는 안 됩니다.

패키지를 개발하는 경우, 패키지 내에서 자산을 로드하려면, 패키지의 `pubspec.yaml`에 지정하세요.

```yaml
flutter:
  assets:
    - assets/images/
```

패키지 내에서 이미지를 로드하려면 다음을 사용하세요.

```dart
return const AssetImage('packages/fancy_backgrounds/backgrounds/background1.png');
```

## 기반 플랫폼과 assets 공유 {:#sharing-assets-with-the-underlying-platform}

Flutter assets은 Android의 `AssetManager`, iOS의 `NSBundle`을 사용하여 플랫폼 코드에서 쉽게 사용할 수 있습니다.

### Android에서 Flutter assets 로딩 {:#loading-flutter-assets-in-android}

Android에서 assets은 [`AssetManager`][] API를 통해 사용할 수 있습니다. 
예를 들어 [`openFd`][]에서 사용된 조회 키(lookup key)는, 
[`PluginRegistry.Registrar`][]의 `lookupKeyForAsset` 또는 
[`FlutterView`][]의 `getLookupKeyForAsset`에서 가져옵니다. 
`PluginRegistry.Registrar`는 플러그인을 개발할 때 사용할 수 있는 반면, 
`FlutterView`는 플랫폼 뷰를 포함하는 앱을 개발할 때 선택할 수 있습니다.

예를 들어, pubspec.yaml에서 다음을 지정했다고 가정해 보겠습니다.

```yaml
flutter:
  assets:
    - icons/heart.png
```

이는 Flutter 앱의 다음 구조를 반영합니다.

```plaintext
.../pubspec.yaml
.../icons/heart.png
...etc.
```

Java 플러그인 코드에서 `icons/heart.png`에 액세스하려면 다음을 수행하세요.

```java
AssetManager assetManager = registrar.context().getAssets();
String key = registrar.lookupKeyForAsset("icons/heart.png");
AssetFileDescriptor fd = assetManager.openFd(key);
```

### iOS에서 Flutter assets 로딩 {:#loading-flutter-assets-in-ios}

iOS에서 assets은 [`mainBundle`][]을 통해 사용할 수 있습니다. 
예를 들어 [`pathForResource:ofType:`][]에서 사용된 조회 키는, 
[`FlutterPluginRegistrar`][]의 `lookupKeyForAsset` 또는 `lookupKeyForAsset:fromPackage:`에서 가져오거나, 
[`FlutterViewController`][]의 `lookupKeyForAsset:` 또는 `lookupKeyForAsset:fromPackage:`에서 가져옵니다. 
`FlutterPluginRegistrar`는 플러그인을 개발할 때 사용할 수 있는 반면, 
`FlutterViewController`는 플랫폼 뷰를 포함하는 앱을 개발할 때 선택할 수 있습니다.

예를 들어, 위의 Flutter 설정이 있다고 가정해 보겠습니다.

Objective-C 플러그인 코드에서 `icons/heart.png`에 액세스하려면, 다음을 수행합니다.

```objc
NSString* key = [registrar lookupKeyForAsset:@"icons/heart.png"];
NSString* path = [[NSBundle mainBundle] pathForResource:key ofType:nil];
```

Swift 앱에서 `icons/heart.png`에 액세스하려면 다음을 수행합니다.

```swift
let key = controller.lookupKey(forAsset: "icons/heart.png")
let mainBundle = Bundle.main
let path = mainBundle.path(forResource: key, ofType: nil)
```

더 완전한 예를 보려면, pub.dev에서 Flutter [`video_player` 플러그인][`video_player` plugin]의 구현을 참조하세요.

pub.dev의 [`ios_platform_images`][] 플러그인은 이 논리를 convenient 카테고리로로 묶습니다. 
다음과 같이 이미지를 가져옵니다.

**Objective-C:**
```objc
[UIImage flutterImageWithName:@"icons/heart.png"];
```

**Swift:**
```swift
UIImage.flutterImageNamed("icons/heart.png")
```

### Flutter에서 iOS 이미지 로딩 {:#loading-ios-images-in-flutter}

[기존 iOS 앱에 추가][add-to-app]하여 Flutter를 구현할 때, 
Flutter에서 사용하려는 iOS에 호스팅된 이미지가 있을 수 있습니다. 
이를 달성하려면 pub.dev에서 제공되는 [`ios_platform_images`][] 플러그인을 사용하세요.

## 플랫폼 assets {:#platform-assets}

플랫폼 프로젝트에서 assets을 직접 작업할 수 있는 다른 경우가 있습니다. 
아래는 Flutter 프레임워크가 로드되고 실행되기 전에 assets이 사용되는 두 가지 일반적인 사례입니다.

### 앱 아이콘 업데이트 {:#updating-the-app-icon}

Flutter 애플리케이션의 시작 아이콘을 업데이트하는 방식은, 
기본 Android나 iOS 애플리케이션의 시작 아이콘을 업데이트하는 방식과 같습니다.

![Launch icon](/assets/images/docs/assets-and-images/icon.png)

#### Android {:#android}

Flutter 프로젝트의 루트 디렉토리에서 `.../android/app/src/main/res`로 이동합니다. 
`mipmap-hdpi`와 같은 다양한 비트맵 리소스 폴더에는 이미 `ic_launcher.png`라는 이름의 플레이스홀더 이미지가 포함되어 있습니다. 
[Android 개발자 가이드][Android Developer Guide]에서 표시한 대로, 
화면 밀도당 권장 아이콘 크기를 준수하여 원하는 assets으로 대체합니다.

![Android icon location](/assets/images/docs/assets-and-images/android-icon-path.png)

:::note
`.png` 파일의 이름을 바꾸는 경우, 
`AndroidManifest.xml`의 `<application>` 태그의 `android:icon` 속성에서도 해당 이름을 업데이트해야 합니다.
:::

#### iOS {:#ios}

Flutter 프로젝트의 루트 디렉토리에서 `.../ios/Runner`로 이동합니다. 
`Assets.xcassets/AppIcon.appiconset` 디렉토리에는 이미 플레이스홀더 이미지가 포함되어 있습니다. 
Apple [Human Interface Guidelines][]에서 지시한 대로, 
파일 이름에 표시된 대로 적절한 크기의 이미지로 대체합니다. 
원래 파일 이름을 유지합니다.

![iOS icon location](/assets/images/docs/assets-and-images/ios-icon-path.png)

### 시작 화면 업데이트 {:#updating-the-launch-screen}

<p align="center">
  <img src="/assets/images/docs/assets-and-images/launch-screen.png" alt="Launch screen" />
</p>

Flutter는 또한 Flutter 프레임워크가 로드되는 동안, 
Flutter 앱에 전환형 시작 화면을 그리기 위해 네이티브 플랫폼 메커니즘을 사용합니다. 
이 시작 화면은 Flutter가 애플리케이션의 첫 번째 프레임을 렌더링할 때까지 지속됩니다.

:::note
이는 앱의 `main()` 함수에서 [`runApp()`][]을 호출하지 않으면,
(또는 보다 구체적으로 [`PlatformDispatcher.onDrawFrame`][]에 대한 응답으로 [`FlutterView.render()`][]를 호출하지 않으면),
시작 화면이 영원히 지속됨을 의미합니다.
:::

[`FlutterView.render()`]: {{site.api}}/flutter/dart-ui/FlutterView/render.html
[`PlatformDispatcher.onDrawFrame`]: {{site.api}}/flutter/dart-ui/PlatformDispatcher/onDrawFrame.html

#### Android {:#android-1}

Flutter 애플리케이션에 시작 화면(일명 "스플래시 화면")을 추가하려면, `.../android/app/src/main`으로 이동합니다. 
`res/drawable/launch_background.xml`에서 이 [레이어 리스트 drawable][layer list drawable] XML을 사용하여 시작 화면의 모양을 커스터마이즈 합니다. 
기존 템플릿은 주석 처리된 코드에서 흰색 시작 화면 중앙에 이미지를 추가하는 예를 제공합니다. 
주석 처리를 해제하거나 다른 [drawables][]를 사용하여 의도한 효과를 얻을 수 있습니다.

자세한 내용은, [Android 앱에 시작 화면 추가][Adding a splash screen to your Android app]를 참조하세요.

#### iOS {:#ios-1}

"스플래시 화면" 중앙에 이미지를 추가하려면, `.../ios/Runner`로 이동합니다. 
`Assets.xcassets/LaunchImage.imageset`에서, 
`LaunchImage.png`, `LaunchImage@2x.png`, `LaunchImage@3x.png`라는 이름의 이미지를 놓습니다. 
다른 파일 이름을 사용하는 경우, 같은 디렉토리에 있는 `Contents.json` 파일을 업데이트합니다.

`.../ios/Runner.xcworkspace`를 열어 Xcode에서 런치 화면 스토리보드를 완전히 커스터마이즈 할 수도 있습니다. 
Project Navigator에서 `Runner/Runner`로 이동하여, 
`Assets.xcassets`를 열어 이미지를 놓거나, 
`LaunchScreen.storyboard`에서 인터페이스 빌더를 사용하여 커스터마이즈를 수행합니다.

![Adding launch icons in Xcode](/assets/images/docs/assets-and-images/ios-launchscreen-xcode.png){:width="100%"}

자세한 내용은 [iOS 앱에 시작 화면 추가][Adding a splash screen to your iOS app]를 참조하세요.


[add-to-app]: /add-to-app/ios
[Adding a splash screen to your Android app]: /platform-integration/android/splash-screen
[Adding a splash screen to your iOS app]: /platform-integration/ios/splash-screen
[`AssetBundle`]: {{site.api}}/flutter/services/AssetBundle-class.html
[`AssetImage`]: {{site.api}}/flutter/painting/AssetImage-class.html
[`DefaultAssetBundle`]: {{site.api}}/flutter/widgets/DefaultAssetBundle-class.html
[`ImageCache`]: {{site.api}}/flutter/painting/ImageCache-class.html
[`ImageStream`]: {{site.api}}/flutter/painting/ImageStream-class.html
[Android Developer Guide]: {{site.android-dev}}/training/multiscreen/screendensities
[`AssetManager`]: {{site.android-dev}}/reference/android/content/res/AssetManager
[device pixel ratio]: {{site.api}}/flutter/dart-ui/FlutterView/devicePixelRatio.html
[Device pixel ratio]: {{site.api}}/flutter/dart-ui/FlutterView/devicePixelRatio.html
[drawables]: {{site.android-dev}}/guide/topics/resources/drawable-resource
[`FlutterPluginRegistrar`]: {{site.api}}/ios-embedder/protocol_flutter_plugin_registrar-p.html
[`FlutterView`]: {{site.api}}/javadoc/io/flutter/view/FlutterView.html
[`FlutterViewController`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html
[Human Interface Guidelines]: {{site.apple-dev}}/design/human-interface-guidelines/app-icons
[`ios_platform_images`]: {{site.pub}}/packages/ios_platform_images
[layer list drawable]: {{site.android-dev}}/guide/topics/resources/drawable-resource#LayerList
[`mainBundle`]: {{site.apple-dev}}/documentation/foundation/nsbundle/1410786-mainbundle
[`openFd`]: {{site.android-dev}}/reference/android/content/res/AssetManager#openFd(java.lang.String)
[package]: /packages-and-plugins/using-packages
[`pathForResource:ofType:`]: {{site.apple-dev}}/documentation/foundation/nsbundle/1410989-pathforresource
[`PluginRegistry.Registrar`]: {{site.api}}/javadoc/io/flutter/plugin/common/PluginRegistry.Registrar.html
[`pubspec.yaml`]: {{site.dart-site}}/tools/pub/pubspec
[`rootBundle`]: {{site.api}}/flutter/services/rootBundle.html
[`runApp()`]: {{site.api}}/flutter/widgets/runApp.html
[`video_player` plugin]: {{site.pub}}/packages/video_player
[MediaQueryData.size]: {{site.api}}/flutter/widgets/MediaQueryData/size.html
[MaterialApp]: {{site.api}}/flutter/material/MaterialApp-class.html
[CupertinoApp]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[Transforming assets at build time]: /ui/assets/asset-transformation
[Conditionally bundling assets based on flavor]: /deployment/flavors#conditionally-bundling-assets-based-on-flavor
[flavors feature]: /deployment/flavors
