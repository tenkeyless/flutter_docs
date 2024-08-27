---
# title: Scrolling
title: 스크롤
# description: Overview of Flutter's scrolling support
description: Flutter 스크롤 지원 개요
---

Flutter에는 자동 스크롤 기능을 갖춘 내장 위젯이 많이 있으며, 
특정 스크롤 동작을 생성하도록 커스터마이즈 할 수 있는 다양한 위젯도 제공합니다.

## 기본 스크롤 {:#basic-scrolling}

많은 Flutter 위젯은 바로 스크롤을 지원하고 대부분의 작업을 대신 해줍니다. 
예를 들어, [`SingleChildScrollView`][]는 필요할 때 자동으로 자식을 스크롤합니다. 
다른 유용한 위젯으로는 [`ListView`][]와 [`GridView`][]가 있습니다. 
위젯 카탈로그의 [스크롤 페이지][scrolling page]에서 이러한 위젯을 더 많이 확인할 수 있습니다.

{% ytEmbed 'DbkIQSvwnZc', 'Scrollbar | Flutter widget of the week' %}

{% ytEmbed 'KJpkjHGiI5A', 'ListView | Flutter widget of the week' %}

### 무한 스크롤 {:#infinite-scrolling}

`ListView` 또는 `GridView`에 긴 아이템 리스트가 있는 경우(_무한_ 리스트 포함), 
아이템이 뷰로 스크롤될 때 필요에 따라 아이템을 빌드할 수 있습니다. 
이렇게 하면 훨씬 더 성능이 좋은 스크롤링 경험이 제공됩니다. 
자세한 내용은 [`ListView.builder`][] 또는 [`GridView.builder`][]를 확인하세요.

[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[`GridView.builder`]: {{site.api}}/flutter/widgets/GridView/GridView.builder.html

### 특수 scrollable 위젯 {:#specialized-scrollable-widgets}

다음 위젯은 더 구체적인 스크롤 동작을 제공합니다.

[`DraggableScrollableSheet`][] 사용에 대한 비디오:

{% ytEmbed 'Hgw819mL_78', 'DraggableScrollableSheet | Flutter widget of the week' %}

[`ListWheelScrollView`][]를 사용하여 scrollable 영역을 휠로 바꾸세요!

{% ytEmbed 'dUhmWAz4C7Y', 'ListWheelScrollView | Flutter widget of the week' %}

[`DraggableScrollableSheet`]: {{site.api}}/flutter/widgets/DraggableScrollableSheet-class.html
[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`ListWheelScrollView`]: {{site.api}}/flutter/widgets/ListWheelScrollView-class.html
[scrolling page]: /ui/widgets/scrolling
[`SingleChildScrollView`]: {{site.api}}/flutter/widgets/SingleChildScrollView-class.html

{% comment %}
  Not yet, but coming. Two dimensional scrolling:
  TableView and TreeView.
  Video: {{site.yt.watch}}?v=UDZ0LPQq-n8
{% endcomment %}

## 멋진(Fancy) 스크롤 {:#fancy-scrolling}

아마도 _탄성 (elastic)_ 스크롤, 즉 _스크롤 바운싱(scroll bouncing)_ 을 구현하고 싶을 것입니다. 
아니면 (패럴랙스 스크롤링과 같은) 다른 동적 스크롤 효과를 구현하고 싶을 수도 있습니다. 
아니면 (축소 또는 사라지는 것과 같은) 매우 구체적인 동작이 있는 스크롤링 헤더를 원할 수도 있습니다.

Flutter `Sliver*` 클래스를 사용하면 이 모든 것과 그 이상을 달성할 수 있습니다. 
_sliver_ 는 scrollable 영역의 일부를 나타냅니다. 
sliver를 정의하고 [`CustomScrollView`][]에 삽입하여, 해당 영역을 보다 세부적으로 제어할 수 있습니다.

자세한 내용은 [sliver를 사용하여 멋진 스크롤 구현][Using slivers to achieve fancy scrolling] 및 [sliver 클래스][Sliver classes]를 확인하세요.

[`CustomScrollView`]: {{site.api}}/flutter/widgets/CustomScrollView-class.html
[Sliver classes]: /ui/widgets/layout#sliver-widgets
[Using slivers to achieve fancy scrolling]: /ui/layout/scrolling/slivers

## 중첩 스크롤 위젯 {:#nested-scrolling-widgets}

스크롤 성능을 저하시키지 않고, 스크롤 위젯을 다른 스크롤 위젯 안에 중첩하려면 어떻게 해야 하나요? 
`ShrinkWrap` 속성을 true로 설정하시나요? 아니면 슬리버를 사용하시나요?

"ShrinkWrap vs Slivers" 비디오를 확인하세요:

{% ytEmbed 'LUqDNnv_dh0', 'ShrinkWrap vs Slivers | Decoding Flutter' %}
