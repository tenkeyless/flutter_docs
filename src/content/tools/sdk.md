---
# title: Flutter SDK overview
title: Flutter SDK 개요
# short-title: Flutter SDK
short-title: Flutter SDK
# description: Flutter libraries and command-line tools.
description: Flutter 라이브러리 및 명령줄 도구.
---

Flutter SDK에는 여러 플랫폼에서 Flutter 앱을 개발하는 데 필요한 패키지와 명령줄 도구가 있습니다. 
Flutter SDK를 받으려면 [설치][Install]를 참조하세요.

## Flutter SDK에는 무엇이 있나요? {:#whats-in-the-flutter-sdk}

Flutter SDK를 통해 다음을 사용할 수 있습니다.

* [Dart SDK][]
* 텍스트에 대한 뛰어난 지원을 제공하는, 고도로 최적화된 모바일 우선 2D 렌더링 엔진
* 현대적인 React 스타일 프레임워크
* Material Design 및 iOS 스타일을 구현하는 풍부한 위젯 세트
* 유닛 및 통합 테스트를 위한 API
* 시스템 및 타사 SDK에 연결하기 위한 Interop 및 플러그인 API
* Windows, Linux 및 Mac에서 테스트를 실행하기 위한 헤드리스 테스트 러너
* 앱을 테스트, 디버깅 및 프로파일링하기 위한 [Flutter DevTools][]
* 앱을 만들고, 빌드하고, 테스트하고, 컴파일하기 위한 `flutter` 및 `dart` 명령줄 도구

참고: Flutter SDK에 대한 자세한 내용은 [README 파일][README file]을 참조하세요.

## `flutter` 명령줄 도구 {:#flutter-command-line-tool}

[`flutter` CLI 도구][`flutter` CLI tool] (`flutter/bin/flutter`)는 
개발자(또는 개발자를 대신하는 IDE)가 Flutter와 상호 작용하는 방식입니다.

## `dart` 명령줄 도구 {:#dart-command-line-tool}

[`dart` CLI 도구][`dart` CLI tool]는 `flutter/bin/dart`의 Flutter SDK와 함께 사용할 수 있습니다.

[Flutter DevTools]: /tools/devtools
[Dart SDK]: {{site.dart-site}}/tools/sdk
[`dart` CLI tool]: {{site.dart-site}}/tools/dart-tool
[`flutter` CLI tool]: /reference/flutter-cli
[Install]: /get-started/install
[README file]: {{site.repo.flutter}}/blob/master/README.md
