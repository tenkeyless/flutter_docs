---
# title: Handle taps
title: 탭 다루기
# description: How to handle tapping and dragging.
description: 탭과 드래그를 다루는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/gestures/handling_taps/"?>

사용자에게 정보를 표시할 뿐만 아니라, 사용자가 앱과 상호 작용하기를 원합니다. 
탭 및 드래그와 같은 기본 동작에 응답하려면, [`GestureDetector`][] 위젯을 사용하세요.

:::note
자세한 내용을 알아보려면, `GestureDetector` 위젯에 대한 이 짧은 주간 위젯 비디오를 시청하세요.

{% ytEmbed 'WhVXkCFPmK4', 'GestureDetector | 이번 주의 Flutter 위젯' %}
:::

이 레시피는 다음 단계에 따라 탭하면 스낵바를 표시하는 커스텀 버튼을 만드는 방법을 보여줍니다.

  1. 버튼을 만듭니다.
  2. `GestureDetector`에 래핑하여 `onTap()` 콜백을 실행합니다.

<?code-excerpt "lib/main.dart (GestureDetector)" replace="/return //g;/^\);$/)/g"?>
```dart
// GestureDetector는 버튼을 래핑합니다.
GestureDetector(
  // child를 탭하면, 스낵바를 보여줍니다.
  onTap: () {
    const snackBar = SnackBar(content: Text('Tap'));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  },
  // 커스텀 버튼
  child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.lightBlue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Text('My Button'),
  ),
)
```

## Notes {:#notes}

  1. 버튼에 Material 리플 효과를 추가하는 방법에 대한 자세한 내용은 
     [Material 터치 리플 추가][Add Material touch ripples] 레시피를 참조하세요.
  2. 이 예제에서는 커스텀 버튼을 만들지만, 
     Flutter에는 [`ElevatedButton`][], [`TextButton`][], [`CupertinoButton`][]과 같은 
     몇 가지 버튼 구현이 포함되어 있습니다.

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter tap handling hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Gesture Demo';

    return const MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: MyButton(),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    // GestureDetector는 버튼을 래핑합니다.
    return GestureDetector(
      // child를 탭하면, 스낵바를 보여줍니다.
      onTap: () {
        const snackBar = SnackBar(content: Text('Tap'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      // 커스텀 버튼
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('My Button'),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/handling-taps.gif" alt="Handle taps demo" class="site-mobile-screenshot" />
</noscript>

[Add Material touch ripples]: /cookbook/gestures/ripples
[`CupertinoButton`]: {{site.api}}/flutter/cupertino/CupertinoButton-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
