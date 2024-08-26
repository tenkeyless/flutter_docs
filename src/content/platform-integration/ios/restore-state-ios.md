--- 
# title: "Restore state on iOS"
title: "iOS에서 상태 복원"
# description: "How to restore the state of your iOS app after it's been killed by the OS."
description: "OS에 의해 종료된 후 iOS 앱 상태를 복원하는 방법."
---

사용자가 모바일 앱을 실행한 다음 실행할 다른 앱을 선택하면, 
첫 번째 앱이 백그라운드로 이동하거나 _백그라운드(backgrounded)_ 됩니다. 
운영 체제(iOS와 Android 모두)는 종종 백그라운드 앱을 종료하여, 
포그라운드에서 실행되는 앱의 메모리를 해제하거나 성능을 개선합니다.

[`RestorationManager`][](및 관련) 클래스를 사용하여, 상태 복원을 처리할 수 있습니다. 
iOS 앱은 Xcode에서 [약간의 추가 설정][a bit of extra setup]이 필요하지만, 
복원 클래스는 그 외에는 iOS와 Android에서 동일하게 작동합니다.

자세한 내용은, [Android에서 상태 복원][State restoration on Android] 및 [VeggieSeasons][] 코드 샘플을 확인하세요.

[a bit of extra setup]: {{site.api}}/flutter/services/RestorationManager-class.html#state-restoration-on-ios
[`RestorationManager`]: {{site.api}}/flutter/services/RestorationManager-class.html
[State restoration on Android]: /platform-integration/android/restore-state-android
[VeggieSeasons]: {{site.repo.samples}}/tree/main/veggieseasons

