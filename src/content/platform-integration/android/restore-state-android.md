--- 
# title: "Restore state on Android"
title: "Android에서 상태 복원"
# description: "How to restore the state of your Android app after it's been killed by the OS."
description: "OS에 의해 Android 앱이 종료된 후, 해당 앱 상태를 복원하는 방법입니다."
---

사용자가 모바일 앱을 실행한 다음 실행할 다른 앱을 선택하면, 첫 번째 앱이 백그라운드로 이동하거나, _백그라운드 (backgrounded)_ 됩니다. 
운영 체제(iOS와 Android 모두)는 백그라운드 앱을 종료하여 메모리를 해제하고, 포그라운드에서 실행되는 앱의 성능을 개선할 수 있습니다.

사용자가 앱을 다시 선택하여, 포그라운드로 다시 가져오면, OS가 앱을 다시 시작합니다. 
하지만, 앱이 종료되기 전의 상태를 저장하는 방법을 설정하지 않았다면, 상태를 잃고 앱은 처음부터 다시 시작합니다. 
사용자는 기대했던 연속성을 잃었고, 이는 분명 이상적이지 않습니다. 
(긴 양식을 작성하다가 **Submit**을 클릭하기 _전에_ 전화로 중단되는 상황을 상상해 보세요.)

그렇다면, 앱 상태를 백그라운드로 보내지기 전처럼 복원하려면 어떻게 해야 할까요?

Flutter는 [services][] 라이브러리의 [`RestorationManager`][](및 관련 클래스)를 사용하여 이 문제를 해결합니다. 
`RestorationManager`를 사용하면, Flutter 프레임워크가 _상태가 변경됨에 따라_ 엔진에 상태 데이터를 제공하므로, 
OS가 앱을 종료하려고 한다는 신호를 보낼 때 앱이 준비되고, 앱은 준비할 시간만 갖게 됩니다.

:::secondary 인스턴스 상태 vs long-lived 상태
  `RestorationManager`를 언제 사용해야 하고, 상태를 장기 저장소에 저장해야 하는 경우는 언제인가요? 
  _인스턴스 상태_(_단기(short-term)_ 또는 _임시적(ephemeral) 상태_ 라고도 함)에는 제출되지 않은 양식 필드 값, 
  현재 선택된 탭 등이 포함됩니다. 
  Android에서는 1MB로 제한되며, 앱이 이를 초과하면, 
  네이티브 코드에서 `TransactionTooLargeException` 오류와 함께 충돌합니다.
:::

[state]: /data-and-backend/state-mgmt/ephemeral-vs-app

## 개요 {:#overview}

몇 가지 작업만으로 상태 복원을 활성화할 수 있습니다.

1. ([`TextField`][] 및 [`ScrollView`][]와 같이) 이를 지원하는 모든 위젯에 대해, 
   `restorationId` 또는 `restorationScopeId`를 정의합니다. 
   이렇게 하면, 해당 위젯에 대한 기본 제공 상태 복원이 자동으로 활성화됩니다.

2. 커스텀 위젯의 경우, 복원할 상태를 결정하고 해당 상태를 [`RestorableProperty`][]에 보관해야 합니다. 
   (Flutter API는 다양한 데이터 타입에 대해 다양한 하위 클래스를 제공합니다.) 
   [`RestorationMixin`][]을 사용하는 `State` 클래스에서, 해당 `RestorableProperty` 위젯을 정의합니다. 
   `restoreState` 메서드에서 믹스인에 해당 위젯을 등록합니다.

3. Navigator API(예: `push`, `pushNamed` 등)를 사용하는 경우, 
   이름에 "restorable"이 포함된 API(`restorablePush`, `restorablePushNamed` 등)로 마이그레이션하여, 
   탐색 스택을 복원합니다.

기타 고려 사항:

* `MaterialApp`, `CupertinoApp` 또는 `WidgetsApp`에 `restorationId`를 제공하면,
  `RootRestorationScope`를 주입하여 자동으로 상태 복원이 활성화됩니다. 
  앱 클래스 _위의_ 상태를 복원해야 하는 경우, `RootRestorationScope`를 수동으로 주입합니다.

* **`restorationId`와 `restorationScopeId`의 차이점:** 
  `restorationScopeID`를 사용하는 위젯은 모든 자식이 상태를 저장하는 새 `restorationScope`(새 `RestorationBucket`)를 만듭니다. 
  `restorationId`는 위젯(및 해당 자식)이 주변 버킷에 데이터를 저장함을 의미합니다.

