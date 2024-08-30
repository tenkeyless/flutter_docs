---
# title: Add a Flutter Fragment to an Android app
title: Android 앱에 Flutter Fragment 추가
# short-title: Add a Flutter Fragment
short-title: Flutter Fragment 추가
# description: Learn how to add a Flutter Fragment to your existing Android app.
description: 기존 Android 앱에 Flutter Fragment를 추가하는 방법을 알아보세요.
---

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-fragment/add-flutter-fragment_header.png'
class="mw-100" alt="Add Flutter Fragment Header">

이 가이드에서는 기존 Android 앱에 Flutter `Fragment`를 추가하는 방법을 설명합니다. 
Android에서, [`Fragment`][]는 더 큰 UI의 모듈식 부분을 나타냅니다. 
`Fragment`는 슬라이딩 서랍, 탭 콘텐츠, `ViewPager`의 페이지를 표시하는 데 사용될 수 있으며, 
단일 `Activity` 앱에서 일반 화면을 나타낼 수도 있습니다. 
Flutter는 개발자가 일반 `Fragment`를 사용할 수 있는 모든 위치에서 
Flutter 경험을 제공할 수 있도록 [`FlutterFragment`][]를 제공합니다.

`Activity`가 애플리케이션 요구 사항에 동일하게 적용되는 경우, 
`FlutterFragment` 대신 [`FlutterActivity`][]를 사용하는 것이, 
더 빠르고 사용하기 쉽습니다.

`FlutterFragment`를 사용하면, 개발자가 `Fragment` 내에서 Flutter 경험의 다음 세부 사항을 제어할 수 있습니다.

* 초기 Flutter 경로
* 실행할 Dart 진입점
* 불투명(Opaque) 배경 vs 반투명(translucent) 배경
* `FlutterFragment`가 주변 `Activity`를 제어해야 하는지 여부
* 새 [`FlutterEngine`][] 또는 캐시된 `FlutterEngine`을 사용해야 하는지 여부

`FlutterFragment`에는 주변 `Activity`에서 전달해야 하는 여러 호출도 함께 제공됩니다. 
이러한 호출을 통해 Flutter는 OS 이벤트에 적절하게 대응할 수 있습니다.

이 가이드에서는 모든 종류의 `FlutterFragment`와 해당 요구 사항을 설명합니다.

## 새로운 `FlutterEngine`을 사용하여 `Activity`에 `FlutterFragment` 추가 {:#add-a-flutterfragment-to-an-activity-with-a-new-flutterengine}

`FlutterFragment`를 사용하기 위해 먼저 해야 할 일은 호스트 `Activity`에 추가하는 것입니다.

`FlutterFragment`를 호스트 `Activity`에 추가하려면, 
`Activity` 내의 `onCreate()`에서 `FlutterFragment` 인스턴스를 인스턴스화하고 첨부하거나, 
앱에서 작동하는 다른 시간에 첨부합니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="MyActivity.kt"
class MyActivity : FragmentActivity() {
  companion object {
    // 이 Activity의 FragmentManager 내에서, 
    // FlutterFragment를 나타내는 태그 문자열을 정의합니다. 
    // 이 값은 원하는 대로 지정할 수 있습니다.
    private const val TAG_FLUTTER_FRAGMENT = "flutter_fragment"
  }

  // FlutterFragment를 참조하는 로컬 변수를 선언하면, 
  // 나중에 호출을 해당 변수에 전달할 수 있습니다.
  private var flutterFragment: FlutterFragment? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    // FlutterFragment에 대한 컨테이너가 있는 레이아웃을 팽창(Inflate)시킵니다. 
    // 이 예에서는 ID가 R.id.fragment_container인 FrameLayout이 있다고 가정합니다. 
    setContentView(R.layout.my_activity_layout)

    // 새로운 FlutterFragment를 추가하려면, 
    // Activity의 FragmentManager에 대한 참조를 가져오거나, 기존 Fragment를 찾습니다.
    val fragmentManager: FragmentManager = supportFragmentManager

    // onCreate()가 처음 실행되는 경우가 아닌 경우, 
    // 기존 FlutterFragment를 찾아보세요.
    flutterFragment = fragmentManager
      .findFragmentByTag(TAG_FLUTTER_FRAGMENT) as FlutterFragment?

