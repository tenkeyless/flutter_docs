---
# title: Using Actions and Shortcuts
title: 동작 및 단축키 사용
# description: How to use Actions and Shortcuts in your Flutter app.
description: Flutter 앱에서 액션과 단축키를 사용하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

이 페이지는 사용자 인터페이스에서 실제 키보드 이벤트를 동작에 바인딩하는 방법을 설명합니다. 
예를 들어, 애플리케이션에서 키보드 단축키를 정의하려면, 이 페이지가 적합합니다.

## 개요 {:#overview}

GUI 애플리케이션이 무언가를 하려면, 액션이 있어야 합니다. 사용자는 애플리케이션에 무언가를 _하라고_ 말하고 싶어합니다. 
액션은 종종 액션을 직접 수행하는 간단한 함수입니다. (예: 값 설정 또는 파일 저장) 
그러나, 더 큰 애플리케이션에서는, 상황이 더 복잡합니다. 액션을 호출하는 코드와, 액션 자체의 코드가 다른 위치에 있어야 할 수 있습니다. 
단축키(키 바인딩)는 호출하는 액션에 대해 아무것도 모르는 레벨에서 정의해야 할 수 있습니다.

여기서 Flutter의 액션 및 단축키 시스템이 등장합니다. 개발자는 자신에게 바인딩된 인텐트를 충족하는 액션을 정의할 수 있습니다. 
이 컨텍스트에서, 인텐트(intent)는 사용자가 수행하려는 일반적인 액션(generic action)이고, 
[`Intent`][] 클래스 인스턴스는 Flutter에서 이러한 사용자 인텐트를 나타냅니다. 
`Intent`는, 다양한 컨텍스트에서 다양한 액션으로 충족되는, 범용 목적일 수 있습니다. 
[`Action`][]은 간단한 콜백(예: [`CallbackAction`][])일 수도 있고, 
전체 실행 취소/재실행 아키텍처나 다른 논리를 통합하는 보다 복잡한 것일 수도 있습니다.

![Using Shortcuts Diagram][]{:width="100%"}

[`Shortcuts`][]는 키나 키 조합을 눌러 활성화되는 키 바인딩입니다. 
키 조합은 바인딩된 인텐트가 있는 테이블에 있습니다. 
`Shortcuts` 위젯이 이를 호출하면, 일치하는 인텐트를 실행을 위해 작업 하위 시스템으로 전송합니다.

이 문서에서는 액션과 단축키의 개념을 설명하기 위해, 
사용자가 버튼과 단축키를 모두 사용하여 텍스트 필드에서 텍스트를 선택하고 복사할 수 있는 간단한 앱을 만듭니다.

### 왜 Actions과 Intents를 분리해야 할까요? {:#why-separate-actions-from-intents}

궁금할 수도 있습니다. 왜 키 조합을 액션에 직접 매핑하지 않을까요? 왜 인텐트가 있는 걸까요? 
이는 키 매핑 정의가 있는 곳(종종 상위 레벨)과 액션 정의가 있는 곳(종종 하위 레벨) 사이에 관심사를 분리하는 것이 유용하기 때문이며, 
앱에서 의도한(intended) 작업에 단일 키 조합을 매핑하고, 
초점이 맞춰진 컨텍스트에서 의도한 작업을 충족하는 액션에 자동으로 적응하는 것이 중요하기 때문입니다.

예를 들어, Flutter에는 각 타입의 컨트롤을 해당 버전의 `ActivateAction`에 매핑하는 `ActivateIntent` 위젯이 있습니다.
(그리고 컨트롤을 활성화하는 코드를 실행합니다) 
이 코드는 종종 작업을 수행하기 위해 상당히(fairly) private 액세스가 필요합니다. 
`Intent`가 제공하는 간접적 레이어가 없다면, 
`Shortcuts` 위젯의 정의 인스턴스가 볼 수 있는 위치로 액션 정의를 승격(elevate)해야 하므로, 
shortcuts이 호출할 액션에 대해 필요 이상으로 많은 지식을 갖게 되고, 
그렇지 않으면, 반드시 필요하지 않거나 필요하지 않은 상태에 액세스하거나 제공하게 됩니다. 
이렇게 하면 코드에서 두 가지 관심사를 분리하여 더 독립적으로 만들 수 있습니다.

