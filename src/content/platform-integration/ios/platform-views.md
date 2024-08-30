---
# title: Hosting native iOS views in your Flutter app with Platform Views
title: Platform Views를 사용하여 Flutter 앱에서 네이티브 iOS 뷰 호스팅
# short-title: iOS platform-views
short-title: iOS 플랫폼 뷰
# description: Learn how to host native iOS views in your Flutter app with Platform Views.
description: Platform 뷰를 사용하여 Flutter 앱에서 네이티브 iOS 뷰를 호스팅하는 방법을 알아보세요.
---

<?code-excerpt path-base="platform_integration/platform_views"?>

플랫폼 뷰를 사용하면 Flutter 앱에 네이티브 뷰를 임베드할 수 있으므로, 
Dart에서 네이티브 뷰에 변환, 클립 및 불투명도를 적용할 수 있습니다.

이를 통해, 예를 들어, Android 및 iOS SDK의 네이티브 Google Maps를 Flutter 앱 내에서 직접 사용할 수 있습니다.

:::note
이 페이지에서는 Flutter 앱 내에서 자체 네이티브 iOS 뷰를 호스팅하는 방법을 설명합니다. 
Flutter 앱에 네이티브 Android 뷰를 포함하려면, [네이티브 Android 뷰 호스팅][Hosting native Android views]을 참조하세요. 
Flutter 앱에 네이티브 macOS 뷰를 포함하려면, [네이티브 macOS 뷰 호스팅][Hosting native macOS views]을 참조하세요.
:::

[Hosting native Android views]: /platform-integration/android/platform-views
[Hosting native macOS views]: /platform-integration/macos/platform-views

iOS는 하이브리드 구성(Hybrid composition)만 사용하는데, 
이는 네이티브 `UIView`가 뷰 계층 구조에 추가된다는 것을 의미합니다.

iOS에서 플랫폼 뷰를 만들려면, 다음 지침을 따르세요.

## Dart 측에서 {:#on-the-dart-side}

Dart 쪽에서 `Widget`을 만들고 다음 단계에 표시된 대로 빌드 구현을 추가합니다.

Dart 위젯 파일에서, `native_view_example.dart`에 표시된 것과 유사한 변경을 합니다.

<ol>
<li>

다음 import를 추가합니다.

<?code-excerpt "lib/native_view_example_3.dart (import)"?>
```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
```

</li>

<li>

`build()` 메서드를 구현합니다.

<?code-excerpt "lib/native_view_example_3.dart (ios-composition)"?>
```dart
Widget build(BuildContext context) {
  // 이는 플랫폼 측에서 뷰를 등록하는 데 사용됩니다.
  const String viewType = '<platform-view-type>';
  // 플랫폼 측에 매개변수를 전달합니다.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  return UiKitView(
    viewType: viewType,
    layoutDirection: TextDirection.ltr,
    creationParams: creationParams,
    creationParamsCodec: const StandardMessageCodec(),
  );
}
```

</li>
</ol>

자세한 내용은, [`UIKitView`][]에 대한 API 문서를 참조하세요.

[`UIKitView`]: {{site.api}}/flutter/widgets/UiKitView-class.html

## 플랫폼 측에서 {:#on-the-platform-side}

플랫폼 측에서는, Swift 또는 Objective-C를 사용하세요.

{% tabs "darwin-language" %}
{% tab "Swift" %}

팩토리와 플랫폼 뷰를 구현합니다. 
`FLNativeViewFactory`는 플랫폼 뷰를 생성하고, 플랫폼 뷰는 `UIView`에 대한 참조를 제공합니다. 
예를 들어, `FLNativeView.swift`:

```swift
import Flutter
import UIKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

    /// 이 메서드를 구현하는 것은 `createWithFrame`의 `arguments`가 `nil`이 아닌 경우에만 필요합니다.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // iOS 뷰는 여기에서 생성할 수 있습니다.
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        _view.backgroundColor = UIColor.blue
        let nativeLabel = UILabel()
        nativeLabel.text = "Native text from iOS"
        nativeLabel.textColor = UIColor.white
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        _view.addSubview(nativeLabel)
    }
}
```

마지막으로, 플랫폼 뷰를 등록합니다. 이는 앱이나 플러그인에서 수행할 수 있습니다.

앱 등록의 경우, 앱의 `AppDelegate.swift`를 수정합니다.

```swift
import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        guard let pluginRegistrar = self.registrar(forPlugin: "plugin-name") else { return false }

        let factory = FLNativeViewFactory(messenger: pluginRegistrar.messenger())
        pluginRegistrar.register(
            factory,
            withId: "<platform-view-type>")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

플러그인 등록을 위해, 플러그인의 메인 파일을 수정합니다. (예: `FLPlugin.swift`)

```swift
import Flutter
import UIKit

class FLPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = FLNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "<platform-view-type>")
    }
}
```

{% endtab %}
{% tab "Objective-C" %}

Objective-C에서, 팩토리와 플랫폼 뷰의 헤더를 추가합니다.
예를 들어, `FLNativeView.h`에 표시된 대로:

```objc
#import <Flutter/Flutter.h>

@interface FLNativeViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

