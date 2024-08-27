---
# title: Fade a widget in and out
title: 위젯을 페이드 인 및 페이드 아웃
# description: How to fade a widget in and out.
description: 위젯을 페이드 인/아웃하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/animation/opacity_animation/"?>

UI 개발자는 종종 화면에 요소를 표시하고 숨겨야 합니다. 
그러나, 요소를 화면에 빠르게 표시하고 숨기는 것은 최종 사용자에게 어색하게 느껴질 수 있습니다. 
대신, 불투명도 애니메이션으로 요소를 페이드 인하고 페이드 아웃하여 매끄러운 경험을 만드세요.

[`AnimatedOpacity`][] 위젯을 사용하면 불투명도 애니메이션을 쉽게 수행할 수 있습니다. 
이 레시피는 다음 단계를 사용합니다.

  1. 페이드 인 및 페이드 아웃할 상자를 만듭니다.
  2. `StatefulWidget`을 정의합니다.
  3. 가시성을 토글하는 버튼을 표시합니다.
  4. 상자를 페이드 인 및 페이드 아웃합니다.

## 1. 페이드 인 및 페이드 아웃할 상자 생성 {:#1-create-a-box-to-fade-in-and-out}

먼저, 페이드인과 페이드아웃을 할 무언가를 만드세요. 
이 예에서는, 화면에 녹색 상자를 그립니다.

<?code-excerpt "lib/main.dart (Container)" replace="/^child: //g;/\),$/)/g"?>
```dart
Container(
  width: 200,
  height: 200,
  color: Colors.green,
)
```

## 2. `StatefulWidget`을 정의 {:#2-define-a-statefulwidget}

이제 애니메이션을 적용할 녹색 상자가 생겼으므로, 상자를 표시할지 여부를 알 수 있는 방법이 필요합니다. 
이를 위해, [`StatefulWidget`][]을 사용합니다.

`StatefulWidget`은 `State` 객체를 만드는 클래스입니다. 
`State` 객체는 앱에 대한 일부 데이터를 보관하고, 해당 데이터를 업데이트하는 방법을 제공합니다. 
데이터를 업데이트할 때 ,Flutter에 해당 변경 사항으로 UI를 다시 빌드하도록 요청할 수도 있습니다.

이 경우, 데이터가 하나 있습니다. 버튼이 표시되는지 여부를 나타내는 boolean 입니다.

`StatefulWidget`을 구성하려면, `StatefulWidget`과 해당 `State` 클래스의 두 클래스를 만듭니다. 

전문가 팁: Android Studio 및 VSCode용 Flutter 플러그인에는 
이 코드를 빠르게 생성하는 `stful` 스니펫이 포함되어 있습니다.

<?code-excerpt "lib/starter.dart (Starter)" remove="return Container();"?>
```dart
// StatefulWidget의 역할은 데이터를 가져와 State 클래스를 만드는 것입니다.
// 이 경우, 위젯은 제목을 가져와, _MyHomePageState를 만듭니다.
class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State 클래스는 두 가지 일을 담당합니다. 
// 업데이트할 수 있는 데이터를 보관하고, 해당 데이터를 사용하여 UI를 구축합니다.
class _MyHomePageState extends State<MyHomePage> {
  // 녹색 상자를 표시할지 여부.
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    // 다른 위젯들과 함께 녹색 상자가 여기에 옵니다.
  }
}
```

## 3. 가시성을 토글하는 버튼을 표시 {:#3-display-a-button-that-toggles-the-visibility}

이제 녹색 상자를 표시할지 여부를 결정할 데이터가 있으므로, 해당 데이터를 업데이트할 방법이 필요합니다. 
이 예에서, 상자가 표시되면 숨깁니다. 상자가 숨겨져 있으면, 표시합니다.

