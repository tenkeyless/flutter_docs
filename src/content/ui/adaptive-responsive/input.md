---
# title: User input & accessibility
title: 사용자 입력 & 접근성
# description: >-
#   A truly adaptive app also handles differences
#   in how user input works and also programs
#   to help folks with accessibility issues.
description: >-
  진정한 적응형 앱은 사용자 입력 방식의 차이를 처리하고, 접근성 이슈가 있는 사람들을 돕기 위한 프로그램도 제공합니다.
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

앱의 보이는 모양을 조정하는 것만으로는 충분하지 않습니다. 다양한 사용자 입력도 지원해야 합니다. 
마우스와 키보드는 (스크롤 휠, 오른쪽 클릭, 호버 상호작용, 탭 이동 및 키보드 단축키와 같이) 
터치 기기에서 찾을 수 있는 것 이상의 입력 타입을 도입합니다.

이러한 기능 중 일부는 기본적으로 Material 위젯에서 작동합니다. 
그러나, 커스텀 위젯을 만든 경우, 직접 구현해야 할 수도 있습니다.

잘 디자인된 앱을 포함하는 일부 기능은, 보조 기술(assistive technologies)을 사용하는 사용자에게도 도움이 됩니다. 
예를 들어, **좋은 앱 디자인**이라는 점 외에도, (탭 이동 및 키보드 단축키와 같은) 일부 기능은, 
_보조 기기를 사용하는 사용자에게 필수적_ 입니다. 
[접근성 있는 앱 만들기][creating accessible apps]에 대한 표준 조언 외에도, 
이 페이지에서는 적응형 _및_ 접근성 있는 앱을 만드는 방법에 대한 정보를 다룹니다.

[creating accessible apps]: /ui/accessibility-and-internationalization/accessibility

## 커스텀 위젯을 위한 스크롤 휠 {:#scroll-wheel-for-custom-widgets}

`ScrollView` 또는 `ListView`와 같은 스크롤 위젯은 기본적으로 스크롤 휠을 지원하며, 
거의 모든 스크롤 가능한 커스텀 위젯이 이 중 하나를 사용하여 빌드되므로, 이 위젯과도 작동합니다.

커스텀 스크롤 동작을 구현해야 하는 경우, 
UI가 스크롤 휠에 반응하는 방식을 커스터마이즈 할 수 있는, 
[`Listener`][] 위젯을 사용할 수 있습니다.

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (pointer-scroll)"?>
```dart
return Listener(
  onPointerSignal: (event) {
    if (event is PointerScrollEvent) print(event.scrollDelta.dy);
  },
  child: ListView(),
);
```

[`Listener`]: {{site.api}}/flutter/widgets/Listener-class.html

## 탭 트래버설 및 포커스 상호 작용 {:#tab-traversal-and-focus-interactions}

실제 키보드를 사용하는 사용자는 탭 키를 사용하여 애플리케이션을 빠르게 탐색할 수 있을 것으로 기대하고, 
운동 또는 시력에 차이가 있는 사용자는 종종 키보드 탐색에 전적으로 의존합니다.

탭 상호 작용에는 두 가지 고려 사항이 있습니다. 
(1) 포커스가 위젯에서 위젯으로 이동하는 방식(트래버설(traversal)이라고 함)과 
(2) 위젯에 포커스가 맞춰졌을 때 표시되는 시각적 하이라이트(highlights)입니다.

(버튼 및 텍스트 필드와 같은) 대부분의 빌트인 컴포넌트는 기본적으로 트래버설과 하이라이트를 지원합니다. 
트래버설에 포함하려는 자체 위젯이 있는 경우, 
[`FocusableActionDetector`][] 위젯을 사용하여 자체 컨트롤을 만들 수 있습니다. 
[`FocusableActionDetector`][] 위젯은 포커스, 마우스 입력 및 단축키를 하나의 위젯에 결합하는 데 유용합니다.
동작 및 키 바인딩을 정의하고, 포커스 및 호버 하이라이트를 처리하기 위한 콜백을 제공하는 감지기를 만들 수 있습니다.

