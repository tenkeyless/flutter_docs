---
# title: Start building Flutter native desktop apps on macOS
title: macOS에서 Flutter 네이티브 데스크톱 앱 빌드 시작
# description: Configure your system to develop Flutter desktop apps on macOS.
description: macOS에서 Flutter 데스크톱 앱을 개발하도록 시스템을 구성하세요.
# short-title: Make macOS desktop apps
short-title: macOS 데스크톱 앱 만들기
target: desktop
config: macOSDesktop
devos: macOS
next:
  # title: Create a test app
  title: 테스트 앱 만들기
  path: /get-started/test-drive
---

{% include docs/install/reqs/macos/base.md os=devos target=target %}

{% include docs/install/flutter-sdk.md os=devos target=target terminal='Terminal' %}

{% include docs/install/compiler/xcode.md os=devos target=target attempt='first' %}

{% include docs/install/flutter-doctor.md devos=devos target=target config=config %}

{% include docs/install/next-steps.md devos=devos target=target config=config %}
