---
# title: Pass arguments to a named route
title: 이름이 있는 경로에 인수 전달
# description: How to pass arguments to a named route.
description: 이름이 지정된 경로에 인수를 전달하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/navigation/navigate_with_arguments"?>

[`Navigator`][]는 공통 식별자(common identifier)를 사용하여 
앱의 모든 부분에서 명명된 경로로 이동하는 기능을 제공합니다. 
어떤 경우에는, 명명된 경로에 인수를 전달해야 할 수도 있습니다. 
예를 들어, `/user` 경로로 이동하고 해당 경로에 사용자에 대한 정보를 전달하고 싶을 수 있습니다.

:::note
명명된 경로는 더 이상 대부분의 애플리케이션에 권장되지 않습니다. 
자세한 내용은, [탐색 개요][navigation overview] 페이지의 [제한 사항][Limitations]을 참조하세요.
:::

[Limitations]: /ui/navigation#limitations
[navigation overview]: /ui/navigation

[`Navigator.pushNamed()`][] 메서드의 `arguments` 매개변수를 사용하여 이 작업을 수행할 수 있습니다. 
[`ModalRoute.of()`][] 메서드를 사용하거나
[`MaterialApp`][] 또는 [`CupertinoApp`][] 생성자에 제공된 [`onGenerateRoute()`][] 함수 내부에서 
인수를 추출합니다.

이 레시피는 다음 단계를 사용하여 `ModalRoute.of()` 및 `onGenerateRoute()`를 사용하여 
명명된 경로에 인수를 전달하고, 인수를 읽는 방법을 보여줍니다.

  1. 전달해야 하는 인수를 정의합니다.
  2. 인수를 추출하는 위젯을 만듭니다.
  3. `routes` 테이블에 위젯을 등록합니다.
  4. 위젯으로 이동합니다.

## 1. 전달해야 할 인수 정의 {:#1-define-the-arguments-you-need-to-pass}

먼저, 새 경로에 전달해야 하는 인수를 정의합니다. 
이 예에서는, 두 가지 데이터를 전달합니다. 
화면의 `title`과 `message`입니다.

두 가지 데이터를 모두 전달하려면, 이 정보를 저장하는 클래스를 만듭니다.

<?code-excerpt "lib/main.dart (ScreenArguments)"?>
```dart
// 인수 매개변수에 어떤 객체라도 전달할 수 있습니다.
// 이 예에서는, 커스터마이즈 가능한 제목과 메시지를 모두 포함하는 클래스를 만듭니다.
class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
```

## 2. 인수를 추출하는 위젯 만들기 {:#2-create-a-widget-that-extracts-the-arguments}

다음으로, `ScreenArguments`에서 `title`과 `message`를 추출하여 표시하는 위젯을 만듭니다. 
`ScreenArguments`에 액세스하려면, [`ModalRoute.of()`][] 메서드를 사용합니다. 
이 메서드는 인수와 함께 현재 경로를 반환합니다.

<?code-excerpt "lib/main.dart (ExtractArgumentsScreen)"?>
```dart
// ModalRoute에서 필요한 인수를 추출하는 위젯입니다.
class ExtractArgumentsScreen extends StatelessWidget {
  const ExtractArgumentsScreen({super.key});

  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // 현재 ModalRoute 설정에서 인수를 추출하여, ScreenArguments로 캐스팅합니다.
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
        child: Text(args.message),
      ),
    );
  }
}
```

## 3. 위젯을 `routes` 테이블에 등록 {:#3-register-the-widget-in-the-routes-table}

다음으로, `MaterialApp` 위젯에 제공된 `routes`에 엔트리를 추가합니다. 
`routes`는 경로의 이름에 따라 어떤 위젯을 만들어야 하는지 정의합니다.

{% comment %}
RegEx removes the return statement and adds the closing parenthesis at the end
{% endcomment %}
<?code-excerpt "lib/main.dart (routes)" plaster="none" replace="/return //g;/^\);$/)/g"?>
```dart
MaterialApp(
  routes: {
    ExtractArgumentsScreen.routeName: (context) =>
        const ExtractArgumentsScreen(),
  },
)
```


## 4. 위젯으로 이동 {:#4-navigate-to-the-widget}

마지막으로, 사용자가 [`Navigator.pushNamed()`][]를 사용하여 버튼을 탭하면, 
`ExtractArgumentsScreen`으로 이동합니다. 
`arguments` 속성을 통해 경로에 인수를 제공합니다. 
`ExtractArgumentsScreen`은 이러한 인수에서 `title`과 `message`를 추출합니다.

<?code-excerpt "lib/main.dart (PushNamed)"?>
```dart
// 명명된 경로로 이동하는 버튼.
// 명명된 경로는 인수를 스스로 추출합니다.
ElevatedButton(
  onPressed: () {
    // 사용자가 버튼을 탭하면, 명명된 경로로 이동하고 인수를 선택적 매개변수로 제공합니다.
    Navigator.pushNamed(
      context,
      ExtractArgumentsScreen.routeName,
      arguments: ScreenArguments(
        'Extract Arguments Screen',
        'This message is extracted in the build method.',
      ),
    );
  },
  child: const Text('Navigate to screen that extracts arguments'),
),
```

## 대안으로, `onGenerateRoute`를 사용하여 인수 추출 {:#alternatively-extract-the-arguments-using-ongenerateroute}

위젯 내부에서 직접 인수를 추출하는 대신, 
[`onGenerateRoute()`][] 함수 내부에서 인수를 추출하여 위젯에 전달할 수도 있습니다.

`onGenerateRoute()` 함수는 주어진 [`RouteSettings`][]에 따라 올바른 경로를 만듭니다.

