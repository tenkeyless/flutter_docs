---
# title: Handle scrolling
title: 스크롤 처리
# description: How to handle scrolling in a widget test.
description: 위젯 테스트에서 스크롤을 처리하는 방법.
---

<?code-excerpt path-base="cookbook/testing/widget/scrolling/"?>

이메일 클라이언트부터 음악 앱에 이르기까지, 많은 앱은 콘텐츠 리스트를 제공합니다. 
위젯 테스트를 사용하여 리스트에 예상 콘텐츠가 포함되어 있는지 확인하려면, 
목록을 스크롤하여 특정 항목을 검색할 방법이 필요합니다.

통합 테스트를 통해 목록을 스크롤하려면, 
[`flutter_test`][] 패키지에 포함된 [`WidgetTester`][] 클래스에서 제공하는 메서드를 사용합니다.

이 레시피에서는, 특정 위젯이 표시되는지 확인하기 위해, 아이템 리스트를 스크롤하는 방법과 다양한 접근 방식의 장단점을 알아봅니다.

이 레시피는 다음 단계를 사용합니다.

1. 아이템 리스트가 있는 앱을 만듭니다.
2. 리스트를 스크롤하는 테스트를 작성합니다.
3. 테스트를 실행합니다.

## 1. 아이템 리스트가 있는 앱 만들기 {:#1-create-an-app-with-a-list-of-items}

이 레시피는 긴 아이템 리스트를 보여주는 앱을 빌드합니다. 
이 레시피를 테스트에 집중시키려면, [긴 리스트로 작업][Work with long lists] 레시피에서 만든 앱을 사용하세요. 
긴 리스트로 작업하는 방법을 잘 모르겠다면, 해당 레시피에서 소개를 참조하세요.

통합 테스트 내에서 상호 작용하려는 위젯에 키를 추가합니다.

<?code-excerpt "lib/main.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(
    items: List<String>.generate(10000, (i) => 'Item $i'),
  ));
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
          // ListView에 키를 추가합니다. 
          // 이렇게 하면 테스트에서 리스트를 찾고 스크롤할 수 있습니다.
          key: const Key('long_list'),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                items[index],
                // 각 아이템에 대한 Text 위젯에 키를 추가합니다. 
                // 이렇게 하면 리스트에서 특정 아이템을 찾고 텍스트가 올바른지 확인할 수 있습니다.
                key: Key('item_${index}_text'),
              ),
            );
          },
        ),
      ),
    );
  }
}
```


## 2. 리스트를 스크롤하는 테스트 작성 {:#2-write-a-test-that-scrolls-through-the-list}

이제, 테스트를 작성할 수 있습니다. 
이 예에서, 아이템 리스트를 스크롤하여 리스트에 특정 아이템이 있는지 확인합니다. 
[`WidgetTester`][] 클래스는 특정 위젯이 표시될 때까지 리스트를 스크롤하는 
[`scrollUntilVisible()`][] 메서드를 제공합니다. 
이는 리스트에 있는 아이템의 높이가 기기에 따라 변경될 수 있기 때문에 유용합니다.

리스트에 있는 모든 아이템의 높이를 알고 있다고 가정하거나, 
특정 위젯이 모든 기기에서 렌더링된다고 가정하는 대신, 
`scrollUntilVisible()` 메서드는 찾고 있는 아이템을 찾을 때까지 아이템 리스트를 반복적으로 스크롤합니다.

다음 코드는 `scrollUntilVisible()` 메서드를 사용하여 리스트에서 특정 아이템을 찾는 방법을 보여줍니다. 
이 코드는 `test/widget_test.dart`라는 파일에 있습니다.

<?code-excerpt "test/widget_test.dart (ScrollWidgetTest)"?>
```dart

// 이것은 기본적인 Flutter 위젯 테스트입니다.
//
// 테스트에서 위젯과 상호작용을 수행하려면, 
// Flutter에서 제공하는 WidgetTester 유틸리티를 사용합니다. 
// 예를 들어, 탭 및 스크롤 제스처를 보낼 수 있습니다. 
// WidgetTester를 사용하여 위젯 트리에서 
// child 위젯을 찾고, 텍스트를 읽고, 위젯 속성 값이 올바른지 확인할 수도 있습니다.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scrolling/main.dart';

void main() {
  testWidgets('finds a deep item in a long list', (tester) async {
    // 앱을 빌드하고 프레임을 트리거합니다.
    await tester.pumpWidget(MyApp(
      items: List<String>.generate(10000, (i) => 'Item $i'),
    ));

    final listFinder = find.byType(Scrollable);
    final itemFinder = find.byKey(const ValueKey('item_50_text'));

    // 찾으려는 아이템이 나타날 때까지 스크롤하세요.
    await tester.scrollUntilVisible(
      itemFinder,
      500.0,
      scrollable: listFinder,
    );

    // 아이템에 올바른 텍스트가 포함되어 있는지 확인하세요.
    expect(itemFinder, findsOneWidget);
  });
}
```

## 3. 테스트 실행 {:#3-run-the-test}

프로젝트 루트에서 다음 명령을 사용하여 테스트를 실행합니다.

```console
flutter test test/widget_test.dart
```

[`flutter_test`]: {{site.api}}/flutter/flutter_test/flutter_test-library.html
[`WidgetTester`]: {{site.api}}/flutter/flutter_test/WidgetTester-class.html
[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[`scrollUntilVisible()`]: {{site.api}}/flutter/flutter_test/WidgetController/scrollUntilVisible.html
[Work with long lists]: /cookbook/lists/long-lists
