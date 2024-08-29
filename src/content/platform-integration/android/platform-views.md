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

플랫폼 뷰는 정상적으로 렌더링됩니다. Flutter 콘텐츠는 텍스처로 렌더링됩니다.
SurfaceFlinger는 Flutter 콘텐츠와 플랫폼 뷰를 구성합니다.

* `+` Android 뷰의 최상의 성능과 충실도.
* `-` Flutter 성능이 저하됩니다.
* `-` 애플리케이션의 FPS가 낮아집니다.
* `-` Flutter 위젯에 적용할 수 있는 특정 변환은, 플랫폼 뷰에 적용하면 작동하지 않습니다.

## [Texture 레이어](#texturelayerhybridcompisition) (또는 Texture 레이어 하이브리드 구성) {:#texture-layer-or-texture-layer-hybrid-composition}

플랫폼 뷰는 텍스처로 렌더링됩니다.
Flutter는 플랫폼 뷰를 그립니다. (텍스처를 통해)
Flutter 콘텐츠는 Surface로 직접 렌더링됩니다.

* `+` Android 뷰에 대한 우수한 성능
* `+` Flutter 렌더링에 대한 최상의 성능.
* `+` 모든 변환이 올바르게 작동합니다.
* `-` 빠른 스크롤(예: 웹 뷰)이 janky 합니다.
* `-` SurfaceView는 이 모드에서 문제가 있으며, 가상 디스플레이로 이동합니다. (a11y가 깨짐)
* `-` Flutter가 TextureView로 렌더링되지 않으면, 텍스트 확대경이 깨집니다.

Android에서 플랫폼 뷰를 만들려면, 다음 단계를 따르세요.

## Dart 측에서 {:#on-the-dart-side}

Dart 측에서, `Widget`을 생성하고 다음 빌드 구현 중 하나를 추가합니다.

### 하이브리드 구성(composition) {:#hybrid-composition-1}

예를 들어, `native_view_example.dart`와 같은 Dart 파일에서 다음 지침을 사용합니다.

1. 다음 imports를 추가합니다.

   <?code-excerpt "lib/native_view_example_1.dart (import)"?>
   ```dart
   import 'package:flutter/foundation.dart';
   import 'package:flutter/gestures.dart';
   import 'package:flutter/material.dart';
   import 'package:flutter/rendering.dart';
   import 'package:flutter/services.dart';
   ```  
    
2. `build()` 메서드를 구현합니다.

   <?code-excerpt "lib/native_view_example_1.dart (hybrid-composition)"?>
   ```dart
   Widget build(BuildContext context) {
     // 이는 플랫폼 측에서 뷰를 등록하는 데 사용됩니다.
     const String viewType = '<platform-view-type>';
     // 플랫폼 측에 매개변수를 전달합니다.
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

자세한 내용은, 다음 API 문서를 참조하세요.

* [`PlatformViewLink`][]
* [`AndroidViewSurface`][]
* [`PlatformViewsService`][]

[`AndroidViewSurface`]: {{site.api}}/flutter/widgets/AndroidViewSurface-class.html
[`PlatformViewLink`]: {{site.api}}/flutter/widgets/PlatformViewLink-class.html
[`PlatformViewsService`]: {{site.api}}/flutter/services/PlatformViewsService-class.html

### Texture 레이어 하이브리드 구성 {:#texturelayerhybridcompisition}

예를 들어, `native_view_example.dart`와 같은 Dart 파일에서 다음 지침을 따르세요.

1. 다음 imports를 추가합니다.

   <?code-excerpt "lib/native_view_example_2.dart (import)"?>
   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter/services.dart';
   ```

2. `build()` 메서드를 구현합니다.

   <?code-excerpt "lib/native_view_example_2.dart (virtual-display)"?>
   ```dart
   Widget build(BuildContext context) {
     // 이는 플랫폼 측에서 뷰를 등록하는 데 사용됩니다.
     const String viewType = '<platform-view-type>';
     // 플랫폼 측에 매개변수를 전달합니다.
     final Map<String, dynamic> creationParams = <String, dynamic>{};
   
     return AndroidView(
       viewType: viewType,
       layoutDirection: TextDirection.ltr,
       creationParams: creationParams,
       creationParamsCodec: const StandardMessageCodec(),
     );
   }
   ```

