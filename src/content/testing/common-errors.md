---
# title: Common Flutter errors
title: 일반적인 Flutter 오류
# description: How to recognize and resolve common Flutter framework errors.
description: 일반적인 Flutter 프레임워크 오류를 인식하고 해결하는 방법.
---

<?code-excerpt path-base="testing/common_errors"?>

## 소개 {:#introduction}

이 페이지에서는 자주 발생하는 여러 Flutter 프레임워크 오류(레이아웃 오류 포함)를 설명하고, 
이를 해결하는 방법에 대한 제안을 제공합니다. 
이는 향후 개정판에 추가될 오류가 더 많은 라이브 문서이며, 여러분의 기여를 환영합니다. 
이 페이지를 여러분과 Flutter 커뮤니티에 더 유용하게 만들기 위해, 
[문제 열기][open an issue] 또는 [풀 리퀘스트 제출][submit a pull request]을 자유롭게 하세요.

[open an issue]: {{site.repo.this}}/issues/new/choose
[submit a pull request]: {{site.repo.this}}/pulls

## 앱을 실행할 때 빨간색 또는 회색 화면이 나타납니다. {:#a-solid-red-or-grey-screen-when-running-your-app}

일반적으로 "빨간색(또는 회색) 죽음의 화면"이라고 불리는 이것은, 
때때로 Flutter가 오류가 있음을 알려주는 방식입니다.

앱이 디버그 또는 프로필 모드에서 실행될 때 빨간색 화면이 나타날 수 있습니다. 
앱이 릴리스 모드에서 실행될 때 회색 화면이 나타날 수 있습니다.

일반적으로, 이러한 오류는 포착되지 않은 예외가 있을 때(그리고 다른 try-catch 블록이 필요할 수 있음) 
또는 오버플로 오류와 같은 렌더링 오류가 있을 때 발생합니다.

다음 문서에서는 이러한 종류의 오류를 디버깅하는 데 유용한 통찰력을 제공합니다.

* [Flutter 오류의 비밀 해제][Flutter errors demystified] by Abishek
* [Flutter에서 회색 화면 이해 및 해결][Understanding and addressing the grey screen in Flutter] by Christopher Nwosu-Madueke
* [Flutter가 흰색 화면에 갇힘][Flutter stuck on white screen] by Kesar Bhimani

[Flutter errors demystified]: {{site.medium}}/@hpatilabhi10/flutter-errors-demystified-red-screen-errors-vs-debug-console-errors-acb3b8ed2625
[Flutter stuck on white screen]: https://www.dhiwise.com/post/flutter-stuck-on-white-screen-understanding-and-fixing
[Understanding and addressing the grey screen in Flutter]: {{site.medium}}/@LordChris/understanding-and-addressing-the-grey-screen-in-flutter-5e72c31f408f

## 'A RenderFlex overflowed…' {:#a-renderflex-overflowed}

RenderFlex 오버플로는 가장 자주 발생하는 Flutter 프레임워크 오류 중 하나이며, 
아마 여러분은 이미 이 오류를 겪었을 것입니다.

**오류는 어떻게 생겼나요?**

오류가 발생하면 노란색과 검은색 줄무늬가 나타나 앱 UI에서 오버플로 영역을 나타냅니다. 
또한 디버그 콘솔에 오류 메시지가 표시됩니다.

```plaintext
The following assertion was thrown during layout:
A RenderFlex overflowed by 1146 pixels on the right.

The relevant error-causing widget was

    Row      lib/errors/renderflex_overflow_column.dart:23

The overflowing RenderFlex has an orientation of Axis.horizontal.
The edge of the RenderFlex that is overflowing has been marked in the rendering 
with a yellow and black striped pattern. This is usually caused by the contents 
being too big for the RenderFlex.
(Additional lines of this message omitted)
```

**어떻게 이 오류가 발생할 수 있나요?**

이 오류는 `Column` 또는 `Row`에 크기에 제한이 없는 자식 위젯이 있을 때 종종 발생합니다. 
예를 들어, 아래 코드 조각은 일반적인 시나리오를 보여줍니다.