    // FlutterFragment가 없으면 생성하여 연결합니다.
    if (flutterFragment == null) {
      var newFlutterFragment = FlutterFragment.createDefault()
      flutterFragment = newFlutterFragment
      fragmentManager
        .beginTransaction()
        .add(
          R.id.fragment_container,
          newFlutterFragment,
          TAG_FLUTTER_FRAGMENT
        )
        .commit()
    }
  }
}
```

{% endtab %}
{% tab "Java" %}

```java title="MyActivity.java"
public class MyActivity extends FragmentActivity {
    // 이 Activity의 FragmentManager 내에서, 
    // FlutterFragment를 나타내는 태그 문자열을 정의합니다. 
    // 이 값은 원하는 대로 지정할 수 있습니다.
    private static final String TAG_FLUTTER_FRAGMENT = "flutter_fragment";

    // FlutterFragment를 참조하는 로컬 변수를 선언하면, 
    // 나중에 호출을 해당 변수에 전달할 수 있습니다.
    private FlutterFragment flutterFragment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // FlutterFragment에 대한 컨테이너가 있는 레이아웃을 팽창(Inflate)시킵니다. 
        // 이 예에서는 ID가 R.id.fragment_container인 FrameLayout이 있다고 가정합니다. 
        setContentView(R.layout.my_activity_layout);

        // 새로운 FlutterFragment를 추가하려면, 
        // Activity의 FragmentManager에 대한 참조를 가져오거나, 기존 Fragment를 찾습니다.
        FragmentManager fragmentManager = getSupportFragmentManager();

        // onCreate()가 처음 실행되는 경우가 아닌 경우, 
        // 기존 FlutterFragment를 찾아보세요.
        flutterFragment = (FlutterFragment) fragmentManager
            .findFragmentByTag(TAG_FLUTTER_FRAGMENT);

        // FlutterFragment가 없으면 생성하여 연결합니다.
        if (flutterFragment == null) {
            flutterFragment = FlutterFragment.createDefault();

            fragmentManager
                .beginTransaction()
                .add(
                    R.id.fragment_container,
                    flutterFragment,
                    TAG_FLUTTER_FRAGMENT
                )
                .commit();
        }
    }
}
```

{% endtab %}
{% endtabs %}

이전 코드는 `main()` Dart 진입점, `/`의 초기 Flutter 경로, 
그리고 새로운 `FlutterEngine`에 대한 호출로 시작하는 Flutter UI를 렌더링하기에 충분합니다. 
그러나, 이 코드는 예상되는 모든 Flutter 동작을 달성하기에 충분하지 않습니다. 
Flutter는 호스트 `Activity`에서 `FlutterFragment`로 전달해야 하는 다양한 OS 신호에 따라 달라집니다. 
이러한 호출은 다음 예에서 표시됩니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="MyActivity.kt"
class MyActivity : FragmentActivity() {
  override fun onPostResume() {
    super.onPostResume()
    flutterFragment!!.onPostResume()
  }

  override fun onNewIntent(@NonNull intent: Intent) {
    flutterFragment!!.onNewIntent(intent)
  }

  override fun onBackPressed() {
    flutterFragment!!.onBackPressed()
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<String?>,
    grantResults: IntArray
  ) {
    flutterFragment!!.onRequestPermissionsResult(
      requestCode,
      permissions,
      grantResults
    )
  }

  override fun onActivityResult(
    requestCode: Int,
    resultCode: Int,
    data: Intent?
  ) {
    super.onActivityResult(requestCode, resultCode, data)
    flutterFragment!!.onActivityResult(
      requestCode,
      resultCode,
      data
    )
  }

  override fun onUserLeaveHint() {
    flutterFragment!!.onUserLeaveHint()
  }

  override fun onTrimMemory(level: Int) {
    super.onTrimMemory(level)
    flutterFragment!!.onTrimMemory(level)
  }
}
```

{% endtab %}
{% tab "Java" %}

