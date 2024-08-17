---
# title: Create a staggered menu animation
title: 단계적(staggered) 메뉴 애니메이션 만들기
# description: How to implement a staggered menu animation.
description: 단계적 메뉴 애니메이션을 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/effects/staggered_menu_animation"?>

단일 앱 화면에는 여러 애니메이션이 포함될 수 있습니다. 
모든 애니메이션을 동시에 재생하는 것은 압도적일 수 있습니다. 
애니메이션을 하나씩 재생하면 너무 오래 걸릴 수 있습니다. 
더 나은 옵션은 애니메이션을 단계적으로 재생하는 것입니다. 
각 애니메이션은 다른 시간에 시작하지만, 애니메이션이 겹쳐져 더 짧은 지속 시간을 만듭니다. 
이 레시피에서는, 애니메이션 콘텐츠가 단계적으로 표시되고 하단에 팝업되는 버튼이 있는 drawer 메뉴를 빌드합니다.

다음 애니메이션은 앱의 동작을 보여줍니다.

![Staggered Menu Animation Example](/assets/images/docs/cookbook/effects/StaggeredMenuAnimation.gif){:.site-mobile-screenshot}

## 애니메이션 없이 메뉴 만들기 {:#create-the-menu-without-animations}

drawer 메뉴는 제목 리스트를 표시한 다음, 메뉴 하단에 Get started 버튼이 표시됩니다.

`Menu`라는 stateful 위젯을 정의하여, static 위치에 리스트와 버튼을 표시합니다.

<?code-excerpt "lib/step1.dart (step1)"?>
```dart
class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  static const _menuTitles = [
    'Declarative Style',
    'Premade Widgets',
    'Stateful Hot Reload',
    'Native Performance',
    'Great Community',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildFlutterLogo(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildFlutterLogo() {
    // TODO: 이것은 나중에 구현하겠습니다.
    return Container();
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(),
        const Spacer(),
        _buildGetStartedButton(),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuTitles.length; ++i) {
      listItems.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          child: Text(
            _menuTitles[i],
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return listItems;
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
          ),
          onPressed: () {},
          child: const Text(
            'Get Started',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}
```

## 애니메이션 준비 {:#prepare-for-animations}

애니메이션 타이밍을 제어하려면, `AnimationController`가 필요합니다.

`SingleTickerProviderStateMixin`을 `MenuState` 클래스에 추가합니다. 
그런 다음, `AnimationController`를 선언하고 인스턴스화합니다.

<?code-excerpt "lib/step2.dart (animation-controller)" plaster="none"?>
```dart
class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late AnimationController _staggeredController;

  @override
  void initState() {
    super.initState();

    _staggeredController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }
}
```

각 애니메이션 전 지연 시간은 당신에게 달려 있습니다. 애니메이션 지연, 개별 애니메이션 기간, 그리고 총 애니메이션 기간을 정의하세요.

<?code-excerpt "lib/animation_delays.dart (delays)" plaster="none"?>
```dart
class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 500);
  final _animationDuration = _initialDelayTime +
      (_staggerTime * _menuTitles.length) +
      _buttonDelayTime +
      _buttonTime;
}
```

이 경우, 모든 애니메이션은 50ms 지연됩니다. 그 후, 리스트 아이템이 나타나기 시작합니다. 
각 리스트 아이템의 출현은 이전 리스트 아이템이 슬라이드 인되기 시작한 후 50ms 지연됩니다. 
각 리스트 아이템은 오른쪽에서 왼쪽으로 슬라이드하는 데 250ms가 걸립니다. 
마지막 리스트 아이템이 슬라이드 인되기 시작한 후, 맨 아래의 버튼은 튀어나오기까지 150ms 더 기다립니다. 
버튼 애니메이션은 500ms가 걸립니다. (50+250+150=500)

각 지연 및 애니메이션 지속 시간을 정의하면, 총 지속 시간이 계산되어 개별 애니메이션 시간을 계산하는 데 사용할 수 있습니다.

원하는 애니메이션 시간은 다음 다이어그램에 나와 있습니다.

![Animation Timing Diagram](/assets/images/docs/cookbook/effects/TimingDiagram.png){:.site-mobile-screenshot}

더 큰 애니메이션의 하위 섹션 동안 값을 애니메이션화하기 위해, Flutter는 `Interval` 클래스를 제공합니다. 
`Interval`은 시작 시간 백분율과 종료 시간 백분율을 사용합니다. 
그런 다음, 해당 `Interval`을 사용하여 전체 애니메이션의 시작 및 종료 시간을 사용하는 대신 
시작 및 종료 시간 사이의 값을 애니메이션화할 수 있습니다. 
예를 들어, 1초가 걸리는 애니메이션의 경우, 0.2에서 0.5까지의 간격은 200ms(20%)에서 시작하여 500ms(50%)에서 끝납니다.

각 리스트 아이템의 `Interval`과 하단 버튼 `Interval`을 선언하고 계산합니다.

