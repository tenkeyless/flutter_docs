---
# title: Understanding Flutter's keyboard focus system
title: Flutter의 키보드 포커스 시스템 이해
# description: How to use the focus system in your Flutter app.
description: Flutter 앱에서 포커스 시스템을 사용하는 방법.
---

이 문서에서는 키보드 입력이 어디로 향하는지 제어하는 ​​방법을 설명합니다. 
대부분의 데스크톱 및 웹 애플리케이션과 같이 물리적 키보드를 사용하는 애플리케이션을 구현하는 경우, 이 페이지가 적합합니다. 
앱이 물리적 키보드와 함께 사용되지 않는 경우, 건너뛸 수 있습니다.

## 개요 {:#overview}

Flutter에는 키보드 입력을 애플리케이션의 특정 부분으로 보내는 포커스 시스템이 있습니다. 
이를 위해, 사용자는 원하는 UI 요소를 탭하거나 클릭하여, 입력을 애플리케이션의 해당 부분에 "포커스"합니다. 
이렇게 되면, 키보드로 입력한 텍스트가 포커스가 애플리케이션의 다른 부분으로 이동할 때까지 해당 애플리케이션 부분으로 흐릅니다. 포커스는 특정 키보드 단축키를 눌러 이동할 수도 있는데, 
이는 일반적으로 <kbd>Tab</kbd>에 바인딩되어 있으므로 "탭 트래버설(tab traversal)"이라고도 합니다.

