---
# title: Tap, drag, and enter text
title: 탭, 드래그, 텍스트 입력
# description: How to test widgets for user interaction.
description: 위젯의 사용자 상호작용을 테스트하는 방법.
---

<?code-excerpt path-base="cookbook/testing/widget/tap_drag/"?>

{% assign api = site.api | append: '/flutter' -%}

많은 위젯은 정보를 표시할 뿐만 아니라, 사용자 상호작용에 응답합니다. 
여기에는 탭할 수 있는 버튼과 텍스트를 입력하기 위한 [`TextField`][]가 포함됩니다.

이러한 상호작용을 테스트하려면, 테스트 환경에서 이를 시뮬레이션할 방법이 필요합니다. 
이를 위해, [`WidgetTester`][] 라이브러리를 사용하세요.

`WidgetTester`는 텍스트 입력, 탭, 드래그를 위한 메서드를 제공합니다.

* [`enterText()`][]
* [`tap()`][]
* [`drag()`][]

대부분의 경우, 사용자 상호작용은 앱의 상태를 업데이트합니다. 
테스트 환경에서, Flutter는 상태가 변경될 때 위젯을 자동으로 다시 빌드하지 않습니다. 
사용자 상호작용을 시뮬레이션한 후 위젯 트리가 다시 빌드되도록 하려면,
`WidgetTester`에서 제공하는 [`pump()`][] 또는 [`pumpAndSettle()`][] 메서드를 호출하세요. 
이 레시피는 다음 단계를 사용합니다.

  1. 테스트할 위젯을 만듭니다.
  2. 텍스트 필드에 텍스트를 입력합니다.
  3. 버튼을 탭하면 todo가 추가되는지 확인합니다.
  4. 스와이프하여 해제하면(swipe-to-dismiss) todo가 제거되는지 확인합니다.

## 1. 테스트할 위젯 만들기 {:#1-create-a-widget-to-test}

이 예제에서는, 세 가지 기능을 테스트하는 기본 todo 앱을 만듭니다.

  1. `TextField`에 텍스트 입력.
  2. `FloatingActionButton`을 탭하여 텍스트를 todo 리스트에 추가.
  3. 스와이프하여(Swiping-to-dismiss) 리스트에서 아이템 제거.

테스트에 집중하기 위해, 이 레시피에서는 todo 앱을 빌드하는 방법에 대한 자세한 가이드를 제공하지 않습니다. 
이 앱이 어떻게 빌드되는지 자세히 알아보려면 관련 레시피를 참조하세요.

* [텍스트 필드 만들기 및 스타일 지정][Create and style a text field]
* [탭 처리][Handle taps]
* [기본 리스트 만들기][Create a basic list]
* [스와이프하여 닫기 구현][Implement swipe to dismiss]

