---
# title: Flutter performance profiling
title: Flutter 성능 프로파일링
# subtitle: Where to look when your Flutter app drops frames in the UI.
subtitle: Flutter 앱이 UI에서 프레임을 드롭할 때 어디를 살펴봐야 할까요?
# description: Diagnosing UI performance issues in Flutter.
description: Flutter에서 UI 성능 문제 진단하기.
---

{% render docs/performance.md %}

:::secondary 학습할 내용
* Flutter는 초당 60프레임(fps) 성능, 또는 120Hz 업데이트가 가능한 기기에서 120fps 성능을 제공하는 것을 목표로 합니다.
* 60fps의 경우, 프레임은 약 16ms마다 렌더링해야 합니다.
* UI가 매끄럽게 렌더링되지 않으면 Jank 현상이 발생합니다. 
  예를 들어, 가끔 프레임을 렌더링하는 데 10배 더 오래 걸려서, 프레임이 드롭되고 애니메이션이 눈에 띄게 멈춥니다.
:::

"_빠른 (fast)_ 앱은 좋지만, _매끄러운 (smooth)_ 앱은 더 좋다"는 말이 있습니다. 
앱이 매끄럽게 렌더링되지 않으면, 어떻게 해결할까요? 어디서부터 시작해야 할까요? 
이 가이드에서는 시작할 곳, 취해야 할 단계, 도움이 될 수 있는 도구를 보여줍니다.

:::note
* 앱의 성능은 두 가지 이상의 측정 항목에 의해 결정됩니다. 
  성능은 때로는 순수한 속도를 의미하지만, UI의 부드러움과 끊김 현상 없음을 의미하기도 합니다. 
  성능의 다른 예로는 I/O 또는 네트워크 속도가 있습니다. 
  이 페이지는 주로 두 번째 타입의 성능(UI 부드러움)에 초점을 맞추지만, 
  대부분의 동일한 도구를 사용하여 다른 성능 문제를 진단할 수 있습니다.
* Dart 코드 내에서 추적을 수행하려면, 
  [디버깅][Debugging] 페이지의 [Dart 코드 추적][Tracing Dart code]을 참조하세요.
:::

[Debugging]: /testing/debugging
[Tracing Dart code]: /testing/code-debugging#trace-dart-code-performance

## 성능 문제 진단 {:#diagnosing-performance-problems}

성능 문제가 있는 앱을 진단하려면, 성능 오버레이를 활성화하여 UI와 래스터 스레드(raster threads)를 살펴보세요. 
시작하기 전에, [프로필 모드][profile mode]에서 실행하고 있고, 에뮬레이터를 사용하지 않는지 확인하세요. 
최상의 결과를 얻으려면, 사용자가 사용할 수 있는 가장 느린 기기를 선택할 수 있습니다.

[profile mode]: /testing/build-modes#profile

### 실제 기기(physical device)에 연결 {:#connect-to-a-physical-device}

Flutter 애플리케이션의 거의 모든 성능 디버깅은, 
Flutter 애플리케이션이 [프로필 모드][profile mode]에서 실행되는, 실제 Android 또는 iOS 기기에서 수행해야 합니다. 
디버그 모드를 사용하거나, 시뮬레이터 또는 에뮬레이터에서 앱을 실행하는 것은, 
일반적으로 릴리스 모드 빌드의 최종 동작을 나타내지 않습니다. 
_사용자가 합리적으로 사용할 수 있는 가장 느린 기기에서 성능을 확인하는 것을 고려해야 합니다._

:::secondary 실제 기기에서 실행해야 하는 이유
* 시뮬레이터와 에뮬레이터는 동일한 하드웨어를 사용하지 않으므로, 성능 특성이 다릅니다. 
  * 일부 작업은 시뮬레이터에서 실제 기기보다 빠르고 일부는 느립니다.
* 디버그 모드에서는 프로필 또는 릴리스 빌드에서 실행되지 않는 추가 검사(예: assert)가 가능하며, 
  이러한 검사는 비용이 많이 들 수 있습니다.
* 디버그 모드에서는 릴리스 모드와 다른 방식으로 코드를 실행합니다. 
  디버그 빌드는 앱이 실행될 때 Dart 코드를 "적시에"(JIT, just in time) 컴파일하지만, 
  프로필 및 릴리스 빌드는 앱이 기기에 로드되기 전에 네이티브 명령어로 사전("사전, ahead of time" 또는 AOT라고도 함) 컴파일됩니다. 
  JIT로 인해 앱이 JIT 컴파일을 위해 일시 ​​중지될 수 있으며, 이로 인해 jank가 발생할 수 있습니다.
