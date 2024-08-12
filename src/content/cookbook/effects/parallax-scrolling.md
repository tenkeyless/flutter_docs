---
# title: Create a scrolling parallax effect
title: 스크롤링 패럴랙스 효과 만들기
# description: How to implement a scrolling parallax effect.
description: 스크롤링 패럴랙스 효과를 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/effects/parallax_scrolling"?>

앱에서 카드 목록(예: 이미지 포함)을 스크롤하면, 해당 이미지가 화면의 나머지 부분보다 더 느리게 스크롤되는 것처럼 보일 수 있습니다. 
목록의 카드가 전경에 있는 것처럼 보이지만, 이미지 자체는 멀리 떨어진 배경에 있습니다. 이 효과를 패럴랙스(parallax)라고 합니다.

이 레시피에서는, 카드 목록(모서리가 둥글고 텍스트가 있는 목록)을 만들어 패럴랙스 효과를 만듭니다. 각 카드에는 이미지도 포함됩니다. 
카드가 화면 위로 미끄러지면, 각 카드 내의 이미지가 아래로 미끄러집니다.

다음 애니메이션은 앱의 동작을 보여줍니다.

![Parallax scrolling](/assets/images/docs/cookbook/effects/ParallaxScrolling.gif){:.site-mobile-screenshot}

## 패럴랙스 항목을 보관할 리스트 생성 {:#create-a-list-to-hold-the-parallax-items}

패럴랙스 스크롤링 이미지 목록을 표시하려면, 먼저 목록을 표시해야 합니다.

`ParallaxRecipe`라는 새 stateless 위젯을 만듭니다. 
`ParallaxRecipe` 내에서, `SingleChildScrollView`와 `Column`을 사용하여 목록을 형성하는 위젯 트리를 빌드합니다.

<?code-excerpt "lib/excerpt1.dart (ParallaxRecipe)"?>
```dart
class ParallaxRecipe extends StatelessWidget {
  const ParallaxRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [],
      ),
    );
  }
}
```

## 텍스트와 정적 이미지가 있는 항목 표시 {:#display-items-with-text-and-a-static-image}

각 목록 항목은 세계 7개 위치 중 하나를 나타내는, 둥근 사각형 배경 이미지를 표시합니다. 
배경 이미지 위에 위치 이름과 국가 이름이 왼쪽 아래에 배치되어 있습니다. 
배경 이미지와 텍스트 사이에는 어두운 그라데이션이 있어, 배경에 대한 텍스트의 가독성을 향상시킵니다.

이전에 언급한 비주얼로 구성된 `LocationListItem`이라는 stateless 위젯을 구현합니다. 
지금은, 배경에 static `Image` 위젯을 사용합니다. 나중에, 해당 위젯을 패럴랙스 버전으로 대체합니다.

<?code-excerpt "lib/excerpt2.dart (LocationListItem)"?>
```dart
@immutable
class LocationListItem extends StatelessWidget {
  const LocationListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.country,
  });

  final String imageUrl;
  final String name;
  final String country;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Positioned.fill(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            country,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
```

다음으로, `ParallaxRecipe` 위젯에 목록 항목을 추가합니다.

<?code-excerpt "lib/excerpt3.dart (ParallaxRecipeItems)"?>
```dart
class ParallaxRecipe extends StatelessWidget {
  const ParallaxRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final location in locations)
            LocationListItem(
              imageUrl: location.imageUrl,
              name: location.name,
              country: location.place,
            ),
        ],
      ),
    );
  }
}
```

이제 전 세계의 7개 고유한 위치를 표시하는 일반적인 스크롤 가능한 카드 목록이 있습니다. 
다음 단계에서는, 배경 이미지에 패럴랙스 효과를 추가합니다.

## 패럴랙스 효과 구현 {:#implement-the-parallax-effect}

