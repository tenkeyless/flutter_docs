---
# title: Performance best practices
title: 성능 모범 사례
# short-title: Best practices
short-title: 모범 사례
# description: How to ensure that your Flutter app is performant.
description: Flutter 앱의 성능을 보장하는 방법
---

{% render docs/performance.md %}

일반적으로, Flutter 애플리케이션은 기본적으로 성능이 좋으므로, 우수한 성능을 얻으려면 일반적인 함정만 피하면 됩니다. 
이러한 모범 사례 권장 사항은 가능한 가장 성능이 좋은 Flutter 앱을 작성하는 데 도움이 됩니다.

:::note
Flutter에서 웹 앱을 작성하고 있다면, 
Flutter Material 팀이 [Flutter Gallery][] 앱을 수정하여 웹에서 더 나은 성능을 낼 수 있도록 한 후, 
작성한 일련의 글에 관심이 있을 수 있습니다.

* [트리 셰이킹 및 지연된 로딩(deferred loading)을 사용하여 Flutter 웹 앱에서 성능 최적화][web-perf-1]
* [이미지 플레이스홀더, 사전 캐싱 및 비활성화된 탐색 전환을 사용하여 인지된 성능 개선][web-perf-2]
* [성능이 좋은 Flutter 위젯 빌드][web-perf-3]
:::

[Flutter Gallery]: {{site.gallery-archive}}
[web-perf-1]: {{site.flutter-medium}}/optimizing-performance-in-flutter-web-apps-with-tree-shaking-and-deferred-loading-535fbe3cd674
[web-perf-2]: {{site.flutter-medium}}/improving-perceived-performance-with-image-placeholders-precaching-and-disabled-navigation-6b3601087a2b
[web-perf-3]: {{site.flutter-medium}}/building-performant-flutter-widgets-3b2558aa08fa

장면을 가장 효율적으로 렌더링하기 위해 Flutter 앱을 어떻게 디자인합니까? 
특히, 프레임워크에서 생성된 페인팅 코드가 가능한 한 효율적이도록 어떻게 보장합니까? 
일부 렌더링 및 레이아웃 작업은 느린 것으로 알려져 있지만, 항상 피할 수는 없습니다. 
아래 지침에 따라 신중하게 사용해야 합니다.

## 비용이 많이 드는 작업 최소화 {:#minimize-expensive-operations}

일부 작업은 다른 작업보다 비용이 많이 들며, 이는 더 많은 리소스를 소모한다는 것을 의미합니다. 
분명히, 이러한 작업은 필요할 때만 사용하고 싶을 것입니다. 
앱의 UI를 디자인하고 구현하는 방법은 앱이 얼마나 효율적으로 실행되는지에 큰 영향을 미칠 수 있습니다.

### build() 비용 제어 {:#control-build-cost}

UI를 디자인할 때 염두에 두어야 할 몇 가지 사항은 다음과 같습니다.

* 조상 위젯이 다시 빌드될 때 `build()`가 자주 호출될 수 있으므로, `build()` 메서드에서 반복적이고 비용이 많이 드는 작업을 피하십시오.
* 큰 `build()` 함수가 있는 너무 큰 단일 위젯을 피하십시오. 캡슐화와 변경 방식에 따라 위젯을 여러 위젯으로 분할하십시오.
  * `State` 객체에서 `setState()`가 호출되면, 모든 하위 위젯이 다시 빌드됩니다. 
    따라서, `setState()` 호출을 UI가 실제로 변경되어야 하는, 하위 트리의 일부로 지역화하십시오. 
    변경 사항이 트리의 작은 부분에 포함된 경우, 트리에서 위쪽에 있는 `setState()`를 호출하지 마십시오.
  * 이전 프레임과 동일한 자식 위젯 인스턴스가 다시 발생하면, 모든 하위 위젯을 다시 빌드하는 트래버설이 중지됩니다. 
    이 기술은 애니메이션이 자식 하위 트리에 영향을 미치지 않는 애니메이션을 최적화하기 위해, 프레임워크 내부에서 많이 사용됩니다. 
    [`TransitionBuilder`][] 패턴과 [`SlideTransition`의 소스 코드][source code for `SlideTransition`]를 참조하세요. 
    이 원칙을 사용하면, 애니메이션을 적용할 때 하위 요소를 다시 빌드하지 않아도 됩니다. 
    ("동일한 인스턴스"는 `operator ==`를 사용하여 평가되지만, 
    이 페이지 끝에 있는 함정 섹션에서 `operator ==`를 재정의하지 않는 경우에 대한 조언을 참조하세요.)
  * 위젯에서 `const` 생성자를 최대한 사용하세요. 
    Flutter가 대부분의 다시 빌드 작업을 단축할 수 있기 때문입니다. 
    가능한 경우 `const`를 사용하도록 자동으로 상기시키려면 [`flutter_lints`][] 패키지에서 권장하는 lint를 활성화하세요.
    자세한 내용은 [`flutter_lints` 마이그레이션 가이드][`flutter_lints` migration guide]를 확인하세요.
  * 재사용 가능한 UI를 만들려면, 함수 대신 [`StatelessWidget`][]을 사용하는 것이 좋습니다.

