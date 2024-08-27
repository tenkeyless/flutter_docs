---
# title: Animations tutorial
title: 애니메이션 튜토리얼
# short-title: Tutorial
short-title: 튜토리얼
# description: A tutorial showing how to build explicit animations in Flutter.
description: Flutter에서 명시적 애니메이션을 만드는 방법을 보여주는 튜토리얼입니다.
diff2html: true
---

{% assign api = site.api | append: '/flutter' -%}
{% capture examples -%} {{site.repo.this}}/tree/{{site.branch}}/examples {%- endcapture -%}

<?code-excerpt path-base="animation"?>

:::secondary 배울 내용
* 애니메이션 라이브러리의 기본 클래스를 사용하여 위젯에 애니메이션을 추가하는 방법.
* `AnimatedWidget`과 `AnimatedBuilder`를 사용하는 경우.
:::

이 튜토리얼은 Flutter에서 명시적 애니메이션을 빌드하는 방법을 보여줍니다. 
애니메이션 라이브러리의 필수 개념, 클래스, 메서드 중 일부를 소개한 후, 5가지 애니메이션 예제를 안내합니다. 
이 예제는 서로를 기반으로 하여, 애니메이션 라이브러리의 다양한 측면을 소개합니다.

Flutter SDK는 또한 [`FadeTransition`][], [`SizeTransition`][], [`SlideTransition`][]과 같은 빌트인 명시적 애니메이션을 제공합니다. 
이러한 간단한 애니메이션은 시작점과 끝점을 설정하여 트리거됩니다. 
여기에서 설명하는 커스텀 명시적 애니메이션보다 구현하기가 더 간단합니다.

<a id="concepts"></a>
## 필수 애니메이션 개념 및 클래스 {:#essential-animation-concepts-and-classes}

:::secondary 요점은 무엇인가요?
* Flutter 애니메이션 라이브러리의 코어 클래스인 [`Animation`][]은 애니메이션을 안내하는 데 사용되는 값을 보간합니다.
* `Animation` 객체는 애니메이션의 현재 상태(예: 시작, 중지 또는 앞으로 또는 뒤로 이동하는지)를 알고 있지만, 
  화면에 나타나는 내용에 대해서는 아무것도 모릅니다.
* [`AnimationController`][]는 `Animation`을 관리합니다.
* [`CurvedAnimation`][]은 진행을 비선형 곡선(non-linear curve)으로 정의합니다.
* [`Tween`][]은 애니메이션을 적용하는 객체에서 사용하는 데이터 범위 사이를 보간합니다. 
  예를 들어, `Tween`은 빨간색에서 파란색으로 또는 0에서 255로 보간을 정의할 수 있습니다.
* `Listener`와 `StatusListener`를 사용하여 애니메이션 상태 변경을 모니터링합니다.
:::

Flutter의 애니메이션 시스템은 타입이 지정된 [`Animation`][] 객체를 기반으로 합니다. 
위젯은 현재 값을 읽고 상태 변경을 수신하여 이러한 애니메이션을 빌드 함수에 직접 통합하거나, 
애니메이션을 다른 위젯에 전달하는 보다 정교한 애니메이션의 기반으로 사용할 수 있습니다.

<a id="animation-class"></a>
### Animation<wbr>\<double> {:#animationdouble}

Flutter에서, `Animation` 객체는 화면에 있는 것에 대해 아무것도 모릅니다. 
`Animation`은 현재 값과 상태(완료(completed) 또는 해제(dismissed))를 이해하는 추상 클래스입니다. 
가장 일반적으로 사용되는 애니메이션 타입 중 하나는 `Animation<double>`입니다.

`Animation` 객체는 특정 기간(duration) 동안 두 값 사이에 보간된 숫자를 순차적으로 생성합니다. 
`Animation` 객체의 출력은 선형, 곡선, 계단 함수 또는 고안할 수 있는 다른 매핑일 수 있습니다. 
`Animation` 객체가 제어되는 방식에 따라, 역순으로 실행되거나, 중간에 방향을 바꿀 수도 있습니다.

애니메이션은 (`Animation<Color>` 또는 `Animation<Size>`와 같이) double 이외의 타입을 보간할 수도 있습니다.

`Animation` 객체에는 상태가 있습니다. 현재 값은 항상 `.value` 멤버에서 사용할 수 있습니다.

