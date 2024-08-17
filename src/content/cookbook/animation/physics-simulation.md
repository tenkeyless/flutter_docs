---
# title: Animate a widget using a physics simulation
title: 물리 시뮬레이션을 사용하여 위젯 애니메이션 하기
# description: How to implement a physics animation.
description: 물리 애니메이션을 구현하는 방법.
diff2html: true
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/animation/physics_simulation/"?>

물리 시뮬레이션을 통해 앱 상호작용이 현실적이고 상호 작용으로 느껴지도록 할 수 있습니다. 
예를 들어, 위젯을 스프링에 부착된 것처럼 또는 중력에 의해 떨어지는 것처럼 
애니메이션화하고 싶을 수 있습니다.

이 레시피는 스프링 시뮬레이션을 사용하여 위젯을 드래그한 지점에서 
중앙으로 다시 이동하는 방법을 보여줍니다.

이 레시피는 다음 단계를 사용합니다.

1. 애니메이션 컨트롤러 설정
2. 제스처를 사용하여 위젯 이동
3. 위젯 애니메이션화
4. 스프링 동작을 시뮬레이션하기 위해 속도 계산


## 1단계: 애니메이션 컨트롤러 설정 {:#step-1-set-up-an-animation-controller}

`DraggableCard`라는 stateful 위젯으로 시작합니다.

<?code-excerpt "lib/starter.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: PhysicsCardDragDemo()));
}

class PhysicsCardDragDemo extends StatelessWidget {
  const PhysicsCardDragDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const DraggableCard(
        child: FlutterLogo(
          size: 128,
        ),
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  const DraggableCard({required this.child, super.key});

  final Widget child;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Card(
        child: widget.child,
      ),
    );
  }
}
```

`_DraggableCardState` 클래스를 [SingleTickerProviderStateMixin][]에서 확장합니다. 
그런 다음, `initState`에서 [AnimationController][]를 구성하고, `vsync`를 `this`로 설정합니다.

:::note
`SingleTickerProviderStateMixin`을 확장하면, 
상태 객체가 `AnimationController`의 `TickerProvider`가 될 수 있습니다. 
자세한 내용은, [TickerProvider][]에 대한 문서를 참조하세요.
:::

```diff2html
--- lib/starter.dart
+++ lib/step1.dart
@@ -29,14 +29,20 @@
   State<DraggableCard> createState() => _DraggableCardState();
 }

