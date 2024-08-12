---
title: "암묵적 애니메이션 (Implicit animations)"
description: >
  대화형 예제와 연습을 통해 Flutter의 암묵적 애니메이션 위젯을 사용하는 방법을 알아보세요.
toc: true
diff2html: true
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="animation/implicit"?>

암묵적 애니메이션 코드랩에 오신 것을 환영합니다. 
여기서는 특정 속성 세트에 대한 애니메이션을 쉽게 만들 수 있는 
Flutter 위젯을 사용하는 방법을 알아봅니다.

{% include docs/dartpad-troubleshooting.md %}

이 코드랩을 최대한 활용하려면, 다음에 대한 기본 지식이 있어야 합니다.

- [Flutter 앱 만들기][make a Flutter app] 방법.
- [Stateful 위젯][stateful widgets] 사용 방법.

이 코드랩은 다음 내용을 다룹니다.

- `AnimatedOpacity`를 사용하여 페이드인 효과 만들기.
- `AnimatedContainer`를 사용하여 크기, 색상 및 여백에서 전환 애니메이션 만들기.
- 암묵적 애니메이션 개요 및 사용 기술.

**이 코드랩 완료 예상 시간: 15-30분**

## 암묵적 애니메이션이란? {:#what-are-implicit-animations}

Flutter의 [애니메이션 라이브러리][animation library]를 사용하면, UI의 위젯에 모션을 추가하고 시각적 효과를 만들 수 있습니다. 
라이브러리에 있는 하나의 위젯 세트가 애니메이션을 관리합니다. 
이러한 위젯은 총칭하여 _암묵적 애니메이션(implicit animations)_ 또는 
_암묵적으로 애니메이션이 적용된 위젯(implicitly animated widgets)_ 이라고 하며, 
그들을 구현하는 [ImplicitlyAnimatedWidget][] 클래스에서 이름을 따왔습니다. 
암묵적 애니메이션을 사용하면, 대상 값을 설정하여 위젯 속성을 애니메이션화할 수 있습니다. 
대상 값이 변경될 때마다, 위젯은 속성을 이전 값에서 새 값으로 애니메이션화합니다. 
이런 방식으로, 암묵적 애니메이션은 편의성을 위해 제어권(control)을 교환합니다. 
&mdash; 즉, 사용자가 직접 애니메이션 효과를 관리할 필요가 없습니다.

## 예제: 페이드인 텍스트 효과 {:#example-fade-in-text-effect}

다음 예제는 [AnimatedOpacity][]라는 암묵적으로 애니메이션이 적용된 위젯을 사용하여, 
기존 UI에 페이드인 효과를 추가하는 방법을 보여줍니다. 
**예제는 애니메이션 코드 없이 시작합니다.**
&mdash;다음을 포함하는 [Material App][] 홈 화면으로 구성됩니다.

- 올빼미 사진.
- 클릭해도 아무 작업도 수행되지 않는 **Show details** 버튼 하나.
- 사진 속 올빼미의 설명 텍스트.

### 페이드인 (시작 코드) {:#fade-in-starter-code}

예제를 보려면, **Run**을 클릭하세요.

{% render docs/implicit-animations/fade-in-starter-code.md %}

### AnimatedOpacity 위젯으로 불투명도 애니메이션 적용 {:#animate-opacity-with-animatedopacity-widget}

이 섹션에는 [페이드인 시작 코드][fade-in starter code]에 암묵적 애니메이션을 추가하는 데 
사용할 수 있는 단계 리스트가 포함되어 있습니다. 
단계가 끝나면, 이미 변경한 내용으로 [페이드인 완료][fade-in complete] 코드를 실행할 수도 있습니다. 
이 단계에서는 `AnimatedOpacity` 위젯을 사용하여 다음 애니메이션 기능을 추가하는 방법을 설명합니다.

- 올빼미의 설명 텍스트는 사용자가 **Show details**를 클릭할 때까지 숨겨진 상태로 유지됩니다.
- 사용자가 **Show details**를 클릭하면, 올빼미의 설명 텍스트가 페이드인됩니다.

