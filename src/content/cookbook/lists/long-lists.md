---
# title: Work with long lists
title: 긴 리스트로 작업하기
# description: Use ListView.builder to implement a long or infinite list.
description: ListView.builder를 사용하여 길거나 무한한 리스트를 구현합니다.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/long_lists/"?>

표준 [`ListView`][] 생성자는 작은 리스트에 적합합니다. 
많은 수의 아이템이 포함된 리스트를 사용하려면, [`ListView.builder`][] 생성자를 사용하는 것이 가장 좋습니다.

모든 아이템을 한 번에 만들어야 하는, 기본 `ListView` 생성자와 달리, 
`ListView.builder()` 생성자는 아이템이 화면으로 스크롤될 때 아이템을 만듭니다.

## 1. 데이터 소스 생성 {:#1-create-a-data-source}

먼저, 데이터 소스가 필요합니다. 
예를 들어, 데이터 소스는 메시지 리스트, 검색 결과 또는 매장의 제품일 수 있습니다. 
대부분의 경우, 이 데이터는 인터넷이나 데이터베이스에서 제공됩니다.

이 예에서는, [`List.generate`][] 생성자를 사용하여 10,000개의 문자열 리스트를 생성합니다.

<?code-excerpt "lib/main.dart (Items)" replace="/^items: //g"?>
```dart
List<String>.generate(10000, (i) => 'Item $i'),
```

## 2. 데이터 소스를 위젯으로 변환 {:#2-convert-the-data-source-into-widgets}

문자열 리스트를 표시하려면, `ListView.builder()`를 사용하여 각 문자열을 위젯으로 렌더링합니다. 
이 예에서는, 각 문자열을 개별 줄에 표시합니다.

<?code-excerpt "lib/main.dart (ListView)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: items.length,
  prototypeItem: ListTile(
    title: Text(items.first),
  ),
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
    );
  },
)
```

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter create long list hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(
      items: List<String>.generate(10000, (i) => 'Item $i'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<String> items;

  const MyApp({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const title = 'Long List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          prototypeItem: ListTile(
            title: Text(items.first),
          ),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
            );
          },
        ),
      ),
    );
  }
}
```

## 자식들의 범위 (Children's extent) {:#childrens-extent}

각 아이템의 범위를 지정하려면, 
[`prototypeItem`][], [`itemExtent`][] 또는 [`itemExtentBuilder`][]를 사용할 수 있습니다.

둘 중 하나를 지정하는 것이 자식이 스스로 범위를 결정하도록 하는 것보다 효율적입니다. 
스크롤링 기계가 자식의 범위에 대한 사전 지식을 활용하여 작업을 절약할 수 있기 때문입니다. 
예를 들어, 스크롤 위치가 크게 변경될 때 말입니다.

리스트에 고정된 크기의 아이템이 있는 경우, [`prototypeItem`][] 또는 [`itemExtent`][]를 사용합니다.

리스트에 크기가 다른 아이템이 있는 경우, [`itemExtentBuilder`][]를 사용합니다.

<noscript>
  <img src="/assets/images/docs/cookbook/long-lists.gif" alt="Long Lists Demo" class="site-mobile-screenshot" />
</noscript>

[`List.generate`]: {{site.api}}/flutter/dart-core/List/List.generate.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[`prototypeItem`]: {{site.api}}/flutter/widgets/ListView/prototypeItem.html
[`itemExtent`]: {{site.api}}/flutter/widgets/ListView/itemExtent.html
[`itemExtentBuilder`]: {{site.api}}/flutter/widgets/ListView/itemExtentBuilder.html
