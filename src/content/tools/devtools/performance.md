---
# title: Use the Performance view
title: 성능 뷰 사용
# description: Learn how to use the DevTools performance view.
description: DevTools 성능 보기를 사용하는 방법을 알아보세요.
---

:::note
DevTools 성능 보기는 Flutter 모바일 및 데스크톱 앱에서 작동합니다. 
웹 앱의 경우, Flutter는 대신 Chrome DevTools의 성능 패널에 타임라인 이벤트를 추가합니다. 
웹 앱 프로파일링에 대해 알아보려면 [웹 성능 디버깅][Debugging web performance]을 확인하세요.
:::

[Debugging web performance]: /perf/web-performance

성능 페이지는 애플리케이션의 성능 문제와 UI jank를 진단하는 데 도움이 될 수 있습니다. 
이 페이지는 애플리케이션의 activity에 대한 타이밍 및 성능 정보를 제공합니다. 
여기에는 앱의 성능 저하 원인을 식별하는 데 도움이 되는 여러 도구가 포함되어 있습니다.

* Flutter 프레임 차트(Flutter 앱 전용)
* 프레임 분석 탭(Flutter 앱 전용)
* 래스터 통계 탭(Flutter 앱 전용)
* 타임라인 이벤트 추적 뷰어(모든 네이티브 Dart 애플리케이션)
* 고급 디버깅 도구(Flutter 앱 전용)

:::secondary
**성능을 분석하려면 애플리케이션의 [프로필 빌드][profile build]를 사용하세요.** 
디버그 모드에서 실행할 때, 프레임 렌더링 시간은 릴리스 성능을 나타내지 않습니다. 
유용한 디버깅 정보가 여전히 보존되는 프로필 모드에서 앱을 실행하세요.
:::

[profile build]: /testing/build-modes#profile

성능 뷰는 데이터 스냅샷 가져오기 및 내보내기도 지원합니다. 
자세한 내용은 [가져오기 및 내보내기][Import and export] 섹션을 확인하세요.

## Flutter에서 프레임이란 무엇인가요? {:#what-is-a-frame-in-flutter}

Flutter는 초당 60프레임(fps) 또는 120Hz 업데이트가 가능한 기기에서는 120fps로 UI를 렌더링하도록 설계되었습니다. 
각 렌더를 _프레임_ 이라고 합니다. 즉, 약 16ms마다 UI가 업데이트되어, 애니메이션이나 UI의 다른 변경 사항을 반영합니다. 
렌더링하는 데 16ms보다 오래 걸리는 프레임은, 디스플레이 기기에서 jank(jerky motion)을 일으킵니다.

## Flutter 프레임 차트 {:#flutter-frames-chart}

이 차트에는 애플리케이션의 Flutter 프레임 정보가 포함되어 있습니다. 
차트에 설정된 각 막대는 단일 Flutter 프레임을 나타냅니다. 
막대는 Flutter 프레임을 렌더링할 때 발생하는 작업의 다른 부분을 강조하기 위해 색상으로 구분되어 있습니다. 
UI 스레드에서 작업하고 래스터 스레드에서 작업합니다.

