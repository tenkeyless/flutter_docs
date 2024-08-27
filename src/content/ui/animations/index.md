---
# title: Introduction to animations
title: 애니메이션 소개
# short-title: Animations
short-title: 애니메이션
# description: How to perform animations in Flutter.
description: Flutter에서 애니메이션을 실행하는 방법.
---

잘 디자인된 애니메이션은 UI를 더 직관적으로 느끼게 하고, 세련된 앱의 매끄러운 모양과 느낌에 기여하며, 사용자 경험을 개선합니다. 
Flutter의 애니메이션 지원은 다양한 애니메이션 타입을 쉽게 구현할 수 있게 해줍니다. 
많은 위젯, 특히 [Material 위젯][Material widgets]에는 디자인 사양에 정의된 표준 모션 효과가 제공되지만, 
이러한 효과를 커스터마이즈 할 수도 있습니다.

## 접근 방식 선택 {:#choosing-an-approach}

Flutter에서 애니메이션을 만들 때 취할 수 있는 다양한 접근 방식이 있습니다. 
어떤 접근 방식이 당신에게 맞을까요? 
결정을 돕기 위해 [어떤 Flutter 애니메이션 위젯이 당신에게 맞을까요?][How to choose which Flutter Animation Widget is right for you?] 비디오를 시청해 보세요. 
(또한 [_companion article_][article1]로 게시됨.)

{% ytEmbed 'GXIJJkq_H8g', '사용 사례에 적합한 Flutter 애니메이션 위젯을 선택하는 방법' %}

(의사 결정 과정을 더 자세히 알아보려면, Flutter Europe에서 발표한 [Flutter에서 애니메이션을 올바르게 구현하기][Animations in Flutter done right] 비디오를 시청하세요.)

비디오에서 보여지는 것처럼, 
다음 의사 결정 트리는 Flutter 애니메이션을 구현할 때 어떤 접근 방식을 사용할지 결정하는 데 도움이 됩니다.

<img src='/assets/images/docs/ui/animations/animation-decision-tree.png'
    alt="애니메이션 결정 트리" class="mw-100">

미리 패키지된 암묵적 애니메이션(구현하기 가장 쉬운 애니메이션)이 귀하의 필요에 맞는다면, 
[암묵적 애니메이션을 사용한 애니메이션 기본 사항][Animation basics with implicit animations]을 시청하세요. (또한 [_companion article_][article2]로 게시됨.)

{% ytEmbed 'IVTjpW3W33s', 'Flutter 암묵적 애니메이션 기본 사항' %}

커스텀 암묵적 애니메이션을 만들려면, 
[TweenAnimationBuilder로 사용자 지정 암묵적 애니메이션 만들기][Creating your own custom implicit animations with TweenAnimationBuilder]를 시청하세요. (또한 [_companion article_][article3]으로 게시됨.)

{% ytEmbed '6KiPEqzJIKQ', 'TweenAnimationBuilder를 사용하여 커스텀 암묵적 애니메이션 만들기' %}

명시적 애니메이션(프레임워크가 제어하는 ​​대신, 애니메이션을 제어하는 ​​경우)을 만들려면, 
빌트인 명시적 애니메이션 클래스 중 하나를 사용할 수 있습니다. 
자세한 내용은 [내장된 명시적 애니메이션으로 첫 방향 애니메이션 만들기][Making your first directional animations with built-in explicit animations]를 시청하세요. (또한 [_companion article_][article4]로 게시됨.)

{% ytEmbed 'CunyH6unILQ', '내장된 명시적 애니메이션을 사용하여 첫 번째 방향 애니메이션 만들기', true %}

처음부터 명시적 애니메이션을 빌드해야 하는 경우, 
[AnimatedBuilder 및 AnimatedWidget을 사용하여 커스텀 명시적 애니메이션 만들기][Creating custom explicit animations with AnimatedBuilder and AnimatedWidget]를 시청하세요. (또한 [_companion article_][article5]로 게시됨.)

{% ytEmbed 'fneC7t4R_B0', 'AnimatedBuilder 및 AnimatedWidget을 사용하여 커스텀 명시적 애니메이션 만들기', true %}

Flutter에서 애니메이션이 어떻게 작동하는지 더 자세히 알아보려면 [애니메이션 심층 분석][Animation deep dive]을 시청하세요.
(또한 [_companion article_][article6]로 게시됨.)

{% ytEmbed 'PbcILiN8rbo', 'Flutter 애니메이션에 대해 자세히 알아보세요', true %}

## 코드랩, 튜토리얼 및 글 {:#codelabs-tutorials-and-articles}

다음 리소스는 Flutter 애니메이션 프레임워크를 배우기 시작하기에 좋은 곳입니다. 
이러한 각 문서는 애니메이션 코드를 작성하는 방법을 보여줍니다.

* [암묵적 애니메이션 코드랩][Implicit animations codelab]<br>
  단계별 지침과 대화형 예제를 사용하여 암묵적 애니메이션을 사용하는 방법을 다룹니다.

