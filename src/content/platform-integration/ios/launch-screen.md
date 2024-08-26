---
# title: Adding a launch screen to your iOS app
title: iOS 앱에 시작 화면 추가
# short-title: Launch screen
short-title: 시작 화면
# description: Learn how to add a launch screen to your iOS app.
description: iOS 앱에 시작 화면을 추가하는 방법을 알아보세요.
toc: false
---

{% comment %}
Consider introducing an image here similar to the android splash-screen one:
https://github.com/flutter/website/issues/8357
{% endcomment -%}

[런치 스크린][Launch screens]은 iOS 앱이 로드되는 동안 간단한 초기 경험을 제공합니다. 
앱 엔진이 로드되고 앱이 초기화될 시간을 허용하는 동시에, 애플리케이션의 무대를 설정합니다.

[Launch screens]: {{site.apple-dev}}/design/human-interface-guidelines/launching#Launch-screens

Apple App Store에 제출된 모든 앱은 Xcode 스토리보드가 포함된 [시작 화면을 제공해야][apple-requirement] 합니다.

## 시작 화면 커스터마이즈 {:#customize-the-launch-screen}

The default Flutter template includes an Xcode
storyboard named `LaunchScreen.storyboard`
that can be customized with your own assets.
By default, the storyboard displays a blank image,
but you can change this. To do so,
open the Flutter app's Xcode project
by typing `open ios/Runner.xcworkspace`
from the root of your app directory.
Then select `Runner/Assets.xcassets`
from the Project Navigator and
drop in the desired images to the `LaunchImage` image set.

Apple provides detailed guidance for launch screens as
part of the [Human Interface Guidelines][].

[apple-requirement]: {{site.apple-dev}}/documentation/xcode/specifying-your-apps-launch-screen
[Human Interface Guidelines]: {{site.apple-dev}}/design/human-interface-guidelines/patterns/launching#launch-screens
