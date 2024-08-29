---
# title: Hosting native macOS views in your Flutter app with Platform Views
title: Platform Views를 사용하여 Flutter 앱에서 네이티브 macOS 뷰 호스팅
# short-title: macOS platform-views
short-title: macOS 플랫폼 뷰
# description: Learn how to host native macOS views in your Flutter app with Platform Views.
description: 플랫폼 뷰를 사용하여 Flutter 앱에서 기본 macOS 뷰를 호스팅하는 방법을 알아보세요.
---

<?code-excerpt path-base="platform_integration/platform_views"?>

플랫폼 뷰를 사용하면 Flutter 앱에 네이티브 뷰를 임베드할 수 있으므로, 
Dart에서 네이티브 뷰에 변환, 클립 및 불투명도를 적용할 수 있습니다.

이를 통해, 예를 들어, Flutter 앱 내에서 네이티브 웹 뷰를 직접 사용할 수 있습니다.

:::note
이 페이지에서는 Flutter 앱 내에서 자체 네이티브 macOS 뷰를 호스팅하는 방법을 설명합니다. 
Flutter 앱에 네이티브 Android 뷰를 포함하려면, [네이티브 Android 뷰 호스팅][Hosting native Android views]을 참조하세요. 
Flutter 앱에 네이티브 iOS 뷰를 포함하려면, [네이티브 iOS 뷰 호스팅][Hosting native iOS views]을 참조하세요.
:::

[Hosting native Android views]: /platform-integration/android/platform-views
[Hosting native iOS views]: /platform-integration/ios/platform-views

:::note 버전 참고
macOS의 플랫폼 뷰 지원은 현재 릴리스에서 완전히 작동하지 않습니다. 
예를 들어, 제스처 지원은 아직 macOS에서 사용할 수 없습니다. 
향후 stable 릴리스를 기대하세요.
:::

macOS는 하이브리드 구성(Hybrid composition)을 사용하는데, 
이는 네이티브 `NSView`가 뷰 계층 구조에 추가된다는 것을 의미합니다.

macOS에서 플랫폼 뷰를 만들려면, 다음 지침을 따르세요.

## Dart 측에서 {:#on-the-dart-side}

On the Dart side, create a `Widget` and add the build implementation, as shown
in the following steps.

In the Dart widget file, make changes similar to those 
shown in `native_view_example.dart`:

<ol>
<li>

Add the following imports:

<?code-excerpt "lib/native_view_example_4.dart (import)"?>
```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
```

</li>

<li>

Implement a `build()` method:

<?code-excerpt "lib/native_view_example_4.dart (macos-composition)"?>
```dart
Widget build(BuildContext context) {
  // This is used in the platform side to register the view.
  const String viewType = '<platform-view-type>';
  // Pass parameters to the platform side.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  return AppKitView(
    viewType: viewType,
    layoutDirection: TextDirection.ltr,
    creationParams: creationParams,
    creationParamsCodec: const StandardMessageCodec(),
  );
}
```

</li>
</ol>

For more information, see the API docs for: [`AppKitView`][].

[`AppKitView`]: {{site.api}}/flutter/widgets/AppKitView-class.html

## 플랫폼 측에서 {:#on-the-platform-side}

Implement the factory and the platform view. The `NativeViewFactory` creates the
platform view, and the platform view provides a reference to the `NSView`. For
example, `NativeView.swift`:

```swift
import Cocoa
import FlutterMacOS

class NativeViewFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withViewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> NSView {
    return NativeView(
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: messenger)
  }

  /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
  public func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol)? {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class NativeView: NSView {

  init(
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger?
  ) {
    super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    wantsLayer = true
    layer?.backgroundColor = NSColor.systemBlue.cgColor
    // macOS views can be created here
    createNativeView(view: self)
  }
    
    required init?(coder nsCoder: NSCoder) {
        super.init(coder: nsCoder)
    }
    
  func createNativeView(view _view: NSView) {
    let nativeLabel = NSTextField()
    nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
    nativeLabel.stringValue = "Native text from macOS"
    nativeLabel.textColor = NSColor.black
    nativeLabel.font = NSFont.systemFont(ofSize: 14)
    nativeLabel.isBezeled = false
    nativeLabel.focusRingType = .none
    nativeLabel.isEditable = true
    nativeLabel.sizeToFit()
    _view.addSubview(nativeLabel)
  }
}

```

Finally, register the platform view. This can be done in an app or a plugin.

For app registration, modify the App's `MainFlutterWindow.swift`:

```swift
import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    // ...

    let registrar = flutterViewController.registrar(forPlugin: "plugin-name")
    let factory = NativeViewFactory(messenger: registrar.messenger)
    registrar.register(
      factory,
      withId: "<platform-view-type>")
  }
}
```

For plugin registration, modify the plugin's main file (for example,
`Plugin.swift`):

```swift
import Cocoa
import FlutterMacOS

public class Plugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = NativeViewFactory(messenger: registrar.messenger)
    registrar.register(factory, withId: "<platform-view-type>")
  }
}
```

For more information, see the API docs for:

* [`FlutterPlatformViewFactory`][]
* [`FlutterPlatformView`][]
* [`PlatformView`][]

[`FlutterPlatformView`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view-p.html
[`FlutterPlatformViewFactory`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view_factory-p.html
[`PlatformView`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformView.html

## 함께 모으기 {:#putting-it-together}

When implementing the `build()` method in Dart,
you can use [`defaultTargetPlatform`][]
to detect the platform, and decide which widget to use:

<?code-excerpt "lib/native_view_example_4.dart (together-widget)"?>
```dart
Widget build(BuildContext context) {
  // This is used in the platform side to register the view.
  const String viewType = '<platform-view-type>';
  // Pass parameters to the platform side.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    // return widget on Android.
    case TargetPlatform.iOS:
    // return widget on iOS.
    case TargetPlatform.macOS:
    // return widget on macOS.
    default:
      throw UnsupportedError('Unsupported platform view');
  }
}
```

[`defaultTargetPlatform`]: {{site.api}}/flutter/foundation/defaultTargetPlatform.html

## 성능 {:#performance}
Platform views in Flutter come with performance trade-offs.

For example, in a typical Flutter app, the Flutter UI is composed on a dedicated
raster thread. This allows Flutter apps to be fast, as this thread is rarely
blocked.

When a platform view is rendered with hybrid composition, the Flutter UI
continues to be composed from the dedicated raster thread, but the platform view
performs graphics operations on the platform thread. To rasterize the combined
contents, Flutter performs synchronization between its raster thread and the
platform thread. As such, any slow or blocking operations on the platform thread
can negatively impact Flutter graphics performance.