`Animation` 객체는 렌더링이나 `build()` 함수에 대해 아무것도 모릅니다.

### Curved&shy;Animation {:#curvedanimation}

[`CurvedAnimation`][]은 애니메이션의 진행을 비선형 곡선으로 정의합니다.

<?code-excerpt "animate5/lib/main.dart (CurvedAnimation)"?>
```dart
animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
```

:::note
[`Curves`][] 클래스는 일반적으로 사용되는 많은 곡선을 정의하거나, 직접 만들 수 있습니다. 예를 들어:

<?code-excerpt "animate5/lib/main.dart (ShakeCurve)" plaster="none"?>
```dart
import 'dart:math';

class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * pi * 2);
}
```

Flutter와 함께 제공되는 `Curves` 상수의 전체 리스트(시각적 미리보기 포함)는 [`Curves`] 문서를 탐색해 보세요.
:::

`CurvedAnimation`과 `AnimationController`(다음 섹션에서 설명)는 모두 `Animation<double>` 타입이므로, 
서로 바꿔서 전달할 수 있습니다. 
`CurvedAnimation`은 수정하는 객체를 래핑합니다. 
곡선을 구현하기 위해 `AnimationController`를 하위 클래스화하지 않습니다.

### Animation&shy;Controller {:#animationcontroller}

[`AnimationController`][]는 하드웨어가 새 프레임을 준비할 때마다 새 값을 생성하는 특수한 `Animation` 객체입니다. 
기본적으로, `AnimationController`는 주어진 기간 동안 0.0에서 1.0까지의 숫자를 선형적으로 생성합니다. 
예를 들어, 이 코드는 `Animation` 객체를 생성하지만, 실행을 시작하지 않습니다.

<?code-excerpt "animate5/lib/main.dart (animation-controller)"?>
```dart
controller =
    AnimationController(duration: const Duration(seconds: 2), vsync: this);
```

`AnimationController`는 `Animation<double>`에서 파생되므로, 
`Animation` 객체가 필요한 곳이면 어디든 사용할 수 있습니다. 
그러나, `AnimationController`에는 애니메이션을 제어하는 ​​추가 메서드가 있습니다. 
예를 들어, `.forward()` 메서드로 애니메이션을 시작합니다. 
숫자 생성은 화면 새로 고침과 연결되어 있으므로, 일반적으로 초당 60개의 숫자가 생성됩니다. 
각 숫자가 생성된 후, 각 `Animation` 객체는 연결된 `Listener` 객체를 호출합니다. 
각 자식에 대한 커스텀 표시 리스트를 만들려면, [`RepaintBoundary`][]를 참조하세요.

`AnimationController`를 만들 때 `vsync` 인수를 전달합니다. 
`vsync`가 있으면 오프스크린 애니메이션이 불필요한 리소스를 소모하지 않습니다. 
클래스 정의에 `SingleTickerProviderStateMixin`을 추가하여, 상태 객체를 vsync로 사용할 수 있습니다. 
GitHub의 [animate1][]에서 이에 대한 예를 볼 수 있습니다.

{% comment %}
`vsync` 객체는 애니메이션 컨트롤러의 똑딱거림(ticking)을 위젯의 가시성과 연결합니다. 
즉, 애니메이션 위젯이 화면에서 사라지면 똑딱거림이 멈추고, 위젯이 복구되면 다시 시작됩니다.
(시계는 멈추지 않으므로 마치 CPU를 사용하지 않고도 항상 똑딱거리고 있었던 것처럼 보입니다) 
커스텀 State 객체를 `vsync`로 사용하려면, 커스텀 State 클래스를 정의할 때 `TickerProviderStateMixin`을 포함시킵니다.
{% endcomment -%}

:::note
어떤 경우에는, 위치가 `AnimationController`의 0.0-1.0 범위를 초과할 수 있습니다. 
예를 들어, `fling()` 함수를 사용하면 속도, 힘, 위치(Force 객체를 통해)를 제공할 수 있습니다. 
위치는 무엇이든 될 수 있으므로 0.0~1.0 범위를 벗어날 수 있습니다.

`CurvedAnimation`은, `AnimationController`가 초과하지 않더라도, 0.0~1.0 범위를 초과할 수도 있습니다. 
선택한 곡선에 따라, `CurvedAnimation`의 출력 범위가 입력 범위보다 더 넓을 수 있습니다. 
예를 들어, `Curves.elasticIn`과 같은 탄성 곡선은 기본 범위를 상당히 초과하거나 미달합니다.
:::

