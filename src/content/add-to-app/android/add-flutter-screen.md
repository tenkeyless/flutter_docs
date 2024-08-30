---
# title: Add a Flutter screen to an Android app
title: Android 앱에 Flutter 화면 추가
# short-title: Add a Flutter screen
short-title: Flutter 화면 추가
# description: >
  # Learn how to add a single Flutter screen to your existing Android app.
description: >
  기존 Android 앱에 단일 Flutter 화면을 추가하는 방법을 알아보세요.
---

이 가이드에서는 기존 Android 앱에 단일 Flutter 화면을 추가하는 방법을 설명합니다. 
Flutter 화면은 일반 불투명 화면 또는 투명한 반투명(translucent) 화면으로 추가할 수 있습니다. 
이 가이드에서는 두 가지 옵션 모두 설명합니다.

## 일반 Flutter 화면 추가 {:#add-a-normal-flutter-screen}

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-screen/add-single-flutter-screen_header.png'
class="mw-100" alt="Add Flutter Screen Header">

### 1단계: AndroidManifest.xml에 FlutterActivity 추가 {:#step-1-add-flutteractivity-to-androidmanifest-xml}

Flutter는 Android 앱 내에서 Flutter 경험을 표시하기 위해, 
[`FlutterActivity`][]를 제공합니다. 
다른 [`Activity`][]와 마찬가지로, 
`FlutterActivity`는 `AndroidManifest.xml`에 등록해야 합니다. 
다음 XML을 `application` 태그 아래의 `AndroidManifest.xml` 파일에 추가합니다.

```xml
<activity
  android:name="io.flutter.embedding.android.FlutterActivity"
  android:theme="@style/LaunchTheme"
  android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
  android:hardwareAccelerated="true"
  android:windowSoftInputMode="adjustResize"
  />
```

`@style/LaunchTheme`에 대한 참조는 `FlutterActivity`에 적용하려는 모든 Android 테마로 대체할 수 있습니다. 
테마 선택은 Android의 시스템 크롬에 적용되는 색상(Android의 네비게이션 바와 같은)과 Flutter UI가 처음으로 렌더링되기 직전의 `FlutterActivity`의 배경색을 결정합니다.

### 2단계: FlutterActivity 실행 {:#step-2-launch-flutteractivity}

매니페스트 파일에 `FlutterActivity`가 등록되어 있으면, 
앱의 원하는 지점에서 `FlutterActivity`를 시작하는 코드를 추가합니다. 
다음 예에서는 `OnClickListener`에서 `FlutterActivity`가 시작되는 것을 보여줍니다.

:::note
다음 import를 사용해야 합니다.

```java
import io.flutter.embedding.android.FlutterActivity;
```
:::

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="ExistingActivity.kt"
myButton.setOnClickListener {
  startActivity(
    FlutterActivity.createDefaultIntent(this)
  )
}
```

{% endtab %}
{% tab "Java" %}

```java title="ExistingActivity.java"
myButton.setOnClickListener(new OnClickListener() {
  @Override
  public void onClick(View v) {
    startActivity(
      FlutterActivity.createDefaultIntent(currentActivity)
    );
  }
});
```

{% endtab %}
{% endtabs %}

이전 예제에서는 Dart 진입점이 `main()`이고 초기 Flutter 경로가 '/'라고 가정합니다. 
Dart 진입점은 `Intent`를 사용하여 변경할 수 없지만, 
초기 경로는 `Intent`를 사용하여 변경할 수 있습니다. 
다음 예제에서는 Flutter에서 커스텀 경로를 처음에 렌더링하는 `FlutterActivity`를 시작하는 방법을 보여줍니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="ExistingActivity.kt"
myButton.setOnClickListener {
  startActivity(
    FlutterActivity
      .withNewEngine()
      .initialRoute("/my_route")
      .build(this)
  )
}
```

{% endtab %}
{% tab "Java" %}

```java title="ExistingActivity.java"
myButton.addOnClickListener(new OnClickListener() {
  @Override
  public void onClick(View v) {
    startActivity(
      FlutterActivity
        .withNewEngine()
        .initialRoute("/my_route")
        .build(currentActivity)
      );
  }
});
```

{% endtab %}
{% endtabs %}

`"/my_route"`를 원하는 초기 경로로 바꾸세요.

`withNewEngine()` 팩토리 메서드를 사용하면, 
내부적으로 자체 [`FlutterEngine`][] 인스턴스를 만드는 `FlutterActivity`가 구성됩니다. 
여기에는 사소한 초기화 시간이 따릅니다. 
다른 방법은 `FlutterActivity`에 미리 워밍업되고, 
캐시된 `FlutterEngine`을 사용하도록 지시하는 것입니다. 
이렇게 하면 Flutter의 초기화 시간이 최소화됩니다. 
이 방법은 다음에 설명합니다.

### 3단계: (선택 사항) 캐시된 FlutterEngine 사용 {:#step-3-optional-use-a-cached-flutterengine}