```java title="MyActivity.java"
public class MyActivity extends FragmentActivity {
    @Override
    public void onPostResume() {
        super.onPostResume();
        flutterFragment.onPostResume();
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        flutterFragment.onNewIntent(intent);
    }

    @Override
    public void onBackPressed() {
        flutterFragment.onBackPressed();
    }

    @Override
    public void onRequestPermissionsResult(
        int requestCode,
        @NonNull String[] permissions,
        @NonNull int[] grantResults
    ) {
        flutterFragment.onRequestPermissionsResult(
            requestCode,
            permissions,
            grantResults
        );
    }

    @Override
    public void onActivityResult(
        int requestCode,
        int resultCode,
        @Nullable Intent data
    ) {
        super.onActivityResult(requestCode, resultCode, data);
        flutterFragment.onActivityResult(
            requestCode,
            resultCode,
            data
        );
    }

    @Override
    public void onUserLeaveHint() {
        flutterFragment.onUserLeaveHint();
    }

    @Override
    public void onTrimMemory(int level) {
        super.onTrimMemory(level);
        flutterFragment.onTrimMemory(level);
    }
}
```

{% endtab %}
{% endtabs %}

OS 신호가 Flutter로 전달되면, `FlutterFragment`가 예상대로 작동합니다. 
이제 기존 Android 앱에 `FlutterFragment`를 추가했습니다.

가장 간단한 통합 경로는 새로운 `FlutterEngine`을 사용하는데, 
이는 사소한 초기화 시간과 함께 제공되어 Flutter가 처음 초기화되고 렌더링될 때까지 빈 UI로 이어집니다. 
이 시간 오버헤드의 대부분은, 
다음에 논의되는 캐시되고 미리 워밍된 `FlutterEngine`을 사용하여 피할 수 있습니다.

## 미리 예열된(pre-warmed) `FlutterEngine` 사용 {:#using-a-pre-warmed-flutterengine}

기본적으로, `FlutterFragment`는 `FlutterEngine`의 자체 인스턴스를 생성하는데, 
여기에는 사소하지 않은 워밍업 시간이 필요합니다. 
즉, 사용자는 잠시 동안 빈 `Fragment`를 보게 됩니다. 
기존의 미리 워밍된 `FlutterEngine` 인스턴스를 사용하면, 
이러한 워밍업 시간의 대부분을 줄일 수 있습니다.

미리 워밍된 `FlutterEngine`을 `FlutterFragment`에서 사용하려면, 
`withCachedEngine()` 팩토리 메서드로 `FlutterFragment`를 인스턴스화합니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="MyApplication.kt"
// FlutterFragment가 필요하기 전에 앱의 어딘가에(예: Application 클래스)...
// FlutterEngine을 인스턴스화합니다.
val flutterEngine = FlutterEngine(context)

// FlutterEngine에서 Dart 코드 실행을 시작합니다.
flutterEngine.getDartExecutor().executeDartEntrypoint(
    DartEntrypoint.createDefault()
)

// 미리 예열된 FlutterEngine을 캐시하여 나중에 FlutterFragment에서 사용할 수 있도록 합니다.
FlutterEngineCache
  .getInstance()
  .put("my_engine_id", flutterEngine)
```

```kotlin title="MyActivity.java"
FlutterFragment.withCachedEngine("my_engine_id").build()
```

{% endtab %}
{% tab "Java" %}

```java title="MyApplication.java"
// FlutterFragment가 필요하기 전에 앱의 어딘가에(예: Application 클래스)...
// FlutterEngine을 인스턴스화합니다.
FlutterEngine flutterEngine = new FlutterEngine(context);

// FlutterEngine에서 Dart 코드 실행을 시작합니다.
flutterEngine.getDartExecutor().executeDartEntrypoint(
    DartEntrypoint.createDefault()
);

// 미리 예열된 FlutterEngine을 캐시하여 나중에 FlutterFragment에서 사용할 수 있도록 합니다.
FlutterEngineCache
  .getInstance()
  .put("my_engine_id", flutterEngine);
