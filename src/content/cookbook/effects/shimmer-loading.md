---
# title: Create a shimmer loading effect
title: 반짝이는(shimmer) 로딩 효과 만들기
# description: How to implement a shimmer loading effect.
description: 반짝이는(shimmer) 로딩 효과를 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/effects/shimmer_loading"?>

로딩 시간은 애플리케이션 개발에서 피할 수 없습니다. 
사용자 경험(UX) 관점에서, 가장 중요한 것은 사용자에게 로딩이 진행 중임을 보여주는 것입니다. 
사용자에게 데이터가 로딩 중임을 알리는 인기 있는 방법 중 하나는 
로딩 중인 콘텐츠 유형에 근접한 모양 위에 반짝이는(shimmer) 애니메이션이 있는 크롬 색상을 표시하는 것입니다.

다음 애니메이션은 앱의 동작을 보여줍니다.

![Gif showing the UI loading](/assets/images/docs/cookbook/effects/UILoadingAnimation.gif){:.site-mobile-screenshot}

이 레시피는 콘텐츠 위젯을 정의하고 배치하는 것으로 시작합니다. 
또한 오른쪽 하단 모서리에 로딩 모드와 로드 모드 사이를 전환하는 
플로팅 작업 버튼(FAB, Floating Action Button)이 있어 구현을 쉽게 검증할 수 있습니다.

## 반짝이는 모양 그리기 {:#draw-the-shimmer-shapes}

이 효과에서 반짝이는 모양은 결국 로드되는 실제 콘텐츠와 무관합니다.

따라서, 목표는 최종 콘텐츠를 가능한 한 정확하게 나타내는 모양을 표시하는 것입니다.

콘텐츠에 명확한 경계가 있는 상황에서는 정확한 모양을 표시하는 것이 쉽습니다. 
예를 들어, 이 레시피에는, 원형 이미지와 둥근 사각형 이미지가 있습니다. 
해당 이미지의 윤곽선과 정확히 일치하는 모양을 그릴 수 있습니다.

반면에, 둥근 사각형 이미지 아래에 나타나는 텍스트를 고려해봅시다. 
텍스트가 로드될 때까지, 텍스트 줄이 몇 개인지 알 수 없습니다. 
따라서, 모든 텍스트 줄에 대해 사각형을 그리려고 하는 것은 의미가 없습니다. 
대신, 데이터가 로드되는 동안, 나타날 텍스트를 나타내는 매우 얇은 둥근 사각형 몇 개를 그립니다. 
모양과 크기가 정확히 일치하지는 않지만, 괜찮습니다.

화면 상단의 원형 목록 항목부터 시작합니다. 
이미지가 로드되는 동안 각 `CircleListItem` 위젯에 색상이 있는 원이 표시되는지 확인합니다.

<?code-excerpt "lib/main.dart (CircleListItem)"?>
```dart
class CircleListItem extends StatelessWidget {
  const CircleListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        width: 54,
        height: 54,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.network(
            'https://docs.flutter.dev/cookbook'
            '/img-files/effects/split-check/Avatar1.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
```

위젯이 어떤 모양을 표시하는 한, 이 레시피에서 쉬머 효과를 적용할 수 있습니다.

`CircleListItem` 위젯과 마찬가지로, `CardListItem` 위젯이 이미지가 나타날 색상을 표시하는지 확인합니다.
또한, `CardListItem` 위젯에서, 현재 로딩 상태에 따라 텍스트와 사각형 표시를 전환합니다.

<?code-excerpt "lib/main.dart (CardListItem)"?>
```dart
class CardListItem extends StatelessWidget {
  const CardListItem({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          const SizedBox(height: 16),
          _buildText(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            'https://docs.flutter.dev/cookbook'
            '/img-files/effects/split-check/Food1.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 250,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
          'eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        ),
      );
    }
  }
}
```

이제 UI가 로딩 중이거나 로드 중인지에 따라 다르게 렌더링됩니다. 
이미지 URL을 일시적으로 주석 처리하면, UI가 렌더링되는 두 가지 방식을 볼 수 있습니다.

![Gif showing the shimmer animation](/assets/images/docs/cookbook/effects/LoadingShimmer.gif){:.site-mobile-screenshot}

다음 목표는 모든 채색된 영역을 반짝임처럼 보이는 단일 그라데이션으로 칠하는 것입니다.

