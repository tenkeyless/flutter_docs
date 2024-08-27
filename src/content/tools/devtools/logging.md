---
# title: Use the Logging view
title: Logging 뷰 사용
# description: Learn how to use the DevTools logging view.
description: DevTools 로깅 뷰를 사용하는 방법을 알아보세요.
---

:::note
로깅 뷰는 모든 Flutter 및 Dart 애플리케이션에서 작동합니다.
:::

## 그것은 무엇입니까? {:#what-is-it}

로깅 뷰에는 Dart 런타임, 애플리케이션 프레임워크(예: Flutter) 및 애플리케이션 수준 레벨 이벤트의 이벤트가 표시됩니다.

## 표준 로깅 이벤트 {:#standard-logging-events}

기본적으로, 로깅 뷰는 다음을 표시합니다.

* Dart 런타임의 가비지 수집 이벤트
* 프레임 생성 이벤트와 같은, Flutter 프레임워크 이벤트
* 애플리케이션의 `stdout` 및 `stderr`
* 애플리케이션의 커스텀 로깅 이벤트

![Screenshot of a logging view](/assets/images/docs/tools/devtools/logging_log_entries.png){:width="100%"}

## 애플리케이션에서 로깅 {:#logging-from-your-application}

코드에 로깅을 구현하려면, [프로그래밍 방식으로 Flutter 앱 디버깅][Debugging Flutter apps programmatically] 페이지의 [로깅][Logging] 섹션을 참조하세요.

## 로그 지우기 {:#clearing-logs}

로깅 뷰에서 로그 항목을 지우려면, **Clear logs** 버튼을 클릭하세요.

[Logging]: /testing/code-debugging#add-logging-to-your-application
[Debugging Flutter apps programmatically]: /testing/code-debugging

## 기타 리소스 {:#other-resources}

다양한 로깅 방법과 DevTools를 효과적으로 사용하여, 
Flutter 앱을 더 빠르게 분석하고 디버깅하는 방법에 대해 알아보려면, 
가이드 [로깅 뷰 튜토리얼][logging-tutorial]을 확인하세요.

[logging-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-logging-view-part-5-of-8-b634f3a3af26