### Tween {:#tween}

기본적으로, `AnimationController` 객체는 0.0에서 1.0까지입니다. 
다른 범위나 다른 데이터 타입이 필요한 경우, [`Tween`][]을 사용하여, 
애니메이션을 다른 범위나 데이터 타입으로 보간하도록 구성할 수 있습니다. 
예를 들어, 다음 `Tween`은 -200.0에서 0.0까지입니다.

<?code-excerpt "animate5/lib/main.dart (tween)"?>
```dart
tween = Tween<double>(begin: -200, end: 0);
```

`Tween`은 `begin`과 `end`만 취하는 stateless 객체입니다. 
`Tween`의 유일한 작업은 입력 범위에서 출력 범위로의 매핑을 정의하는 것입니다. 
입력 범위는 일반적으로 0.0~1.0이지만, 꼭 그런 것은 아닙니다.

`Tween`은 `Animation<T>`가 아니라 `Animatable<T>`에서 상속받습니다. 
`Animation`과 마찬가지로 `Animatable`은 double을 출력할 필요가 없습니다. 
예를 들어, `ColorTween`은 두 색상 간의 진행을 지정합니다.

<?code-excerpt "animate5/lib/main.dart (colorTween)"?>
```dart
colorTween = ColorTween(begin: Colors.transparent, end: Colors.black54);
```

`Tween` 객체는 상태를 저장하지 않습니다. 
대신, `transform` 함수를 사용하여, 
애니메이션의 현재 값(0.0~1.0 사이)을 실제 애니메이션 값에 매핑하는 [`evaluate(Animation<double> animation)`][] 메서드를 제공합니다.

`Animation` 객체의 현재 값은 `.value` 메서드에서 찾을 수 있습니다. 
evaluate 함수는, 애니메이션 값이 각각 0.0과 1.0일 때 begin과 end가 반환되도록 하는 등, 일부 정리 작업도 수행합니다.

#### Tween.animate

`Tween` 객체를 사용하려면, `Tween`에서 `animate()`를 호출하여 컨트롤러 객체를 전달합니다. 
예를 들어, 다음 코드는 500ms 동안 0에서 255까지의 정수 값을 생성합니다.

<?code-excerpt "animate5/lib/main.dart (IntTween)"?>
```dart
AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 500), vsync: this);
Animation<int> alpha = IntTween(begin: 0, end: 255).animate(controller);
```

:::note
`animate()` 메서드는 [`Animatable`][]이 아닌 [`Animation`][]을 반환합니다.
:::

다음 예제에서는 컨트롤러, 커브 및 `Tween`을 보여줍니다.

<?code-excerpt "animate5/lib/main.dart (IntTween-curve)"?>
```dart
AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 500), vsync: this);
final Animation<double> curve =
    CurvedAnimation(parent: controller, curve: Curves.easeOut);
Animation<int> alpha = IntTween(begin: 0, end: 255).animate(curve);
```

### Animation 알림 {:#animation-notifications}

[`Animation`][] 객체는 `addListener()` 및 `addStatusListener()`로 정의된 `Listener` 및 `StatusListener`를 가질 수 있습니다. 
`Listener`는 애니메이션 값이 변경될 때마다 호출됩니다. 
`Listener`의 가장 일반적인 동작은 `setState()`를 호출하여 다시 빌드하는 것입니다. 
`StatusListener`는 `AnimationStatus`로 정의된 대로 애니메이션이 시작, 종료, 앞으로 이동 또는 뒤로 이동할 때 호출됩니다. 
다음 섹션에는 `addListener()` 메서드의 예가 있고, 
[애니메이션 진행 상황 모니터링][Monitoring the progress of the animation]에서는 `addStatusListener()`의 예를 보여줍니다.

---

## 애니메이션 예제 {:#animation-examples}

이 섹션에서는 5가지 애니메이션 예제를 안내합니다.
각 섹션은 해당 예제의 소스 코드에 대한 링크를 제공합니다.

### 애니메이션 렌더링 {:#rendering-animations}

