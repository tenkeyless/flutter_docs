---
# title: Create an expandable FAB
title: 확장 가능한 FAB 만들기
# description: How to implement a FAB that expands to multiple buttons when tapped.
description: 탭하면 여러 개의 버튼으로 확장되는 FAB를 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/effects/expandable_fab"?>

플로팅 액션 버튼(FAB, Floating Action Button)은 콘텐츠 영역의 오른쪽 하단에 떠 있는 둥근 버튼입니다. 
이 버튼은 해당 콘텐츠의 기본 동작을 나타내지만, 기본 동작이 없는 경우도 있습니다. 
대신, 사용자가 취할 수 있는 몇 가지 중요한 동작이 있습니다. 
이 경우, 다음 그림과 같이 확장 가능한 FAB를 만들 수 있습니다. 
이 확장 가능한 FAB를 누르면, 여러 개의 다른 동작 버튼이 생성됩니다. 각 버튼은 이러한 중요한 동작 중 하나에 해당합니다.

다음 애니메이션은 앱의 동작을 보여줍니다.

![Expanding and collapsing the FAB](/assets/images/docs/cookbook/effects/ExpandingFAB.gif){:.site-mobile-screenshot}

## ExpandableFab 위젯 만들기 {:#create-an-expandablefab-widget}

`ExpandableFab`라는 새로운 stateful 위젯을 만드는 것으로 시작합니다. 
이 위젯은 기본 FAB를 표시하고, 다른 작업 버튼의 확장 및 축소를 조정합니다. 
위젯은 `ExpandedFab`가 확장된 위치에서 시작하는지 여부, 각 작업 버튼의 최대 거리 및 자식 목록에 대한 매개변수를 사용합니다. 
나중에 목록을 사용하여 다른 작업 버튼을 제공합니다.

<?code-excerpt "lib/excerpt1.dart (ExpandableFab)"?>
```dart
@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
```

## FAB 크로스 페이드 {:#fab-cross-fade}

`ExpandableFab`은 축소 시 파란색 편집 버튼을 표시하고, 확장 시 흰색 닫기 버튼을 표시합니다. 
확장 및 축소 시, 이 두 버튼은 서로 크기가 조정되고 페이드됩니다.

두 개의 다른 FAB 간에 확장 및 축소 크로스 페이드를 구현합니다. 

<?code-excerpt "lib/excerpt2.dart (ExpandableFabState)"?>
```dart
class _ExpandableFabState extends State<ExpandableFab> {
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
  }

  void _toggle() {
    setState(() {
      _open = !_open;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}
```

열기 버튼은 `Stack` 내의 닫기 버튼 위에 위치하여, 맨 위 버튼이 나타나고 사라질 때 크로스 페이드의 시각적 모양을 허용합니다.

크로스 페이드 애니메이션을 구현하기 위해, 
열기 버튼은 스케일 변환과 `AnimatedOpacity`를 사용하는 `AnimatedContainer`를 사용합니다. 
`ExpandableFab`가 축소에서 확장으로 전환될 때, 열기 버튼은 축소되고 페이드 아웃됩니다. 
그런 다음, `ExpandableFab`가 확장에서 축소로 전환될 때, 열기 버튼은 확대되고 페이드 인됩니다.

열기 버튼이 `IgnorePointer` 위젯으로 래핑되어 있는 것을 알 수 있습니다. 
이는 열기 버튼이 투명할 때에도, 항상 존재하기 때문입니다. 
`IgnorePointer`가 없으면, 닫기 버튼이 표시될 때에도, 열기 버튼은 항상 탭 이벤트를 받습니다.

## ActionButton 위젯 만들기 {:#create-an-actionbutton-widget}

`ExpandableFab`에서 확장되는 각 버튼은 동일한 디자인을 가지고 있습니다. 
흰색 아이콘이 있는 파란색 원입니다. 
더 정확하게 말하면, 버튼 배경색은 `ColorScheme.secondary` 색상이고, 아이콘 색상은 `ColorScheme.onSecondary`입니다.

이러한 둥근 버튼을 표시하기 위해 `ActionButton`이라는 새 stateless 위젯을 정의합니다.

<?code-excerpt "lib/main.dart (ActionButton)"?>
```dart
@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}
```