Intents는 동일한 액션이 여러 용도로 사용될 수 있도록 작업을 구성합니다. 
이에 대한 예로는 `DirectionalFocusIntent`가 있는데, 
이는 초점을 이동할 방향을 받아서, `DirectionalFocusAction`이 초점을 이동할 방향을 알 수 있도록 합니다. 
다만 조심하세요. `Action`의 모든 호출에 적용되는 `Intent`의 상태를 전달하지 마세요. 
그런 종류의 상태는 `Action` 자체의 생성자에 전달해야 `Intent`가 너무 많은 것을 알 필요가 없습니다.

### 왜 콜백을 사용하지 않나요? {:#why-not-use-callbacks}

또한 궁금할 수도 있습니다. 왜 `Action` 객체 대신 콜백을 사용하지 않을까요? 
주된 이유는 `isEnabled`를 구현하여 액션이 활성화되었는지 여부를 결정하는 데 유용하기 때문입니다. 
또한, 키 바인딩과 해당 바인딩의 구현이 다른 위치에 있는 경우 종종 도움이 됩니다.

`Actions`와 `Shortcuts`의 유연성 없이 콜백만 필요한 경우, [`CallbackShortcuts`][] 위젯을 사용할 수 있습니다.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (callback-shortcuts)"?>
```dart
@override
Widget build(BuildContext context) {
  return CallbackShortcuts(
    bindings: <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.arrowUp): () {
        setState(() => count = count + 1);
      },
      const SingleActivator(LogicalKeyboardKey.arrowDown): () {
        setState(() => count = count - 1);
      },
    },
    child: Focus(
      autofocus: true,
      child: Column(
        children: <Widget>[
          const Text('Press the up arrow key to add to the counter'),
          const Text('Press the down arrow key to subtract from the counter'),
          Text('count: $count'),
        ],
      ),
    ),
  );
}
```

## Shortcuts {:#shortcuts}

아래에서 볼 수 있듯이, 액션은 그 자체로 유용하지만, 가장 일반적인 사용 사례는 키보드 단축키에 바인딩하는 것입니다. 
이것이 바로 `Shortcuts` 위젯의 용도입니다.

이 위젯은 해당 키 조합을 눌렀을 때, 사용자의 의도(intent)를 나타내는 키 조합을 정의하기 위해, 위젯 계층에 삽입됩니다. 
키 조합에 대한 의도된 목적을 구체적인 액션으로 변환하기 위해, 
`Actions` 위젯은 `Intent`를 `Action`에 매핑하는 데 사용되었습니다. 
예를 들어, `SelectAllIntent`를 정의하고, 
이를 당신 자신의 `SelectAllAction` 또는 당신의 `CanvasSelectAllAction`에 바인딩할 수 있으며, 
해당 키 바인딩에서 시스템은 애플리케이션의 어느 부분에 포커스가 있는지에 따라, 두 키 중 하나를 호출합니다. 
키 바인딩 부분이 어떻게 작동하는지 살펴보겠습니다.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (shortcuts)"?>
```dart
@override
Widget build(BuildContext context) {
  return Shortcuts(
    shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA):
          const SelectAllIntent(),
    },
    child: Actions(
      dispatcher: LoggingActionDispatcher(),
      actions: <Type, Action<Intent>>{
        SelectAllIntent: SelectAllAction(model),
      },
      child: Builder(
        builder: (context) => TextButton(
          onPressed: Actions.handler<SelectAllIntent>(
            context,
            const SelectAllIntent(),
          ),
          child: const Text('SELECT ALL'),
        ),
      ),
    ),
  );
}
```