:::

### 프로필 모드에서 실행 {:#run-in-profile-mode}

Flutter의 프로필 모드는 릴리스 모드와 거의 동일하게 애플리케이션을 컴파일하고 시작하지만, 
성능 문제를 디버깅할 수 있을 만큼의 추가 기능이 있습니다. 
예를 들어, 프로필 모드는 프로파일링 도구에 추적 정보를 제공합니다.

:::note
Dart/Flutter DevTools는 프로필 모드에서 실행되는 Flutter 웹 앱에 연결할 수 없습니다. 
Chrome DevTools를 사용하여 웹 앱에 대한 [타임라인 이벤트 생성][generate timeline events]을 실행하세요.
:::

[generate timeline events]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/performance-reference


다음과 같이 프로필 모드에서 앱을 시작합니다.

* VS Code에서, `launch.json` 파일을 열고, `flutterMode` 속성을 `profile`로 설정합니다.
  (프로파일링이 끝나면, `release` 또는 `debug`로 다시 변경):

  ```json
  "configurations": [
    {
      "name": "Flutter",
      "request": "launch",
      "type": "dart",
      "flutterMode": "profile"
    }
  ]
  ```

* Android Studio와 IntelliJ에서, **Run > Flutter Run main.dart in Profile Mode** 메뉴 항목을 사용합니다.
* 명령줄에서, `--profile` 플래그를 사용합니다.

  ```console
  $ flutter run --profile
  ```