패럴랙스 스크롤링 효과는 목록의 나머지 부분과 반대 방향으로 배경 이미지를 약간 미는 것으로 구현됩니다. 
목록 항목이 화면을 위로 밀어 올리면(slide up), 각 배경 이미지가 약간 아래로 슬라이드합니다. (slides slightly downward) 
반대로, 목록 항목이 화면을 아래로 밀어 올리면(slide down), 각 배경 이미지가 약간 위로 슬라이드합니다. (slides slightly upward)
시각적으로, 패럴랙스가 발생합니다.

패럴랙스 효과는 조상인 `Scrollable` 내에서 목록 항목의 현재 위치에 따라 달라집니다. 
목록 항목의 스크롤 위치가 변경되면, 목록 항목의 배경 이미지 위치도 변경해야 합니다. 
이는 해결하기 흥미로운 문제입니다. 
`Scrollable` 내에서 목록 항목의 위치는 Flutter의 레이아웃 단계가 완료될 때까지 사용할 수 없습니다. 
즉, 레이아웃 단계 다음에 오는, 페인트 단계에서 배경 이미지의 위치를 ​​결정해야 합니다. 
다행히도, Flutter는 `Flow`라는 위젯을 제공하는데, 
이 위젯은 위젯이 페인트되기 직전에 자식 위젯의 변형을 제어할 수 있도록 특별히 설계되었습니다. 
즉, 페인팅 단계를 가로채서, 원하는 대로 자식 위젯의 위치를 ​​변경할 수 있습니다.

:::note
자세한 내용을 알아보려면 `Flow` 위젯에 대한 이 짧은 주간 위젯 비디오를 확인하세요.

{% ytEmbed 'NG6pvXpnIso', 'Flow | 이번 주의 Flutter 위젯' %}
:::

:::note
child가 어디에 그려지는지가 아니라, 무엇을 그리는지에 대한 제어가 필요한 경우, 
[`CustomPaint`][] 위젯을 사용하는 것을 고려하세요.

레이아웃, 페인팅 및 히트 테스트를 제어해야 하는 경우, 커스텀 [`RenderBox`][]를 정의하는 것을 고려하세요.
:::

배경 `Image` 위젯을 [`Flow`][] 위젯으로 감싸세요.

<?code-excerpt "lib/excerpt4.dart (BuildParallaxBackground)" replace="/\n    delegate: ParallaxFlowDelegate\(\),//g"?>
```dart
Widget _buildParallaxBackground(BuildContext context) {
  return Flow(
    children: [
      Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    ],
  );
}
```

`ParallaxFlowDelegate`라는 새로운 `FlowDelegate`를 소개합니다.

<?code-excerpt "lib/excerpt4.dart (BuildParallaxBackground)"?>
```dart
Widget _buildParallaxBackground(BuildContext context) {
  return Flow(
    delegate: ParallaxFlowDelegate(),
    children: [
      Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    ],
  );
}
```

<?code-excerpt "lib/excerpt4.dart (parallax-flow-delegate)" replace="/\n    return constraints;//g"?>
```dart
class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate();

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    // TODO: 나중에 더 많은 내용을 추가할 것입니다.
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // TODO: 나중에 더 많은 내용을 추가할 것입니다.
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    // TODO: 나중에 더 많은 내용을 추가할 것입니다.
    return true;
  }
}
```

`FlowDelegate`는 children의 크기와 children이 그려지는 위치를 제어합니다. 
이 경우, `Flow` 위젯에는 child가 하나뿐입니다. 배경 이미지입니다. 
해당 이미지는 `Flow` 위젯과 정확히 같은 너비여야 합니다.

배경 이미지 child에 대한 엄격한 너비 제약 조건을 반환합니다.

<?code-excerpt "lib/main.dart (TightWidth)"?>
```dart
@override
BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
  return BoxConstraints.tightFor(
    width: constraints.maxWidth,
  );
}
```

배경 이미지의 크기가 이제 적절하게 조정되었지만, 
여전히 스크롤 위치를 기준으로 각 배경 이미지의 수직 위치를 계산한 다음, 페인트해야 합니다.

배경 이미지의 원하는 위치를 계산하는 데 필요한 세 가지 중요한 정보가 있습니다.