자세한 내용은 다음을 확인하세요.

* [성능 고려 사항][Performance considerations], [`StatefulWidget`][] API 문서의 일부
* [위젯 vs 헬퍼 메서드][Widgets vs helper methods], 공식 Flutter YouTube 채널의 비디오로, 
  위젯(특히 `const` 생성자가 있는 위젯)이 함수보다 성능이 뛰어난 이유를 설명합니다.

[`flutter_lints`]: {{site.pub-pkg}}/flutter_lints
[`flutter_lints` migration guide]: /release/breaking-changes/flutter-lints-package#migration-guide
[Performance considerations]: {{site.api}}/flutter/widgets/StatefulWidget-class.html#performance-considerations
[source code for `SlideTransition`]: {{site.repo.flutter}}/blob/master/packages/flutter/lib/src/widgets/transitions.dart#L168
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`TransitionBuilder`]: {{site.api}}/flutter/widgets/TransitionBuilder.html
[Widgets vs helper methods]: {{site.yt.watch}}?v=IOyq-eTRhvo

---

### saveLayer()를 신중하게 사용하기 {:#use-savelayer-thoughtfully}

일부 Flutter 코드는 UI에서 다양한 시각적 효과를 구현하기 위해, 비용이 많이 드는 연산인 `saveLayer()`를 사용합니다. 
코드에서 `saveLayer()`를 명시적으로 호출하지 않더라도, 사용하는 다른 위젯이나 패키지가 백그라운드에서 호출할 수 있습니다. 
아마도 앱이 필요 이상으로 `saveLayer()`를 호출하고 있을 수 있습니다. 
`saveLayer()`를 과도하게 호출하면, jank가 발생할 수 있습니다.

#### saveLayer가 비싼 이유는 ​​무엇인가요? {:#why-is-savelayer-expensive}

`saveLayer()`를 호출하면, 오프스크린 버퍼가 할당되고, 오프스크린 버퍼에 콘텐츠를 그리면, 렌더 타겟 전환이 트리거될 수 있습니다. 
GPU는 소방호스처럼 실행되고 싶어하며, 렌더 타겟 전환은 GPU가 해당 스트림을 일시적으로 리디렉션한 다음, 그리고나서 다시 리디렉션하도록 강제합니다. 
모바일 GPU에서 이는 렌더링 처리량에 특히 방해가 됩니다.

#### saveLayer는 언제 필요한가요? {:#when-is-savelayer-required}

런타임에, 서버에서 오는 다양한 모양을 동적으로 표시해야 하는 경우,
(예: 각각에 투명도(transparency)가 있고, 겹칠 수도 있고 겹치지 않을 수도 있음)에는, 
`saveLayer()`를 사용해야 합니다.

#### saveLayer에 대한 디버깅 호출 {:#debugging-calls-to-savelayer}

