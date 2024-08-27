---
# title: Hot reload
title: 핫 리로드
# description: Speed up development using Flutter's hot reload feature.
description: Flutter의 핫 리로드 기능을 사용하여 개발 속도를 높이세요.
---

<?code-excerpt path-base="tools"?>

Flutter의 핫 리로드 기능은 빠르고 쉽게 실험하고, UI를 빌드하고, 기능을 추가하고, 버그를 수정하는 데 도움이 됩니다. 
핫 리로드는 업데이트된 소스 코드 파일을 실행 중인 [Dart Virtual Machine(VM)][]에 주입하여 작동합니다. 
VM이 새 버전의 필드와 함수로 클래스를 업데이트한 후, Flutter 프레임워크는 자동으로 위젯 트리를 다시 빌드하여, 
변경 사항의 효과를 빠르게 볼 수 있도록 합니다.

## 핫 리로드를 수행하는 방법 {:#how-to-perform-a-hot-reload}

Flutter 앱을 핫 리로드하려면:

1. 지원되는 [Flutter 에디터][Flutter editor] 또는 터미널 창에서 앱을 실행합니다. 
   실제 또는 가상 장치가 대상이 될 수 있습니다. 
   **디버그 모드의 Flutter 앱만 핫 리로드 또는 핫 재시작이 가능합니다.**
