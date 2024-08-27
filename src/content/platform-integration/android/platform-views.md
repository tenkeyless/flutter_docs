---
# title: Hosting native Android views in your Flutter app with Platform Views
title: Platform Views를 사용하여 Flutter 앱에서 네이티브 Android 뷰 호스팅
# short-title: Android platform-views
short-title: Android 플랫폼 뷰
# description: Learn how to host native Android views in your Flutter app with Platform Views.
description: Platform Views를 사용하여 Flutter 앱에서 네이티브 Android 뷰를 호스팅하는 방법을 알아보세요.
---

<?code-excerpt path-base="platform_integration/platform_views"?>

플랫폼 뷰를 사용하면, Flutter 앱에 네이티브 뷰를 임베드할 수 있으므로, 
Dart에서 네이티브 뷰에 변환, 클립 및 불투명도를 적용할 수 있습니다.

이를 통해, 예를 들어, Flutter 앱 내에서 Android SDK의 네이티브 Google Maps를 직접 사용할 수 있습니다.

:::note
이 페이지에서는 Flutter 앱 내에서 자체 네이티브 Android 뷰를 호스팅하는 방법을 설명합니다. 
Flutter 앱에 네이티브 iOS 뷰를 포함하려면, [네이티브 iOS 뷰 호스팅][Hosting native iOS views]을 참조하세요. 
Flutter 앱에 네이티브 macOS 뷰를 포함하려면, [네이티브 macOS 뷰 호스팅][Hosting native macOS views]을 참조하세요.
:::

[Hosting native iOS views]: /platform-integration/ios/platform-views
[Hosting native macOS views]: /platform-integration/macos/platform-views

Android의 플랫폼 뷰에는 두 가지 구현이 있습니다. 
성능과 충실도 측면에서 모두 상충이 있습니다. 
플랫폼 뷰에는 Android API 23 이상이 필요합니다.

## [하이브리드 구성(Composition)](#hybrid-composition) {:#hybrid-composition}

Platform Views are rendered as they are normally. Flutter content is rendered into a texture.
SurfaceFlinger composes the Flutter content and the platform views.

* `+` best performance and fidelity of Android views.
* `-` Flutter performance suffers.
* `-` FPS of application will be lower.
* `-` Certain transformations that can be applied to Flutter widgets will not work when applied to platform views.

## [Texture 레이어](#texturelayerhybridcompisition) (또는 Texture 레이어 하이브리드 구성) {:#texture-layer-or-texture-layer-hybrid-composition}

Platform Views are rendered into a texture.
Flutter draws the platform views (via the texture).
Flutter content is rendered directly into a Surface.

* `+` good performance for Android Views
* `+` best performance for Flutter rendering.
* `+` all transformations work correctly.
* `-` quick scrolling (e.g. a web view) will be janky
* `-` SurfaceViews are problematic in this mode and will be moved into a virtual display (breaking a11y)
* `-` Text magnifier will break unless Flutter is rendered into a TextureView.

To create a platform view on Android,
use the following steps:

## Dart 측에서 {:#on-the-dart-side}

On the Dart side, create a `Widget`
and add one of the following build implementations.

### 하이브리드 구성(composition) {:#hybrid-composition-1}

In your Dart file,
for example `native_view_example.dart`,
use the following instructions:

1. Add the following imports:  

   <?code-excerpt "lib/native_view_example_1.dart (import)"?>
   ```dart
   import 'package:flutter/foundation.dart';
   import 'package:flutter/gestures.dart';
   import 'package:flutter/material.dart';
   import 'package:flutter/rendering.dart';
   import 'package:flutter/services.dart';
   ```  
    
2. Implement a `build()` method:

   <?code-excerpt "lib/native_view_example_1.dart (hybrid-composition)"?>
   ```dart
   Widget build(BuildContext context) {
     // This is used in the platform side to register the view.
     const String viewType = '<platform-view-type>';
     // Pass parameters to the platform side.
     const Map<String, dynamic> creationParams = <String, dynamic>{};
   
     return PlatformViewLink(
       viewType: viewType,
       surfaceFactory: (context, controller) {
         return AndroidViewSurface(
           controller: controller as AndroidViewController,
           gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
           hitTestBehavior: PlatformViewHitTestBehavior.opaque,
         );
       },
       onCreatePlatformView: (params) {
         return PlatformViewsService.initSurfaceAndroidView(
           id: params.id,
           viewType: viewType,
           layoutDirection: TextDirection.ltr,
           creationParams: creationParams,
           creationParamsCodec: const StandardMessageCodec(),
           onFocus: () {
             params.onFocusChanged(true);
           },
         )
           ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
           ..create();
       },
     );
   }
   ```

For more information, see the API docs for:

* [`PlatformViewLink`][]
* [`AndroidViewSurface`][]
* [`PlatformViewsService`][]

[`AndroidViewSurface`]: {{site.api}}/flutter/widgets/AndroidViewSurface-class.html
[`PlatformViewLink`]: {{site.api}}/flutter/widgets/PlatformViewLink-class.html
[`PlatformViewsService`]: {{site.api}}/flutter/services/PlatformViewsService-class.html

### Texture 레이어 하이브리드 구성 {:#texturelayerhybridcompisition}

In your Dart file,
for example `native_view_example.dart`,
use the following instructions:

