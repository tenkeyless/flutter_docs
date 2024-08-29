---
# title: Start building Flutter Android apps on Linux
title: Linux에서 Flutter Android 앱 빌드 시작
# description: Configure your system to develop Flutter mobile apps on Linux and Android.
description: Linux 및 Android에서 Flutter 모바일 앱을 개발하도록 시스템을 구성하세요.
# short-title: Make Android apps
short-title: Android 앱 만들기
target: Android
config: LinuxAndroid
devos: Linux
next:
  # title: Create a test app
  title: 테스트 앱 만들기
  path: /get-started/test-drive
---

{% include docs/install/reqs/linux/base.md os=devos target=target %}

{% include docs/install/flutter-sdk.md os=devos target=target terminal='Terminal' %}

{% include docs/install/compiler/android.md devos=devos target=target attempt='first' %}

{% include docs/install/flutter-doctor.md devos=devos target=target config=config %}

{% include docs/install/next-steps.md devos=devos target=target config=config %}