#### 1. 애니메이션을 적용할 위젯 속성 선택 {:#1-pick-a-widget-property-to-animate}

페이드인 효과를 만들려면, `AnimatedOpacity` 위젯을 사용하여 `opacity` 속성을 애니메이션으로 적용할 수 있습니다. 
`Column` 위젯을 `AnimatedOpacity` 위젯으로 래핑합니다.

```diff2html
--- opacity1/lib/main.dart
+++ opacity2/lib/main.dart
@@ -26,12 +26,14 @@
         ),
         onPressed: () => {},
       ),
-      const Column(
-        children: [
-          Text('Type: Owl'),
-          Text('Age: 39'),
-          Text('Employment: None'),
-        ],
+      AnimatedOpacity(
+        child: const Column(
+          children: [
+            Text('Type: Owl'),
+            Text('Age: 39'),
+            Text('Employment: None'),
+          ],
+        ),
       )
     ]);
   }
```

:::note
[페이드인 시작 코드][fade-in starter code]에서 변경 사항을 어디에 적용해야 하는지
추적하는 데 도움이 되도록 예제 코드의 줄 번호를 참조할 수 있습니다.
:::

#### 2. 애니메이션 속성에 대한 상태 변수 초기화 {:#2-initialize-a-state-variable-for-the-animated-property}

사용자가 **Show details**를 클릭하기 전에 텍스트를 숨기려면, 
`opacity`의 시작 값을 0으로 설정합니다.

```diff2html
--- opacity2/lib/main.dart
+++ opacity3/lib/main.dart
@@ -15,6 +15,8 @@
 }

 class _FadeInDemoState extends State<FadeInDemo> {
+  double opacity = 0;
+
   @override
   Widget build(BuildContext context) {
     return ListView(children: <Widget>[
@@ -27,6 +29,7 @@
         onPressed: () => {},
       ),
       AnimatedOpacity(
+        opacity: opacity,
         child: const Column(
           children: [
             Text('Type: Owl'),
```

#### 3. 애니메이션 지속시간 설정 {:#3-set-the-duration-of-the-animation}

`opacity` 매개변수 외에도, `AnimatedOpacity`는 애니메이션에 사용할 [duration][]이 필요합니다. 
이 예제에서는, 2초로 시작할 수 있습니다.

```diff2html
--- opacity3/lib/main.dart
+++ opacity4/lib/main.dart
@@ -29,6 +29,7 @@
         onPressed: () => {},
       ),
       AnimatedOpacity(
+        duration: const Duration(seconds: 2),
         opacity: opacity,
         child: const Column(
           children: [
```

#### 4. 애니메이션에 대한 트리거를 설정하고, 종료 값 선택 {:#4-set-up-a-trigger-for-animation-and-choose-an-end-value}

사용자가 **Show details**를 클릭할 때 트리거되도록 애니메이션을 구성합니다. 
이렇게 하려면, `TextButton`에 대한 `onPressed()` 핸들러를 사용하여 `opacity` 상태를 변경합니다. 
사용자가 **Show details**를 클릭할 때 `FadeInDemo` 위젯이 완전히 표시되도록 하려면, 
`onPressed()` 핸들러를 사용하여 `opacity`를 1로 설정합니다.

```diff2html
--- opacity4/lib/main.dart
+++ opacity5/lib/main.dart
@@ -26,7 +26,9 @@
           'Show Details',
           style: TextStyle(color: Colors.blueAccent),
         ),
-        onPressed: () => {},
+        onPressed: () => setState(() {
+          opacity = 1;
+        }),
       ),
       AnimatedOpacity(
         duration: const Duration(seconds: 2),
```

:::note
`opacity`의 시작 및 종료 값만 설정하면 됩니다.
`AnimatedOpacity` 위젯은 그 사이의 모든 것을 관리합니다.
:::

### 페이드인(완료) {:#fade-in-complete}

변경이 완료된 예제는 다음과 같습니다.
이 예제를 실행한 다음 **Show details**를 클릭하여 애니메이션을 트리거합니다.

{% render docs/implicit-animations/fade-in-complete.md %}

### 모두 합치기 {:#putting-it-all-together}