<?code-excerpt "lib/step3.dart (step3)" plaster="none"?>
```dart
class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  final List<Interval> _itemSlideIntervals = [];
  late Interval _buttonInterval;

  @override
  void initState() {
    super.initState();

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < _menuTitles.length; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }

    final buttonStartTime =
        Duration(milliseconds: (_menuTitles.length * 50)) + _buttonDelayTime;
    final buttonEndTime = buttonStartTime + _buttonTime;
    _buttonInterval = Interval(
      buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
      buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
    );
  }
}
```

## 리스트 아이템과 버튼에 애니메이션 적용 {:#animate-the-list-items-and-button}

메뉴가 표시되자마자 계단형(staggered) 애니메이션이 재생됩니다.

`initState()`에서 애니메이션을 시작합니다.

<?code-excerpt "lib/step4.dart (init-state)"?>
```dart
@override
void initState() {
  super.initState();

  _createAnimationIntervals();

  _staggeredController = AnimationController(
    vsync: this,
    duration: _animationDuration,
  )..forward();
}
```
각 리스트 아이템은 오른쪽에서 왼쪽으로 슬라이드하고, 동시에 페이드 인합니다.

리스트 아이템의 `Interval`과 `easeOut` 곡선을 사용하여, 각 리스트 아이템의 불투명도와 변환 값을 애니메이션화합니다.

<?code-excerpt "lib/step4.dart (build-list-items)"?>
```dart
List<Widget> _buildListItems() {
  final listItems = <Widget>[];
  for (var i = 0; i < _menuTitles.length; ++i) {
    listItems.add(
      AnimatedBuilder(
        animation: _staggeredController,
        builder: (context, child) {
          final animationPercent = Curves.easeOut.transform(
            _itemSlideIntervals[i].transform(_staggeredController.value),
          );
          final opacity = animationPercent;
          final slideDistance = (1.0 - animationPercent) * 150;

          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(slideDistance, 0),
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          child: Text(
            _menuTitles[i],
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
  return listItems;
}
```

같은 접근 방식을 사용하여 하단 버튼의 불투명도와 크기를 애니메이션화합니다. 
이번에는, `elasticOut` 곡선을 사용하여 버튼에 탄력 있는 효과를 줍니다.

<?code-excerpt "lib/step4.dart (build-get-started)"?>
```dart
Widget _buildGetStartedButton() {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: AnimatedBuilder(
        animation: _staggeredController,
        builder: (context, child) {
          final animationPercent = Curves.elasticOut.transform(
              _buttonInterval.transform(_staggeredController.value));
          final opacity = animationPercent.clamp(0.0, 1.0);
          final scale = (animationPercent * 0.5) + 0.5;

          return Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          );
        },
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
          ),
          onPressed: () {},
          child: const Text(
            'Get Started',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
    ),
  );
}
```

축하합니다!
각 리스트 아이템의 모양이 단계적(staggered)으로 배열되고, 
그 뒤에 하단 버튼이 제자리로 튀어나오는 애니메이션 메뉴가 있습니다.

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter staggered menu animation hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleStaggeredAnimations(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class ExampleStaggeredAnimations extends StatefulWidget {
  const ExampleStaggeredAnimations({
    super.key,
  });

  @override
  State<ExampleStaggeredAnimations> createState() =>
      _ExampleStaggeredAnimationsState();
}

class _ExampleStaggeredAnimationsState extends State<ExampleStaggeredAnimations>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildContent(),
          _buildDrawer(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Flutter Menu',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: [
        AnimatedBuilder(
          animation: _drawerSlideController,
          builder: (context, child) {
            return IconButton(
              onPressed: _toggleDrawer,
              icon: _isDrawerOpen() || _isDrawerOpening()
                  ? const Icon(
                      Icons.clear,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    // 여기에 페이지 내용을 넣으세요.
    return const SizedBox();
  }

  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerSlideController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(1.0 - _drawerSlideController.value, 0.0),
          child: _isDrawerClosed() ? const SizedBox() : const Menu(),
        );
      },
    );
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  static const _menuTitles = [
    'Declarative style',
    'Premade widgets',
    'Stateful hot reload',
    'Native performance',
    'Great community',
  ];

  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 500);
  final _animationDuration = _initialDelayTime +
      (_staggerTime * _menuTitles.length) +
      _buttonDelayTime +
      _buttonTime;

  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];
  late Interval _buttonInterval;

  @override
  void initState() {
    super.initState();

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < _menuTitles.length; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }

    final buttonStartTime =
        Duration(milliseconds: (_menuTitles.length * 50)) + _buttonDelayTime;
    final buttonEndTime = buttonStartTime + _buttonTime;
    _buttonInterval = Interval(
      buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
      buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
    );
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildFlutterLogo(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildFlutterLogo() {
    return const Positioned(
      right: -100,
      bottom: -30,
      child: Opacity(
        opacity: 0.2,
        child: FlutterLogo(
          size: 400,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(),
        const Spacer(),
        _buildGetStartedButton(),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuTitles.length; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(_staggeredController.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            child: Text(
              _menuTitles[i],
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }
    return listItems;
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.elasticOut.transform(
                _buttonInterval.transform(_staggeredController.value));
            final opacity = animationPercent.clamp(0.0, 1.0);
            final scale = (animationPercent * 0.5) + 0.5;

            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            );
          },
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
            ),
            onPressed: () {},
            child: const Text(
              'Get started',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```
