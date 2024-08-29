---
# title: Adding a splash screen to your Android app
title: Android 앱에 스플래시 화면 추가
# short-title: Splash screen
short-title: 스플래시 화면
# description: Learn how to add a splash screen to your Android app.
description: Android 앱에 스플래시 화면을 추가하는 방법을 알아보세요.
---

<img src='/assets/images/docs/development/ui/splash-screen/android-splash-screen/splash-screens_header.png'
class="mw-100" alt="A graphic outlining the launch flow of an app including a splash screen">

스플래시 화면(런치 화면이라고도 함)은 Android 앱이 로드되는 동안 간단한 초기 경험을 제공합니다. 
앱 엔진이 로드되고 앱이 초기화될 시간을 허용하는 동시에, 애플리케이션의 무대를 설정합니다.

## 개요 {:#overview}

:::warning
스플래시 화면을 구현하는 데 충돌이 발생하는 경우 코드를 마이그레이션해야 할 수 있습니다. 
[Deprecated 스플래시 화면 API 마이그레이션 가이드][Deprecated Splash Screen API Migration guide]에서 자세한 지침을 참조하세요.
:::

Android에서는, 제어할 수 있는 두 개의 별도 화면이 있습니다. 
(1) Android 앱이 초기화되는 동안 표시되는, _실행 화면(launch screen)_ 과 
(2) Flutter 경험이 초기화되는 동안 표시되는, _시작 화면(splash screen)_ 입니다.

:::note
Flutter 2.5부터 launch 화면과 스플래시 화면이 통합되었습니다. 
이제 Flutter는 프레임워크가 첫 번째 프레임을 그릴 때까지 표시되는 Android launch 화면만 구현합니다. 
이 launch 화면은 커스터마이즈를 통해, Android launch 화면과 Android 스플래시 화면으로 모두 작동할 수 있으므로, 
두 용어로 모두 불립니다. 이러한 커스터마이즈의 예는 [Android 스플래시 화면 샘플 앱][Android splash screen sample app]을 확인하세요.

2.5 이전에 `flutter create`를 사용하여 앱을 만들고, 2.5 이상에서 앱을 실행하면, 앱이 충돌할 수 있습니다. 
자세한 내용은 [Deprecated 않는 스플래시 화면 API 마이그레이션 가이드][Deprecated Splash Screen API Migration guide]를 참조하세요.
:::

:::note
기존 Android 앱 내에 하나 이상의 Flutter 화면을 내장한 앱의 경우, 
Flutter 엔진 초기화와 관련된 대기 시간을 최소화하기 위해, 
[`FlutterEngine`을 미리 워밍업][pre-warming a `FlutterEngine`]하고, 
앱 전체에서 동일한 엔진을 재사용하는 것을 고려하세요.
:::

## 앱 초기화 {:#initializing-the-app}

모든 Android 앱은 운영 체제가 앱 프로세스를 설정하는 동안 초기화 시간이 필요합니다. 
Android는 앱이 초기화되는 동안 `Drawable`을 표시하기 위해, [launch screen][]이라는 개념을 제공합니다.

`Drawable`은 Android 그래픽입니다. 
Android Studio에서 Flutter 프로젝트에 `Drawable`을 추가하는 방법을 알아보려면, 
Android 개발자 문서에서 [프로젝트에 drawable 가져오기][drawables]를 확인하세요.

기본 Flutter 프로젝트 템플릿에는 launch 테마와 launch 배경의 정의가 포함되어 있습니다. 
`styles.xml`을 편집하여 이를 커스터마이즈 할 수 있으며, 
여기서 `windowBackground`가 launch 화면으로 표시되어야 하는 
`Drawable`로 설정된 테마를 정의할 수 있습니다.

```xml
<style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowBackground">@drawable/launch_background</item>
</style>
```

또한, `styles.xml`은 launch 화면이 사라진 후 `FlutterActivity`에 적용할 _normal 테마_ 를 정의합니다. 
normal 테마 배경은 스플래시 화면이 사라진 후 아주 짧은 순간 동안만 표시되고, 
방향이 변경되고 `Activity`가 복원되는 동안 표시됩니다. 
따라서, normal 테마는 Flutter UI의 primary 배경색과 비슷한 단색 배경색을 사용하는 것이 좋습니다.

```xml
<style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowBackground">@drawable/normal_background</item>
</style>
```

[drawables]: {{site.android-dev}}/studio/write/resource-manager#import

