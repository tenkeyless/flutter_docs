---
# title: Handle changes to a text field
title: 텍스트 필드의 변경 사항 처리
# description: How to detect changes to a text field.
description: 텍스트 필드의 변경 사항을 감지하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/forms/text_field_changes/"?>

어떤 경우에는, 텍스트 필드의 텍스트가 변경될 때마다 콜백 함수를 실행하는 것이 유용합니다. 
예를 들어, 사용자가 입력할 때 결과를 업데이트하려는 자동 완성 기능이 있는 검색 화면을 빌드할 수 있습니다.

텍스트가 변경될 때마다 콜백 함수를 어떻게 실행합니까? Flutter를 사용하면, 두 가지 옵션이 있습니다.

  1. `TextField` 또는 `TextFormField`에 `onChanged()` 콜백을 제공합니다.
  2. `TextEditingController`를 사용합니다.

## 1. `TextField` 또는 `TextFormField`에 `onChanged()` 콜백 제공{:#1-supply-an-onchanged-callback-to-a-textfield-or-a-textformfield}

가장 간단한 방법은 [`TextField`][] 또는 [`TextFormField`][]에 [`onChanged()`][] 콜백을 제공하는 것입니다.
텍스트가 변경될 때마다, 콜백이 호출됩니다.

이 예에서는, 텍스트가 변경될 때마다 텍스트 필드의 현재 값과 길이를 콘솔에 출력합니다.

텍스트에 복잡한 문자가 포함될 수 있으므로, 사용자 입력을 처리할 때는 [characters][characters]를 사용하는 것이 중요합니다.
이렇게 하면 모든 문자가 사용자에게 표시되는 대로 올바르게 계산됩니다.

<?code-excerpt "lib/main.dart (TextField1)"?>
```dart
TextField(
  onChanged: (text) {
    print('First text field: $text (${text.characters.length})');
  },
),
```

## 2. `TextEditingController` 사용 {:#2-use-a-texteditingcontroller}

더 강력하지만, 더 정교한 접근 방식은 [`TextEditingController`][]를 
`TextField` 또는 `TextFormField`의 [`controller`][] 속성으로 제공하는 것입니다.

텍스트가 변경될 때 알림을 받으려면, 다음 단계에 따라 [`addListener()`][] 메서드를 사용하여 컨트롤러를 수신 대기합니다.

  1. `TextEditingController`를 만듭니다.
  2. `TextEditingController`를 텍스트 필드에 연결합니다.
  3. 최신 값을 출력하는 함수를 만듭니다.
  4. 컨트롤러에서 변경 사항을 수신 대기합니다.

### `TextEditingController` 생성 {:#create-a-texteditingcontroller}

`TextEditingController` 생성하기:

<?code-excerpt "lib/main_step1.dart (Step1)" remove="return Container();"?>
```dart
// 커스텀 Form 위젯을 정의합니다.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// 대응되는 State 클래스를 정의합니다.
// 이 클래스는 Form과 관련된 데이터를 보유합니다.
class _MyCustomFormState extends State<MyCustomForm> {
  // 텍스트 컨트롤러를 만듭니다. 
  // 나중에, 이를 사용하여 TextField의 현재 값을 검색합니다.
  final myController = TextEditingController();

  @override
  void dispose() {
    // 위젯 트리에서 위젯을 제거하면 컨트롤러를 정리합니다.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 다음 단계에서 이를 작성합니다.
  }
}
```

:::note
더 이상 필요하지 않을 때 `TextEditingController`를 폐기하는 것을 기억하세요. 
이렇게 하면, 객체에서 사용하는 모든 리소스를 폐기할 수 있습니다.
:::

### `TextEditingController`를 텍스트 필드에 연결 {:#connect-the-texteditingcontroller-to-a-text-field}

`TextEditingController`를 `TextField` 또는 `TextFormField`에 제공합니다. 
이 두 클래스를 함께 연결하면, 텍스트 필드의 변경 사항을 수신하기 시작할 수 있습니다.

<?code-excerpt "lib/main.dart (TextField2)"?>
```dart
TextField(
  controller: myController,
),
```

### 최신 값을 출력하는 함수 생성 {:#create-a-function-to-print-the-latest-value}

텍스트가 변경될 때마다 실행할 함수가 필요합니다. 
`_MyCustomFormState` 클래스에 텍스트 필드의 현재 값을 출력하는 메서드를 만듭니다.

<?code-excerpt "lib/main.dart (printLatestValue)"?>
```dart
void _printLatestValue() {
  final text = myController.text;
  print('Second text field: $text (${text.characters.length})');
}
```

### 컨트롤러에 대해 변경 사항 수신 {:#listen-to-the-controller-for-changes}

마지막으로, `TextEditingController`를 수신하고 텍스트가 변경될 때 `_printLatestValue()` 메서드를 호출합니다. 
이 목적을 위해 [`addListener()`][] 메서드를 사용합니다.

`_MyCustomFormState` 클래스가 초기화되면(initialized) 변경 사항을 수신하기 시작하고, 
`_MyCustomFormState`가 삭제(disposed)되면 수신을 중지합니다.

<?code-excerpt "lib/main.dart (init-state)"?>
```dart
@override
void initState() {
  super.initState();

  // 변경사항을 수신하기 시작합니다.
  myController.addListener(_printLatestValue);
}
```

<?code-excerpt "lib/main.dart (dispose)"?>
```dart
@override
void dispose() {
  // 위젯이 위젯 트리에서 제거되면 컨트롤러를 정리합니다.
  // 이렇게 하면 _printLatestValue 리스너도 제거됩니다.
  myController.dispose();
  super.dispose();
}
```

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter text field change hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Retrieve Text Input',
      home: MyCustomForm(),
    );
  }
}

// 커스텀 Form 위젯을 정의합니다.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// 대응되는 State 클래스를 정의합니다.
// 이 클래스는 Form과 관련된 데이터를 보유합니다.
class _MyCustomFormState extends State<MyCustomForm> {
  // 텍스트 컨트롤러를 만들고 이를 사용하여 TextField의 현재 값을 검색합니다.
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 변경사항을 수신하기 시작합니다.
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // 위젯이 위젯 트리에서 제거되면 컨트롤러를 정리합니다.
    // 이렇게 하면 _printLatestValue 리스너도 제거됩니다.
    myController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    final text = myController.text;
    print('Second text field: $text (${text.characters.length})');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                print('First text field: $text (${text.characters.length})');
              },
            ),
            TextField(
              controller: myController,
            ),
          ],
        ),
      ),
    );
  }
}
```

[`addListener()`]: {{site.api}}/flutter/foundation/ChangeNotifier/addListener.html
[`controller`]: {{site.api}}/flutter/material/TextField/controller.html
[`onChanged()`]: {{site.api}}/flutter/material/TextField/onChanged.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`TextEditingController`]: {{site.api}}/flutter/widgets/TextEditingController-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
[characters]: {{site.pub}}/packages/characters