앱에서 직접 또는 간접적으로, `saveLayer()`를 호출하는 빈도를 어떻게 알 수 있을까요? 
`saveLayer()` 메서드는 [DevTools 타임라인][DevTools timeline]에서 이벤트를 트리거합니다. 
[DevTools Performance 뷰][DevTools Performance view]에서 `PerformanceOverlayLayer.checkerboardOffscreenLayers` 스위치를 확인하여 장면에서, `saveLayer`를 사용하는 시기를 알아보세요.

[DevTools timeline]: /tools/devtools/performance#timeline-events-tab

#### saveLayer에 대한 호출 최소화 {:#minimizing-calls-to-savelayer}

`saveLayer`에 대한 호출을 피할 수 있나요? 시각적 효과를 만드는 방법을 재고해야 할 수도 있습니다.

* 호출이 _당신의_ 코드에서 오는 경우, 이를 줄이거나 제거할 수 있나요? 
  예를 들어, 당신의 UI가 각각 0이 아닌 투명도를 가진, 두 개의 도형을 겹쳐 놓을 수 있습니다.
  * 항상 같은 양, 같은 방식으로, 같은 투명도로 겹쳐 놓는 경우, 
    겹쳐진 반투명 객체가 어떻게 보이는지 미리 계산하고 캐시한 다음, 
    `saveLayer()`를 호출하는 대신 사용할 수 있습니다. 
    이는 미리 계산할 수 있는 모든 정적 도형에서 작동합니다.
  * 겹쳐지는 것을 완전히 피하기 위해 페인팅 로직을 리팩토링할 수 있나요?
{% comment %}
TBD: It would be nice if we could link to an example.
  Kenzie suggested to John and Tao that we add an
  example to perf_diagnosis_demo. Michael indicated
  that he doesn't have a saveLayer demo.
{% endcomment %}

* 호출이 본인이 소유하지 않은 패키지에서 오는 경우, 패키지 소유자에게 연락하여 왜 이 호출이 필요한지 물어보세요. 
  호출이 줄어들거나 없어질 수 있을까요? 그렇지 않다면, 다른 패키지를 찾거나 직접 작성해야 할 수도 있습니다.

:::note 패키지 소유자에게 참고 사항
모범 사례로서, 패키지에 `saveLayer`가 필요할 수 있는 경우, 
이를 피하는 방법, 그리고 이를 피할 수 없는 경우에 대한 문서를 제공하는 것을 고려하세요.
:::

`saveLayer()`를 트리거할 수 있고, 잠재적으로 비용이 많이 드는 다른 위젯:

* [`ShaderMask`][]
* [`ColorFilter`][]
* [`Chip`][]&mdash;`disabledColorAlpha != 0xff`인 경우, `saveLayer()`에 대한 호출을 트리거할 수 있음
* [`Text`][]&mdash;`overflowShader`가 있는 경우, `saveLayer()`에 대한 호출을 트리거할 수 있음

[`Chip`]: {{site.api}}/flutter/material/Chip-class.html
[`ColorFilter`]: {{site.api}}/flutter/dart-ui/ColorFilter-class.html
[`FadeInImage`]: {{site.api}}/flutter/widgets/FadeInImage-class.html
[`Opacity`]: {{site.api}}/flutter/widgets/Opacity-class.html
[`ShaderMask`]: {{site.api}}/flutter/widgets/ShaderMask-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[Transparent image]: {{site.api}}/flutter/widgets/Opacity-class.html#transparent-image

---

### opacity와 clipping 사용 최소화 {:#minimize-use-of-opacity-and-clipping}

Opacity는 clipping과 마찬가지로, 비용이 많이 드는 작업입니다. 다음은 유용할 수 있는 몇 가지 팁입니다.

* 필요할 때만 [`Opacity`][] 위젯을 사용하세요. 
  * `Opacity` API 페이지의 [Transparent image][] 섹션에서 이미지에 불투명도를 직접 적용하는 예를 확인할 수 있습니다. 
    * 이는 `Opacity` 위젯을 사용하는 것보다 빠릅니다.
* 간단한 모양이나 텍스트를 `Opacity` 위젯으로 래핑하는 대신, 반투명 색상으로 그리는 것이 일반적으로 더 빠릅니다. 
  (단, 이는 그릴 모양에 겹치는 비트가 없는 경우에만 작동합니다.)