`Shortcuts` 위젯에 주어진 맵은 `LogicalKeySet`(또는 `ShortcutActivator`, 아래 note 참고)을 `Intent` 인스턴스에 매핑합니다. 
논리적 키 세트는 하나 이상의 키 세트를 정의하고, 인텐트는 키 누름의 의도된 목적을 나타냅니다. 
`Shortcuts` 위젯은 맵에서 키 누름을 조회하여, `Intent` 인스턴스를 찾은 다음, 이를 액션의 `invoke()` 메서드에 제공합니다.

:::note
`ShortcutActivator`는 `LogicalKeySet`의 대체품입니다. 
단축키를 보다 유연하고 정확하게 활성화할 수 있습니다. 
`LogicalKeySet`는 물론 `ShortcutActivator`이지만, 
단일 키와 키 전에 눌러야 할 선택적 수정자를 취하는 `SingleActivator`도 있습니다. 
그런 다음, 논리적 키 자체가 아닌, 키 시퀀스에서 생성된 문자를 기반으로 단축키를 활성화하는 `CharacterActivator`가 있습니다. 
`ShortcutActivator`는 키 이벤트에서 단축키를 활성화하는 커스텀 방식을 허용하도록 하위 클래스화되도록 설계되었습니다.
:::

### ShortcutManager {:#the-shortcutmanager}

`Shortcuts` 위젯보다 더 오래 지속되는 객체인, 바로가기 관리자(shortcut manager)는, 키 이벤트를 수신하면 이를 전달합니다.
여기에는 키를 처리하는 방법을 결정하는 로직, 다른 바로가기 매핑을 찾기 위해 트리를 올라가는 로직이 포함되며, 
인텐트에 대한 키 조합 맵을 유지 관리합니다.

`ShortcutManager`의 기본 동작은 일반적으로 바람직하지만(desirable), 
`Shortcuts` 위젯은 기능을 커스터마이즈 하기 위해 하위 클래스화할 수 있는 `ShortcutManager`를 사용합니다.

예를 들어, `Shortcuts` 위젯이 처리하는 각 키를 기록하려면, `LoggingShortcutManager`를 만들 수 있습니다.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (logging-shortcut-manager)"?>
```dart
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      print('Handled shortcut $event in $context');
    }
    return result;
  }
}
```

이제, `Shortcuts` 위젯이 단축키를 처리할 때마다, 키 이벤트와 관련 컨텍스트를 출력합니다.

## Actions {:#actions}

`Actions`는 애플리케이션이 `Intent`로 호출하여 수행할 수 있는 작업의 정의를 허용합니다. 
Actions는 활성화 또는 비활성화할 수 있으며, 호출한 Intent 인스턴스를 인수로 수신하여, Intent로 구성할 수 있습니다.

### 액션 정의하기 {:#defining-actions}

가장 단순한 형태의 액션은, 단순히 `invoke()` 메서드만 있는 `Action<Intent>`의 하위 클래스입니다. 
제공된 모델에서 함수를 호출하는 간단한 액션은 다음과 같습니다.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (select-all-action)"?>
```dart
class SelectAllAction extends Action<SelectAllIntent> {
  SelectAllAction(this.model);

  final Model model;

  @override
  void invoke(covariant SelectAllIntent intent) => model.selectAll();
}
```

또는, 새로운 클래스를 만드는 것이 너무 번거롭다면, `CallbackAction`을 사용하세요.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (callback-action)"?>
```dart
CallbackAction(onInvoke: (intent) => model.selectAll());
```

액션이 있으면, [`Actions`][] 위젯을 사용하여 애플리케이션에 추가합니다. 
이 위젯은 `Intent` 타입을 `Action`으로 매핑합니다.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (select-all-usage)"?>
```dart
@override
Widget build(BuildContext context) {
  return Actions(
    actions: <Type, Action<Intent>>{
      SelectAllIntent: SelectAllAction(model),
    },
    child: child,
  );
}
```