<?code-excerpt "test/main_test.dart (TodoList)"?>
```dart
class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  static const _appTitle = 'Todo List';
  final todos = <String>[];
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_appTitle),
        ),
        body: Column(
          children: [
            TextField(
              controller: controller,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];

                  return Dismissible(
                    key: Key('$todo$index'),
                    onDismissed: (direction) => todos.removeAt(index),
                    background: Container(color: Colors.red),
                    child: ListTile(title: Text(todo)),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              todos.add(controller.text);
              controller.clear();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

## 2. 텍스트 필드에 텍스트를 입력 {:#2-enter-text-in-the-text-field}

이제 todo 앱이 있으니 테스트를 작성하기 시작합니다. 
`TextField`에 텍스트를 입력하여 시작합니다.

다음을 통해 이 작업을 수행합니다.

  1. 테스트 환경에서 위젯을 빌드합니다.
  2. `WidgetTester`에서 [`enterText()`][] 메서드를 사용합니다.

<?code-excerpt "test/main_steps.dart (TestWidgetStep2)"?>
```dart
testWidgets('Add and remove a todo', (tester) async {
  // 위젯을 빌드하세요.
  await tester.pumpWidget(const TodoList());

  // TextField에 'hi'를 입력하세요.
  await tester.enterText(find.byType(TextField), 'hi');
});
```

:::note
이 레시피는 이전 위젯 테스트 레시피를 기반으로 합니다. 
위젯 테스트의 핵심 개념을 알아보려면, 다음 레시피를 참조하세요.

* [위젯 테스트 소개][Introduction to widget testing]
* [위젯 테스트에서 위젯 찾기][Finding widgets in a widget test]
:::

## 3. 버튼을 탭하면 todo가 추가되는지 확인 {:#3-ensure-tapping-a-button-adds-the-todo}

`TextField`에 텍스트를 입력한 후, `FloatingActionButton`을 탭하면 아이템이 리스트에 추가되는지 확인합니다.

여기에는 세 단계가 포함됩니다.

  1. [`tap()`][] 메서드를 사용하여 추가 버튼을 탭합니다.
  2. [`pump()`][] 메서드를 사용하여 상태가 변경된 후 위젯을 다시 빌드합니다.
  3. 리스트 아이템이 화면에 나타나는지 확인합니다.

<?code-excerpt "test/main_steps.dart (TestWidgetStep3)"?>
```dart
testWidgets('Add and remove a todo', (tester) async {
  // 텍스트 코드를 입력하세요...

  // 추가 버튼을 탭하세요.
  await tester.tap(find.byType(FloatingActionButton));

  // 상태가 변경된 후 위젯을 다시 빌드합니다.
  await tester.pump();

  // 해당 항목이 화면에 표시될 것으로 예상하세요.
  expect(find.text('hi'), findsOneWidget);
});
```

## 4. 스와이프하여 해제하면(swipe-to-dismiss) todo가 제거되는지 확인 {:#4-ensure-swipe-to-dismiss-removes-the-todo}

마지막으로, todo 아이템에서 스와이프하여 닫기(swipe-to-dismiss) 동작을 수행하면, 리스트에서 제거되는지 확인합니다. 
여기에는 세 단계가 포함됩니다.

  1. [`drag()`][] 메서드를 사용하여, 스와이프하여 닫기(swipe-to-dismiss) 동작을 수행합니다.
  2. [`pumpAndSettle()`][] 메서드를 사용하여 닫기(dismiss) 애니메이션이 완료될 때까지 
     위젯 트리를 지속적으로 재구성합니다.
  3. 아이템이 더 이상 화면에 나타나지 않는지 확인합니다.

<?code-excerpt "test/main_steps.dart (TestWidgetStep4)"?>
```dart
testWidgets('Add and remove a todo', (tester) async {
  // 텍스트를 입력하고 아이템을 추가하세요...

  // 해당 아이템을 스와이프해서 dismiss 하세요.
  await tester.drag(find.byType(Dismissible), const Offset(500, 0));

  // 위젯을 dismiss 하는 애니메이션이 끝날 때까지 빌드합니다.
  await tester.pumpAndSettle();

  // 해당 아이템이 더 이상 화면에 없는지 확인하세요.
  expect(find.text('hi'), findsNothing);
});
```

## 완성된 예제 {:#complete-example}

<?code-excerpt "test/main_test.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add and remove a todo', (tester) async {
    // 위젯을 빌드합니다.
    await tester.pumpWidget(const TodoList());

    // TextField에 'hi'를 입력하세요.
    await tester.enterText(find.byType(TextField), 'hi');

    // 추가 버튼을 탭하세요.
    await tester.tap(find.byType(FloatingActionButton));

    // 새 아이템과 함께 위젯을 다시 빌드합니다.
    await tester.pump();

    // 해당 아이템이 화면에 표시될 것으로 예상하세요.
    expect(find.text('hi'), findsOneWidget);

    // 해당 항목을 스와이프해서 dismiss 하세요.
    await tester.drag(find.byType(Dismissible), const Offset(500, 0));

    // 위젯을 dismiss 하는 애니메이션이 끝날 때까지 빌드합니다.
    await tester.pumpAndSettle();

    // 해당 아이템이 더 이상 화면에 없는지 확인하세요.
    expect(find.text('hi'), findsNothing);
  });
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  static const _appTitle = 'Todo List';
  final todos = <String>[];
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_appTitle),
        ),
        body: Column(
          children: [
            TextField(
              controller: controller,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];

                  return Dismissible(
                    key: Key('$todo$index'),
                    onDismissed: (direction) => todos.removeAt(index),
                    background: Container(color: Colors.red),
                    child: ListTile(title: Text(todo)),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              todos.add(controller.text);
              controller.clear();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

[Create a basic list]: /cookbook/lists/basic-list
[Create and style a text field]: /cookbook/forms/text-input
[`drag()`]: {{api}}/flutter_test/WidgetController/drag.html
[`enterText()`]: {{api}}/flutter_test/WidgetTester/enterText.html
[Finding widgets in a widget test]: /cookbook/testing/widget/finders
[Handle taps]: /cookbook/gestures/handling-taps
[Implement swipe to dismiss]: /cookbook/gestures/dismissible
[Introduction to widget testing]: /cookbook/testing/widget/introduction
[`pump()`]: {{api}}/flutter_test/WidgetTester/pump.html
[`pumpAndSettle()`]: {{api}}/flutter_test/WidgetTester/pumpAndSettle.html
[`tap()`]: {{api}}/flutter_test/WidgetController/tap.html
[`TextField`]: {{api}}/material/TextField-class.html
[`WidgetTester`]: {{api}}/flutter_test/WidgetTester-class.html