<?code-excerpt "lib/pages/focus_examples_page.dart (focusable-action-detector)"?>
```dart
class _BasicActionDetectorState extends State<BasicActionDetector> {
  bool _hasFocus = false;
  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onFocusChange: (value) => setState(() => _hasFocus = value),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<Intent>(onInvoke: (intent) {
          print('Enter or Space was pressed!');
          return null;
        }),
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const FlutterLogo(size: 100),
          // 멋진 효과를 위해 음수 여백에 포커스 위치 지정
          if (_hasFocus)
            Positioned(
              left: -4,
              top: -4,
              bottom: -4,
              right: -4,
              child: _roundedBorder(),
            )
        ],
      ),
    );
  }
}
```

[`Actions`]: {{site.api}}/flutter/widgets/Actions-class.html
[`Focus`]: {{site.api}}/flutter/widgets/Focus-class.html
[`FocusableActionDetector`]: {{site.api}}/flutter/widgets/FocusableActionDetector-class.html
[`MouseRegion`]: {{site.api}}/flutter/widgets/MouseRegion-class.html
[`Shortcuts`]: {{site.api}}/flutter/widgets/Shortcuts-class.html

### 트래버설 순서 제어 {:#controlling-traversal-order}

사용자가 탭할 때 위젯이 초점을 맞추는 순서를 더 잘 제어하려면, 
[`FocusTraversalGroup`][]을 사용하여 탭할 때 그룹으로 처리해야 하는 트리 섹션을 정의할 수 있습니다.

예를 들어, submit 버튼으로 탭하기 전에 양식의 모든 필드를 탭할 수 있습니다.

<?code-excerpt "lib/pages/focus_examples_page.dart (focus-traversal-group)"?>
```dart
return Column(children: [
  FocusTraversalGroup(
    child: MyFormWithMultipleColumnsAndRows(),
  ),
  SubmitButton(),
]);
```

Flutter에는 위젯과 그룹을 탐색(traverse)하는 여러 가지 빌트인 방법이 있으며, 
기본적으로 `ReadingOrderTraversalPolicy` 클래스를 사용합니다. 
이 클래스는 일반적으로 잘 작동하지만, 
다른 사전 정의된 `TraversalPolicy` 클래스를 사용하거나 커스텀 정책을 만들어서 이를 수정할 수 있습니다.

[`FocusTraversalGroup`]: {{site.api}}/flutter/widgets/FocusTraversalGroup-class.html

## 키보드 가속기 {:#keyboard-accelerators}

탭 트래버설 외에도, 데스크톱 및 웹 사용자는 특정 작업에 다양한 키보드 단축키를 바인딩하는 데 익숙합니다. 
빠른 삭제를 위한 `Delete` 키이든, 새 문서를 위한 `Control+N`이든, 
사용자가 기대하는 다양한 가속기를 고려해야 합니다. 
키보드는 강력한 입력 도구이므로, 최대한 효율성을 끌어내세요. 사용자가 좋아할 것입니다!

키보드 가속기는 목표에 따라 Flutter에서 여러 가지 방법으로 구현할 수 있습니다.

이미 포커스 노드가 있는 `TextField` 또는 `Button`과 같은 단일 위젯이 있는 경우, 
[`KeyboardListener`][] 또는 [`Focus`][] 위젯으로 래핑하고 키보드 이벤트를 수신할 수 있습니다.

<?code-excerpt "lib/pages/focus_examples_page.dart (focus-keyboard-listener)"?>
```dart
  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          print(event.logicalKey);
        }
        return KeyEventResult.ignored;
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
```

트리의 큰 섹션에 키보드 단축키 세트를 적용하려면, [`Shortcuts`][] 위젯을 사용하세요.

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (shortcuts)"?>
```dart
// 원하는 각 타입의 shortcut 액션에 대해 클래스를 정의합니다.
class CreateNewItemIntent extends Intent {
  const CreateNewItemIntent();
}

Widget build(BuildContext context) {
  return Shortcuts(
    // 키 조합에 인텐트(intents) 바인딩
    shortcuts: const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.keyN, control: true):
          CreateNewItemIntent(),
    },
    child: Actions(
      // 코드에서 실제 메서드에 인텐트(intents)를 바인딩
      actions: <Type, Action<Intent>>{
        CreateNewItemIntent: CallbackAction<CreateNewItemIntent>(
          onInvoke: (intent) => _createNewItem(),
        ),
      },
      // 하위 트리는 focusNode에 래핑되어, 포커스를 받을 수 있어야 합니다.
      child: Focus(
        autofocus: true,
        child: Container(),
      ),
    ),
  );
}
```