* 조상 `Scrollable`의 경계(bounds)
* 개별 목록 항목의 경계
* 목록 항목에 맞게 축소된 후의 이미지 크기

`Scrollable`의 경계를 찾으려면, `ScrollableState`를 `FlowDelegate`에 전달합니다.

개별 목록 항목의 경계를 찾으려면, 목록 항목의 `BuildContext`를 `FlowDelegate`에 전달합니다.

배경 이미지의 최종 크기를 찾으려면, `Image` 위젯에 `GlobalKey`를 할당한 다음, 
해당 `GlobalKey`를 `FlowDelegate`에 전달합니다.

이 정보를 `ParallaxFlowDelegate`에서 사용할 수 있도록 합니다.

<?code-excerpt "lib/excerpt5.dart (global-key)" plaster="none"?>
```dart
@immutable
class LocationListItem extends StatelessWidget {
  final GlobalKey _backgroundImageKey = GlobalKey();

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.network(
          imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
```

<?code-excerpt "lib/excerpt5.dart (parallax-flow-delegate-gk)" plaster="none"?>
```dart
class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  });

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;
}
```

패럴랙스 스크롤을 구현하는 데 필요한 모든 정보를 갖추고, `shouldRepaint()` 메서드를 구현합니다.

<?code-excerpt "lib/main.dart (ShouldRepaint)"?>
```dart
@override
bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
  return scrollable != oldDelegate.scrollable ||
      listItemContext != oldDelegate.listItemContext ||
      backgroundImageKey != oldDelegate.backgroundImageKey;
}
```

이제, 패럴랙스 효과에 대한 레이아웃 계산을 구현합니다.

먼저, 조상 `Scrollable` 내에서 목록 항목의 픽셀 위치를 계산합니다.

<?code-excerpt "lib/excerpt5.dart (paint-children)" plaster="none"?>
```dart
@override
void paintChildren(FlowPaintingContext context) {
  // 뷰포트 내에서 이 목록 항목의 위치를 ​​계산합니다.
  final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
  final listItemBox = listItemContext.findRenderObject() as RenderBox;
  final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox);
}
```

목록 항목의 픽셀 위치를 사용하여 `Scrollable` 상단으로부터의 백분율을 계산합니다. 
스크롤 가능 영역 상단에 있는 목록 항목은 0%를 생성해야 하고, 스크롤 가능 영역 하단에 있는 목록 항목은 100%를 생성해야 합니다.

<?code-excerpt "lib/excerpt5.dart (paint-children-2)"?>
```dart
@override
void paintChildren(FlowPaintingContext context) {
  // 뷰포트 내에서 이 목록 항목의 위치를 ​​계산합니다.
  final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
  final listItemBox = listItemContext.findRenderObject() as RenderBox;
  final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox);

  // 스크롤 가능한 영역 내에서 이 목록 항목의 퍼센트 위치를 결정합니다.
  final viewportDimension = scrollable.position.viewportDimension;
  final scrollFraction =
      (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);
  // ···
}
```

스크롤 백분율을 사용하여 `Alignment`를 계산합니다. 
0%에서는, `Alignment(0.0, -1.0)`를 원하고, 
100%에서는, `Alignment(0.0, 1.0)`를 원합니다. 
이러한 좌표는 각각 위쪽과 아래쪽 정렬에 해당합니다.

<?code-excerpt "lib/excerpt5.dart (paint-children-3)" plaster="none"?>
```dart
@override
void paintChildren(FlowPaintingContext context) {
  // 뷰포트 내에서 이 목록 항목의 위치를 ​​계산합니다.
  final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
  final listItemBox = listItemContext.findRenderObject() as RenderBox;
  final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox);

  // 스크롤 가능한 영역 내에서 이 목록 항목의 퍼센트 위치를 결정합니다.
  final viewportDimension = scrollable.position.viewportDimension;
  final scrollFraction =
      (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

  // 스크롤 비율에 따라 배경의 vertical 정렬을 계산합니다.
  final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);
}
```

`verticalAlignment`를, 목록 항목의 크기와 배경 이미지의 크기와 함께 사용하여, 
배경 이미지가 배치될 위치를 결정하는 `Rect`를 생성합니다.

