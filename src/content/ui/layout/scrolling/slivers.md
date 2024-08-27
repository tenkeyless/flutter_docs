---
# title: Using slivers to achieve fancy scrolling
title: 슬리버를 사용하여 멋진 스크롤링 구현
# description: Where to find information on using slivers to implement fancy scrolling effects, like elastic scrolling, in Flutter.
description: Flutter에서 탄성 스크롤링 등의 멋진 스크롤 효과를 구현하기 위해, 슬리버를 사용하는 방법에 대한 정보를 찾을 수 있는 곳
toc: false
---

슬리버는 scrollable 영역의 일부로, 특별한 방식으로 동작하도록 정의할 수 있습니다. 
슬리버를 사용하면, (탄력적(elastic) 스크롤과 같은) 커스텀 스크롤 효과를 얻을 수 있습니다.

무료로, DartPad를 사용하는 강사 주도 비디오 워크숍에서, 슬리버 사용에 대한 다음 비디오를 확인하세요.

{% ytEmbed 'YY-_yrZdjGc', 'Building scrolling experiences in Flutter' %}

## 리소스 {:#resources}

Flutter에서 멋진 스크롤 효과를 구현하는 방법에 대한 자세한 내용은, 다음 리소스를 참조하세요.

**[Slivers, Demystified][]**
: sliver 클래스를 사용하여 커스텀 스크롤을 구현하는 방법을 설명하는 Medium의 무료 글.

**[SliverAppBar][sliver-app-bar-video]**
: `SliverAppBar` 위젯에 대한 개요를 제공하는 1분 분량의 주간 위젯 비디오.

  {% ytEmbed 'R9C5KMJKluE', 'SliverAppBar | Flutter widget of the week', true %}

**[SliverList 및 SliverGrid][SliverList and SliverGrid]**
: `SliverList`와 `SliverGrid` 위젯에 대한 개요를 제공하는 1분 분량의 주간 위젯 소개 영상입니다.

  {% ytEmbed 'ORiTTaVY6mM', 'SliverList & SliverGrid | Flutter widget of the week', true %}

**[Slivers 설명 - 동적 레이아웃 만들기][Slivers explained - Making dynamic layouts]**
: Flutter의 기술 책임자 Ian Hickson과 Filip Hracek이 Slivers의 힘에 대해 논의하는, 
  [The Boring Show][]의 50분 에피소드.

  {% ytEmbed 'Mz3kHQxBjGg', 'Slivers explained - Making dynamic layouts', true %}

## API 문서 {:#api-docs}

사용 가능한 슬리버 API에 대해 자세히 알아보려면, 다음 관련 API 문서를 확인하세요.

* [`CustomScrollView`][]
* [`SliverAppBar`][]
* [`SliverGrid`][]
* [`SliverList`][]

[`CustomScrollView`]: {{site.api}}/flutter/widgets/CustomScrollView-class.html
[sliver-app-bar-video]: {{site.yt.watch}}?v=R9C5KMJKluE
[`SliverAppBar`]: {{site.api}}/flutter/material/SliverAppBar-class.html
[`SliverGrid`]: {{site.api}}/flutter/widgets/SliverGrid-class.html
[SliverList and SliverGrid]: {{site.yt.watch}}?v=ORiTTaVY6mM
[`SliverList`]: {{site.api}}/flutter/widgets/SliverList-class.html
[Slivers, DeMystified]: {{site.flutter-medium}}/slivers-demystified-6ff68ab0296f
[Slivers explained - Making dynamic layouts]: {{site.yt.watch}}?v=Mz3kHQxBjGg
[The Boring Show]: {{site.yt.playlist}}PLOU2XLYxmsIK0r_D-zWcmJ1plIcDNnRkK