이를 처리하려면, 버튼을 표시합니다. 
사용자가 버튼을 누르면, boolean 값을 true에서 false로, false에서 true로 뒤집습니다. 
`State` 클래스의 메서드인 [`setState()`][]를 사용하여 이 변경을 수행합니다. 
이렇게 하면 Flutter가 위젯을 다시 빌드합니다.

사용자 입력 작업에 대한 자세한 내용은, 쿡북의 [Gestures][] 섹션을 참조하세요.

<?code-excerpt "lib/main.dart (FAB)" replace="/^floatingActionButton: //g;/^\),$/)/g"?>
```dart
FloatingActionButton(
  onPressed: () {
    // setState를 호출합니다. 
    // 이는 Flutter에게 변경 사항으로 UI를 재구축하라고 알려줍니다.
    setState(() {
      _visible = !_visible;
    });
  },
  tooltip: 'Toggle Opacity',
  child: const Icon(Icons.flip),
)
```

## 4. 상자를 페이드 인 및 페이드 아웃 {:#4-fade-the-box-in-and-out}

화면에 녹색 상자가 있고, 표시 여부를 `true` 또는 `false`로 전환하는 버튼이 있습니다. 
상자를 페이드 인/아웃하는 방법은? [`AnimatedOpacity`][] 위젯을 사용하면 됩니다.

`AnimatedOpacity` 위젯에는 세 가지 인수가 필요합니다.

* `opacity`: 0.0(보이지 않음)에서 1.0(완전히 보임)까지의 값입니다.
* `duration`: 애니메이션을 완료하는 데 걸리는 시간입니다.
* `child`: 애니메이션을 적용할 위젯입니다. 이 경우, 녹색 상자입니다.

<?code-excerpt "lib/main.dart (AnimatedOpacity)" replace="/^child: //g;/^\),$/)/g"?>
```dart
AnimatedOpacity(
  // 위젯이 보이면, 0.0으로 애니메이트 합니다. (보이지 않음)
  // 위젯이 숨겨져 있으면, 1.0으로 애니메이트 합니다. (완전히 보임)
  opacity: _visible ? 1.0 : 0.0,
  duration: const Duration(milliseconds: 500),
  // 녹색 상자는 AnimatedOpacity 위젯의 자식이어야 합니다.
  child: Container(
    width: 200,
    height: 200,
    color: Colors.green,
  ),
)
```

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Implicit Animation Opacity DartPad hands-on example" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Opacity Demo';
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

// StatefulWidget의 역할은 데이터를 가져와 State 클래스를 만드는 것입니다.
// 이 경우, 위젯은 제목을 가져와, _MyHomePageState를 만듭니다.
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State 클래스는 두 가지 일을 담당합니다. 
// 업데이트할 수 있는 데이터를 보관하고, 해당 데이터를 사용하여 UI를 구축합니다.
class _MyHomePageState extends State<MyHomePage> {
  // 녹색 상자를 표시할지 여부.
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: AnimatedOpacity(
          // 위젯이 보이면, 0.0으로 애니메이트 합니다. (보이지 않음)
          // 위젯이 숨겨져 있으면, 1.0으로 애니메이트 합니다. (완전히 보임)
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          // 녹색 상자는 AnimatedOpacity 위젯의 자식이어야 합니다.
          child: Container(
            width: 200,
            height: 200,
            color: Colors.green,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // setState를 호출합니다. 
          // 이는 Flutter에게 변경 사항으로 UI를 재구축하라고 알려줍니다.
          setState(() {
            _visible = !_visible;
          });
        },
        tooltip: 'Toggle Opacity',
        child: const Icon(Icons.flip),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/fade-in-out.gif" alt="Fade In and Out Demo" class="site-mobile-screenshot" />
</noscript>

[`AnimatedOpacity`]: {{site.api}}/flutter/widgets/AnimatedOpacity-class.html
[Gestures]: /cookbook#gestures
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`setState()`]: {{site.api}}/flutter/widgets/State/setState.html
