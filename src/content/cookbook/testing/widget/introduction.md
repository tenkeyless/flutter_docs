---
# title: An introduction to widget testing
title: 위젯 테스트 소개
# description: Learn more about widget testing in Flutter.
description: Flutter에서 위젯 테스트에 대해 자세히 알아보세요.
# short-title: Introduction
short-title: 소개
---

<?code-excerpt path-base="cookbook/testing/widget/introduction/"?>

{% assign api = site.api | append: '/flutter' -%}

[유닛 테스트 소개][introduction to unit testing] 레시피에서 `test` 패키지를 사용하여 
Dart 클래스를 테스트하는 방법을 알아보았습니다. 
위젯 클래스를 테스트하려면, Flutter SDK와 함께 제공되는, 
[`flutter_test`][] 패키지에서 제공하는 몇 가지 추가 도구가 필요합니다.

`flutter_test` 패키지는 위젯 테스트를 위한 다음 도구를 제공합니다.

  * [`WidgetTester`][]를 사용하면, 
    * 테스트 환경에서 위젯을 빌드하고 위젯과 상호 작용할 수 있습니다.
  * [`testWidgets()`][] 함수는 
    * 각 테스트 케이스에 대해 자동으로 새 `WidgetTester`를 생성하며, 
    * 일반적인 `test()` 함수 대신 사용됩니다.
  * [`Finder`][] 클래스를 사용하면, 
    * 테스트 환경에서 위젯을 검색할 수 있습니다.
  * 위젯별 [`Matcher`][] 상수는 
    * `Finder`가 테스트 환경에서 위젯을 하나 또는 여러 개 찾는지 확인하는 데 도움이 됩니다.

이것이 어렵게 들리더라도 걱정하지 마세요. 
이 레시피에서 이러한 모든 부분이 어떻게 함께 맞춰지는지 알아보기 위해, 다음 단계를 따르세요.

  1. `flutter_test` 종속성을 추가합니다.
  2. 테스트할 위젯을 만듭니다.
  3. `testWidgets` 테스트를 만듭니다.
  4. `WidgetTester`를 사용하여 위젯을 빌드합니다.
  5. `Finder`를 사용하여 위젯을 검색합니다.
  6. `Matcher`를 사용하여 위젯을 검증합니다.

## 1. `flutter_test` 종속성 추가 {:#1-add-the-flutter_test-dependency}

테스트를 작성하기 전에, `pubspec.yaml` 파일의 `dev_dependencies` 섹션에 `flutter_test` 종속성을 포함합니다. 
명령줄 도구나 코드 편집기로 새 Flutter 프로젝트를 만드는 경우, 이 종속성은 이미 있어야 합니다.

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
```

## 2. 테스트할 위젯 만들기 {:#2-create-a-widget-to-test}

다음으로, 테스트를 위한 위젯을 만듭니다. 
이 레시피의 경우, `title`과 `message`를 표시하는 위젯을 만듭니다.

<?code-excerpt "test/main_test.dart (widget)"?>
```dart
class MyWidget extends StatelessWidget {
  const MyWidget({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
```

## 3. `testWidgets` 테스트 만들기 {:#3-create-a-testwidgets-test}

테스트할 위젯이 있으면, 첫 번째 테스트를 작성하여 시작합니다. 
`flutter_test` 패키지에서 제공하는 [`testWidgets()`][] 함수를 사용하여 테스트를 정의합니다. 
`testWidgets` 함수를 사용하면 위젯 테스트를 정의하고, 작업할 `WidgetTester`를 만들 수 있습니다.

이 테스트는 `MyWidget`이 주어진 제목과 메시지를 표시하는지 확인합니다. 
그에 따라 제목이 지정되고, 다음 섹션에서 채워집니다.

<?code-excerpt "test/main_step3_test.dart (main)"?>
```dart
void main() {
  // 테스트를 정의합니다. 
  // TestWidgets 함수는 또한 작업할 WidgetTester를 제공합니다. 
  // WidgetTester를 사용하면 테스트 환경에서 위젯을 빌드하고 상호 작용할 수 있습니다.
  testWidgets('MyWidget has a title and message', (tester) async {
    // 테스트 코드는 여기에 있습니다.
  });
}
```

## 4. `WidgetTester`를 사용하여 위젯을 빌드 {:#4-build-the-widget-using-the-widgettester}

다음으로, `WidgetTester`에서 제공하는 [`pumpWidget()`][] 메서드를 사용하여 
테스트 환경 내에서 `MyWidget`을 빌드합니다. 
`pumpWidget` 메서드는 제공된 위젯을 빌드하고 렌더링합니다.

제목으로 "T"를 표시하고, 메시지로 "M"을 표시하는, `MyWidget` 인스턴스를 만듭니다.

<?code-excerpt "test/main_step4_test.dart (main)"?>
```dart
void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    // 테스터에게 위젯을 만들라고 말해 위젯을 만듭니다.
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));
  });
}
```

### pump() 메서드에 대한 참고 사항 {:#notes-about-the-pump-methods}

`pumpWidget()`에 대한 초기 호출 후, `WidgetTester`는 동일한 위젯을 다시 빌드하는 추가적인 방법을 제공합니다. `StatefulWidget` 또는 애니메이션으로 작업하는 경우 유용합니다.

예를 들어, 버튼을 탭하면 `setState()`가 호출되지만, Flutter는 테스트 환경에서 위젯을 자동으로 다시 빌드하지 않습니다. 
다음 방법 중 하나를 사용하여 Flutter에 위젯을 다시 빌드하도록 요청합니다.

[`tester.pump(Duration duration)`][]
: 프레임을 스케쥴링하고, 위젯의 재구축을 트리거합니다. 
  `Duration`이 지정되면, 해당 양만큼 클록을 진행하고, 프레임을 예약합니다. 
  duration이 단일 프레임보다 길더라도, 여러 프레임을 예약하지 않습니다.

:::note
애니메이션을 시작하려면, `pump()`를 한 번 호출해야 합니다. (duration을 지정하지 않고) 
그것이 없이는, 애니메이션이 시작되지 않습니다.
:::

[`tester.pumpAndSettle()`][]
: 더 이상 예약된 프레임이 없을 때까지 주어진 duration으로 `pump()`를 반복적으로 호출합니다. 
  이는, 기본적으로, 모든 애니메이션이 완료될 때까지 기다립니다.

이러한 방법은 빌드 수명 주기를 세부적으로 제어할 수 있는 기능을 제공하며, 특히 테스트 중에 유용합니다.

## 5. `Finder`를 사용하여 위젯을 검색 {:#5-search-for-our-widget-using-a-finder}

테스트 환경에 위젯이 있는 경우, `Finder`를 사용하여 위젯 트리에서 `title` 및 `message` 텍스트 위젯을 검색합니다. 
이를 통해 위젯이 올바르게 표시되는지 확인할 수 있습니다.

이를 위해, `flutter_test` 패키지에서 제공하는 최상위 레벨 [`find()`][] 메서드를 사용하여 `Finders`를 만듭니다.
당신이 `Text` 위젯을 찾고 있다는 것을 알고 있으므로, [`find.text()`][] 메서드를 사용합니다.

`Finder` 클래스에 대한 자세한 내용은, [위젯 테스트에서 위젯 찾기][Finding widgets in a widget test] 레시피를 참조하세요.

<?code-excerpt "test/main_step5_test.dart (main)"?>
```dart
void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));

    // Finders를 만듭니다.
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');
  });
}
```

## 6. `Matcher`를 사용하여 위젯을 검증 {:#6-verify-the-widget-using-a-matcher}

마지막으로, `flutter_test`에서 제공하는 `Matcher` 상수를 사용하여 
제목과 메시지 `Text` 위젯이 화면에 나타나는지 확인합니다. 
`Matcher` 클래스는 `test` 패키지의 핵심 부분이며, 주어진 값이 기대치를 충족하는지 확인하는 일반적인 방법을 제공합니다.

위젯이 화면에 정확히 한 번만 나타나는지 확인합니다. 
이를 위해, [`findsOneWidget`][] `Matcher`를 사용합니다.

<?code-excerpt "test/main_step6_test.dart (main)"?>
```dart
void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    // flutter_test가 제공하는 `findsOneWidget` matcher를 사용하여 
    // 텍스트 위젯이 위젯 트리에 정확히 한 번 나타나는지 확인합니다.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}
