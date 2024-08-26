---
# title: Introduction to declarative UI
title: 선언적(declarative) UI 소개
# short-title: Declarative UI
short-title: 선언적 UI
description: 선언적 프로그래밍 스타일과 명령형 프로그래밍 스타일의 차이점을 설명합니다.
---

<?code-excerpt path-base="get-started/flutter-for/declarative"?>

_이 소개에서는 Flutter에서 사용하는 선언적 스타일과 다른 많은 UI 프레임워크에서 사용하는 명령형 스타일 간의 개념적 차이점을 설명합니다._

## 왜 선언적 UI인가요? {:#why-a-declarative-ui}

Win32에서 웹, Android 및 iOS에 이르기까지 프레임워크는 일반적으로 명령형 UI 프로그래밍 스타일을 사용합니다. 
이는 가장 익숙한 스타일일 수 있습니다. UIView 또는 이와 동등한 완전한 기능의 UI 엔티티를 수동으로 구성한 다음, 
나중에 UI가 변경될 때 메서드와 세터를 사용하여 변형합니다.

개발자가 다양한 UI 상태 간 전환 방법을 프로그래밍해야 하는 부담을 덜어주기 위해, 
Flutter는 대조적으로, 개발자가 현재 UI 상태를 설명하도록 하고, 전환은 프레임워크에 맡깁니다.

그러나, UI를 조작하는 방법에 대한 사고방식을 약간 바꿔야 합니다.

## 선언적 프레임워크에서 UI를 변경하는 방법 {:#how-to-change-ui-in-a-declarative-framework}

아래의 간단한 예를 살펴보겠습니다.

<img src="/assets/images/docs/declarativeUIchanges.png" alt="View B (contained by view A) morphs from containing two views, c1 and c2, to containing only view c3.">

명령형 스타일에서는, 일반적으로 ViewB의 소유자에게 가서, 
선택자(selectors)나 `findViewById` 또는 유사한 것을 사용하여, 
인스턴스 `b`를 검색하고, 
이에 대한 변형(mutations)을 호출합니다. (그리고 암묵적으로 무효화(invalidate)합니다) 
예를 들어:

```java
// 명령형 스타일
b.setColor(red)
b.clearChildren()
ViewC c3 = new ViewC(...)
b.add(c3)
```

UI의 진실의 근원(source of truth)이 인스턴스 `b` 자체보다 오래 지속(outlive)될 수 있으므로, 
ViewB의 생성자에서 이 구성을 복제해야 할 수도 있습니다.

선언적 스타일에서, 뷰 구성(예: Flutter의 위젯)은 변경할 수 없으며(immutable) 가벼운 "청사진"일 뿐입니다. 
UI를 변경하려면, 위젯이 자체적으로 재구축을 트리거하고,
(가장 일반적으로 Flutter의 StatefulWidgets에서 `setState()`를 호출) 새 위젯 하위 트리를 구성합니다.

<?code-excerpt "lib/main.dart (declarative)"?>
```dart
// 선언적 스타일
return ViewB(
  color: red,
  child: const ViewC(),
);
```

여기서, UI가 변경될 때 이전 인스턴스 `b`를 변형하는 대신, Flutter는 새로운 Widget 인스턴스를 구성합니다. 
프레임워크는 RenderObjects를 사용하여, 기존 UI 객체의 많은 책임(예: 레이아웃 상태 유지)을 백그라운드에서 관리합니다. 
RenderObjects는 프레임 간에 지속되고, 
Flutter의 가벼운 Widgets는 프레임워크에 RenderObjects를 상태 간에 변형하라고 지시합니다. 
Flutter 프레임워크는 나머지를 처리합니다.