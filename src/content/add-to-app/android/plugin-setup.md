---
# title: Manage plugins and dependencies in add-to-app
title: 앱 to 앱에서 플러그인 및 종속성 관리
# short-title: Plugin setup
short-title: 플러그인 설정
# description: >
#   Learn how to use plugins and share your 
#   plugin's library dependencies with your existing app.
description: >
  플러그인을 사용하는 방법과 플러그인 라이브러리 종속성을 기존 앱과 공유하는 방법을 알아보세요.
---

이 가이드에서는 플러그인을 사용하도록 프로젝트를 설정하는 방법과 
기존 Android 앱과 Flutter 모듈의 플러그인 간의 Gradle 라이브러리 종속성을 관리하는 방법을 설명합니다.

## A. 간단한 시나리오 {:#a-simple-scenario}

간단한 케이스:

* Flutter 모듈은 카메라 플러그인과 같이, Android OS API만 사용하기 때문에, 
  추가 Android Gradle 종속성이 없는 플러그인을 사용합니다.
* Flutter 모듈은 [video_player 플러그인의 ExoPlayer][ExoPlayer from the video_player plugin]와 같이, 
  Android Gradle 종속성이 있는 플러그인을 사용하지만, 
  기존 Android 앱은 ExoPlayer에 종속되지 않았습니다.

추가 단계는 필요하지 않습니다. 
앱에 추가 모듈은 전체 Flutter 앱과 동일한 방식으로 작동합니다. 
Android Studio, Gradle 하위 프로젝트 또는 AAR을 사용하여 통합하든, 
전이적 Android Gradle 라이브러리는 필요에 따라 자동으로 외부 기존 앱에 번들로 제공됩니다.

## B. 프로젝트 편집이 필요한 플러그인 {:#b-plugins-needing-project-edits}

일부 플러그인은 프로젝트의 Android 측면을 약간 편집해야 합니다.

예를 들어, [firebase_crashlytics][] 플러그인의 통합 지침은 
Android 래퍼 프로젝트의 `build.gradle` 파일을 수동으로 편집해야 합니다.

전체 Flutter 앱의 경우, 이러한 편집은 Flutter 프로젝트의 `/android/` 디렉터리에서 수행됩니다.

Flutter 모듈의 경우, 모듈 프로젝트에 Dart 파일만 있습니다. 
Flutter 모듈이 아닌 외부 기존 Android 앱에서, Android Gradle 파일 편집을 수행합니다.

:::note
눈치 빠른 독자라면 Flutter 모듈 디렉토리에 `.android`와 `.ios` 디렉토리도 있다는 것을 알아차렸을 것입니다. 
이러한 디렉토리는 Flutter 도구에서 생성되며, 
Flutter를 일반적인 Android 또는 iOS 라이브러리로 부트스트랩하기 위한 것입니다. 
이러한 디렉토리는 편집하거나 체크인해서는 안 됩니다. 
이를 통해 새로운 버전의 Gradle, Android, Android Gradle 플러그인 등에 버그나 업데이트가 필요한 경우, 
Flutter가 통합 지점을 개선할 수 있습니다.

고급 사용자의 경우, 더 많은 모듈성이 필요하고, 
Flutter 모듈의 종속성에 대한 지식을 외부 호스트 앱으로 유출해서는 안 되는 경우, 
Flutter 모듈의 Gradle 라이브러리를, 
Flutter 모듈의 Gradle 라이브러리에 종속된, 
다른 기본 Android Gradle 라이브러리 내부로 다시 래핑하고 다시 패키징할 수 있습니다. 
AndroidManifest.xml, Gradle 파일을 편집하거나, 
해당 래퍼 라이브러리에 Java 파일을 추가하는 등 Android에 특정한 변경을 할 수 있습니다.
:::

## C. 라이브러리 병합 {:#c-merging-libraries}

약간 더 많은 주의가 필요한 시나리오는 
기존 Android 애플리케이션이 이미 Flutter 모듈이 사용하는 것과 동일한 Android 라이브러리에 의존하는 경우입니다.
(플러그인을 통해 전이적으로(transitively))

예를 들어, 기존 앱의 Gradle에는 이미 다음이 있을 수 있습니다.

```groovy title="ExistingApp/app/build.gradle"
…
dependencies {
    …
    implementation("com.crashlytics.sdk.android:crashlytics:2.10.1")
    …
}
…
```

그리고 Flutter 모듈은 `pubspec.yaml`을 통해 [firebase_crashlytics][]에도 의존합니다.

```yaml title="flutter_module/pubspec.yaml"
…
dependencies:
  …
  firebase_crashlytics: ^0.1.3
  …
…
```

이 플러그인 사용은 firebase_crashlytics v0.1.3 자체의 [Gradle 파일][Gradle file]을 통해,
다시 Gradle 종속성을 타동적(transitively)으로 추가합니다.

```groovy title="firebase_crashlytics_via_pub/android/build.gradle
…
dependencies {
    …
    implementation("com.crashlytics.sdk.android:crashlytics:2.9.9")
    …
}
…
```

두 개의 `com.crashlytics.sdk.android:crashlytics` 종속성은 버전이 다를 수 있습니다. 
이 예에서, 호스트 앱은 v2.10.1을 요청했고 Flutter 모듈 플러그인은 v2.9.9를 요청했습니다.

기본적으로, Gradle v5는 라이브러리의 최신 버전을 사용하여 [종속성 버전 충돌을 해결][resolves dependency version conflicts]합니다.

이는 일반적으로 버전 간에 API 또는 구현의 중대한 변경 사항이 없는 한 괜찮습니다. 
예를 들어, 다음과 같이 기존 앱에서 새 Crashlytics 라이브러리를 사용할 수 있습니다.

```groovy title="ExistingApp/app/build.gradle"
…
dependencies {
    …
    implementation("com.google.firebase:firebase-crashlytics:17.0.0-beta03")
    …
}
…
```

이 방법은 Crashlytics의 Gradle 라이브러리 버전 v17.0.0-beta03과 v2.9.9 사이에, 
major API 차이가 있기 때문에 작동하지 않습니다.

시맨틱 버전을 따르는 Gradle 라이브러리의 경우, 
일반적으로 기존 앱과 Flutter 모듈 플러그인에서, 
동일한 major 시맨틱 버전을 사용하여 컴파일 및 런타임 오류를 방지할 수 있습니다.

[ExoPlayer from the video_player plugin]: {{site.repo.packages}}/blob/main/packages/video_player/video_player_android/android/build.gradle
[firebase_crashlytics]: {{site.pub}}/packages/firebase_crashlytics
[Gradle file]: {{site.github}}/firebase/flutterfire/blob/bdb95fcacf7cf077d162d2f267eee54a8b0be3bc/packages/firebase_crashlytics/android/build.gradle#L40
[resolves dependency version conflicts]: https://docs.gradle.org/current/userguide/dependency_resolution.html#sub:resolution-strategy

