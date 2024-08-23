---
# title: Debug Flutter apps from code
title: 코드에서 Flutter 앱 디버그
# description: >
#   How to enable various debugging tools from
#   your code and at the command line.
description: >
  코드와 명령줄에서 다양한 디버깅 도구를 활성화하는 방법.
---

<?code-excerpt path-base="testing/code_debugging"?>

이 가이드에서는 코드에서 활성화할 수 있는 디버깅 기능을 설명합니다. 
디버깅 및 프로파일링 도구의 전체 리스트는, [디버깅][Debugging] 페이지를 확인하세요.

:::note
Android 앱 프로세스 내에서 실행되는 Flutter 엔진을 원격으로 디버깅하기 위해 GDB를 사용하는 방법을 찾고 있다면, 
[`flutter_gdb`][]를 확인하세요.
:::

[`flutter_gdb`]: {{site.repo.engine}}/blob/main/sky/tools/flutter_gdb

## 애플리케이션에 로깅 추가 {:#add-logging-to-your-application}

:::note
DevTools의 [Logging view][] 또는 시스템 콘솔에서 로그를 볼 수 있습니다. 
이 섹션에서는 로깅 문을 설정하는 방법을 보여줍니다.
:::

애플리케이션에 로깅하는 데는 두 가지 옵션이 있습니다.

1. `print()` 문을 사용하여 `stdout` 및 `stderr`에 출력합니다.
2. `dart:io`를 import 하고, `stderr` 및 `stdout`에서 메서드를 호출합니다. 예를 들어:

    <?code-excerpt "lib/main.dart (stderr)"?>
    ```dart
    stderr.writeln('print me');
    ```

한 번에 너무 많은 것을 출력하면, Android에서 일부 로그 줄을 삭제할 수 있습니다. 
이러한 결과를 피하려면, Flutter의 `foundation` 라이브러리에서 [`debugPrint()`][]를 사용하세요. 
`print`를 둘러싼 이 래퍼는 Android 커널이 출력을 삭제하는 것을 방지하기 위해 출력을 조절합니다.

`dart:developer` [`log()`][] 함수를 사용하여 앱을 로깅할 수도 있습니다. 
이를 통해 로깅 출력에 더 많은 세부 정보와 정보를 포함할 수 있습니다.

### 예제 1 {:#example-1 .no_toc}

<?code-excerpt "lib/main.dart (log)"?>
```dart
import 'dart:developer' as developer;

void main() {
  developer.log('log me', name: 'my.app.category');

  developer.log('log me 1', name: 'my.other.category');
  developer.log('log me 2', name: 'my.other.category');
}
```

앱 데이터를 로그 호출에 전달할 수도 있습니다. 
이를 위한 규칙은 `log()` 호출에서 `error:`라는 이름의 매개변수를 사용하고, 
보내고자 하는 객체를 JSON으로 인코딩하고, 
인코딩된 문자열을 error 매개변수에 전달하는 것입니다.

### 예제 2 {:#example-2 .no_toc}

<?code-excerpt "lib/app_data.dart (pass-data)"?>
```dart
import 'dart:convert';
import 'dart:developer' as developer;

void main() {
  var myCustomObject = MyCustomObject();

  developer.log(
    'log me',
    name: 'my.app.category',
    error: jsonEncode(myCustomObject),
  );
}
```

DevTool의 로깅 뷰는 JSON 인코딩된 오류 매개변수를 데이터 객체로 해석합니다. 
DevTool은 해당 로그 항목에 대한 세부 정보 뷰를 렌더링합니다.

## 중단점 설정 {:#set-breakpoints}

DevTools의 [Debugger][] 또는 IDE의 빌트인 디버거에서 중단점을 설정할 수 있습니다.

프로그래밍 중단점을 설정하려면:

1. `dart:developer` 패키지를 관련 파일에 import 합니다.
2. `debugger()` 문을 사용하여 프로그래밍 중단점을 삽입합니다. 
   이 문은 선택적 `when` 인수를 사용합니다. 
   이 boolean 인수는 주어진 조건이 true로 해결될 때 중단을 설정합니다.

   **예제 3**은 이를 설명합니다.

### 예제 3 {:#example-3 .no_toc}

<?code-excerpt "lib/debugger.dart"?>
```dart
import 'dart:developer';

void someFunction(double offset) {
  debugger(when: offset > 30);
  // ...
}
```

## 플래그를 사용하여 앱 레이어 디버그 {:#debug-app-layers-using-flags}

