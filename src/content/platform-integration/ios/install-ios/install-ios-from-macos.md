---
# title: Add iOS as a target platform from macOS start
title: macOS로부터 시작하여, iOS를 대상 플랫폼으로 추가 ([macOS] macOS + iOS)
# description: Configure your system to develop Flutter mobile apps on iOS.
description: iOS에 대해서, Flutter 모바일 앱을 개발하도록 시스템을 구성하세요.
# short-title: Starting from macOS
short-title: macOS로부터 시작
---

macOS용 Flutter 앱 타겟으로 iOS를 추가하려면 다음 절차를 따르세요.

이 절차는 Flutter 시작 경로가 macOS로 시작되었을 때, 
[Xcode][] {{site.appnow.xcode}}를 설치했다고 가정합니다.

{% include docs/install/compiler/xcode.md target='iOS' devos='macOS' attempt="next" -%}

{% include docs/install/flutter-doctor.md target='iOS' devos='macOS' config='macOSDesktopiOS' %}

[Xcode]: {{site.apple-dev}}/xcode/