<?code-excerpt "lib/renderflex_overflow.dart (problem)"?>
```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      const Icon(Icons.message),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Title', style: Theme.of(context).textTheme.headlineMedium),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed '
            'do eiusmod tempor incididunt ut labore et dolore magna '
            'aliqua. Ut enim ad minim veniam, quis nostrud '
            'exercitation ullamco laboris nisi ut aliquip ex ea '
            'commodo consequat.',
          ),
        ],
      ),
    ],
  );
}
```

위의 예에서, `Column`은 `Row`(부모)가 할당할 수 있는 공간보다 더 넓게 만들려고 시도하여, 오버플로 오류가 발생합니다. `Column`은 왜 그렇게 하려고 할까요? 
이 레이아웃 동작을 이해하려면, Flutter 프레임워크가 레이아웃을 수행하는 방식을 알아야 합니다.

"_레이아웃을 수행하기 위해, Flutter는 깊이 우선 순회(depth-first traversal)에서 렌더 트리를 탐색하고, 부모에서 자식으로 **크기 제약 조건을 아래로(passes down size constraints)** 전달합니다... 자식은 부모가 설정한 제약 조건 내에서 부모 객체로 **크기를 위로 전달(passing up a size)** 하여 응답합니다._" – [Flutter 아키텍처 개요][Flutter architectural overview]

이 경우, `Row` 위젯은 자식의 크기를 제한하지 않으며, `Column` 위젯도 마찬가지입니다. 
부모 위젯의 제약 조건이 없는, 두 번째 `Text` 위젯은 표시하는 데 필요한 모든 문자만큼 넓게 만들려고 합니다. 
그러면 `Text` 위젯의 자체 결정 너비가 `Column` 위젯에 의해 채택되는데, 
이는 부모 위젯인 `Row` 위젯이 제공할 수 있는 최대 수평 공간과 충돌합니다.

[Flutter architectural overview]: /resources/architectural-overview#layout-and-rendering

**어떻게 고치나요?**

글쎄요, `Column`이 가능한 것보다 더 넓어지려고 하지 않도록 해야 합니다. 
이를 달성하려면, 너비를 제한해야 합니다. 
이를 위한 한 가지 방법은 `Column`을 `Expanded` 위젯으로 래핑하는 것입니다.

<?code-excerpt "lib/renderflex_overflow.dart (solution)"?>
```dart
return const Row(
  children: [
    Icon(Icons.message),
    Expanded(
      child: Column(
          // 코드 생략
          ),
    ),
  ],
);
```

다른 방법은 `Column`을 `Flexible` 위젯으로 래핑하고, `flex` 인수를 지정하는 것입니다. 
사실 `Expanded` 위젯은 `flex` 인수가 1.0인 `Flexible` 위젯과 동일합니다. 
[소스 코드][its source code]에서 볼 수 있습니다. 
Flutter 레이아웃에서 `Flex` 위젯을 사용하는 방법을 자세히 알아보려면, 
`Flexible` 위젯에 대한 [이 90초짜리 주간 위젯 비디오][flexible-video]를 확인하세요.

**추가 정보:**

아래 링크된 리소스는 이 오류에 대한 추가 정보를 제공합니다.

* [Flutter Widget of the Week(주간 위젯)][flexible-video]
* [Flutter Inspector로 레이아웃 문제를 디버깅하는 방법][medium-article]
* [제약 조건 이해][Understanding constraints]

[its source code]: {{site.repo.flutter}}/blob/c8e42b47f5ea8b5ff7bf2f2b0a2a8e765f1aa51d/packages/flutter/lib/src/widgets/basic.dart#L5166-L5174
[flexible-video]: {{site.yt.watch}}?v=CI7x0mAZiY0
[medium-article]: {{site.flutter-medium}}/how-to-debug-layout-issues-with-the-flutter-inspector-87460a7b9db#738b
[Understanding constraints]: /ui/layout/constraints