Flutter 프레임워크의 각 레이어는 `debugPrint` 속성을 사용하여, 현재 상태나 이벤트를 콘솔에 덤프하는 기능을 제공합니다.

:::note
다음 모든 예는 MacBook Pro M1에서 macOS 네이티브 앱으로 실행되었습니다. 
이는 개발 머신에서 출력하는 모든 덤프와 다릅니다.
:::

{% include docs/admonitions/tip-hashCode-tree.md %}

### 위젯 트리 출력 {:#print-the-widget-tree}

위젯 라이브러리의 상태를 덤프하려면, [`debugDumpApp()`][] 함수를 호출합니다.

1. 소스 파일을 엽니다.
2. `package:flutter/rendering.dart`를 import 합니다.
3. `runApp()` 함수 내에서 [`debugDumpApp()`][] 함수를 호출합니다. 
   앱은 디버그 모드여야 합니다. 
   앱이 빌드 중일 때는 `build()` 메서드 내에서 이 함수를 호출할 수 없습니다.
4. 앱을 시작하지 않았다면, IDE를 사용하여 디버깅합니다.
5. 앱을 시작했다면, 소스 파일을 저장합니다. 핫 리로드는 앱을 다시 렌더링합니다.

#### 예제 4: `debugDumpApp()` 호출 {:#example-4-call-debugdumpapp}

