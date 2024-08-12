---
# title: Create a photo filter carousel
title: 사진 필터 carousel 만들기
# description: How to implement a photo filter carousel in Flutter.
description: Flutter에서 사진 필터 carousel를 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/effects/photo_filter_carousel"?>

{% include docs/deprecated.md %}

필터가 있는 사진이 더 보기 좋다는 건 누구나 알고 있습니다. 이 레시피에서는, 스크롤 가능한, 필터 선택 carousel를 만듭니다.

다음 애니메이션은 앱의 동작을 보여줍니다.

![Photo Filter Carousel](/assets/images/docs/cookbook/effects/PhotoFilterCarousel.gif){:.site-mobile-screenshot}

이 레시피는 사진과 필터가 이미 있는 상태에서 시작합니다. 
필터는 [`Image`][] 위젯의 `color` 및 `colorBlendMode` 속성으로 적용됩니다.

## 선택기 링과 다크 그라디언트 추가 {:#add-a-selector-ring-and-dark-gradient}

선택된 필터 원은 선택기 링 안에 표시됩니다. 
또한, 사용 가능한 필터 뒤에 어두운 그라데이션이 있어 필터와 선택한 사진 간의 대비를 돕습니다.

선택기를 구현하는 데 사용할 `FilterSelector`라는 새 stateful 위젯을 만듭니다.

<?code-excerpt "lib/excerpt1.dart (FilterSelector)"?>
```dart
@immutable
class FilterSelector extends StatefulWidget {
  const FilterSelector({
    super.key,
  });

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
```

기존 위젯 트리에 `FilterSelector` 위젯을 추가합니다. 
`FilterSelector` 위젯을 사진 위, 아래, 중앙에 배치합니다.

<?code-excerpt "lib/excerpt1.dart (Stack)" replace="/^child: //g"?>
```dart
Stack(
  children: [
    Positioned.fill(
      child: _buildPhotoWithFilter(),
    ),
    const Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: FilterSelector(),
    ),
  ],
),
```

`FilterSelector` 위젯 내에서, 
`Stack` 위젯을 사용하여 어두운 그라데이션 위에 선택기 링을 표시합니다.

<?code-excerpt "lib/excerpt2.dart (FilterSelectorState2)"?>
```dart
class _FilterSelectorState extends State<FilterSelector> {
  static const _filtersPerScreen = 5;
  static const _viewportFractionPerItem = 1.0 / _filtersPerScreen;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemSize = constraints.maxWidth * _viewportFractionPerItem;

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _buildShadowGradient(itemSize),
            _buildSelectionRing(itemSize),
          ],
        );
      },
    );
  }

  Widget _buildShadowGradient(double itemSize) {
    return SizedBox(
      height: itemSize * 2 + widget.padding.vertical,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
            ],
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }

  Widget _buildSelectionRing(double itemSize) {
    return IgnorePointer(
      child: Padding(
        padding: widget.padding,
        child: SizedBox(
          width: itemSize,
          height: itemSize,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(width: 6, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

선택기 링과 배경 그래디언트의 크기는 `itemSize`라는 carousel의 개별 필터 크기에 따라 달라집니다. 
`itemSize`는 사용 가능한 너비에 따라 달라집니다. 
따라서, `LayoutBuilder` 위젯을 사용하여 사용 가능한 공간을 결정한 다음, 
개별 필터의 `itemSize` 크기를 계산합니다.

선택기 링에는 `IgnorePointer` 위젯이 포함되어 있는데, 
carousel 상호 작용이 추가되면 선택기 링이 탭 및 드래그 이벤트를 방해하지 않아야 하기 때문입니다.

## 필터 carousel 항목 만들기 {:#create-a-filter-carousel-item}

carousel의 각 필터 항목은 연관된 필터 색상에 해당하는 색상이 적용된 원형 이미지를 표시합니다.

단일 목록 항목을 표시하는 `FilterItem`이라는 새 stateless 위젯을 정의합니다.

<?code-excerpt "lib/original_example.dart (filter-item)"?>
```dart
@immutable
class FilterItem extends StatelessWidget {
  const FilterItem({
    super.key,
    required this.color,
    this.onFilterSelected,
  });

