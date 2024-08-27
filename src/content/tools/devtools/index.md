---
# title: Flutter and Dart DevTools
title: Flutter 및 Dart DevTools
# description: How to use Flutter DevTools with Flutter.
description: Flutter와 함께 Flutter DevTools를 사용하는 방법.
---

## DevTools이란 무엇인가요? {:#what-is-devtools}

DevTools는 Dart 및 Flutter용 성능 및 디버깅 도구 모음입니다. 
_Flutter DevTools_ 와 _Dart DevTools_ 는 **동일한 도구 모음**을 말합니다.

![Dart DevTools Screens](/assets/images/docs/tools/devtools/dart-devtools.gif){:width="100%"}

DevTools에 대한 비디오 소개를 보려면, 다음의 심층 분석 및 사용 사례 연습을 확인하세요.

{% ytEmbed '_EYk-E29edo', 'Flutter와 Dart DevTools에 대해 알아보세요' %}

## DevTools로 무엇을 할 수 있나요? {:#what-can-i-do-with-devtools}

DevTools로 할 수 있는 몇 가지 작업은 다음과 같습니다.

* Flutter 앱의 UI 레이아웃과 상태를 검사합니다.
* Flutter 앱에서 UI jank 성능 문제를 진단합니다.
* Flutter 또는 Dart 앱의 CPU 프로파일링.
* Flutter 앱의 네트워크 프로파일링.
* Flutter 또는 Dart 앱의 소스 레벨 디버깅.
* Flutter 또는 Dart 명령줄 앱에서 메모리 문제를 디버깅합니다.
* 실행 중인 Flutter 또는 Dart 명령줄 앱에 대한 일반 로그 및 진단 정보를 확인합니다.
* 코드와 앱 크기를 분석합니다.
* Android 앱에서 딥 링크를 검증합니다.

기존 IDE 또는 명령줄 기반 개발 워크플로와 함께 DevTools를 사용하기를 기대합니다.

<a id="how-do-i-install-devtools"></a>
<a id="install-devtools"></a>

## DevTools를 시작하는 방법 {:#start}

DevTools를 시작하는 방법에 대한 지침은 
[VS Code][], [Android Studio/IntelliJ][] 또는 [명령줄][command line] 페이지를 참조하세요.

## 일부 표준 문제 해결 {:#troubleshooting-some-standard-issues}

**질문**: 앱이 janky 하거나 끊깁니다. 어떻게 해결해야 하나요?

**답변**: 성능 문제로 인해 [UI 프레임][UI frames]이 janky 하거나, 일부 작업이 느려질 수 있습니다.

  1. 구체적인 지연 프레임에 영향을 미치는 코드를 감지하려면, [Performance > Timeline][]에서 시작합니다.
  2. 백그라운드에서 가장 많은 CPU 시간을 차지하는 코드를 알아보려면, [CPU profiler][]를 사용합니다.

자세한 내용은 [성능][Performance] 페이지를 확인하세요.

**질문**: 가비지 수집(GC) 이벤트가 많이 발생하는 것을 봅니다. 이게 문제일까요?

**답변**: 빈번한 GC 이벤트는 DevTools > Memory > Memory chart에 표시될 수 있습니다. 대부분의 경우, 문제가 아닙니다.

앱에 유휴 시간이 있는 빈번한 백그라운드 활동이 있는 경우, 
Flutter는 이 기회를 이용하여 성능에 영향을 미치지 않고 생성된 객체를 수집할 수 있습니다.

[CPU profiler]: /tools/devtools/cpu-profiler
[Performance]: /perf
[Performance > Timeline]: /tools/devtools/performance#timeline-events-tab
[UI frames]: /perf/ui-performance

## 피드백 제공 {:#providing-feedback}

DevTools를 사용해 보시고 피드백을 제공하고, [DevTools 이슈 트래커][DevTools issue tracker]에 이슈를 등록해 주세요. 감사합니다!

## 기타 리소스 {:#other-resources}

Flutter 앱 디버깅 및 프로파일링에 대한 자세한 내용은, 
[디버깅][Debugging] 페이지와 특히 [다른 리소스][other resources] 리스트를 참조하세요.

Dart 명령줄 앱에서 DevTools를 사용하는 방법에 대한 자세한 내용은, 
[dart.dev의 DevTools 문서]({{site.dart-site}}/tools/dart-devtools)를 참조하세요.

[Android Studio/IntelliJ]: /tools/devtools/android-studio
[VS Code]: /tools/devtools/vscode
[command line]: /tools/devtools/cli
[DevTools issue tracker]: {{site.github}}/flutter/devtools/issues
[Debugging]: /testing/debugging
[Other resources]: /testing/debugging#other-resources
