---
# title: Networking
title: 네트워킹
# description: Internet network calls in Flutter.
description: Flutter에서 인터넷 네트워크를 호출합니다.
---

## 크로스 플랫폼 http 네트워킹 {:#cross-platform-http-networking}

[`http`][] 패키지는 http 요청을 발행하는 가장 간단한 방법을 제공합니다. 
이 패키지는 Android, iOS, macOS, Windows, Linux 및 웹에서 지원됩니다.

## 플랫폼 노트 {:#platform-notes}

일부 플랫폼은, 아래에 자세히 설명된 대로, 추가 단계가 필요합니다.

### Android {:#android}

Android 앱은 Android 매니페스트(`AndroidManifest.xml`)에서 [인터넷 사용을 선언][declare]해야 합니다.

```xml
<manifest xmlns:android...>
 ...
 <uses-permission android:name="android.permission.INTERNET" />
 <application ...
</manifest>
```

### macOS {:#macos}

macOS 앱은 관련 `*.entitlements` 파일에서 네트워크 액세스를 허용해야 합니다.

```xml
<key>com.apple.security.network.client</key>
<true/>
```

[setting up entitlements][]에 대해 자세히 알아보세요.

[setting up entitlements]: /platform-integration/macos/building#setting-up-entitlements

## 샘플 {:#samples}

다양한 네트워킹 작업(데이터 가져오기, 웹 소켓, 백그라운드에서 데이터 구문 분석 포함)에 대한 실제 샘플은, 
[네트워킹 쿡북](/cookbook#networking)을 참조하세요.

[declare]: {{site.android-dev}}/training/basics/network-ops/connecting
[`http`]: {{site.pub-pkg}}/http