<?code-excerpt "lib/dump_app.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AppHome(),
    ),
  );
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: TextButton(
          onPressed: () {
            debugDumpApp();
          },
          child: const Text('Dump Widget Tree'),
        ),
      ),
    );
  }
}
```

이 함수는 위젯 트리의 루트에서 시작하여, `toStringDeep()` 메서드를 재귀적으로 호출합니다. 
"평평해진(flattened)" 트리를 반환합니다.

**예제 4**는 다음 위젯 트리를 생성합니다. 여기에는 다음이 포함됩니다.

* 다양한 빌드 함수를 통해 프로젝션된 모든 위젯.
* 앱 소스에 나타나지 않는 많은 위젯. 프레임워크의 위젯 빌드 함수는 빌드 중에 이를 삽입합니다.

  예를 들어, 다음 트리는, [`_InkFeatures`][]를 보여줍니다.
  해당 클래스는 [`Material`][] 위젯의 일부를 구현합니다.
  **예제 4**의 코드 어디에도 나타나지 않습니다.

<details>
<summary><strong>예제 4의 위젯 트리를 보려면 확장하세요.</strong></summary>

{% render docs/testing/trees/widget-tree.md -%}

</details>

버튼이 눌림에서 놓임으로 바뀌면, `debugDumpApp()` 함수가 호출됩니다. 
또한, [`TextButton`][] 객체가 [`setState()`][]를 호출하여, 
자체를 더티로 표시하는 것과 일치합니다. 
이는 Flutter가 특정 객체를 "더티"로 표시하는 이유를 설명합니다. 
위젯 트리를 검토할 때, 다음과 유사한 줄을 찾습니다.

```plaintext
└TextButton(dirty, dependencies: [MediaQuery, _InheritedTheme, _LocalizationsScope-[GlobalKey#5880d]], state: _ButtonStyleState#ab76e)
```

위젯을 직접 작성하는 경우, [`debugFillProperties()`][widget-fill] 메서드를 재정의하여 정보를 추가합니다. 
메서드의 인수에 [DiagnosticsProperty][] 객체를 추가하고, 슈퍼클래스 메서드를 호출합니다. 
`toString` 메서드는 이 함수를 사용하여 위젯의 설명을 채웁니다.

### 렌더 트리 출력 {:#print-the-render-tree}

레이아웃 문제를 디버깅할 때, 위젯 레이어의 트리에 세부 정보가 부족할 수 있습니다. 
다음 레벨의 디버깅에는 렌더 트리가 필요할 수 있습니다. 렌더 트리를 덤프하려면:

1. 소스 파일을 엽니다.
1. [`debugDumpRenderTree()`][] 함수를 호출합니다. 
   레이아웃이나 페인트 단계를 제외하고, 언제든지 호출할 수 있습니다. 
   [frame callback][] 또는 이벤트 핸들러에서 호출하는 것을 고려하세요.
2. 앱을 시작하지 않은 경우, IDE를 사용하여 디버깅합니다.
3. 앱을 시작한 경우, 소스 파일을 저장합니다. 핫 리로드는 앱을 다시 렌더링합니다.

#### 예제 5: `debugDumpRenderTree()` 호출 {:#example-5-call-debugdumprendertree}

<?code-excerpt "lib/dump_render_tree.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AppHome(),
    ),
  );
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: TextButton(
          onPressed: () {
            debugDumpRenderTree();
          },
          child: const Text('Dump Render Tree'),
        ),
      ),
    );
  }
}
```

레이아웃 문제를 디버깅할 때, `size` 및 `constraints` 필드를 살펴보세요.
제약 조건은 트리를 따라 아래로 흐르고, 크기는 다시 위로 흐릅니다.

<details>
<summary><strong>예제 5의 렌더 트리를 보려면 확장하세요.</strong></summary>

{% render docs/testing/trees/render-tree.md -%}

</details>

**예제 5**의 렌더 트리에서:

* `RenderView` 또는 창 크기는 [`RenderPositionedBox`][] `#dc1df` 렌더 객체를 포함하여, 모든 렌더 객체를 화면 크기로 제한합니다. 
  이 예에서는 크기를 `Size(800.0, 600.0)`로 설정합니다.

* 각 렌더 객체의 `constraints` 속성은 각 자식의 크기를 제한합니다. 
  이 속성은 [`BoxConstraints`][] 렌더 객체를 값으로 사용합니다. 
  `RenderSemanticsAnnotations#fe6b5`부터 제약 조건은 `BoxConstraints(w=800.0, h=600.0)`와 같습니다.

* [`Center`][] 위젯은 `RenderSemanticsAnnotations#8187b` 하위 트리 아래에, 
  `RenderPositionedBox#dc1df` 렌더 객체를 생성했습니다.

* 이 렌더 객체 아래의 각 자식에는 최소값과 최대값이 모두 있는 `BoxConstraints`가 있습니다. 
  예를 들어, `RenderSemanticsAnnotations#a0a4b`는 `BoxConstraints(0.0<=w<=800.0, 0.0<=h<=600.0)`를 사용합니다.

* `RenderPhysicalShape#8e171` 렌더 객체의 모든 자식은 
  `BoxConstraints(BoxConstraints(56.0<=w<=800.0, 28.0<=h<=600.0))`를 사용합니다.

* 자식 `RenderPadding#8455f`는 `Padding` 값을 `EdgeInsets(8.0, 0.0, 8.0, 0.0)`로 설정합니다. 
  이는 이 렌더 객체의 모든 후속 자식에 왼쪽 및 오른쪽 패딩을 8로 설정합니다. 
  이제 새로운 제약 조건이 추가되었습니다: `BoxConstraints(40.0<=w<=784.0, 28.0<=h<=600.0)`.

`creator` 필드에서 아마도 [`TextButton`][] 정의의 일부일 것이라고 알려주는 이 객체는, 
내용에 최소 너비를 88픽셀로 설정하고 특정 높이를 36.0으로 설정합니다. 
이것은 버튼 크기에 관한 Material Design 가이드라인을 구현하는 `TextButton` 클래스입니다.

`RenderPositionedBox#80b8d` 렌더 객체는 제약 조건을 다시 완화하여 텍스트를 버튼 안에 가운데에 배치합니다. 
[`RenderParagraph`][]#59bc2 렌더 객체는 내용에 따라 크기를 선택합니다. 
크기를 트리 위로 따라가면, 텍스트 크기가 버튼을 형성하는 모든 상자의 너비에 어떻게 영향을 미치는지 알 수 있습니다. 
모든 부모는 자식의 차원을 사용하여 크기를 조정합니다.

이를 알아차리는 또 다른 방법은 각 상자의 설명에서 `relayoutBoundary` 속성을 보는 것입니다. 
이를 통해 이 요소의 크기에 얼마나 많은 조상이 의존하는지 알 수 있습니다.

예를 들어, 가장 안쪽의 `RenderPositionedBox` 줄에는 `relayoutBoundary=up13`이 있습니다. 
즉, Flutter가 `RenderConstrainedBox`를 더티로 표시할 때 상자의 13개 조상도 더티로 표시합니다. 
새로운 차원이 해당 조상에 영향을 미칠 수 있기 때문입니다.

직접 렌더 객체를 작성하는 경우 덤프에 정보를 추가하려면 [`debugFillProperties()`][render-fill]을 재정의합니다. 
[DiagnosticsProperty][] 객체를 메서드의 인수에 추가한 다음 슈퍼클래스 메서드를 호출합니다.

### 레이어 트리 출력 {:#print-the-layer-tree}

구성(compositing) 문제를 디버깅하려면, [`debugDumpLayerTree()`][]를 사용하세요.

#### 예제 6: `debugDumpLayerTree()` 호출 {:#example-6-call-debugdumplayertree}

<?code-excerpt "lib/dump_layer_tree.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AppHome(),
    ),
  );
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: TextButton(
          onPressed: () {
            debugDumpLayerTree();
          },
          child: const Text('Dump Layer Tree'),
        ),
      ),
    );
  }
}
```

<details>
<summary><strong>예제 6의 레이어 트리 출력을 보려면 확장하세요.</strong></summary>

{% render docs/testing/trees/layer-tree.md -%}

</details>

`RepaintBoundary` 위젯은 다음을 생성합니다.

1. **예제 5** 결과에 표시된 대로 렌더 트리의 `RenderRepaintBoundary` RenderObject입니다.

   ```plaintext
   ╎     └─child: RenderRepaintBoundary#f8f28
   ╎       │ needs compositing
   ╎       │ creator: RepaintBoundary ← _FocusInheritedScope ← Semantics ←
   ╎       │   FocusScope ← PrimaryScrollController ← _ActionsScope ← Actions
   ╎       │   ← Builder ← PageStorage ← Offstage ← _ModalScopeStatus ←
   ╎       │   UnmanagedRestorationScope ← ⋯
   ╎       │ parentData: <none> (can use size)
   ╎       │ constraints: BoxConstraints(w=800.0, h=600.0)
   ╎       │ layer: OffsetLayer#e73b7
   ╎       │ size: Size(800.0, 600.0)
   ╎       │ metrics: 66.7% useful (1 bad vs 2 good)
   ╎       │ diagnosis: insufficient data to draw conclusion (less than five
   ╎       │   repaints)
   ```

1. **예시 6** 결과에 표시된 대로 레이어 트리에 새 레이어가 추가되었습니다.

   ```plaintext
   ├─child 1: OffsetLayer#0f766
   │ │ creator: RepaintBoundary ← _FocusInheritedScope ← Semantics ←
   │ │   FocusScope ← PrimaryScrollController ← _ActionsScope ← Actions
   │ │   ← Builder ← PageStorage ← Offstage ← _ModalScopeStatus ←
   │ │   UnmanagedRestorationScope ← ⋯
   │ │ engine layer: OffsetEngineLayer#1768d
   │ │ handles: 2
   │ │ offset: Offset(0.0, 0.0)
   ```

이렇게 하면 다시 칠해야 할 양이 줄어듭니다.

### 포커스 트리 출력 {:#print-the-focus-tree}

포커스 또는 바로가기 문제를 디버깅하려면, [`debugDumpFocusTree()`][] 함수를 사용하여 포커스 트리를 덤프합니다.

`debugDumpFocusTree()` 메서드는 앱의 포커스 트리를 반환합니다.

포커스 트리는 다음과 같은 방식으로 노드에 레이블을 지정합니다.

* 포커스된 노드는 `PRIMARY FOCUS`로 레이블이 지정됩니다.
* 포커스 노드의 조상은 `IN FOCUS PATH`로 레이블이 지정됩니다.

앱에서 [`Focus`][] 위젯을 사용하는 경우, [`debugLabel`][] 속성을 사용하여 트리에서 포커스 노드를 찾는 작업을 간소화합니다.

[`debugFocusChanges`][] boolean 속성을 사용하여, 포커스가 변경될 때 광범위한 로깅을 활성화할 수도 있습니다.

#### 예제 7: `debugDumpFocusTree()` 호출 {:#example-7-call-debugdumpfocustree}

<?code-excerpt "lib/dump_focus_tree.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AppHome(),
    ),
  );
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: TextButton(
          onPressed: () {
            debugDumpFocusTree();
          },
          child: const Text('Dump Focus Tree'),
        ),
      ),
    );
  }
}
```

