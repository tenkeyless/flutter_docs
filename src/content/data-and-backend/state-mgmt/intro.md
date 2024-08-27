---
# title: State management
title: 상태 관리
# description: How to structure an app to manage the state of the data flowing through it.
description: 앱에 흐르는 데이터 상태를 관리하기 위해 앱을 구성하는 방법입니다.
next:
  # title: Start thinking declaratively
  title: 선언적으로 생각하기 시작하세요
  path: /development/data-and-backend/state-mgmt/declarative
---

:::note
Flutter를 사용하여 모바일 앱을 작성했고, 재시작 시 앱 상태가 손실되는 이유가 궁금하다면, 
[Android에서 상태 복원][Restore state on Android] 또는 [iOS에서 상태 복원][Restore state on iOS]을 확인하세요.
:::

[Restore state on Android]: /platform-integration/android/restore-state-android
[Restore state on iOS]: /platform-integration/ios/restore-state-ios

_reactive 앱의 상태 관리에 대해 이미 잘 알고 있다면, 이 섹션을 건너뛸 수 있지만, [다양한 접근 방식 리스트][list of different approaches]를 검토하고 싶을 수도 있습니다._

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/state-management-explainer.gif' width="100%" alt="A short animated gif that shows the workings of a simple declarative state management system. This is explained in full in one of the following pages. Here it's just a decoration.">

{% comment %}
Source of the above animation tracked internally as b/122314402
{% endcomment %}

Flutter를 탐색하다 보면, 앱 전체에서 화면 간에 애플리케이션 상태를 공유해야 할 때가 옵니다. 
취할 수 있는 접근 방식은 다양하고, 생각해야 할 질문도 많습니다.

다음 페이지에서는, Flutter 앱에서 상태를 처리하는 기본 사항을 알아봅니다.

[list of different approaches]: /data-and-backend/state-mgmt/options