```

```java title="MyActivity.java"
FlutterFragment.withCachedEngine("my_engine_id").build();
```

{% endtab %}
{% endtabs %}

`FlutterFragment`는 내부적으로 [`FlutterEngineCache`][]에 대해 알고 있으며, 
`withCachedEngine()`에 제공된 ID를 기반으로, 
미리 예열된 `FlutterEngine`을 검색합니다.

이전에 표시된 것처럼 미리 예열된 `FlutterEngine`을 제공하면, 
앱이 가능한 한 빨리 첫 번째 Flutter 프레임을 렌더링합니다.

#### 캐시된 엔진을 사용한 초기 경로 {:#initial-route-with-a-cached-engine}

{% include docs/add-to-app/android-initial-route-cached-engine.md %}

## 시작 화면 표시 {:#display-a-splash-screen}

Flutter 콘텐츠의 초기 표시에는 사전 워밍된 `FlutterEngine`을 사용하더라도, 
약간의 대기 시간이 필요합니다. 
이 짧은 대기 기간 동안 사용자 경험을 개선하기 위해, 
Flutter는 Flutter가 첫 번째 프레임을 렌더링할 때까지 스플래시 화면(일명 "런치 화면") 표시를 지원합니다. 
시작 화면을 표시하는 방법에 대한 지침은 [스플래시 화면 가이드][splash screen guide]를 참조하세요.

## 지정된 초기 경로로 Flutter 실행 {:#run-flutter-with-a-specified-initial-route}

Android 앱은 서로 다른 `FlutterFragment`에서 실행되고, 
서로 다른 `FlutterEngine`을 사용하는 여러 독립적인 Flutter 경험을 포함할 수 있습니다. 
이러한 시나리오에서 각 Flutter 경험은 서로 다른 초기 경로(`/` 이외의 경로)로 시작하는 것이 일반적입니다. 
이를 용이하게 하기 위해, 
`FlutterFragment`의 `Builder`를 사용하면 다음과 같이 원하는 초기 경로를 지정할 수 있습니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="MyActivity.kt"
// 새로운 FlutterEngine을 사용하여.
val flutterFragment = FlutterFragment.withNewEngine()
    .initialRoute("myInitialRoute/")
    .build()
```

{% endtab %}
{% tab "Java" %}

```java title="MyActivity.java"
// 새로운 FlutterEngine을 사용하여.
FlutterFragment flutterFragment = FlutterFragment.withNewEngine()
    .initialRoute("myInitialRoute/")
    .build();
```

{% endtab %}
{% endtabs %}

:::note
`FlutterFragment`의 초기 경로 속성은 미리 워밍된 `FlutterEngine`이 사용될 때 효과가 없습니다. 
미리 워밍된 `FlutterEngine`이 이미 초기 경로를 선택했기 때문입니다. 
초기 경로는 `FlutterEngine`을 미리 워밍할 때 명시적으로 선택할 수 있습니다.
:::

## 지정된 진입점에서 Flutter 실행 {:#run-flutter-from-a-specified-entrypoint}

다양한 초기 경로와 마찬가지로, 
서로 다른 `FlutterFragment`는 서로 다른 Dart 진입점을 실행하고 싶어할 수 있습니다. 
일반적인 Flutter 앱에서는 Dart 진입점은 `main()` 하나뿐이지만, 
다른 진입점을 정의할 수 있습니다.

`FlutterFragment`는 주어진 Flutter 경험에 대해, 
실행할 원하는 Dart 진입점의 지정을 지원합니다. 
진입점을 지정하려면 다음과 같이 `FlutterFragment`를 빌드합니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="MyActivity.kt"
val flutterFragment = FlutterFragment.withNewEngine()
    .dartEntrypoint("mySpecialEntrypoint")
    .build()
```

{% endtab %}
{% tab "Java" %}

```java title="MyActivity.java"
FlutterFragment flutterFragment = FlutterFragment.withNewEngine()
    .dartEntrypoint("mySpecialEntrypoint")
    .build();