<details>
<summary><strong>예제 7의 포커스 트리를 보려면 확장하세요.</strong></summary>

{% render docs/testing/trees/focus-tree.md -%}

</details>

### 시맨틱 트리 출력 {:#print-the-semantics-tree}

`debugDumpSemanticsTree()` 함수는 앱의 시맨틱 트리를 출력합니다.

시맨틱 트리는 시스템 접근성 API에 제공됩니다. 시맨틱 트리 덤프를 얻으려면:

1. 시스템 접근성 도구 또는 `SemanticsDebugger`를 사용하여, 접근성을 활성화합니다.
2. [`debugDumpSemanticsTree()`][] 함수를 사용합니다.

#### 예제 8: `debugDumpSemanticsTree()` 호출 {:#example-8-call-debugdumpsemanticstree}

<?code-excerpt "lib/dump_semantic_tree.dart"?>
```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(
    const MaterialApp(
      home: AppHome(),
    ),
  );
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Semantics(
          button: true,
          enabled: true,
          label: 'Clickable text here!',
          child: GestureDetector(
              onTap: () {
                debugDumpSemanticsTree();
                if (kDebugMode) {
                  print('Clicked!');
                }
              },
              child: const Text('Click Me!', style: TextStyle(fontSize: 56))),
        ),
      ),
    );
  }
}
```