`Shortcuts` 위젯은 `Focus` 위젯의 컨텍스트와 `Actions.invoke`를 사용하여 호출할 액션을 찾습니다. 
`Shortcuts` 위젯이 처음 발견한 `Actions` 위젯에서 일치하는 인텐트 타입을 찾지 못하면, 
다음 조상 `Actions` 위젯을 고려하는 식으로, 
위젯 트리의 루트에 도달하거나 일치하는 인텐트 타입을 찾아 해당 작업을 호출합니다.

### 액션 호출 {:#invoking-actions}

액션 시스템은 액션을 호출하는 여러 가지 방법을 가지고 있습니다. 
지금까지 가장 일반적인 방법은 이전 섹션에서 다룬 `Shortcuts` 위젯을 사용하는 것이지만, 
액션 하위 시스템을 조사하고 액션을 호출하는 다른 방법도 있습니다. 
키에 바인딩되지 않은 액션을 호출할 수 있습니다.

예를 들어, 인텐트와 연관된 액션을 찾으려면 다음을 사용할 수 있습니다.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (maybe-find)"?>
```dart
Action<SelectAllIntent>? selectAll =
    Actions.maybeFind<SelectAllIntent>(context);
```

주어진 `context`에서 사용 가능한 경우, `SelectAllIntent` 타입과 연관된 `Action`을 반환합니다. 
사용할 수 없는 경우, null을 반환합니다. 
연관된 `Action`이 항상 사용 가능해야 하는 경우, 
일치하는 `Intent` 타입을 찾지 못하면 예외를 throw하는 `maybeFind` 대신 `find`를 사용합니다.

해당 작업을 호출하려면(존재하는 경우), 다음을 호출합니다.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (invoke-action)"?>
```dart
Object? result;
if (selectAll != null) {
  result =
      Actions.of(context).invokeAction(selectAll, const SelectAllIntent());
}
```

다음을 사용하여 하나의 호출로 결합합니다.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (maybe-invoke)"?>
```dart
Object? result =
    Actions.maybeInvoke<SelectAllIntent>(context, const SelectAllIntent());
```

때로는 버튼이나 다른 컨트롤을 눌러서 액션을 호출하고 싶을 때가 있습니다. 
`Actions.handler` 함수를 사용하면 됩니다. 
인텐트에 활성화된 액션에 대한 매핑이 있는 경우, `Actions.handler` 함수는 핸들러 클로저를 만듭니다. 
그러나, 매핑이 없는 경우, `null`을 반환합니다. 
이렇게 하면 컨텍스트에서 일치하는 활성화된 액션이 없는 경우, 버튼을 비활성화할 수 있습니다.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (handler)"?>
```dart
@override
Widget build(BuildContext context) {
  return Actions(
    actions: <Type, Action<Intent>>{
      SelectAllIntent: SelectAllAction(model),
    },
    child: Builder(
      builder: (context) => TextButton(
        onPressed: Actions.handler<SelectAllIntent>(
          context,
          SelectAllIntent(controller: controller),
        ),
        child: const Text('SELECT ALL'),
      ),
    ),
  );
}
```

`Actions` 위젯은 `isEnabled(Intent intent)`가 true를 반환할 때만 액션을 호출하여, 
디스패처가 호출을 위해 액션을 고려해야 하는지 여부를 액션이 결정할 수 있도록 합니다. 
액션이 활성화되지 않은 경우, 
`Actions` 위젯은 위젯 계층 구조에서 더 높은 활성화된 다른 액션(존재하는 경우)에 실행할 기회를 제공합니다.

이전 예제는 `Builder`를 사용합니다. `Actions.handler`와 `Actions.invoke`(예시)는 제공된 `context`에서만 액션을 찾고, 이 예제가 `build` 함수에 제공된 `context`를 전달하면, 프레임워크가 현재 위젯 _위에서_ 찾기 시작합니다. 
`Builder`를 사용하면 프레임워크가 동일한 `build` 함수에 정의된 액션을 찾을 수 있습니다.

`BuildContext`가 없어도 액션을 호출할 수 있지만, `Actions` 위젯은 호출할 활성화된 액션을 찾기 위해 컨텍스트가 필요하므로, 
직접 `Action` 인스턴스를 만들거나, `Actions.find`를 사용하여 적절한 컨텍스트에서 액션을 찾아서 제공해야 합니다.