:::secondary 요점은 무엇인가요?
* `addListener()`와 `setState()`를 사용하여 위젯에 기본 애니메이션을 추가하는 방법.
* 애니메이션이 새 숫자를 생성할 때마다, `addListener()` 함수는 `setState()`를 호출합니다.
* 필수 `vsync` 매개변수로 `AnimationController`를 정의하는 방법.
* Dart의 _cascade 표기법_ 이라고도 알려진, ``..addListener``의 "`..`" 구문을 이해합니다.
* 클래스를 private으로 만들려면, 이름을 밑줄(`_`)로 시작합니다.
:::

지금까지 시간에 따른 숫자 시퀀스를 생성하는 방법을 배웠습니다. 
화면에 아무것도 렌더링되지 않았습니다. 
`Animation` 객체로 렌더링하려면, `Animation` 객체를 위젯의 멤버로 저장한 다음, 값을 사용하여 그리는 방법을 결정합니다.

애니메이션 없이 Flutter 로고를 그리는 다음 앱을 고려하세요.

<?code-excerpt "animate0/lib/main.dart"?>
```dart
import 'package:flutter/material.dart';

void main() => runApp(const LogoApp());

class LogoApp extends StatefulWidget {
  const LogoApp({super.key});

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 300,
        width: 300,
        child: const FlutterLogo(),
      ),
    );
  }
}
```

**앱 소스:** [animate0][]

다음은 로고가 아무것도 없는 상태에서 전체 크기로 커지도록 애니메이션을 적용하기 위해 수정된 동일한 코드를 보여줍니다. 
`AnimationController`를 정의할 때, `vsync` 객체를 전달해야 합니다. 
`vsync` 매개변수는 [`AnimationController` 섹션][`AnimationController` section]에 설명되어 있습니다.

애니메이션이 없는 예제의 변경 사항은 다음과 같이 강조 표시됩니다.

```dart diff
- class _LogoAppState extends State<LogoApp> {
+ class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
+   late Animation<double> animation;
+   late AnimationController controller;
+ 
+   @override
+   void initState() {
+     super.initState();
+     controller =
+         AnimationController(duration: const Duration(seconds: 2), vsync: this);
+     animation = Tween<double>(begin: 0, end: 300).animate(controller)
+       ..addListener(() {
+         setState(() {
+           // 여기서 변경된 상태는 애니메이션 객체의 값입니다.
+         });
+       });
+     controller.forward();
+   }
+ 
    @override
    Widget build(BuildContext context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
-         height: 300,
-         width: 300,
+         height: animation.value,
+         width: animation.value,
          child: const FlutterLogo(),
        ),
      );
    }
+ 
+   @override
+   void dispose() {
+     controller.dispose();
+     super.dispose();
+   }
  }
```

**앱 소스:** [animate1][]

`addListener()` 함수는 `setState()`를 호출하므로, `Animation`이 새 숫자를 생성할 때마다, 
현재 프레임이 dirty로 표시되어 `build()`가 다시 호출됩니다. 
`build()`에서, 컨테이너는 높이와 너비가 하드코딩된 값 대신 `animation.value`를 사용하기 때문에 크기가 변경됩니다. 
메모리 누수를 방지하기 위해 `State` 객체가 삭제되면 컨트롤러를 삭제(Dispose)합니다.

이러한 몇 가지 변경 사항으로 Flutter에서 첫 번째 애니메이션을 만들었습니다!

:::tip Dart 언어 트릭
Dart의 캐스케이드 표기법인 `..addListener()`의 두 점에 익숙하지 않을 수도 있습니다. 
이 구문은 `addListener()` 메서드가 `animate()`의 반환 값으로 호출된다는 것을 의미합니다. 
다음 예를 고려하세요.

<?code-excerpt "animate1/lib/main.dart (add-listener)"?>
```dart highlightLines=2
animation = Tween<double>(begin: 0, end: 300).animate(controller)
  ..addListener(() {
    // ···
  });
```

이 코드는 다음과 동일합니다.

<?code-excerpt "animate1/lib/main.dart (add-listener)" replace="/animation.*/$&;/g; /  \./animation/g;"?>
```dart highlightLines=2
animation = Tween<double>(begin: 0, end: 300).animate(controller);
animation.addListener(() {
    // ···
  });
```

캐스케이드에 대해 자세히 알아보려면, [Dart 언어 문서][Dart language documentation]의 [캐스케이드 표기법][Cascade notation]을 확인하세요.
:::