## 'RenderBox was not laid out' {:#renderbox-was-not-laid-out}

이 오류는 꽤 흔하지만, 종종 렌더링 파이프라인에서 일찍 발생한 기본 오류의 부작용입니다.

**오류는 어떻게 생겼나요?**

오류에서 표시되는 메시지는 다음과 같습니다.

```plaintext
RenderBox was not laid out: 
RenderViewport#5a477 NEEDS-LAYOUT NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
```

**어떻게 이 오류가 발생할 수 있나요?**

일반적으로, 이 문제는 상자 제약 조건 위반과 관련이 있으며, 
해당 위젯을 제약하는 방법에 대한 자세한 정보를 Flutter에 제공하여 해결해야 합니다. 
Flutter에서 제약 조건이 작동하는 방식에 대한 자세한 내용은 [제약 조건 이해][Understanding constraints] 페이지에서 확인할 수 있습니다.

`RenderBox was not laid out` 오류는 종종 두 가지 다른 오류 중 하나로 인해 발생합니다.

* '수직 뷰포트에 무제한 높이가 지정되었습니다' ('Vertical viewport was given unbounded height')
* 'InputDecorator...에는 무제한 너비가 있을 수 없습니다' ('An InputDecorator...cannot have an unbounded width')

<a id="unbounded"></a>

## 'Vertical viewport was given unbounded height' {:#vertical-viewport-was-given-unbounded-height}

이것은 Flutter 앱에서 UI를 만드는 동안 발생할 수 있는 또 다른 일반적인 레이아웃 오류입니다.

**오류는 어떻게 생겼나요?**

오류에 표시된 메시지는 다음과 같습니다.

```plaintext
The following assertion was thrown during performResize():
Vertical viewport was given unbounded height.

Viewports expand in the scrolling direction to fill their container. 
In this case, a vertical viewport was given an unlimited amount of 
vertical space in which to expand. This situation typically happens when a 
scrollable widget is nested inside another scrollable widget.
(Additional lines of this message omitted)
```

**어떻게 이 오류가 발생할 수 있나요?**

이 오류는 `ListView`(또는 `GridView`와 같은 다른 종류의 scrollable 위젯)가 `Column` 내부에 배치될 때 종종 발생합니다. 
`ListView`는 부모 위젯에 의해 제한되지 않는 한, 사용 가능한 모든 수직 공간을 차지합니다. 
그러나, `Column`은 기본적으로 자식의 높이에 어떠한 제약도 가하지 않습니다. 
두 가지 동작이 결합되면, `ListView`의 크기를 결정하지 못하게 됩니다.

<?code-excerpt "lib/unbounded_height.dart (problem)"?>
```dart
Widget build(BuildContext context) {
  return Center(
    child: Column(
      children: <Widget>[
        const Text('Header'),
        ListView(
          children: const <Widget>[
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Map'),
            ),
            ListTile(
              leading: Icon(Icons.subway),
              title: Text('Subway'),
            ),
          ],
        ),
      ],
    ),
  );
}
```

**어떻게 고치나요?**

이 오류를 수정하려면 `ListView`의 높이를 지정합니다. 
`Column`의 나머지 공간과 같은 높이로 만들려면, `Expanded` 위젯을 사용하여 래핑합니다. (다음 예에서 표시)
그렇지 않으면, `SizedBox` 위젯을 사용하여 절대 높이를 지정하거나, `Flexible` 위젯을 사용하여 상대 높이를 지정합니다.

<?code-excerpt "lib/unbounded_height.dart (solution)"?>
```dart
Widget build(BuildContext context) {
  return Center(
    child: Column(
      children: <Widget>[
        const Text('Header'),
        Expanded(
          child: ListView(
            children: const <Widget>[
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
              ),
              ListTile(
                leading: Icon(Icons.subway),
                title: Text('Subway'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
```

**추가 정보:**

아래 링크된 리소스는 이 오류에 대한 추가 정보를 제공합니다.

* [Flutter Inspector로 레이아웃 문제를 디버깅하는 방법][medium-article]
* [제약 조건 이해][Understanding constraints]

