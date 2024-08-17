---
# title: Navigate with named routes
title: 이름이 있는 경로로 이동
# description: How to implement named routes for navigating between screens.
description: 화면 간 이동을 위해 명명된 경로를 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/navigation/named_routes"?>

:::note
명명된 경로는 더 이상 대부분의 애플리케이션에 권장되지 않습니다. 
자세한 내용은 [네비게이션 개요][navigation overview] 페이지의 [제한 사항][Limitations]을 참조하세요.
:::

[Limitations]: /ui/navigation#limitations
[navigation overview]: /ui/navigation

[새 화면으로 이동하고 돌아가기][Navigate to a new screen and back] 레시피에서, 
새 경로를 만들고 [`Navigator`][]에 푸시하여 새 화면으로 이동하는 방법을 알아보았습니다.

그러나, 앱의 여러 부분에서 동일한 화면으로 이동해야 하는 경우, 이 방법을 사용하면 코드 중복이 발생할 수 있습니다. 
해결책은 _명명된 경로(named route)_ 를 정의하고, 명명된 경로를 탐색에 사용하는 것입니다.

명명된 경로로 작업하려면, [`Navigator.pushNamed()`][] 함수를 사용합니다. 
이 예제는 원래 레시피의 기능을 복제하여, 다음 단계를 사용하여 명명된 경로를 사용하는 방법을 보여줍니다.

  1. 두 개의 화면을 만듭니다.
  2. 경로를 정의합니다.
  3. `Navigator.pushNamed()`를 사용하여 두 번째 화면으로 이동합니다.
  4. `Navigator.pop()`를 사용하여 첫 번째 화면으로 돌아갑니다.

## 1. 두 개의 화면 만들기 {:#1-create-two-screens}

먼저, 작업할 두 개의 화면을 만듭니다. 
첫 번째 화면에는 두 번째 화면으로 이동하는 버튼이 있습니다. 
두 번째 화면에는 첫 번째 화면으로 돌아가는 버튼이 있습니다.

<?code-excerpt "lib/main_original.dart"?>
```dart
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 탭하면 두 번째 화면으로 이동합니다.
          },
          child: const Text('Launch screen'),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 탭하면 첫 번째 화면으로 돌아갑니다.
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
```

## 2. 경로 정의 {:#2-define-the-routes}

다음으로, [`MaterialApp`][] 생성자에 추가 속성인 `initialRoute`와 `routes` 자체를 제공하여 경로를 정의합니다.

`initialRoute` 속성은 앱이 시작해야 하는 경로를 정의합니다. 
`routes` 속성은 사용 가능한 명명된 경로와 해당 경로로 이동할 때 빌드할 위젯을 정의합니다.

{% comment %}
RegEx removes the trailing comma
{% endcomment %}
<?code-excerpt "lib/main.dart (MaterialApp)" replace="/^\),$/)/g"?>
```dart
MaterialApp(
  title: 'Named Routes Demo',
  // "/"라는 이름의 경로로 앱을 시작합니다. 
  // 이 경우, 앱은 FirstScreen 위젯에서 시작합니다.
  initialRoute: '/',
  routes: {
    // "/" 경로로 이동할 때, FirstScreen 위젯을 빌드합니다.
    '/': (context) => const FirstScreen(),
    // "/second" 경로로 이동할 때, SecondScreen 위젯을 빌드합니다.
    '/second': (context) => const SecondScreen(),
  },
)
```

:::warning
`initialRoute`를 사용할 때, `home` 속성을 정의하지 마세요.
:::

## 3. 두 번째 화면으로 이동 {:#3-navigate-to-the-second-screen}

위젯과 경로가 제자리에 있으면, [`Navigator.pushNamed()`][] 메서드를 사용하여 탐색을 트리거합니다. 
이렇게 하면, Flutter가 `routes` 테이블에 정의된 위젯을 빌드하고 화면을 시작하도록 합니다.

`FirstScreen` 위젯의 `build()` 메서드에서, `onPressed()` 콜백을 업데이트합니다.

{% comment %}
RegEx removes the trailing comma
{% endcomment %}
<?code-excerpt "lib/main.dart (PushNamed)" replace="/,$//g"?>
```dart
// `FirstScreen` 위젯 내에서
onPressed: () {
  // 명명된 경로를 사용하여 두 번째 화면으로 이동합니다.
  Navigator.pushNamed(context, '/second');
}
```

## 4. 첫 번째 화면으로 돌아가기 {:#4-return-to-the-first-screen}

첫 번째 화면으로 돌아가려면, [`Navigator.pop()`][] 함수를 사용하세요.

{% comment %}
RegEx removes the trailing comma
{% endcomment %}
<?code-excerpt "lib/main.dart (Pop)" replace="/,$//g"?>
```dart
// SecondScreen 위젯 내부
onPressed: () {
  // 스택에서 현재 경로를 pop하여, 첫 번째 화면으로 돌아갑니다.
  Navigator.pop(context);
}
```

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Named Routes hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Named Routes Demo',
      // "/"라는 이름의 경로로 앱을 시작합니다. 
      // 이 경우, 앱은 FirstScreen 위젯에서 시작합니다.
      initialRoute: '/',
      routes: {
        // "/" 경로로 이동할 때, FirstScreen 위젯을 빌드합니다.
        '/': (context) => const FirstScreen(),
        // "/second" 경로로 이동할 때, SecondScreen 위젯을 빌드합니다.
        '/second': (context) => const SecondScreen(),
      },
    ),
  );
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          // `FirstScreen` 위젯 내에서
          onPressed: () {
            // 명명된 경로를 사용하여 두 번째 화면으로 이동합니다.
            Navigator.pushNamed(context, '/second');
          },
          child: const Text('Launch screen'),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          // SecondScreen 위젯 내부
          onPressed: () {
            // 스택에서 현재 경로를 pop하여, 첫 번째 화면으로 돌아갑니다.
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/navigation-basics.gif" alt="Navigation Basics Demo" class="site-mobile-screenshot" />
</noscript>


[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[Navigate to a new screen and back]: /cookbook/navigation/navigation-basics
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Navigator.pop()`]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`Navigator.pushNamed()`]: {{site.api}}/flutter/widgets/Navigator/pushNamed.html
