---
# title: Add Android as a target platform for Flutter from iOS start
title: iOS 시작에서 Flutter의 대상 플랫폼으로 Android 추가
# description: Configure your Mac to develop Flutter mobile apps for Android.
description: Android용 Flutter 모바일 앱을 개발하도록 Mac을 구성하세요.
# short-title: Starting from iOS on macOS
short-title: macOS에서 iOS로 시작
---

iOS의 Flutter 앱 대상으로 Android를 추가하려면, 다음 절차를 따르세요.

## Android Studio 설치 {:#install-android-studio}

1. Allocate a minimum of 7.5 GB of storage for Android Studio.
   Consider allocating 10 GB of storage for an optimal configuration.
1. Install [Android Studio][] {{site.appmin.android_studio}} or later
   to debug and compile Java or Kotlin code for Android.
   Flutter requires the full version of Android Studio.

{% include docs/install/compiler/android.md target='macos' devos='macOS' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='Android' devos='macOS' config='macOSDesktopAndroid' %}

[Android Studio]: https://developer.android.com/studio/install#mac