모든 `FlutterActivity`는 기본적으로 자체 `FlutterEngine`을 만듭니다. 
각 `FlutterEngine`은 사소하지 않은 워밍업 시간을 갖습니다. 
즉, 표준 `FlutterActivity`를 시작하면, Flutter 경험이 표시되기 전에 잠시 지연됩니다. 
이 지연을 최소화하려면, `FlutterActivity`에 도착하기 전에, 
`FlutterEngine`을 워밍업한 다음, 
미리 워밍된 `FlutterEngine`을 대신 사용할 수 있습니다.

`FlutterEngine`을 미리 워밍하려면, 
앱에서 `FlutterEngine`을 인스턴스화할 적절한 위치를 찾으세요. 
다음 예제는 `Application` 클래스에서 임의로 `FlutterEngine`을 미리 워밍합니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="MyApplication.kt"
class MyApplication : Application() {
  lateinit var flutterEngine : FlutterEngine

  override fun onCreate() {
    super.onCreate()

    // FlutterEngine을 인스턴스화합니다.
    flutterEngine = FlutterEngine(this)

    // FlutterEngine을 예열하기 위해 Dart 코드 실행을 시작합니다.
    flutterEngine.dartExecutor.executeDartEntrypoint(
      DartExecutor.DartEntrypoint.createDefault()
    )

    // FlutterActivity에서 사용할 FlutterEngine을 캐시합니다.
    FlutterEngineCache
      .getInstance()
      .put("my_engine_id", flutterEngine)
  }
}
```

{% endtab %}
{% tab "Java" %}

```java title="MyApplication.java"
public class MyApplication extends Application {
  public FlutterEngine flutterEngine;
  
  @Override
  public void onCreate() {
    super.onCreate();
    // FlutterEngine을 인스턴스화합니다.
    flutterEngine = new FlutterEngine(this);

    // FlutterEngine을 예열하기 위해 Dart 코드 실행을 시작합니다.
    flutterEngine.getDartExecutor().executeDartEntrypoint(
      DartEntrypoint.createDefault()
    );

    // FlutterActivity에서 사용할 FlutterEngine을 캐시합니다.
    FlutterEngineCache
      .getInstance()
      .put("my_engine_id", flutterEngine);
  }
}
```

{% endtab %}
{% endtabs %}

[`FlutterEngineCache`][]에 전달된 ID는 원하는 대로 될 수 있습니다. 
캐시된 `FlutterEngine`을 사용해야 하는 모든 `FlutterActivity` 또는 [`FlutterFragment`][]에 동일한 ID를 전달해야 합니다. 
캐시된 `FlutterEngine`과 함께 `FlutterActivity`를 사용하는 것에 대해서는 다음에 설명합니다.

:::note
`FlutterEngine`을 워밍업하려면, Dart 진입점을 실행해야 합니다. 
`executeDartEntrypoint()`가 호출되는 순간, 
Dart 진입점 메서드가 실행되기 시작한다는 점을 명심하세요. 
Dart 진입점이 `runApp()`를 호출하여 Flutter 앱을 실행하면, 
Flutter 앱은 이 `FlutterEngine`이 `FlutterActivity`, `FlutterFragment` 또는 `FlutterView`에 연결될 때까지, 
크기가 0인 창에서 실행되는 것처럼 동작합니다. 
앱을 워밍업하는 시간과 Flutter 콘텐츠를 표시하는 시간 사이에 앱이 적절하게 동작하는지 확인하세요.
:::

미리 워밍업되고 캐시된 `FlutterEngine`을 사용하면, 
이제 `FlutterActivity`에 새 것을 만드는 대신, 
캐시된 `FlutterEngine`을 사용하도록 지시해야 합니다. 
이를 수행하려면 `FlutterActivity`의 `withCachedEngine()` 빌더를 사용합니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="ExistingActivity.kt"
myButton.setOnClickListener {
  startActivity(
    FlutterActivity
      .withCachedEngine("my_engine_id")
      .build(this)
  )
}
```

{% endtab %}
{% tab "Java" %}

```java title="ExistingActivity.java"
myButton.addOnClickListener(new OnClickListener() {
  @Override
  public void onClick(View v) {
    startActivity(
      FlutterActivity
        .withCachedEngine("my_engine_id")
        .build(currentActivity)
      );
  }
});
```

{% endtab %}
{% endtabs %}

`withCachedEngine()` 팩토리 메서드를 사용할 때, 
원하는 `FlutterEngine`을 캐싱할 때 사용한 것과 동일한 ID를 전달합니다.

이제 `FlutterActivity`를 실행하면, Flutter 콘텐츠 표시에 지연이 상당히 줄어듭니다.

