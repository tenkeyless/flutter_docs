---
# title: Animate a page route transition
title: 페이지 경로(route) 전환 애니메이션
# description: How to animate from one page to another.
description: 한 페이지에서 다른 페이지로 애니메이션을 적용하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/animation/page_route_animation/"?>

Material과 같은 디자인 언어는 경로(또는 화면) 간 전환 시 표준 동작을 정의합니다. 
그러나, 때로는, 화면 간의 커스텀 전환으로 앱이 더 독특해질 수 있습니다. 
도움을 주기 위해, [`PageRouteBuilder`][]는 [`Animation`] 객체를 제공합니다. 
이 `Animation`은 [`Tween`][] 및 [`Curve`][] 객체와 함께 사용하여 
전환 애니메이션을 커스터마이즈 할 수 있습니다. 
이 레시피는 화면 하단에서 새 경로를 애니메이션으로 표시하여 경로 간 전환하는 방법을 보여줍니다.

이 레시피는 커스텀 페이지 경로 전환을 만들기 위해, 다음 단계를 사용합니다.

1. PageRouteBuilder 설정
2. `Tween` 만들기
3. `AnimatedWidget` 추가
4. `CurveTween` 사용
5. 두 개의 `Tween` 결합

## 1. PageRouteBuilder 셋업 {:#1-set-up-a-pageroutebuilder}

시작하려면, [`PageRouteBuilder`][]를 사용하여 [`Route`][]를 만듭니다. 
`PageRouteBuilder`에는 두 개의 콜백이 있습니다. 
하나는 경로의 콘텐츠를 빌드하는 것(`pageBuilder`)이고, 
다른 하나는 경로의 전환을 빌드하는 것(`transitionsBuilder`)입니다.

:::note
transitionsBuilder의 `child` 매개변수는 pageBuilder에서 반환된 위젯입니다. 
`pageBuilder` 함수는 경로가 처음 빌드될 때만 호출됩니다. 
`child`가 전환 내내 동일하게 유지되므로, 프레임워크는 추가 작업을 피할 수 있습니다.
:::

다음 예에서는 두 개의 경로를 만듭니다. 
"Go!" 버튼이 있는 홈(home) 경로와 
"Page 2"라는 제목의 두 번째(second) 경로입니다.

<?code-excerpt "lib/starter.dart (Starter)"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Page1(),
    ),
  );
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
          child: const Text('Go!'),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Page 2'),
      ),
    );
  }
}
```

## 2. Tween 만들기 {:#2-create-a-tween}

새 페이지를 아래쪽으로부터 애니메이션 하려면, `Offset(0,1)`에서 `Offset(0, 0)`
(일반적으로 `Offset.zero` 생성자를 사용하여 정의)으로 애니메이션을 적용해야 합니다. 
이 경우, Offset은 [`FractionalTranslation`][] 위젯의 2D 벡터입니다. 
`dy` 인수를 1로 설정하면 페이지의 전체 높이만큼 수직임을 나타냅니다.

`transitionsBuilder` 콜백에는 `animation` 매개변수가 있습니다. 
0과 1 사이의 값을 생성하는 `Animation<double>`입니다. 
Tween을 사용하여 `Animation<double>`을 `Animation<Offset>`으로 변환합니다.

<?code-excerpt "lib/starter.dart (step1)"?>
```dart
transitionsBuilder: (context, animation, secondaryAnimation, child) {
  const begin = Offset(0.0, 1.0);
  const end = Offset.zero;
  final tween = Tween(begin: begin, end: end);
  final offsetAnimation = animation.drive(tween);
  return child;
},
```

## 3. AnimatedWidget 사용 {:#3-use-an-animatedwidget}

Flutter에는 애니메이션 값이 변경될 때 스스로를 재구축하는 
[`AnimatedWidget`][]을 확장하는 위젯 세트가 있습니다. 
예를 들어, [`SlideTransition`][]은 `Animation<Offset>`을 취해 
애니메이션 값이 변경될 때마다 자식을 변환합니다. ([`FractionalTranslation`][] 위젯 사용)

AnimatedWidget은 `Animation<Offset>`과 child 위젯이 있는 [`SlideTransition`][]을 반환합니다.

<?code-excerpt "lib/starter.dart (step2)"?>
```dart
transitionsBuilder: (context, animation, secondaryAnimation, child) {
  const begin = Offset(0.0, 1.0);
  const end = Offset.zero;
  final tween = Tween(begin: begin, end: end);
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
},
```

## 4. CurveTween 사용 {:#4-use-a-curvetween}

Flutter는 시간에 따라 애니메이션 속도를 조정하는 완화 곡선(easing curves)을 제공합니다. 
[`Curves`][] 클래스는 일반적으로 사용되는 곡선의 미리 정의된 세트를 제공합니다. 
예를 들어, `Curves.easeOut`은 애니메이션을 빠르게 시작하고 느리게 끝냅니다.

Curve를 사용하려면, 새 [`CurveTween`][]을 만들고 Curve를 전달합니다.

<?code-excerpt "lib/starter.dart (step3)"?>
```dart
var curve = Curves.ease;
var curveTween = CurveTween(curve: curve);
```

이 새로운 Tween은 여전히 ​​0~1까지의 값을 생성합니다. 
다음 단계에서는, 2단계의 `Tween<Offset>`을 결합합니다.

## 5. 두 개의 Tweens을 결합 {:#5-combine-the-two-tweens}

트윈을 결합하려면, [`chain()`][]을 사용하세요.

<?code-excerpt "lib/main.dart (Tween)"?>
```dart
const begin = Offset(0.0, 1.0);
const end = Offset.zero;
const curve = Curves.ease;