액션을 호출하려면, 직접 만든 `ActionDispatcher`의 `invoke` 메서드에 액션을 전달하거나, 
`Actions.of(context)` 메서드를 사용하여 기존 `Actions` 위젯에서 검색한 액션을 전달합니다. 
`invoke`를 호출하기 전에 액션이 활성화되었는지 확인합니다. 
물론, 액션 자체에서 `invoke`를 호출하여 `Intent`를 전달할 수도 있지만, 
그러면 액션 디스패처가 제공하는 모든 서비스(로깅, 실행 취소/다시 실행 등)를 옵트아웃합니다.

### 액션 디스패처 (dispatchers) {:#action-dispatchers}

If you want a log of all the actions invoked, however, you can create your own `LoggingActionDispatcher` to do the job:

대부분의 경우, 여러분은 그저 액션을 호출하고, 액션이 그 일을 하게 한 다음, 잊어버리고 싶을 것입니다. 
하지만, 가끔은 실행된 액션을 기록하고 싶을 수도 있습니다.

여기서 기본 `ActionDispatcher`를 커스텀 디스패처로 바꾸는 것이 등장합니다. 
`ActionDispatcher`를 `Actions` 위젯에 전달하면, 
디스패처를 설정하지 않은 그 위젯 아래의 모든 `Actions` 위젯에서 액션을 호출합니다.

`Actions`가 액션을 호출할 때 하는 첫 번째 일은, 
`ActionDispatcher`를 찾아서 호출을 위해 액션을 전달하는 것입니다. 
아무것도 없다면, 단순히 액션을 호출하는 기본 `ActionDispatcher`를 만듭니다.

하지만 호출된 모든 액션의 로그를 원한다면, 작업을 수행하기 위해 여러분만의 `LoggingActionDispatcher`를 만들 수 있습니다.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (logging-action-dispatcher)"?>
```dart
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);

    return null;
  }

  @override
  (bool, Object?) invokeActionIfEnabled(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Action invoked: $action($intent) from $context');
    return super.invokeActionIfEnabled(action, intent, context);
  }
}
```

그런 다음 최상위 `Actions` 위젯에 전달합니다.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/samples.dart (logging-action-dispatcher-usage)"?>
```dart
@override
Widget build(BuildContext context) {
  return Actions(
    dispatcher: LoggingActionDispatcher(),
    actions: <Type, Action<Intent>>{
      SelectAllIntent: SelectAllAction(model),
    },
    child: Builder(
      builder: (context) => TextButton(
        onPressed: Actions.handler<SelectAllIntent>(
          context,
          const SelectAllIntent(),
        ),
        child: const Text('SELECT ALL'),
      ),
    ),
  );
}
```

이렇게 하면 모든 액션이 실행될 때마다 기록됩니다.

```console
flutter: Action invoked: SelectAllAction#906fc(SelectAllIntent#a98e3) from Builder(dependencies: _[ActionsMarker])
```

## 함께 정리하기 {:#putting-it-together}

`Actions`와 `Shortcuts`의 조합은 강력합니다. 
위젯 레벨에서 특정 액션에 매핑되는 일반적인 의도(intents)를 정의할 수 있습니다. 
위에 설명된 개념을 보여주는 간단한 앱이 있습니다. 
이 앱은 옆에 "모두 선택" 및 "클립보드에 복사" 버튼이 있는 텍스트 필드를 만듭니다. 
버튼은 작업을 수행하기 위해 액션을 호출합니다. 
호출된 모든 액션과 단축키는 기록됩니다.

