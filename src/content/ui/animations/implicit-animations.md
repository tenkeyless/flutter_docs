---
# title: Implicit animations
title: 암묵적 애니메이션
# description: Where to find more information on using implicit animations in Flutter.
description: Flutter에서 암묵적 애니메이션을 사용하는 방법에 대한 자세한 내용은 어디에서 찾을 수 있나요?
---

Flutter의 [애니메이션 라이브러리][animation library]를 사용하면, 
UI의 위젯에 모션을 추가하고 시각적 효과를 만들 수 있습니다. 
라이브러리의 한 부분은 애니메이션을 관리하는 위젯 모음입니다. 
이러한 위젯은 총칭하여 _암묵적 애니메이션(implicit animations)_ 또는 _암묵적으로 애니메이션이 적용된 위젯(implicitly animated widgets)_ 이라고 하며, 구현하는 [`ImplicitlyAnimatedWidget`][] 클래스에서 이름을 따왔습니다. 
다음 리소스 세트는 Flutter에서 암묵적 애니메이션에 대해 배우는 여러 가지 방법을 제공합니다.

## 문서 {:#documentation}

[암시적 애니메이션 코드랩][Implicit animations codelab]
: 바로 코드로 들어가세요! 
  이 코드랩은 대화형 예제와 단계별 지침을 사용하여 암묵적 애니메이션을 사용하는 방법을 알려줍니다.

[`AnimatedContainer` 샘플][`AnimatedContainer` sample]
: [Flutter 쿡북][Flutter cookbook]에서 
  [`AnimatedContainer`][] 암묵적으로 애니메이션이 적용된 위젯을 사용하기 위한 단계별 레시피입니다.

[`ImplicitlyAnimatedWidget`][] API 페이지
: 모든 암묵적 애니메이션은 `ImplicitlyAnimatedWidget` 클래스를 확장합니다.

## Flutter in Focus 비디오 {:#flutter-in-focus-videos}

Flutter in Focus 비디오는 모든 Flutter 개발자가 처음부터 끝까지 알아야 할 기술을 다루는, 
실제 코드가 포함된 5~10분 분량의 튜토리얼을 제공합니다. 
다음 비디오는 암묵적 애니메이션과 관련된 주제를 다룹니다.

{% ytEmbed 'IVTjpW3W33s', 'Flutter 암묵적 애니메이션 기본 사항' %}

{% ytEmbed '6KiPEqzJIKQ', 'TweenAnimationBuilder를 사용하여 커스텀 암묵적 애니메이션 만들기' %}

## The Boring Show {:#the-boring-show}

The Boring Show를 시청하여 Google 엔지니어가 Flutter에서 처음부터 앱을 빌드하는 모습을 지켜보세요. 
다음 에피소드에서는 뉴스 애그리게이터 앱에서 암묵적 애니메이션을 사용하는 방법을 다룹니다.

{% ytEmbed '8ehlWchLVlQ', '뉴스 애플리케이션에 암묵적 애니메이션 추가' %}

## Widget of the Week 비디오 {:#widget-of-the-week-videos}

각 위젯의 중요한 기능을 보여주는 짧은 애니메이션 비디오의 주간 시리즈입니다. 
약 60초 안에, 각 위젯의 실제 코드와 작동 방식에 대한 데모를 볼 수 있습니다. 
다음 Widget of the Week 비디오는 암묵적으로 애니메이션이 적용된 위젯을 다룹니다.

{% assign animated-widgets = 'AnimatedOpacity, AnimatedPadding, AnimatedPositioned, AnimatedSwitcher' | split: ", " %}
{% assign animated-urls = 'QZAvjqOqiLY, PY2m0fhGNz4, hC3s2YdtWt8, 2W7POjFb88g' | split: ", " %}

{% for widget in animated-widgets %}
{% assign videoUrl = animated-urls[forloop.index0] %}
{% assign videoDescription = 'Flutter 위젯 ' | append: widget | append: '에 대해 배우기' %}

{% ytEmbed videoUrl, videoDescription %}

{% endfor -%}

[`AnimatedContainer` sample]: /cookbook/animation/animated-container
[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html
[animation library]: {{site.api}}/flutter/animation/animation-library.html
[Flutter cookbook]: /cookbook
[Implicit animations codelab]: /codelabs/implicit-animations
[`ImplicitlyAnimatedWidget`]: {{site.api}}/flutter/widgets/ImplicitlyAnimatedWidget-class.html