  final Color color;
  final VoidCallback? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ClipOval(
            child: Image.network(
              'https://docs.flutter.dev/cookbook/img-files'
              '/effects/instagram-buttons/millennial-texture.jpg',
              color: color.withOpacity(0.5),
              colorBlendMode: BlendMode.hardLight,
            ),
          ),
        ),
      ),
    );
  }
}
```

## 필터 carousel 구현 {:#implement-the-filter-carousel}

필터 항목은 사용자가 드래그할 때 좌우로 스크롤됩니다. 스크롤에는 일종의 `Scrollable` 위젯이 필요합니다.

horizontal `ListView` 위젯을 사용하는 것을 고려할 수 있지만, 
`ListView` 위젯은 첫 번째 요소를 선택기 링이 있는 중앙이 아닌 사용 가능한 공간의 시작 부분에 배치합니다.

`PageView` 위젯이 회전형에 더 적합합니다. 
`PageView` 위젯은 사용 가능한 공간의 중앙에서 자식을 배치하고, 스냅핑 물리(snapping physics)를 제공합니다. 
스냅핑 물리(snapping physics)는 사용자가 드래그를 놓을 위치에 관계없이, 항목이 중앙으로 스냅되도록 하는 것입니다.

:::note
스크롤 가능 영역 내에서 자식 위젯의 위치를 커스터마이즈해야 하는 경우, 
[`Scrollable`][] 위젯을 [`viewportBuilder`][]와 함께 사용하고, 
[`Flow`][] 위젯을 `viewportBuilder` 내부에 배치하는 것을 고려하세요. 
`Flow` 위젯에는, 현재 `viewportOffset`에 따라, 자식 위젯을 원하는 위치에 배치할 수 있는 
[delegate 속성][delegate property]가 있습니다.
:::

`PageView`를 위한 공간을 확보하기 위해 위젯 트리를 구성합니다.

<?code-excerpt "lib/excerpt3.dart (page-view)"?>
```dart
@override
Widget build(BuildContext context) {
  return LayoutBuilder(builder: (context, constraints) {
    final itemSize = constraints.maxWidth * _viewportFractionPerItem;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _buildShadowGradient(itemSize),
        _buildCarousel(itemSize),
        _buildSelectionRing(itemSize),
      ],
    );
  });
}

Widget _buildCarousel(double itemSize) {
  return Container(
    height: itemSize,
    margin: widget.padding,
    child: PageView.builder(
      itemCount: widget.filters.length,
      itemBuilder: (context, index) {
        return const SizedBox();
      },
    ),
  );
}
```

주어진 `index`를 기반으로 `PageView` 위젯 내에서 각 `FilterItem` 위젯을 빌드합니다.

<?code-excerpt "lib/excerpt4.dart (BuildFilterItem)"?>
```dart
Color itemColor(int index) => widget.filters[index % widget.filters.length];

Widget _buildCarousel(double itemSize) {
  return Container(
    height: itemSize,
    margin: widget.padding,
    child: PageView.builder(
      itemCount: widget.filters.length,
      itemBuilder: (context, index) {
        return Center(
          child: FilterItem(
            color: itemColor(index),
            onFilterSelected: () {},
          ),
        );
      },
    ),
  );
}
```

`PageView` 위젯은 모든 `FilterItem` 위젯을 표시하며, 좌우로 드래그할 수 있습니다. 
그러나, 지금은 각 `FilterItem` 위젯이 화면의 전체 너비를 차지하고, 
각 `FilterItem` 위젯은 동일한 크기와 불투명도로 표시됩니다. 
화면에는 5개의 `FilterItem` 위젯이 있어야 하며, 
`FilterItem` 위젯은 화면 중앙에서 멀어질수록 줄어들고 희미해져야 합니다.

이 두 가지 문제에 대한 해결책은 `PageViewController`를 도입하는 것입니다. 
`PageViewController`의 `viewportFraction` 속성은 여러 `FilterItem` 위젯을 동시에 화면에 표시하는 데 사용됩니다.
`PageViewController`가 변경될 때 각 `FilterItem` 위젯을 다시 빌드하면, 사용자가 스크롤할 때 각 `FilterItem` 위젯의 크기와 불투명도를 변경할 수 있습니다.

`PageViewController`를 만들고, `PageView` 위젯에 연결합니다.

<?code-excerpt "lib/excerpt5.dart (page-view-controller)" plaster="none"?>
```dart
class _FilterSelectorState extends State<FilterSelector> {
  static const _filtersPerScreen = 5;
  static const _viewportFractionPerItem = 1.0 / _filtersPerScreen;