자세한 내용은, 다음 API 문서를 참조하세요.

* [`AndroidView`][]

[`AndroidView`]: {{site.api}}/flutter/widgets/AndroidView-class.html

## 플랫폼 측에서 {:#on-the-platform-side}

플랫폼 측에서는 Kotlin 또는 Java에서 표준 `io.flutter.plugin.platform` 패키지를 사용합니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

네이티브 코드에서, 다음을 구현합니다.

`io.flutter.plugin.platform.PlatformView`를 확장하여, 
`android.view.View`(예: `NativeView.kt`)에 대한 참조를 제공합니다.

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

이전에 생성한 `NativeView`의 인스턴스를 생성하는 팩토리 클래스를 생성합니다. (예: `NativeViewFactory.kt`)

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

마지막으로 플랫폼 뷰를 등록합니다. 앱이나 플러그인에서 이 작업을 수행할 수 있습니다.

앱 등록의 경우, 앱의 메인 액티비티를 수정합니다(예: `MainActivity.kt`):

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

플러그인 등록을 위해, 플러그인의 메인 클래스를 수정합니다. (예: `PlatformViewPlugin.kt`):

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

네이티브 코드에서 다음을 구현합니다.

`io.flutter.plugin.platform.PlatformView`를 확장하여, 
`android.view.View`(예: `NativeView.java`)에 대한 참조를 제공합니다.

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

이전에 생성한 `NativeView`의 인스턴스를 생성하는 팩토리 클래스를 생성합니다(예: `NativeViewFactory.java`):

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

마지막으로, 플랫폼 뷰를 등록합니다. 앱이나 플러그인에서 이 작업을 수행할 수 있습니다.

앱 등록의 경우, 앱의 기본 액티비티를 수정합니다(예: `MainActivity.java`):

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

플러그인 등록을 위해, 플러그인의 메인 파일을 수정합니다(예: `PlatformViewPlugin.java`):

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

자세한 내용은, 다음 API 문서를 참조하세요.

* [`FlutterPlugin`][]
* [`PlatformViewRegistry`][]
* [`PlatformViewFactory`][]
* [`PlatformView`][]

[`FlutterPlugin`]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/FlutterPlugin.html
[`PlatformView`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformView.html
[`PlatformViewFactory`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformViewFactory.html
[`PlatformViewRegistry`]: {{site.api}}/javadoc/io/flutter/plugin/platform/PlatformViewRegistry.html

마지막으로, 최소 Android SDK 버전 중 하나를 요구하도록 `build.gradle` 파일을 수정합니다.

```kotlin
android {
    defaultConfig {
        minSdk = 19 // 하이브리드 구성을 사용하는 경우
        minSdk = 20 // 가상 디스플레이를 사용하는 경우
    }
}
```
### 표면 뷰 {:#surface-views}

SurfaceView를 처리하는 것은 Flutter에서 문제가 될 수 있으므로 가능하면 피하는 것이 좋습니다.

### 수동 뷰 무효화 {:#manual-view-invalidation}

특정 Android View는 콘텐츠가 변경될 때 자체적으로 무효화되지 않습니다. 
일부 예시 View에는 `SurfaceView`와 `SurfaceTexture`가 있습니다. 
Platform View에 이러한 View가 포함된 경우 뷰가 그려진 후(또는 더 구체적으로: 스왑 체인이 뒤집힌 후), 
수동으로 뷰를 무효화해야 합니다. 
수동 뷰 무효화는 View 또는 부모 뷰 중 하나에서 `invalidate`를 호출하여 수행됩니다.

[`AndroidViewSurface`]: {{site.api}}/flutter/widgets/AndroidViewSurface-class.html

### 이슈 {:#issues}

[기존 플랫폼 뷰 문제](https://github.com/flutter/flutter/issues?q=is%3Aopen+is%3Aissue+label%3A%22a%3A+platform-views%22)

{% include docs/platform-view-perf.md %}

