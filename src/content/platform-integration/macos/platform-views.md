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

Dart 쪽에서, `Widget`을 만들고 다음 단계에 표시된 대로 빌드 구현을 추가합니다.

Dart 위젯 파일에서, `native_view_example.dart`에 표시된 것과 유사한 변경을 합니다.

<ol>
<li>

다음 imports를 추가합니다.

<?code-excerpt "lib/native_view_example_4.dart (import)"?>
```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
```

</li>

<li>

`build()` 메서드를 구현합니다.

<?code-excerpt "lib/native_view_example_4.dart (macos-composition)"?>
```dart
Widget build(BuildContext context) {
  // 이는 플랫폼 측에서 뷰를 등록하는 데 사용됩니다.
  const String viewType = '<platform-view-type>';
  // 플랫폼 측에 매개변수를 전달합니다.
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

자세한 내용은 [`AppKitView`][]에 대한 API 문서를 참조하세요.

[`AppKitView`]: {{site.api}}/flutter/widgets/AppKitView-class.html

## 플랫폼 측에서 {:#on-the-platform-side}

팩토리와 플랫폼 뷰를 구현합니다. 
`NativeViewFactory`는 플랫폼 뷰를 생성하고 플랫폼 뷰는 `NSView`에 대한 참조를 제공합니다. 
예를 들어, `NativeView.swift`:

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

  /// 이 메서드를 구현하는 것은 `createWithFrame`의 `arguments`가 `nil`이 아닌 경우에만 필요합니다.
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
    // macOS 뷰는 여기에서 생성할 수 있습니다.
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

마지막으로, 플랫폼 뷰를 등록합니다. 이는 앱이나 플러그인에서 수행할 수 있습니다.

앱 등록의 경우, 앱의 `MainFlutterWindow.swift`를 수정합니다.

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

플러그인 등록을 위해, 플러그인의 메인 파일을 수정합니다(예: `Plugin.swift`):

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

자세한 내용은 다음 API 문서를 참조하세요.

* [`FlutterPlatformViewFactory`][]
* [`FlutterPlatformView`][]
* [`PlatformView`][]

[`FlutterPlatformView`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view-p.html
[`FlutterPlatformViewFactory`]: {{site.api}}/ios-embedder/protocol_flutter_platform_view_factory-p.html
[`PlatformView`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformView.html

## 함께 모으기 {:#putting-it-together}

Dart에서 `build()` 메서드를 구현할 때, 
[`defaultTargetPlatform`][]을 사용하여 플랫폼을 감지하고 어떤 위젯을 사용할지 결정할 수 있습니다.

<?code-excerpt "lib/native_view_example_4.dart (together-widget)"?>
```dart
Widget build(BuildContext context) {
  // 이는 플랫폼 측에서 뷰를 등록하는 데 사용됩니다.
  const String viewType = '<platform-view-type>';
  // 플랫폼 측에 매개변수를 전달합니다.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    // Android에 대한 위젯을 반환합니다.
    case TargetPlatform.iOS:
    // iOS에 대한 위젯을 반환합니다.
    case TargetPlatform.macOS:
    // macOS에 대한 위젯을 반환합니다.
    default:
      throw UnsupportedError('Unsupported platform view');
  }
}
```

[`defaultTargetPlatform`]: {{site.api}}/flutter/foundation/defaultTargetPlatform.html

## 성능 {:#performance}

Flutter의 플랫폼 뷰는 성능 트레이드 오프와 함께 제공됩니다.

예를 들어, 일반적인 Flutter 앱에서 Flutter UI는 전용 래스터 스레드에서 구성됩니다. 
이 스레드는 거의 차단되지 않으므로, Flutter 앱이 빠르게 실행될 수 있습니다.

하이브리드 구성으로 플랫폼 뷰를 렌더링하는 경우, 
Flutter UI는 전용 래스터 스레드에서 계속 구성되지만, 
플랫폼 뷰는 플랫폼 스레드에서 그래픽 작업을 수행합니다. 
결합된 콘텐츠를 래스터화하기 위해, Flutter는 래스터 스레드와 플랫폼 스레드 간에 동기화를 수행합니다. 
따라서, 플랫폼 스레드에서 느리거나 차단되는 작업은 Flutter 그래픽 성능에 부정적인 영향을 미칠 수 있습니다.