* [애니메이션 튜토리얼][Animations tutorial]<br>
  애니메이션 API의 다양한 측면을 사용하여 트윈 애니메이션의 진행을 안내하면서, 
  Flutter 애니메이션 패키지의 기본 클래스(컨트롤러, `Animatable`, curves, 리스너, 빌더)를 설명합니다. 
  이 튜토리얼은 사용자 지정 명시적 애니메이션을 만드는 방법을 보여줍니다.

* [Flutter를 사용한 Zero to One, 1부][Zero to One with Flutter, part 1] 및 [2부][part 2]<br>
  트위닝을 사용하여 애니메이션 차트를 만드는 방법을 보여주는 Medium 글.

* [웹에서 첫 번째 Flutter 앱 작성][Write your first Flutter app on the web]<br>
  사용자가 필드를 채울 때 진행 상황을 보여주는 애니메이션을 사용하는 양식을 만드는 방법을 보여주는 코드랩.

## Animation 타입 {:#animation-types}

일반적으로 애니메이션은 트윈 기반이거나 물리 기반입니다. 
다음 섹션에서는 이러한 용어의 의미를 설명하고, 자세히 알아볼 수 있는 리소스를 안내합니다.

### Tween 애니메이션 {:#tween-animation}

_in-betweening_ 의 약자입니다. 
트윈 애니메이션에서는, 시작점과 끝점이 정의되고, 타임라인과 전환의 타이밍과 속도를 정의하는 곡선(curve)도 정의됩니다. 
프레임워크는 시작점에서 끝점으로 전환하는 방법을 계산합니다.

위에 나열된 문서(예: [애니메이션 튜토리얼][Animations tutorial])는 특별히 트위닝에 대한 내용은 아니지만, 
예제에서 트윈을 사용합니다.

### 물리 기반 애니메이션 {:#physics-based-animation}

물리 기반 애니메이션에서, 동작은 실제 세계의 행동을 닮도록 모델링됩니다. 
예를 들어, 공을 던질 때, 공이 어디에 언제 떨어지는지는 공을 던진 속도와 땅에서 얼마나 떨어져 있는지에 따라 달라집니다. 
마찬가지로, 스프링에 부착된 공을 떨어뜨리는 것은, 끈에 부착된 공을 떨어뜨리는 것과 다르게 떨어집니다. (그리고 튀기도 합니다)

* [물리 시뮬레이션을 사용하여 위젯 애니메이션 만들기][Animate a widget using a physics simulation]<br>
  Flutter 쿡북의 애니메이션 섹션에 있는 레시피입니다.

* 또한 [`AnimationController.animateWith`][] 및 [`SpringSimulation`][]에 대한 API 문서를 참조하세요.

## 미리 준비된(Pre-canned) 애니메이션 {:#pre-canned-animations}

Material 위젯을 사용하는 경우, pub.dev에서 제공되는 [애니메이션 패키지][animations package]를 확인해 보세요. 
이 패키지에는 다음과 같은 일반적으로 사용되는 패턴에 대한 사전 빌드된 애니메이션이 포함되어 있습니다. 
`Container` 변환, 공유 축 변환, 페이드 스루 변환 및 페이드 변환.

## 일반적인 애니메이션 패턴 {:#common-animation-patterns}

대부분의 UX 또는 모션 디자이너는 UI를 디자인할 때 특정 애니메이션 패턴이 반복적으로 사용된다는 것을 알게 됩니다. 
이 섹션에서는 일반적으로 사용되는 애니메이션 패턴 중 일부를 나열하고, 자세한 내용을 알아볼 수 있는 곳을 알려줍니다.

### 애니메이션 리스트 또는 그리드 {:#animated-list-or-grid}

이 패턴은 리스트나 그리드에서 요소를 추가하거나 제거하는 것을 애니메이션으로 만드는 것을 포함합니다.

* [`AnimatedList` 예제][`AnimatedList` example]<br>
  [샘플 앱 카탈로그][Sample app catalog]의 ​​이 데모는 리스트에 요소를 추가하거나 선택한 요소를 제거하는 것을 애니메이션으로 만드는 방법을 보여줍니다. 
  사용자가 더하기(+) 및 빼기(-) 버튼을 사용하여 리스트를 수정하면 내부 Dart 리스트가 동기화됩니다.

### 공유 요소 전환 {:#shared-element-transition}

이 패턴에서, 사용자는 페이지에서 요소(종종 이미지)를 선택하고, 
UI는 선택한 요소를 더 자세한 내용이 있는 새 페이지로 애니메이션화합니다. 
Flutter에서는, `Hero` 위젯을 사용하여 경로 routes (페이지 pages) 간에 공유된 요소 전환을 쉽게 구현할 수 있습니다.

* [Hero 애니메이션][Hero animations]
  두 가지 스타일의 Hero 애니메이션을 만드는 방법:
  * Hero는 위치와 크기를 변경하면서, 한 페이지에서 다른 페이지로 날아갑니다.
  * Hero의 경계는 한 페이지에서 다른 페이지로 날아가면서 원에서 사각형으로 모양이 바뀝니다.