-class _DraggableCardState extends State<DraggableCard> {
+class _DraggableCardState extends State<DraggableCard>
+    with SingleTickerProviderStateMixin {
+  late AnimationController _controller;
+
   @override
   void initState() {
     super.initState();
+    _controller =
+        AnimationController(vsync: this, duration: const Duration(seconds: 1));
   }

   @override
   void dispose() {
+    _controller.dispose();
     super.dispose();
   }
```

## 2단계: 제스처를 사용하여 위젯 이동 {:#step-2-move-the-widget-using-gestures}

위젯을 드래그할 때 움직이게 하고, 
`_DraggableCardState` 클래스에 [Alignment][] 필드를 추가합니다.

```diff2html
--- lib/step1.dart (alignment)
+++ lib/step2.dart (alignment)
@@ -1,3 +1,4 @@
 class _DraggableCardState extends State<DraggableCard>
     with SingleTickerProviderStateMixin {
   late AnimationController _controller;
+  Alignment _dragAlignment = Alignment.center;
```

`onPanDown`, `onPanUpdate`, `onPanEnd` 콜백을 처리하는 [GestureDetector][]를 추가합니다. 
정렬을 조정하려면, [MediaQuery][]를 사용하여 위젯의 크기를 구하고, 2로 나눕니다. 
(이렇게 하면 "드래그된 픽셀" 단위가 [Align][]에서 사용하는 좌표로 변환됩니다.) 
그런 다음, `Align` 위젯의 `alignment`를 `_dragAlignment`로 설정합니다.

```diff2html
--- lib/step1.dart (build)
+++ lib/step2.dart (build)
@@ -1,8 +1,22 @@
 @override
 Widget build(BuildContext context) {
-  return Align(
-    child: Card(
-      child: widget.child,
+  var size = MediaQuery.of(context).size;
+  return GestureDetector(
+    onPanDown: (details) {},
+    onPanUpdate: (details) {
+      setState(() {
+        _dragAlignment += Alignment(
+          details.delta.dx / (size.width / 2),
+          details.delta.dy / (size.height / 2),
+        );
+      });
+    },
+    onPanEnd: (details) {},
+    child: Align(
+      alignment: _dragAlignment,
+      child: Card(
+        child: widget.child,
+      ),
     ),
   );
 }
```

## 3단계: 위젯 애니메이션 하기 {:#step-3-animate-the-widget}

위젯을 놓으면, 중앙으로 다시 튀어올라야 합니다.

`Animation<Alignment>` 필드와 `_runAnimation` 메서드를 추가합니다. 
이 메서드는 위젯이 드래그된 지점과 중앙의 지점 사이를 보간하는 `Tween`을 정의합니다.

```diff2html
--- lib/step2.dart (animation)
+++ lib/step3.dart (animation)
@@ -1,4 +1,5 @@
 class _DraggableCardState extends State<DraggableCard>
     with SingleTickerProviderStateMixin {
   late AnimationController _controller;
+  late Animation<Alignment> _animation;
   Alignment _dragAlignment = Alignment.center;
```

<?code-excerpt "lib/step3.dart (runAnimation)"?>
```dart
void _runAnimation() {
  _animation = _controller.drive(
    AlignmentTween(
      begin: _dragAlignment,
      end: Alignment.center,
    ),
  );
  _controller.reset();
  _controller.forward();
}
```

다음으로, `AnimationController`가 값을 생성하면 `_dragAlignment`를 업데이트합니다.

```diff2html
--- lib/step2.dart (init-state)
+++ lib/step3.dart (init-state)
@@ -3,4 +3,9 @@
   super.initState();
   _controller =
       AnimationController(vsync: this, duration: const Duration(seconds: 1));
+  _controller.addListener(() {
+    setState(() {
+      _dragAlignment = _animation.value;
+    });
+  });
 }
```

다음으로, `Align` 위젯이 `_dragAlignment` 필드를 사용하도록 합니다.

<?code-excerpt "lib/step3.dart (align)"?>
```dart
child: Align(
  alignment: _dragAlignment,
  child: Card(
    child: widget.child,
  ),
),
```

마지막으로, 애니메이션 컨트롤러를 관리하기 위해 `GestureDetector`를 업데이트합니다.

```diff2html
--- lib/step2.dart (gesture)
+++ lib/step3.dart (gesture)
@@ -1,5 +1,7 @@
 return GestureDetector(
-  onPanDown: (details) {},
+  onPanDown: (details) {
+    _controller.stop();
+  },
   onPanUpdate: (details) {
     setState(() {
       _dragAlignment += Alignment(
@@ -8,7 +10,9 @@
       );
     });
   },
-  onPanEnd: (details) {},
+  onPanEnd: (details) {
+    _runAnimation();
+  },
   child: Align(
     alignment: _dragAlignment,
     child: Card(
```

## 4단계: 스프링 동작을 시뮬레이션하기 위한 속도 계산 {:#step-4-calculate-the-velocity-to-simulate-a-springing-motion}

마지막 단계는 약간의 수학을 하는 것입니다. 위젯이 드래그를 마친 후의 속도를 계산하는 것입니다. 
이렇게 하면 위젯이 다시 스냅되기 전(being snapped back)에 실제로 그 속도로 계속 진행될 수 있습니다.
(`_runAnimation` 메서드는 이미 애니메이션의 시작 및 종료 정렬을 설정하여 방향을 설정합니다.)

먼저 `physics` 패키지를 가져옵니다.

<?code-excerpt "lib/main.dart (import)"?>
```dart
import 'package:flutter/physics.dart';
```

`onPanEnd` 콜백은 [DragEndDetails][] 객체를 제공합니다. 
이 객체는 포인터가 화면과 접촉하는 것을 멈췄을 때의 포인터 속도를 제공합니다. 
속도는 초당 픽셀 단위이지만, `Align` 위젯은 픽셀을 사용하지 않습니다. 
[-1.0, -1.0]과 [1.0, 1.0] 사이의 좌표 값을 사용하는데, 여기서 [0.0, 0.0]은 중심을 나타냅니다. 
2단계에서 계산된 `size`는 픽셀을 이 범위의 좌표 값으로 변환하는 데 사용됩니다.

마지막으로, `AnimationController`에는 [SpringSimulation][]을 지정할 수 있는 
`animateWith()` 메서드가 있습니다.

<?code-excerpt "lib/main.dart (runAnimation)"?>
```dart
/// [SpringSimulation]을 계산하고 실행합니다.
void _runAnimation(Offset pixelsPerSecond, Size size) {
  _animation = _controller.drive(
    AlignmentTween(
      begin: _dragAlignment,
      end: Alignment.center,
    ),
  );
  // 애니메이션 컨트롤러에서 사용하는 단위 간격 [0,1]을 기준으로 속도를 계산합니다.
  final unitsPerSecondX = pixelsPerSecond.dx / size.width;
  final unitsPerSecondY = pixelsPerSecond.dy / size.height;
  final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
  final unitVelocity = unitsPerSecond.distance;

  const spring = SpringDescription(
    mass: 30,
    stiffness: 1,
    damping: 1,
  );

  final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

  _controller.animateWith(simulation);
}
```

속도와 크기로 `_runAnimation()`을 호출하는 것을 잊지 마세요.

<?code-excerpt "lib/main.dart (onPanEnd)"?>
```dart
onPanEnd: (details) {
  _runAnimation(details.velocity.pixelsPerSecond, size);
},
```

:::note
이제 애니메이션 컨트롤러가 시뮬레이션을 사용하므로, `duration` 인수는 더 이상 필요하지 않습니다.
:::

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter physics simulation hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(const MaterialApp(home: PhysicsCardDragDemo()));
}

class PhysicsCardDragDemo extends StatelessWidget {
  const PhysicsCardDragDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const DraggableCard(
        child: FlutterLogo(
          size: 128,
        ),
      ),
    );
  }
}

/// 놓였을 때, [Alignment.center]로 다시 이동하는 드래그 가능한 카드입니다.
class DraggableCard extends StatefulWidget {
  const DraggableCard({required this.child, super.key});

  final Widget child;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// 카드를 드래그하거나, 애니메이션화할 때의 카드 정렬.
  ///
  /// 카드가 드래그되는 동안, 이 값은 GestureDetector onPanUpdate 콜백에서 계산된 값으로 설정됩니다. 
  /// 애니메이션이 실행 중인 경우, 이 값은 [_animation]의 값으로 설정됩니다.
  Alignment _dragAlignment = Alignment.center;

  late Animation<Alignment> _animation;

  /// [SpringSimulation]을 계산하고 실행합니다.
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    // 애니메이션 컨트롤러에서 사용하는 단위 간격 [0,1]을 기준으로 속도를 계산합니다.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details) {
        _controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/animation-physics-card-drag.gif" alt="Demo showing a widget being dragged and snapped back to the center" class="site-mobile-screenshot" />
</noscript>

[Align]: {{site.api}}/flutter/widgets/Align-class.html
[Alignment]: {{site.api}}/flutter/painting/Alignment-class.html
[AnimationController]: {{site.api}}/flutter/animation/AnimationController-class.html
[GestureDetector]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[SingleTickerProviderStateMixin]: {{site.api}}/flutter/widgets/SingleTickerProviderStateMixin-mixin.html
[TickerProvider]: {{site.api}}/flutter/scheduler/TickerProvider-class.html
[MediaQuery]: {{site.api}}/flutter/widgets/MediaQuery-class.html
[DragEndDetails]: {{site.api}}/flutter/gestures/DragEndDetails-class.html
[SpringSimulation]: {{site.api}}/flutter/physics/SpringSimulation-class.html
