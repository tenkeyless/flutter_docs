---
# title: Use lists
title: 리스트 사용
# description: How to implement a list.
description: 리스트를 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/basic_list"?>

데이터 리스트를 표시하는 것은 모바일 앱의 기본 패턴입니다. 
Flutter에는 리스트 작업을 쉽게 하기 위해 [`ListView`][] 위젯이 포함되어 있습니다.

## ListView 생성 {:#create-a-listview}

표준 `ListView` 생성자를 사용하는 것은 몇 개의 아이템만 포함하는 리스트에 적합합니다. 
내장된 [`ListTile`][] 위젯은 아이템에 시각적 구조를 제공하는 방법입니다.

<?code-excerpt "lib/main.dart (ListView)" replace="/^body\: //g"?>
```dart
ListView(
  children: const <Widget>[
    ListTile(
      leading: Icon(Icons.map),
      title: Text('Map'),
    ),
    ListTile(
      leading: Icon(Icons.photo_album),
      title: Text('Album'),
    ),
    ListTile(
      leading: Icon(Icons.phone),
      title: Text('Phone'),
    ),
  ],
),
```

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter lists hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Basic List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView(
          children: const <Widget>[
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Map'),
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('Album'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone'),
            ),
          ],
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/basic-list.png" alt="Basic List Demo" class="site-mobile-screenshot" /> 
</noscript>


[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