:::note
캐시된 `FlutterEngine`을 사용할 때, 해당 `FlutterEngine`은 그것을 표시하는 `FlutterActivity` 또는 `FlutterFragment`보다 오래 지속됩니다. 
Dart 코드는 `FlutterEngine`을 사전 워밍하는 즉시 실행을 시작하고, 
`FlutterActivity`/`FlutterFragment`가 파괴된 후에도 계속 실행된다는 점을 명심하세요. 
실행을 중지하고 리소스를 지우려면, 
`FlutterEngineCache`에서 `FlutterEngine`을 가져오고, 
`FlutterEngine.destroy()`로 `FlutterEngine`을 파괴하세요.
:::

:::note
런타임 성능이 `FlutterEngine`을 사전 워밍하고 캐시하는 유일한 이유는 아닙니다. 
사전 워밍된 `FlutterEngine`은 `FlutterActivity`와 독립적으로 Dart 코드를 실행하므로, 
이러한 `FlutterEngine`을 사용하여 언제든지 임의의 Dart 코드를 실행할 수 있습니다. 
네트워킹 및 데이터 캐싱과 같은 비 UI 애플리케이션 로직은 `FlutterEngine`에서 실행될 수 있으며, 
`Service` 또는 다른 곳에서 백그라운드 동작으로 실행될 수 있습니다. 
`FlutterEngine`을 사용하여 백그라운드에서 동작을 실행하는 경우, 
백그라운드 실행에 대한 모든 Android 제한 사항을 준수해야 합니다.
:::

:::note
Flutter의 디버그/릴리스 빌드는 성능 특성이 크게 다릅니다. 
Flutter의 성능을 평가하려면, 릴리스 빌드를 사용하세요.
:::

#### 캐시된 엔진을 사용한 초기 경로 {:#initial-route-with-a-cached-engine}

{% include docs/add-to-app/android-initial-route-cached-engine.md %}

## 반투명(translucency) Flutter 화면 추가 {:#add-a-translucent-flutter-screen}

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-screen/add-single-flutter-screen-transparent_header.png'
class="mw-100" alt="Add Flutter Screen With Translucency Header">

대부분의 전체 화면 Flutter 경험은 불투명(opaque)합니다. 
그러나, 일부 앱은 모달처럼 보이는 Flutter 화면, 
예를 들어, 대화 상자나 바텀 시트를 배포하고 싶어합니다. 
Flutter는 기본적으로 반투명(translucent) `FlutterActivity`를 지원합니다.

`FlutterActivity`를 반투명하게 만들려면, 
`FlutterActivity`를 만들고 시작하는 일반적인 프로세스를 다음과 같이 변경합니다.

### 1단계: 반투명 테마 사용 {:#step-1-use-a-theme-with-translucency}

Android는 반투명 배경으로 렌더링되는 `Activity`에 대한 특수 테마 속성을 요구합니다. 
다음 속성으로 Android 테마를 만들거나 업데이트하세요.

```xml
<style name="MyTheme" parent="@style/MyParentTheme">
  <item name="android:windowIsTranslucent">true</item>
</style>
```

그런 다음, `FlutterActivity`에 반투명 테마를 적용합니다.

```xml
<activity
  android:name="io.flutter.embedding.android.FlutterActivity"
  android:theme="@style/MyTheme"
  android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
  android:hardwareAccelerated="true"
  android:windowSoftInputMode="adjustResize"
  />
```

이제 `FlutterActivity`가 반투명성을 지원합니다. 
다음으로, 명시적 투명성 지원으로 `FlutterActivity`를 시작해야 합니다.

### 2단계: 투명성을 사용하여 FlutterActivity 시작 {:#step-2-start-flutteractivity-with-transparency}

투명한 배경으로 `FlutterActivity`를 시작하려면, 
적절한 `BackgroundMode`를 `IntentBuilder`에 전달합니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="ExistingActivity.kt"
// 새로운 FlutterEngine을 사용합니다.
startActivity(
  FlutterActivity
    .withNewEngine()
    .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
    .build(this)
);

// 캐시된 FlutterEngine을 사용합니다.
startActivity(
  FlutterActivity
    .withCachedEngine("my_engine_id")
    .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
    .build(this)
);
```

{% endtab %}
{% tab "Java" %}

```java title="ExistingActivity.java"
// 새로운 FlutterEngine을 사용합니다.
startActivity(
  FlutterActivity
    .withNewEngine()
    .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
    .build(context)
);

// 캐시된 FlutterEngine을 사용합니다.
startActivity(
  FlutterActivity
    .withCachedEngine("my_engine_id")
    .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.transparent)
    .build(context)
);
```

{% endtab %}
{% endtabs %}

이제 투명한 배경을 가진 `FlutterActivity`가 생겼습니다.

:::note
Flutter 콘텐츠에도 반투명 배경이 포함되어 있는지 확인하세요. 
Flutter UI가 단색 배경색을 칠하는 경우, 
`FlutterActivity`에 불투명 배경이 있는 것처럼 보입니다.
:::

[`FlutterActivity`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html
[`Activity`]: {{site.android-dev}}/reference/android/app/Activity
[`FlutterEngine`]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html
[`FlutterEngineCache`]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngineCache.html
[`FlutterFragment`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterFragment.html
