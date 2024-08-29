---
# title: Start building Flutter web apps on Windows
title: Windows에서 Flutter 웹 앱 빌드 시작
# description: Configure your system to develop Flutter web apps on Windows.
description: Windows에서 Flutter 웹앱을 개발하도록 시스템을 구성하세요.
# short-title: Make web apps
short-title: 웹 앱 만들기
target: web
config: WindowsWeb
devos: Windows
next:
  # title: Create a test app
  title: 테스트 앱 만들기
  path: /get-started/test-drive
---

{% include docs/install/reqs/windows/base.md os=devos target=target %}

{% include docs/install/flutter-sdk.md os=devos target=target terminal='PowerShell' -%}

{% include docs/install/flutter-doctor.md devos=devos target=target config='WindowsWeb' -%}

{% include docs/install/next-steps.md devos=devos target=target config=config %}