<details>
<summary><strong>예제 8의 시맨틱 트리를 보려면 확장하세요.</strong></summary>

{% render docs/testing/trees/semantic-tree.md -%}

</details>

### 이벤트 타이밍 출력 {:#print-event-timings}

프레임의 시작과 끝을 기준으로 이벤트가 발생하는 위치를 찾으려면, 
이러한 이벤트를 기록하도록 출력를 설정할 수 있습니다. 
프레임의 시작과 끝을 콘솔에 출력하려면, 
[`debugPrintBeginFrameBanner`][]와 [`debugPrintEndFrameBanner`][]를 토글합니다.

**예제 1의 프레임 배너 로그 출력**

```plaintext
I/flutter : ▄▄▄▄▄▄▄▄ Frame 12         30s 437.086ms ▄▄▄▄▄▄▄▄
I/flutter : Debug print: Am I performing this work more than once per frame?
I/flutter : Debug print: Am I performing this work more than once per frame?
I/flutter : ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
```

현재 프레임이 예약되도록 호출 스택을 출력하려면, [`debugPrintScheduleFrameStacks`][] 플래그를 사용하세요.

## 레이아웃 문제 디버그 {:#debug-layout-issues}

GUI를 사용하여 레이아웃 문제를 디버깅하려면, [`debugPaintSizeEnabled`][]를 `true`로 설정합니다. 
이 플래그는 `rendering` 라이브러리에서 찾을 수 있습니다. 
언제든지 활성화할 수 있으며, `true` 동안 모든 페인팅에 영향을 미칩니다. 
`void main()` 진입점의 맨 위에 추가하는 것을 고려하세요.

#### 예제 9 {:#example-9}

다음 코드에서 예제를 확인하세요.

<?code-excerpt "lib/debug_flags.dart (debug-paint-size-enabled)"?>
```dart
// Flutter 렌더링 라이브러리에 import를 추가합니다.
import 'package:flutter/rendering.dart';

void main() {
  debugPaintSizeEnabled = true;
  runApp(const MyApp());
}
```

활성화하면, Flutter는 앱에 다음과 같은 변경 사항을 표시합니다.

* 모든 상자를 밝은 청록색 테두리로 표시합니다.
* 모든 패딩을 희미한 파란색 채우기와 자식 위젯 주위에 파란색 테두리가 있는 상자로 표시합니다.
* 모든 정렬 위치를 노란색 화살표로 표시합니다.
* 자식이 없는 경우, 모든 스페이서를 회색으로 표시합니다.

[`debugPaintBaselinesEnabled`][] 플래그는 비슷한 작업을 하지만, 기준선(baselines)이 있는 객체에 대해 수행합니다. 
앱은 알파벳 문자(alphabetic characters)의 기준선을 밝은 녹색으로 표시하고, 표의 문자(ideographic characters)의 기준선을 주황색으로 표시합니다. 
알파벳 문자는 알파벳 기준선에 "앉아(sit)" 있지만, 해당 기준선은 [CJK 문자][cjk]의 하단을 "잘라냅니다(cuts)". 
Flutter는 표의 문자(ideographic) 기준선을 텍스트 줄의 맨 아래에 배치합니다.

[`debugPaintPointersEnabled`][] 플래그는 탭한 모든 객체를 teal 색으로 강조 표시하는 특수 모드를 켭니다. 
이를 통해 객체가 적중 테스트(hit test)에 실패했는지 여부를 확인하는 데 도움이 될 수 있습니다. 
이는 객체가 부모의 경계를 벗어나 처음부터 적중 테스트에 고려되지 않는 경우 발생할 수 있습니다.

