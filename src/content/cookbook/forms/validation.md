---
# title: Build a form with validation
title: 유효성 검증이 있는 양식 만들기
# description: How to build a form that validates input.
description: 입력 내용을 검증하는 양식을 만드는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/forms/validation"?>

앱에서는 종종 사용자가 텍스트 필드에 정보를 입력하도록 요구합니다. 
예를 들어, 사용자에게 이메일 주소와 비밀번호 조합으로 로그인하도록 요구할 수 있습니다.

앱을 안전하고 사용하기 쉽게 만들려면, 사용자가 제공한 정보가 유효한지 확인하세요. 
사용자가 양식을 올바르게 작성했다면, 정보를 처리합니다. 
사용자가 잘못된 정보를 제출하면, 친절한 오류 메시지를 표시하여 무엇이 잘못되었는지 알려줍니다.

이 예에서는, 다음 단계를 사용하여 단일 텍스트 필드가 있는 양식에 유효성 검사를 추가하는 방법을 알아봅니다.

  1. `GlobalKey`가 있는 `Form`을 만듭니다.
  2. 유효성 검사 논리가 있는 `TextFormField`를 추가합니다.
  3. 양식을 유효성 검사하고 제출하는 버튼을 만듭니다.

## 1. `GlobalKey`가 있는 `Form` 만들기 {:#1-create-a-form-with-a-globalkey}

[`Form`][]을 만듭니다. `Form` 위젯은 여러 양식 필드를 그룹화하고 검증하기 위한 컨테이너 역할을 합니다.

양식을 만들 때 [`GlobalKey`][]를 제공합니다. 
이렇게 하면 `Form`에 고유 식별자가 할당됩니다. 
또한 나중에 양식을 검증할 수도 있습니다.

양식을 `StatefulWidget`으로 만듭니다. 
이렇게 하면 고유한 `GlobalKey<FormState>()`를 한 번 만들 수 있습니다. 
그런 다음 변수로 저장하고 다른 지점에서 액세스할 수 있습니다.

이것을 `StatelessWidget`으로 만든 경우, 이 키를 *어딘가에* 저장해야 합니다. 
리소스가 많이 소모되므로, `build` 메서드를 실행할 때마다 새 `GlobalKey`를 생성하고 싶지 않을 것입니다.

<?code-excerpt "lib/form.dart"?>
```dart
import 'package:flutter/material.dart';

// 커스텀 Form 위젯을 정의합니다.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// 해당 State 클래스를 정의합니다.
// 이 클래스는 폼과 관련된 데이터를 보유합니다.
class MyCustomFormState extends State<MyCustomForm> {
  // Form 위젯을 고유하게 식별하고, 양식의 유효성 검사를 허용하는 글로벌 키를 만듭니다.
  //
  // Note: 이것은 `GlobalKey<FormState>`이고 GlobalKey<MyCustomFormState>가 아닙니다.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // 위에서 만든 _formKey를 사용하여 Form 위젯을 만들어보세요.
    return Form(
      key: _formKey,
      child: const Column(
        children: <Widget>[
          // 여기에 TextFormFields와 ElevatedButton을 추가합니다.
        ],
      ),
    );
  }
}
```

:::tip
`GlobalKey`를 사용하는 것은 폼에 액세스하는 권장 방법입니다. 
그러나, 더 복잡한 위젯 트리가 있는 경우, [`Form.of()`][] 메서드를 사용하여 중첩된 위젯 내에서 폼에 액세스할 수 있습니다.
:::

## 2. 검증 로직을 사용하여 `TextFormField` 추가 {:#2-add-a-textformfield-with-validation-logic}

`Form`이 제자리에 있지만, 사용자가 텍스트를 입력할 방법이 없습니다. 이는 [`TextFormField`][]의 역할입니다.
`TextFormField` 위젯은 머티리얼 디자인 텍스트 필드를 렌더링하고, 오류가 발생하면 유효성 검사 오류를 표시할 수 있습니다.