<?code-excerpt "lib/excerpt5.dart (paint-children-4)" plaster="none"?>
```dart
@override
void paintChildren(FlowPaintingContext context) {
  // 뷰포트 내에서 이 목록 항목의 위치를 ​​계산합니다.
  final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
  final listItemBox = listItemContext.findRenderObject() as RenderBox;
  final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox);

  // 스크롤 가능한 영역 내에서 이 목록 항목의 퍼센트 위치를 결정합니다.
  final viewportDimension = scrollable.position.viewportDimension;
  final scrollFraction =
      (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

  // 스크롤 비율에 따라 배경의 vertical 정렬을 계산합니다.
  final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

  // 페인팅 목적으로 배경 정렬을 픽셀 오프셋으로 변환합니다.
  final backgroundSize =
      (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
          .size;
  final listItemSize = context.size;
  final childRect =
      verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);
}
```

`childRect`를 사용하여 원하는 변환 변환으로 배경 이미지를 그립니다. 
시간이 지남에 따라 이러한 변환이 패럴랙스 효과를 제공합니다.

<?code-excerpt "lib/excerpt5.dart (paint-children-5)" plaster="none" ?>
```dart
@override
void paintChildren(FlowPaintingContext context) {
  // 뷰포트 내에서 이 목록 항목의 위치를 ​​계산합니다.
  final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
  final listItemBox = listItemContext.findRenderObject() as RenderBox;
  final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox);

  // 스크롤 가능한 영역 내에서 이 목록 항목의 퍼센트 위치를 결정합니다.
  final viewportDimension = scrollable.position.viewportDimension;
  final scrollFraction =
      (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

  // 스크롤 비율에 따라 배경의 vertical 정렬을 계산합니다.
  final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

  // 페인팅 목적으로 배경 정렬을 픽셀 오프셋으로 변환합니다.
  final backgroundSize =
      (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
          .size;
  final listItemSize = context.size;
  final childRect =
      verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

  // 배경을 페인트합니다.
  context.paintChild(
    0,
    transform:
        Transform.translate(offset: Offset(0.0, childRect.top)).transform,
  );
}
```

패럴랙스 효과를 얻으려면 마지막 세부 사항이 필요합니다. 
`ParallaxFlowDelegate`는 입력이 변경될 때 다시 그려지지만, 
`ParallaxFlowDelegate`는 스크롤 위치가 변경될 때마다 다시 그려지지 않습니다.

`ScrollableState`의 `ScrollPosition`을 `FlowDelegate` 슈퍼클래스에 전달하여, 
`ScrollPosition`이 변경될 때마다 `FlowDelegate`가 다시 그려지도록 합니다.

<?code-excerpt "lib/main.dart (SuperScrollPosition)" replace="/;\n/;\n}/g"?>
```dart
class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);
}
```

축하합니다!
이제 패럴랙스, 스크롤링 배경 이미지가 있는 카드 목록이 있습니다.

## 대화형 예제 {:#interactive-example}

앱 실행:

* 위아래로 스크롤하여 패럴랙스 효과를 관찰합니다.

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter parallax scrolling hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: ExampleParallax(),
        ),
      ),
    );
  }
}

class ExampleParallax extends StatelessWidget {
  const ExampleParallax({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final location in locations)
            LocationListItem(
              imageUrl: location.imageUrl,
              name: location.name,
              country: location.place,
            ),
        ],
      ),
    );
  }
}

class LocationListItem extends StatelessWidget {
  LocationListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.country,
  });

  final String imageUrl;
  final String name;
  final String country;
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.network(
          imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            country,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);


  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // 뷰포트 내에서 이 목록 항목의 위치를 ​​계산합니다.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    // 스크롤 가능한 영역 내에서 이 목록 항목의 퍼센트 위치를 결정합니다.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // 스크롤 비율에 따라 배경의 vertical 정렬을 계산합니다.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // 페인팅 목적으로 배경 정렬을 픽셀 오프셋으로 변환합니다.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // 배경을 페인트합니다.
    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}