2. 프로젝트에서 Dart 파일 중 하나를 수정합니다. 
   대부분의 코드 변경 사항은 핫 리로드할 수 있습니다. 
   핫 재시작이 필요한 변경 사항 리스트는, [특수 사례](#special-cases)를 참조하세요.
3. Flutter의 IDE 도구를 지원하는 IDE/편집기에서 작업하는 경우, 
   **Save All**(`cmd-s`/`ctrl-s`)을 선택하거나, 도구 모음에서 핫 리로드 버튼을 클릭합니다.

  `flutter run`을 사용하여 명령줄에서 앱을 실행하는 경우, 터미널 창에 `r`을 입력합니다.

핫 리로드 작업이 성공적으로 완료되면, 콘솔에 다음과 유사한 메시지가 표시됩니다.

```console
Performing hot reload...
Reloaded 1 of 448 libraries in 978ms.
```

앱은 변경 사항을 반영하도록 업데이트되고, 앱의 현재 상태는 보존됩니다. 
앱은 핫 리로드 명령을 실행하기 전 위치에서 계속 실행됩니다. 코드가 업데이트되고 실행이 계속됩니다.

:::secondary
**핫 리로드, 핫 리스타트, 풀 리스타트의 차이점은 무엇인가요?**

* **핫 리로드**는 
  * 코드 변경 사항을 VM에 로드하고 위젯 트리를 다시 빌드하고, 앱 상태를 유지합니다. 
    * `main()` 또는 `initState()`를 다시 실행하지 않습니다. 
  * (Intellij 및 Android Studio에서는 `⌘\`, VSCode에서는 `⌃F5`)
* **핫 리스타트**는 
  * 코드 변경 사항을 VM에 로드하고, Flutter 앱을 다시 시작하며, 앱 상태를 잃습니다. 
  * (IntelliJ 및 Android Studio에서는 `⇧⌘\`, VSCode에서는 `⇧⌘F5`)
* **전체 리스타트**는 
  * iOS, Android 또는 웹 앱을 다시 시작합니다. 
  * Java/Kotlin/Objective-C/Swift 코드도 다시 컴파일하기 때문에 시간이 더 오래 걸립니다. 
  * 웹에서는, Dart 개발 컴파일러도 다시 시작합니다. 
  * 이에 대한 특정 키보드 단축키는 없습니다. 
    * 실행 구성을 중지했다가 다시 시작해야 합니다.

Flutter 웹은 현재 핫 리스타트를 지원하지만, 핫 리로드는 지원하지 않습니다.
:::

![Android Studio UI](/assets/images/docs/development/tools/android-studio-run-controls.png){:width="100%"}<br>
Android Studio에서 실행, 실행 디버그, 핫 리로드 및 핫 재시작을 위한 컨트롤

코드 변경은 변경 후 수정된 Dart 코드를 다시 실행하는 경우에만 눈에 띄는 효과가 있습니다. 
구체적으로, 핫 리로드는 모든 기존 위젯을 다시 빌드합니다. 
위젯을 다시 빌드하는 데 관련된 코드만 자동으로 다시 실행됩니다. 
예를 들어 `main()` 및 `initState()` 함수는 다시 실행되지 않습니다.

## 특수한 경우 {:#special-cases}

다음 섹션에서는 핫 리로드와 관련된 구체적인 시나리오를 설명합니다. 
어떤 경우에는, Dart 코드를 약간 변경하면 앱에 핫 리로드를 계속 사용할 수 있습니다. 
다른 경우에는, 핫 재시작 또는 전체 재시작이 필요합니다.

### 앱이 종료됨 {:#an-app-is-killed}

앱이 종료되면, 핫 리로드가 중단될 수 있습니다.
예를 들어, 앱이 너무 오랫동안 백그라운드에 있는 경우.

### 컴파일 오류 {:#compilation-errors}

코드 변경으로 인해 컴파일 오류가 발생하면, 핫 리로드는 다음과 유사한 오류 메시지를 생성합니다.

```plaintext
Hot reload was rejected:
'/path/to/project/lib/main.dart': warning: line 16 pos 38: unbalanced '{' opens here
  Widget build(BuildContext context) {
                                     ^
'/path/to/project/lib/main.dart': error: line 33 pos 5: unbalanced ')'
    );
    ^
```

In this situation, simply correct the errors on the
specified lines of Dart code to keep using hot reload.

### CupertinoTabView의 빌더 {:#cupertinotabviews-builder}

핫 리로드는 `CupertinoTabView`의 `builder`에 대한 변경 사항을 적용하지 않습니다. 
자세한 내용은 [이슈 43574][Issue 43574]를 참조하세요.

### 열거형 타입 {:#enumerated-types}

열거형이 일반 클래스로 변경되거나, 일반 클래스가 열거형으로 변경되면, 핫 리로드가 작동하지 않습니다.

예를 들어:

변경 전:
<?code-excerpt "lib/hot-reload/before.dart (enum)"?>
```dart
enum Color {
  red,
  green,
  blue,
}
```

변경 후:
<?code-excerpt "lib/hot-reload/after.dart (enum)"?>
```dart
class Color {
  Color(this.i, this.j);
  final int i;
  final int j;
}
```

### 제네릭 타입 {:#generic-types}

제네릭 타입 선언이 수정되면, 핫 리로드가 작동하지 않습니다. 
예를 들어, 다음은 작동하지 않습니다.

변경 전:
<?code-excerpt "lib/hot-reload/before.dart (class)"?>
```dart
class A<T> {
  T? i;
}
```

변경 후:
<?code-excerpt "lib/hot-reload/after.dart (class)"?>
```dart
class A<T, V> {
  T? i;
  V? v;
}
```

### 네이티브 코드 {:#native-code}

네이티브 코드(예: Kotlin, Java, Swift, Objective-C)를 변경한 경우, 
변경 사항이 적용되는지 확인하려면 전체 재시작(앱을 중지했다가 다시 시작)을 수행해야 합니다.

### 이전 상태는 새 코드와 결합되는 경우 {:#previous-state-is-combined-with-new-code}

Flutter의 stateful 핫 리로드는 앱의 상태를 보존합니다. 
이 접근 방식을 사용하면 현재 상태를 버리지 않고, 가장 최근의 변경 사항의 효과만 볼 수 있습니다. 
예를 들어, 앱에서 사용자가 로그인해야 하는 경우, 로그인 자격 증명을 다시 입력하지 않고도, 
네비게이션 계층 구조에서 몇 레벨 아래에 있는 페이지를 수정하고, 핫 리로드할 수 있습니다. 
상태는 유지되며, 이는 일반적으로 원하는 동작입니다.

코드 변경 사항이 앱(또는 종속성)의 상태에 영향을 미치는 경우, 
앱이 작업해야 하는 데이터는 처음부터 실행했을 때의 데이터와 완전히 일치하지 않을 수 있습니다. 
핫 리로드와 핫 재시작 후의 결과는 다를 수 있습니다.

### 최근 코드 변경 사항은 포함되지만 앱 상태는 제외되는 경우 {:#recent-code-change-is-included-but-app-state-is-excluded}

Dart에서, [static 필드는 lazily 초기화][static-variables]됩니다. 
즉, Flutter 앱을 처음 실행하고 static 필드를 읽을 때, 이니셜라이저가 평가된 값으로 설정됩니다. 
전역 변수와 정적 필드는 상태로 처리되므로, 핫 리로드 중에 다시 초기화되지 않습니다.

전역 변수와 정적 필드의 이니셜라이저를 변경하는 경우, 
핫 재시작 또는 이니셜라이저가 유지되는 상태를 다시 시작해야 변경 사항을 확인할 수 있습니다. 
예를 들어, 다음 코드를 고려해 보세요.

<?code-excerpt "lib/hot-reload/before.dart (sample-table)"?>
```dart
final sampleTable = [
  Table(
    children: const [
      TableRow(
        children: [Text('T1')],
      )
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T2')],
      )
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T3')],
      )
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T4')],
      )
    ],
  ),
];
```

앱을 실행한 후, 다음과 같이 변경합니다.

<?code-excerpt "lib/hot-reload/after.dart (sample-table)"?>
```dart
final sampleTable = [
  Table(
    children: const [
      TableRow(
        children: [Text('T1')],
      )
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T2')],
      )
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T3')],
      )
    ],
  ),
  Table(
    children: const [
      TableRow(
        children: [Text('T10')], // 수정됨
      )
    ],
  ),
];
```

핫 리로드를 했지만, 변경 사항이 반영되지 않았습니다.

반대로, 다음 예에서는:

<?code-excerpt "lib/hot-reload/before.dart (const)"?>
```dart
const foo = 1;
final bar = foo;
void onClick() {
  print(foo);
  print(bar);
}
```

앱을 처음 실행하면 `1`과 `1`이 출력됩니다. 
그런 다음, 다음과 같이 변경합니다.

<?code-excerpt "lib/hot-reload/after.dart (const)"?>
```dart
const foo = 2; // 수정됨
final bar = foo;
void onClick() {
  print(foo);
  print(bar);
}
```

`const` 필드 값에 대한 변경 사항은 항상 핫 리로드되지만, 
정적 필드 이니셜라이저는 다시 실행되지 않습니다. 
개념적으로, `const` 필드는 상태가 아닌 별칭으로 처리됩니다.

Dart VM은 이니셜라이저 변경 사항을 감지하고, 
변경 사항 집합이 적용되려면 핫 재시작이 필요한 경우 플래그를 지정합니다. 
플래깅 메커니즘은 위의 예에서 대부분의 초기화 작업에 대해 트리거되지만, 다음과 같은 경우에는 트리거되지 않습니다.

<?code-excerpt "lib/hot-reload/after.dart (final-foo)"?>
```dart
final bar = foo;
```

`foo`를 업데이트하고 핫 리로드 후 변경 사항을 보려면, 
`final`을 사용하는 대신 필드를 `const`로 다시 정의하거나, 
getter를 사용하여 값을 반환하는 것을 고려하세요. 
예를 들어, 다음 솔루션 중 하나가 작동합니다.

<?code-excerpt "lib/hot-reload/foo_const.dart (const)"?>
```dart
const foo = 1;
const bar = foo; // foo를 const로 변환합니다...
void onClick() {
  print(foo);
  print(bar);
}
```

<?code-excerpt "lib/hot-reload/getter.dart (const)"?>
```dart
const foo = 1;
int get bar => foo; // ...또는 getter를 제공합니다.
void onClick() {
  print(foo);
  print(bar);
}
```

자세한 내용은, Dart의 [`const`와 `final` 키워드의 차이점][const-new]를 읽어보세요.

### 최근 UI 변경 사항은 제외 {:#recent-ui-change-is-excluded}

핫 리로드 작업이 성공적으로 보이고 예외가 발생하지 않더라도, 
일부 코드 변경 사항은 새로 고침된 UI에서 표시되지 않을 수 있습니다. 
이 동작은 앱의 `main()` 또는 `initState()` 메서드가 변경된 후에 일반적입니다.

일반적으로, 수정된 코드가 루트 위젯의 `build()` 메서드의 다운스트림인 경우, 핫 리로드는 예상대로 동작합니다.
그러나, 위젯 트리를 다시 빌드한 결과로 수정된 코드가 다시 실행되지 않으면, 핫 리로드 후에 그 효과를 볼 수 없습니다.

예를 들어 다음 코드를 고려해 보겠습니다.

<?code-excerpt "lib/hot-reload/before.dart (build)"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => print('tapped'));
  }
}
```