1. Add the following imports:

   <?code-excerpt "lib/native_view_example_2.dart (import)"?>
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter/services.dart';
   ```

2. Implement a `build()` method:

   <?code-excerpt "lib/native_view_example_2.dart (virtual-display)"?>
   ```dart
   Widget build(BuildContext context) {
     // This is used in the platform side to register the view.
     const String viewType = '<platform-view-type>';
     // Pass parameters to the platform side.
     final Map<String, dynamic> creationParams = <String, dynamic>{};
   
     return AndroidView(
       viewType: viewType,
       layoutDirection: TextDirection.ltr,
       creationParams: creationParams,
       creationParamsCodec: const StandardMessageCodec(),
     );
   }
   ```

For more information, see the API docs for:

* [`AndroidView`][]

[`AndroidView`]: {{site.api}}/flutter/widgets/AndroidView-class.html

## 플랫폼 측에서 {:#on-the-platform-side}

On the platform side, use the standard
`io.flutter.plugin.platform` package
in either Kotlin or Java:

{% tabs "android-language" %}
{% tab "Kotlin" %}

In your native code, implement the following:

Extend `io.flutter.plugin.platform.PlatformView`
to provide a reference to the `android.view.View`
(for example, `NativeView.kt`):

```kotlin
package dev.flutter.example

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.TextView
import io.flutter.plugin.platform.PlatformView

internal class NativeView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val textView: TextView

    override fun getView(): View {
        return textView
    }

    override fun dispose() {}

    init {
        textView = TextView(context)
        textView.textSize = 72f
        textView.setBackgroundColor(Color.rgb(255, 255, 255))
        textView.text = "Rendered on a native Android view (id: $id)"
    }
}
```

Create a factory class that creates an instance of the
`NativeView` created earlier
(for example, `NativeViewFactory.kt`):

```kotlin
package dev.flutter.example

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return NativeView(context, viewId, creationParams)
    }
}
```

Finally, register the platform view.
You can do this in an app or a plugin.

For app registration,
modify the app's main activity
(for example, `MainActivity.kt`):

```kotlin
package dev.flutter.example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory("<platform-view-type>", 
                                      NativeViewFactory())
    }
}
```

For plugin registration,
modify the plugin's main class
(for example, `PlatformViewPlugin.kt`):

```kotlin
package dev.flutter.plugin.example

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding

class PlatformViewPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        binding
                .platformViewRegistry
                .registerViewFactory("<platform-view-type>", NativeViewFactory())
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {}
}
```

{% endtab %}
{% tab "Java" %}

In your native code, implement the following:

Extend `io.flutter.plugin.platform.PlatformView`
to provide a reference to the `android.view.View`
(for example, `NativeView.java`):

```java
package dev.flutter.example;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.platform.PlatformView;
import java.util.Map;

class NativeView implements PlatformView {
   @NonNull private final TextView textView;

    NativeView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        textView = new TextView(context);
        textView.setTextSize(72);
        textView.setBackgroundColor(Color.rgb(255, 255, 255));
        textView.setText("Rendered on a native Android view (id: " + id + ")");
    }

    @NonNull
    @Override
    public View getView() {
        return textView;
    }

    @Override
    public void dispose() {}
}
```

Create a factory class that creates an
instance of the `NativeView` created earlier
(for example, `NativeViewFactory.java`):

```java
package dev.flutter.example;

import android.content.Context;
import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import java.util.Map;

class NativeViewFactory extends PlatformViewFactory {

  NativeViewFactory() {
    super(StandardMessageCodec.INSTANCE);
  }

  @NonNull
  @Override
  public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
    final Map<String, Object> creationParams = (Map<String, Object>) args;
    return new NativeView(context, id, creationParams);
  }
}
```

Finally, register the platform view.
You can do this in an app or a plugin.

For app registration,
modify the app's main activity
(for example, `MainActivity.java`):

```java
package dev.flutter.example;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        flutterEngine
            .getPlatformViewsController()
            .getRegistry()
            .registerViewFactory("<platform-view-type>", new NativeViewFactory());
    }
}
```

For plugin registration,
modify the plugin's main file
(for example, `PlatformViewPlugin.java`):

```java
package dev.flutter.plugin.example;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class PlatformViewPlugin implements FlutterPlugin {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    binding
        .getPlatformViewRegistry()
        .registerViewFactory("<platform-view-type>", new NativeViewFactory());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {}
}
```

{% endtab %}
{% endtabs %}

For more information, see the API docs for:

* [`FlutterPlugin`][]
* [`PlatformViewRegistry`][]
* [`PlatformViewFactory`][]
* [`PlatformView`][]

[`FlutterPlugin`]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/FlutterPlugin.html
[`PlatformView`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformView.html
[`PlatformViewFactory`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformViewFactory.html
[`PlatformViewRegistry`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformViewRegistry.html

Finally, modify your `build.gradle` file
to require one of the minimal Android SDK versions:

```kotlin
android {
    defaultConfig {
        minSdk = 19 // if using hybrid composition
        minSdk = 20 // if using virtual display.
    }
}
```
### 표면 뷰 {:#surface-views}

Handling SurfaceViews is problematic for Flutter and should be avoided when possible.

### 수동 뷰 무효화 {:#manual-view-invalidation}

Certain Android Views do not invalidate themselves when their content changes.
Some example views include `SurfaceView` and `SurfaceTexture`.
When your Platform View includes these views you are required to
manually invalidate the view after they have been drawn to
(or more specifically: after the swap chain is flipped).
Manual view invalidation is done by calling `invalidate` on the View 
or one of its parent views.

[`AndroidViewSurface`]: {{site.api}}/flutter/widgets/AndroidViewSurface-class.html

### 이슈 {:#issues}

[Existing Platform View issues](https://github.com/flutter/flutter/issues?q=is%3Aopen+is%3Aissue+label%3A%22a%3A+platform-views%22)

{% include docs/platform-view-perf.md %}

