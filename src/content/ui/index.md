---
# title: Building user interfaces with Flutter
title: Flutter로 사용자 인터페이스 구축
short-title: UI
# description: Introduction to user interface development in Flutter.
description: Flutter에서 사용자 인터페이스 개발 소개.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="ui/widgets_intro/"?>

{% assign api = site.api | append: '/flutter' -%}

플러터 위젯은 [React][]에서 영감을 얻은 최신 프레임워크를 사용하여 빌드됩니다. 
핵심 아이디어는 위젯으로 UI를 빌드한다는 것입니다. 
위젯은 현재 구성과 상태를 고려하여 뷰가 어떻게 보여야 하는지 설명합니다. 
위젯의 상태가 변경되면, 위젯은 표현을 다시 빌드하고, 
프레임워크는 기본 렌더 트리에서 한 상태에서 다음 상태로 전환하는 데 필요한 최소한의 변경 사항을 결정하기 위해, 
이전 표현과 비교합니다.

:::note
Flutter에 대해 코드를 자세히 알아보고 싶다면, 
[레이아웃 작성][building layouts]과 [Flutter 앱에 상호작용성 추가][adding interactivity to your Flutter app]를 확인하세요.
:::

## Hello world {:#hello-world}

최소한의 Flutter 앱은 위젯과 함께 [`runApp()`][] 함수를 호출하기만 하면 됩니다.

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Hello World hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const Center(
      child: Text(
        'Hello, world!',
        textDirection: TextDirection.ltr,
      ),
    ),
  );
}
```

`runApp()` 함수는 주어진 [`Widget`][]을 가져와 위젯 트리의 루트로 만듭니다. 
이 예에서, 위젯 트리는 두 개의 위젯, 즉 [`Center`][] 위젯과 그 자식인 [`Text`][] 위젯으로 구성됩니다. 
프레임워크는 루트 위젯이 화면을 커버하도록 강제합니다. 
즉, "Hello, world"라는 텍스트가 화면 중앙에 배치됩니다. 이 경우 텍스트 방향을 지정해야 합니다. 
`MaterialApp` 위젯을 사용하면, 나중에 설명하겠지만, 이 작업이 자동으로 처리됩니다.

앱을 작성할 때는, 위젯이 상태를 관리하는지 여부에 따라, 
[`StatelessWidget`][] 또는 [`StatefulWidget`][]의, 하위 클래스인 새 위젯을 작성하는 것이 일반적입니다. 
위젯의 주요 작업은 다른 하위 레벨 위젯을 기준으로 위젯을 표현하는 [`build()`][] 함수를 구현하는 것입니다. 
프레임워크는 기본 [`RenderObject`][]를 나타내는 위젯에서 프로세스가 최하위에 도달할 때까지 위젯을 차례로 빌드합니다. 
여기서 위젯의 기하학을 계산하고 표현합니다.

## 기본 위젯 {:#basic-widgets}

Flutter에는 강력한 기본 위젯이 함께 제공되며, 그 중 일반적으로 사용되는 것은 다음과 같습니다.

**[`Text`][]**
: `Text` 위젯을 사용하면 애플리케이션 내에서 스타일이 지정된 텍스트를 만들 수 있습니다.

**[`Row`][], [`Column`][]**
: 이러한 플렉스(flex) 위젯을 사용하면, 가로(`Row`) 및 세로(`Column`) 방향으로 유연한 레이아웃을 만들 수 있습니다. 
  이러한 객체의 디자인은 웹의 플렉스박스(flexbox) 레이아웃 모델을 기반으로 합니다.

**[`Stack`][]**
: `Stack` 위젯을 사용하면 선형 방향(가로 또는 세로)이 아닌, 위젯을 페인트 순서대로, 서로 위에 배치할 수 있습니다. 
  그런 다음, `Stack`의 자식에 [`Positioned`][] 위젯을 사용하여, 
  상대적으로(relative) 스택의 위쪽, 오른쪽, 아래쪽 또는 왼쪽 가장자리를 기준으로 배치할 수 있습니다. 
  스택은 웹의 절대(absolute) 위치 지정 레이아웃 모델을 기반으로 합니다.

**[`Container`][]**
: `Container` 위젯을 사용하면 직사각형 시각적 요소를 만들 수 있습니다. 
  컨테이너는 배경, 테두리 또는 그림자와 같은, [`BoxDecoration`][]으로 장식할 수 있습니다. 
  `Container`는 크기에 적용되는 여백(margins), 패딩(padding) 및 제약 조건(constraints)을 가질 수도 있습니다. 
  또한, `Container`는 행렬을 사용하여 3차원 공간에서 변환할 수 있습니다.

다음은 이러한 위젯과 다른 위젯을 결합한 간단한 위젯입니다.

<?code-excerpt "lib/main_myappbar.dart"?>
```dartpad title="Flutter combining widgets hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({required this.title, super.key});

  // Widget 하위 클래스의 필드는 항상 "final"으로 표시됩니다.

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, // 논리적 픽셀입니다.
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.blue[500]),
      // Row는 수평적이고, 선형적인 레이아웃입니다.
      child: Row(
        children: [
          const IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Navigation menu',
            onPressed: null, // null은 버튼을 비활성화합니다.
          ),
          // Expanded는 사용 가능한 공간을 채우기 위해 자식을 확장합니다.
          Expanded(
            child: title,
          ),
          const IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    // Material은 UI가 나타나는 개념적 종이입니다.
    return Material(
      // Column은 수직적이고, 선형적인 레이아웃입니다.
      child: Column(
        children: [
          MyAppBar(
            title: Text(
              'Example title',
              style: Theme.of(context) //
                  .primaryTextTheme
                  .titleLarge,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Hello, world!'),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      title: 'My app', // OS 작업 전환기에서 사용됩니다.
      home: SafeArea(
        child: MyScaffold(),
      ),
    ),
  );
}
```

`pubspec.yaml` 파일의 `flutter` 섹션에 `uses-material-design: true` 항목이 있는지 확인하세요. 
그러면 미리 정의된 [Material 아이콘][Material icons] 세트를 사용할 수 있습니다. 
Materials 라이브러리를 사용하는 경우 일반적으로 이 줄을 포함하는 것이 좋습니다.

```yaml
name: my_app
flutter:
  uses-material-design: true
```

많은 Material Design 위젯은, 테마 데이터를 상속하기 위해, [`MaterialApp`][] 내부에 있어야 제대로 표시됩니다. 
따라서, `MaterialApp`로 애플리케이션을 실행하세요.

`MyAppBar` 위젯은 
높이가 56 기기 독립 픽셀(device-independent pixels)이고, 
왼쪽과 오른쪽 모두의 내부 패딩이 8픽셀인 [`Container`][]를 만듭니다. 

컨테이너 내부에서, `MyAppBar`는 [`Row`][] 레이아웃을 사용하여 children을 구성합니다. 
가운데 child인, `title` 위젯은 [`Expanded`][]로 표시되어, 
다른 자식이 사용하지 않은 남은 사용 가능한 공간을 채우기 위해 확장됩니다. 
여러 개의 `Expanded` 자식을 가질 수 있으며, 
`Expanded`에 대한 [`flex`][] 인수를 사용하여, 사용 가능한 공간을 사용하는 비율을 결정할 수 있습니다.

`MyScaffold` 위젯은 자식을 세로 column으로 구성합니다. 
열의 맨 위에 `MyAppBar` 인스턴스를 배치하여, 앱 바에 제목으로 사용할 [`Text`][] 위젯을 전달합니다. 
위젯을 다른 위젯에 인수로 전달하는 것은 다양한 방식으로 재사용할 수 있는 일반 위젯을 만들 수 있는 강력한 기술입니다. 
마지막으로, `MyScaffold`는 [`Expanded`][]를 사용하여 나머지 공간을 body로 채웁니다. 
body는 가운데 정렬된 메시지로 구성됩니다.

자세한 내용은 [Layouts][]를 확인하세요.

## Material 컴포넌트 사용 {:#using-material-components}

Flutter는 Material Design을 따르는 앱을 빌드하는 데 도움이 되는 여러 위젯을 제공합니다. 
Material 앱은 [`MaterialApp`][] 위젯으로 시작하는데, 이 위젯은 앱 루트에 여러 유용한 위젯을 빌드합니다. 
여기에는 문자열로 식별된 위젯 스택을 관리하는 [`Navigator`][]가 포함되며, "경로(routes)"라고도 합니다. 
`Navigator`를 사용하면 애플리케이션 화면 간에 원활하게 전환할 수 있습니다. 
[`MaterialApp`][] 위젯을 사용하는 것은 전적으로 선택 사항이지만, 좋은 관행입니다.

<?code-excerpt "lib/main_tutorial.dart"?>
```dartpad title="Flutter Material design hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Flutter Tutorial',
      home: TutorialHome(),
    ),
  );
}

