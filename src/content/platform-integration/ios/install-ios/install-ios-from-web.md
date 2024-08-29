---
# title: Add iOS as a target platform from web start
title: 웹으로부터 시작하여, iOS를 대상 플랫폼으로 추가 ([macOS] web + iOS)
# description: Configure your system to develop Flutter mobile apps on iOS.
description: iOS에 대해서, Flutter 모바일 앱을 개발하도록 시스템을 구성하세요.
# short-title: Starting from web
short-title: 웹으로부터 시작
---

macOS에서 iOS를 Flutter 앱 대상으로 추가하려면, 다음 절차를 따르세요.

## Xcode 설치 {:#install-xcode}

1. Xcode에 최소 26GB의 스토리지를 할당합니다.
   최적의 구성을 위해 42GB의 스토리지를 할당하는 것을 고려하세요.
1. [Xcode][] {{site.appnow.xcode}}를 설치하여, 
   네이티브 Swift 또는 ObjectiveC 코드를 디버깅하고 컴파일합니다.

{% include docs/install/compiler/xcode.md target='iOS' devos='macOS' attempt="first" -%}

{% include docs/install/flutter-doctor.md target='iOS' devos='macOS' config='macOSiOSWeb' %}

[Xcode]: {{site.apple-dev}}/xcode/