var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
```

그런 다음, 이 트윈을 `animation.drive()`에 전달하여 사용합니다. 
이렇게 하면, `SlideTransition` 위젯에 제공할 수 있는 새 `Animation<Offset>`이 생성됩니다.

<?code-excerpt "lib/main.dart (SlideTransition)"?>
```dart
return SlideTransition(
  position: animation.drive(tween),
  child: child,
);
```

이 새로운 Tween(또는 Animatable)은 
먼저 `CurveTween`을 평가한 다음 `Tween<Offset>`을 평가하여 
`Offset` 값을 생성합니다. 
애니메이션이 실행되면, 값은 다음 순서로 계산됩니다.

1. 애니메이션(transitionsBuilder 콜백에 제공됨)은 0~1 사이의 값을 생성합니다.
2. CurveTween은 그것의 곡선(curve)을 기반으로 0~1 사이의 새 값으로 해당 값을 매핑합니다.
3. `Tween<Offset>`은 `double` 값을 `Offset` 값으로 매핑합니다.

완화 곡선(easing curve)이 있는 `Animation<Offset>`을 만드는 또 다른 방법은 
`CurvedAnimation`을 사용하는 것입니다.

<?code-excerpt "lib/starter.dart (step4)" replace="/^\},$/}/g"?>
```dart
transitionsBuilder: (context, animation, secondaryAnimation, child) {
  const begin = Offset(0.0, 1.0);
  const end = Offset.zero;
  const curve = Curves.ease;

  final tween = Tween(begin: begin, end: end);
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: curve,
  );

  return SlideTransition(
    position: tween.animate(curvedAnimation),
    child: child,
  );
}
```

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter page routing hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Page1(),
    ),
  );
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
          child: const Text('Go!'),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Page 2'),
      ),
    );
  }
}
```
<noscript>
  <img src="/assets/images/docs/cookbook/page-route-animation.gif" alt="Demo showing a custom page route transition animating up from the bottom of the screen" class="site-mobile-screenshot" />
</noscript>


[`AnimatedWidget`]: {{site.api}}/flutter/widgets/AnimatedWidget-class.html
[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[`chain()`]: {{site.api}}/flutter/animation/Animatable/chain.html
[`Curve`]: {{site.api}}/flutter/animation/Curve-class.html
[`Curves`]: {{site.api}}/flutter/animation/Curves-class.html
[`CurveTween`]: {{site.api}}/flutter/animation/CurveTween-class.html
[`FractionalTranslation`]: {{site.api}}/flutter/widgets/FractionalTranslation-class.html
[`PageRouteBuilder`]: {{site.api}}/flutter/widgets/PageRouteBuilder-class.html
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[`SlideTransition`]: {{site.api}}/flutter/widgets/SlideTransition-class.html
[`Tween`]: {{site.api}}/flutter/animation/Tween-class.html