[페이드인 텍스트 효과][Fade-in text effect] 예제는 `AnimatedOpacity` 위젯의 다음 기능을 보여줍니다.

- `opacity` 속성의 상태 변경을 수신합니다.
- `opacity` 속성이 변경되면, `opacity`의 새 값으로 전환을 애니메이션화합니다.
- 값 사이의 전환에 걸리는 시간을 정의하기 위해 `duration` 매개변수가 필요합니다.

:::note
- 암묵적 애니메이션은 부모 stateful 위젯의 속성만 애니메이션화할 수 있습니다. 
  앞의 예에서는 `StatefulWidget`을 확장하는 `FadeInDemo` 위젯을 사용하여 이를 활성화합니다.

- `AnimatedOpacity` 위젯은 `opacity` 속성만 애니메이션화합니다. 
  일부 암묵적 애니메이션 위젯은 동시에 여러 속성을 애니메이션화할 수 있습니다. 
  다음 예제에서는 이를 보여줍니다.
:::

## 예제: 모양 변환 효과 {:#example-shape-shifting-effect}

다음 예제는 [`AnimatedContainer`][] 위젯을 사용하여 서로 다른 타입(`double` 및 `Color`)의 여러 속성(`margin`, `borderRadius`, `color`)을 애니메이션화하는 방법을 보여줍니다. **예제는 애니메이션 코드 없이 시작합니다.** 다음을 포함하는 [Material App][] 홈 화면으로 시작합니다.

- `borderRadius`, `margin`, `color`로 구성된 `Container` 위젯. 
  이러한 속성은 예제를 실행할 때마다 다시 생성되도록 설정됩니다.
- 클릭해도 아무 작업도 수행하지 않는 **Change** 버튼.

### Shape 변환 (시작 코드) {:#shape-shifting-starter-code}

예제를 시작하려면, **Run**을 클릭하세요.

{% render docs/implicit-animations/shape-shifting-starter-code.md %}

### AnimatedContainer를 사용하여 색상, borderRadius 및 여백에 애니메이션 적용 {:#animate-color-borderradius-and-margin-with-animatedcontainer}

이 섹션에는 [모양 변환 시작 코드][shape-shifting starter code]에 암묵적 애니메이션을 추가하는 데 사용할 수 있는 단계 리스트가 들어 있습니다. 각 단계를 완료한 후에는, 이미 변경한 내용으로 [모양 변환 예제 완료][complete shape-shifting example]를 실행할 수도 있습니다.

[모양 변환 시작 코드][shape-shifting starter code]는 `Container` 위젯의 각 속성에 임의의 값을 할당합니다. 연관된 함수는 관련 값을 생성합니다.

- `randomColor()` 함수는 `color` 속성에 대해 `Color`를 생성합니다.
- `randomBorderRadius()` 함수는 `borderRadius` 속성에 대해 `double`을 생성합니다.
- `randomMargin()` 함수는 `margin` 속성에 대해 `double`을 생성합니다.

다음 단계에서는 `AnimatedContainer` 위젯을 사용하여 다음을 수행합니다.

- 사용자가 **Change**를 클릭할 때마다, `color`, `borderRadius` 및 `margin`에 대한 새 값으로 전환합니다.
- `color`, `borderRadius`, `margin`의 새 값이 설정될 때마다 해당 값으로 전환을 애니메이션으로 적용합니다.

#### 1. 암묵적 애니메이션 추가 {:#1-add-an-implicit-animation}

`Container` 위젯을 `AnimatedContainer` 위젯으로 변경합니다.

```diff2html
--- container1/lib/main.dart
+++ container2/lib/main.dart
@@ -47,7 +47,7 @@
             SizedBox(
               width: 128,
               height: 128,
-              child: Container(
+              child: AnimatedContainer(
                 margin: EdgeInsets.all(margin),
                 decoration: BoxDecoration(
                   color: color,
```

:::note
[모양 변환 시작 코드][shape-shifting starter code]에서 변경 사항을 어디에 적용해야 하는지 
추적하는 데 도움이 되도록 예제 코드의 줄 번호를 참조할 수 있습니다.
:::