<?code-excerpt "ui/advanced/actions_and_shortcuts/lib/copyable_text.dart"?>
```dartpad title="Copyable text DartPad hands-on example" run="true"
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 모든 텍스트를 선택하고 선택한 텍스트를 클립보드에 복사할 수 있는 버튼이 있는 텍스트 필드입니다.
class CopyableTextField extends StatefulWidget {
  const CopyableTextField({super.key, required this.title});

  final String title;

  @override
  State<CopyableTextField> createState() => _CopyableTextFieldState();
}

class _CopyableTextFieldState extends State<CopyableTextField> {
  late final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      dispatcher: LoggingActionDispatcher(),
      actions: <Type, Action<Intent>>{
        ClearIntent: ClearAction(controller),
        CopyIntent: CopyAction(controller),
        SelectAllIntent: SelectAllAction(controller),
      },
      child: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: Row(
              children: <Widget>[
                const Spacer(),
                Expanded(
                  child: TextField(controller: controller),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed:
                      Actions.handler<CopyIntent>(context, const CopyIntent()),
                ),
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: Actions.handler<SelectAllIntent>(
                      context, const SelectAllIntent()),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// 처리하는 모든 키를 기록하는 ShortcutManager입니다.
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      print('Handled shortcut $event in $context');
    }
    return result;
  }
}

/// 호출하는 모든 액션을 기록하는 ActionDispatcher입니다.
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);

    return null;
  }
}

/// TextEditingController를 지우기 위해(clear) ClearAction에 바인딩되는 인텐트입니다.
class ClearIntent extends Intent {
  const ClearIntent();
}

/// ClearIntent에 바인딩되어 TextEditingController를 지우는(clear) 액션입니다.
class ClearAction extends Action<ClearIntent> {
  ClearAction(this.controller);

  final TextEditingController controller;

  @override
  Object? invoke(covariant ClearIntent intent) {
    controller.clear();

    return null;
  }
}

/// TextEditingController에서 복사하기 위해 CopyAction에 바인딩된 인텐트입니다.
class CopyIntent extends Intent {
  const CopyIntent();
}

/// TextEditingController에 있는 텍스트를 클립보드에 복사하는 CopyIntent에 바인딩된 작업입니다.
class CopyAction extends Action<CopyIntent> {
  CopyAction(this.controller);

  final TextEditingController controller;

  @override
  Object? invoke(covariant CopyIntent intent) {
    final String selectedString = controller.text.substring(
      controller.selection.baseOffset,
      controller.selection.extentOffset,
    );
    Clipboard.setData(ClipboardData(text: selectedString));

    return null;
  }
}

/// 컨트롤러에 있는 모든 텍스트를 선택하기 위해 SelectAllAction에 바인딩된 인텐트입니다.
class SelectAllIntent extends Intent {
  const SelectAllIntent();
}

/// TextEditingController에 있는 모든 텍스트를 선택하는 SelectAllAction에 바인딩된 액션입니다.
class SelectAllAction extends Action<SelectAllIntent> {
  SelectAllAction(this.controller);

  final TextEditingController controller;

  @override
  Object? invoke(covariant SelectAllIntent intent) {
    controller.selection = controller.selection.copyWith(
      baseOffset: 0,
      extentOffset: controller.text.length,
      affinity: controller.selection.affinity,
    );

    return null;
  }
}

/// 최상위 레벨 애플리케이션 클래스.
///
/// 여기에 정의된 단축키는 전체 앱에 적용되지만, 위젯마다 다르게 구현될 수 있습니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String title = 'Shortcuts and Actions Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.escape): const ClearIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC):
              const CopyIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA):
              const SelectAllIntent(),
        },
        child: const CopyableTextField(title: title),
      ),
    );
  }
}

void main() => runApp(const MyApp());
```


[`Action`]: {{site.api}}/flutter/widgets/Action-class.html
[`Actions`]: {{site.api}}/flutter/widgets/Actions-class.html
[`CallbackAction`]: {{site.api}}/flutter/widgets/CallbackAction-class.html
[`CallbackShortcuts`]: {{site.api}}/flutter/widgets/CallbackShortcuts-class.html
[`Intent`]: {{site.api}}/flutter/widgets/Intent-class.html
[`Shortcuts`]: {{site.api}}/flutter/widgets/Shortcuts-class.html
[Using Shortcuts Diagram]: /assets/images/docs/using_shortcuts.png