## 쉬머 그라데이션 칠하기 {:#paint-the-shimmer-gradient}

이 레시피에서 달성한 효과의 핵심은 [`ShaderMask`][]라는 위젯을 사용하는 것입니다. 
`ShaderMask` 위젯은, 이름에서 알 수 있듯이, 자식 위젯에 셰이더를 적용하지만, 
자식 위젯이 이미 무언가를 그린 영역에만 적용됩니다. 
예를 들어, 이전에 구성한 검은색 모양에만 셰이더를 적용합니다.

반짝이는 모양에 적용되는 크롬 색상의 선형 그라데이션을 정의합니다.

<?code-excerpt "lib/main.dart (shimmerGradient)"?>
```dart
const _shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
```

`ShimmerLoading`이라는 새로운 stateful 위젯을 정의하여, 주어진 `child` 위젯을 `ShaderMask`로 래핑합니다. 
`ShaderMask` 위젯을 구성하여 `blendMode`가 `srcATop`인 셰이더로 쉬머 그라데이션을 적용합니다. 
`srcATop` 블렌드 모드는 `child` 위젯이 칠한 모든 색상을 셰이더 색상으로 대체합니다.

<?code-excerpt "lib/main.dart (ShimmerLoading)"?>
```dart
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return _shimmerGradient.createShader(bounds);
      },
      child: widget.child,
    );
  }
}
```

`CircleListItem` 위젯을 `ShimmerLoading` 위젯으로 래핑합니다.

<?code-excerpt "lib/shimmer_loading_items.dart (buildTopRowItem)"?>
```dart
Widget _buildTopRowItem() {
  return ShimmerLoading(
    isLoading: _isLoading,
    child: const CircleListItem(),
  );
}
```

`CardListItem` 위젯을 `ShimmerLoading` 위젯으로 래핑합니다.

<?code-excerpt "lib/shimmer_loading_items.dart (buildListItem)"?>
```dart
Widget _buildListItem() {
  return ShimmerLoading(
    isLoading: _isLoading,
    child: CardListItem(
      isLoading: _isLoading,
    ),
  );
}
```

모양이 로딩되면, 이제 `shaderCallback`에서 반환된 반짝이는 그라데이션이 표시됩니다.

이것은 올바른 방향으로 나아가는 큰 진전이지만, 이 그라데이션 표시에는 문제가 있습니다. 
각 `CircleListItem` 위젯과 각 `CardListItem` 위젯은 그라데이션의 새 버전을 표시합니다. 
이 레시피의 경우, 전체 화면은 하나의 크고 반짝이는 표면처럼 보여야 합니다. 다음 단계에서 이 문제를 해결합니다.

## 하나의 큰 쉬머 칠하기 {:#paint-one-big-shimmer}

화면에 큰 쉬머를 하나 칠하려면, 각 `ShimmerLoading` 위젯은 
화면에서 해당 `ShimmerLoading` 위젯의 위치에 따라 동일한 전체 화면 그라데이션을 칠해야 합니다.

더 정확하게 말해서, 쉬머가 전체 화면을 차지해야 한다고 가정하는 대신, 쉬머를 공유하는 영역이 있어야 합니다. 
그 영역이 전체 화면을 차지할 수도 있고, 그렇지 않을 수도 있습니다. 
Flutter에서 이런 종류의 문제를 해결하는 방법은 
위젯 트리에서 모든 `ShimmerLoading` 위젯 위에 있는 다른 위젯을 정의하고 `Shimmer`라고 부르는 것입니다. 
그런 다음, 각 `ShimmerLoading` 위젯은 `Shimmer` 상위 위젯에 대한 참조를 가져오고, 
표시할 원하는 크기와 그라데이션을 요청합니다.

`Shimmer`라는 새 stateful 위젯을 정의합니다. 
이 위젯은 [`LinearGradient`][]를 가져오고, 하위 위젯에 `State` 객체에 대한 액세스를 제공합니다.

<?code-excerpt "lib/main.dart (Shimmer)"?>
```dart
class Shimmer extends StatefulWidget {
  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  const Shimmer({
    super.key,
    required this.linearGradient,
    this.child,
  });

  final LinearGradient linearGradient;
  final Widget? child;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> {
  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}
```

