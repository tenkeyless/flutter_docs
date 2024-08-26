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

You can enable state restoration with just a few tasks:

1. Define a `restorationId` or a `restorationScopeId`
   for all widgets that support it,
   such as [`TextField`][] and [`ScrollView`][].
   This automatically enables built-in state restoration
   for those widgets.

2. For custom widgets,
   you must decide what state you want to restore
   and hold that state in a [`RestorableProperty`][].
   (The Flutter API provides various subclasses for
   different data types.)
   Define those `RestorableProperty` widgets 
   in a `State` class that uses the [`RestorationMixin`][].
   Register those widgets with the mixin in a
   `restoreState` method.

3. If you use any Navigator API (like `push`, `pushNamed`, and so on)
   migrate to the API that has "restorable" in the name
   (`restorablePush`, `restorablePushNamed`, and so on)
   to restore the navigation stack.

Other considerations:

* Providing a `restorationId` to
  `MaterialApp`, `CupertinoApp`, or `WidgetsApp`
  automatically enables state restoration by
  injecting a `RootRestorationScope`.
  If you need to restore state _above_ the app class,
  inject a `RootRestorationScope` manually.

* **The difference between a `restorationId` and
  a `restorationScopeId`:** Widgets that take a
  `restorationScopeID` create a new `restorationScope`
  (a new `RestorationBucket`) into which all children
  store their state. A `restorationId` means the widget
  (and its children) store the data in the surrounding bucket.

[a bit of extra setup]: {{site.api}}/flutter/services/RestorationManager-class.html#state-restoration-on-ios
[`restorationId`]: {{site.api}}/flutter/widgets/RestorationScope/restorationId.html
[`restorationScopeId`]: {{site.api}}/flutter/widgets/RestorationScope/restorationScopeId.html
[`RestorationMixin`]: {{site.api}}/flutter/widgets/RestorationMixin-mixin.html
[`RestorationScope`]: {{site.api}}/flutter/widgets/RestorationScope-class.html
[`restoreState`]: {{site.api}}/flutter/widgets/RestorationMixin/restoreState.html
[VeggieSeasons]: {{site.repo.samples}}/tree/main/veggieseasons

## 네비게이션 상태 복원 {:#restoring-navigation-state}

If you want your app to return to a particular route
that the user was most recently viewing
(the shopping cart, for example), then you must implement
restoration state for navigation, as well.

If you use the Navigator API directly,
migrate the standard methods to restorable
methods (that have "restorable" in the name).
For example, replace `push` with [`restorablePush`][].

The VeggieSeasons example (listed under "Other resources" below)
implements navigation with the [`go_router`][] package.
Setting the `restorationId`
values occur in the `lib/screens` classes.

## 상태 복원 테스트 {:#testing-state-restoration}

To test state restoration, set up your mobile device so that
it doesn't save state once an app is backgrounded.
To learn how to do this for both iOS and Android,
check out [Testing state restoration][] on the
[`RestorationManager`][] page.

:::warning
Don't forget to reenable
storing state on your device once you are
finished with testing!
:::

[Testing state restoration]: {{site.api}}/flutter/services/RestorationManager-class.html#testing-state-restoration
[`RestorationBucket`]: {{site.api}}/flutter/services/RestorationBucket-class.html
[`RestorationManager`]: {{site.api}}/flutter/services/RestorationManager-class.html
[services]: {{site.api}}/flutter/services/services-library.html

## 기타 리소스 {:#other-resources}

For further information on state restoration,
check out the following resources:

* For an example that implements state restoration, 
  check out [VeggieSeasons][], a sample app written
  for iOS that uses Cupertino widgets. An iOS app requires
  [a bit of extra setup][] in Xcode, but the restoration
  classes otherwise work the same on both iOS and Android.<br>
  The following list links to relevant parts of the VeggieSeasons
  example:
    * [Defining a `RestorablePropery` as an instance property]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L33-L37)
    * [Registering the properties]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L49-L54)
    * [Updating the property values]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L108-L109)
    * [Using property values in build]({{site.repo.samples}}/blob/604c82cd7c9c7807ff6c5ca96fbb01d44a4f2c41/veggieseasons/lib/widgets/trivia.dart#L205-L210)<br>

* To learn more about short term and long term state,
  check out [Differentiate between ephemeral state
  and app state][state].

* You might want to check out packages on pub.dev that
  perform state restoration, such as [`statePersistence`][].

* For more information on navigation and the
  `go_router` package, check out [Navigation and routing][].

[`RestorableProperty`]: {{site.api}}/flutter/widgets/RestorableProperty-class.html
[`restorablePush`]: {{site.api}}/flutter/widgets/Navigator/restorablePush.html
[`ScrollView`]: {{site.api}}/flutter/widgets/ScrollView/restorationId.html
[`statePersistence`]: {{site.pub-pkg}}/state_persistence
[`TextField`]: {{site.api}}/flutter/material/TextField/restorationId.html
[`restorablePush`]: {{site.api}}/flutter/widgets/Navigator/restorablePush.html
[`go_router`]: {{site.pub}}/packages/go_router
[Navigation and routing]: /ui/navigation