컴포지터(compositor) 레이어를 디버깅하려는 경우, 다음 플래그를 사용하는 것이 좋습니다.

* [`debugPaintLayerBordersEnabled`][] 플래그를 사용하여, 각 레이어의 경계를 찾습니다. 
  이 플래그를 사용하면, 각 레이어의 경계가 주황색으로 윤곽이 표시됩니다.

* [`debugRepaintRainbowEnabled`][] 플래그를 사용하여 다시 칠해진 레이어를 표시합니다. 
  레이어가 다시 칠해질 때마다, 회전하는 색상 세트로 오버레이됩니다.

`debug...`로 시작하는 Flutter 프레임워크의 모든 함수나 메서드는 [디버그 모드][debug mode]에서만 작동합니다.

[cjk]: https://en.wikipedia.org/wiki/CJK_characters

## 애니메이션 문제 디버그 {:#debug-animation-issues}

:::note
애니메이션을 최소한의 노력으로 디버깅하려면, 속도를 늦추세요. 
애니메이션 속도를 늦추려면, DevTools의 [Inspector view][]에서 **Slow Animations**를 클릭하세요. 
이렇게 하면, 애니메이션 속도가 20%로 줄어듭니다. 
느림의 양을 더 많이 제어하려면, 다음 지침을 사용하세요.
:::

[`timeDilation`][] 변수(`scheduler` 라이브러리에서)를 1.0보다 큰 숫자로 설정합니다. (예: 50.0)
앱 시작 시 한 번만 설정하는 것이 가장 좋습니다. 
즉석에서 변경하는 경우, 특히 애니메이션이 실행되는 동안 값을 줄이는 경우, 프레임워크가 시간이 뒤로 가는 것을 관찰할 수 있으며, 
이는 어설션을 발생시키고 일반적으로 작업을 방해할 수 있습니다.

## 성능 문제 디버그 {:#debug-performance-issues}

:::note
[DevTools][]를 사용하여 이러한 디버그 플래그 중 일부와 유사한 결과를 얻을 수 있습니다. 
일부 디버그 플래그는 거의 이점이 없습니다. 
[DevTools][]에 추가하고 싶은 기능이 있는 플래그를 찾으면, [문제를 제출하세요][file an issue].
:::

[`debugDumpRenderTree()`][]
: To dump the rendering tree to the console, call this function when not in a layout or repaint phase.

Flutter는 개발 주기의 다양한 지점에서 앱을 디버깅하는 데 도움이 되는 다양한 최상위 속성과 함수를 제공합니다. 
이러한 기능을 사용하려면, 디버그 모드에서 앱을 컴파일하세요.

다음 리스트는 성능 문제를 디버깅하기 위한 [렌더링 라이브러리][rendering library]의 일부 플래그와 한 가지 함수를 강조합니다.

[`debugDumpRenderTree()`][]
: 렌더링 트리를 콘솔에 덤프하려면, 레이아웃 또는 다시 그리기 단계가 아닐 때, 이 함수를 호출합니다.

  {% comment %}
    Feature is not yet added to DevTools:
    Rather than using this flag to dump the render tree
    to a file, view the render tree in the Flutter inspector.
    To do so, bring up the Flutter inspector and select the
    **Render Tree** tab.
  {% endcomment %}

  이러한 플래그를 설정하려면:

  * 프레임워크 코드 편집
  * 모듈을 import 한 후, `main()` 함수에 값을 설정한 후 핫 리스타트합니다.

[`debugPaintLayerBordersEnabled`][]
: 각 레이어의 경계를 표시하려면 이 속성을 `true`로 설정합니다. 
  설정하면 각 레이어가 경계 주위에 상자를 그립니다.

[`debugRepaintRainbowEnabled`][]
: 각 위젯 주위에 색상 테두리를 표시하려면, 이 속성을 `true`로 설정합니다. 
  이러한 테두리는 앱 사용자가 앱에서 스크롤할 때 색상이 변경됩니다. 
  이 플래그를 설정하려면, 앱의 최상위 속성으로 `debugRepaintRainbowEnabled = true;`를 추가합니다. 
  이 플래그를 설정한 후 static 위젯이 색상을 따라 회전하는 경우, 해당 영역에 다시 칠하기 경계를 추가하는 것을 고려하세요.