`ShimmerState` 클래스에 메서드를 추가하여, `linearGradient`에 접근할 수 있게 하고, 
`ShimmerState`의 `RenderBox` 크기를 제공하며, 
`ShimmerState`의 `RenderBox` 내에서 자손의 위치를 ​​조회합니다.

<?code-excerpt "lib/shimmer_state.dart (ShimmerState)"?>
```dart
class ShimmerState extends State<Shimmer> {
  Gradient get gradient => LinearGradient(
        colors: widget.linearGradient.colors,
        stops: widget.linearGradient.stops,
        begin: widget.linearGradient.begin,
        end: widget.linearGradient.end,
      );

  bool get isSized =>
      (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}
```

Wrap all of your screen's content with the `Shimmer` widget.

<?code-excerpt "lib/main.dart (ExampleUiAnimationState)"?>
```dart
class _ExampleUiLoadingAnimationState extends State<ExampleUiLoadingAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer(
        linearGradient: _shimmerGradient,
        child: ListView(
            // ListView 컨텐츠
            ),
      ),
    );
  }
}
```

`ShimmerLoading` 위젯 내에서 `Shimmer` 위젯을 사용하여, 공유된 그래디언트를 칠합니다.

<?code-excerpt "lib/shimmer_loading_state_pt2.dart (ShimmerLoadingStatePt2)"?>
```dart
class _ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    // 조상의 쉬머 정보를 수집합니다.
    final shimmer = Shimmer.of(context)!;
    if (!shimmer.isSized) {
      // 조상 Shimmer 위젯은 아직 배치되지 않았습니다. 빈 상자를 반환합니다.
      return const SizedBox();
    }
    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    final offsetWithinShimmer = shimmer.getDescendantOffset(
      descendant: context.findRenderObject() as RenderBox,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetWithinShimmer.dx,
            -offsetWithinShimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}
```

이제 `ShimmerLoading` 위젯은 `Shimmer` 위젯 내의 모든 공간을 차지하는 공유 그라데이션을 표시합니다.

## 쉬머 애니메이트 {:#animate-the-shimmer}

반짝이는 그라데이션은 반짝이는 광채를 나타내기 위해 움직여야 합니다.

`LinearGradient`에는 `transform`이라는 속성이 있는데, 이를 사용하여 그라디언트의 모양을 변형할 수 있습니다. 
예를 들어, 수평으로 이동시키는 것입니다. `transform` 속성은 `GradientTransform` 인스턴스를 허용합니다.

`GradientTransform`을 구현하여 수평 슬라이딩의 모양을 구현하는 `_SlidingGradientTransform`이라는 클래스를 정의합니다.

<?code-excerpt "lib/original_example.dart (sliding-gradient-transform)"?>
```dart
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
```

그라데이션 슬라이드 백분율은 동작의 모양을 만들기 위해 시간이 지남에 따라 변경됩니다. 
백분율을 변경하려면, `ShimmerState` 클래스에서 [`AnimationController`][]를 구성하세요.

<?code-excerpt "lib/original_example.dart (shimmer-state-animation)" replace="/\/\/ code-excerpt-closing-bracket/}/g"?>
```dart
class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }
}
```

`_shimmerController`의 `value`를 `slidePercent`로 사용하여,
`_SlidingGradientTransform`을 `gradient`에 적용합니다.


<?code-excerpt "lib/original_example.dart (linear-gradient)"?>
```dart
LinearGradient get gradient => LinearGradient(
      colors: widget.linearGradient.colors,
      stops: widget.linearGradient.stops,
      begin: widget.linearGradient.begin,
      end: widget.linearGradient.end,
      transform:
          _SlidingGradientTransform(slidePercent: _shimmerController.value),
    );
```

이제 그래디언트가 애니메이션화되지만, 개별 `ShimmerLoading` 위젯은 그래디언트가 변경될 때 스스로 다시 그려지지 않습니다. 
따라서, 아무 일도 일어나지 않는 것처럼 보입니다.

`ShimmerState`에서 `_shimmerController`를 [`Listenable`][]로 노출합니다.

<?code-excerpt "lib/original_example.dart (shimmer-changes)"?>
```dart
Listenable get shimmerChanges => _shimmerController;
```

`ShimmerLoading`에서, 조상 `ShimmerState`의 `shimmerChanges` 속성에 대한 변경 사항을 수신하고, 
쉬머 그라데이션을 다시 칠합니다.

