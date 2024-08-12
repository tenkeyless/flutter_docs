---
# title: Retrieve the value of a text field
title: 텍스트 필드의 값 검색
# description: How to retrieve text from a text field.
description: 텍스트 필드에서 텍스트를 검색하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/forms/retrieve_input"?>

이 레시피에서는, 다음 단계를 사용하여 사용자가 텍스트 필드에 입력한 텍스트를 검색하는 방법을 알아봅니다.

  1. `TextEditingController`를 만듭니다.
  2. `TextEditingController`를 `TextField`에 제공합니다.
  3. 텍스트 필드의 현재 값을 표시합니다.

## 1. `TextEditingController` 생성 {:#1-create-a-texteditingcontroller}

사용자가 텍스트 필드에 입력한 텍스트를 검색하려면, 
[`TextEditingController`][]를 생성하여 `TextField` 또는 `TextFormField`에 제공합니다.

:::important
`TextEditingController`를 사용한 후에는 `dispose`를 호출합니다.
이렇게 하면, 객체에서 사용한 모든 리소스를 삭제할 수 있습니다.
:::

<?code-excerpt "lib/starter.dart (Starter)" remove="return Container();"?>
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
  // 텍스트 컨트롤러를 만들고 이를 사용하여 TextField의 현재 값을 검색합니다.
  final myController = TextEditingController();

  @override
  void dispose() {
    // 위젯을 폐기할 때 컨트롤러도 정리하세요.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 다음 단계에서 이를 작성합니다.
  }
}
```

## 2. `TextField`에 `TextEditingController`를 제공 {:#2-supply-the-texteditingcontroller-to-a-textfield}

이제 `TextEditingController`가 있으므로, `controller` 속성을 사용하여 이를 텍스트 필드에 연결합니다.

<?code-excerpt "lib/step2.dart (TextFieldController)"?>
```dart
return TextField(
  controller: myController,
);
```

## 3. 텍스트 필드의 현재 값 표시 {:#3-display-the-current-value-of-the-text-field}

`TextEditingController`를 텍스트 필드에 제공한 후, 값을 읽기 시작합니다. 
`TextEditingController`에서 제공하는 [`text()`][] 메서드를 사용하여, 사용자가 텍스트 필드에 입력한 문자열을 검색합니다.

다음 코드는 사용자가 플로팅 작업 버튼을 탭할 때, 텍스트 필드의 현재 값이 있는 경고 대화 상자를 표시합니다.

<?code-excerpt "lib/step3.dart (FloatingActionButton)" replace="/^floatingActionButton\: //g"?>
```dart
FloatingActionButton(
  // 사용자가 버튼을 누르면, 사용자가 텍스트 필드에 입력한 텍스트가 포함된 알림 대화 상자를 표시합니다.
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // TextEditingController를 사용하여 사용자가 입력한 텍스트를 검색합니다.
          content: Text(myController.text),
        );
      },
    );
  },
  tooltip: 'Show me the value!',
  child: const Icon(Icons.text_fields),
),
```

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter retrieve input hands-on example in DartPad" run="true"
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
  void dispose() {
    // 위젯을 폐기할 때 컨트롤러도 정리하세요.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // 사용자가 버튼을 누르면, 사용자가 텍스트 필드에 입력한 텍스트가 포함된 알림 대화 상자를 표시합니다.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // TextEditingController를 사용하여 사용자가 입력한 텍스트를 검색합니다.
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/retrieve-input.gif" alt="Retrieve Text Input Demo" class="site-mobile-screenshot" />
</noscript>


[`text()`]: {{site.api}}/flutter/widgets/TextEditingController/text.html
[`TextEditingController`]: {{site.api}}/flutter/widgets/TextEditingController-class.html