```

{% endtab %}
{% endtabs %}

`FlutterFragment` 구성은 `mySpecialEntrypoint()`라는 Dart 진입점을 실행하게 됩니다. 
`()` 괄호는 `dartEntrypoint` `String` 이름에 포함되지 않는다는 점에 유의하세요.

:::note
`FlutterFragment`의 Dart 진입점 속성은 미리 워밍된 `FlutterEngine`이 사용될 때 효과가 없습니다. 
미리 워밍된 `FlutterEngine`이 이미 Dart 진입점을 실행했기 때문입니다. 
Dart 진입점은 `FlutterEngine`을 미리 워밍할 때 명시적으로 선택할 수 있습니다.
:::

## `FlutterFragment`의 렌더 모드 제어 {:#control-flutterfragments-render-mode}

`FlutterFragment`는 `SurfaceView`를 사용하여 Flutter 콘텐츠를 렌더링하거나 `TextureView`를 사용할 수 있습니다. 
기본값은 `SurfaceView`로, `TextureView`보다 성능이 훨씬 좋습니다. 
그러나, `SurfaceView`는 Android `View` 계층 구조의 중간에 끼어들 수 없습니다. 
`SurfaceView`는 계층 구조에서 가장 아래에 있는 `View`이거나, 
계층 구조에서 가장 위에 있는 `View`여야 합니다. 
또한 Android N 이전의 Android 버전에서는, 
`SurfaceView`의 레이아웃과 렌더링이 나머지 `View` 계층 구조와 동기화되지 않기 때문에, 
애니메이션을 적용할 수 없습니다. 
이러한 사용 사례 중 하나가 앱에 필요한 경우, 
`SurfaceView` 대신 `TextureView`를 사용해야 합니다. 
`texture` `RenderMode`로 `FlutterFragment`를 빌드하여, 
`TextureView`를 선택합니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="MyActivity.kt"
// 새로운 FlutterEngine을 사용하여.
val flutterFragment = FlutterFragment.withNewEngine()
    .renderMode(FlutterView.RenderMode.texture)
    .build()

// 캐시된 FlutterEngine을 사용하여.
val flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
    .renderMode(FlutterView.RenderMode.texture)
    .build()
```

{% endtab %}
{% tab "Java" %}

```java title="MyActivity.java"
// 새로운 FlutterEngine을 사용하여.
FlutterFragment flutterFragment = FlutterFragment.withNewEngine()
    .renderMode(FlutterView.RenderMode.texture)
    .build();

// 캐시된 FlutterEngine을 사용하여.
FlutterFragment flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
    .renderMode(FlutterView.RenderMode.texture)
    .build();
```

{% endtab %}
{% endtabs %}

표시된 구성을 사용하면, 
결과 `FlutterFragment`가 UI를 `TextureView`로 렌더링합니다.

## 투명도를 사용하여 `FlutterFragment` 표시 {:#display-a-flutterfragment-with-transparency}

기본적으로, `FlutterFragment`는 `SurfaceView`를 사용하여 불투명한 배경으로 렌더링합니다. 
("Control `FlutterFragment`'s render mode"를 참조하세요.) 
Flutter에서 그리지 않은 픽셀의 경우 해당 배경은 검은색입니다. 
성능상의 이유로 불투명한 배경으로 렌더링하는 것이 선호되는 렌더링 모드입니다. 
Android에서 투명도를 사용하여 Flutter 렌더링하면 성능에 부정적인 영향을 미칩니다. 
그러나, 기본 Android UI에 표시되는 Flutter 환경에서 투명한 픽셀이 필요한 디자인이 많이 있습니다. 
이러한 이유로 Flutter는 `FlutterFragment`에서 반투명성을 지원합니다.

:::note
`SurfaceView`와 `TextureView`는 모두 투명성을 지원합니다. 
그러나, `SurfaceView`가 투명성을 사용하여 렌더링하도록 지시되면, 
다른 모든 Android `View`보다 높은 z-index에 위치하게 되며, 
이는 다른 모든 `View` 위에 표시됨을 의미합니다. 
이는 `SurfaceView`의 제한 사항입니다. 
다른 모든 콘텐츠 위에 Flutter 환경을 렌더링하는 것이 허용되는 경우, 
`FlutterFragment`의 기본 `RenderMode`인 `surface`가 사용해야 하는 `RenderMode`입니다. 
그러나, Flutter 환경 위와 아래에 모두 Android `View`를 표시해야 하는 경우, 
`RenderMode`를 `texture`로 지정해야 합니다. 
`RenderMode`를 제어하는 ​​방법에 대한 자세한 내용은, 
"`FlutterFragment`의 렌더링 모드 제어"를 참조하세요.
:::

`FlutterFragment`에 투명성을 활성화하려면, 다음 구성으로 빌드하세요.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="MyActivity.kt"
// 새로운 FlutterEngine을 사용합니다.
val flutterFragment = FlutterFragment.withNewEngine()
    .transparencyMode(FlutterView.TransparencyMode.transparent)
    .build()

