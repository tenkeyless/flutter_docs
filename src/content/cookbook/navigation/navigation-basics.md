---
# title: Navigate to a new screen and back
title: 새 화면으로 이동하고 돌아가기
# description: How to navigate between routes.
description: 경로 간 이동 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/navigation/navigation_basics"?>

대부분의 앱에는 다양한 타입의 정보를 표시하기 위한 여러 화면이 있습니다. 
예를 들어, 앱에는 제품을 표시하는 화면이 있을 수 있습니다. 
사용자가 제품 이미지를 탭하면, 새 화면에 제품에 대한 세부 정보가 표시됩니다.

:::note 용어
Flutter에서는 _화면(screens)_ 과 _페이지(pages)_ 를 _경로(routes)_ 라고 합니다. 
이 레시피의 나머지 부분은 경로를 참조합니다.
:::

Android에서, 경로는 Activity와 동일합니다. 
iOS에서, 경로는 ViewController와 동일합니다. 
Flutter에서, 경로는 위젯일 뿐입니다.

이 레시피는 [`Navigator`][]를 사용하여 새 경로로 이동합니다.

다음 몇 섹션에서는 다음 단계를 사용하여, 두 경로 사이를 탐색하는 방법을 보여줍니다.

1. 두 개의 경로를 만듭니다.
2. `Navigator.push()`를 사용하여 두 번째 경로로 이동합니다.
3. `Navigator.pop()`을 사용하여 첫 번째 경로로 돌아갑니다.

## 1. 두 개의 경로 만들기 {:#1-create-two-routes}

먼저, 작업할 두 개의 경로를 만듭니다. 
이것은 기본적인 예이므로, 각 경로에는 하나의 버튼만 있습니다. 
첫 번째 경로의 버튼을 탭하면, 두 번째 경로로 이동합니다. 
두 번째 경로의 버튼을 탭하면, 첫 번째 경로로 돌아갑니다.

먼저, 시각적 구조를 설정합니다.

<?code-excerpt "lib/main_step1.dart (first-second-routes)"?>
```dart
class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            // 탭하면 두 번째 경로로 이동합니다.
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 탭하면 첫 번째 경로로 돌아갑니다.
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
```

## 2. Navigator.push()를 사용하여 두 번째 경로로 이동 {:#2-navigate-to-the-second-route-using-navigator-push}

새 경로로 전환하려면, [`Navigator.push()`][] 메서드를 사용합니다. 
`push()` 메서드는 `Navigator`가 관리하는 경로 스택에 `Route`를 추가합니다. 
`Route`는 어디에서 왔을까요? 
직접 만들거나, [`MaterialPageRoute`][]를 사용할 수 있습니다. 
이는 플랫폼별 애니메이션을 사용하여 새 경로로 전환하기 때문에 유용합니다.

`FirstRoute` 위젯의 `build()` 메서드에서, `onPressed()` 콜백을 업데이트합니다.

<?code-excerpt "lib/main_step2.dart (first-route-on-pressed)" replace="/^\},$/}/g"?>
```dart
// `FirstRoute` 위젯 내부:
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SecondRoute()),
  );
}
```

## 3. Navigator.pop()를 사용하여 첫 번째 경로로 돌아가기 {:#3-return-to-the-first-route-using-navigator-pop}

두 번째 경로를 닫고 첫 번째 경로로 돌아가려면 어떻게 해야 하나요? 
[`Navigator.pop()`][] 메서드를 사용하면 됩니다. 
`pop()` 메서드는 `Navigator`가 관리하는 경로 스택에서 현재 `Route`를 제거합니다.

원래 경로로 돌아가는 것을 구현하려면, `SecondRoute` 위젯에서 `onPressed()` 콜백을 업데이트합니다.

<?code-excerpt "lib/main_step2.dart (second-route-on-pressed)" replace="/^\},$/}/g"?>
```dart
// SecondRoute 위젯 내부
onPressed: () {
  Navigator.pop(context);
}
```

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter navigation hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondRoute()),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
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

## CupertinoPageRoute를 이용한 네비게이션 {:#navigation-with-cupertinopageroute}

이전 예제에서는 [Material Components][]의 [`MaterialPageRoute`][]를 사용하여, 
화면 간을 탐색하는 방법을 알아보았습니다. 
그러나, Flutter에서는 Material 디자인 언어로 제한되지 않고, 
대신, [Cupertino][](iOS 스타일) 위젯에도 액세스할 수 있습니다.

Cupertino 위젯으로 네비게이션을 구현하는 단계는 [`MaterialPageRoute`][]를 사용할 때와 동일하지만, 
대신, iOS 스타일 전환 애니메이션을 제공하는 [`CupertinoPageRoute`][]를 사용합니다.

다음 예제에서, 이러한 위젯은 대체되었습니다.

- [`MaterialApp`][]이 [`CupertinoApp`][]으로 대체되었습니다.
- [`Scaffold`][]가 [`CupertinoPageScaffold`][]로 대체되었습니다.
- [`ElevatedButton`][]이 [`CupertinoButton`][]으로 대체되었습니다.

이런 방식으로, 예제는 현재 iOS 디자인 언어를 따릅니다.

:::secondary
Flutter에서는 필요에 따라 Material 및 Cupertino 위젯을 혼합하여 사용할 수 있으므로, 
[`CupertinoPageRoute`][]를 사용하기 위해 모든 Material 위젯을 Cupertino 버전으로 바꿀 필요는 없습니다.
:::

<?code-excerpt "lib/main_cupertino.dart"?>
```dartpad title="Flutter Cupertino theme hands-on example in DartPad" run="true"
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const CupertinoApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('First Route'),
      ),
      child: Center(
        child: CupertinoButton(
          child: const Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const SecondRoute()),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Second Route'),
      ),
      child: Center(
        child: CupertinoButton(
          onPressed: () {
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
  <img src="/assets/images/docs/cookbook/navigation-basics-cupertino.gif" alt="Navigation Basics Cupertino Demo" class="site-mobile-screenshot" />
</noscript>

[Cupertino]: {{site.docs}}/ui/widgets/cupertino
[Material Components]: {{site.docs}}/ui/widgets/material
[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`CupertinoButton`]: {{site.api}}/flutter/cupertino/CupertinoButton-class.html
[`CupertinoPageRoute`]: {{site.api}}/flutter/cupertino/CupertinoPageRoute-class.html
[`CupertinoPageScaffold`]: {{site.api}}/flutter/cupertino/CupertinoPageScaffold-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`MaterialPageRoute`]: {{site.api}}/flutter/material/MaterialPageRoute-class.html
[`Navigator.pop()`]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`Navigator.push()`]: {{site.api}}/flutter/widgets/Navigator/push.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
