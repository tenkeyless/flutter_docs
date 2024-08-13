---
# title: Create a horizontal list
title: horizontal 리스트 만들기
# description: How to implement a horizontal list.
description: horizontal 리스트를 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/horizontal_list"?>

수직(vertically) 방향이 아닌 수평(horizontally) 방향으로 스크롤되는 리스트를 만들고 싶을 수도 있습니다. 
[`ListView`][] 위젯은 수평(horizontal) 리스트를 지원합니다.

표준 `ListView` 생성자를 사용하여, horizontal `scrollDirection`을 전달하면, 기본 vertical 방향을 재정의합니다.

<?code-excerpt "lib/main.dart (ListView)" replace="/^child\: //g"?>
```dart
ListView(
  // 다음 줄이 그 요령입니다.
  scrollDirection: Axis.horizontal,
  children: <Widget>[
    Container(
      width: 160,
      color: Colors.red,
    ),
    Container(
      width: 160,
      color: Colors.blue,
    ),
    Container(
      width: 160,
      color: Colors.green,
    ),
    Container(
      width: 160,
      color: Colors.yellow,
    ),
    Container(
      width: 160,
      color: Colors.orange,
    ),
  ],
),
```

## 대화형 예제 {:#interactive-example}

:::note 데스크탑 및 웹 노트
이 예는 브라우저와 데스크톱에서 작동합니다. 
그러나, 이 리스트가 수평 축(왼쪽에서 오른쪽 또는 오른쪽에서 왼쪽)으로 스크롤될 때, 
<kbd>Shift</kbd>를 누른 채로 마우스 스크롤 휠을 사용하여 리스트를 스크롤합니다.

자세한 내용은, 스크롤링 장치의 기본 드래그에 대한 [중요 변경 사항][breaking change] 페이지를 읽어보세요.
:::

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter horizontal list hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Horizontal List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: 200,
          child: ListView(
            // 다음 줄이 그 요령입니다.
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: 160,
                color: Colors.red,
              ),
              Container(
                width: 160,
                color: Colors.blue,
              ),
              Container(
                width: 160,
                color: Colors.green,
              ),
              Container(
                width: 160,
                color: Colors.yellow,
              ),
              Container(
                width: 160,
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/horizontal-list.gif" alt="Horizontal List Demo" class="site-mobile-screenshot" />
</noscript>

[breaking change]: /release/breaking-changes/default-scroll-behavior-drag
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