이 차트에는 애플리케이션의 Flutter 프레임 타이밍 정보가 포함되어 있습니다. 
차트의 각 막대 쌍은 단일 Flutter 프레임을 나타냅니다. 
이 차트에서 프레임을 선택하면 [프레임 분석](#frame-analysis-tab) 탭 또는 
[타임라인 이벤트](#timeline-events-tab) 탭에 아래에 표시된 데이터가 업데이트됩니다. 
([DevTools 2.23.1][]부터, [래스터 통계](#raster-stats-tab)는 프레임당 데이터가 없는 독립 실행형 기능입니다.)

[DevTools 2.23.1]: /tools/devtools/release-notes/release-notes-2.23.1

Flutter 프레임 차트는 앱에서 새 프레임이 그려지면 업데이트됩니다. 
이 차트의 업데이트를 일시 중지하려면 차트 오른쪽에 있는 일시 중지 버튼을 클릭하세요. 
차트 위의 **Flutter frames** 버튼을 클릭하면 이 차트를 축소하여, 
아래의 데이터에 대한 더 많은 보기 공간을 제공할 수 있습니다.

![Screenshot of a Flutter frames chart](/assets/images/docs/tools/devtools/flutter-frames-chart.png)

각 Flutter 프레임을 나타내는 막대 쌍은, Flutter 프레임을 렌더링할 때 발생하는 
작업의 다른 부분(UI 스레드의 작업 및 래스터 스레드의 작업)을 강조하기 위해, 색상으로 구분되어 있습니다.

### UI {:#ui}

UI 스레드는 Dart VM에서 Dart 코드를 실행합니다. 
여기에는 애플리케이션의 코드와 Flutter 프레임워크가 포함됩니다. 
앱에서 장면을 만들고 표시할 때, UI 스레드는 레이어 트리를 만듭니다. 
레이어 트리는 기기에 독립적인 페인팅 명령을 포함하는 가벼운 객체이며, 
레이어 트리를 래스터 스레드로 보내 기기에서 렌더링합니다. 

이 스레드를 차단(block)하지 **마세요**.

### Raster {:#raster}

래스터 스레드는 Flutter 엔진에서 그래픽 코드를 실행합니다. 
이 스레드는 레이어 트리를 가져와 GPU(그래픽 처리 장치)와 통신하여 표시합니다. 
래스터 스레드나 데이터에 직접 액세스할 수는 없지만, 이 스레드가 느리다면, Dart 코드에서 한 작업의 결과입니다. 
그래픽 라이브러리인 Skia가 이 스레드에서 실행됩니다. 
[Impeller][]도 이 스레드를 사용합니다.

[Impeller]: /perf/impeller

때때로 장면은 구성하기 쉬운 레이어 트리를 생성하지만, 래스터 스레드에서 렌더링하기에는 비용이 많이 듭니다. 
이 경우, 렌더링 코드가 느려지는 원인이 되는 코드를 파악해야 합니다. 
특정 종류의 워크로드는 GPU에 더 어렵습니다. 
여기에는 `saveLayer()`에 대한 불필요한 호출, 여러 개체와 교차하는 불투명도, 
특정 상황에서의 클립 또는 그림자가 포함될 수 있습니다.

프로파일링에 대한 자세한 내용은, [GPU 그래프에서 문제 식별][GPU graph]를 확인하세요.

### Jank (느린 프레임) {:#jank-slow-frame}

프레임 렌더링 차트는 빨간색 오버레이로 jank를 보여줍니다. 
프레임이 완료되는 데 약 16ms 이상 걸리는 경우(60 FPS 기기의 경우), janky한 것으로 간주됩니다. 
60 FPS(초당 프레임)의 프레임 렌더링 속도를 달성하려면, 각 프레임이 약 16ms 이내에 렌더링되어야 합니다. 
이 목표를 놓치면 UI jank 또는 프레임 드롭이 발생할 수 있습니다.

앱 성능을 분석하는 방법에 대한 자세한 내용은, 
[Flutter 성능 프로파일링][Flutter performance profiling]을 확인하세요.

### 셰이더 컴파일 {:#shader-compilation}

셰이더 컴파일은 셰이더가 Flutter 앱에서 처음 사용될 때 발생합니다. 
셰이더 컴파일을 수행하는 프레임은 진한 빨간색으로 표시됩니다.

![Screenshot of shader compilation for a frame](/assets/images/docs/tools/devtools/shader-compilation-frames-chart.png)

셰이더 컴파일 jank를 줄이는 방법에 대한 자세한 내용은, [모바일에서 셰이더 컴파일 jank 줄이기][]를 확인하세요.

## 프레임 분석 탭 {:#frame-analysis-tab}

위의 Flutter 프레임 차트에서 janky 프레임(느림, 빨간색으로 표시)을 선택하면, 
프레임 분석 탭에 디버깅 힌트가 표시됩니다. 
이러한 힌트는 앱에서 jank를 진단하는 데 도움이 되며, 
느린 프레임 시간에 기여했을 수 있는 비용이 많이 드는 작업을 감지한 경우 알려줍니다.

![Screenshot of the frame analysis tab](/assets/images/docs/tools/devtools/frame-analysis-tab.png)

## 래스터 통계 탭 {:#raster-stats-tab}

:::note
최상의 결과를 얻으려면, 이 도구는 Impeller 렌더링 엔진과 함께 사용해야 합니다. 
Skia를 사용할 때, 보고된 래스터 통계는 셰이더가 컴파일되는 타이밍으로 인해 일관되지 않을 수 있습니다.
:::

래스터 스레드 시간이 느린 Flutter 프레임이 있는 경우, 이 도구가 느린 성능의 원인을 진단하는 데 도움이 될 수 있습니다. 
래스터 통계를 생성하려면:

1. 래스터 스레드 jank가 나타나는 앱의 화면으로 이동합니다.
2. **Take Snapshot**를 클릭합니다.
3. 다양한 레이어와 해당 렌더링 시간을 확인합니다.

비용이 많이 드는 레이어가 있는 경우, 앱에서 이 레이어를 생성하는 Dart 코드를 찾아 자세히 조사합니다. 
코드를 변경하고, 핫 리로드하고, 새 스냅샷을 찍어, 변경으로 인해 레이어의 성능이 향상되었는지 확인할 수 있습니다.

![Screenshot of the raster stats tab](/assets/images/docs/tools/devtools/raster-stats-tab.png)

## 타임라인 이벤트 탭 {:#timeline-events-tab}

타임라인 이벤트 차트는 애플리케이션의 모든 이벤트 추적을 보여줍니다. 
Flutter 프레임워크는 프레임을 빌드하고, 장면을 그리며, 
(HTTP 요청 타이밍 및 가비지 수집과 같은) 다른 활동을 추적하는 동안 타임라인 이벤트를 내보냅니다. 
이러한 이벤트는 여기 타임라인에 표시됩니다. 
dart:developer [`Timeline`][] 및 [`TimelineTask`][] API를 사용하여, 
고유한 타임라인 이벤트를 보낼 수도 있습니다.

[`Timeline`]: {{site.api}}/flutter/dart-developer/Timeline-class.html
[`TimelineTask`]: {{site.api}}/flutter/dart-developer/TimelineTask-class.html

![Screenshot of a timeline events tab](/assets/images/docs/tools/devtools/timeline-events-tab.png)

추적 뷰어를 탐색하고 사용하는 데 도움이 필요하면, 타임라인 이벤트 탭 바의 오른쪽 상단에 있는 **?** 버튼을 클릭하세요. 
애플리케이션의 새 이벤트로 타임라인을 새로 고치려면, 새로 고침 버튼(탭 컨트롤의 오른쪽 상단 모서리에도 있음)을 클릭하세요.

## 고급 디버깅 도구 {:#advanced-debugging-tools}

### 추적 강화(enhance tracing) {:#enhance-tracing}

타임라인 이벤트 차트에서 더 자세한 추적을 보려면, 추적 강화 드롭다운의 옵션을 사용하세요.

:::note
이러한 옵션을 활성화하면, 프레임 시간에 부정적인 영향이 미칠 수 있습니다.
:::

![Screenshot of enhanced tracing options](/assets/images/docs/tools/devtools/enhanced-tracing.png)

새로운 타임라인 이벤트를 보려면, 추적하려는 앱에서 활동을 재현한 다음, 프레임을 선택하여 타임라인을 검사합니다.

### 위젯 빌드 추적 {:#track-widget-builds}

타임라인에서 `build()` 메서드 이벤트를 보려면, **Track Widget Builds** 옵션을 활성화하세요. 
위젯의 이름은 타임라인 이벤트에 표시됩니다.

![Screenshot of track widget builds](/assets/images/docs/tools/devtools/track-widget-builds.png)

[위젯 빌드 추적의 예를 보려면 이 비디오를 시청하세요.][track-widgets]

### 레이아웃 추적 {:#track-layouts}

타임라인에서 렌더 개체 레이아웃 이벤트를 보려면, **Track Layouts** 옵션을 활성화하세요.

![Screenshot of track layouts](/assets/images/docs/tools/devtools/track-layouts.png)

[레이아웃 추적의 예를 보려면 이 비디오를 시청하세요.][track-layouts]

### 페인팅 추적 {:#track-paints}

타임라인에서 렌더 객체 페인트 이벤트를 보려면, **Track Paints** 옵션을 활성화하세요.

![Screenshot of track paints](/assets/images/docs/tools/devtools/track-paints.png)

[페인트 추적의 예를 보려면 이 비디오를 시청하세요.][track-paints]

## 더 많은 디버깅 옵션 {:#more-debugging-options}

렌더링 레이어와 관련된 성능 문제를 진단하려면, 렌더링 레이어를 끕니다. 
이러한 옵션은 기본적으로 활성화되어 있습니다.

앱 성능에 미치는 영향을 확인하려면, 앱에서 activity를 재현합니다. 
그런 다음, 프레임 차트에서 새 프레임을 선택하여, 레이어가 비활성화된 타임라인 이벤트를 검사합니다. 
래스터 시간이 크게 감소한 경우, 비활성화한 효과를 과도하게 사용하면 앱에서 발생한 jank 현상에 영향을 미칠 수 있습니다.

**Clip 레이어 렌더링**
: 이 옵션을 비활성화하여, 과도한 클리핑 사용이 성능에 영향을 미치는지 확인합니다. 
  이 옵션을 비활성화한 상태에서 성능이 개선되면, 앱에서 클리핑 효과 사용을 줄여보세요.

**Opacity 레이어 렌더링**
: 불투명도 효과를 과도하게 사용하면 성능에 영향을 미치는지 확인하려면, 이 옵션을 비활성화합니다. 
  이 옵션을 비활성화한 상태에서 성능이 개선되면, 앱에서 불투명도 효과 사용을 줄여보세요.

**Physical Shape 레이어 렌더링**
: (shadows나 elevation와 같은) 물리적 모델링 효과를 과도하게 사용하는 것이 성능에 영향을 미치는지 확인하려면, 
  이 옵션을 비활성화합니다. 
  이 옵션을 비활성화한 상태에서 성능이 개선되면, 앱에서 물리적 모델링 효과 사용을 줄여보세요.

![Screenshot of more debugging options](/assets/images/docs/tools/devtools/more-debugging-options.png)

## Import 및 export {:#import-and-export}

DevTools는 성능 스냅샷 가져오기 및 내보내기를 지원합니다. 
내보내기 버튼(프레임 렌더링 차트 위 오른쪽 상단 모서리)을 클릭하면, 
성능 페이지에서 현재 데이터의 스냅샷이 다운로드됩니다. 
성능 스냅샷을 가져오려면, 어떤 페이지에서든 DevTools로 스냅샷을 끌어서 놓으면 됩니다.
**DevTools는 원래 DevTools에서 내보낸 파일만 가져오기를 지원합니다.**

## 기타 리소스 {:#other-resources}

DevTools를 사용하여 앱 성능을 모니터링하고 jank를 감지하는 방법을 알아보려면, 
가이드 [성능 보기 튜토리얼][performance-tutorial]을 확인하세요.

[GPU graph]: /perf/ui-performance#identifying-problems-in-the-gpu-graph
[Flutter performance profiling]: /perf/ui-performance
[Reduce shader compilation jank on mobile]: /perf/shader
[Import and export]: #import-and-export
[performance-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-performance-view-part-8-of-8-4ae762f91230
[track-widgets]: {{site.yt.watch}}/_EYk-E29edo?t=623
[track-layouts]: {{site.yt.watch}}/_EYk-E29edo?t=676
[track-paints]: {{site.yt.watch}}/_EYk-E29edo?t=748
