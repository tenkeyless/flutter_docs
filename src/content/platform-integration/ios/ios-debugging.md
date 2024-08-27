---
# title: iOS debugging
title: iOS 디버깅
# description: iOS-specific debugging techniques for Flutter apps
description: Flutter 앱을 위한 iOS 특정 디버깅 기술
---

[iOS 14 이상의 로컬 네트워크 권한][local network permissions in iOS 14 or later]과 관련된 보안으로 인해, 
핫 리로드 및 DevTools와 같은 Flutter 디버깅 기능을 사용하려면 권한 대화 상자를 수락해야 합니다.

![Screenshot of "allow network connections" dialog](/assets/images/docs/development/device-connect.png)

이는 디버그 및 프로필 빌드에만 영향을 미치며, 릴리스 빌드에는 나타나지 않습니다. 
**Settings > Privacy > Local Network > Your App**을 활성화하여 이 권한을 허용할 수도 있습니다.

[local network permissions in iOS 14 or later]: {{site.apple-dev}}/news/?id=0oi77447