이 페이지에서는 Flutter 애플리케이션에서 이러한 작업을 수행하는 데 사용되는 API와 포커스 시스템의 작동 방식을 살펴봅니다. 
개발자들 사이에서 [`FocusNode`][] 객체를 정의하고 사용하는 방법에 대해 혼란이 있는 것을 알았습니다. 
이것이 여러분의 경험을 설명하는 경우, 
[`FocusNode` 객체를 만드는 모범 사례](#best-practices-for-creating-focusnode-objects)로 건너뜁니다.

### 포커스 사용 사례 {:#focus-use-cases}

포커스 시스템을 사용하는 방법을 알아야 할 수 있는 상황의 몇 가지 예:

- [키 이벤트 수신/처리](#key-events)
- [포커스 가능해야 하는 커스텀 컴포넌트 구현](#focus-widget)
- [포커스가 변경될 때 알림 수신](#change-notifications)
- [애플리케이션에서 포커스 트래버설의 "탭 순서" 변경 또는 정의](#focustraversalpolicy)
- [함께 트래버설해야 하는 컨트롤 그룹 정의](#focustraversalgroup-widget)
- [애플리케이션에서 일부 컨트롤이 포커스 가능하지 않도록 방지](#controlling-what-gets-focus)

## 용어집 {:#glossary}

아래는 Flutter에서 포커스 시스템의 요소에 사용하는 용어입니다. 
이러한 개념 중 일부를 구현하는 다양한 클래스가 아래에 소개됩니다.

- **포커스 트리 (Focus tree)** 
  - 일반적으로 위젯 트리를 희소하게(sparsely) 미러링하는 포커스 노드 트리로, 
  - 포커스를 받을 수 있는 모든 위젯을 나타냅니다.
- **포커스 노드 (Focus node)** 
  - 포커스 트리의 단일 노드. 
  - 이 노드는 포커스를 받을 수 있으며, 포커스 체인의 일부일 때 "포커스가 있다"고 합니다. 
    포커스가 있을 때만 키 이벤트를 처리하는 데 참여합니다.
- **주 포커스 (Primary focus)** 
  - 포커스가 있는 포커스 트리의 루트에서 가장 먼 포커스 노드입니다. 
  - 이것은 키 이벤트가 주 포커스 노드와 그 조상으로 전파되기 시작하는 포커스 노드입니다.
- **포커스 체인 (Focus chain)**
  - 주 포커스 노드에서 시작하여 포커스 트리의 분기를 따라 포커스 트리의 루트까지 이어지는 포커스 노드의 정렬된 리스트입니다.
- **포커스 범위 (Focus scope)**
  - 다른 포커스 노드 그룹을 포함하고 해당 노드만 포커스를 받도록 하는 것이 작업인 특수 포커스 노드입니다. 
  - 하위 트리에서 이전에 포커스가 있었던 노드에 대한 정보가 포함되어 있습니다.
- **포커스 트래버설 (Focus traversal)** 
  - 예측 가능한 순서로 한 포커스 가능 노드에서 다른 포커스 가능 노드로 이동하는 프로세스입니다. 
  - 이는 일반적으로 사용자가 <kbd>Tab</kbd>을 눌러 다음 포커스 가능 컨트롤이나 필드로 이동할 때, 
    애플리케이션에서 볼 수 있습니다.

## FocusNode 및 FocusScopeNode {:#focusnode-and-focusscopenode}

`FocusNode` 및 [`FocusScopeNode`][] 객체는 포커스 시스템의 메커니즘을 구현합니다. 
오래 지속되는 객체(위젯보다 더 오래감. 렌더 객체와 유사)로, 포커스 상태와 속성을 유지하여 위젯 트리의 빌드 간에 지속됩니다. 
함께, 포커스 트리 데이터 구조를 형성합니다.

원래는 포커스 시스템의 일부 측면을 제어하는 ​​데 사용되는 개발자 대상 객체로 의도되었지만, 
시간이 지남에 따라 포커스 시스템의 세부 정보를 주로 구현하도록 발전했습니다. 
기존 애플리케이션을 손상시키지 않기 위해, 속성에 대한 공개 인터페이스가 여전히 포함되어 있습니다. 
그러나, 일반적으로, 가장 유용한 것은 상대적으로 불투명한(opaque) 핸들 역할을 하여, 
조상 위젯에서 `requestFocus()`를 호출하기 위해 자손 위젯에 전달하여 자손 위젯이 포커스를 얻도록 요청하는 것입니다. 
다른 속성의 설정은 [`Focus`][] 또는 [`FocusScope`][] 위젯에서 가장 잘 관리합니다. 
이를 사용하지 않거나, 고유한 버전을 구현하지 않는 한 말입니다.

### FocusNode 객체를 생성하기 위한 모범 사례 {:#best-practices-for-creating-focusnode-objects}

이러한 객체를 사용하는 데 대한 몇 가지 해야 할 일과 하지 말아야 할 일은 다음과 같습니다.

- \<Don't\> 각 빌드에 대해 새 `FocusNode`를 할당하지 마세요. 
  - 이렇게 하면 메모리 누수가 발생할 수 있으며, 
  - 노드에 포커스가 있는 동안 위젯을 다시 빌드할 때 가끔 포커스가 손실될 수 있습니다.
- \<Do\> stateful 위젯에서 `FocusNode` 및 `FocusScopeNode` 객체를 만드세요. 
  - `FocusNode` 및 `FocusScopeNode`는 사용이 끝나면 폐기(disposed)해야 하므로, 
    stateful 위젯의 상태 객체 내부에서만 만들어야 하며, 
    여기서 `dispose`를 재정의하여 폐기할 수 있습니다.
- \<Don't\> 여러 위젯에 동일한 `FocusNode`를 사용하지 마세요. 
  - 그렇게 하면, 위젯이 노드의 속성을 관리하기 위해 다투고, 예상한 결과를 얻지 못할 수 있습니다.
- \<Do\> 포커스 문제를 진단하는 데 도움이 되도록 포커스 노드 위젯의 `debugLabel`을 설정하세요.
  \<Don't\> `Focus` 또는 `FocusScope` 위젯에서 관리하는 경우, 
  `FocusNode` 또는 `FocusScopeNode`에 `onKeyEvent` 콜백을 설정하지 마세요. 
  - `onKeyEvent` 핸들러가 필요한 경우, 수신하려는 위젯 서브트리 주위에 새 `Focus` 위젯을 추가하고, 
    위젯의 `onKeyEvent` 속성을 핸들러로 설정하세요. 
  - 주 포커스를 받지 않으려면 위젯에 `canRequestFocus: false`를 설정하세요. 
  - 이는 `Focus` 위젯의 `onKeyEvent` 속성이 후속 빌드에서 다른 것으로 설정될 수 있고, 
    그럴 경우 노드에 설정한 `onKeyEvent` 핸들러를 덮어쓰기 때문입니다.
- \<Do\> 노드에서 `requestFocus()`를 호출하여 주 포커스를 받도록 요청하세요. 
  - 특히, 소유한 노드를 포커스를 지정하려는 하위 노드로 전달한 상위 노드에서요.
- \<Do\> `focusNode.requestFocus()`를 사용하세요. 
  - `FocusScope.of(context).requestFocus(focusNode)`를 호출할 필요는 없습니다. 
  - `focusNode.requestFocus()` 메서드는 동등하고 성능이 더 좋습니다.

### Unfocusing {:#unfocusing}

`FocusNode.unfocus()`라는 이름의, 노드에 "포커스를 포기"하라고 말하는 API가 있습니다. 
노드에서 포커스를 제거하지만, 모든 노드를 "포커스 해제"하는 것은 실제로 불가능하다는 것을 깨닫는 것이 중요합니다. 
노드가 포커스 해제된 경우, _항상_ 주 포커스가 있기 때문에 다른 곳으로 포커스를 전달해야 합니다. 
노드가 `unfocus()`를 호출할 때 포커스를 받는 노드는 `unfocus()`에 제공된 `disposition` 인수에 따라, 
가장 가까운 `FocusScopeNode`이거나 해당 범위에서 이전에 포커스된 노드입니다. 
노드에서 포커스를 제거할 때 포커스가 이동하는 위치를 더 많이 제어하려면, `unfocus()`를 호출하는 대신, 
(1) 다른 노드에 명시적으로 포커스를 지정하거나 
(2) 포커스 트래버설 메커니즘을 사용하여 `FocusNode`에서 `focusInDirection`, `nextFocus` 또는 `previousFocus` 메서드를 사용하여 다른 노드를 찾습니다.

`unfocus()`를 호출할 때, `disposition` 인수는 두 가지 언포커싱 모드를 허용합니다. 
(1) [`UnfocusDisposition.scope`][] 및 (2) `UnfocusDisposition.previouslyFocusedChild`. 
기본값은 `scope`로, 가장 가까운 부모 포커스 범위에 포커스를 제공합니다. 
즉, 그 후 포커스가 `FocusNode.nextFocus`로 다음 노드로 이동하면, 범위에서 "첫 번째" 포커스 가능 항목부터 시작합니다.

`previouslyFocusedChild` 디스포지션은 범위를 검색하여 이전에 포커스된 자식을 찾고 해당 자식에 포커스를 요청합니다. 
이전에 포커스된 자식이 없으면, `scope`와 동일합니다.

:::secondary 주의
다른 범위가 없는 경우, 포커스는 포커스 시스템의 루트 범위 노드인 `FocusManager.rootScope`로 이동합니다. 
이는 일반적으로 바람직하지 않은데, 루트 범위에는 프레임워크가 다음에 어떤 노드에 포커스를 맞춰야 하는지 결정할 `context`가 없기 때문입니다. 
애플리케이션이 포커스 트래버설을 사용하여 탐색하는 기능을 갑자기 잃는 경우, 아마도 이런 일이 일어났을 것입니다. 
이를 수정하려면, 포커스 해제를 요청하는 포커스 노드에 `FocusScope`를 조상으로 추가합니다. 
`WidgetsApp`(`MaterialApp` 및 `CupertinoApp`가 파생됨)에는 자체 `FocusScope`가 있으므로, 
이를 사용하는 경우 문제가 되지 않습니다.
:::

## Focus 위젯 {:#focus-widget}

`Focus` 위젯은 포커스 노드를 소유하고 관리하며, 포커스 시스템의 일꾼(workhorse)입니다. 
포커스 트리에서 소유한 포커스 노드의 연결 및 분리를 관리하고, 포커스 노드의 속성 및 콜백을 관리하며, 
위젯 트리에 연결된 포커스 노드를 검색할 수 있는 static 함수가 있습니다.

가장 간단한 형태로, `Focus` 위젯을 위젯 하위 트리 주위에 래핑하면, 
해당 위젯 하위 트리가 포커스 트래버설 프로세스의 일부로 포커스를 얻거나, 
`FocusNode`에 전달된 `requestFocus`가 호출될 때마다 포커스를 얻을 수 있습니다. 
`requestFocus`를 호출하는 제스처 감지기와 결합하면, 탭하거나 클릭할 때 포커스를 받을 수 있습니다.

`FocusNode` 객체를 `Focus` 위젯에 전달하여 관리할 수 있지만, 전달하지 않으면 자체 객체를 만듭니다. 
자체 `FocusNode`를 만드는 주된 이유는, 
노드에서 `requestFocus()`를 호출하여 부모 위젯에서 포커스를 제어할 수 있기 때문입니다. 
`FocusNode`의 다른 기능 대부분은 `Focus` 위젯 자체의 속성을 변경하여 액세스하는 것이 가장 좋습니다.

`Focus` 위젯은 대부분의 Flutter 자체 컨트롤에서 포커스 기능을 구현하는 데 사용됩니다.

다음은 `Focus` 위젯을 사용하여 사용자 지정 컨트롤을 포커스 가능하게 만드는 방법을 보여주는 예입니다. 
포커스를 받는 것에 반응하는 텍스트가 있는 컨테이너를 만듭니다.

<?code-excerpt "ui/advanced/focus/lib/custom_control_example.dart"?>
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Focus Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[MyCustomWidget(), MyCustomWidget()],
        ),
      ),
    );
  }
}

class MyCustomWidget extends StatefulWidget {
  const MyCustomWidget({super.key});

  @override
  State<MyCustomWidget> createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget> {
  Color _color = Colors.white;
  String _label = 'Unfocused';

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _color = focused ? Colors.black26 : Colors.white;
          _label = focused ? 'Focused' : 'Unfocused';
        });
      },
      child: Center(
        child: Container(
          width: 300,
          height: 50,
          alignment: Alignment.center,
          color: _color,
          child: Text(_label),
        ),
      ),
    );
  }
}
```

### 키 이벤트 {:#key-events}

하위 트리에서 키 이벤트를 수신하려면, `Focus` 위젯의 `onKeyEvent` 속성을 키를 listens 하거나, 
키를 처리하고 다른 위젯으로의 전파를 중지하는 핸들러로 설정합니다.

키 이벤트는 주 포커스가 있는 포커스 노드에서 시작합니다. 
해당 노드가 `onKeyEvent` 핸들러에서 `KeyEventResult.handled`를 반환하지 않으면, 부모 포커스 노드에 이벤트가 제공됩니다. 
부모가 처리하지 않으면 그 부모로 이동하고, 이런 식으로 포커스 트리의 루트에 도달할 때까지 계속됩니다. 
이벤트가 처리되지 않고 포커스 트리의 루트에 도달하면, 플랫폼으로 반환되어 애플리케이션의 다음 네이티브 컨트롤에 제공됩니다. 
(Flutter UI가 더 큰 네이티브 애플리케이션 UI의 일부인 경우). 
처리된 이벤트는 다른 Flutter 위젯으로 전파되지 않으며, 네이티브 위젯에도 전파되지 않습니다.

다음은 주 포커스가 될 수 없지만 하위 트리가 처리하지 않는 모든 키를 흡수하는, `Focus` 위젯의 예입니다.

<?code-excerpt "ui/advanced/focus/lib/samples.dart (absorb-keys)"?>
```dart
@override
Widget build(BuildContext context) {
  return Focus(
    onKeyEvent: (node, event) => KeyEventResult.handled,
    canRequestFocus: false,
    child: child,
  );
}
```

포커스 키 이벤트는 텍스트 입력 이벤트보다 먼저 처리되므로, 
포커스 위젯이 텍스트 필드를 둘러싸고 있을 때 키 이벤트를 처리하면 해당 키가 텍스트 필드에 입력되지 않습니다.

다음은 텍스트 필드에 문자 "a"를 입력할 수 없는 위젯의 예입니다.

<?code-excerpt "ui/advanced/focus/lib/samples.dart (no-letter-a)"?>
```dart
@override
Widget build(BuildContext context) {
  return Focus(
    onKeyEvent: (node, event) {
      return (event.logicalKey == LogicalKeyboardKey.keyA)
          ? KeyEventResult.handled
          : KeyEventResult.ignored;
    },
    child: const TextField(),
  );
}
```

인텐트가 입력 검증이라면, 이 예제의 기능은 아마도 `TextInputFormatter`를 사용하여 구현하는 것이 더 나을 것입니다. 
하지만, 이 기술은 여전히 ​​유용할 수 있습니다. 
예를 들어, `Shortcuts` 위젯은 이 메서드를 사용하여 텍스트 입력이 되기 전에, 단축키를 처리합니다.

### 무엇이 초점을 맞출지 제어하기 {:#controlling-what-gets-focus}

포커스의 주요 측면 중 하나는 포커스를 받을 수 있는 대상과 방법을 제어하는 ​​것입니다. 
`canRequestFocus`, `skipTraversal` 및 `descendantsAreFocusable` 속성은 
이 노드와 그 하위 노드가 포커스 프로세스에 참여하는 방식을 제어합니다.

`skipTraversal` 속성이 true이면, 이 포커스 노드는 포커스 트래버설에 참여하지 않습니다. 
포커스 노드에서 `requestFocus`가 호출되면 여전히 포커스 가능하지만, 
포커스 트래버설 시스템이 다음에 포커스할 대상을 찾을 때는 건너뜁니다.

`canRequestFocus` 속성은, 놀랍지 않게도, 이 `Focus` 위젯이 관리하는 포커스 노드를 사용하여, 
포커스를 요청할 수 있는지 여부를 제어합니다. 
이 속성이 false이면, 노드에서 `requestFocus`를 호출해도 효과가 없습니다. 
또한 이 노드는 포커스를 요청할 수 없으므로, 포커스 트래버설을 위해 건너뜁니다.

`descendantsAreFocusable` 속성은 이 노드의 자손이 포커스를 받을 수 있는지 여부를 제어하지만, 
이 노드가 포커스를 받을 수 있도록 허용합니다. 
이 속성은 전체 위젯 서브트리에 대한 포커스 가능성을 끄는 데 사용할 수 있습니다. 
`ExcludeFocus` 위젯은 이렇게 작동합니다. 이는 단지, 이 속성이 설정된 `Focus` 위젯일 뿐입니다.

### 오토포커스 {:#autofocus}

`Focus` 위젯의 `autofocus` 속성을 설정하면 위젯이 속한 포커스 범위가 처음 포커스될 때 포커스를 요청합니다. 
두 개 이상의 위젯에 `autofocus`가 설정된 경우, 
포커스를 받는 위젯은 임의적이므로 포커스 범위당 하나의 위젯에만 설정하도록 하세요.

`autofocus` 속성은 노드가 속한 범위에 포커스가 없는 경우에만 적용됩니다.

다른 포커스 범위에 속하는 두 노드에 `autofocus` 속성을 설정하는 것은 잘 정의되어 있습니다. 
각 노드는 해당 범위가 포커스될 때, 포커스된 위젯이 됩니다.

### 알림 변경 {:#change-notifications}

`Focus.onFocusChanged` 콜백은 특정 노드의 포커스 상태가 변경되었다는 알림을 받는 데 사용할 수 있습니다. 
노드가 포커스 체인에 추가되거나 제거되면, 알림을 주므로 주 포커스가 아니더라도 알림을 받습니다. 
주 포커스를 받았는지 여부만 알고 싶다면, 포커스 노드에서 `hasPrimaryFocus`가 true 인지 확인하세요.

### FocusNode 얻기 {:#obtaining-the-focusnode}

때때로, `Focus` 위젯의 포커스 노드를 얻어 속성을 조사하는 것이 유용합니다.

`Focus` 위젯의 조상에서 포커스 노드에 액세스하려면, 
`FocusNode`를 만들어 `Focus` 위젯의 `focusNode` 속성으로 전달합니다. 
폐기(disposed)해야 하므로, 전달하는 포커스 노드는 stateful 위젯이 소유해야 하므로, 빌드할 때마다 하나만 만들지 마세요.

`Focus` 위젯의 자손에서 포커스 노드에 액세스해야 하는 경우, 
`Focus.of(context)`를 호출하여 주어진 컨텍스트에 가장 가까운 `Focus` 위젯의 포커스 노드를 얻을 수 있습니다. 
동일한 build 함수 내에서 `Focus` 위젯의 `FocusNode`를 얻어야 하는 경우,
[`Builder`][]를 사용하여 올바른 컨텍스트가 있는지 확인합니다. 이는 다음 예에서 보여줍니다.

<?code-excerpt "ui/advanced/focus/lib/samples.dart (builder)"?>
```dart
@override
Widget build(BuildContext context) {
  return Focus(
    child: Builder(
      builder: (context) {
        final bool hasPrimary = Focus.of(context).hasPrimaryFocus;
        print('Building with primary focus: $hasPrimary');
        return const SizedBox(width: 100, height: 100);
      },
    ),
  );
}
```

### 타이밍 {:#timing}

포커스 시스템의 세부 사항 중 하나는 포커스가 요청되면, 현재 빌드 단계가 완료된 후에만 적용된다는 것입니다. 
즉, 포커스 변경은 항상 한 프레임 지연됩니다. 
포커스를 변경하면, 현재 포커스를 요청하는 위젯의 조상을 포함하여, 위젯 트리의 임의의 부분이 재구축될 수 있기 때문입니다. 
자손은 조상을 더럽힐 수 없으므로, 프레임 사이에서 발생해야 필요한 변경 사항이 다음 프레임에서 발생할 수 있습니다.

## FocusScope 위젯 {:#focusscope-widget}

`FocusScope` 위젯은 `FocusNode` 대신 `FocusScopeNode`를 관리하는 `Focus` 위젯의 특수 버전입니다. 
`FocusScopeNode`는 서브트리의 포커스 노드에 대한 그룹화 메커니즘 역할을 하는 포커스 트리의 특수 노드입니다. 
포커스 트래버설은 범위 밖의 노드가 명시적으로 포커스되지 않는 한 포커스 범위 내에 머물러 있습니다.

포커스 범위는 또한 현재 포커스와 서브트리 내에서 포커스된 노드의 히스토리를 추적합니다. 
이런 방식으로, 노드가 포커스를 해제하거나 포커스가 있을 때 제거되면, 포커스를 이전에 포커스가 있었던 노드로 반환할 수 있습니다.

포커스 범위는 또한 하위 노드 중 어느 것도 포커스가 없는 경우 포커스를 반환할 장소 역할을 합니다. 
이를 통해 포커스 트래버설 코드는 이동할 다음(또는 첫 번째) 포커스 가능 컨트롤을 찾기 위한 시작 컨텍스트를 가질 수 있습니다.

포커스 범위 노드에 초점을 맞추면, 먼저 현재 또는 가장 최근에 포커스된 노드의 서브트리 또는 오토포커스를 요청한 서브트리의 노드 (있는 경우)에 초점을 맞추려고 시도합니다. 
그러한 노드가 없으면, 포커스 자체를 받습니다.

## FocusableActionDetector 위젯 {:#focusableactiondetector-widget}

[`FocusableActionDetector`][]는 [`Actions`][], [`Shortcuts`][], [`MouseRegion`][] 및 `Focus` 위젯의 기능을 결합하여, 액션과 키 바인딩을 정의하고, 포커스 및 호버 하이라이트를 처리하기 위한 콜백을 제공하는 감지기를 만드는 위젯입니다. 
Flutter 컨트롤은 이를 사용하여 컨트롤의 이러한 모든 측면을 구현합니다. 
구성 위젯을 사용하여 구현되므로, 모든 기능이 필요하지 않은 경우 필요한 기능만 사용할 수 있지만, 
이러한 동작을 커스텀 컨트롤에 빌드하는 편리한 방법입니다.

:::note
자세한 내용을 알아보려면, `FocusableActionDetector` 위젯에 대한 이 짧은 주간 위젯 비디오를 시청하세요.

{% ytEmbed 'R84AGg0lKs8', 'FocusableActionDetector - Flutter widget of the week' %}
:::

## 포커스 트래버설 제어 {:#controlling-focus-traversal}

애플리케이션이 포커스 할 수 있는 기능을 갖게 되면, 
많은 애플리케이션이 다음으로 하려는 것은 사용자가 키보드나 다른 입력 장치를 사용하여 포커스를 제어할 수 있도록 하는 것입니다. 
이에 대한 가장 일반적인 예는 사용자가 <kbd>Tab</kbd>을 눌러 "다음" 컨트롤로 이동하는 "탭 트래버설"입니다. 
"다음"이 무엇을 의미하는지 제어하는 ​​것이 이 섹션의 주제입니다. 
이러한 종류의 트래버설은 기본적으로 Flutter에서 제공됩니다.

간단한 그리드 레이아웃에서는, 다음 컨트롤을 결정하기가 매우 쉽습니다. 
행의 끝에 있지 않으면, 오른쪽(또는 right-to-left 로케일의 경우 왼쪽)에 있는 컨트롤입니다. 
행의 끝에 있는 경우, 다음 행의 첫 번째 컨트롤입니다. 
안타깝게도, 애플리케이션은 그리드에 배치되는 경우가 드물기 때문에, 종종 더 많은 지침이 필요합니다.

포커스 트래버설을 위한 Flutter의 기본 알고리즘([`ReadingOrderTraversalPolicy`][])은 꽤 좋습니다. 
대부분의 애플리케이션에 대한 올바른 답을 제공합니다. 
그러나, 항상 병적인 경우(pathological cases)가 있거나, 
컨텍스트나 디자인이 기본 순서 알고리즘이 도달한 순서와 다른 순서를 요구하는 경우가 있습니다. 
그러한 경우에는, 원하는 순서를 달성하기 위한 다른 메커니즘이 있습니다.

### FocusTraversalGroup 위젯 {:#focustraversalgroup-widget}

[`FocusTraversalGroup`][] 위젯은 다른 위젯이나 위젯 그룹으로 이동하기 전에, 
완전히 트래버스(traversed)해야 하는 위젯 하위 트리 주변의 트리에 배치해야 합니다. 
위젯을 관련 그룹으로 그룹화하는 것만으로도 많은 탭 횡단 순서 문제를 해결하기에 충분합니다. 
그렇지 않은 경우, 그룹에 [`FocusTraversalPolicy`][]를 지정하여 그룹 내의 순서를 결정할 수도 있습니다.

기본 [`ReadingOrderTraversalPolicy`][]로도 일반적으로 충분하지만, 
순서를 더 많이 제어해야 하는 경우, [`OrderedTraversalPolicy`][]를 사용할 수 있습니다. 
포커스 가능한 구성 요소를 래핑하는 [`FocusTraversalOrder`][] 위젯의 `order` 인수는 순서를 결정합니다. 
순서는 [`FocusOrder`][]의 어떠한 하위 클래스도 될 수 있지만, 
[`NumericFocusOrder`][]와 [`LexicalFocusOrder`][]가 제공됩니다.

제공된 포커스 트래버설 정책이 애플리케이션에 충분하지 않은 경우, 
직접 정책을 작성하여 원하는 사용자 지정 순서를 결정하는 데 사용할 수도 있습니다.

다음은 `NumericFocusOrder`를 사용하여 TWO, ONE, THREE 순서로 버튼 행을 트래버설하는, 
`FocusTraversalOrder` 위젯을 사용하는 방법의 예입니다.

<?code-excerpt "ui/advanced/focus/lib/samples.dart (ordered-button-row)"?>
```dart
class OrderedButtonRow extends StatelessWidget {
  const OrderedButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Row(
        children: <Widget>[
          const Spacer(),
          FocusTraversalOrder(
            order: const NumericFocusOrder(2),
            child: TextButton(
              child: const Text('ONE'),
              onPressed: () {},
            ),
          ),
          const Spacer(),
          FocusTraversalOrder(
            order: const NumericFocusOrder(1),
            child: TextButton(
              child: const Text('TWO'),
              onPressed: () {},
            ),
          ),
          const Spacer(),
          FocusTraversalOrder(
            order: const NumericFocusOrder(3),
            child: TextButton(
              child: const Text('THREE'),
              onPressed: () {},
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
```

### FocusTraversalPolicy {:#focustraversalpolicy}

`FocusTraversalPolicy`는 요청과 현재 포커스 노드가 주어졌을 때 다음 위젯을 결정하는 객체입니다. 
요청(멤버 함수)은 `findFirstFocus`, `findLastFocus`, `next`, `previous`, `inDirection`과 같은 것입니다.

`FocusTraversalPolicy`는 `ReadingOrderTraversalPolicy`, `OrderedTraversalPolicy`, [`DirectionalFocusTraversalPolicyMixin`][] 클래스와 같은 구체적 정책(concrete policies)의 추상 베이스 클래스(abstract base class)입니다.

`FocusTraversalPolicy`를 사용하려면, 
정책이 적용될 위젯 하위 트리를 결정하는 `FocusTraversalGroup`에 하나를 제공해야 합니다. 
클래스의 멤버 함수는 직접 호출되는 경우가 거의 없습니다. 포커스 시스템에서 사용하도록 의도된 것입니다.

## 포커스 매니저 {:#the-focus-manager}

[`FocusManager`][]는 시스템의 현재 주 포커스를 유지합니다. 
포커스 시스템 사용자에게 유용한 API는 몇 가지뿐입니다. 
하나는 `FocusManager.instance.primaryFocus` 속성으로, 
현재 포커스된 포커스 노드를 포함하고 있으며 글로벌 `primaryFocus` 필드에서도 액세스할 수 있습니다.

다른 유용한 속성은 `FocusManager.instance.highlightMode`와 `FocusManager.instance.highlightStrategy`입니다. 
이러한 속성은 포커스 하이라이트를 위해 "터치" 모드와 "전통적인"(마우스와 키보드) 모드 사이를 전환해야 하는 위젯에서 사용됩니다.
사용자가 터치를 사용하여 탐색하는 경우, 포커스 하이라이트는 일반적으로 숨겨지고, 
마우스나 키보드로 전환하면, 포커스 하이라이트를 다시 표시하여 포커스된 부분을 알 수 있어야 합니다. 
`hightlightStrategy`는 포커스 매니저에게 장치의 사용 모드에서 변경 사항을 해석하는 방법을 알려줍니다. 
가장 최근의 입력 이벤트에 따라 두 모드 사이를 자동으로 전환하거나, 터치 또는 전통적인 모드로 고정할 수 있습니다. 
Flutter에서 제공하는 위젯은 이미 이 정보를 사용하는 방법을 알고 있으므로, 처음부터 자체 컨트롤을 작성하는 경우에만 필요합니다. 
`addHighlightModeListener` 콜백을 사용하여 하이라이트 모드에서 변경 사항을 수신할 수 있습니다.

[`Actions`]: {{site.api}}/flutter/widgets/Actions-class.html
[`Builder`]: {{site.api}}/flutter/widgets/Builder-class.html
[`DirectionalFocusTraversalPolicyMixin`]: {{site.api}}/flutter/widgets/DirectionalFocusTraversalPolicyMixin-mixin.html
[`Focus`]: {{site.api}}/flutter/widgets/Focus-class.html
[`FocusableActionDetector`]: {{site.api}}/flutter/widgets/FocusableActionDetector-class.html
[`FocusManager`]: {{site.api}}/flutter/widgets/FocusManager-class.html
[`FocusNode`]: {{site.api}}/flutter/widgets/FocusNode-class.html
[`FocusOrder`]: {{site.api}}/flutter/widgets/FocusOrder-class.html
[`FocusScope`]: {{site.api}}/flutter/widgets/FocusScope-class.html
[`FocusScopeNode`]: {{site.api}}/flutter/widgets/FocusScopeNode-class.html
[`FocusTraversalGroup`]: {{site.api}}/flutter/widgets/FocusTraversalGroup-class.html
[`FocusTraversalOrder`]: {{site.api}}/flutter/widgets/FocusTraversalOrder-class.html
[`FocusTraversalPolicy`]: {{site.api}}/flutter/widgets/FocusTraversalPolicy-class.html
[`LexicalFocusOrder`]: {{site.api}}/flutter/widgets/LexicalFocusOrder-class.html
[`MouseRegion`]: {{site.api}}/flutter/widgets/MouseRegion-class.html
[`NumericFocusOrder`]: {{site.api}}/flutter/widgets/NumericFocusOrder-class.html
[`OrderedTraversalPolicy`]: {{site.api}}/flutter/widgets/OrderedTraversalPolicy-class.html
[`ReadingOrderTraversalPolicy`]: {{site.api}}/flutter/widgets/ReadingOrderTraversalPolicy-class.html
[`Shortcuts`]: {{site.api}}/flutter/widgets/Shortcuts-class.html
[`UnfocusDisposition.scope`]: {{site.api}}/flutter/widgets/UnfocusDisposition.html