* 이미지 페이딩을 구현하려면, GPU의 프래그먼트 셰이더를 사용하여 점진적 불투명도를 적용하는, 
  [`FadeInImage`][] 위젯을 사용하는 것을 고려하세요. 
    자세한 내용은 [`Opacity`][] 문서를 확인하세요.
* **Clipping**은 `saveLayer()`를 호출하지 않습니다. (`Clip.antiAliasWithSaveLayer`로 명시적으로 요청하지 않는 한) 
  * 따라서, 이러한 작업은 `Opacity`만큼 비용이 많이 들지 않지만, 
    클리핑은 여전히 ​​비용이 많이 들기 때문에 주의해서 사용해야 합니다. 
  * 기본적으로, 클리핑은 비활성화되어 있으므로(`Clip.none`), 필요할 때 명시적으로 활성화해야 합니다.
* 모서리가 둥근 사각형을 만들려면, clipping 사각형을 적용하는 대신, 
  많은 위젯 클래스에서 제공하는 `borderRadius` 속성을 사용하는 것을 고려하세요.

---

### 그리드와 리스트를 신중하게 구현하기 {:#implement-grids-and-lists-thoughtfully}

그리드와 리스트가 구현된 방식이 앱의 성능 문제를 일으킬 수 있습니다. 
이 섹션에서는 그리드와 리스트를 만들 때 중요한 모범 사례와, 
앱에서 과도한 레이아웃 패스를 사용하는지 여부를 확인하는 방법을 설명합니다.

#### lazy가 되세요! {:#be-lazy}

큰 그리드나 리스트를 빌드할 때는, 콜백과 함께, 지연 빌더(lazy builder) 메서드를 사용합니다. 
그러면, 시작 시 화면에서 보이는 부분만 빌드됩니다.

자세한 내용과 예는 다음을 확인하세요.

* [쿡북][Cookbook]의 [긴 리스트로 작업하기][Working with long lists]
* [한 번에 한 페이지씩 로드하는 `ListView` 만들기][Creating a `ListView` that loads one page at a time] by AbdulRahman AlHamali의 커뮤니티 문서
* [`Listview.builder`][] API