* 또한 [`Hero`][], [`Navigator`][], [`PageRoute`][] 클래스에 대한 API 문서를 참조하세요.

### 단계적(Staggered) 애니메이션 {:#staggered-animation}

더 작은 동작으로 나뉜 애니메이션으로, 동작 중 일부가 지연됩니다. 
더 작은 애니메이션은 순차적일 수도 있고, 일부 또는 완전히 겹칠 수도 있습니다.

* [단계적(Staggered) 애니메이션][Staggered Animations]

{% comment %}
  Save so I can remember how to add it back later.
  <img src="/assets/images/docs/ic_new_releases_black_24px.svg" alt="this doc is new!"> NEW<br>
{% endcomment -%}

## 기타 리소스 {:#other-resources}

다음 링크에서 Flutter 애니메이션에 대해 자세히 알아보세요.

* [애니메이션 샘플][Animation samples]은 [샘플 앱 카탈로그][Sample app catalog]에서.

* [애니메이션 레시피][Animation recipes]는 Flutter 쿡북에서.

* [애니메이션 비디오][Animation videos]는 Flutter YouTube 채널에서.

* [애니메이션: 개요][Animations: overview]<br>
  애니메이션 라이브러리의 주요 클래스와 Flutter의 애니메이션 아키텍처를 살펴봅니다.

* [애니메이션 및 모션 위젯][Animation and motion widgets]<br>
  Flutter API에서 제공하는 일부 애니메이션 위젯 카탈로그.

* [Flutter API 문서][Flutter API documentation]의 [애니메이션 라이브러리][animation library]<br>
  Flutter 프레임워크의 애니메이션 API. 이 링크는 라이브러리의 기술 개요 페이지로 이동합니다.

[Animate a widget using a physics simulation]: /cookbook/animation/physics-simulation
[`AnimatedList` example]: https://flutter.github.io/samples/animations.html
[Animation and motion widgets]: /ui/widgets/animation
[Animation basics with implicit animations]: {{site.yt.watch}}?v=IVTjpW3W33s&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=1
[Animation deep dive]: {{site.yt.watch}}?v=PbcILiN8rbo&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=5
[animation library]: {{site.api}}/flutter/animation/animation-library.html
[Animation recipes]: /cookbook/animation
[Animation samples]: {{site.repo.samples}}/tree/main/animations#animation-samples
[Animation videos]: {{site.social.youtube}}/search?query=animation
[Animations in Flutter done right]: {{site.yt.watch}}?v=wnARLByOtKA&t=3s
[Animations: overview]: /ui/animations/overview
[animations package]: {{site.pub}}/packages/animations
[Animations tutorial]: /ui/animations/tutorial
[`AnimationController.animateWith`]: {{site.api}}/flutter/animation/AnimationController/animateWith.html
[article1]: {{site.flutter-medium}}/how-to-choose-which-flutter-animation-widget-is-right-for-you-79ecfb7e72b5
[article2]: {{site.flutter-medium}}/flutter-animation-basics-with-implicit-animations-95db481c5916
[article3]: {{site.flutter-medium}}/custom-implicit-animations-in-flutter-with-tweenanimationbuilder-c76540b47185
[article4]: {{site.flutter-medium}}/directional-animations-with-built-in-explicit-animations-3e7c5e6fbbd7
[article5]: {{site.flutter-medium}}/when-should-i-useanimatedbuilder-or-animatedwidget-57ecae0959e8
[article6]: {{site.flutter-medium}}/animation-deep-dive-39d3ffea111f
[Creating your own custom implicit animations with TweenAnimationBuilder]: {{site.yt.watch}}?v=6KiPEqzJIKQ&feature=youtu.be
[Creating custom explicit animations with AnimatedBuilder and AnimatedWidget]: {{site.yt.watch}}?v=fneC7t4R_B0&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=4
[Flutter API documentation]: {{site.api}}
[`Hero`]: {{site.api}}/flutter/widgets/Hero-class.html
[Hero animations]: /ui/animations/hero-animations
[How to choose which Flutter Animation Widget is right for you?]: {{site.yt.watch}}?v=GXIJJkq_H8g
[Implicit animations codelab]: /codelabs/implicit-animations
[Making your first directional animations with built-in explicit animations]: {{site.yt.watch}}?v=CunyH6unILQ&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=3
[Material widgets]: /ui/widgets/material
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`PageRoute`]: {{site.api}}/flutter/widgets/PageRoute-class.html
[part 2]: {{site.medium}}/dartlang/zero-to-one-with-flutter-part-two-5aa2f06655cb
[Sample app catalog]: https://flutter.github.io/samples
[`SpringSimulation`]: {{site.api}}/flutter/physics/SpringSimulation-class.html
[Staggered Animations]: /ui/animations/staggered-animations
[Write your first Flutter app on the web]: /get-started/codelab-web
[Zero to One with Flutter, part 1]: {{site.medium}}/dartlang/zero-to-one-with-flutter-43b13fd7b354
