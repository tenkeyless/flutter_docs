---
# title: Implement swipe to dismiss
title: 스와이프하여 사라지기(dismiss) 구현
# description: How to implement swiping to dismiss or delete.
description: 스와이프하여 dismiss 하거나 삭제하는 방법.
diff2html: true
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/gestures/dismissible"?>

"스와이프하여 사라지기" 패턴은 많은 모바일 앱에서 일반적입니다. 
예를 들어, 이메일 앱을 작성할 때, 사용자가 이메일 메시지를 스와이프하여 목록에서 삭제할 수 있도록 허용할 수 있습니다.

Flutter는 [`Dismissible`][] 위젯을 제공하여 이 작업을 쉽게 해줍니다. 
다음 단계에 따라 스와이프하여 사라지기를 구현하는 방법을 알아보세요.

  1. 항목 목록을 만듭니다.
  2. 각 항목을 `Dismissible` 위젯으로 래핑합니다.
  3. "남겨두기(leave behind)" 표시기를 제공합니다.

## 1. 항목 목록 만들기 {:#1-create-a-list-of-items}

먼저, 항목 목록을 만듭니다. 
목록을 만드는 방법에 대한 자세한 지침은 [긴 목록으로 작업하기][Working with long lists] 레시피를 따르세요.

### 데이터 소스 생성 {:#create-a-data-source}

이 예에서, 당신은 작업할 20개의 샘플 아이템을 원합니다. 간단하게 하기 위해, 문자열 목록을 생성하세요.

<?code-excerpt "lib/main.dart (Items)"?>
```dart
final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
```

### 데이터 소스를 목록으로 변환 {:#convert-the-data-source-into-a-list}

목록의 각 항목을 화면에 표시합니다. 사용자는 아직 이 항목을 스와이프할 수 없습니다.

<?code-excerpt "lib/step1.dart (ListView)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
    );
  },
)
```

## 2. 각 항목을 Dismissible 위젯으로 래핑 {:#2-wrap-each-item-in-a-dismissible-widget}

이 단계에서는, [`Dismissible`][] 위젯을 사용하여 사용자가 목록에서 항목을 스와이프할 수 있도록 합니다.

사용자가 항목을 스와이프한 후, 목록에서 항목을 제거하고 스낵바를 표시합니다. 
실제 앱에서는, 웹 서비스나 데이터베이스에서 항목을 제거하는 것과 같이, 더 복잡한 논리를 수행해야 할 수도 있습니다.

`itemBuilder()` 함수를 업데이트하여 `Dismissible` 위젯을 반환합니다.

<?code-excerpt "lib/step2.dart (Dismissible)"?>
```dart
itemBuilder: (context, index) {
  final item = items[index];
  return Dismissible(
    // 각 Dismissible에는 Key가 포함되어야 합니다. 
    // Key를 사용하면 Flutter가 위젯을 고유하게 식별할 수 있습니다.
    key: Key(item),
    // 항목을 스와이프한 후(swiped away) 앱에 수행할 작업을 알려주는 함수를 제공합니다.
    onDismissed: (direction) {
      // 데이터 소스에서 항목을 제거합니다.
      setState(() {
        items.removeAt(index);
      });

      // 그런 다음, 스낵바를 보여줍니다.
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$item dismissed')));
    },
    child: ListTile(
      title: Text(item),
    ),
  );
},
```

## 3. "뒤로 남겨진(leave behind)" 지표 제공 {:#3-provide-leave-behind-indicators}

현재 앱에서는, 사용자가 목록에서 항목을 스와이프 하도록 허용하지만, 그럴 때 어떤 일이 일어나는지 시각적으로 표시하지 않습니다. 
항목이 제거되었다는 신호를 제공하려면, 항목을 화면에서 스와이프할 때 "남겨두기(leave behind)" 표시기를 표시합니다. 
이 경우, 표시기는 빨간색 배경입니다.

표시기를 추가하려면, `Dismissible`에 `background` 매개변수를 제공합니다.


```diff2html
--- lib/step2.dart (Dismissible)
+++ lib/main.dart (Dismissible)
@@ -16,6 +16,8 @@
       ScaffoldMessenger.of(context)
           .showSnackBar(SnackBar(content: Text('$item dismissed')));
     },
+    // 항목을 스와이프 하면(swiped away), 빨간색 배경이 표시됩니다.
+    background: Container(color: Colors.red),
     child: ListTile(
       title: Text(item),
     ),
```

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Swipe to Dismiss hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp은 StatefulWidget입니다. 
// 이를 통해 항목이 제거될 때 위젯의 상태를 업데이트할 수 있습니다.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    const title = 'Dismissing Items';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Dismissible(
              // 각 Dismissible에는 Key가 포함되어야 합니다. 
              // Key를 사용하면 Flutter가 위젯을 고유하게 식별할 수 있습니다.
              key: Key(item),
              // 항목을 스와이프한 후(swiped away) 앱에 수행할 작업을 알려주는 함수를 제공합니다.
              onDismissed: (direction) {
                // 데이터 소스에서 항목을 제거합니다.
                setState(() {
                  items.removeAt(index);
                });

                // 그런 다음, 스낵바를 보여줍니다.
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('$item dismissed')));
              },
              // 항목을 스와이프 하면(swiped away), 빨간색 배경이 표시됩니다.
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(item),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/dismissible.gif" alt="Dismissible Demo" class="site-mobile-screenshot" />
</noscript>


[`Dismissible`]: {{site.api}}/flutter/widgets/Dismissible-class.html
[Working with long lists]: /cookbook/lists/long-lists