  late final PageController _controller;

  Color itemColor(int index) => widget.filters[index % widget.filters.length];

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: _viewportFractionPerItem,
    );
    _controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = (_controller.page ?? 0).round();
    widget.onFilterChanged(widget.filters[page]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCarousel(double itemSize) {
    return Container(
      height: itemSize,
      margin: widget.padding,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.filters.length,
        itemBuilder: (context, index) {
          return Center(
            child: FilterItem(
              color: itemColor(index),
              onFilterSelected: () {},
            ),
          );
        },
      ),
    );
  }
}
```

With the `PageViewController` added, five `FilterItem`
widgets are visible on the screen at the same time,
and the photo filter changes as you scroll, but 
the `FilterItem` widgets are still the same size. 

Wrap each `FilterItem` widget with an `AnimatedBuilder`
to change the visual properties of each `FilterItem`
widget as the scroll position changes.

<?code-excerpt "lib/excerpt6.dart (BuildCarousel)"?>
```dart
Widget _buildCarousel(double itemSize) {
  return Container(
    height: itemSize,
    margin: widget.padding,
    child: PageView.builder(
      controller: _controller,
      itemCount: widget.filters.length,
      itemBuilder: (context, index) {
        return Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FilterItem(
                color: itemColor(index),
                onFilterSelected: () => {},
              );
            },
          ),
        );
      },
    ),
  );
}
```

`AnimatedBuilder` 위젯은 `_controller`가 스크롤 위치를 변경할 때마다 다시 빌드됩니다. 
이러한 다시 빌드를 통해 사용자가 드래그할 때 `FilterItem` 크기와 불투명도를 변경할 수 있습니다.

`AnimatedBuilder` 내의 각 `FilterItem` 위젯에 적합한 스케일과 불투명도를 계산하고 해당 값을 적용합니다.

<?code-excerpt "lib/original_example.dart (final-build-carousel)"?>
```dart
Widget _buildCarousel(double itemSize) {
  return Container(
    height: itemSize,
    margin: widget.padding,
    child: PageView.builder(
      controller: _controller,
      itemCount: widget.filters.length,
      itemBuilder: (context, index) {
        return Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              if (!_controller.hasClients ||
                  !_controller.position.hasContentDimensions) {
                // PageViewController는 아직 PageView 위젯에 연결되지 않았습니다. 
                // 빈 상자를 반환합니다.
                return const SizedBox();
              }

              // 현재 페이지의 정수 인덱스는 0, 1, 2, 3 등입니다.
              final selectedIndex = _controller.page!.roundToDouble();

              // 현재 필터를 왼쪽이나 오른쪽으로 드래그하는 비율(fractional) 값입니다. 
              // 예를 들어, 현재 필터를 왼쪽으로 25% 드래그하면 0.25가 됩니다.
              final pageScrollAmount = _controller.page! - selectedIndex;

              // 필터가 화면에서 사라지기 직전까지의 페이지 거리입니다.
              const maxScrollDistance = _filtersPerScreen / 2;

              // 현재 선택된 필터 항목에서 이 필터 항목까지의 페이지 거리입니다.
              final pageDistanceFromSelected =
                  (selectedIndex - index + pageScrollAmount).abs();

              // carousel 메뉴의 중심(선택기 링이 있는 위치)에서 필터 항목까지의 거리(백분율)입니다.
              final percentFromCenter =
                  1.0 - pageDistanceFromSelected / maxScrollDistance;

              final itemScale = 0.5 + (percentFromCenter * 0.5);
              final opacity = 0.25 + (percentFromCenter * 0.75);

              return Transform.scale(
                scale: itemScale,
                child: Opacity(
                  opacity: opacity,
                  child: FilterItem(
                    color: itemColor(index),
                    onFilterSelected: () => () {},
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
```

각 `FilterItem` 위젯은 이제 화면 중앙에서 멀어질수록 줄어들고 사라집니다.

`FilterItem` 위젯을 탭하면 선택된 필터를 변경하는 메서드를 추가합니다.

<?code-excerpt "lib/original_example.dart (FilterTapped)"?>
```dart
void _onFilterTapped(int index) {
  _controller.animateToPage(
    index,
    duration: const Duration(milliseconds: 450),
    curve: Curves.ease,
  );
}
```

각 `FilterItem` 위젯을 구성하여 탭하면 `_onFilterTapped`를 호출하도록 합니다.

```dart
FilterItem(
  color: itemColor(index),
  onFilterSelected: () => _onFilterTapped,
),
```

축하합니다!
이제 드래그하고 탭할 수 있는 사진 필터 carousel가 생겼습니다.

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter photo filter carousel hands-on example in DartPad" run="true"
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ViewportOffset;

void main() {
  runApp(
    const MaterialApp(
      home: ExampleInstagramFilterSelection(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

@immutable
class ExampleInstagramFilterSelection extends StatefulWidget {
  const ExampleInstagramFilterSelection({super.key});

  @override
  State<ExampleInstagramFilterSelection> createState() =>
      _ExampleInstagramFilterSelectionState();
}

class _ExampleInstagramFilterSelectionState
    extends State<ExampleInstagramFilterSelection> {
  final _filters = [
    Colors.white,
    ...List.generate(
      Colors.primaries.length,
      (index) => Colors.primaries[(index * 4) % Colors.primaries.length],
    )
  ];

  final _filterColor = ValueNotifier<Color>(Colors.white);

  void _onFilterChanged(Color value) {
    _filterColor.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: _buildPhotoWithFilter(),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: _buildFilterSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoWithFilter() {
    return ValueListenableBuilder(
      valueListenable: _filterColor,
      builder: (context, color, child) {
        return Image.network(
          'https://docs.flutter.dev/cookbook/img-files'
          '/effects/instagram-buttons/millennial-dude.jpg',
          color: color.withOpacity(0.5),
          colorBlendMode: BlendMode.color,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildFilterSelector() {
    return FilterSelector(
      onFilterChanged: _onFilterChanged,
      filters: _filters,
    );
  }
}

@immutable
class FilterSelector extends StatefulWidget {
  const FilterSelector({
    super.key,
    required this.filters,
    required this.onFilterChanged,
    this.padding = const EdgeInsets.symmetric(vertical: 24),
  });

  final List<Color> filters;
  final void Function(Color selectedColor) onFilterChanged;
  final EdgeInsets padding;

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  static const _filtersPerScreen = 5;
  static const _viewportFractionPerItem = 1.0 / _filtersPerScreen;

  late final PageController _controller;
  late int _page;

  int get filterCount => widget.filters.length;

  Color itemColor(int index) => widget.filters[index % filterCount];

  @override
  void initState() {
    super.initState();
    _page = 0;
    _controller = PageController(
      initialPage: _page,
      viewportFraction: _viewportFractionPerItem,
    );
    _controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = (_controller.page ?? 0).round();
    if (page != _page) {
      _page = page;
      widget.onFilterChanged(widget.filters[page]);
    }
  }

  void _onFilterTapped(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      controller: _controller,
      axisDirection: AxisDirection.right,
      physics: const PageScrollPhysics(),
      viewportBuilder: (context, viewportOffset) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final itemSize = constraints.maxWidth * _viewportFractionPerItem;
            viewportOffset
              ..applyViewportDimension(constraints.maxWidth)
              ..applyContentDimensions(0.0, itemSize * (filterCount - 1));

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildShadowGradient(itemSize),
                _buildCarousel(
                  viewportOffset: viewportOffset,
                  itemSize: itemSize,
                ),
                _buildSelectionRing(itemSize),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildShadowGradient(double itemSize) {
    return SizedBox(
      height: itemSize * 2 + widget.padding.vertical,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
            ],
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }

  Widget _buildCarousel({
    required ViewportOffset viewportOffset,
    required double itemSize,
  }) {
    return Container(
      height: itemSize,
      margin: widget.padding,
      child: Flow(
        delegate: CarouselFlowDelegate(
          viewportOffset: viewportOffset,
          filtersPerScreen: _filtersPerScreen,
        ),
        children: [
          for (int i = 0; i < filterCount; i++)
            FilterItem(
              onFilterSelected: () => _onFilterTapped(i),
              color: itemColor(i),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectionRing(double itemSize) {
    return IgnorePointer(
      child: Padding(
        padding: widget.padding,
        child: SizedBox(
          width: itemSize,
          height: itemSize,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(width: 6, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CarouselFlowDelegate extends FlowDelegate {
  CarouselFlowDelegate({
    required this.viewportOffset,
    required this.filtersPerScreen,
  }) : super(repaint: viewportOffset);

  final ViewportOffset viewportOffset;
  final int filtersPerScreen;

  @override
  void paintChildren(FlowPaintingContext context) {
    final count = context.childCount;

    // 사용 가능한 모든 페인팅 폭
    final size = context.size.width;

    // 스크롤 페이징 시스템의 관점에서 단일 항목 "페이지"가 ​​차지하는 거리입니다. 
    // 또한 이 크기를 단일 항목의 너비와 높이에도 사용합니다.
    final itemExtent = size / filtersPerScreen;

    // 현재 스크롤 위치는 항목 비율(fraction)로 표현됩니다. (예: 0.0, 1.0, 1.3, 2.9 등). 
    // 1.3의 값은 인덱스 1의 항목이 활성화되어 있고, 사용자가 인덱스 2의 항목 방향으로 30% 스크롤했음을 나타냅니다.
    final active = viewportOffset.pixels / itemExtent;

    // 지금 당장 페인트해야 할 첫 번째 항목의 인덱스입니다.
    // 최대 3개 항목을 활성 항목의 왼쪽에 페인트합니다.
    final min = math.max(0, active.floor() - 3).toInt();

    // 지금 당장 페인트해야 할 마지막 항목의 인덱스입니다.
    // 최대 3개의 항목을 활성 항목의 오른쪽에 페인트합니다.
    final max = math.min(count - 1, active.ceil() + 3).toInt();

    // 표시된 항목에 대한 변환을 생성하고 거리별로 정렬합니다.
    for (var index = min; index <= max; index++) {
      final itemXFromCenter = itemExtent * index - viewportOffset.pixels;
      final percentFromCenter = 1.0 - (itemXFromCenter / (size / 2)).abs();
      final itemScale = 0.5 + (percentFromCenter * 0.5);
      final opacity = 0.25 + (percentFromCenter * 0.75);

      final itemTransform = Matrix4.identity()
        ..translate((size - itemExtent) / 2)
        ..translate(itemXFromCenter)
        ..translate(itemExtent / 2, itemExtent / 2)
        ..multiply(Matrix4.diagonal3Values(itemScale, itemScale, 1.0))
        ..translate(-itemExtent / 2, -itemExtent / 2);

      context.paintChild(
        index,
        transform: itemTransform,
        opacity: opacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CarouselFlowDelegate oldDelegate) {
    return oldDelegate.viewportOffset != viewportOffset;
  }
}

@immutable
class FilterItem extends StatelessWidget {
  const FilterItem({
    super.key,
    required this.color,
    this.onFilterSelected,
  });

  final Color color;
  final VoidCallback? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ClipOval(
            child: Image.network(
              'https://docs.flutter.dev/cookbook/img-files'
              '/effects/instagram-buttons/millennial-texture.jpg',
              color: color.withOpacity(0.5),
              colorBlendMode: BlendMode.hardLight,
            ),
          ),
        ),
      ),
    );
  }
}
```

[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[`Scrollable`]: {{site.api}}/flutter/widgets/Scrollable-class.html
[`viewportBuilder`]: {{site.api}}/flutter/widgets/Scrollable/viewportBuilder.html
[`Flow`]: {{site.api}}/flutter/widgets/Flow-class.html
[delegate property]: {{site.api}}/flutter/widgets/Flow/delegate.html