이 앱을 실행한 후, 코드를 다음과 같이 변경하세요.

<?code-excerpt "lib/hot-reload/after.dart (main)"?>
```dart
import 'package:flutter/widgets.dart';

void main() {
  runApp(const Center(child: Text('Hello', textDirection: TextDirection.ltr)));
}
```

핫 리스타트를 사용하면, 프로그램이 처음부터 시작하여 `main()`의 새 버전을 실행하고, 
`Hello`라는 텍스트를 표시하는 위젯 트리를 빌드합니다.

그러나, 이 변경 후에 앱을 핫 리로드하면, `main()`과 `initState()`가 다시 실행되지 않고, 
위젯 트리가 루트 위젯으로 변경되지 않은 `MyApp` 인스턴스로 다시 빌드됩니다. 
이로 인해 핫 리로드 후에 눈에 띄는 변경 사항이 없습니다.

## 작동 원리 {:#how-it-works}

핫 리로드가 호출되면, 호스트 머신은 마지막 컴파일 이후 편집된 코드를 살펴봅니다. 다음 라이브러리가 다시 컴파일됩니다.

* 코드가 변경된 모든 라이브러리
* 애플리케이션의 메인 라이브러리
* 영향을 받는 라이브러리로 이어지는 메인 라이브러리의 라이브러리

해당 라이브러리의 소스 코드는 [커널 파일][kernel files]로 컴파일되어, 모바일 기기의 Dart VM으로 전송됩니다.

Dart VM은 새 커널 파일에서 모든 라이브러리를 다시 로드합니다. 지금까지 코드는 다시 실행되지 않았습니다.

그런 다음, 핫 리로드 메커니즘은 Flutter 프레임워크가,
모든 기존 위젯과 렌더 객체의 재구축/재레이아웃/재페인트를 트리거하도록 합니다.

[static-variables]: {{site.dart-site}}/language/classes#static-variables
[const-new]: {{site.dart-site}}/language/variables#final-and-const
[Dart Virtual Machine (VM)]: {{site.dart-site}}/overview#platform
[Flutter editor]: /get-started/editor
[Issue 43574]: {{site.repo.flutter}}/issues/43574
[kernel files]: {{site.github}}/dart-lang/sdk/tree/main/pkg/kernel