class Parallax extends SingleChildRenderObjectWidget {
  const Parallax({
    super.key,
    required Widget background,
  }) : super(child: background);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderParallax(scrollable: Scrollable.of(context));
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderParallax renderObject) {
    renderObject.scrollable = Scrollable.of(context);
  }
}

class ParallaxParentData extends ContainerBoxParentData<RenderBox> {}

class RenderParallax extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin {
  RenderParallax({
    required ScrollableState scrollable,
  }) : _scrollable = scrollable;

  ScrollableState _scrollable;

  ScrollableState get scrollable => _scrollable;

  set scrollable(ScrollableState value) {
    if (value != _scrollable) {
      if (attached) {
        _scrollable.position.removeListener(markNeedsLayout);
      }
      _scrollable = value;
      if (attached) {
        _scrollable.position.addListener(markNeedsLayout);
      }
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _scrollable.position.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollable.position.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! ParallaxParentData) {
      child.parentData = ParallaxParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // 배경이 사용 가능한 너비를 모두 차지하도록 한 다음 이미지의 종횡비에 따라 높이를 조절합니다.
    final background = child!;
    final backgroundImageConstraints =
        BoxConstraints.tightFor(width: size.width);
    background.layout(backgroundImageConstraints, parentUsesSize: true);

    // 배경의 로컬 오프셋을 0으로 설정합니다.
    (background.parentData as ParallaxParentData).offset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // 스크롤 가능한 영역의 크기를 가져옵니다.
    final viewportDimension = scrollable.position.viewportDimension;

    // 이 목록 항목의 글로벌 위치를 계산합니다.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final backgroundOffset =
        localToGlobal(size.centerLeft(Offset.zero), ancestor: scrollableBox);

    // 스크롤 가능한 영역 내에서 이 목록 항목의 퍼센트 위치를 결정합니다.
    final scrollFraction =
        (backgroundOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // 스크롤 비율에 따라 배경의 vertical 정렬을 계산합니다.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // 페인팅 목적으로 배경 정렬을 픽셀 오프셋으로 변환합니다.
    final background = child!;
    final backgroundSize = background.size;
    final listItemSize = size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // 배경을 페인트합니다.
    context.paintChild(
        background,
        (background.parentData as ParallaxParentData).offset +
            offset +
            Offset(0.0, childRect.top));
  }
}

class Location {
  const Location({
    required this.name,
    required this.place,
    required this.imageUrl,
  });

  final String name;
  final String place;
  final String imageUrl;
}

const urlPrefix =
    'https://docs.flutter.dev/cookbook/img-files/effects/parallax';
const locations = [
  Location(
    name: 'Mount Rushmore',
    place: 'U.S.A',
    imageUrl: '$urlPrefix/01-mount-rushmore.jpg',
  ),
  Location(
    name: 'Gardens By The Bay',
    place: 'Singapore',
    imageUrl: '$urlPrefix/02-singapore.jpg',
  ),
  Location(
    name: 'Machu Picchu',
    place: 'Peru',
    imageUrl: '$urlPrefix/03-machu-picchu.jpg',
  ),
  Location(
    name: 'Vitznau',
    place: 'Switzerland',
    imageUrl: '$urlPrefix/04-vitznau.jpg',
  ),
  Location(
    name: 'Bali',
    place: 'Indonesia',
    imageUrl: '$urlPrefix/05-bali.jpg',
  ),
  Location(
    name: 'Mexico City',
    place: 'Mexico',
    imageUrl: '$urlPrefix/06-mexico-city.jpg',
  ),
  Location(
    name: 'Cairo',
    place: 'Egypt',
    imageUrl: '$urlPrefix/07-cairo.jpg',
  ),
];
```

[`CustomPaint`]: {{site.api}}/flutter/widgets/CustomPaint-class.html
[`Flow`]: {{site.api}}/flutter/widgets/Flow-class.html
[`RenderBox`]: {{site.api}}/flutter/rendering/RenderBox-class.html