이 새로운 `ActionButton` 위젯의 몇 개 인스턴스를 `ExpandableFab`에 전달합니다.

<?code-excerpt "lib/main.dart (FloatingActionButton)"?>
```dart
floatingActionButton: ExpandableFab(
  distance: 112,
  children: [
    ActionButton(
      onPressed: () => _showAction(context, 0),
      icon: const Icon(Icons.format_size),
    ),
    ActionButton(
      onPressed: () => _showAction(context, 1),
      icon: const Icon(Icons.insert_photo),
    ),
    ActionButton(
      onPressed: () => _showAction(context, 2),
      icon: const Icon(Icons.videocam),
    ),
  ],
),
```

## 작업 버튼들을 확장 및 축소 {:#expand-and-collapse-the-action-buttons}

자식 `ActionButton`은 확장 시 열린 FAB 아래에서 날아가야 합니다. 
그런 다음, 자식 `ActionButton`은 축소 시 열린 FAB 아래로 다시 날아가야 합니다. 
이 동작에는 각 `ActionButton`의 명시적 (x,y) 위치 지정과 
시간이 지남에 따라 해당 (x,y) 위치에 대한 변경을 안무(choreograph)하는 `Animation`이 필요합니다.

다양한 `ActionButton`이 확장되고 축소되는 속도를 제어하는 ​​`AnimationController`와 `Animation`을 도입합니다.

<?code-excerpt "lib/excerpt3.dart (ExpandableFabState3)" replace="/\/\/ code-excerpt-closing-bracket/}/g"?>
```dart
class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }
}
```

다음으로, `_ExpandingActionButton`이라는 새로운 stateless 위젯을 도입하고, 
이 위젯을 구성하여 개별 `ActionButton`을 애니메이션화하고 배치합니다. 
`ActionButton`은 `child`라는 제네릭 `Widget`으로 제공됩니다.

<?code-excerpt "lib/excerpt3.dart (ExpandingActionButton)"?>
```dart
@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
```

`_ExpandingActionButton`의 가장 중요한 부분은 `Positioned` 위젯으로, 
주변 `Stack` 내의 특정 (x,y) 좌표에 `child`를 배치합니다. 
`AnimatedBuilder`는 애니메이션이 변경될 때마다 `Positioned` 위젯을 다시 빌드합니다. 
`FadeTransition` 위젯은 각각 확장 및 축소될 때 각 `ActionButton`의 표시 및 사라짐을 조정합니다.

:::note
`_ExpandingActionButton` 내에서 `Positioned` 위젯을 사용하면,
`_ExpandingActionButton`은 `Stack`의 직접적인 자식으로만 사용할 수 있습니다. 
이는 `Positioned`와 `Stack` 간의 명시적 관계 때문입니다.
:::

마지막으로, `ExpandableFab` 내의 새로운 `_ExpandingActionButton` 위젯을 사용하여 연습을 완료합니다.

<?code-excerpt "lib/excerpt4.dart (ExpandableFabState4)" replace="/\/\/ code-excerpt-closing-bracket/}/g"?>
```dart
class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }
}
```

축하합니다! 이제 확장 가능한 FAB가 생겼습니다.

## 대화형 예제 {:#interactive-example}

앱 실행:

* 오른쪽 하단 모서리에 있는 편집 아이콘으로 표시된 FAB를 클릭합니다. 
  3개의 버튼으로 펼쳐지고, 닫기 버튼으로 대체되며 **X**로 표시됩니다.
* 닫기 버튼을 클릭하면 확장된 버튼이 원래 FAB로 돌아가고, **X**가 편집 아이콘으로 대체됩니다.
* FAB를 다시 확장하고, 3개의 위성 버튼 중 하나를 클릭하면, 해당 버튼의 동작을 나타내는 대화 상자가 표시됩니다.


<!-- start dartpad -->

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter expandable floating action button hands-on example in DartPad" run="true"
import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleExpandableFab(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

@immutable
class ExampleExpandableFab extends StatelessWidget {
  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];

  const ExampleExpandableFab({super.key});

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expandable Fab'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 25,
        itemBuilder: (context, index) {
          return FakeItem(isBig: index.isOdd);
        },
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(Icons.format_size),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 2),
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
    );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    super.key,
    required this.isBig,
  });

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      height: isBig ? 128 : 36,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
```
