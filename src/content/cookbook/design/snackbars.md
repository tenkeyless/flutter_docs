---
# title: Display a snackbar
title: 스낵바 표시
# description: How to implement a snackbar to display messages.
description: 메시지를 표시하기 위해 스낵바를 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/design/snackbars/"?>

특정 작업이 수행될 때 사용자에게 간단히 알리는 것이 유용할 수 있습니다. 
예를 들어, 사용자가 리스트에서 메시지를 스와이프(swipes away)하면, 메시지가 삭제되었음을 알리고 싶을 수 있습니다. 
작업을 취소하는 옵션을 제공하고 싶을 수도 있습니다.

Material Design에서, 이는 [`SnackBar`][]의 작업입니다. 
이 레시피는 다음 단계를 사용하여 스낵바를 구현합니다.

  1. `Scaffold`를 만듭니다.
  2. `SnackBar`를 표시합니다.
  3. 선택적 작업을 제공합니다.

## 1. `Scaffold` 만들기 {:#1-create-a-scaffold}

Material Design 가이드라인을 따르는 앱을 만들 때는, 앱에 일관된 시각적 구조를 제공하세요. 
이 예제에서는, `SnackBar`를 화면 하단에 표시하고, 
`FloatingActionButton`과 같은 다른 중요한 위젯을 겹치지 않게 하세요.

[material 라이브러리][material library]의 [`Scaffold`][] 위젯은, 
이러한 시각적 구조를 만들고 중요한 위젯이 겹치지 않도록 합니다.

<?code-excerpt "lib/partial.dart (Scaffold)"?>
```dart
return MaterialApp(
  title: 'SnackBar Demo',
  home: Scaffold(
    appBar: AppBar(
      title: const Text('SnackBar Demo'),
    ),
    body: const SnackBarPage(),
  ),
);
```

## 2. `SnackBar` 디스플레이 {:#2-display-a-snackbar}

`Scaffold`가 제자리에 있으면, `SnackBar`를 표시합니다. 
먼저, `SnackBar`를 만든 다음, `ScaffoldMessenger`를 사용하여 표시합니다.

<?code-excerpt "lib/partial.dart (DisplaySnackBar)"?>
```dart
const snackBar = SnackBar(
  content: Text('Yay! A SnackBar!'),
);

// 위젯 트리에서 ScaffoldMessenger를 찾아 SnackBar를 표시합니다.
ScaffoldMessenger.of(context).showSnackBar(snackBar);
```

:::note
자세한 내용을 알아보려면, `ScaffoldMessenger` 위젯에 대한 이 짧은 주간 위젯 비디오를 시청하세요.

{% ytEmbed 'lytQi-slT5Y', 'ScaffoldMessenger | 이번 주의 Flutter 위젯' %}
:::

## 3. Provide an optional action {:#3-provide-an-optional-action}

SnackBar가 표시될 때, 사용자에게 동작을 제공하고 싶을 수 있습니다. 
예를 들어, 사용자가 실수로 메시지를 삭제한 경우, SnackBar에서 선택적 동작을 사용하여 메시지를 복구할 수 있습니다.

다음은 `SnackBar` 위젯에 추가 `action`을 제공하는 예입니다.

<?code-excerpt "lib/main.dart (SnackBarAction)"?>
```dart
final snackBar = SnackBar(
  content: const Text('Yay! A SnackBar!'),
  action: SnackBarAction(
    label: 'Undo',
    onPressed: () {
      // 변경 사항을 취소하는 코드입니다.
    },
  ),
);
```

## 상호 작용 예제 {:#interactive-example}

:::note
이 예제에서는, SnackBar는 사용자가 버튼을 탭하면 표시됩니다.
사용자 입력 작업에 대한 자세한 내용은, 쿡북의 [Gestures][] 섹션을 참조하세요.
:::

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter snackbar hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const SnackBarDemo());

class SnackBarDemo extends StatelessWidget {
  const SnackBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackBar Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SnackBar Demo'),
        ),
        body: const SnackBarPage(),
      ),
    );
  }
}

class SnackBarPage extends StatelessWidget {
  const SnackBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: const Text('Yay! A SnackBar!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // 변경 사항을 취소하는 코드입니다.
              },
            ),
          );

          // 위젯 트리에서 ScaffoldMessenger를 찾아 SnackBar를 표시합니다.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: const Text('Show SnackBar'),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/snackbar.gif" alt="SnackBar Demo" class="site-mobile-screenshot" />
</noscript>

[Gestures]: /cookbook#gestures
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[`SnackBar`]: {{site.api}}/flutter/material/SnackBar-class.html
[material library]: {{site.api}}/flutter/material/material-library.html
