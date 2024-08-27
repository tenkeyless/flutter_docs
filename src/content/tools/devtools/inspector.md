---
# title: Use the Flutter inspector
title: Flutter 검사기 사용
# description: Learn how to use the Flutter inspector to explore a Flutter app's widget tree.
description: Flutter 앱의 위젯 트리를 탐색하기 위해 Flutter 검사기를 사용하는 방법을 알아보세요.
---

<?code-excerpt path-base="../examples/visual_debugging/"?>

:::note
검사기는 모든 Flutter 애플리케이션에서 작동합니다.
:::

## 이게 무엇인가요? {:#what-is-it}

Flutter 위젯 검사기는 Flutter 위젯 트리를 시각화하고, 탐색하기 위한 강력한 도구입니다. 
Flutter 프레임워크는 컨트롤(예: 텍스트, 버튼, 토글)부터 레이아웃(예: 가운데 정렬, 패딩, 행, 열)에 이르기까지, 
모든 것에 대한 핵심 빌딩 블록으로 위젯을 사용합니다. 
검사기는 Flutter 위젯 트리를 시각화하고 탐색하는 데 도움이 되며, 다음과 같은 용도로 사용할 수 있습니다.

* 기존 레이아웃 이해
* 레이아웃 문제 진단

![Screenshot of the Flutter inspector window](/assets/images/docs/tools/devtools/inspector_screenshot.png){:width="100%"}

## 시작하기 {:#get-started}

레이아웃 문제를 디버깅하려면, 앱을 [디버그 모드][debug mode]에서 실행하고, 
DevTools 도구 모음에서 **Flutter Inspector** 탭을 클릭하여 검사기를 엽니다.

:::note
Android Studio/IntelliJ에서 Flutter 검사기에 직접 액세스할 수는 있지만, 
브라우저의 DevTools에서 실행할 경우 더 넓은 뷰가 선호될 수 있습니다.
:::

### 레이아웃 문제를 시각적으로 디버깅 {:#debugging-layout-issues-visually}

다음은 검사기 툴바에서 사용할 수 있는 기능에 대한 가이드입니다. 
공간이 제한되어 있는 경우, 아이콘은 레이블의 시각적 버전으로 사용됩니다.