#### 2. 애니메이션 속성에 대한 시작 값 설정 {:#2-set-starting-values-for-animated-properties}

`AnimatedContainer` 위젯은 속성이 변경될 때 이전 값과 새 값 사이를 전환합니다. 
사용자가 **Change**를 클릭할 때 트리거되는 동작을 포함하려면, `change()` 메서드를 만듭니다. 
`change()` 메서드는 `setState()` 메서드를 사용하여 
`color`, `borderRadius` 및 `margin` 상태 변수에 대한 새 값을 설정할 수 있습니다.

```diff2html
--- container2/lib/main.dart
+++ container3/lib/main.dart
@@ -38,6 +38,14 @@
     margin = randomMargin();
   }

+  void change() {
+    setState(() {
+      color = randomColor();
+      borderRadius = randomBorderRadius();
+      margin = randomMargin();
+    });
+  }
+
   @override
   Widget build(BuildContext context) {
     return Scaffold(
```

#### 3. 애니메이션에 대한 트리거 설정 {:#3-set-up-a-trigger-for-the-animation}

사용자가 **Change**를 누를 때마다 애니메이션이 트리거되도록 설정하려면, 
`onPressed()` 핸들러에서 `change()` 메서드를 호출합니다.

```diff2html
--- container3/lib/main.dart
+++ container4/lib/main.dart
@@ -65,7 +65,7 @@
             ),
             ElevatedButton(
               child: const Text('Change'),
-              onPressed: () => {},
+              onPressed: () => change(),
             ),
           ],
         ),
```

#### 4. 기간 설정 {:#4-set-duration}

이전 값과 새 값 사이의 전환을 담당하는 애니메이션의 `duration`을 설정합니다.

```diff2html
--- container4/lib/main.dart
+++ container5/lib/main.dart
@@ -6,6 +6,8 @@

 import 'package:flutter/material.dart';

+const _duration = Duration(milliseconds: 400);
+
 double randomBorderRadius() {
   return Random().nextDouble() * 64;
 }
@@ -61,6 +63,7 @@
                   color: color,
                   borderRadius: BorderRadius.circular(borderRadius),
                 ),
+                duration: _duration,
               ),
             ),
             ElevatedButton(
```

### 모양 변환 (완료) {:#shape-shifting-complete}

변경 사항이 완료된 예제는 다음과 같습니다. 
코드를 실행하고 **Change**를 클릭하여 애니메이션을 트리거합니다. 
**Change**를 클릭할 때마다, 
모양이 `margin`, `borderRadius` 및 `color`에 대한 새 값으로 애니메이션됩니다.

{% render docs/implicit-animations/shape-shifting-complete.md %}

### 애니메이션 곡선 사용 {:#using-animation-curves}

앞의 예제는 다음 방법을 보여줍니다.

- 암묵적 애니메이션을 사용하면 특정 위젯 속성의 값 간 전환을 애니메이션 할 수 있습니다.
- `duration` 매개변수를 사용하면, 애니메이션이 완료되는 데 걸리는 시간을 설정할 수 있습니다.

암묵적 애니메이션을 사용하면, 설정된 `duration` 동안 발생하는 
애니메이션의 **속도(the rate)**를 변경할 수도 있습니다. 
이 속도 변경을 정의하려면, `curve` 매개변수의 값을 [`Curves`][] 클래스에 선언된 것과 같은 
[`Curve`][]로 설정합니다.

앞의 예제에서는 `curve` 매개변수의 값을 지정하지 않았습니다. 
지정된 곡선 값이 없으면, 암묵적 애니메이션은 [선형 애니메이션 곡선][linear animation curve]을 적용합니다.

[완전한 모양 변환 예제][complete shape-shifting example]에서 `curve` 매개변수의 값을 지정합니다.
`curve`에 [`easeInOutBack`][] 상수를 전달하면 애니메이션이 변경됩니다.

```diff2html
--- container5/lib/main.dart
+++ container6/lib/main.dart
@@ -64,6 +64,7 @@
                   borderRadius: BorderRadius.circular(borderRadius),
                 ),
                 duration: _duration,
+                curve: Curves.easeInOutBack,
               ),
             ),
             ElevatedButton(
```