// 캐시된 FlutterEngine을 사용합니다.
val flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
    .transparencyMode(FlutterView.TransparencyMode.transparent)
    .build()
```

{% endtab %}
{% tab "Java" %}

```java title="MyActivity.java"
// 새로운 FlutterEngine을 사용합니다.
FlutterFragment flutterFragment = FlutterFragment.withNewEngine()
    .transparencyMode(FlutterView.TransparencyMode.transparent)
    .build();

// 캐시된 FlutterEngine을 사용합니다.
FlutterFragment flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
    .transparencyMode(FlutterView.TransparencyMode.transparent)
    .build();
```

{% endtab %}
{% endtabs %}

## `FlutterFragment`와 그것의 `Activity`의 관계 {:#the-relationship-between-flutterfragment-and-its-activity}

일부 앱은 `Fragment`를 전체 Android 화면으로 사용하기로 선택합니다. 
이러한 앱에서는 `Fragment`가 Android의 상태 표시줄, 탐색 막대 및 방향과 같은 
시스템 크롬을 제어하는 ​​것이 합리적입니다.

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-fragment/add-flutter-fragment_fullscreen.png'
 class="mw-100" alt="Fullscreen Flutter">

다른 앱에서는, `Fragment`가 UI의 일부만을 나타내는 데 사용됩니다. 
`FlutterFragment`는 서랍, 비디오 플레이어 또는 단일 카드의 내부를 구현하는 데 사용될 수 있습니다. 
이러한 상황에서는, 
`FlutterFragment`가 Android의 시스템 크롬에 영향을 미치는 것은 부적절할 것입니다. 
왜냐하면, 동일한 `Window` 내에 다른 UI 조각이 있기 때문입니다.

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-fragment/add-flutter-fragment_partial-ui.png'
 class="mw-100" alt="Flutter as Partial UI">

`FlutterFragment`에는 `FlutterFragment`가 호스트 `Activity`를 제어할 수 있어야 하는 경우와 `FlutterFragment`가 자체 동작에만 영향을 미쳐야 하는 경우를 구별하는 데 도움이 되는 개념이 있습니다. 
`FlutterFragment`가 `Activity`를 Flutter 플러그인에 노출하는 것을 방지하고, 
Flutter가 `Activity`의 시스템 UI를 제어하지 못하도록 하려면, 
다음과 같이 `FlutterFragment`의 `Builder`에서 `shouldAttachEngineToActivity()` 메서드를 사용합니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="MyActivity.kt"
// 새로운 FlutterEngine을 사용합니다.
val flutterFragment = FlutterFragment.withNewEngine()
    .shouldAttachEngineToActivity(false)
    .build()

// 캐시된 FlutterEngine을 사용합니다.
val flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
    .shouldAttachEngineToActivity(false)
    .build()
```

{% endtab %}
{% tab "Java" %}

```java title="MyActivity.java"
// 새로운 FlutterEngine을 사용합니다.
FlutterFragment flutterFragment = FlutterFragment.withNewEngine()
    .shouldAttachEngineToActivity(false)
    .build();

// 캐시된 FlutterEngine을 사용합니다.
FlutterFragment flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
    .shouldAttachEngineToActivity(false)
    .build();
```

{% endtab %}
{% endtabs %}

`shouldAttachEngineToActivity()` `Builder` 메서드에 `false`를 전달하면, 
Flutter가 주변 `Activity`와 상호 작용하지 않습니다. 
기본값은 `true`로, 
Flutter와 Flutter 플러그인이 주변 `Activity`와 상호 작용할 수 있습니다.

:::note
일부 플러그인은 `Activity` 참조를 기대하거나 요구할 수 있습니다. 
액세스를 비활성화하기 전에 플러그인 중 어느 것도 `Activity`를 요구하지 않는지 확인하세요.
:::

[`Fragment`]: {{site.android-dev}}/guide/components/fragments
[`FlutterFragment`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterFragment.html
[using a `FlutterActivity`]: /add-to-app/android/add-flutter-screen
[`FlutterEngine`]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html
[`FlutterEngineCache`]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngineCache.html
[splash screen guide]: /platform-integration/android/splash-screen
