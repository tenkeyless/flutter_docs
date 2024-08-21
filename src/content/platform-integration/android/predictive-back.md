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

## Configure your app {:#configure-your-app}

Make sure your app supports Android API 33 or higher,
as predictive back won't work on older versions of Android.
Then, set the flag `android:enableOnBackInvokedCallback="true"`
in `android/app/src/main/AndroidManifest.xml`.

## Configure your device {:#configure-your-device}

You need to enable Developer Mode and set a flag on your device,
so you can't yet expect predictive back to work on most users'
Android devices. If you want to try it out on your own device though,
make sure it's running API 33 or higher, and then in
**Settings => System => Developer** options,
make sure the switch is enabled next to **Predictive back animations**.

## Set up your app {:#set-up-your-app}

The predictive back route transitions are currently
not enabled by default, so for now you'll need to enable them
manually in your app.
Typically, you do this by setting them in your theme:

```dart
MaterialApp(
  theme: ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        // Set the predictive back transitions for Android.
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
  ),
  ...
),
```

## Run your app {:#run-your-app}

Lastly, just make sure you're using at least
Flutter version 3.22.2 to run your app,
which is the latest stable release at the time of this writing.

## For more information {:#for-more-information}

You can find more information at the following link:

* [Android predictive back][] breaking change

[Android predictive back]: /release/breaking-changes/android-predictive-back