![Select widget mode icon](/assets/images/docs/tools/devtools/select-widget-mode-icon.png){:width="20px"} **위젯 모드 선택**
: 이 버튼을 활성화하면, 장치에서 위젯을 선택하여 검사할 수 있습니다. 자세한 내용은 [위젯 검사](#inspecting-a-widget)를 확인하세요.

![Refresh tree icon](/assets/images/docs/tools/devtools/refresh-tree-icon.png){:width="20px"} **트리 새로 고침**
: 현재 위젯 정보를 다시 로드합니다.

![Slow animations icon](/assets/images/docs/tools/devtools/slow-animations-icon.png){:width="20px"} **[느린 애니메이션][Slow animations]**
: 애니메이션을 5배 느리게 실행하여 미세 조정을 돕습니다.

![Show guidelines mode icon](/assets/images/docs/tools/devtools/debug-paint-mode-icon.png){:width="20px"} **[가이드라인 표시][Show guidelines]**
: 레이아웃 문제 해결을 돕기 위한 가이드라인을 오버레이합니다.

![Show baselines icon](/assets/images/docs/tools/devtools/paint-baselines-icon.png){:width="20px"} **[기준선 표시][Show baselines]**
: 텍스트를 정렬하는 데 사용되는 기준선을 표시합니다. 텍스트가 정렬되었는지 확인하는 데 유용할 수 있습니다.

![Highlight repaints icon](/assets/images/docs/tools/devtools/repaint-rainbow-icon.png){:width="20px"} **[리페인트 강조][Highlight repaints]**
: 요소가 리페인트될 때 색상이 변경되는 테두리를 표시합니다. 불필요한 리페인트를 찾는 데 유용합니다.

![Highlight oversized images icon](/assets/images/docs/tools/devtools/invert_oversized_images_icon.png){:width="20px"} **[크기가 큰 이미지 강조][Highlight oversized images]**
: 색상을 반전하고 뒤집어서 메모리를 너무 많이 사용하는 이미지를 강조합니다.

[Slow animations]: #slow-animations
[Show guidelines]: #show-guidelines
[Show baselines]: #show-baselines
[Highlight repaints]: #highlight-repaints
[Highlight oversized images]: #highlight-oversized-images

## 위젯 검사하기 {:#inspecting-a-widget}

대화형 위젯 트리를 탐색하여, 근처 위젯을 보고, 해당 필드 값을 확인할 수 있습니다.

위젯 트리에서 개별 UI 요소를 찾으려면, 도구 모음에서 **Select Widget Mode** 버튼을 클릭합니다. 
그러면 기기의 앱이 "위젯 선택" 모드로 전환됩니다. 
앱 UI에서 위젯을 클릭하면 앱 화면에서 위젯이 선택되고, 위젯 트리가 해당 노드로 스크롤됩니다. 
**Select Widget Mode** 버튼을 다시 토글하여, 위젯 선택 모드를 종료합니다.

레이아웃 문제를 디버깅할 때, 살펴봐야 할 핵심 필드는 `size` 및 `constraints` 필드입니다. 
제약 조건은 트리 아래로 흐르고, 크기는 다시 위로 흐릅니다. 
작동 방식에 대한 자세한 내용은 [제약 조건 이해][Understanding constraints]를 참조하세요.

## Flutter 레이아웃 탐색기 {:#flutter-layout-explorer}

Flutter Layout Explorer는 Flutter 레이아웃을 더 잘 이해하는 데 도움이 됩니다.

이 도구로 무엇을 할 수 있는지에 대한 개요는 Flutter Explorer 비디오를 참조하세요.

{% ytEmbed 'Jakrc3Tn_y4', 'DevTools 레이아웃 탐색기' %}

다음 단계별 글도 유용할 수 있습니다.

* [Flutter Inspector로 레이아웃 문제를 디버깅하는 방법][debug-article]

[debug-article]: {{site.flutter-medium}}/how-to-debug-layout-issues-with-the-flutter-inspector-87460a7b9db

### 레이아웃 탐색기 사용 {:#use-the-layout-explorer}

Flutter Inspector에서 위젯을 선택합니다. 
Layout Explorer는 [flex 레이아웃][flex layouts]과 고정 크기 레이아웃을 모두 지원하며, 
두 종류에 대한 특정 툴링을 제공합니다.

#### Flex 레이아웃 {:#flex-layouts}

flex 위젯(예: [`Row`][], [`Column`][], [`Flex`][]) 또는 flex 위젯의 직계 자식을 선택하면, 
레이아웃 탐색기에 flex 레이아웃 도구가 나타납니다.

레이아웃 탐색기는 [`Flex`][] 위젯과 그 자식이 어떻게 배치되는지 시각화합니다. 
탐색기는 주축(main axis)과 교차축(cross axis), 그리고 각각의 현재 정렬(예: 시작, 끝, spaceBetween)을 식별합니다. 
또한 flex 계수(factor), flex 맞춤(fit), 레이아웃 제약 조건과 같은 세부 정보도 표시합니다.

또한, 탐색기는 레이아웃 제약 조건 위반과 렌더 오버플로 오류를 표시합니다. 
위반된 레이아웃 제약 조건은 빨간색으로 표시되고, 
오버플로 오류는 실행 중인 기기에서 볼 수 있듯이 표준 "노란색 테이프" 패턴으로 표시됩니다. 
이러한 시각화는 오버플로 오류가 발생하는 이유와 이를 수정하는 방법에 대한 이해를 높이는 것을 목표로 합니다.

![The Layout Explorer showing errors and device inspector](/assets/images/docs/tools/devtools/layout_explorer_errors_and_device.gif){:width="100%"}

레이아웃 탐색기에서 위젯을 클릭하면, 온디바이스 인스펙터에서 선택한 내용이 반영됩니다. 
이를 위해 **Select Widget Mode**을 활성화해야 합니다. 
활성화하려면, 인스펙터에서 **Select Widget Mode** 버튼을 클릭합니다.

![The Select Widget Mode button in the inspector](/assets/images/docs/tools/devtools/select_widget_mode_button.png)

flex factor, flex fit, alignment와 같은 일부 속성의 경우, 
탐색기의 드롭다운 리스트를 통해 값을 수정할 수 있습니다. 
위젯 속성을 수정하면, Layout Explorer뿐만 아니라 Flutter 앱을 실행하는 기기에도, 
새 값이 반영되는 것을 볼 수 있습니다. 
탐색기는 속성 변경 시 애니메이션을 적용하여 변경의 효과를 명확하게 보여줍니다. 
Layout Explorer에서 변경한 위젯 속성은 소스 코드를 수정하지 않으며 핫 리로드 시 되돌립니다.

##### 상호 작용 속성 {:#interactive-properties}

Layout Explorer는 [`mainAxisAlignment`][], [`crossAxisAlignment`][], 및 [`FlexParentData.flex`][] 수정을 지원합니다. 
향후에는 [`mainAxisSize`][], [`textDirection`][], 및 [`FlexParentData.fit`][]와 같은 추가 속성에 대한 지원을 추가할 수 있습니다.

###### mainAxisAlignment {:#mainaxisalignment}

![The Layout Explorer changing main axis alignment](/assets/images/docs/tools/devtools/layout_explorer_main_axis_alignment.gif){:width="100%"}

지원되는 값:

* `MainAxisAlignment.start`
* `MainAxisAlignment.end`
* `MainAxisAlignment.center`
* `MainAxisAlignment.spaceBetween`
* `MainAxisAlignment.spaceAround`
* `MainAxisAlignment.spaceEvenly`

###### crossAxisAlignment {:#crossaxisalignment}

![The Layout Explorer changing cross axis alignment](/assets/images/docs/tools/devtools/layout_explorer_cross_axis_alignment.gif){:width="100%"}

지원되는 값:

* `CrossAxisAlignment.start`
* `CrossAxisAlignment.center`
* `CrossAxisAlignment.end`
* `CrossAxisAlignment.stretch`

###### FlexParentData.flex {:#flexparentdata-flex}

![The Layout Explorer changing flex factor](/assets/images/docs/tools/devtools/layout_explorer_flex.gif){:width="100%"}

레이아웃 탐색기는 UI에서 7개의 flex 옵션(null, 0, 1, 2, 3, 4, 5)을 지원하지만, 
기술적으로 flex 위젯의 자식의 flex 인수는 모든 int가 될 수 있습니다.

###### Flexible.fit {:#flexible-fit}

![The Layout Explorer changing fit](/assets/images/docs/tools/devtools/layout_explorer_fit.gif){:width="100%"}

레이아웃 탐색기는 두 가지 타입의 [`FlexFit`][], 즉 `loose`과 `tight`을 지원합니다.

#### 고정 크기 layouts {:#fixed-size-layouts}

flex 위젯의 자식이 아닌 고정 크기 위젯을 선택하면, 고정 크기 레이아웃 정보가 Layout Explorer에 나타납니다. 
선택한 위젯과 가장 가까운 업스트림 RenderObject에 대한 크기, 제약 조건 및 패딩 정보를 볼 수 있습니다.

![The Layout Explorer fixed size tool](/assets/images/docs/tools/devtools/layout_explorer_fixed_layout.png){:width="100%"}

## 시각적 디버깅 {:#visual-debugging}

Flutter Inspector는 앱을 시각적으로 디버깅할 수 있는 여러 가지 옵션을 제공합니다.

![Inspector visual debugging options](/assets/images/docs/tools/devtools/visual_debugging_options.png){:width="100%"}

### 느린 애니메이션 {:#slow-animations}

이 옵션을 활성화하면, 애니메이션을 5배 느리게 실행하여 시각적으로 더 쉽게 검사할 수 있습니다. 
이 기능은 제대로 보이지 않는 애니메이션을 주의 깊게 관찰하고 조정하려는 경우에 유용할 수 있습니다.

코드에서도 설정할 수 있습니다.

<?code-excerpt "lib/slow_animations.dart"?>
```dart
import 'package:flutter/scheduler.dart';

void setSlowAnimations() {
  timeDilation = 5.0;
}
```

이렇게 하면 애니메이션 속도가 5배 느려집니다.

#### 다음도 참조하세요 {:#see-also}

다음 링크는 자세한 정보를 제공합니다.

* [Flutter 문서: timeDilation 속성]({{site.api}}/flutter/scheduler/timeDilation.html)

다음 화면 녹화는 애니메이션을 느리게 하기 전과 후를 보여줍니다.

![Screen recording showing normal animation speed](/assets/images/docs/tools/devtools/debug-toggle-slow-animations-disabled.gif)
![Screen recording showing slowed animation speed](/assets/images/docs/tools/devtools/debug-toggle-slow-animations-enabled.gif)

### 가이드라인 표시 {:#show-guidelines}

이 기능은 앱 위에 렌더 박스, 정렬, 패딩, 스크롤 뷰, 클리핑 및 스페이서를 표시하는 가이드라인을 그립니다.

이 도구는 레이아웃을 더 잘 이해하는 데 사용할 수 있습니다. 
예를 들어, 원치 않는 패딩을 찾거나 위젯 정렬을 이해하는 것입니다.

코드에서 이 기능을 활성화할 수도 있습니다.

<?code-excerpt "lib/layout_guidelines.dart"?>
```dart
import 'package:flutter/rendering.dart';

void showLayoutGuidelines() {
  debugPaintSizeEnabled = true;
}
```

#### 렌더 박스 {:#render-boxes}

화면에 그리는 위젯은 Flutter 레이아웃의 빌딩 블록인 [렌더 박스][render box]를 만듭니다. 
밝은 파란색 테두리로 표시됩니다.

![Screenshot of render box guidelines](/assets/images/docs/tools/devtools/debug-toggle-guideline-render-box.png)

#### 정렬 {:#alignments}

정렬은 노란색 화살표로 표시됩니다. 
이 화살표는 위젯의 부모에 대한 수직 및 수평 오프셋을 보여줍니다. 
예를 들어, 이 버튼의 아이콘은 네 개의 화살표로 가운데에 배치된 것으로 표시됩니다.

![Screenshot of alignment guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-alignment.png)

#### Padding {:#padding}

패딩은 반투명한 파란색 배경으로 표시됩니다.

![Screenshot of padding guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-padding.png)

#### 스크롤 뷰 {:#scroll-views}

스크롤 콘텐츠가 있는 위젯(예: 리스트 뷰)은 녹색 화살표로 표시됩니다.

![Screenshot of scroll view guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-scroll.png)

#### Clipping {:#clipping}

예를 들어, [ClipRect 위젯][ClipRect widget]을 사용할 때, 
클리핑은 가위 아이콘이 있는 점선 분홍색 선으로 표시됩니다.

[ClipRect widget]: {{site.api}}/flutter/widgets/ClipRect-class.html

![Screenshot of clip guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-clip.png)

#### Spacers {:#spacers}

Spacers 위젯은 자식이 없는 이 `SizedBox`와 같이 회색 배경으로 표시됩니다.

![Screenshot of spacer guidelines](/assets/images/docs/tools/devtools/debug-toggle-guidelines-spacer.png)

### 베이스라인 표시 {:#show-baselines}

이 옵션은 모든 기준선을 표시합니다. 기준선은 텍스트를 배치하는 데 사용되는 수평선입니다.

이는 텍스트가 수직으로 정확하게 정렬되었는지 확인하는 데 유용할 수 있습니다.
예를 들어, 다음 스크린샷의 텍스트 기준선은 약간 정렬되지 않았습니다.

![Screenshot with show baselines enabled](/assets/images/docs/tools/devtools/debug-toggle-guidelines-baseline.png)

[Baseline][] 위젯은 베이스라인을 조정하는 데 사용할 수 있습니다.

[Baseline]: {{site.api}}/flutter/widgets/Baseline-class.html

기준선이 설정된 모든 [렌더 박스][render box]에 선이 그려집니다. 
알파벳 기준선은 녹색으로, 표의 문자 기준선은 노란색으로 표시됩니다.

코드에서 이 기능을 활성화할 수도 있습니다.

<?code-excerpt "lib/show_baselines.dart"?>
```dart
import 'package:flutter/rendering.dart';

void showBaselines() {
  debugPaintBaselinesEnabled = true;
}
```

### 리페인트 하이라이트 {:#highlight-repaints}

이 옵션은 모든 [렌더 박스][render boxes] 주위에 테두리를 그려, 상자가 다시 그려질 때마다 색상이 변경됩니다.

[render boxes]: {{site.api}}/flutter/rendering/RenderBox-class.html

이 회전하는 무지개색은 앱에서 너무 자주 다시 칠해져 성능을 저하시킬 수 있는 부분을 찾는 데 유용합니다.

예를 들어, 작은 애니메이션 하나가 모든 프레임에서 전체 페이지를 다시 칠하게 할 수 있습니다. 
애니메이션을 [RepaintBoundary 위젯][RepaintBoundary widget]으로 래핑하면, 다시 칠하는 작업이 애니메이션에만 국한됩니다.

[RepaintBoundary widget]: {{site.api}}/flutter/widgets/RepaintBoundary-class.html

여기서 진행률 표시기는 컨테이너를 다시 칠하게 합니다.

<?code-excerpt "lib/highlight_repaints.dart (everything-repaints)"?>
```dart
class EverythingRepaintsPage extends StatelessWidget {
  const EverythingRepaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repaint Example')),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

![Screen recording of a whole screen repainting](/assets/images/docs/tools/devtools/debug-toggle-guidelines-repaint-1.gif)

`RepaintBoundary`로 진행률 표시기를 감싸면 화면의 해당 섹션만 다시 그려집니다.

<?code-excerpt "lib/highlight_repaints.dart (area-repaints)"?>
```dart
class AreaRepaintsPage extends StatelessWidget {
  const AreaRepaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repaint Example')),
      body: const Center(
        child: RepaintBoundary(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
```

![Screen recording of a just a progress indicator repainting](/assets/images/docs/tools/devtools/debug-toggle-guidelines-repaint-2.gif)

`RepaintBoundary` 위젯에는 장단점이 있습니다. 
성능에 도움이 될 수 있지만, 추가 메모리를 사용하는 새 캔버스를 만드는 오버헤드도 있습니다.

코드에서 이 옵션을 활성화할 수도 있습니다.

<?code-excerpt "lib/highlight_repaints.dart (toggle)"?>
```dart
import 'package:flutter/rendering.dart';

void highlightRepaints() {
  debugRepaintRainbowEnabled = true;
}
```

### 크기가 오버된 이미지 하이라이트 {:#highlight-oversized-images}

이 옵션은 색상을 반전하고 수직으로 뒤집어서 너무 큰 이미지를 강조 표시합니다.

![A highlighted oversized image](/assets/images/docs/tools/devtools/debug-toggle-guidelines-oversized.png)

강조 표시된 이미지는 필요한 것보다 더 많은 메모리를 사용합니다. 예를 들어, 100 x 100 픽셀로 표시된 5MB의 큰 이미지.

이러한 이미지는 성능이 저하될 수 있으며, 
특히 하위 기기에서 그렇고 리스트 뷰와 같이 이미지가 많은 경우, 이러한 성능 저하가 누적될 수 있습니다. 
각 이미지에 대한 정보는 디버그 콘솔에 인쇄됩니다.

```console
dash.png has a display size of 213×392 but a decode size of 2130×392, which uses an additional 2542KB.
```

이미지가 필요한 크기보다 128KB 이상 더 사용하면 너무 큰 것으로 간주됩니다.

#### 이미지 고치기 {:#fixing-images}

가능한 경우, 이 문제를 해결하는 가장 좋은 방법은 이미지 asset 파일의 크기를 조정하여 더 작게 만드는 것입니다.

이것이 가능하지 않은 경우, `Image` 생성자에서 `cacheHeight` 및 `cacheWidth` 매개변수를 사용할 수 있습니다.

<?code-excerpt "lib/oversized_images.dart (resized-image)"?>
```dart
class ResizedImage extends StatelessWidget {
  const ResizedImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'dash.png',
      cacheHeight: 213,
      cacheWidth: 392,
    );
  }
}
```

이렇게 하면 엔진이 지정된 크기로 이 이미지를 디코딩하고, 메모리 사용량을 줄입니다. 
(이미지 asset 자체가 축소된 경우보다 디코딩 및 저장 비용이 더 많이 듭니다)
이미지는 이러한 매개변수와 관계없이 레이아웃 또는 너비와 높이의 제약 조건에 따라 렌더링됩니다.

이 속성은 코드에서도 설정할 수 있습니다.

<?code-excerpt "lib/oversized_images.dart (toggle)"?>
```dart
void showOversizedImages() {
  debugInvertOversizedImages = true;
}
```

#### 더 많은 정보 {:#more-information}

다음 링크에서 자세히 알아볼 수 있습니다.

* [Flutter 문서: debugInvertOversizedImages]({{site.api}}/flutter/painting/debugInvertOversizedImages.html)

[render box]: {{site.api}}/flutter/rendering/RenderBox-class.html

## 세부 사항 트리 (Details Tree) {:#details-tree}

**Widget Details Tree** 탭을 선택하여 선택한 위젯의 세부 정보 트리를 표시합니다. 
여기에서 위젯의 속성, 렌더 객체 및 자식에 대한 유용한 정보를 수집할 수 있습니다.

![The Details Tree view](/assets/images/docs/tools/devtools/inspector_details_tree.png){:width="100%"}

## 위젯 생성 추적 {:#track-widget-creation}

Track widget creation enabled (default):

Flutter 인스펙터의 기능 중 일부는, 위젯이 생성된 소스 위치를 더 잘 이해하기 위해, 
애플리케이션 코드를 계측하는 데 기반합니다. 
소스 계측을 통해, Flutter 인스펙터는 UI가 소스 코드에서 정의된 방식과 유사한 방식으로 위젯 트리를 표시할 수 있습니다. 
이 기능이 없으면, 위젯 트리의 노드 트리가 훨씬 더 깊어지고, 
런타임 위젯 계층 구조가 애플리케이션의 UI와 어떻게 대응하는지 이해하기가 더 어려울 수 있습니다.

`--no-track-widget-creation`을 `flutter run` 명령에 전달하여, 이 기능을 비활성화할 수 있습니다.

다음은 트랙 위젯 생성을 활성화한 경우와 그렇지 않은 경우, 위젯 트리가 어떻게 보일지에 대한 예입니다.

트랙 위젯 생성 활성화(기본값):

![The widget tree with track widget creation enabled](/assets/images/docs/tools/devtools/track_widget_creation_enabled.png){:width="100%"}

트랙 위젯 생성이 비활성화됨(권장하지 않음):

![The widget tree with track widget creation disabled](/assets/images/docs/tools/devtools/track_widget_creation_disabled.png){:width="100%"}

이 기능은 그렇지 않으면 동일한 `const` 위젯이 디버그 빌드에서 동등하게 간주되는 것을 방지합니다. 
자세한 내용은 [디버깅 시 일반적인 문제][common problems when debugging]에 대한 토론을 참조하세요.

## 검사기 설정 {:#inspector-settings}

![The Flutter Inspector Settings dialog](/assets/images/docs/tools/devtools/flutter_inspector_settings.png){:width="100%"}

### 호버 검사 활성화 {:#enable-hover-inspection}

위젯 위에 마우스를 올리면 해당 속성과 값이 표시됩니다.

이 값을 토글하면 호버 검사 기능이 활성화되거나 비활성화됩니다.

### 패키지 디렉토리 {:#package-directories}

기본적으로, DevTools는 위젯 트리에 표시되는 위젯을 프로젝트의 루트 디렉토리와 Flutter의 위젯으로 제한합니다. 
이 필터링은 Inspector 위젯 트리(Inspector의 왼쪽)에 있는 위젯에만 적용되며, 
위젯 세부 정보 트리(Layout Explorer와 동일한 탭 뷰에서 Inspector의 오른쪽)에는 적용되지 않습니다. 
위젯 세부 정보 트리에서, 모든 패키지의 트리에 있는 모든 위젯을 볼 수 있습니다.

다른 위젯을 표시하려면, 해당 위젯의 부모 디렉토리를 패키지 디렉토리에 추가해야 합니다.

예를 들어, 다음 디렉토리 구조를 고려해 보겠습니다.

```plaintext
project_foo
  pkgs
    project_foo_app
    widgets_A
    widgets_B
```

`project_foo_app`에서 앱을 실행하면, 
위젯 검사기 트리에 `project_foo/pkgs/project_foo_app`의 위젯만 표시됩니다.

위젯 트리에 `widgets_A`의 위젯을 표시하려면, 
패키지 디렉터리에 `project_foo/pkgs/widgets_A`를 추가합니다.

위젯 트리에 프로젝트 루트의 _모든_ 위젯을 표시하려면, 
패키지 디렉터리에 `project_foo`를 추가합니다.

패키지 디렉터리의 변경 사항은 다음에 위젯 검사기를 앱에 대해 열 때 유지됩니다.

## 기타 리소스 {:#other-resources}

인스펙터로 일반적으로 가능한 작업을 보여주는 데모는, 
Flutter 인스펙터의 IntelliJ 버전을 보여주는 [DartConf 2018 토크][DartConf 2018 talk]를 참조하세요.

DevTools를 사용하여 레이아웃 문제를 시각적으로 디버깅하는 방법을 알아보려면, 
가이드 [Flutter Inspector 튜토리얼][inspector-tutorial]을 확인하세요.

[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[common problems when debugging]: /testing/debugging
[`crossAxisAlignment`]: {{site.api}}/flutter/widgets/Flex/crossAxisAlignment.html
[DartConf 2018 talk]: {{site.yt.watch}}?v=JIcmJNT9DNI
[debug mode]: /testing/build-modes#debug
[`Flex`]: {{site.api}}/flutter/widgets/Flex-class.html
[flex layouts]: {{site.api}}/flutter/widgets/Flex-class.html
[`FlexFit`]: {{site.api}}/flutter/rendering/FlexFit.html
[`FlexParentData.fit`]: {{site.api}}/flutter/rendering/FlexParentData/fit.html
[`FlexParentData.flex`]: {{site.api}}/flutter/rendering/FlexParentData/flex.html
[`mainAxisAlignment`]: {{site.api}}/flutter/widgets/Flex/mainAxisAlignment.html
[`mainAxisSize`]: {{site.api}}/flutter/widgets/Flex/mainAxisSize.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`textDirection`]: {{site.api}}/flutter/widgets/Flex/textDirection.html
[Understanding constraints]: /ui/layout/constraints
[inspector-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-flutter-inspector-part-2-of-8-bbff40692fc7
