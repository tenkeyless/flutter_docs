---
# title: Animate the properties of a container
title: 컨테이너의 속성에 애니메이팅
# description: How to animate properties of a container using implicit animations.
description: 암묵적 애니메이션을 사용하여 컨테이너의 속성에 애니메이션을 적용하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/animation/animated_container/"?>

[`Container`][] 클래스는 특정 속성(너비, 높이, 배경색, 패딩, 테두리 등)이 있는 
위젯을 만드는 편리한 방법을 제공합니다.

간단한 애니메이션은 종종 시간이 지남에 따라 이러한 속성을 변경하는 것을 포함합니다. 
예를 들어, 사용자가 아이템을 선택했음을 나타내기 위해 
배경색을 회색에서 녹색으로 애니메이션화할 수 있습니다.

이러한 속성을 애니메이션화하기 위해, Flutter는 [`AnimatedContainer`][] 위젯을 제공합니다.
`Container` 위젯과 마찬가지로, `AnimatedContainer`를 사용하면 
너비, 높이, 배경색 등을 정의할 수 있습니다. 
그러나, `AnimatedContainer`가 새 속성으로 다시 빌드되면, 
이전 값과 새 값 사이에서 자동으로 애니메이션이 적용됩니다. 
Flutter에서, 이러한 타입의 애니메이션은 "암묵적 애니메이션"이라고 합니다.

이 레시피는 사용자가 다음의 단계를 사용하여 버튼을 탭할 때, 
크기, 배경색 및 테두리 반경을 애니메이션화하는 
`AnimatedContainer`를 사용하는 방법을 설명합니다.

  1. 기본 속성으로 StatefulWidget을 만듭니다.
  2. 속성을 사용하여 `AnimatedContainer`를 빌드합니다.
  3. 새 속성으로 다시 빌드하여 애니메이션을 시작합니다.

## 1. 기본 속성을 사용하여 StatefulWidget 만들기  {:#1-create-a-statefulwidget-with-default-properties}

시작하려면, [`StatefulWidget`][] 및 [`State`][] 클래스를 만듭니다. 
커스텀 State 클래스를 사용하여 시간이 지남에 따라 변경되는 속성을 정의합니다. 
이 예에서는, 너비, 높이, 색상 및 테두리 반경이 포함됩니다. 
각 속성의 기본값을 정의할 수도 있습니다.

이러한 속성은 커스텀 `State` 클래스에 속하므로, 사용자가 버튼을 탭하면 업데이트될 수 있습니다.

<?code-excerpt "lib/starter.dart (Starter)" remove="return Container();"?>
```dart
class AnimatedContainerApp extends StatefulWidget {
  const AnimatedContainerApp({super.key});

  @override
  State<AnimatedContainerApp> createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  // 다양한 속성을 기본값으로 정의합니다. 
  // 사용자가 FloatingActionButton을 탭하면 이러한 속성을 업데이트합니다.
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    // 다음 단계에서 이를 작성하세요.
  }
}
```

## 2. 속성을 사용하여 `AnimatedContainer`를 빌드 {:#2-build-an-animatedcontainer-using-the-properties}

다음으로, 이전 단계에서 정의한 속성을 사용하여 `AnimatedContainer`를 빌드합니다. 
또한, 애니메이션이 실행되어야 하는 기간을 정의하는 `duration`을 제공합니다.

<?code-excerpt "lib/main.dart (AnimatedContainer)" replace="/^child: //g;/^\),$/)/g"?>
```dart
AnimatedContainer(
  // State 클래스에 저장된 속성을 사용합니다.
  width: _width,
  height: _height,
  decoration: BoxDecoration(
    color: _color,
    borderRadius: _borderRadius,
  ),
  // 애니메이션이 얼마나 걸리는지 정의합니다.
  duration: const Duration(seconds: 1),
  // 애니메이션을 더 부드럽게 만들려면 선택적으로 곡선(curve)을 제공합니다.
  curve: Curves.fastOutSlowIn,
)
```

## 3. 새 속성으로 재구성하여 애니메이션을 시작 {:#3-start-the-animation-by-rebuilding-with-new-properties}

마지막으로, 새로운 속성으로 `AnimatedContainer`를 다시 빌드하여 애니메이션을 시작합니다. 
다시 빌드를 트리거하는 방법은? [`setState()`][] 메서드를 사용합니다.

앱에 버튼을 추가합니다. 
사용자가 버튼을 탭하면, `setState()`를 호출하여 속성을 새 너비, 높이, 배경색 및 테두리 반경으로 업데이트합니다.

실제 앱은 일반적으로 고정된 값(예: 회색에서 녹색 배경으로) 간에 전환합니다. 
이 앱의 경우, 사용자가 버튼을 탭할 때마다 새 값을 생성합니다.

<?code-excerpt "lib/main.dart (FAB)" replace="/^floatingActionButton: //g;/^\),$/)/g"?>
```dart
FloatingActionButton(
  // 사용자가 버튼을 탭할 때,
  onPressed: () {
    // setState를 사용하여 새로운 값으로 위젯을 다시 빌드합니다.
    setState(() {
      // 난수 생성기를 만들어보세요.
      final random = Random();

      // 무작위 너비와 높이를 생성합니다.
      _width = random.nextInt(300).toDouble();
      _height = random.nextInt(300).toDouble();

      // 무작위 색상을 생성합니다.
      _color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );

      // 무작위 테두리 반경을 생성합니다.
      _borderRadius =
          BorderRadius.circular(random.nextInt(100).toDouble());
    });
  },
  child: const Icon(Icons.play_arrow),
)
```

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter animated container hands-on example in DartPad" run="true"
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const AnimatedContainerApp());

class AnimatedContainerApp extends StatefulWidget {
  const AnimatedContainerApp({super.key});

  @override
  State<AnimatedContainerApp> createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  // 다양한 속성을 기본값으로 정의합니다. 
  // 사용자가 FloatingActionButton을 탭하면 이러한 속성을 업데이트합니다.
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AnimatedContainer Demo'),
        ),
        body: Center(
          child: AnimatedContainer(
            // State 클래스에 저장된 속성을 사용합니다.
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: _borderRadius,
            ),
            // 애니메이션이 얼마나 걸리는지 정의합니다.
            duration: const Duration(seconds: 1),
            // 애니메이션을 더 부드럽게 만들려면 선택적으로 곡선(curve)을 제공합니다.
            curve: Curves.fastOutSlowIn,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // 사용자가 버튼을 탭할 때,
          onPressed: () {
            // setState를 사용하여 새로운 값으로 위젯을 다시 빌드합니다.
            setState(() {
              // 난수 생성기를 만들어보세요.
              final random = Random();

              // 무작위 너비와 높이를 생성합니다.
              _width = random.nextInt(300).toDouble();
              _height = random.nextInt(300).toDouble();

              // 무작위 색상을 생성합니다.
              _color = Color.fromRGBO(
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
                1,
              );

              // 무작위 테두리 반경을 생성합니다.
              _borderRadius =
                  BorderRadius.circular(random.nextInt(100).toDouble());
            });
          },
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/animated-container.gif" alt="AnimatedContainer demo showing a box growing and shrinking in size while changing color and border radius" class="site-mobile-screenshot" />
</noscript>


[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`setState()`]: {{site.api}}/flutter/widgets/State/setState.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