@interface FLNativeView : NSObject <FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;
@end
```

팩토리와 플랫폼 뷰를 구현합니다. 
`FLNativeViewFactory`는 플랫폼 뷰를 생성하고, 
플랫폼 뷰는 `UIView`에 대한 참조를 제공합니다. 
예를 들어, `FLNativeView.m`:

```objc
#import "FLNativeView.h"

@implementation FLNativeViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  return [[FLNativeView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

/// 이 메서드를 구현하는 것은 `createWithFrame`의 `arguments`가 `nil`이 아닌 경우에만 필요합니다.
- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end

@implementation FLNativeView {
   UIView *_view;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
    _view = [[UIView alloc] init];
  }
  return self;
}

- (UIView*)view {
  return _view;
}

@end
```

마지막으로, 플랫폼 뷰를 등록합니다. 이는 앱이나 플러그인에서 수행할 수 있습니다.

앱 등록의 경우, 앱의 `AppDelegate.m`을 수정합니다.

```objc
#import "AppDelegate.h"
#import "FLNativeView.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

   NSObject<FlutterPluginRegistrar>* registrar =
      [self registrarForPlugin:@"plugin-name"];

  FLNativeViewFactory* factory =
      [[FLNativeViewFactory alloc] initWithMessenger:registrar.messenger];

  [[self registrarForPlugin:@"<plugin-name>"] registerViewFactory:factory
                                                          withId:@"<platform-view-type>"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
```

플러그인 등록을 위해, 메인 플러그인 파일을 수정합니다. (예: `FLPlugin.m`)

```objc
#import <Flutter/Flutter.h>
#import "FLNativeView.h"

@interface FLPlugin : NSObject<FlutterPlugin>
@end

@implementation FLPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FLNativeViewFactory* factory =
      [[FLNativeViewFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:factory withId:@"<platform-view-type>"];
}

@end
```

{% endtab %}
{% endtabs %}

자세한 내용은 다음 API 문서를 참조하세요.

* [`FlutterPlatformViewFactory`][]
* [`FlutterPlatformView`][]
* [`PlatformView`][]

[`FlutterPlatformView`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view-p.html
[`FlutterPlatformViewFactory`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view_factory-p.html
[`PlatformView`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformView.html

## 함께 모으기 {:#putting-it-together}

Dart에서 `build()` 메서드를 구현할 때, 
[`defaultTargetPlatform`][]을 사용하여 플랫폼을 감지하고, 어떤 위젯을 사용할지 결정할 수 있습니다.

<?code-excerpt "lib/native_view_example_3.dart (together-widget)"?>
```dart
Widget build(BuildContext context) {
  // 이는 플랫폼 측에서 뷰를 등록하는 데 사용됩니다.
  const String viewType = '<platform-view-type>';
  // 플랫폼 측에 매개변수를 전달합니다.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    // Android에서 위젯을 반환합니다.
    case TargetPlatform.iOS:
    // iOS에서 위젯을 반환합니다.
    case TargetPlatform.macOS:
    // macOS에서 위젯을 반환합니다.
    default:
      throw UnsupportedError('Unsupported platform view');
  }
}
```

## 성능 {:#performance}

Flutter의 플랫폼 뷰는 성능 트레이드 오프가 따릅니다.

예를 들어, 일반적인 Flutter 앱에서, Flutter UI는 전용 래스터 스레드에서 구성됩니다. 
이를 통해 Flutter 앱은 빠르게 실행될 수 있는데, 메인 플랫폼 스레드가 거의 차단되지 않기 때문입니다.

하이브리드 구성으로 플랫폼 뷰를 렌더링하면, Flutter UI가 플랫폼 스레드에서 구성됩니다. 
플랫폼 스레드는 OS 또는 플러그인 메시지 처리와 같은 다른 작업과 경쟁합니다.

iOS PlatformView가 화면에 표시되면, 렌더링 janks를 방지하기 위해, 화면 새로 고침 빈도가 80fps로 제한됩니다.

복잡한 경우, 성능 문제를 완화하는 데 사용할 수 있는 몇 가지 기술이 있습니다.

예를 들어, Dart에서 애니메이션이 실행되는 동안 플레이스홀더 텍스처를 사용할 수 있습니다. 
즉, 플랫폼 뷰가 렌더링되는 동안 애니메이션이 느리면, 기본 뷰의 스크린샷을 찍어 텍스처로 렌더링하는 것을 고려하세요.

## 구성 제한 사항 {:#composition-limitations}

iOS 플랫폼 뷰를 구성할 때 몇 가지 제한이 있습니다.

- [`ShaderMask`][] 및 [`ColorFiltered`][] 위젯은 지원되지 않습니다.
- [`BackdropFilter`][] 위젯은 지원되지만 사용 방법에 몇 가지 제한이 있습니다. 자세한 내용은 [iOS 플랫폼 뷰 배경 필터 흐림 디자인 문서][design-doc]를 확인하세요.

[`ShaderMask`]: {{site.api}}/flutter/foundation/ShaderMask.html
[`ColorFiltered`]: {{site.api}}/flutter/foundation/ColorFiltered.html
[`BackdropFilter`]: {{site.api}}/flutter/foundation/BackdropFilter.html
[`defaultTargetPlatform`]: {{site.api}}/flutter/foundation/defaultTargetPlatform.html
[design-doc]: {{site.main-url}}/go/ios-platformview-backdrop-filter-blur