[`Shortcuts`][] 위젯은 이 위젯 트리나 그 자식 중 하나에 포커스가 있고 표시될 때만 단축키를 실행할 수 있기 때문에 유용합니다.

마지막 옵션은 글로벌 리스너입니다. 
이 리스너는 항상 켜진 앱 전체 단축키나 (포커스 상태에 관계없이) 표시될 때마다 단축키를 허용할 수 있는 패널에 사용할 수 있습니다. 
[`HardwareKeyboard`][]를 사용하면 글로벌 리스너를 쉽게 추가할 수 있습니다.

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (hardware-keyboard)"?>
```dart
@override
void initState() {
  super.initState();
  HardwareKeyboard.instance.addHandler(_handleKey);
}

@override
void dispose() {
  HardwareKeyboard.instance.removeHandler(_handleKey);
  super.dispose();
}
```

글로벌 리스너로 키 조합을 확인하려면, 
`HardwareKeyboard.instance.logicalKeysPressed` 세트를 사용할 수 있습니다. 
예를 들어, 다음과 같은 메서드는 제공된 키 중 하나가 눌려 있는지 확인할 수 있습니다.

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (keys-pressed)"?>
```dart
static bool isKeyDown(Set<LogicalKeyboardKey> keys) {
  return keys
      .intersection(HardwareKeyboard.instance.logicalKeysPressed)
      .isNotEmpty;
}
```

이 두 가지를 함께 사용하면, `Shift+N`을 눌렀을 때 동작을 실행할 수 있습니다.

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (handle-key)"?>
```dart
bool _handleKey(KeyEvent event) {
  bool isShiftDown = isKeyDown({
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
  });

  if (isShiftDown && event.logicalKey == LogicalKeyboardKey.keyN) {
    _createNewItem();
    return true;
  }

  return false;
}
```

static 리스너를 사용할 때 주의해야 할 점 하나는, 
사용자가 필드에 타이핑하거나 연관된 위젯이 보기에서 숨겨져 있을 때 종종 비활성화해야 한다는 것입니다. 
`Shortcuts` 또는 `KeyboardListener`와 달리, 이는 사용자가 관리해야 할 책임입니다. 
`Delete`에 대한 Delete/Backspace 가속기를 바인딩할 때 특히 중요할 수 있지만, 
사용자가 타이핑으로 입력할 수 있는 자식 `TextFields`가 있습니다.

[`HardwareKeyboard`]: {{site.api}}/flutter/services/HardwareKeyboard-class.html
[`KeyboardListener`]: {{site.api}}/flutter/widgets/KeyboardListener-class.html

## 커스텀 위젯에 대한 마우스 enter, exit 및 hover {:#custom-widgets}

데스크톱에서는, 마우스 커서를 변경하여 마우스가 올려져 있는(hover) 콘텐츠에 대한 기능을 나타내는 것이 일반적입니다. 
예를 들어, 일반적으로 버튼 위에 마우스를 올려놓으면 손 모양 커서가 표시되고, 텍스트 위에 마우스를 올려놓으면 `I` 커서가 표시됩니다.

Flutter의 Material 버튼은 표준 버튼 및 텍스트 커서에 대한 기본 포커스 상태를 처리합니다. 
(주목할 만한 예외는 Material 버튼의 기본 스타일을 변경하여 `overlayColor`를 투명하게 설정하는 경우입니다.)

앱에서 커스텀 버튼이나 제스처 감지기에 대한 포커스 상태를 구현합니다. 
기본 Material 버튼 스타일을 변경하는 경우, 키보드 포커스 상태를 테스트하고, 필요한 경우 커스텀 포커스 상태를 구현합니다.

커스텀 위젯 내에서 커서를 변경하려면, [`MouseRegion`][]을 사용합니다.

<?code-excerpt "lib/pages/focus_examples_page.dart (mouse-region)"?>
```dart
// 손 모양 커서 표시
return MouseRegion(
  cursor: SystemMouseCursors.click,
  // 클릭 시 포커스 요청
  child: GestureDetector(
    onTap: () {
      Focus.of(context).requestFocus();
      _submit();
    },
    child: Logo(showBorder: hasFocus),
  ),
);
```

`MouseRegion`은 사용자 정의 롤오버 및 호버 효과를 만드는 데에도 유용합니다.