`TextFormField`에 `validator()` 함수를 제공하여 입력을 검증합니다. 
사용자 입력이 유효하지 않으면, `validator` 함수는 오류 메시지가 포함된 `String`을 반환합니다. 
오류가 없으면, 유효성 검사기는 null을 반환해야 합니다.

이 예에서는, `TextFormField`가 비어 있지 않은지 확인하는 `validator`를 만듭니다. 
비어 있으면, 친절한 오류 메시지를 반환합니다.

<?code-excerpt "lib/main.dart (TextFormField)"?>
```dart
TextFormField(
  // 검증기는 사용자가 입력한 텍스트를 받습니다.
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  },
),
```

## 3. 양식을 검증하고 제출하기 위한 버튼 만들기 {:#3-create-a-button-to-validate-and-submit-the-form}

이제 텍스트 필드가 있는 양식이 있으므로, 사용자가 정보를 제출하기 위해 탭할 수 있는 버튼을 제공합니다.

사용자가 양식을 제출하려고 할 때, 양식이 유효한지 확인합니다. 유효한 경우, 성공 메시지를 표시합니다. 
유효하지 않은 경우(텍스트 필드에 내용이 없는 경우), 오류 메시지를 표시합니다.

<?code-excerpt "lib/main.dart (ElevatedButton)" replace="/^child\: //g"?>
```dart
ElevatedButton(
  onPressed: () {
    // Validate는 양식이 유효하면 true를 반환하고, 그렇지 않으면 false를 반환합니다.
    if (_formKey.currentState!.validate()) {
      // 양식이 유효하면 스낵바를 표시합니다. 
      // 현실 세계에서는, 종종 서버를 호출하거나 데이터베이스에 정보를 저장합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
  },
  child: const Text('Submit'),
),
```

### 어떻게 작동하나요? {:#how-does-this-work}

폼을 검증하려면, 1단계에서 만든 `_formKey`를 사용합니다. 
`_formKey.currentState` 접근자를 사용하여, Flutter에서 `Form`을 빌드할 때 자동으로 만드는, 
[`FormState`][]에 액세스할 수 있습니다.

`FormState` 클래스에는 `validate()` 메서드가 포함되어 있습니다. 
`validate()` 메서드가 호출되면, 폼의 각 텍스트 필드에 대해 `validator()` 함수를 실행합니다. 
모든 것이 정상이면, `validate()` 메서드는 `true`를 반환합니다. 
텍스트 필드에 오류가 있으면, `validate()` 메서드는 폼을 다시 빌드하여 오류 메시지를 표시하고 `false`를 반환합니다.

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter form validation hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

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

// 양식 위젯을 만듭니다.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// 해당 State 클래스를 만듭니다.
// 이 클래스는 폼과 관련된 데이터를 보관합니다.
class MyCustomFormState extends State<MyCustomForm> {
  // 양식 위젯을 고유하게 식별하고 양식의 유효성 검사를 허용하는 글로벌 키를 만듭니다.
  //
  // Note: 이것은 GlobalKey<FormState>이고, GlobalKey<MyCustomFormState>가 아닙니다.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // 위에서 만든 _formKey를 사용하여, Form 위젯을 만들어보세요.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            // 검증기는 사용자가 입력한 텍스트를 받습니다.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                // Validate는 양식이 유효하면 true를 반환하고, 그렇지 않으면 false를 반환합니다.
                if (_formKey.currentState!.validate()) {
                  // 양식이 유효하면, 스낵바를 표시합니다. 
                  // 현실 세계에서는, 종종 서버를 호출하거나 데이터베이스에 정보를 저장합니다.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/form-validation.gif" alt="Form Validation Demo" class="site-mobile-screenshot" />
</noscript>

이러한 값을 검색하는 방법을 알아보려면, [텍스트 필드 값 검색][Retrieve the value of a text field] 레시피를 확인하세요.


[Retrieve the value of a text field]: /cookbook/forms/retrieve-input
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`Form.of()`]: {{site.api}}/flutter/widgets/Form/of.html
[`FormState`]: {{site.api}}/flutter/widgets/FormState-class.html
[`GlobalKey`]: {{site.api}}/flutter/widgets/GlobalKey-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