```

### 추가적인 Matchers {:#additional-matchers}

`findsOneWidget` 외에도, `flutter_test`는 일반적인 경우에 대한 추가 매처를 제공합니다.

[`findsNothing`][]
: 위젯이 발견되지 않았는지 확인합니다.

[`findsWidgets`][]
: 하나 이상의 위젯이 발견되었는지 확인합니다.

[`findsNWidgets`][]
: 특정 수의 위젯이 발견되었는지 확인합니다.

[`matchesGoldenFile`][]
: 위젯의 렌더링이 특정 비트맵 이미지와 일치하는지 확인합니다. ("골든 파일(golden file)" 테스트)

## 완성된 예제 {:#complete-example}

<?code-excerpt "test/main_test.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 테스트를 정의합니다. 
  // TestWidgets 함수는 또한 작업할 WidgetTester를 제공합니다. 
  // WidgetTester를 사용하면 테스트 환경에서 위젯을 빌드하고 상호 작용할 수 있습니다.
  testWidgets('MyWidget has a title and message', (tester) async {
    // tester에게 위젯을 만들라고 말해 위젯을 만듭니다.
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));

    // Finders를 만듭니다.
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    // flutter_test가 제공하는 `findsOneWidget` matcher를 사용하여 
    // 텍스트 위젯이 위젯 트리에 정확히 한 번 나타나는지 확인합니다.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}

class MyWidget extends StatelessWidget {
  const MyWidget({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
```


[`find()`]: {{api}}/flutter_test/find-constant.html
[`find.text()`]: {{api}}/flutter_test/CommonFinders/text.html
[`findsNothing`]: {{api}}/flutter_test/findsNothing-constant.html
[`findsOneWidget`]: {{api}}/flutter_test/findsOneWidget-constant.html
[`findsNWidgets`]: {{api}}/flutter_test/findsNWidgets.html
[`findsWidgets`]: {{api}}/flutter_test/findsWidgets-constant.html
[`matchesGoldenFile`]: {{api}}/flutter_test/matchesGoldenFile.html
[`Finder`]: {{api}}/flutter_test/Finder-class.html
[Finding widgets in a widget test]: /cookbook/testing/widget/finders
[`flutter_test`]: {{api}}/flutter_test/flutter_test-library.html
[introduction to unit testing]: /cookbook/testing/unit/introduction
[`Matcher`]: {{api}}/package-matcher_matcher/Matcher-class.html
[`pumpWidget()`]: {{api}}/flutter_test/WidgetTester/pumpWidget.html
[`tester.pump(Duration duration)`]: {{api}}/flutter_test/TestWidgetsFlutterBinding/pump.html
[`tester.pumpAndSettle()`]: {{api}}/flutter_test/WidgetTester/pumpAndSettle.html
[`testWidgets()`]: {{api}}/flutter_test/testWidgets.html
[`WidgetTester`]: {{api}}/flutter_test/WidgetTester-class.html