`Curves.easeInOutBack` 상수를 `AnimatedContainer` 위젯의 `curve` 속성에 전달하여, 
`margin`, `borderRadius` 및 `color`의 변경 비율이 
해당 상수가 정의한 곡선을 어떻게 따르는지 살펴보세요.

<video style="width:464px; height:192px;" loop="" autoplay disablepictureinpicture playsinline controls controlslist="nodownload noremoteplayback">
  <source src="{{site.flutter-assets}}/animation/curve_ease_in_out_back.mp4" type="video/mp4">
</video>

### 모두 합치기 {:#putting-it-all-together-1}

[완전한 모양 변환 예제][complete shape-shifting example]는 `margin`, `borderRadius` 및 `color` 속성 값 간의 전환을 애니메이션화합니다. 
`AnimatedContainer` 위젯은 모든 속성의 변경 사항을 애니메이션화합니다. 
여기에는 `padding`, `transform` 및 심지어 `child`와 `alignment`와 같이 사용하지 않은 것도 포함됩니다!
암묵적 애니메이션의 추가 기능을 보여줌으로써, [완전한 모양 변환 예제][complete shape-shifting example]는 [페이드인 완료][fade-in complete] 예제를 기반으로 합니다.

암묵적 애니메이션을 요약하면 다음과 같습니다.

- `AnimatedOpacity` 위젯과 같은 일부 암묵적 애니메이션은, 하나의 속성만 애니메이션화합니다.
  `AnimatedContainer` 위젯과 같은 다른 것은, 여러 속성을 애니메이션화할 수 있습니다.
- 암묵적 애니메이션은 제공된 `curve`와 `duration`을 사용하여 
  속성의 이전 값과 새 값 사이의 전환을 애니메이션화합니다.
- `curve`를 지정하지 않으면, 암묵적 애니메이션은 기본적으로 [선형 곡선][linear curve]으로 설정됩니다.

## 다음은 무엇인가요? {:#whats-next}

축하합니다. 코드랩을 마쳤습니다!
자세히 알아보려면 다음 제안을 확인하세요.

- [애니메이션 튜토리얼][animations tutorial]을 시도해 보세요.
- [히어로(hero) 애니메이션][hero animations]과 [단계적(staggered) 애니메이션][staggered animations]에 대해 알아보세요.
- [애니메이션 라이브러리][animation library]를 확인하세요.
- 다른 [코드랩][codelab]을 시도해 보세요.

[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html
[AnimatedOpacity]: {{site.api}}/flutter/widgets/AnimatedOpacity-class.html
[animation library]: {{site.api}}/flutter/animation/animation-library.html
[animations tutorial]: /ui/animations/tutorial
[codelab]: /codelabs
[`Curve`]: {{site.api}}/flutter/animation/Curve-class.html
[`Curves`]: {{site.api}}/flutter/animation/Curves-class.html
[duration]: {{site.api}}/flutter/widgets/ImplicitlyAnimatedWidget/duration.html
[`easeInOutBack`]: {{site.api}}/flutter/animation/Curves/easeInOutBack-constant.html
[fade-in complete]: #fade-in-complete
[fade-in starter code]: #fade-in-starter-code
[Fade-in text effect]: #example-fade-in-text-effect
[hero animations]: /ui/animations/hero-animations
[ImplicitlyAnimatedWidget]: {{site.api}}/flutter/widgets/ImplicitlyAnimatedWidget-class.html
[linear animation curve]: {{site.api}}/flutter/animation/Curves/linear-constant.html
[linear curve]: {{site.api}}/flutter/animation/Curves/linear-constant.html
[make a Flutter app]: {{site.codelabs}}/codelabs/flutter-codelab-first
[Material App]: {{site.api}}/flutter/material/MaterialApp-class.html
[complete shape-shifting example]: #shape-shifting-complete
[shape-shifting starter code]: #shape-shifting-starter-code
[staggered animations]: /ui/animations/staggered-animations
[stateful widgets]: /ui/interactivity#stateful-and-stateless-widgets