## 'An InputDecorator...cannot have an unbounded width' {:#an-inputdecorator-cannot-have-an-unbounded-width}

오류 메시지는 상자 제약 조건과도 관련이 있음을 시사하는데, 
이는 가장 흔한 Flutter 프레임워크 오류 중 많은 부분을 피하기 위해 이해하는 것이 중요합니다.

**오류는 어떻게 생겼나요?**

오류에 표시된 메시지는 다음과 같습니다.

```plaintext
The following assertion was thrown during performLayout():
An InputDecorator, which is typically created by a TextField, cannot have an 
unbounded width.
This happens when the parent widget does not provide a finite width constraint. 
For example, if the InputDecorator is contained by a `Row`, then its width must 
be constrained. An `Expanded` widget or a SizedBox can be used to constrain the 
width of the InputDecorator or the TextField that contains it.
(Additional lines of this message omitted)
```

**어떻게 오류가 발생할 수 있나요?**

이 오류는 예를 들어 `Row`에 `TextFormField` 또는 `TextField`가 포함되어 있지만, 
후자에 너비 제약 조건이 없는 경우 발생합니다.

<?code-excerpt "lib/unbounded_width.dart (problem)"?>
```dart
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Unbounded Width of the TextField'),
      ),
      body: const Row(
        children: [
          TextField(),
        ],
      ),
    ),
  );
}
```

**어떻게 고치나요?**

오류 메시지에서 제안한 대로, `Expanded` 또는 `SizedBox` 위젯을 사용하여 텍스트 필드를 제한하여 이 오류를 수정합니다. 
다음 예는 `Expanded` 위젯을 사용하는 방법을 보여줍니다.

<?code-excerpt "lib/unbounded_width.dart (solution)"?>
```dart
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Unbounded Width of the TextField'),
      ),
      body: Row(
        children: [
          Expanded(child: TextFormField()),
        ],
      ),
    ),
  );
}
```

## 'Incorrect use of ParentData widget' {:#incorrect-use-of-parentdata-widget}

이 오류는 예상된 부모 위젯이 누락된 것과 관련이 있습니다.

**오류는 어떻게 생겼나요?**

오류에서 표시되는 메시지는 다음과 같습니다.

```plaintext
The following assertion was thrown while looking for parent data:
Incorrect use of ParentDataWidget.
(Some lines of this message omitted)
Usually, this indicates that at least one of the offending ParentDataWidgets 
listed above is not placed directly inside a compatible ancestor widget.
```

**어떻게 오류가 발생할 수 있나요?**

Flutter의 위젯은 일반적으로 UI에서 함께 구성할 수 있는 방식이 유연하지만, 
이러한 위젯 중 일부는 특정 부모 위젯을 기대합니다. 
위젯 트리에서 이러한 기대를 충족할 수 없는 경우, 이 오류가 발생할 가능성이 높습니다.

Flutter 프레임워크 내에서 특정 부모 위젯을 기대하는 위젯의 _불완전한_ 리스트는 다음과 같습니다. 
이 리스트를 확장하려면 PR을 제출하세요. (페이지 오른쪽 상단 모서리에 있는 문서 아이콘 사용)

| 위젯                                |  예상 부모 위젯 |
|:--------------------------------------|---------------------------:|
| `Flexible`                            | `Row`, `Column` 또는 `Flex` |
| `Expanded` (특수한 형태의 `Flexible`) | `Row`, `Column` 또는 `Flex` |
| `Positioned`                          |                    `Stack` |
| `TableCell`                           |                    `Table` |

{:.table .table-striped}

**어떻게 고치나요?**

어느 부모 위젯이 누락되었는지 알게 되면, 수정 방법이 명확해질 것입니다.

## 'setState called during build' {:#setstate-called-during-build}

Flutter 코드의 `build` 메서드는, 직접적이든 간접적이든, `setState`를 호출하기에 좋은 곳이 아닙니다.

**오류는 어떻게 생겼나요?**