[Cookbook]: /cookbook
[Creating a `ListView` that loads one page at a time]: {{site.medium}}/saugo360/flutter-creating-a-listview-that-loads-one-page-at-a-time-c5c91b6fabd3
[`Listview.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[Working with long lists]: /cookbook/lists/long-lists


#### 내재적 요소(intrinsics)를 피하세요 {:#avoid-intrinsics}

내재적 패스(intrinsic passes)가 그리드와 리스트에 문제를 일으킬 수 있는 방법에 대한 정보는, 다음 섹션을 참조하세요.

---

### 내재적인 작업(intrinsic operations)으로 인해 발생하는 레이아웃 패스를 최소화 {:#minimize-layout-passes-caused-by-intrinsic-operations}

Flutter 프로그래밍을 많이 했다면, UI를 만들 때 [레이아웃과 제약 조건의 작동 방식][how layout and constraints work]에 익숙할 것입니다. 
Flutter의 기본 레이아웃 규칙을 암기했을 수도 있습니다. **제약 조건은 아래로 가고, 크기는 위로 갑니다. 부모는 위치를 설정합니다.**

일부 위젯, 특히 그리드와 리스트의 경우, 레이아웃 프로세스가 비쌀 수 있습니다. 
Flutter는 위젯에 대해 단 한 번의 레이아웃 패스만 수행하려고 하지만, 
때로는 두 번째 패스(_내재적 패스(intrinsic pass)_ 라고 함)가 필요하며, 이는 성능을 저하시킬 수 있습니다.

#### 내재적 패스(intrinsic pass)란 무엇입니까? {:#what-is-an-intrinsic-pass}

내재적 패스는, 예를 들어, 모든 셀이 가장 크거나 가장 작은 셀의 크기를 갖기를 원할 때 발생합니다. (또는 모든 셀을 폴링해야 하는 유사한 계산)

예를 들어, `Card`의 큰 그리드를 생각해 보세요. 
그리드는 균일한 크기의 셀을 가져야 하므로, 레이아웃 코드는 그리드의 루트(위젯 트리)에서 시작하여, 
그리드의 **각** 카드(보이는 카드만이 아님)에 
(제약 조건이 없다고 가정하고, 위젯이 선호하는 크기인) _내재적(intrinsic)_ 크기를 반환하도록 요청하는 패스를 수행합니다. 
이 정보를 사용하여, 프레임워크는 균일한 셀 크기를 결정하고, 모든 그리드 셀을 두 번째로 다시 방문하여, 각 카드에 사용할 크기를 알려줍니다.

#### 내재적 패스(intrinsic pass) 디버깅 {:#debugging-intrinsic-passes}

과도한 내재적 패스가 있는지 확인하려면, 
DevTools에서 **[레이아웃 추적 옵션][Track layouts option]** 을 활성화하고(기본적으로 비활성화됨), 
앱의 [스택 추적][stack trace]을 확인하여, 수행된 레이아웃 패스 수를 알아보세요. 
추적을 활성화하면, 내재적 타임라인 이벤트에 '$runtimeType intrinsics'라는 레이블이 지정됩니다.

#### 내재적 패스(intrinsic pass) 피하기 {:#avoiding-intrinsic-passes}

내재적 패스를 피하기 위한 몇 가지 옵션이 있습니다.

* 셀을 미리 고정된 크기로 설정합니다.
* 특정 셀을 "앵커(anchor)" 셀로 선택합니다. 
  모든 셀은 이 셀을 기준으로 크기가 조정됩니다. 
  먼저 자식 앵커를 배치한 다음, 그리고나서 다른 자식을 그 주변에 배치하는 커스텀 [`RenderObject`][]를 작성합니다.

레이아웃이 작동하는 방식을 더 자세히 알아보려면, [Flutter 아키텍처 개요][Flutter architectural overview]의 [레이아웃 및 렌더링][layout and rendering] 섹션을 확인하세요.

[Flutter architectural overview]: /resources/architectural-overview
[how layout and constraints work]: /ui/layout/constraints
[layout and rendering]: /resources/architectural-overview#layout-and-rendering
[stack trace]: /tools/devtools/cpu-profiler#flame-chart
[Track layouts option]: /tools/devtools/performance#track-layouts

---

### 16ms 안에 프레임을 빌드하고 디스플레이하기 {:#build-and-display-frames-in-16ms}

빌드와 렌더링을 위한 두 개의 별도 스레드가 있으므로, 빌드에 16ms, 60Hz 디스플레이에서 렌더링에 16ms가 걸립니다. 
지연 시간이 문제라면, 16ms _또는 그 이하_ 로 프레임을 빌드하고 표시하세요. 
즉, 8ms 이하로 빌드하고, 8ms 이하로 렌더링하여, 총 16ms 이하가 됩니다.

프레임이 [프로필 모드][profile mode]에서 총 16ms 이하로 렌더링되는 경우, 
성능에 대한 걱정은 하지 않아도 되지만 가능한 한 빨리 프레임을 빌드하고 렌더링하는 것을 목표로 해야 합니다. 이유는 무엇일까요?

* 프레임 렌더링 시간을 16ms 이하로 낮추면 시각적인 차이는 없을 수 있지만, **배터리 수명**과 열 문제가 개선됩니다.
* 기기에서 잘 실행될 수 있지만, 타겟팅하는 가장 낮은 기기의 성능을 고려하세요.
* 120fps 기기가 더 널리 보급됨에 따라, 가장 매끄러운 경험을 제공하기 위해 프레임을 8ms(전체) 이내로 렌더링해야 합니다.

60fps가 매끄러운 시각적 경험으로 이어지는 이유가 궁금하다면, [왜 60fps인가?][Why 60fps?] 비디오를 확인하세요.

[profile mode]: /testing/build-modes#profile
[Why 60fps?]: {{site.yt.watch}}?v=CaMTIgxCSqU

## 함정 {:#pitfalls}

앱의 성능을 조정해야 하거나, UI가 예상만큼 매끄럽지 않은 경우, 
[DevTools 성능 뷰][DevTools Performance view]가 도움이 될 수 있습니다!

또한, IDE용 Flutter 플러그인이 유용할 수 있습니다. 
Flutter 성능 창에서, **위젯 재구축 정보 표시(Show widget rebuild information)** 확인란을 활성화합니다. 
이 기능은 프레임이 16ms 이상 렌더링되고 표시되는 경우를 감지하는 데 도움이 됩니다. 
가능한 경우, 플러그인은 관련 팁에 대한 링크를 제공합니다.

다음 동작은 앱 성능에 부정적인 영향을 미칠 수 있습니다.

* `Opacity` 위젯을 사용하지 말고, 특히 애니메이션에서는 사용하지 마세요. 
  * 대신, `AnimatedOpacity` 또는 `FadeInImage`를 사용하세요. 
  * 자세한 내용은 [불투명도 애니메이션의 성능 고려 사항][Performance considerations for opacity animation]을 참조하세요.

* `AnimatedBuilder`를 사용할 때는, 애니메이션에 의존하지 않는 위젯을 빌드하는, 빌더 함수에 하위 트리를 두지 마세요. 
  * 이 하위 트리는 애니메이션의 모든 틱마다 다시 빌드됩니다. 
  * 대신, 하위 트리의 해당 부분을 한 번 빌드하여 `AnimatedBuilder`에 자식으로 전달하세요. 
  * 자세한 내용은 [성능 최적화][Performance optimizations]를 참조하세요.

* 애니메이션에서 클리핑을 사용하지 마세요. 
  * 가능하면, 애니메이션을 적용하기 전에 이미지를 미리 클리핑하세요.

* 대부분의 자식이 화면에 표시되지 않는 경우, 
  빌드 비용을 피하기 위해 concrete (`Column()` 또는 `ListView()`와 같은) children의 `List`가 있는 생성자를 사용하지 마세요.

* `Widget` 객체에서 `operator ==`를 재정의하지 마세요. 불
  * 필요한 재구축을 피하는 데 도움이 될 것처럼 보일 수 있지만, 실제로는 O(N²) 동작으로 이어지기 때문에 성능이 저하됩니다. 
    * 이 규칙의 유일한 예외는 leaf 위젯(자식이 없는 위젯)으로, 
      위젯의 속성을 비교하는 것이 위젯을 재구축하는 것보다 훨씬 효율적일 가능성이 높고, 
      위젯이 구성을 거의 변경하지 않는 특정한 경우입니다. 
  * 그러한 경우에도, 일반적으로 위젯을 캐싱하는 것이 더 바람직합니다. 
    * `operator ==`를 한 번만 재정의해도 컴파일러가 호출이 항상 정적이라고 가정할 수 없기 때문에, 전반적인 성능 저하가 발생할 수 있기 때문입니다.

## 리소스 {:#resources}

더 많은 성능 정보는, 다음 리소스를 확인하세요.

* AnimatedBuilder API 페이지의 [성능 최적화][Performance optimizations]
* Opacity API 페이지의 [불투명도 애니메이션에 대한 성능 고려 사항][Performance considerations for opacity animation]
* ListView API 페이지의 [자식 요소의 수명 주기][Child elements' lifecycle] 및 효율적으로 로드하는 방법
* `StatefulWidget`의 [성능 고려 사항][Performance considerations]
* [Flutter 웹 로딩 속도 최적화를 위한 모범 사례][best-practices-medium]

[Child elements' lifecycle]: {{site.api}}/flutter/widgets/ListView-class.html#child-elements-lifecycle
[`CustomPainter`]: {{site.api}}/flutter/rendering/CustomPainter-class.html
[DevTools Performance view]: /tools/devtools/performance
[Performance optimizations]: {{site.api}}/flutter/widgets/AnimatedBuilder-class.html#performance-optimizations
[Performance considerations for opacity animation]: {{site.api}}/flutter/widgets/Opacity-class.html#performance-considerations-for-opacity-animation
[`RenderObject`]: {{site.api}}/flutter/rendering/RenderObject-class.html
[best-practices-medium]: https://medium.com/flutter/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