class TutorialHome extends StatelessWidget {
  const TutorialHome({super.key});

  @override
  Widget build(BuildContext context) {
    // 스캐폴드는 주요 Material 컴포넌트에 대한 레이아웃입니다.
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title: const Text('Example title'),
        actions: const [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
      // body는 화면의 대부분을 차지합니다.
      body: const Center(
        child: Text('Hello, world!'),
      ),
      floatingActionButton: const FloatingActionButton(
        tooltip: 'Add', // assistive 기술에 의해 사용됩니다.
        onPressed: null,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

이제 코드가 `MyAppBar`와 `MyScaffold`에서 [`AppBar`][]와 [`Scaffold`][] 위젯으로, 
그리고 `material.dart`에서 전환되었으므로 앱이 조금 더 Material처럼 보이기 시작했습니다. 
예를 들어, 앱 바에 그림자가 있고, 제목 텍스트는 올바른 스타일을 자동으로 상속합니다. 
떠 있는 작업 버튼(floating action button, FAB)도 추가되었습니다.

위젯이 다른 위젯에 인수로 전달된다는 점에 유의하세요. 
[`Scaffold`][] 위젯은 여러 위젯을 명명된 인수로 취하며, 각각은 적절한 위치에 있는 `Scaffold` 레이아웃에 배치됩니다. 
마찬가지로, [`AppBar`][] 위젯을 사용하면 
[`leading`][] 위젯과 [`title`][] 위젯의 [`actions`][]에 대한 위젯을 전달할 수 있습니다. 
이 패턴은 프레임워크 전체에서 반복되며, 위젯을 직접 디자인할 때 고려할 수 있는 사항입니다.

자세한 내용은 [Material 컴포넌트 위젯][Material Components widgets]를 확인하세요.

:::note
Material은 Flutter에 포함된 2개의 번들 디자인 중 하나입니다. 
iOS 중심 디자인을 만들려면 [Cupertino 구성 요소][Cupertino components] 패키지를 확인하세요. 
이 패키지에는 [`CupertinoApp`][] 및 [`CupertinoNavigationBar`][]의 자체 버전이 있습니다.
:::


## 제스쳐 다루기 {:#handling-gestures}

대부분의 애플리케이션에는 시스템과의 어떤 형태의 사용자 상호 작용이 포함됩니다. 
대화형 애플리케이션을 구축하는 첫 번째 단계는 입력 제스처를 감지하는 것입니다. 
간단한 버튼을 만들어서 어떻게 작동하는지 살펴보세요.

<?code-excerpt "lib/main_mybutton.dart"?>
```dartpad title="Flutter button hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('MyButton was tapped!');
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.lightGreen[500],
        ),
        child: const Center(
          child: Text('Engage'),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: MyButton(),
        ),
      ),
    ),
  );
}
```

[`GestureDetector`][] 위젯은 시각적 표현이 없지만, 대신 사용자가 한 제스처를 감지합니다. 
사용자가 [`Container`][]를 탭하면, `GestureDetector`가 [`onTap()`][] 콜백을 호출하여, 
이 경우 콘솔에 메시지를 출력합니다. 
`GestureDetector`를 사용하면 탭, 드래그, 크기 조절 등 다양한 입력 제스처를 감지할 수 있습니다.

많은 위젯이 [`GestureDetector`][]를 사용하여 다른 위젯에 대한 선택적 콜백을 제공합니다. 
예를 들어, [`IconButton`][], [`ElevatedButton`][], [`FloatingActionButton`][] 위젯에는 
사용자가 위젯을 탭할 때 트리거되는 [`onPressed()`][] 콜백이 있습니다.

자세한 내용은 [Flutter에서의 제스쳐][Gestures in Flutter]를 확인하세요.

## 입력에 따라 위젯 변경 {:#changing-widgets-in-response-to-input}

지금까지, 이 페이지에서는 stateless 위젯만 사용했습니다. 
stateless 위젯은 부모 위젯에서 인수를 받고, 이를 [`final`][] 멤버 ​​변수에 저장합니다. 
위젯에 [`build()`][]를 요청하면, 이러한 저장된 값을 사용하여 만든 위젯에 대한 새 인수를 파생합니다.

더 복잡한 경험을 구축하기 위해(예: 사용자 입력에 더 흥미로운 방식으로 반응하기 위해) 
애플리케이션은 일반적으로 일부 상태를 보유합니다. 
Flutter는 `StatefulWidgets`를 사용하여 이 아이디어를 포착합니다. 
`StatefulWidgets`는 `State` 객체를 생성하는 방법을 아는 특수 위젯으로, 이 객체는 상태를 보관하는 데 사용됩니다. 
앞서 언급한 [`ElevatedButton`][]을 사용하는, 이 기본 예제를 고려해 보겠습니다.

<?code-excerpt "lib/main_counter.dart"?>
```dartpad title="Flutter state management hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  // 이 클래스는 상태에 대한 구성입니다. 
  // 부모가 제공하고 State의 빌드 메서드에서 사용하는 값(이 경우 아무것도 없음)을 보유합니다. 
  // Widget 하위 클래스의 필드는 항상 "final"으로 표시됩니다.

  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      // setState에 대한 이 호출은 Flutter 프레임워크에 이 State에서 무언가가 변경되었음을 알리고, 
      // 이는 디스플레이가 업데이트된 값을 반영할 수 있도록 아래의 build 메서드를 다시 실행하게 합니다. 
      // setState()를 호출하지 않고 _counter를 변경하면, 
      // build 메서드가 다시 호출되지 않으므로,
      // 아무 일도 일어나지 않는 것처럼 보입니다.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 이 메서드는 setState가 호출될 때마다 다시 실행됩니다. 
    // 예를 들어, 위의 _increment 메서드에서 수행한 것과 같습니다. 
    // Flutter 프레임워크는 빌드 메서드를 빠르게 다시 실행하도록 최적화되어, 
    // 위젯 인스턴스를 개별적으로 변경하는 대신, 업데이트가 필요한 모든 것을 다시 빌드할 수 있습니다.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: _increment,
          child: const Text('Increment'),
        ),
        const SizedBox(width: 16),
        Text('Count: $_counter'),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Counter(),
        ),
      ),
    ),
  );
}
```

`StatefulWidget`과 `State`가 별개의 객체인 이유가 궁금할 수 있습니다. 
Flutter에서, 이 두 타입의 객체는 수명 주기가 다릅니다. 
`Widget`은, 현재 상태에서 애플리케이션의 프레젠테이션을 구성하는 데 사용되는, 임시 객체입니다. 
반면, `State` 객체는 `build()`에 대한 호출 사이에 지속되므로, 정보를 기억할 수 있습니다.

위의 예는 사용자 입력을 수락하고, 결과를 `build()` 메서드에서 직접 사용합니다. 
더 복잡한 애플리케이션에서는, 위젯 계층의 다른 부분이 다른 문제(concerns)에 대한 책임이 있을 수 있습니다. 
예를 들어, 한 위젯은 날짜나 위치와 같은 특정 정보를 수집하는 목표로 복잡한 사용자 인터페이스를 제공하는 반면, 
다른 위젯은 해당 정보를 사용하여 전체 프레젠테이션을 변경할 수 있습니다.

Flutter에서, 변경 알림은 콜백을 통해 위젯 계층을 "위로(up)" 이동하는 반면, 
현재 상태는 프레젠테이션을 수행하는 stateless 위젯으로 "아래로(down)" 이동합니다. 
이 흐름을 리디렉션하는 공통 부모는 `State`입니다. 
다음은 약간 더 복잡한 예이며, 실제로 이것이 어떻게 작동하는지 보여줍니다.

<?code-excerpt "lib/main_counterdisplay.dart"?>
```dartpad title="Flutter Hello World hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}

class CounterIncrementor extends StatelessWidget {
  const CounterIncrementor({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Increment'),
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      ++_counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CounterIncrementor(onPressed: _increment),
        const SizedBox(width: 16),
        CounterDisplay(count: _counter),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Counter(),
        ),
      ),
    ),
  );
}
```

카운터를 _표시(displaying)_ 하는 것(`CounterDisplay`)과 카운터를 _변경(changing)_ 하는 것(`CounterIncrementor`)을 
깔끔하게 분리한 두 개의 새로운 stateless 위젯을 만든 것을 주목하세요. 
최종 결과는 이전 예와 동일하지만, 책임을 분리하면 부모 위젯에서 단순성을 유지하면서도, 
개별 위젯에 더 큰 복잡성을 캡슐화할 수 있습니다.

자세한 내용은 다음을 확인하세요.

* [`StatefulWidget`][]
* [`setState()`][]

## 모두 하나로 모으기 {:#bringing-it-all-together}

다음은 이러한 개념을 하나로 모은 보다 완전한 예입니다. 
가상의 쇼핑 애플리케이션은 판매를 위해 제공되는 다양한 제품을 표시하고, 의도된 구매를 위한 쇼핑 카트를 유지합니다. 
프레젠테이션 클래스인 `ShoppingListItem`을 정의하는 것으로 시작합니다.

<?code-excerpt "lib/main_shoppingitem.dart"?>
```dartpad title="Flutter complete shopping list item hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

class Product {
  const Product({required this.name});

  final String name;
}

typedef CartChangedCallback = Function(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({
    required this.product,
    required this.inCart,
    required this.onCartChanged,
  }) : super(key: ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    // 테마는 BuildContext에 따라 달라집니다. 
    // 트리의 다른 부분은 다른 테마를 가질 수 있기 때문입니다. 
    // BuildContext는 빌드가 진행되는 위치와 따라서 사용할 테마를 나타냅니다.
    return inCart //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onCartChanged(product, inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(product.name, style: _getTextStyle(context)),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: ShoppingListItem(
            product: const Product(name: 'Chips'),
            inCart: true,
            onCartChanged: (product, inCart) {},
          ),
        ),
      ),
    ),
  );
}
```

`ShoppingListItem` 위젯은 stateless 위젯의 일반적인 패턴을 따릅니다. 
생성자에서 수신한 값을 [`final`][] 멤버 ​​변수에 저장한 다음, [`build()`][] 함수에서 사용합니다. 
예를 들어, `inCart` boolean은 두 가지 시각적 모양 사이를 전환합니다. 
하나는 현재 테마의 primary color를 사용하고, 다른 하나는 회색을 사용합니다.

사용자가 리스트 아이템을 탭하면, 위젯은 `inCart` 값을 직접 수정하지 않습니다. 
대신, 위젯은 부모 위젯에서 수신한 `onCartChanged` 함수를 호출합니다. 
이 패턴을 사용하면 위젯 계층에서 상태를 더 높은 위치에 저장할 수 있으므로, 상태가 더 오랜 시간 동안 유지됩니다. 
극단적인 경우, [`runApp()`][]에 전달된 위젯에 저장된 상태는 애플리케이션의 수명 동안 유지됩니다.

부모가 `onCartChanged` 콜백을 받으면, 부모는 내부 상태를 업데이트하고, 
이는 부모가 다시 빌드하고 새 `inCart` 값으로 `ShoppingListItem`의 새 인스턴스를 생성하도록 트리거합니다. 
부모는 다시 빌드할 때 `ShoppingListItem`의 새 인스턴스를 생성하지만, 
프레임워크가 새로 빌드된 위젯을 이전에 빌드된 위젯과 비교하여 기본 [`RenderObject`][]에만 차이점을 적용하기 때문에, 
이 작업은 저렴합니다.

다음은 변경 가능한(mutable) 상태를 저장하는 부모 위젯의 예입니다.

<?code-excerpt "lib/main_shoppinglist.dart"?>
```dartpad title="Flutter storing mutable state hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

class Product {
  const Product({required this.name});

  final String name;
}

typedef CartChangedCallback = Function(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({
    required this.product,
    required this.inCart,
    required this.onCartChanged,
  }) : super(key: ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    // 테마는 BuildContext에 따라 달라집니다. 
    // 트리의 다른 부분은 다른 테마를 가질 수 있기 때문입니다. 
    // BuildContext는 빌드가 진행되는 위치와 따라서 사용할 테마를 나타냅니다.
    return inCart //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onCartChanged(product, inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(
        product.name,
        style: _getTextStyle(context),
      ),
    );
  }
}

class ShoppingList extends StatefulWidget {
  const ShoppingList({required this.products, super.key});

  final List<Product> products;

  // 프레임워크는 위젯이 트리의 주어진 위치에 처음 나타날 때 createState를 호출합니다. 
  // 부모가 동일한 타입의 위젯(동일한 키)을 다시 빌드하고 사용하는 경우, 
  // 프레임워크는 새 State 객체를 만드는 대신 State 객체를 재사용합니다.

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final _shoppingCart = <Product>{};

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      // 사용자가 장바구니에 있는 내용을 변경하면, 
      // setState 호출 내에서 _shoppingCart를 변경하여 재구축을 트리거해야 합니다. 
      // 그런 다음, 프레임워크는 아래의 build를 호출하여, 앱의 시각적 모양을 업데이트합니다.

      if (!inCart) {
        _shoppingCart.add(product);
      } else {
        _shoppingCart.remove(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: widget.products.map((product) {
          return ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product),
            onCartChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Shopping App',
    home: ShoppingList(
      products: [
        Product(name: 'Eggs'),
        Product(name: 'Flour'),
        Product(name: 'Chocolate chips'),
      ],
    ),
  ));
}
```

`ShoppingList` 클래스는 [`StatefulWidget`][]을 확장합니다. 
즉, 이 위젯은 변경 가능한(mutable) 상태를 저장합니다. 
`ShoppingList` 위젯이 처음 트리에 삽입되면, 프레임워크는 [`createState()`][] 함수를 호출하여 
트리의 해당 위치와 연결할 `_ShoppingListState`의 새 인스턴스를 만듭니다. 
([`State`][]의 하위 클래스는 일반적으로 앞에 밑줄을 붙여서 private 구현 세부 정보임을 나타냅니다.) 
이 위젯의 ​​부모가 다시 빌드되면, 부모는 `ShoppingList`의 새 인스턴스를 만들지만, 
프레임워크는 `createState`를 다시 호출하지 않고, 이미 트리에 있는 `_ShoppingListState` 인스턴스를 재사용합니다.

현재 `ShoppingList`의 속성에 액세스하려면, `_ShoppingListState`가 [`widget`][] 속성을 사용할 수 있습니다. 
부모가 다시 빌드하고 새 `ShoppingList`를 만드는 경우, `_ShoppingListState`가 새 위젯 값으로 다시 빌드됩니다. `widget` 속성이 변경될 때 알림을 받으려면, `oldWidget`이 전달되어 이전 위젯과 현재 위젯을 비교할 수 있는,
[`didUpdateWidget()`][] 함수를 재정의합니다.

`onCartChanged` 콜백을 처리할 때, 
`_ShoppingListState`는 `_shoppingCart`에서 제품을 추가하거나 제거하여, 내부 상태를 변경합니다. (mutates) 
프레임워크에 내부 상태가 변경되었음을 알리기 위해, 해당 호출을 [`setState()`][] 호출로 래핑합니다. 
`setState`를 호출하면 이 위젯이 변경된 것으로 표시(marks as dirty)되고, 
다음에 앱에서 화면을 업데이트해야 할 때 다시 빌드되도록 예약됩니다. 
위젯의 내부 상태를 수정할 때 `setState`를 호출하는 것을 잊으면, 
프레임워크는 위젯이 변경된 것을 알지 못하고 위젯의 [`build()`][] 함수를 호출하지 않을 수 있습니다. 
즉, 사용자 인터페이스가 업데이트되어 변경된 상태를 반영하지 못할 수 있습니다. 
이런 방식으로 상태를 관리하면, 자식 위젯을 만들고 업데이트하기 위한 별도의 코드를 작성할 필요가 없습니다. 
대신, 두 상황을 모두 처리하는, `build` 함수를 구현하기만 하면 됩니다.

## 위젯 수명 주기 이벤트에 응답 {:#responding-to-widget-lifecycle-events}

`StatefulWidget`에서 [`createState()`][]를 호출한 후, 
프레임워크는 새 상태 객체를 트리에 삽입한 다음 상태 객체에서 [`initState()`][]를 호출합니다. 
[`State`][]의 하위 클래스는 `initState`를 재정의하여 한 번만 수행해야 하는 작업을 수행할 수 있습니다.
예를 들어, 애니메이션을 구성하거나 플랫폼 서비스를 구독하려면, `initState`를 재정의합니다. 
`initState`의 구현은 `super.initState`를 호출하는 것으로 시작해야 합니다.

상태 객체가 더 이상 필요하지 않으면, 프레임워크는 상태 객체에서 [`dispose()`][]를 호출합니다. 
정리 작업을 수행하려면, `dispose` 함수를 재정의합니다. 
예를 들어, 타이머를 취소하거나 플랫폼 서비스를 구독 취소하려면 `dispose`를 재정의합니다. 
`dispose`의 구현은 일반적으로 `super.dispose`를 호출하여 끝납니다.

자세한 내용은 [`State`][]를 확인하세요.

## 키 {:#keys}

키를 사용하여, 위젯을 다시 빌드할 때 프레임워크가 다른 위젯과 매치하는 위젯을 제어합니다. 
기본적으로, 프레임워크는 현재 및 이전 빌드의 위젯을 [`runtimeType`][]과 나타나는 순서에 따라 매치합니다. 
키를 사용하는 경우, 프레임워크는 두 위젯이 동일한 [`key`][]와 동일한 `runtimeType`을 가져야 합니다.

키는 동일한 유형의 위젯을 여러 개 빌드하는 위젯에서 가장 유용합니다. 
예를 들어, 보이는 영역을 채우기에 충분한 `ShoppingListItem` 인스턴스를 빌드하는 `ShoppingList` 위젯은 다음과 같습니다.

* 키가 없으면, 현재 빌드의 첫 번째 엔트리는 항상 이전 빌드의 첫 번째 엔트리와 동기화됩니다. 
  의미적으로 리스트의 첫 번째 엔트리가 화면에서 스크롤되어 사라져(scrolled off) 
  뷰포트에 더 이상 표시되지 않더라도 마찬가지입니다.

* 리스트의 각 엔트리에 "의미적(semantic)" 키를 할당하면, 
  프레임워크가 일치하는 의미적 키와 항목을 동기화하여, 
  유사(또는 동일한) 시각적 모양을 제공하기 때문에 무한 리스트가 더 효율적이게 될 수 있습니다. 
  또한, 항목을 의미적으로 동기화하면, stateful 자식 위젯에 보관된 상태가 
  뷰포트의 동일한 숫자 위치(numerical position)에 있는 항목이 아니라 동일한 의미적 항목에 연결된 상태로 유지됩니다.

자세한 내용은 [`Key`][] API를 확인하세요.

## 글로벌 키 {:#global-keys}

글로벌 키를 사용하여 자식 위젯을 고유하게 식별합니다. 
글로벌 키는 형제 간에만 고유하면 되는 로컬 키와 달리, 전체 위젯 계층에서 전역적으로 고유해야 합니다. 
전역적으로 고유하므로, 글로벌 키를 사용하여 위젯과 관련된 상태를 검색할 수 있습니다.

자세한 내용은 [`GlobalKey`][] API를 확인하세요.

[`actions`]: {{api}}/material/AppBar-class.html#actions
[adding interactivity to your Flutter app]: /ui/interactivity
[`AppBar`]: {{api}}/material/AppBar-class.html
[`BoxDecoration`]: {{api}}/painting/BoxDecoration-class.html
[`build()`]: {{api}}/widgets/StatelessWidget/build.html
[building layouts]: /ui/layout
[`Center`]: {{api}}/widgets/Center-class.html
[`Column`]: {{api}}/widgets/Column-class.html
[`Container`]: {{api}}/widgets/Container-class.html
[`createState()`]: {{api}}/widgets/StatefulWidget-class.html#createState
[Cupertino components]: /ui/widgets/cupertino
[`CupertinoApp`]: {{api}}/cupertino/CupertinoApp-class.html
[`CupertinoNavigationBar`]: {{api}}/cupertino/CupertinoNavigationBar-class.html
[`didUpdateWidget()`]: {{api}}/widgets/State-class.html#didUpdateWidget
[`dispose()`]: {{api}}/widgets/State-class.html#dispose
[`Expanded`]: {{api}}/widgets/Expanded-class.html
[`final`]: {{site.dart-site}}/language/variables#final-and-const
[`flex`]: {{api}}/widgets/Expanded-class.html#flex
[`FloatingActionButton`]: {{api}}/material/FloatingActionButton-class.html
[Gestures in Flutter]: /ui/interactivity/gestures
[`GestureDetector`]: {{api}}/widgets/GestureDetector-class.html
[`GlobalKey`]: {{api}}/widgets/GlobalKey-class.html
[`IconButton`]: {{api}}/material/IconButton-class.html
[`initState()`]: {{api}}/widgets/State-class.html#initState
[`key`]: {{api}}/widgets/Widget-class.html#key
[`Key`]: {{api}}/foundation/Key-class.html
[Layouts]: /ui/widgets/layout
[`leading`]: {{api}}/material/AppBar-class.html#leading
[Material Components widgets]: /ui/widgets/material
[Material icons]: https://design.google.com/icons/
[`MaterialApp`]: {{api}}/material/MaterialApp-class.html
[`Navigator`]: {{api}}/widgets/Navigator-class.html
[`onPressed()`]: {{api}}/material/ElevatedButton-class.html#onPressed
[`onTap()`]: {{api}}/widgets/GestureDetector-class.html#onTap
[`Positioned`]: {{api}}/widgets/Positioned-class.html
[`ElevatedButton`]: {{api}}/material/ElevatedButton-class.html
[React]: https://react.dev
[`RenderObject`]: {{api}}/rendering/RenderObject-class.html
[`Row`]: {{api}}/widgets/Row-class.html
[`runApp()`]: {{api}}/widgets/runApp.html
[`runtimeType`]: {{api}}/widgets/Widget-class.html#runtimeType
[`Scaffold`]: {{api}}/material/Scaffold-class.html
[`setState()`]: {{api}}/widgets/State/setState.html
[`Stack`]: {{api}}/widgets/Stack-class.html
[`State`]: {{api}}/widgets/State-class.html
[`StatefulWidget`]: {{api}}/widgets/StatefulWidget-class.html
[`StatelessWidget`]: {{api}}/widgets/StatelessWidget-class.html
[`Text`]: {{api}}/widgets/Text-class.html
[`title`]: {{api}}/material/AppBar-class.html#title
[`widget`]: {{api}}/widgets/State-class.html#widget
[`Widget`]: {{api}}/widgets/Widget-class.html
