---
# title: Create lists with different types of items
title: 다양한 타입의 아이템으로 리스트 만들기
# description: How to implement a list that contains different types of assets.
description: 다양한 타입의 애셋을 포함하는 리스트를 구현하는 방법입니다.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/mixed_list/"?>

다양한 타입의 콘텐츠를 표시하는 리스트를 만들어야 할 수도 있습니다. 
예를 들어, 제목 다음에 제목과 관련된 몇 가지 아이템이 이어지고, 
그 다음에 다른 제목이 이어지는 리스트를 작업하고 있을 수 있습니다.

Flutter로 이러한 구조를 만드는 방법은 다음과 같습니다.

  1. 다양한 타입의 아이템이 있는 데이터 소스를 만듭니다.
  2. 데이터 소스를 위젯 리스트로 변환합니다.

## 1. 다양한 타입의 아이템을 포함하는 데이터 소스 만들기 {:#1-create-a-data-source-with-different-types-of-items}

### 아이템 타입 {:#types-of-items}

리스트에서 다양한 타입의 아이템을 나타내려면, 각 타입의 아이템에 대한 클래스를 정의합니다.

이 예에서는, 헤더와 5개의 메시지를 표시하는 앱을 만듭니다. 
따라서, `ListItem`, `HeadingItem`, `MessageItem`의 세 가지 클래스를 만듭니다.

<?code-excerpt "lib/main.dart (ListItem)"?>
```dart
/// 리스트에 포함될 수 있는 다양한 타입의 아이템에 대한 베이스 클래스입니다.
abstract class ListItem {
  /// 리스트 아이템에 표시할 제목 줄입니다.
  Widget buildTitle(BuildContext context);

  /// 리스트 아이템에 표시할, 부제 줄(있는 경우)입니다.
  Widget buildSubtitle(BuildContext context);
}

/// 제목을 표시하기 위한 데이터가 포함된 ListItem입니다.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// 메시지를 표시하기 위한 데이터가 들어있는 ListItem입니다.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}
```

### 아이템들의 리스트 만들기 {:#create-a-list-of-items}

대부분의 경우, 인터넷이나 로컬 데이터베이스에서 데이터를 가져와서 해당 데이터를 아이템들의 리스트로 변환합니다.

이 예에서는, 작업할 아이템들의 리스트를 생성합니다. 리스트에는 헤더와 5개의 메시지가 포함됩니다. 
각 메시지에는 `ListItem`, `HeadingItem` 또는 `MessageItem`의 3가지 타입 중 하나가 있습니다.

<?code-excerpt "lib/main.dart (Items)" replace="/^items:/final items =/g;/^\),$/);/g"?>
```dart
final items = List<ListItem>.generate(
  1000,
  (i) => i % 6 == 0
      ? HeadingItem('Heading $i')
      : MessageItem('Sender $i', 'Message body $i'),
);
```

## 2. 데이터 소스를 위젯 리스트로 변환 {:#2-convert-the-data-source-into-a-list-of-widgets}

각 아이템을 위젯으로 변환하려면, [`ListView.builder()`][] 생성자를 사용합니다.

일반적으로, 어떤 타입의 아이템을 다루고 있는지 확인하고, 해당 타입의 아이템에 적합한 위젯을 반환하는 빌더 함수를 제공합니다.

<?code-excerpt "lib/main.dart (builder)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  // ListView에게 작성해야 할 아이템의 수를 알려줍니다.
  itemCount: items.length,
  // 빌더 함수를 제공합니다. 여기서 마법이 일어납니다.
  // 각 아이템을 아이템의 타입에 따라 위젯으로 변환합니다.
  itemBuilder: (context, index) {
    final item = items[index];

    return ListTile(
      title: item.buildTitle(context),
      subtitle: item.buildSubtitle(context),
    );
  },
)
```

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter create mixed lists hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(
      items: List<ListItem>.generate(
        1000,
        (i) => i % 6 == 0
            ? HeadingItem('Heading $i')
            : MessageItem('Sender $i', 'Message body $i'),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<ListItem> items;

  const MyApp({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const title = 'Mixed List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          // ListView에게 작성해야 할 아이템의 수를 알려줍니다.
          itemCount: items.length,
          // 빌더 함수를 제공합니다. 여기서 마법이 일어납니다.
          // 각 아이템을 아이템의 타입에 따라 위젯으로 변환합니다.
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          },
        ),
      ),
    );
  }
}

/// 리스트에 포함될 수 있는 다양한 타입의 아이템에 대한 베이스 클래스입니다.
abstract class ListItem {
  /// 리스트 아이템에 표시할 제목 줄입니다.
  Widget buildTitle(BuildContext context);

  /// 리스트 아이템에 표시할, 부제 줄(있는 경우)입니다.
  Widget buildSubtitle(BuildContext context);
}

/// 제목을 표시하기 위한 데이터가 포함된 ListItem입니다.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// 메시지를 표시하기 위한 데이터가 들어있는 ListItem입니다.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/mixed-list.png" alt="Mixed list demo" class="site-mobile-screenshot" />
</noscript>


[`ListView.builder()`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