[`debugPrintMarkNeedsLayoutStacks`][]
: 앱에서 예상보다 많은 레이아웃을 생성하는지 확인하려면, 이 속성을 `true`로 설정합니다. 
  이 레이아웃 문제는 타임라인, 프로필 또는 레이아웃 메서드 내의 `print` 문에서 발생할 수 있습니다. 
  설정하면, 프레임워크는 앱이 각 렌더 객체를 레이아웃되도록 표시하는 이유를 설명하는 스택 추적을 콘솔에 출력합니다.

[`debugPrintMarkNeedsPaintStacks`][]
: 앱이 예상보다 많은 레이아웃을 그리는지 확인하려면, 이 속성을 `true`로 설정합니다.

필요에 따라 스택 추적을 생성할 수도 있습니다. 
자신의 스택 추적을 출력하려면 앱에 `debugPrintStack()` 함수를 추가합니다.

### Dart 코드 성능 추적 {:#trace-dart-code-performance}

:::note
DevTools [타임라인 이벤트 탭][Timeline events tab]을 사용하여 추적을 수행할 수 있습니다. 
또한 추적 파일을 타임라인 뷰로 가져오고 내보낼 수 있지만, DevTools에서 생성된 파일만 가능합니다.
:::

Android가 [systrace][]를 사용하여 하는 것처럼, Dart 코드의 임의의 세그먼트에 대한 커스텀 성능 추적을 수행하고, 
벽 또는 CPU 시간(wall or CPU time)을 측정하려면, `dart:developer` [Timeline][] 유틸리티를 사용합니다.

1. 소스 코드를 엽니다.
2. `Timeline` 메서드에서 측정하려는 코드를 래핑합니다.

    <?code-excerpt "lib/perf_trace.dart"?>
    ```dart
    import 'dart:developer';
    
    void main() {
      Timeline.startSync('interesting function');
      // iWonderHowLongThisTakes();
      Timeline.finishSync();
    }
    ```

3. 앱에 연결된 상태에서, DevTools의 [타임라인 이벤트 탭][Timeline events tab]을 엽니다.
4. **Performance settings**에서 **Dart** 기록 옵션을 선택합니다.
5. 측정하려는 기능을 수행합니다.

런타임 성능 특성이 최종 제품과 거의 일치하는지 확인하려면 앱을, [프로필 모드][profile mode]에서 실행하세요.

### 성능 오버레이 추가 {:#add-performance-overlay}

:::note
[Flutter inspector][]의 **Performance Overlay** 버튼을 사용하여, 앱에서 성능 오버레이 표시를 전환할 수 있습니다. 
코드에서 이를 수행하는 것을 선호하는 경우, 다음 지침을 따르세요.
:::

코드에서 `PerformanceOverlay` 위젯을 활성화하려면, 
[`MaterialApp`][], [`CupertinoApp`][] 또는 [`WidgetsApp`][] 생성자에서, 
`showPerformanceOverlay` 속성을 `true`로 설정합니다.

#### Example 10 {:#example-10}

<?code-excerpt "lib/performance_overlay.dart (show-overlay)"?>
```dart
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      title: 'My Awesome App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'My Awesome App'),
    );
  }
}
```

(`MaterialApp`, `CupertinoApp` 또는 `WidgetsApp`를 사용하지 않는 경우, 
애플리케이션을 스택에 래핑하고 [`PerformanceOverlay.allEnabled()`][]를 호출하여, 
생성된 위젯을 스택에 넣으면 동일한 효과를 얻을 수 있습니다.)

오버레이의 그래프를 해석하는 방법을 알아보려면 [Flutter 성능 프로파일링][Profiling Flutter performance]의 [성능 오버레이][The performance overlay]를 확인하세요.

## 위젯 정렬 그리드 추가 {:#add-widget-alignment-grid}

앱의 [Material Design 기준선 그리드][Material Design baseline grid]에 오버레이를 추가하여 정렬을 확인하려면, 
[`MaterialApp` 생성자][`MaterialApp` constructor]에 `debugShowMaterialGrid` 인수를 추가합니다.

비Material 애플리케이션에 오버레이를 추가하려면 [`GridPaper`][] 위젯을 추가합니다.