## AndroidManifest.xml에 FlutterActivity 설정 {:#set-up-the-flutteractivity-in-androidmanifest-xml}

`AndroidManifest.xml`에서, `FlutterActivity`의 `theme`을 시작 테마로 설정합니다. 
그런 다음, 원하는 `FlutterActivity`에 메타데이터 요소를 추가하여, 
적절한 시기에 시작 테마에서 일반 테마로 전환하도록 Flutter에 지시합니다.

```xml
<activity
    android:name=".MyActivity"
    android:theme="@style/LaunchTheme"
    // ...
    >
    <meta-data
        android:name="io.flutter.embedding.android.NormalTheme"
        android:resource="@style/NormalTheme"
        />
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
</activity>
```

이제 Android 앱이 초기화되는 동안 원하는 시작 화면이 표시됩니다.

## Android 12 {:#android-12}

Android 12에서 시작 화면을 구성하려면, [Android Splash Screens][]를 확인하세요.

Android 12부터, `styles.xml` 파일에서 새로운 시작 화면 API를 사용해야 합니다. 
Android 12 이상을 위한 대체 리소스 파일을 만드는 것을 고려하세요. 
또한, 배경 이미지가 아이콘 가이드라인에 맞는지 확인하세요. 
자세한 내용은 [Android Splash Screens][]를 확인하세요.

```xml
<style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">
    <item name="android:windowSplashScreenBackground">@color/bgColor</item>
    <item name="android:windowSplashScreenAnimatedIcon">@drawable/launch_background</item>
</style>
```

`io.flutter.embedding.android.SplashScreenDrawable`이 매니페스트에 **설정되지 않았는지** 확인하고, 
`provideSplashScreen`이 구현되지 않았는지 **확인하세요.** 이러한 API는 deprecated 입니다. 
그렇게 하면 앱이 시작될 때 Android 시작 화면이 Flutter로 부드럽게 페이드아웃되고 앱이 충돌할 수 있습니다.

일부 앱은 Flutter에서 Android 시작 화면의 마지막 프레임을 계속 표시하고 싶어할 수 있습니다. 
예를 들어, 이렇게 하면 Dart에서 추가 로딩이 계속되는 동안, 단일 프레임의 환상이 유지됩니다. 
이를 달성하기 위해, 다음 Android API가 도움이 될 수 있습니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="MainActivity.kt"
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    // Flutter 뷰를 창에 수직으로 정렬합니다.
    WindowCompat.setDecorFitsSystemWindows(getWindow(), false)

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
      // Flutter에서 비슷한 프레임이 그려지기 전에 깜빡임이 발생하지 않도록, 
      // Android 시작 화면 페이드 아웃 애니메이션을 비활성화합니다.
      splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
    }

    super.onCreate(savedInstanceState)
  }
}
```

{% endtab %}
{% tab "Java" %}

```java title="MainActivity.java"
import android.os.Build;
import android.os.Bundle;
import android.window.SplashScreenView;
import androidx.core.view.WindowCompat;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Flutter 뷰를 창에 수직으로 정렬합니다.
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Flutter에서 비슷한 프레임이 그려지기 전에 깜빡임이 발생하지 않도록, 
            // Android 시작 화면 페이드 아웃 애니메이션을 비활성화합니다.
            getSplashScreen()
                .setOnExitAnimationListener(
                    (SplashScreenView splashScreenView) -> {
                        splashScreenView.remove();
                    });
        }

        super.onCreate(savedInstanceState);
    }
}
```

{% endtab %}
{% endtabs %}

그런 다음, 화면의 동일한 위치에 Android 시작 화면의 요소를 표시하는 Flutter의 첫 번째 프레임을 다시 구현할 수 있습니다. 
이에 대한 예는, [Android 시작 화면 샘플 앱][Android splash screen sample app]을 확인하세요.

[Android Splash Screens]: {{site.android-dev}}/about/versions/12/features/splash-screen
[launch screen]: {{site.android-dev}}/topic/performance/vitals/launch-time#themed
[pre-warming a `FlutterEngine`]: /add-to-app/android/add-flutter-fragment#using-a-pre-warmed-flutterengine
[Android splash screen sample app]: {{site.repo.samples}}/tree/main/android_splash_screen
[Deprecated Splash Screen API Migration guide]: /release/breaking-changes/splash-screen-migration
[Customizing web app initialization guide]: /platform-integration/web/initialization
