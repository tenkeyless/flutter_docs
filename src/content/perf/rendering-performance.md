---
# title: Improving rendering performance
title: 렌더링 성능 향상
# description: How to measure and evaluate your app's rendering performance.
description: 앱의 렌더링 성능을 측정하고 평가하는 방법.
---

{% render docs/performance.md %}

앱에서 애니메이션을 렌더링하는 것은 성능 측정과 관련하여 가장 많이 언급되는 관심 주제 중 하나입니다. 
부분적으로 Flutter의 Skia 엔진과 위젯을 빠르게 만들고 폐기할 수 있는 기능 덕분에, 
Flutter 애플리케이션은 기본적으로 성능이 좋으므로, 
우수한 성능을 달성하기 위해 일반적인 함정만 피하면 됩니다.

## 일반적인 조언 {:#general-advice}

janky(부드럽지 않은) 애니메이션이 보이면, _profile_ 모드로 빌드된 앱으로 성능을 프로파일링하고 있는지 **확인**하세요. 
기본 Flutter 빌드는 릴리스 성능을 나타내지 않는, _debug_ 모드로 앱을 만듭니다. 
자세한 내용은 [Flutter의 빌드 모드][Flutter's build modes]를 참조하세요.

몇 가지 일반적인 함정:

* 예상보다 훨씬 더 많은 UI를 각 프레임에서 다시 빌드합니다. 
  위젯 다시 빌드를 추적하려면, [성능 데이터 표시][Show performance data]를 참조하세요.
* ListView를 사용하는 대신, 많은 children 리스트를 직접 빌드합니다.

일반적인 함정에 대한 정보를 포함하여 성능 평가에 대한 자세한 내용은 다음 문서를 참조하세요.

* [성능 모범 사례][Performance best practices]
* [Flutter 성능 프로파일링][Flutter performance profiling]


## 모바일 전용 조언 {:#mobile-only-advice}

모바일 앱에서 눈에 띄는 jank가 보이지만, 애니메이션을 처음 실행할 때만 그런가요? 
그렇다면, [모바일에서 셰이더 애니메이션 jank 줄이기][Reduce shader animation jank on mobile]를 참조하세요.

[Reduce shader animation jank on mobile]: /perf/shader

## 웹 전용 조언 {:#web-only-advice}

다음 글 시리즈에서는 Flutter Material 팀이 웹에서 Flutter Gallery 앱의 성능을 개선하면서 배운 내용을 다룹니다.

* [트리 셰이킹 및 지연된 로딩을 사용하여 Flutter 웹 앱에서 성능 최적화][shaking]
* [이미지 플레이스홀더, 사전 캐싱 및 비활성화된 탐색 전환을 사용하여 인식된 성능 개선][images]
* [성능이 좋은 Flutter 위젯 빌드][Building performant Flutter widgets]

[Building performant Flutter widgets]: {{site.flutter-medium}}/building-performant-flutter-widgets-3b2558aa08fa
[Flutter's build modes]: /testing/build-modes
[Flutter performance profiling]: /perf/ui-performance
[images]: {{site.flutter-medium}}/improving-perceived-performance-with-image-placeholders-precaching-and-disabled-navigation-6b3601087a2b
[Performance best practices]: /perf/best-practices
[shaking]: {{site.flutter-medium}}/optimizing-performance-in-flutter-web-apps-with-tree-shaking-and-deferred-loading-535fbe3cd674
[Show performance data]: /tools/android-studio#show-performance-data
