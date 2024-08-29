---
# title: Add the predictive-back gesture
title: 예측적 백(predictive-back) 제스처 추가
# short-title: Predictive-back
short-title: Predictive-back
# description: >-
#   Learn how to add the predictive back gesture to your Android app.
description: >-
  Android 앱에 예측적 뒤로 제스처를 추가하는 방법을 알아보세요.
---

이 기능은 Flutter에 도입되었지만, Android 자체에서는 아직 기본적으로 활성화되지 않았습니다. 
다음 지침을 사용하여 시도해 볼 수 있습니다.

## 앱 구성하기 {:#configure-your-app}

앱이 Android API 33 이상을 지원하는지 확인하세요. 
예측적 백은 이전 버전의 Android에서는 작동하지 않습니다. 
그런 다음, `android/app/src/main/AndroidManifest.xml`에서 `android:enableOnBackInvokedCallback="true"` 플래그를 설정합니다.

## 장치 구성 {:#configure-your-device}

개발자 모드를 활성화하고 기기에 플래그를 설정해야 하므로, 
대부분 사용자의 Android 기기에서 예측적 백이 작동할 것으로 기대할 수 없습니다. 
하지만, 자신의 기기에서 시도하려면 API 33 이상을 실행 중인지 확인한 다음, 
**Settings => System => Developer** 옵션에서, 
**Predictive back animations** 옆의 스위치가 활성화되어 있는지 확인하세요.

## 앱 설정 {:#set-up-your-app}

예측적 백 라우트 전환은 현재 기본적으로 활성화되어 있지 않으므로, 
지금은 앱에서 수동으로 활성화해야 합니다. 
일반적으로 테마에서 설정하여 이를 수행합니다.

```dart
MaterialApp(
  theme: ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        // Android에 대한 예측적 뒤로 전환을 설정합니다.
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
  ),
  ...
),
```

## 앱 실행 {:#run-your-app}

마지막으로, 이 글을 쓰는 시점에서 최신 stable 릴리스 버전인, 
Flutter 버전 3.22.2 이상을 사용하여 앱을 실행해야 합니다.

## 더 많은 정보 {:#for-more-information}

다음 링크에서 더 많은 정보를 찾을 수 있습니다.

* [Android 예측적 뒤로][Android predictive back] 브레이킹 체인지

[Android predictive back]: /release/breaking-changes/android-predictive-back