다양한 모드에 대한 자세한 내용은, [Flutter의 빌드 모드][Flutter's build modes]를 참조하세요.

다음 섹션에서 설명하는 대로, DevTools를 열고 성능 오버레이를 보는 것으로 시작합니다.

[Flutter's build modes]: /testing/build-modes

## DevTools 실행 {:#launch-devtools}

DevTools는 프로파일링, 힙 검사, 코드 커버리지 표시, 성능 오버레이 활성화, 단계별 디버거와 같은 기능을 제공합니다. 
DevTools의 [타임라인 뷰][Timeline view]를 사용하면, 프레임별로 애플리케이션의 UI 성능을 조사할 수 있습니다.

앱이 프로필 모드에서 실행되면, [DevTools 실행][launch DevTools]하세요.

[launch DevTools]: /tools/devtools
[Timeline view]: /tools/devtools/performance

<a id="the-performance-overlay" aria-hidden="true"></a>

## 성능 오버레이 {:#performance-overlay}

성능 오버레이는 앱에서 시간이 어디에 소요되는지 보여주는 두 개의 그래프로 통계를 표시합니다. 
UI가 janky인 경우(프레임 건너뛰기), 이러한 그래프는 그 이유를 파악하는 데 도움이 됩니다. 
그래프는 실행 중인 앱 위에 표시되지만, 일반 위젯처럼 그려지지 않습니다.&mdash;Flutter 엔진 자체가 오버레이를 칠하고 성능에 미치는 영향은 미미합니다. 
각 그래프는 해당 스레드의 마지막 300개 프레임을 나타냅니다.

이 섹션에서는 성능 오버레이를 활성화하고 이를 사용하여, 애플리케이션에서 jank의 원인을 진단하는 방법을 설명합니다. 
다음 스크린샷은 Flutter Gallery 예제에서 실행되는 성능 오버레이를 보여줍니다.

![Screenshot of overlay showing zero jank](/assets/images/docs/tools/devtools/performance-overlay-green.png)
<br>래스터(raster) 스레드(위)와 UI 스레드(아래)를 보여주는 성능 오버레이입니다.
<br>수직 녹색 막대는 현재 프레임을 나타냅니다.

## 그래프 해석하기 {:#interpreting-the-graphs}

상단 그래프("GPU"로 표시)는 래스터(raster) 스레드에서 소요된 시간을 보여주고, 
하단 그래프는 UI 스레드에서 소요된 시간을 보여줍니다. 
그래프를 가로지르는 흰색 선은 수직축을 따라 16ms 간격을 보여줍니다. (그래프가 이 선 중 하나를 넘어가면 60Hz 미만으로 실행하고 있는 것입니다.) 
수평축은 프레임을 나타냅니다. 그래프는 애플리케이션이 페인팅할 때만 업데이트되므로, 유휴 상태이면 그래프가 움직이지 않습니다.

오버레이는 항상 [프로필 모드][profile mode]에서 보아야 합니다. 
[디버그 모드][debug mode] 성능은 개발을 돕기 위한 값비싼 어설션과 교환하여 의도적으로 희생되므로, 
결과가 오해의 소지가 있습니다.

각 프레임은 1/60초(약 16ms) 이내에 생성되고 표시되어야 합니다. 
이 제한을 초과하는 프레임(두 그래프 모두)은 표시되지 않아, jank가 발생하고, 
그래프 중 하나 또는 둘 다에 빨간색 세로 막대가 나타납니다. 
UI 그래프에 빨간색 막대가 나타나면, Dart 코드가 너무 비싼 것입니다. 
GPU 그래프에 빨간색 수직 막대가 나타나면, 해당 장면이 너무 복잡해서 빠르게 렌더링할 수 없음을 의미합니다.

![Screenshot of performance overlay showing jank with red bars](/assets/images/docs/tools/devtools/performance-overlay-jank.png)
<br>수직 빨간색 막대는 현재 프레임이 렌더링과 페인트 모두에 비용이 많이 든다는 것을 나타냅니다.
<br>두 그래프가 모두 빨간색으로 표시되면, UI 스레드를 진단하는 것으로 시작합니다.

[debug mode]: /testing/build-modes#debug

## Flutter의 스레드 {:#flutters-threads}

Flutter는 여러 스레드를 사용하여 작업을 수행하지만, 오버레이에 표시된 스레드는 두 개뿐입니다. 
모든 Dart 코드는 UI 스레드에서 실행됩니다. 
다른 스레드에 직접 액세스할 수는 없지만, UI 스레드에서의 작업은 다른 스레드의 성능에 영향을 미칩니다.

**플랫폼 스레드 (Platform thread)**
: 플랫폼의 메인 스레드입니다. 
  플러그인 코드는 여기에서 실행됩니다. 
  자세한 내용은, iOS의 경우 [UIKit][] 문서 또는 Android의 경우 [MainThread][] 문서를 참조하세요. 
  이 스레드는 성능 오버레이에 표시되지 않습니다.

**UI 스레드 (UI thread)**
: UI 스레드는 Dart VM에서 Dart 코드를 실행합니다. 
  이 스레드에는 사용자가 작성한 코드와 Flutter 프레임워크에서 앱을 대신하여 실행하는 코드가 포함됩니다. 
  앱에서 장면을 만들고 표시할 때, UI 스레드는 장치에 독립적인(device-agnostic) 페인팅 명령을 포함하는 가벼운 객체인 
  _레이어 트리(layer tree)_ 를 만들고, 
  레이어 트리를 래스터 스레드로 보내 장치에서 렌더링합니다. 
  _이 스레드를 차단하지 마세요!_ 
  성능 오버레이의 맨 아래 행에 표시됩니다.

**래스터 스레드 (Raster thread)**
: 래스터 스레드는 레이어 트리를 가져와 GPU(그래픽 처리 장치)와 통신하여 표시합니다. 
  래스터 스레드나 데이터에 직접 액세스할 수 없지만, 이 스레드가 느리다면, Dart 코드에서 한 일의 결과입니다. 
  그래픽 라이브러리인 Skia와 Impeller가 이 스레드에서 실행됩니다. 
  성능 오버레이의 맨 위 행에 표시됩니다. 
  래스터 스레드가 GPU를 위해 래스터화하는 동안, 스레드 자체는 CPU에서 실행됩니다.

**I/O 스레드**
: UI 또는 래스터 스레드를 차단하는 비용이 많이 드는 작업(대부분 I/O)을 수행합니다. 
  이 스레드는 성능 오버레이에 표시되지 않습니다.

자세한 정보와 비디오에 대한 링크는, [Flutter wiki][]의 [프레임워크 아키텍처][The Framework architecture]와 커뮤니티 문서 [레이어 케이크][The Layer Cake]를 참조하세요.

[Flutter wiki]: {{site.repo.flutter}}/tree/master/docs
[MainThread]: {{site.android-dev}}/reference/android/support/annotation/MainThread
[The Framework architecture]: {{site.repo.flutter}}/blob/master/docs/about/The-Framework-architecture.md
[The Layer Cake]: {{site.medium}}/flutter-community/the-layer-cake-widgets-elements-renderobjects-7644c3142401
[UIKit]: {{site.apple-dev}}/documentation/uikit

### 성능 오버레이 표시 {:#displaying-the-performance-overlay}

다음과 같이 성능 오버레이 표시를 토글할 수 있습니다.

* Flutter 검사기 사용
* 명령줄에서
* 프로그래밍 방식으로

#### Flutter 검사기 사용 {:#using-the-flutter-inspector}

PerformanceOverlay 위젯을 활성화하는 가장 쉬운 방법은, 
[DevTools][]의 [Inspector view][]에서 사용할 수 있는 Flutter 검사기를 사용하는 것입니다. 
실행 중인 앱에서 오버레이를 toggle 하려면, **Performance Overlay** 버튼을 클릭하기만 하면 됩니다.

[Inspector view]: /tools/devtools/inspector

#### 명령줄에서 {:#from-the-command-line}

명령줄에서 **P** 키를 사용하여 성능 오버레이를 toggle 합니다.

#### 프로그래밍 방식으로 {:#programmatically}

오버레이를 프로그래밍 방식으로 활성화하려면, 
[프로그래밍 방식으로 Flutter 앱 디버깅][Debugging Flutter apps programmatically] 페이지의 [성능 오버레이][Performance overlay] 섹션을 참조하세요.

[Debugging Flutter apps programmatically]: /testing/code-debugging
[Performance overlay]: /testing/code-debugging#add-performance-overlay

## UI 그래프의 문제 식별 {:#identifying-problems-in-the-ui-graph}

UI 그래프에서 성능 오버레이가 빨간색으로 표시되는 경우, 
GPU 그래프도 빨간색으로 표시되는 경우에도, 
Dart VM을 프로파일링하는 것으로 시작하세요.

## GPU 그래프의 문제 식별 {:#identifying-problems-in-the-gpu-graph}

때때로 장면은 구성하기 쉽지만 (래스터 스레드에서 렌더링하기에는 비용이 많이 드는) 레이어 트리를 생성합니다. 
이런 경우, UI 그래프에는 빨간색이 없지만 GPU 그래프에는 빨간색이 표시됩니다. 
이 경우, 렌더링 코드가 느려지는 원인이 되는 코드를 파악해야 합니다. 
특정 종류의 워크로드는 GPU에 더 어렵습니다. 
여기에는 불필요한 [`saveLayer`][] 호출, 여러 개체와 불투명도 교차, 특정 상황에서의 클립 또는 그림자가 포함될 수 있습니다.

애니메이션 중에 느린 속도의 원인이 있다고 생각되면, 
Flutter 검사기에서 **Slow Animations** 버튼을 클릭하여 애니메이션 속도를 5배 늦춥니다. 
속도를 더 많이 제어하려면, [프로그래밍 방식으로][programmatically] 이렇게 할 수도 있습니다.

느린 속도가 첫 번째 프레임에서 발생하는지, 아니면 전체 애니메이션에서 발생하는지? 
전체 애니메이션에서 발생하는 경우, 클리핑이 느려지는 원인인지? 
클리핑을 사용하지 않고 장면을 그리는 대체 방법이 있을 수 있습니다. 
예를 들어, 둥근 사각형에 클리핑하는 대신, 불투명한 모서리를 사각형에 오버레이합니다. 
페이드, 회전 또는 기타 조작되는 static 장면인 경우 [`RepaintBoundary`][]가 도움이 될 수 있습니다.

[programmatically]: /testing/code-debugging#debug-animation-issues
[`RepaintBoundary`]: {{site.api}}/flutter/widgets/RepaintBoundary-class.html
[`saveLayer`]: {{site.api}}/flutter/dart-ui/Canvas/saveLayer.html

#### 오프스크린 레이어 확인 {:#checking-for-offscreen-layers}

[`saveLayer`][] 메서드는 Flutter 프레임워크에서 가장 비싼 메서드 중 하나입니다. 
장면에 후처리를 적용할 때 유용하지만, 앱 속도가 느려질 수 있으므로, 필요하지 않은 경우 피해야 합니다. 
`saveLayer`를 명시적으로 호출하지 않더라도, 
[`Clip.antiAliasWithSaveLayer`][]를 지정할 때(일반적으로 `clipBehavior`로 지정)와 같이, 
암묵적인 호출이 발생할 수 있습니다.

예를 들어, `saveLayer`를 사용하여 렌더링되는 불투명도가 있는 객체 그룹이 있을 수 있습니다. 
이 경우, 위젯 트리에서 더 높은 부모 위젯보다, 각 개별 위젯에 불투명도를 적용하는 것이 성능이 더 좋을 수 있습니다. 
클리핑이나 그림자와 같이, 잠재적으로 비싼 다른 작업도 마찬가지입니다.

:::note
Opacity, clipping, shadows 자체는 나쁜 생각이 아닙니다. 
그러나, 위젯 트리의 맨 위에 적용하면, `saveLayer`에 대한 추가 호출과 불필요한 처리가 발생할 수 있습니다.
:::

`saveLayer`에 대한 호출을 접하면, 다음과 같은 질문을 스스로에게 던져보세요.

* 앱에 이 효과가 필요한가요?
* 이러한 호출 중 하나를 제거할 수 있나요?
* 그룹 대신 개별 요소에 동일한 효과를 적용할 수 있나요?

[`Clip.antiAliasWithSaveLayer`]: {{site.api}}/flutter/dart-ui/Clip.html

#### 캐시되지 않은 이미지 확인 {:#checking-for-non-cached-images}

[`RepaintBoundary`][]로 이미지를 캐싱하는 것은, _의미가 있을 때 (when it makes sense)_ 좋습니다.

리소스 관점에서 가장 비용이 많이 드는 작업 중 하나는, 이미지 파일을 사용하여 텍스처를 렌더링하는 것입니다. 
먼저, 압축된 이미지를 영구 저장소에서 가져옵니다. 
이미지는 호스트 메모리(GPU 메모리)로 압축 해제되고, 장치 메모리(RAM)로 전송됩니다.

즉, 이미지 I/O는 비용이 많이 들 수 있습니다. 
캐시는 복잡한 계층 구조의 스냅샷을 제공하므로, 후속 프레임에서 렌더링하기가 더 쉽습니다. 
_래스터 캐시 항목은 구성하는 데 비용이 많이 들고 GPU 메모리를 많이 차지하므로, 절대적으로 필요한 경우에만 이미지를 캐시합니다._

### 위젯 재구축 프로파일러 보기 {:#viewing-the-widget-rebuild-profiler}

Flutter 프레임워크는 60fps가 아니고 매끄럽지 않은 애플리케이션을 만드는 것을 어렵게 만들기 위해 설계되었습니다. 
종종 jank가 발생하는 경우, 필요한 것보다 더 많은 UI를 각 프레임마다 다시 빌드해야 하는 간단한 버그가 있기 때문입니다. 
위젯 재구축 프로파일러는 이러한 종류의 버그로 인한 성능 문제를 디버깅하고 수정하는 데 도움이 됩니다.

Android Studio 및 IntelliJ용 Flutter 플러그인에서, 
현재 화면과 프레임에 대한 위젯 다시 빌드 횟수를 볼 수 있습니다. 
이를 수행하는 방법에 대한 자세한 내용은 [성능 데이터 표시][Show performance data]를 참조하세요.

[Show performance data]: /tools/android-studio#show-performance-data

## 벤치마킹 {:#benchmarking}

벤치마크 테스트를 작성하여, 앱의 성능을 측정하고 추적할 수 있습니다. 
Flutter Driver 라이브러리는 벤치마킹을 지원합니다. 
이 통합 테스트 프레임워크를 사용하면, 다음을 추적하는 메트릭을 생성할 수 있습니다.

* Jank
* 다운로드 크기
* 배터리 효율성
* 시작 시간

이러한 벤치마크를 추적하면, 성능에 부정적인 영향을 미치는 회귀(regression)가 도입될 때 알림을 받을 수 있습니다.

자세한 내용은 [통합 테스트][Integration testing]를 확인하세요.

[Integration testing]: /testing/integration-tests

## 기타 리소스 {:#other-resources}

다음 리소스는 Flutter에서 Flutter 도구 사용 및 디버깅에 대한 자세한 정보를 제공합니다.

* [디버깅][Debugging]
* [Flutter inspector][]
* [Flutter inspector talk][], DartConf 2018에서 발표
* [Why Flutter Uses Dart][], Hackernoon의 기사
* [Why Flutter uses Dart][video], Flutter 채널의 비디오
* [DevTools][devtools]: Dart 및 Flutter 앱을 위한 성능 도구
* [Flutter API][] 문서, 특히 [`PerformanceOverlay`][] 클래스 및 [dart:developer][] 패키지

[dart:developer]: {{site.api}}/flutter/dart-developer/dart-developer-library.html
[devtools]: /tools/devtools
[Flutter API]: {{site.api}}
[Flutter inspector]: /tools/devtools/inspector
[Flutter inspector talk]: {{site.yt.watch}}?v=JIcmJNT9DNI
[`PerformanceOverlay`]: {{site.api}}/flutter/widgets/PerformanceOverlay-class.html
[video]: {{site.yt.watch}}?v=5F-6n_2XWR8
[Why Flutter Uses Dart]: https://hackernoon.com/why-flutter-uses-dart-dd635a054ebf