### Animated&shy;Widget으로 단순화하기 {:#simplifying-with-animatedwidget}

:::secondary 요점은 무엇인가요?
* 애니메이션을 적용하는 위젯을 생성하기 위해 
  [`AnimatedWidget`][] 헬퍼 클래스(`addListener()` 및 `setState()` 대신)를 사용하는 방법.
* 재사용 가능한 애니메이션을 수행하는 위젯을 생성하려면 `AnimatedWidget`을 사용합니다. 
  * 위젯에서 전환을 분리하려면 [AnimatedBuilder로 리팩토링][Refactoring with AnimatedBuilder] 섹션에 표시된 대로 
    `AnimatedBuilder`를 사용합니다.
* Flutter API에서 `AnimatedWidget`의 예:
  `AnimatedBuilder`, `AnimatedModalBarrier`,
  `DecoratedBoxTransition`, `FadeTransition`,
  `PositionedTransition`, `RelativePositionedTransition`,
  `RotationTransition`, `ScaleTransition`,
  `SizeTransition`, `SlideTransition`.
:::

`AnimatedWidget` 베이스 클래스를 사용하면, 핵심 위젯 코드를 애니메이션 코드에서 분리할 수 있습니다. 
`AnimatedWidget`은 애니메이션을 보관하기 위해 `State` 객체를 유지할 필요가 없습니다. 
다음 `AnimatedLogo` 클래스를 추가합니다.

<?code-excerpt path-base="animation/animate2"?>
<?code-excerpt "lib/main.dart (AnimatedLogo)"?>
```dart
class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({super.key, required Animation<double> animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: const FlutterLogo(),
      ),
    );
  }
}
```
<?code-excerpt path-base="animation"?>

`AnimatedLogo`는 자체를 그릴 때, `animation`의 현재 값을 사용합니다.

`LogoApp`은 여전히 ​​`AnimationController`와 `Tween`을 관리하고, 
`Animation` 객체를 `AnimatedLogo`에 전달합니다.

```dart diff
  void main() => runApp(const LogoApp());

+ class AnimatedLogo extends AnimatedWidget {
+   const AnimatedLogo({super.key, required Animation<double> animation})
+       : super(listenable: animation);
+ 
+   @override
+   Widget build(BuildContext context) {
+     final animation = listenable as Animation<double>;
+     return Center(
+       child: Container(
+         margin: const EdgeInsets.symmetric(vertical: 10),
+         height: animation.value,
+         width: animation.value,
+         child: const FlutterLogo(),
+       ),
+     );
+   }
+ }
+ 
  class LogoApp extends StatefulWidget {
    // ...

    @override
    void initState() {
      super.initState();
      controller =
          AnimationController(duration: const Duration(seconds: 2), vsync: this);
-     animation = Tween<double>(begin: 0, end: 300).animate(controller)
-       ..addListener(() {
-         setState(() {
-           // The state that has changed here is the animation object's value.
-         });
-       });
+     animation = Tween<double>(begin: 0, end: 300).animate(controller);
      controller.forward();
    }

    @override
-   Widget build(BuildContext context) {
-     return Center(
-       child: Container(
-         margin: const EdgeInsets.symmetric(vertical: 10),
-         height: animation.value,
-         width: animation.value,
-         child: const FlutterLogo(),
-       ),
-     );
-   }
+   Widget build(BuildContext context) => AnimatedLogo(animation: animation);
    
    // ...
  }
```

**앱 소스:** [animate2][]

<a id="monitoring"></a>
### 애니메이션 진행 상황 모니터링 {:#monitoring-the-progress-of-the-animation}

:::secondary 요점은 무엇인가요?
* 애니메이션 상태의 변경 사항(시작, 중지 또는 방향 전환 등)에 대한 알림을 위해, `addStatusListener()`를 사용합니다.
* 애니메이션이 완료되거나 시작 상태로 돌아왔을 때, 방향을 전환하여(reversing direction) 무한 루프에서 애니메이션을 실행합니다.
:::

애니메이션이 완료, 앞으로 이동 또는 뒤로 이동하는 것과 같이, 상태가 변경될 때를 아는 것이 종종 도움이 됩니다. `addStatusListener()`로 이에 대한 알림을 받을 수 있습니다. 
다음 코드는 이전 예제를 수정하여 상태 변경을 수신하고 업데이트를 출력합니다. 
강조 표시된 줄은 변경 사항을 보여줍니다.

