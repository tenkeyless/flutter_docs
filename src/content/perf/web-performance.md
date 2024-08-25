---
# title: Debug performance for web apps
title: 웹앱의 성능 디버그
# description: Learn how to use Chrome DevTools to debug web performance issues.
description: Chrome DevTools를 사용하여 웹 성능 문제를 디버깅하는 방법을 알아보세요.
---

:::note
Flutter 웹앱을 프로파일링하려면 Flutter 버전 3.14 이상이 필요합니다.
:::

Flutter 프레임워크는 프레임을 빌드하고, 장면을 그리며, (가비지 수집과 같은) 다른 활동을 추적하는 동안, 
타임라인 이벤트를 내보냅니다. 
이러한 이벤트는 디버깅을 위해 [Chrome DevTools 성능 패널][Chrome DevTools performance panel]에 노출됩니다.

:::note
웹 로딩 속도를 최적화하는 방법에 대한 자세한 내용은, 
Medium의 (무료) 글인 [Flutter 웹 로딩 속도 최적화 모범 사례][article]를 확인하세요.

[article]: {{site.flutter-medium}}/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
:::

`dart:developer` [Timeline][] 및 [TimelineTask][] API를 사용하여, 
추가적인 성능 분석을 위해 자체 타임라인 이벤트를 내보낼 수도 있습니다.

[Chrome DevTools performance panel]: https://developer.chrome.com/docs/devtools/performance
[Timeline]: {{site.api}}/flutter/dart-developer/Timeline-class.html
[TimelineTask]: {{site.api}}/flutter/dart-developer/TimelineTask-class.html

![Screenshot of the Chrome DevTools performance panel](/assets/images/docs/tools/devtools/chrome-devtools-performance-panel.png)

## 추적을 강화하기 위한 선택적 플래그 {:#optional-flags-to-enhance-tracing}

추적할 타임라인 이벤트를 구성하려면, 앱의 `main` 메서드에서 다음 최상위 속성 중 하나를 `true`로 설정합니다.

- [debugProfileBuildsEnabled][]: 빌드된 모든 `Widget`에 대해, `Timeline` 이벤트를 추가합니다.
- [debugProfileBuildsEnabledUserWidgets][]: 빌드된 모든 사용자 생성 `Widget`에 대해, `Timeline` 이벤트를 추가합니다.
- [debugProfileLayoutsEnabled][]: 모든 `RenderObject` 레이아웃에 대해, `Timeline` 이벤트를 추가합니다.
- [debugProfilePaintsEnabled][]: 페인트된 모든 `RenderObject`에 대해, `Timeline` 이벤트를 추가합니다.

[debugProfileBuildsEnabled]: {{site.api}}/flutter/widgets/debugProfileBuildsEnabled.html
[debugProfileBuildsEnabledUserWidgets]: {{site.api}}/flutter/widgets/debugProfileBuildsEnabledUserWidgets.html
[debugProfileLayoutsEnabled]: {{site.api}}/flutter/rendering/debugProfileLayoutsEnabled.html
[debugProfilePaintsEnabled]: {{site.api}}/flutter/rendering/debugProfilePaintsEnabled.html

## 지침 {:#instructions}

1. _[선택 사항]_ 앱의 메인 메서드에서 원하는 추적 플래그를 true로 설정합니다.
2. Flutter 웹 앱을 [프로필 모드][profile mode]에서 실행합니다.
3. 애플리케이션의 [Chrome DevTools 성능 패널][Chrome DevTools Performance panel]을 열고, [녹화 시작][start recording]하여 타임라인 이벤트를 캡처합니다.

[start recording]: https://developer.chrome.com/docs/devtools/performance/#record

[profile mode]: /testing/build-modes#profile
[Chrome DevTools performance panel]: https://developer.chrome.com/docs/devtools/performance