[a bit of extra setup]: {{site.api}}/flutter/services/RestorationManager-class.html#state-restoration-on-ios
[`restorationId`]: {{site.api}}/flutter/widgets/RestorationScope/restorationId.html
[`restorationScopeId`]: {{site.api}}/flutter/widgets/RestorationScope/restorationScopeId.html
[`RestorationMixin`]: {{site.api}}/flutter/widgets/RestorationMixin-mixin.html
[`RestorationScope`]: {{site.api}}/flutter/widgets/RestorationScope-class.html
[`restoreState`]: {{site.api}}/flutter/widgets/RestorationMixin/restoreState.html
[VeggieSeasons]: {{site.repo.samples}}/tree/main/veggieseasons

## 네비게이션 상태 복원 {:#restoring-navigation-state}

사용자가 가장 최근에 본 특정 경로(예: 쇼핑 카트)로 앱을 돌아가게 하려면, 탐색을 위한 복원 상태도 구현해야 합니다.

Navigator API를 직접 사용하는 경우, 
표준 메서드를 복원 가능한 메서드(이름에 "복원 가능"이 있는 메서드)로 마이그레이션합니다. 
예를 들어, `push`를 [`restorablePush`][]로 바꿉니다.

VeggieSeasons 예제(아래 "기타 리소스"에 나열됨)는 [`go_router`][] 패키지로 탐색을 구현합니다. 
`restorationId` 값을 설정하는 것은 `lib/screens` 클래스에서 발생합니다.

## 상태 복원 테스트 {:#testing-state-restoration}

상태 복원을 테스트하려면, 앱이 백그라운드로 전환되면 상태를 저장하지 않도록 모바일 기기를 설정하세요. 
iOS와 Android에서 이 작업을 수행하는 방법을 알아보려면, 
[`RestorationManager`][] 페이지에서 [상태 복원 테스트][Testing state restoration]를 확인하세요.

:::warning
테스트가 끝나면 기기에서 상태 저장 기능을 다시 활성화하는 것을 잊지 마세요!
:::

[Testing state restoration]: {{site.api}}/flutter/services/RestorationManager-class.html#testing-state-restoration
[`RestorationBucket`]: {{site.api}}/flutter/services/RestorationBucket-class.html
[`RestorationManager`]: {{site.api}}/flutter/services/RestorationManager-class.html
[services]: {{site.api}}/flutter/services/services-library.html

## 기타 리소스 {:#other-resources}

상태 복원에 대한 자세한 내용은 다음 리소스를 확인하세요.

* 상태 복원을 구현하는 예는, Cupertino 위젯을 사용하는 iOS용으로 작성된 샘플 앱인, [VeggieSeasons][]를 확인하세요. 
  iOS 앱은 Xcode에서 [약간의 추가 설정][a bit of extra setup]이 필요하지만, 
  복원 클래스는 그 외에는 iOS와 Android에서 모두 동일하게 작동합니다.<br> 
  다음 목록은 VeggieSeasons 예제의 관련 부분으로 연결됩니다.
  * [`RestorablePropery`를 인스턴스 속성으로 정의]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L33-L37)
  * ​​[속성 등록]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L49-L54)
  * [속성 값 업데이트]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L108-L109)
  * [빌드에서 속성 값 사용]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L205-L210)<br>

* 단기 및 장기 상태에 대해 자세히 알아보려면, [임시적(ephemeral) 상태와 앱 상태의 차이점][state]를 확인하세요.

* [`statePersistence`][]와 같이 상태 복원을 수행하는, pub.dev의 패키지를 확인해 보세요.

* 탐색 및 `go_router` 패키지에 대한 자세한 내용은 [탐색 및 라우팅][Navigation and routing]을 확인하세요.

[`RestorableProperty`]: {{site.api}}/flutter/widgets/RestorableProperty-class.html
[`restorablePush`]: {{site.api}}/flutter/widgets/Navigator/restorablePush.html
[`ScrollView`]: {{site.api}}/flutter/widgets/ScrollView/restorationId.html
[`statePersistence`]: {{site.pub-pkg}}/state_persistence
[`TextField`]: {{site.api}}/flutter/material/TextField/restorationId.html
[`restorablePush`]: {{site.api}}/flutter/widgets/Navigator/restorablePush.html
[`go_router`]: {{site.pub}}/packages/go_router
[Navigation and routing]: /ui/navigation