<?code-excerpt "animate3/lib/main.dart (print-state)" plaster="none" replace="/\/\/ (\.\..*)/$1;/g; /\n  }/$&\n  \/\/ .../g"?>
```dart highlightLines=11
class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addStatusListener((status) => print('$status'));
    controller.forward();
  }
  // ...
}
```

이 코드를 실행하면 다음과 같은 출력이 생성됩니다.

```console
AnimationStatus.forward
AnimationStatus.completed
```

다음으로, `addStatusListener()`를 사용하여 애니메이션을 시작 또는 끝에서 반전(reverse)합니다. 
이렇게 하면 "호흡(breathing)" 효과가 생성됩니다.

```dart diff
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
-   animation = Tween<double>(begin: 0, end: 300).animate(controller);
+   animation = Tween<double>(begin: 0, end: 300).animate(controller)
+     ..addStatusListener((status) {
+       if (status == AnimationStatus.completed) {
+         controller.reverse();
+       } else if (status == AnimationStatus.dismissed) {
+         controller.forward();
+       }
+     })
+     ..addStatusListener((status) => print('$status'));
    controller.forward();
  }
```

**앱 소스:** [animate3][]

### AnimatedBuilder로 리팩토링 {:#refactoring-with-animatedbuilder}

:::secondary 요점은 무엇인가요?
* [`AnimatedBuilder`][]는 전환을 렌더링하는 방법을 이해합니다.
* `AnimatedBuilder`는 위젯을 렌더링하는 방법을 모르고, `Animation` 객체를 관리하지도 않습니다.
* `AnimatedBuilder`를 사용하여 다른 위젯의 build 메서드의 일부로 애니메이션을 설명합니다. 
  재사용 가능한 애니메이션으로 위젯을 정의하려는 경우, 
  [AnimatedWidget으로 단순화][Simplifying with AnimatedWidget] 섹션에 표시된 대로 `AnimatedWidget`을 사용합니다.
* Flutter API의 `AnimatedBuilders` 예:
  `BottomSheet`, `ExpansionTile`, `PopupMenu`, `ProgressIndicator`,
  `RefreshIndicator`, `Scaffold`, `SnackBar`, `TabBar`,
  `TextField`.
:::

[animate3][] 예제의 코드에 있는 한 가지 문제는, 
애니메이션을 변경하려면 로고를 렌더링하는 위젯을 변경해야 한다는 것입니다. 
더 나은 해결책은 책임을 다음의 여러 클래스로 분리하는 것입니다.

* 로고 렌더링
* `Animation` 객체 정의
* 전환 렌더링

`AnimatedBuilder` 클래스의 도움으로 이러한 분리를 달성할 수 있습니다. 
`AnimatedBuilder`는 렌더링 트리에서 별도의 클래스입니다. 
`AnimatedWidget`과 마찬가지로, `AnimatedBuilder`는 `Animation` 객체의 알림을 자동으로 수신하고, 
필요에 따라 위젯 트리를 dirty로 표시하므로, `addListener()`를 호출할 필요가 없습니다.

[animate4][] 예제의 위젯 트리는 다음과 같습니다.

<img src="/assets/images/docs/ui/AnimatedBuilder-WidgetTree.png"
    alt="AnimatedBuilder widget tree" class="d-block mx-auto" width="160px">

위젯 트리의 맨 아래부터 시작하여, 로고를 렌더링하는 코드는 간단합니다.

<?code-excerpt "animate4/lib/main.dart (logo-widget)"?>
```dart
class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  // 높이와 너비를 생략하여, 애니메이션을 적용하는 부모를 채웁니다.
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const FlutterLogo(),
    );
  }
}
```

다이어그램의 가운데 세 블록은 모두 아래에 표시된 `GrowTransition`의 `build()` 메서드에서 생성됩니다. 
`GrowTransition` 위젯 자체는 stateless 이며, 전환 애니메이션을 정의하는 데 필요한 최종 변수 집합을 보유합니다. 
build() 함수는 `AnimatedBuilder`를 생성하여 반환합니다. 
이 함수는 (`Anonymous` builder) 메서드와 `LogoWidget` 객체를 매개변수로 사용합니다. 
전환을 렌더링하는 작업은 실제로 (`Anonymous` builder) 메서드에서 발생하며, 
이 메서드는 적절한 크기의 `Container`를 생성하여 `LogoWidget`이 축소되도록 강제합니다.

