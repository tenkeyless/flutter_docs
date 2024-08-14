---
# title: Find widgets
title: 위젯 찾기
# description: How to use the Finder classes for testing widgets.
description: 위젯을 테스트하기 위해 Finder 클래스를 사용하는 방법.
---

<?code-excerpt path-base="cookbook/testing/widget/finders/"?>

{% assign api = site.api | append: '/flutter' -%}

테스트 환경에서 위젯을 찾으려면, [`Finder`][] 클래스를 사용합니다. 
직접 `Finder` 클래스를 작성할 수도 있지만, 
일반적으로 [`flutter_test`][] 패키지에서 제공하는 도구를 사용하여 위젯을 찾는 것이 더 편리합니다.

위젯 테스트에서 `flutter run` 세션 중에, 
화면의 일부를 대화형으로 탭하여 Flutter 도구가 제안된 `Finder`를 출력하도록 할 수도 있습니다.

이 레시피는 `flutter_test` 패키지에서 제공하는 [`find`][] 상수를 살펴보고, 
제공하는 일부 `Finder`를 사용하는 방법을 보여줍니다.
사용 가능한 finder의 전체 목록은 [`CommonFinders` 문서][`CommonFinders` documentation]를 ​​참조하세요.

위젯 테스트와 `Finder` 클래스의 역할에 익숙하지 않은 경우, 
[위젯 테스트 소개][Introduction to widget testing] 레시피를 검토하세요.

이 레시피는 다음 단계를 사용합니다.

  1. `Text` 위젯을 찾습니다.
  2. 특정 `Key`가 있는 위젯을 찾습니다.
  3. 특정 위젯 인스턴스를 찾습니다.

## 1. `Text` 위젯 찾기 {:#1-find-a-text-widget}

테스트에서는, 특정 텍스트가 포함된 위젯을 찾아야 하는 경우가 많습니다. 
이것이 바로 `find.text()` 메서드의 용도입니다. 
특정 `String` 텍스트를 표시하는 위젯을 검색하는 `Finder`를 만듭니다.

<?code-excerpt "test/finders_test.dart (test1)"?>
```dart
testWidgets('finds a Text widget', (tester) async {
  // 'H' 문자를 표시하는 Text 위젯이 있는 App을 빌드합니다.
  await tester.pumpWidget(const MaterialApp(
    home: Scaffold(
      body: Text('H'),
    ),
  ));

  // 문자 'H'가 표시되는 위젯을 찾습니다.
  expect(find.text('H'), findsOneWidget);
});
```

## 2. 특정 `Key`가 있는 위젯 찾기 {:#2-find-a-widget-with-a-specific-key}

어떤 경우에는, 제공된 Key를 기준으로 위젯을 찾고 싶을 수 있습니다. 
이는 동일한 위젯의 여러 인스턴스를 표시하는 경우 유용할 수 있습니다. 
예를 들어, `ListView`는 동일한 텍스트를 포함하는 여러 `Text` 위젯을 표시할 수 있습니다.

이 경우, 리스트의 각 위젯에 `Key`를 제공합니다. 
이를 통해 앱은 특정 위젯을 고유하게 식별할 수 있으므로, 테스트 환경에서 위젯을 더 쉽게 찾을 수 있습니다.

<?code-excerpt "test/finders_test.dart (test2)"?>
```dart
testWidgets('finds a widget using a Key', (tester) async {
  // 테스트 키를 정의합니다.
  const testKey = Key('K');

  // testKey로 MaterialApp을 빌드합니다.
  await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));

  // testKey를 사용하여 MaterialApp 위젯을 찾습니다.
  expect(find.byKey(testKey), findsOneWidget);
});
```

## 3. 특정 위젯 인스턴스 찾기 {:#3-find-a-specific-widget-instance}

마지막으로, 위젯의 특정 인스턴스를 찾는 데 관심이 있을 수 있습니다. 
예를 들어, `child` 속성을 사용하는 위젯을 만들고, `child` 위젯을 렌더링하고 있는지 확인하고 싶을 때 유용할 수 있습니다.

<?code-excerpt "test/finders_test.dart (test3)"?>
```dart
testWidgets('finds a specific instance', (tester) async {
  const childWidget = Padding(padding: EdgeInsets.zero);

  // Container에 childWidget을 제공합니다.
  await tester.pumpWidget(Container(child: childWidget));

  // 트리에서 childWidget을 검색하여 존재하는지 확인합니다.
  expect(find.byWidget(childWidget), findsOneWidget);
});
```

## 요약 {:#summary}

`flutter_test` 패키지에서 제공하는 `find` 상수는 테스트 환경에서 위젯을 찾는 여러 가지 방법을 제공합니다. 
이 레시피는 이러한 방법 중 세 가지를 보여주었고, 다른 목적을 위한 몇 가지 방법이 더 있습니다.

위의 예가 특정 사용 사례에 작동하지 않으면, [`CommonFinders` 문서][`CommonFinders` documentation]를 ​​참조하여
사용 가능한 모든 방법을 검토하세요.

## 완성된 예제 {:#complete-example}

<?code-excerpt "test/finders_test.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('finds a Text widget', (tester) async {
    // 'H' 문자를 표시하는 Text 위젯이 있는 App을 빌드합니다.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text('H'),
      ),
    ));

    // 문자 'H'가 표시되는 위젯을 찾습니다.
    expect(find.text('H'), findsOneWidget);
  });

  testWidgets('finds a widget using a Key', (tester) async {
    // 테스트 키를 정의합니다.
    const testKey = Key('K');

    // testKey로 MaterialApp을 빌드합니다.
    await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));

    // testKey를 사용하여 MaterialApp 위젯을 찾습니다.
    expect(find.byKey(testKey), findsOneWidget);
  });

  testWidgets('finds a specific instance', (tester) async {
    const childWidget = Padding(padding: EdgeInsets.zero);

    // Container에 childWidget을 제공합니다.
    await tester.pumpWidget(Container(child: childWidget));

    // 트리에서 childWidget을 검색하여 존재하는지 확인합니다.
    expect(find.byWidget(childWidget), findsOneWidget);
  });
}
```

[`Finder`]: {{api}}/flutter_test/Finder-class.html
[`CommonFinders` documentation]: {{api}}/flutter_test/CommonFinders-class.html
[`find`]: {{api}}/flutter_test/find-constant.html
[`flutter_test`]: {{api}}/flutter_test/flutter_test-library.html
[Introduction to widget testing]: /cookbook/testing/widget/introduction
