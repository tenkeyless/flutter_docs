---
# title: Focus and text fields
title: 포커스 및 텍스트 필드
# description: How focus works with text fields.
description: 텍스트 필드에 포커스가 작동하는 방식.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/forms/focus/"?>

텍스트 필드가 선택되어 입력을 받으면, "포커스"가 있다고 합니다. 
일반적으로, 사용자는 탭하여 텍스트 필드로 포커스를 이동하고, 
개발자는 이 레시피에 설명된 도구를 사용하여 프로그래밍 방식으로 텍스트 필드로 포커스를 이동합니다.

포커스 관리란 직관적인 흐름으로 양식을 만드는 데 기본이 되는 도구입니다. 
예를 들어, 텍스트 필드가 있는 검색 화면이 있다고 가정해 보겠습니다. 
사용자가 검색 화면으로 이동하면, 검색어의 텍스트 필드로 포커스를 설정할 수 있습니다. 
이렇게 하면 사용자가 텍스트 필드를 수동으로 탭하지 않고도, 화면이 표시되자마자 입력을 시작할 수 있습니다.

이 레시피에서는, 텍스트 필드가 표시되자마자 포커스를 주는 방법과, 버튼을 탭할 때 텍스트 필드에 포커스를 주는 방법을 알아봅니다.

## 텍스트 필드가 표시되면 즉시 포커스 맞추기 {:#focus-a-text-field-as-soon-as-its-visible}

텍스트 필드가 표시되자마자 포커스를 주려면, `autofocus` 속성을 사용합니다.

```dart
TextField(
  autofocus: true,
);
```

입력 처리 및 텍스트 필드 생성에 대한 자세한 내용은, 쿡북의 [폼][Forms] 섹션을 참조하세요.

## 버튼을 탭하면 텍스트 필드에 포커스 맞추기 {:#focus-a-text-field-when-a-button-is-tapped}

특정 텍스트 필드로 바로 포커스를 옮기는 대신, 나중에 텍스트 필드에 포커스를 주어야 할 수도 있습니다. 
현실 세계에서는, API 호출이나 검증 오류에 대한 응답으로 특정 텍스트 필드에 포커스를 주어야 할 수도 있습니다. 
이 예에서는, 사용자가 버튼을 누른 후 다음 단계에 따라 텍스트 필드에 포커스를 줍니다.

  1. `FocusNode`를 만듭니다.
  2. `FocusNode`를 `TextField`에 전달합니다.
  3. 버튼을 탭하면 `TextField`에 포커스를 줍니다.

### 1. `FocusNode` 생성 {:#1-create-a-focusnode}

먼저, [`FocusNode`][]를 만듭니다. 
`FocusNode`를 사용하여 Flutter의 "포커스 트리"에서 특정 `TextField`를 식별합니다. 
이렇게 하면, 다음 단계에서 `TextField`에 포커스를 줄 수 있습니다.

포커스 노드는 수명이 긴 객체이므로, `State` 객체를 사용하여 수명 주기를 관리합니다. 
다음 지침을 사용하여 `State` 클래스의 `initState()` 메서드 내에서 `FocusNode` 인스턴스를 만들고, 
`dispose()` 메서드에서 정리합니다.

<?code-excerpt "lib/starter.dart (Starter)" remove="return Container();"?>
```dart
// 커스텀 Form 위젯을 정의합니다.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// 해당 State 클래스를 정의합니다.
// 이 클래스는 폼과 관련된 데이터를 보유합니다.
class _MyCustomFormState extends State<MyCustomForm> {
  // 포커스 노드를 정의합니다. 
  // 라이프사이클을 관리하려면, initState 메서드에서 FocusNode를 만들고, dispose 메서드에서 정리합니다.
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Form이 삭제되면, 포커스 노드를 정리합니다.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 다음 단계에서 이를 작성합니다.
  }
}
```

### 2. `FocusNode`를 `TextField`에 전달 {:#2-pass-the-focusnode-to-a-textfield}

이제 `FocusNode`가 있으므로, `build()` 메서드에서 특정 `TextField`에 전달합니다.

<?code-excerpt "lib/step2.dart (Build)"?>
```dart
@override
Widget build(BuildContext context) {
  return TextField(
    focusNode: myFocusNode,
  );
}
```

### 3. 버튼을 탭하면 `TextField`에 포커스 주기 {:#3-give-focus-to-the-textfield-when-a-button-is-tapped}

마지막으로, 사용자가 플로팅 액션 버튼을 탭하면 텍스트 필드에 초점을 맞춥니다. 
이 작업을 수행하려면, [`requestFocus()`][] 메서드를 사용합니다.

<?code-excerpt "lib/step3.dart (FloatingActionButton)" replace="/^floatingActionButton\: //g"?>
```dart
FloatingActionButton(
  // 버튼을 누르면, myFocusNode를 사용하여 텍스트 필드에 포커스를 둡니다.
  onPressed: () => myFocusNode.requestFocus(),
),
```

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter text focus hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Text Field Focus',
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

// 해당 State 클래스를 정의합니다.
// 이 클래스는 폼과 관련된 데이터를 보유합니다.
class _MyCustomFormState extends State<MyCustomForm> {
  // 포커스 노드를 정의합니다. 
  // 라이프사이클을 관리하려면, initState 메서드에서 FocusNode를 만들고, dispose 메서드에서 정리합니다.
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Form이 삭제되면, 포커스 노드를 정리합니다.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Field Focus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 첫 번째 텍스트 필드는 앱이 시작되는 즉시 포커스가 맞춰집니다.
            const TextField(
              autofocus: true,
            ),
            // 두 번째 텍스트 필드는 사용자가 FloatingActionButton을 탭할 때에 초점을 맞춥니다.
            TextField(
              focusNode: myFocusNode,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // 버튼을 누르면, myFocusNode를 사용하여 텍스트 필드에 포커스를 둡니다.
        onPressed: () => myFocusNode.requestFocus(),
        tooltip: 'Focus Second Text Field',
        child: const Icon(Icons.edit),
      ), // 이 마지막 쉼표는 빌드 메서드에 대한 자동 서식을 더욱 좋게 만들어줍니다.
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/focus.gif" alt="Text Field Focus Demo" class="site-mobile-screenshot" />
</noscript>


[fix has landed]: {{site.repo.flutter}}/pull/50372
[`FocusNode`]: {{site.api}}/flutter/widgets/FocusNode-class.html
[Forms]: /cookbook#forms
[flutter/flutter@bf551a3]: {{site.repo.flutter}}/commit/bf551a31fe7ef45c854a219686b6837400bfd94c
[Issue 52221]: {{site.repo.flutter}}/issues/52221
[`requestFocus()`]: {{site.api}}/flutter/widgets/FocusNode/requestFocus.html
[workaround]: {{site.repo.flutter}}/issues/52221#issuecomment-598244655
