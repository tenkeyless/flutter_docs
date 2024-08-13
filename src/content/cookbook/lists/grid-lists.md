---
# title: Create a grid list
title: 그리드 리스트 만들기
# description: How to implement a grid list.
description: 그리드 리스트를 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/grid_lists"?>

어떤 경우에는, 아이템을 차례로 나열하는 일반적인 리스트가 아닌, 그리드로 표시하고 싶을 수 있습니다. 
이 작업의 경우, [`GridView`][] 위젯을 사용합니다.

그리드 사용을 시작하는 가장 간단한 방법은 [`GridView.count()`][] 생성자를 사용하는 것입니다. 
이 생성자를 사용하면 원하는 행이나 열의 수를 지정할 수 있기 때문입니다.

`GridView`가 어떻게 작동하는지 시각화하기 위해, 리스트에 인덱스를 표시하는 100개 위젯의 리스트를 생성합니다.

<?code-excerpt "lib/main.dart (GridView)" replace="/^body\: //g"?>
```dart
GridView.count(
  // 2개의 열로 된 그리드를 만듭니다. 
  // scrollDirection을 수평으로 변경하면, 2개의 행이 생성됩니다.
  crossAxisCount: 2,
  // 리스트에 인덱스를 표시하는 100개의 위젯을 생성합니다.
  children: List.generate(100, (index) {
    return Center(
      child: Text(
        'Item $index',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }),
),
```

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter GridView hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Grid List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: GridView.count(
          // 2개의 열로 된 그리드를 만듭니다. 
          // scrollDirection을 수평으로 변경하면, 2개의 행이 생성됩니다.
          crossAxisCount: 2,
          // 리스트에 인덱스를 표시하는 100개의 위젯을 생성합니다.
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/grid-list.gif" alt="Grid List Demo" class="site-mobile-screenshot" />
</noscript>

[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`GridView.count()`]: {{site.api}}/flutter/widgets/GridView/GridView.count.html