<?code-excerpt "lib/pages/focus_examples_page.dart (mouse-over)"?>
```dart
return MouseRegion(
  onEnter: (_) => setState(() => _isMouseOver = true),
  onExit: (_) => setState(() => _isMouseOver = false),
  onHover: (e) => print(e.localPosition),
  child: Container(
    height: 500,
    color: _isMouseOver ? Colors.blue : Colors.black,
  ),
);
```

버튼에 포커스가 있을 때 버튼의 윤곽을 표시하기 위해 버튼 스타일을 변경하는 예를 보려면, 
[Wonderous 앱의 버튼 코드][button code for the Wonderous app]를 확인하세요. 
앱은 [`FocusNode.hasFocus`][] 속성을 수정하여, 버튼에 포커스가 있는지 확인하고, 포커스가 있으면 윤곽을 추가합니다.

[button code for the Wonderous app]: {{site.github}}/gskinnerTeam/flutter-wonderous-app/blob/8a29d6709668980340b1b59c3d3588f123edd4d8/lib/ui/common/controls/buttons.dart#L143
[`FocusNode.hasFocus`]: {{site.api}}/flutter/widgets/FocusNode/hasFocus.html

## 시각적 밀도 {:#visual-density}

예를 들어, 터치 스크린을 수용하기 위해 위젯의 "히트 영역"을 확대하는 것을 고려할 수 있습니다.

다양한 입력 장치는 다양한 수준의 정밀도를 제공하므로, 서로 다른 크기의 히트 영역이 필요합니다. 
Flutter의 `VisualDensity` 클래스를 사용하면 전체 애플리케이션에서 뷰의 밀도를 쉽게 조정할 수 있습니다. 
예를 들어, 터치 장치에서 버튼을 더 크게 만들어(따라서 탭하기 쉽게) 할 수 있습니다.

`MaterialApp`의 `VisualDensity`를 변경하면, 
이를 지원하는 `MaterialComponents`가 밀도를 일치하도록 애니메이션화합니다. 
기본적으로, 수평 및 수직 밀도는 모두 0.0으로 설정되지만, 원하는 음수 또는 양수 값으로 밀도를 설정할 수 있습니다. 
다른 밀도 간에 전환하면, UI를 쉽게 조정할 수 있습니다.

![Adaptive scaffold](/assets/images/docs/ui/adaptive-responsive/adaptive_scaffold.gif){:width="100%"}

커스텀 시각적 밀도를 설정하려면, `MaterialApp` 테마에 밀도를 삽입하세요.

<?code-excerpt "lib/main.dart (visual-density)"?>
```dart
double densityAmt = touchMode ? 0.0 : -1.0;
VisualDensity density =
    VisualDensity(horizontal: densityAmt, vertical: densityAmt);
return MaterialApp(
  theme: ThemeData(visualDensity: density),
  home: MainAppScaffold(),
  debugShowCheckedModeBanner: false,
);
```

자신의 뷰 내에서 `VisualDensity`를 사용하려면, 다음을 찾아보세요.

<?code-excerpt "lib/pages/adaptive_reflow_page.dart (visual-density-own-view)"?>
```dart
VisualDensity density = Theme.of(context).visualDensity;
```

컨테이너는 밀도의 변화에 ​​자동으로 반응할 뿐만 아니라, 밀도가 변경될 때 애니메이션도 적용합니다. 
이를 통해 커스텀 컴포넌트와 빌트인 컴포넌트를 결합하여, 앱 전체에서 매끄러운 전환 효과를 얻을 수 있습니다.

표시된 대로, `VisualDensity`는 단위가 없으므로, 다른 뷰에 대해 다른 의미를 가질 수 있습니다. 
다음 예에서, 1개의 밀도 단위는 6픽셀과 같지만, 이는 전적으로 사용자가 결정해야 합니다. 
단위가 없다는 사실 때문에 매우 다재다능하며, 대부분의 컨텍스트에서 작동해야 합니다.

Material은 일반적으로 각 시각적 밀도 단위에 대해 약 4개의 논리적 픽셀 값을 사용한다는 점에 유의해야 합니다. 
지원되는 컴포넌트에 대한 자세한 내용은 [`VisualDensity`][] API를 참조하세요. 
일반적인 밀도 원칙에 대한 자세한 내용은 [Material Design 가이드][Material Design guide]를 참조하세요.

[Material Design guide]: {{site.material2}}/design/layout/applying-density.html#usage
[`VisualDensity`]: {{site.api}}/flutter/material/VisualDensity-class.html