오류가 발생하면, 콘솔에 다음 메시지가 표시됩니다.

```plaintext
The following assertion was thrown building DialogPage(dirty, dependencies: 
[_InheritedTheme, _LocalizationsScope-[GlobalKey#59a8e]], 
state: _DialogPageState#f121e):
setState() or markNeedsBuild() called during build.

This Overlay widget cannot be marked as needing to build because the framework 
is already in the process of building widgets.
(Additional lines of this message omitted)
```

**어떻게 오류가 발생할 수 있나요?**

일반적으로, 이 오류는 `build` 메서드 내에서 `setState` 메서드가 호출될 때 발생합니다.

이 오류가 발생하는 일반적인 시나리오는, `build` 메서드 내에서 `Dialog`를 트리거하려고 할 때입니다. 
이는 종종 사용자에게 정보를 즉시 표시해야 할 필요성에서 비롯되지만, `setState`는 `build` 메서드에서 호출해서는 안 됩니다.

다음 스니펫은 이 오류의 일반적인 원인인 듯합니다.

<?code-excerpt "lib/set_state_build.dart (problem)"?>
```dart
Widget build(BuildContext context) {
  // 이렇게 하지 마세요.
  showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Alert Dialog'),
        );
      });

  return const Center(
    child: Column(
      children: <Widget>[
        Text('Show Material Dialog'),
      ],
    ),
  );
}
```

이 코드는 `setState`를 명시적으로 호출하지 않지만, `showDialog`에서 호출합니다. 
`build` 메서드는 `showDialog`를 호출하기에 적합한 곳이 아닙니다. 
`build`는, 예를 들어, 애니메이션 중에 프레임워크에서 모든 프레임에 대해 호출될 수 있기 때문입니다.

**어떻게 고치나요?**

이 오류를 피하는 한 가지 방법은 `Navigator` API를 사용하여 대화 상자를 경로로 트리거하는 것입니다. 
다음 예에서는 두 페이지가 있습니다. 두 번째 페이지에는 진입 시 표시되는 대화 상자가 있습니다. 
사용자가 첫 번째 페이지의 버튼을 클릭하여 두 번째 페이지를 요청하면, `Navigator`는 두 개의 경로를 푸시합니다. 
하나는 두 번째 페이지용이고, 다른 하나는 대화 상자용입니다.

<?code-excerpt "lib/set_state_build.dart (solution)"?>
```dart
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Launch screen'),
          onPressed: () {
            // Navigate to the second screen using a named route.
            Navigator.pushNamed(context, '/second');
            // Immediately show a dialog upon loading the second screen.
            Navigator.push(
              context,
              PageRouteBuilder(
                barrierDismissible: true,
                opaque: false,
                pageBuilder: (_, anim1, anim2) => const MyDialog(),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

## `The ScrollController is attached to multiple scroll views` {:#the-scrollcontroller-is-attached-to-multiple-scroll-views}

이 오류는 여러 스크롤 위젯(예: `ListView`)이 동시에 화면에 나타날 때 발생할 수 있습니다. 
모바일 앱에서는 이 시나리오가 드물기 때문에, 모바일 앱보다 웹 또는 데스크톱 앱에서 이 오류가 발생할 가능성이 더 큽니다.

자세한 내용과 수정 방법을 알아보려면, [`PrimaryScrollController`][controller-video]에서 다음 비디오를 확인하세요.

{% ytEmbed '33_0ABjFJUU', 'PrimaryScrollController | Decoding Flutter', true %}

[controller-video]: {{site.api}}/flutter/widgets/PrimaryScrollController-class.html

## 참고자료 {:#references}

Flutter에서 특히 레이아웃 오류를 디버깅하는 방법에 대해 자세히 알아보려면, 다음 리소스를 확인하세요.

* [Flutter Inspector로 레이아웃 문제를 디버깅하는 방법][medium-article]
* [제약 조건 이해][Understanding constraints]
* [Flutter 아키텍처 개요][Flutter architectural overview]

[Flutter architectural overview]: /resources/architectural-overview#layout-and-rendering
