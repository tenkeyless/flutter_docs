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

기본 Flutter 템플릿에는 자체 assets으로 커스터마이즈할 수 있는 `LaunchScreen.storyboard`라는 Xcode 스토리보드가 포함되어 있습니다. 
기본적으로 스토리보드는 빈 이미지를 표시하지만, 이를 변경할 수 있습니다. 
이를 위해, 앱 디렉토리의 루트에서 `open ios/Runner.xcworkspace`를 입력하여, 
Flutter 앱의 Xcode 프로젝트를 엽니다. 
그런 다음, Project Navigator에서 `Runner/Assets.xcassets`를 선택하고, 
원하는 이미지를 `LaunchImage` 이미지 세트에 놓습니다.

Apple은 [Human Interface Guidelines][]의 일부로 실행 화면에 대한 자세한 지침을 제공합니다.

[apple-requirement]: {{site.apple-dev}}/documentation/xcode/specifying-your-apps-launch-screen
[Human Interface Guidelines]: {{site.apple-dev}}/design/human-interface-guidelines/patterns/launching#launch-screens