아래 코드에서 까다로운 점 하나는 자식이 두 번 지정된 것처럼 보인다는 것입니다. 
일어나는 일은 자식의 외부 참조가 `AnimatedBuilder`에 전달되고, 
익명 클로저에 전달되어 해당 객체를 자식으로 사용한다는 것입니다. 
결과적으로 `AnimatedBuilder`가 렌더 트리의 두 위젯 사이에 삽입됩니다.

<?code-excerpt "animate4/lib/main.dart (grow-transition)"?>
```dart
class GrowTransition extends StatelessWidget {
  const GrowTransition({
    required this.child,
    required this.animation,
    super.key,
  });

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return SizedBox(
            height: animation.value,
            width: animation.value,
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}
```

마지막으로, 애니메이션을 초기화하는 코드는 [animate2][] 예제와 매우 유사합니다. 
`initState()` 메서드는 `AnimationController`와 `Tween`을 생성한 다음, `animate()`로 바인딩합니다. 
마법은 `build()` 메서드에서 일어나는데, 
`LogoWidget`을 자식으로 하는 `GrowTransition` 객체와 전환을 구동하는 애니메이션 객체를 반환합니다. 
이것들은 위의 글머리 기호에 나열된 세 가지 요소입니다.

```dart diff
  void main() => runApp(const LogoApp());
  
+ class LogoWidget extends StatelessWidget {
+   const LogoWidget({super.key});
+ 
+   // Leave out the height and width so it fills the animating parent.
+   @override
+   Widget build(BuildContext context) {
+     return Container(
+       margin: const EdgeInsets.symmetric(vertical: 10),
+       child: const FlutterLogo(),
+     );
+   }
+ }
+ 
+ class GrowTransition extends StatelessWidget {
+   const GrowTransition({
+     required this.child,
+     required this.animation,
+     super.key,
+   });
+ 
+   final Widget child;
+   final Animation<double> animation;
+ 
+   @override
+   Widget build(BuildContext context) {
+     final animation = listenable as Animation<double>;
+     return Center(
+       child: Container(
+         margin: const EdgeInsets.symmetric(vertical: 10),
+         height: animation.value,
+         width: animation.value,
+         child: const FlutterLogo(),
+       child: AnimatedBuilder(
+         animation: animation,
+         builder: (context, child) {
+           return SizedBox(
+             height: animation.value,
+             width: animation.value,
+             child: child,
+           );
+         },
+         child: child,
+       ),
+     );
+   }
+ }

  class LogoApp extends StatefulWidget {
    // ...

    @override
-   Widget build(BuildContext context) => AnimatedLogo(animation: animation);
+   Widget build(BuildContext context) {
+     return GrowTransition(
+       animation: animation,
+       child: const LogoWidget(),
+     );
+   }

    // ...
  }
```

**앱 소스:** [animate4][]

### 동시 애니메이션 {:#simultaneous-animations}

:::secondary 요점은 무엇인가요?
* [`Curves`][] 클래스는 [`CurvedAnimation`][]과 함께 사용할 수 있는 일반적으로 사용되는 곡선 배열을 정의합니다.
:::

이 섹션에서는, [애니메이션 진행 모니터링][monitoring the progress of the animation] ([animate3][])의 예를 기반으로 구축합니다. 
여기서는 `AnimatedWidget`을 사용하여 지속적으로 애니메이션을 삽입하고 삽입합니다. 
불투명도가 투명에서 불투명으로 애니메이션되는 동안, in 및 out을 애니메이션하려는 경우를 고려합니다.

:::note
이 예제는 동일한 애니메이션 컨트롤러에서, 여러 트윈을 사용하는 방법을 보여줍니다. 
각 트윈은 애니메이션에서 다른 효과를 관리합니다. 설명 목적으로만 사용됩니다. 
프로덕션 코드에서 불투명도와 크기를 트위닝하는 경우, 
이것 대신 [`FadeTransition`][]과 [`SizeTransition`][]을 사용할 것입니다.
:::

각 트윈은 애니메이션의 한 측면을 관리합니다. 예를 들어:

<?code-excerpt "animate5/lib/main.dart (tweens)" plaster="none"?>
```dart
controller =
    AnimationController(duration: const Duration(seconds: 2), vsync: this);
sizeAnimation = Tween<double>(begin: 0, end: 300).animate(controller);
opacityAnimation = Tween<double>(begin: 0.1, end: 1).animate(controller);
```

`sizeAnimation.value`로 크기를 얻고, `opacityAnimation.value`로 불투명도를 얻을 수 있지만, 
`AnimatedWidget`의 생성자는 단일 `Animation` 객체만 사용합니다. 
이 문제를 해결하기 위해, 이 예제는 자체 `Tween` 객체를 생성하고 값을 명시적으로 계산합니다.

`AnimatedLogo`를 변경하여 자체 `Tween` 객체를 캡슐화하고, 
`build()` 메서드는 부모의 애니메이션 객체에서 `Tween.evaluate()`를 호출하여 필요한 크기와 불투명도 값을 계산합니다. 
다음 코드는 강조 표시된 변경 사항을 보여줍니다.

<?code-excerpt "animate5/lib/main.dart (diff)" replace="/(static final|child: Opacity|opacity:|_sizeTween\.|CurvedAnimation).*/[!$&!]/g"?>
```dart
class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({super.key, required Animation<double> animation})
      : super(listenable: animation);

  // 트윈은 변하지 않으므로 static으로 만드세요.
  [!static final _opacityTween = Tween<double>(begin: 0.1, end: 1);!]
  [!static final _sizeTween = Tween<double>(begin: 0, end: 300);!]

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      [!child: Opacity(!]
        [!opacity: _opacityTween.evaluate(animation),!]
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: [!_sizeTween.evaluate(animation),!]
          width: [!_sizeTween.evaluate(animation),!]
          child: const FlutterLogo(),
        ),
      ),
    );
  }
}

class LogoApp extends StatefulWidget {
  const LogoApp({super.key});

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = [!CurvedAnimation(parent: controller, curve: Curves.easeIn)!]
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedLogo(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

**앱 소스:** [animate5][]

## 다음 스텝 {:#next-steps}

이 튜토리얼은 `Tweens`를 사용하여 Flutter에서 애니메이션을 만드는 기초를 제공하지만, 
탐색할 수 있는 다른 클래스가 많이 있습니다. 
특수 `Tween` 클래스, Material Design에 특화된 애니메이션, `ReverseAnimation`, 
공유 요소 전환(Hero 애니메이션이라고도 함), 물리 시뮬레이션 및 `fling()` 메서드를 조사할 수 있습니다. 
최신 문서와 예제는 [애니메이션 랜딩 페이지][animations landing page]를 참조하세요.


[animate0]: {{examples}}/animation/animate0
[animate1]: {{examples}}/animation/animate1
[animate2]: {{examples}}/animation/animate2
[animate3]: {{examples}}/animation/animate3
[animate4]: {{examples}}/animation/animate4
[animate5]: {{examples}}/animation/animate5
[`AnimatedWidget`]: {{site.api}}/flutter/widgets/AnimatedWidget-class.html
[`Animatable`]: {{site.api}}/flutter/animation/Animatable-class.html
[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[`AnimatedBuilder`]: {{site.api}}/flutter/widgets/AnimatedBuilder-class.html
[animations landing page]: /ui/animations
[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[`AnimationController` section]: #animationcontroller
[`Curves`]: {{site.api}}/flutter/animation/Curves-class.html
[`CurvedAnimation`]: {{site.api}}/flutter/animation/CurvedAnimation-class.html
[Cascade notation]: {{site.dart-site}}/language/operators#cascade-notation
[Dart language documentation]: {{site.dart-site}}/language
[`evaluate(Animation<double> animation)`]: {{site.api}}/flutter/animation/Animation/value.html
[`FadeTransition`]: {{site.api}}/flutter/widgets/FadeTransition-class.html
[Monitoring the progress of the animation]: #monitoring
[Refactoring with AnimatedBuilder]: #refactoring-with-animatedbuilder
[`RepaintBoundary`]: {{site.api}}/flutter/widgets/RepaintBoundary-class.html
[`SlideTransition`]: {{site.api}}/flutter/widgets/SlideTransition-class.html
[Simplifying with AnimatedWidget]: #simplifying-with-animatedwidget
[`SizeTransition`]: {{site.api}}/flutter/widgets/SizeTransition-class.html
[`Tween`]: {{site.api}}/flutter/animation/Tween-class.html