{% comment %}
RegEx removes the return statement, removed "routes" property and adds the closing parenthesis at the end
{% endcomment %}

```dart
MaterialApp(
  // 명명된 경로를 처리하는 함수를 제공합니다. 
  // 이 함수를 사용하여 푸시되는 명명된 경로를 식별하고, 올바른 화면을 만듭니다.
  onGenerateRoute: (settings) {
    // PassArguments 경로를 푸시하는 경우
    if (settings.name == PassArgumentsScreen.routeName) {
      // 인수를 올바른 타입인 ScreenArguments로 캐스팅합니다.
      final args = settings.arguments as ScreenArguments;

      // 그런 다음, 인수에서 필요한 데이터를 추출하여, 올바른 화면에 데이터를 전달합니다.
      return MaterialPageRoute(
        builder: (context) {
          return PassArgumentsScreen(
            title: args.title,
            message: args.message,
          );
        },
      );
    }
    // 이 코드는 지금 PassArgumentsScreen.routeName만 지원합니다. 
    // 다른 값을 추가하면 구현해야 합니다. 
    // 여기의 assertion은 호출 스택에서 더 높은 것을 상기시키는 데 도움이 될 것입니다. 
    // 그렇지 않으면 이 assertion은 프레임워크 어딘가에서 실행될 것이기 때문입니다.
    assert(false, 'Need to implement ${settings.name}');
    return null;
  },
)
```

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter complete navigation hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ExtractArgumentsScreen.routeName: (context) =>
            const ExtractArgumentsScreen(),
      },
      // 명명된 경로를 처리하는 함수를 제공합니다. 
      // 이 함수를 사용하여 푸시되는 명명된 경로를 식별하고, 올바른 화면을 만듭니다.
      onGenerateRoute: (settings) {
        // PassArguments 경로를 푸시하는 경우
        if (settings.name == PassArgumentsScreen.routeName) {
          // 인수를 올바른 타입인 ScreenArguments로 캐스팅합니다.
          final args = settings.arguments as ScreenArguments;

          // 그런 다음, 인수에서 필요한 데이터를 추출하여, 올바른 화면에 데이터를 전달합니다.
          return MaterialPageRoute(
            builder: (context) {
              return PassArgumentsScreen(
                title: args.title,
                message: args.message,
              );
            },
          );
        }
        // 이 코드는 지금 PassArgumentsScreen.routeName만 지원합니다. 
        // 다른 값을 추가하면 구현해야 합니다. 
        // 여기의 assertion은 호출 스택에서 더 높은 것을 상기시키는 데 도움이 될 것입니다. 
        // 그렇지 않으면 이 assertion은 프레임워크 어딘가에서 실행될 것이기 때문입니다.
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      title: 'Navigation with Arguments',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 명명된 경로로 이동하는 버튼. 
            // 명명된 경로는 인수를 스스로 추출합니다.
            ElevatedButton(
              onPressed: () {
                // 사용자가 버튼을 탭하면, 
                // 명명된 경로로 이동하고 
                // 인수를 선택적 매개변수로서 제공합니다.
                Navigator.pushNamed(
                  context,
                  ExtractArgumentsScreen.routeName,
                  arguments: ScreenArguments(
                    'Extract Arguments Screen',
                    'This message is extracted in the build method.',
                  ),
                );
              },
              child: const Text('Navigate to screen that extracts arguments'),
            ),
            // 명명된 경로로 이동하는 버튼. 
            // 이 경로의 경우, onGenerateRoute 함수에서 
            // 인수를 추출하여 화면에 전달합니다.
            ElevatedButton(
              onPressed: () {
                // 사용자가 버튼을 탭하면, 
                // 명명된 경로로 이동하고 인수를 선택적 매개변수로 제공합니다.
                Navigator.pushNamed(
                  context,
                  PassArgumentsScreen.routeName,
                  arguments: ScreenArguments(
                    'Accept Arguments Screen',
                    'This message is extracted in the onGenerateRoute '
                        'function.',
                  ),
                );
              },
              child: const Text('Navigate to a named that accepts arguments'),
            ),
          ],
        ),
      ),
    );
  }
}

// ModalRoute에서 필요한 인수를 추출하는 위젯입니다.
class ExtractArgumentsScreen extends StatelessWidget {
  const ExtractArgumentsScreen({super.key});

  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // 현재 ModalRoute 설정에서 인수를 추출하여, ScreenArguments로 캐스팅합니다.
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
        child: Text(args.message),
      ),
    );
  }
}

// 생성자를 통해 필요한 인수를 받는 위젯입니다.
class PassArgumentsScreen extends StatelessWidget {
  static const routeName = '/passArguments';

  final String title;
  final String message;

  // 이 위젯은 생성자 매개변수로 인수를 받습니다. 
  // ModalRoute에서 인수를 추출하지 않습니다. 
  // 
  // 인수는 MaterialApp 위젯에 제공된 onGenerateRoute 함수에 의해 추출됩니다.
  const PassArgumentsScreen({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}

// 인수 매개변수에 모든 객체를 전달할 수 있습니다. 
// 이 예에서, 커스터마이즈 가능한 제목과 메시지를 모두 포함하는 클래스를 만듭니다.
//
class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/navigate-with-arguments.gif" alt="Demonstrates navigating to different routes with arguments" class="site-mobile-screenshot" />
</noscript>


[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`ModalRoute.of()`]: {{site.api}}/flutter/widgets/ModalRoute/of.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Navigator.pushNamed()`]: {{site.api}}/flutter/widgets/Navigator/pushNamed.html
[`onGenerateRoute()`]: {{site.api}}/flutter/widgets/WidgetsApp/onGenerateRoute.html
[`RouteSettings`]: {{site.api}}/flutter/widgets/RouteSettings-class.html
