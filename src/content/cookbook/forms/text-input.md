---
# title: Create and style a text field
title: 텍스트 필드 만들기 및 스타일 지정
# description: How to implement a text field.
description: 텍스트 필드를 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/forms/text_input/"?>

텍스트 필드를 사용하면 사용자가 앱에 텍스트를 입력할 수 있습니다. 
텍스트 필드는 폼을 빌드하고, 메시지를 보내고, 검색 환경을 만드는 등의 용도로 사용됩니다. 
이 레시피에서는, 텍스트 필드를 만들고 스타일을 지정하는 방법을 살펴보겠습니다.

Flutter는 [`TextField`][]와 [`TextFormField`][]라는 두 가지 텍스트 필드를 제공합니다.

## `TextField` {:#textfield}

[`TextField`][]는 가장 일반적으로 사용되는 텍스트 입력 위젯입니다.

기본적으로, `TextField`는 밑줄로 장식됩니다. 
`TextField`의 [`decoration`][] 속성으로 [`InputDecoration`][]을 제공하여 
레이블, 아이콘, 인라인 힌트 텍스트 및 오류 텍스트를 추가할 수 있습니다. 
장식을 완전히 제거하려면(밑줄과 레이블에 예약된 공간 포함), `decoration`을 null로 설정합니다.

<?code-excerpt "lib/main.dart (TextField)" replace="/^child\: //g"?>
```dart
TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Enter a search term',
  ),
),
```

값이 변경될 때 이를 검색하려면, [텍스트 필드의 변경 사항 처리][Handle changes to a text field] 레시피를 참조하세요.

## `TextFormField` {:#textformfield}

[`TextFormField`][]는 `TextField`를 래핑하고, 이를 둘러싼 [`Form`][]과 통합합니다. 
이는 유효성 검사 및 다른 [`FormField`][] 위젯과의 통합과 같은, 추가 기능을 제공합니다.

<?code-excerpt "lib/main.dart (TextFormField)" replace="/^child\: //g"?>
```dart
TextFormField(
  decoration: const InputDecoration(
    border: UnderlineInputBorder(),
    labelText: 'Enter your username',
  ),
),
```

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart" replace="/^child\: //g"?>
```dartpad title="Flutter text input hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Styling Demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your username',
            ),
          ),
        ),
      ],
    );
  }
}
```

입력 검증에 대한 자세한 내용은, [검증 기능이 있는 양식 작성][Building a form with validation] 레시피를 참조하세요.


[Building a form with validation]: /cookbook/forms/validation/
[`decoration`]: {{site.api}}/flutter/material/TextField/decoration.html
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`FormField`]: {{site.api}}/flutter/widgets/FormField-class.html
[Handle changes to a text field]: /cookbook/forms/text-field-changes/
[`InputDecoration`]: {{site.api}}/flutter/material/InputDecoration-class.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
