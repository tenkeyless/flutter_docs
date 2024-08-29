---
# title: Add Android as a target platform for Flutter from Web on Linux start
title: Linux에서 웹으로부터 시작하여, Flutter의 대상 플랫폼으로 Android 추가 ([Linux] web + Android)
# description: Configure your Linux system to develop Flutter mobile apps for Android.
description: Android용 Flutter 모바일 앱을 개발하기 위해 Linux 시스템을 구성하세요.
# short-title: Starting from Web on Linux
short-title: Linux에서 웹으로부터 시작
---

Linux에서 Flutter 앱 대상으로 Android를 추가하려면, 다음 절차를 따르세요.

## Android Studio 설치 {:#install-android-studio}

1. Android Studio에 최소 7.5GB의 스토리지를 할당합니다.
   최적의 구성을 위해 10GB의 스토리지를 할당하는 것을 고려하세요.

2. Android Studio에 대한 다음 필수 패키지를 설치합니다.
   `libc6:i386`, `libncurses5:i386`, `libstdc++6:i386`, `lib32z1`, `libbz2-1.0:i386`

    ```console
    $ sudo apt-get install \
        libc6:i386 libncurses5:i386 \
        libstdc++6:i386 lib32z1 \
        libbz2-1.0:i386
    ```

2. Android용 Java 또는 Kotlin 코드를 디버깅하고 컴파일하려면, 
   [Android Studio][] {{site.appmin.android_studio}} 이상을 설치하세요. 
   Flutter에는 Android Studio 풀버전이 필요합니다.

{% include docs/install/compiler/android.md target='linux' devos='Linux' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='Android' devos='Linux' config='LinuxWebAndroid' %}

[Android Studio]: https://developer.android.com/studio/install#linux