[Debugger]: /tools/devtools/debugger
[Debugging]: /testing/debugging
[DevTools]: /tools/devtools
[DiagnosticsProperty]: {{site.api}}/flutter/foundation/DiagnosticsProperty-class.html
[Flutter inspector]: /tools/devtools/inspector
[Inspector view]: /tools/devtools/inspector
[Logging view]: /tools/devtools/logging
[Material Design baseline grid]: {{site.material}}/foundations/layout/understanding-layout/spacing
[Profiling Flutter performance]: /perf/ui-performance
[The performance overlay]: /perf/ui-performance#the-performance-overlay
[Timeline events tab]: /tools/devtools/performance#timeline-events-tab
[Timeline]: {{site.dart.api}}/stable/dart-developer/Timeline-class.html
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`Focus`]: {{site.api}}/flutter/widgets/Focus-class.html
[`GridPaper`]: {{site.api}}/flutter/widgets/GridPaper-class.html
[`MaterialApp` constructor]: {{site.api}}/flutter/material/MaterialApp/MaterialApp.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp/MaterialApp.html
[`Material`]: {{site.api}}/flutter/material/Material-class.html
[`PerformanceOverlay.allEnabled()`]: {{site.api}}/flutter/widgets/PerformanceOverlay/PerformanceOverlay.allEnabled.html
[`RenderParagraph`]: {{site.api}}/flutter/rendering/RenderParagraph-class.html
[`RenderPositionedBox`]: {{site.api}}/flutter/rendering/RenderPositionedBox-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`WidgetsApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html
[`_InkFeatures`]: {{site.api}}/flutter/material/InkFeature-class.html
[`debugDumpApp()`]: {{site.api}}/flutter/widgets/debugDumpApp.html
[`debugDumpFocusTree()`]: {{site.api}}/flutter/widgets/debugDumpFocusTree.html
[`debugDumpLayerTree()`]: {{site.api}}/flutter/rendering/debugDumpLayerTree.html
[`debugDumpRenderTree()`]: {{site.api}}/flutter/rendering/debugDumpRenderTree.html
[`debugDumpSemanticsTree()`]: {{site.api}}/flutter/rendering/debugDumpSemanticsTree.html
[`debugFocusChanges`]: {{site.api}}/flutter/widgets/debugFocusChanges.html
[`debugLabel`]: {{site.api}}/flutter/widgets/Focus/debugLabel.html
[`debugPaintBaselinesEnabled`]: {{site.api}}/flutter/rendering/debugPaintBaselinesEnabled.html
[`debugPaintLayerBordersEnabled`]: {{site.api}}/flutter/rendering/debugPaintLayerBordersEnabled.html
[`debugPaintPointersEnabled`]: {{site.api}}/flutter/rendering/debugPaintPointersEnabled.html
[`debugPaintSizeEnabled`]: {{site.api}}/flutter/rendering/debugPaintSizeEnabled.html
[`debugPrint()`]: {{site.api}}/flutter/foundation/debugPrint.html
[`debugPrintBeginFrameBanner`]: {{site.api}}/flutter/scheduler/debugPrintBeginFrameBanner.html
[`debugPrintEndFrameBanner`]: {{site.api}}/flutter/scheduler/debugPrintEndFrameBanner.html
[`debugPrintMarkNeedsLayoutStacks`]: {{site.api}}/flutter/rendering/debugPrintMarkNeedsLayoutStacks.html
[`debugPrintMarkNeedsPaintStacks`]: {{site.api}}/flutter/rendering/debugPrintMarkNeedsPaintStacks.html
[`debugPrintScheduleFrameStacks`]: {{site.api}}/flutter/scheduler/debugPrintScheduleFrameStacks.html
[`debugRepaintRainbowEnabled`]: {{site.api}}/flutter/rendering/debugRepaintRainbowEnabled.html
[`log()`]: {{site.api}}/flutter/dart-developer/log.html
[`setState()`]: {{site.api}}/flutter/widgets/State/setState.html
[`timeDilation`]: {{site.api}}/flutter/scheduler/timeDilation.html
[debug mode]: /testing/build-modes#debug
[file an issue]: {{site.github}}/flutter/devtools/issues
[frame callback]: {{site.api}}/flutter/scheduler/SchedulerBinding/addPersistentFrameCallback.html
[profile mode]: /testing/build-modes#profile
[render-fill]: {{site.api}}/flutter/rendering/Layer/debugFillProperties.html
[rendering library]: {{site.api}}/flutter/rendering/rendering-library.html
[systrace]: {{site.android-dev}}/studio/profile/systrace
[widget-fill]: {{site.api}}/flutter/widgets/Widget/debugFillProperties.html
[`BoxConstraints`]: {{site.api}}/flutter/rendering/BoxConstraints-class.html
