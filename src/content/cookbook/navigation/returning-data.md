---
# title: Return data from a screen
title: 화면으로부터 ​​데이터 반환
# description: How to return data from a new screen.
description: 새 화면에서 데이터를 반환하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/navigation/returning_data/"?>

어떤 경우에는, 새 화면에서 데이터를 반환하고 싶을 수 있습니다. 
예를 들어, 사용자에게 두 가지 옵션을 제공하는 새 화면을 푸시한다고 가정해 보겠습니다. 
사용자가 옵션을 탭하면, 첫 번째 화면에 사용자의 선택을 알려서 해당 정보에 따라 작업할 수 있도록 합니다.

다음 단계를 사용하여 [`Navigator.pop()`][] 메서드로 이를 수행할 수 있습니다.

  1. 홈 화면 정의
  2. 선택 화면을 시작하는 버튼 추가
  3. 두 개의 버튼이 있는 선택 화면 보여주기
  4. 버튼을 탭하면, 선택 화면 닫기
  5. 선택한 아이템으로 홈 화면에 스낵바 표시

## 1. 홈 화면 정의 {:#1-define-the-home-screen}

홈 화면에는 버튼이 표시됩니다. 탭하면, 선택 화면이 시작됩니다.

<?code-excerpt "lib/main_step2.dart (HomeScreen)"?>
```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Returning Data Demo'),
      ),
      // 다음 단계에서는 SelectionButton 위젯을 만듭니다.
      body: const Center(
        child: SelectionButton(),
      ),
    );
  }
}
```

## 2. 선택 화면을 시작하는 버튼 추가 {:#2-add-a-button-that-launches-the-selection-screen}

이제, 다음을 수행하는, SelectionButton을 만듭니다.

  * 탭하면 SelectionScreen을 시작합니다.
  * SelectionScreen이 결과를 반환할 때까지 기다립니다.

<?code-excerpt "lib/main_step2.dart (SelectionButton)"?>
```dart
class SelectionButton extends StatefulWidget {
  const SelectionButton({super.key});

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
      child: const Text('Pick an option, any option!'),
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push는 Selection Screen에서 
    // Navigator.pop을 호출한 후 완료되는 Future를 반환합니다.
    final result = await Navigator.push(
      context,
      // 다음 단계에서는 SelectionScreen을 만듭니다.
      MaterialPageRoute(builder: (context) => const SelectionScreen()),
    );
  }
}
```

## 3. 두 개의 버튼이 있는 선택 화면 보여주기 {:#3-show-the-selection-screen-with-two-buttons}

이제, 두 개의 버튼이 포함된 선택 화면을 빌드합니다. 
사용자가 버튼을 탭하면, 해당 앱은 선택 화면을 닫고 홈 화면에 어떤 버튼이 탭되었는지 알려줍니다.

이 단계에서는 UI를 정의합니다. 다음 단계에서는 데이터를 반환하는 코드를 추가합니다.

<?code-excerpt "lib/main_step2.dart (SelectionScreen)"?>
```dart
class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick an option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // "Yep" 대답과 함께 pop 합니다...
                },
                child: const Text('Yep!'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // "Nope" 대답과 함께 pop 합니다...
                },
                child: const Text('Nope.'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
```

## 4. 버튼을 탭하면, 선택 화면 닫기 {:#4-when-a-button-is-tapped-close-the-selection-screen}

이제, 두 버튼 모두에 대한 `onPressed()` 콜백을 업데이트합니다. 
첫 번째 화면으로 데이터를 반환하려면, 
`result`라는 선택적 두 번째 인수를 허용하는 [`Navigator.pop()`][] 메서드를 사용합니다. 
어떤 결과이던지, SelectionButton의 `Future`로 반환됩니다.

### Yep 버튼 {:#yep-button}

<?code-excerpt "lib/main.dart (Yep)" replace="/^child: //g;/^\),$/)/g"?>
```dart
ElevatedButton(
  onPressed: () {
    // 화면을 닫고, 결과로 "Yep!"을 반환합니다.
    Navigator.pop(context, 'Yep!');
  },
  child: const Text('Yep!'),
)
```

### Nope 버튼 {:#nope-button}

<?code-excerpt "lib/main.dart (Nope)" replace="/^child: //g;/^\),$/)/g"?>
```dart
ElevatedButton(
  onPressed: () {
    // 화면을 닫고, 결과로 "Nope."을 반환합니다.
    Navigator.pop(context, 'Nope.');
  },
  child: const Text('Nope.'),
)
```

## 5. 선택한 아이템으로 홈 화면에 스낵바 표시 {:#5-show-a-snackbar-on-the-home-screen-with-the-selection}

이제 선택 화면을 시작하고 결과를 기다리고 있으므로, 반환된 정보로 무언가를 하고 싶을 것입니다.

이 경우, `SelectionButton`에서 `_navigateAndDisplaySelection()` 메서드를 사용하여 
결과를 표시하는 스낵바를 표시합니다.

<?code-excerpt "lib/main.dart (navigateAndDisplay)"?>
```dart
// SelectionScreen을 실행하고, Navigator.pop에서 결과를 기다리는 메서드입니다.
Future<void> _navigateAndDisplaySelection(BuildContext context) async {
  // Navigator.push는 Selection Screen에서 Navigator.pop을 호출한 후 완료되는 Future를 반환합니다.
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SelectionScreen()),
  );

  // StatefulWidget에서 BuildContext를 사용하는 경우, 비동기 간격 후에 mounted 속성을 확인해야 합니다.
  if (!context.mounted) return;

  // Selection Screen에서 결과가 반환되면, 이전 스낵바를 숨기고 새로운 결과를 표시합니다.
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$result')));
}
```

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Return from Data hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Returning Data',
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Returning Data Demo'),
      ),
      body: const Center(
        child: SelectionButton(),
      ),
    );
  }
}

class SelectionButton extends StatefulWidget {
  const SelectionButton({super.key});

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _navigateAndDisplaySelection(context);
      },
      child: const Text('Pick an option, any option!'),
    );
  }

  // SelectionScreen을 실행하고 Navigator.pop에서 결과를 기다리는 메서드입니다.
  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push는 Selection Screen에서 
    // Navigator.pop을 호출한 후 완료되는 Future를 반환합니다.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectionScreen()),
    );

    // StatefulWidget에서 BuildContext를 사용하는 경우, 비동기 간격 후에 mounted 속성을 확인해야 합니다.
    if (!context.mounted) return;

    // Selection Screen에서 결과가 반환되면, 
    // 이전 스낵바를 숨기고 새로운 결과를 표시합니다.
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
  }
}

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick an option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // 화면을 닫고, 결과로 "Yep!"을 반환합니다.
                  Navigator.pop(context, 'Yep!');
                },
                child: const Text('Yep!'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // 화면을 닫고, 결과로 "Nope."을 반환합니다.
                  Navigator.pop(context, 'Nope.');
                },
                child: const Text('Nope.'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/returning-data.gif" alt="Returning data demo" class="site-mobile-screenshot" />
</noscript>


[`Navigator.pop()`]: {{site.api}}/flutter/widgets/Navigator/pop.html