<?code-excerpt "lib/original_example.dart (shimmer-loading-state)" replace="/\/\/ code-excerpt-closing-bracket/}/g"?>
```dart
class _ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    if (widget.isLoading) {
      setState(() {
        // 쉬머 페인팅을 업데이트합니다.
      });
    }
  }
}
```

축하합니다!
이제 콘텐츠가 로드될 때 켜지고 꺼지는 전체 화면 애니메이션 반짝임 효과가 있습니다.

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/original_example.dart" remove="code-excerpt-closing-bracket"?>
```dartpad title="Flutter shimmer loading hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleUiLoadingAnimation(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

const _shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

class ExampleUiLoadingAnimation extends StatefulWidget {
  const ExampleUiLoadingAnimation({
    super.key,
  });

  @override
  State<ExampleUiLoadingAnimation> createState() =>
      _ExampleUiLoadingAnimationState();
}

class _ExampleUiLoadingAnimationState extends State<ExampleUiLoadingAnimation> {
  bool _isLoading = true;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer(
        linearGradient: _shimmerGradient,
        child: ListView(
          physics: _isLoading ? const NeverScrollableScrollPhysics() : null,
          children: [
            const SizedBox(height: 16),
            _buildTopRowList(),
            const SizedBox(height: 16),
            _buildListItem(),
            _buildListItem(),
            _buildListItem(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleLoading,
        child: Icon(
          _isLoading ? Icons.hourglass_full : Icons.hourglass_bottom,
        ),
      ),
    );
  }

  Widget _buildTopRowList() {
    return SizedBox(
      height: 72,
      child: ListView(
        physics: _isLoading ? const NeverScrollableScrollPhysics() : null,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          const SizedBox(width: 16),
          _buildTopRowItem(),
          _buildTopRowItem(),
          _buildTopRowItem(),
          _buildTopRowItem(),
          _buildTopRowItem(),
          _buildTopRowItem(),
        ],
      ),
    );
  }

  Widget _buildTopRowItem() {
    return ShimmerLoading(
      isLoading: _isLoading,
      child: const CircleListItem(),
    );
  }

  Widget _buildListItem() {
    return ShimmerLoading(
      isLoading: _isLoading,
      child: CardListItem(
        isLoading: _isLoading,
      ),
    );
  }
}

class Shimmer extends StatefulWidget {
  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  const Shimmer({
    super.key,
    required this.linearGradient,
    this.child,
  });

  final LinearGradient linearGradient;
  final Widget? child;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  LinearGradient get gradient => LinearGradient(
        colors: widget.linearGradient.colors,
        stops: widget.linearGradient.stops,
        begin: widget.linearGradient.begin,
        end: widget.linearGradient.end,
        transform:
            _SlidingGradientTransform(slidePercent: _shimmerController.value),
      );

  bool get isSized =>
      (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox?;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  Listenable get shimmerChanges => _shimmerController;

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    if (widget.isLoading) {
      setState(() {
        // 쉬머 페인팅을 업데이트합니다.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    // 조상의 쉬머 정보를 수집합니요.
    final shimmer = Shimmer.of(context)!;
    if (!shimmer.isSized) {
      // 조상 Shimmer 위젯은 아직 레이아웃되지 않았습니다. 빈 상자를 반환합니다.
      return const SizedBox();
    }
    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    final offsetWithinShimmer = shimmer.getDescendantOffset(
      descendant: context.findRenderObject() as RenderBox,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetWithinShimmer.dx,
            -offsetWithinShimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}

//----------- List Items ---------
class CircleListItem extends StatelessWidget {
  const CircleListItem({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        width: 54,
        height: 54,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.network(
            'https://docs.flutter.dev/cookbook'
            '/img-files/effects/split-check/Avatar1.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class CardListItem extends StatelessWidget {
  const CardListItem({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          const SizedBox(height: 16),
          _buildText(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            'https://docs.flutter.dev/cookbook'
            '/img-files/effects/split-check/Food1.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 250,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
          'eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        ),
      );
    }
  }
}
```



[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[cloning the example code]: {{site.github}}/flutter/codelabs
[issue 44152]: {{site.repo.flutter}}/issues/44152
[`LinearGradient`]: {{site.api}}/flutter/painting/LinearGradient-class.html
[`Listenable`]: {{site.api}}/flutter/foundation/Listenable-class.html
[`ShaderMask`]: {{site.api}}/flutter/widgets/ShaderMask-class.html
