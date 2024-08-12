---
# title: Add Material touch ripples
title: Material 터치 리플(ripples) 추가
# description: How to implement ripple animations.
description: 리플 애니메이션을 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/gestures/ripples/"?>

Material Design 가이드라인을 따르는 위젯은 탭하면 리플 애니메이션을 표시합니다.

Flutter는 이 효과를 수행하기 위해 [`InkWell`][] 위젯을 제공합니다. 
다음 단계에 따라 리플 효과를 만듭니다.

  1. 탭을 지원하는 위젯을 만듭니다.
  2. `InkWell` 위젯에 래핑하여, 탭 콜백과 리플 애니메이션을 관리합니다.

<?code-excerpt "lib/main.dart (InkWell)" replace="/return //g;/^\);$/)/g"?>
```dart
// InkWell은 커스텀 플랫 버튼 위젯을 래핑합니다.
InkWell(
  // 사용자가 버튼을 탭하면, 스낵바를 표시합니다.
  onTap: () {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Tap'),
    ));
  },
  child: const Padding(
    padding: EdgeInsets.all(12),
    child: Text('Flat Button'),
  ),
)
```

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Material ripples hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'InkWell Demo';

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
    // InkWell은 커스텀 플랫 버튼 위젯을 래핑합니다.
    return InkWell(
      // 사용자가 버튼을 탭하면, 스낵바를 표시합니다.
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tap'),
        ));
      },
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Text('Flat Button'),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/ripples.gif" alt="Ripples Demo" class="site-mobile-screenshot" />
</noscript>


[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
