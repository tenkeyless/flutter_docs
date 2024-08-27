---
# title: Start thinking declaratively
title: 선언적으로 생각하기 시작하세요
description: 선언적 프로그래밍에 대한 생각.
prev:
  # title: Intro
  title: 소개
  path: /development/data-and-backend/state-mgmt
next:
  # title: Ephemeral versus app state
  title: 일시적(Ephemeral) 상태 vs 앱 상태
  path: /development/data-and-backend/state-mgmt/ephemeral-vs-app
---

명령형 프레임워크(예: Android SDK 또는 iOS UIKit)에서 Flutter로 전환하는 경우, 
새로운 관점에서 앱 개발에 대해 생각해야 합니다.

여러분이 가질 수 있는 많은 가정은 Flutter에 적용되지 않습니다. 
예를 들어, Flutter에서는 UI의 일부를 수정하는 대신 처음부터 다시 빌드해도 됩니다. 
Flutter는 필요한 경우, 모든 프레임에서 이를 수행할 만큼 충분히 빠릅니다.

Flutter는 _선언적_ 입니다. 즉, Flutter는 앱의 현재 상태를 반영하도록 사용자 인터페이스를 빌드합니다.

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/ui-equals-function-of-state.png' width="100%" alt="A mathematical formula of UI = f(state). 'UI' is the layout on the screen. 'f' is your build methods. 'state' is the application state.">

{% comment %}
Source drawing for the png above: : https://docs.google.com/drawings/d/1RDcR5LyFtzhpmiT5-UupXBeos2Ban5cUTU0-JujS3Os/edit?usp=sharing
{% endcomment %}

앱의 상태가 변경되면(예: 사용자가 설정 화면에서 스위치를 켤 때), 상태를 변경하고, 그러면 사용자 인터페이스가 다시 그려집니다. 
UI 자체를 반드시 변경해야 하는 것은 아닙니다. (예: `widget.setText`) - 상태를 변경하면, UI가 처음부터 다시 빌드됩니다.

[시작 가이드][get started guide]에서 UI 프로그래밍에 대한 선언적 접근 방식에 대해 자세히 알아보세요.

UI 프로그래밍의 선언적 스타일에는 많은 이점이 있습니다. 
놀랍게도, UI의 모든 상태에 대한 코드 경로는 하나뿐입니다. 
주어진 상태에 대한 UI가 어떻게 보여야 하는지 한 번만 설명하면 됩니다.

처음에는, 이러한 프로그래밍 스타일이 명령적 스타일만큼 직관적이지 않을 수 있습니다. 
이 섹션이 여기에 있는 이유입니다. 계속 읽어보세요.

[get started guide]: /get-started/flutter-for/declarative
