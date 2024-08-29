---
# title: Building macOS apps with Flutter
title: Flutter로 macOS 앱 빌드
# description: Platform-specific considerations for building for macOS with Flutter.
description: Flutter를 사용하여 macOS에서 빌드할 때 플랫폼별 고려 사항.
toc: true
# short-title: macOS development
short-title: macOS 개발
---

이 페이지에서는 Apple Store를 통한 macOS 앱의 셸 통합 및 배포를 포함하여, 
Flutter를 사용하여 macOS 앱을 빌드하는 데 고유한 고려 사항에 대해 설명합니다.

## macOS 모양과 느낌과 통합 {:#integrating-with-macos-look-and-feel}

macOS 앱을 빌드하기 위해 선택한 모든 시각적 스타일이나 테마를 사용할 수 있지만, 
macOS의 모양과 느낌에 더욱 완벽하게 맞춰 앱을 조정하고 싶을 수 있습니다. 
Flutter에는 현재 iOS 디자인 언어에 대한 위젯 세트를 제공하는 [Cupertino] 위젯 세트가 포함되어 있습니다. 
슬라이더, 스위치, 세그먼트 컨트롤을 포함한 이러한 위젯 중 다수는 macOS에서도 사용하기에 적합합니다.

또는, [macos_ui][] 패키지가 필요에 잘 맞을 수 있습니다. 
이 패키지는 `MacosWindow` 프레임과 스캐폴드, 툴바, 풀다운 및 팝업 버튼, 모달 대화 상자를 포함하여, 
macOS 디자인 언어를 구현하는 위젯과 테마를 제공합니다.

[Cupertino]: /ui/widgets/cupertino
[macos_ui]: {{site.pub}}/packages/macos_ui

## macOS 앱 빌드 {:#building-macos-apps}

macOS 애플리케이션을 배포하려면, [macOS 앱 스토어를 통해 배포][distribute it through the macOS App Store]하거나, 
자체 웹사이트에서 `.app` 자체를 배포할 수 있습니다. 
macOS 10.14.5부터 macOS 앱 스토어 외부에서 배포하기 전에 macOS 애플리케이션을 공증해야 합니다.

위의 두 프로세스의 첫 번째 단계는 Xcode 내부에서 애플리케이션 작업을 하는 것입니다. 
Xcode 내부에서 애플리케이션을 컴파일하려면, 먼저 `flutter build` 명령을 사용하여, 
릴리스를 위한 애플리케이션을 빌드한 다음, Flutter macOS Runner 애플리케이션을 열어야 합니다.

```bash
flutter build macos
open macos/Runner.xcworkspace
```

Xcode에 들어가면, Apple의 [macOS 애플리케이션 공증에 대한 문서][documentation on notarizing macOS Applications] 또는 [App Store를 통한 애플리케이션 배포][on distributing an application through the App Store]를 따르세요. 
또한 아래의 [macOS별 지원](#entitlements-and-the-app-sandbox) 섹션을 읽어, 
자격(entitlements), 앱 샌드박스, 강화된 런타임이 배포 가능한 애플리케이션에 어떤 영향을 미치는지 이해해야 합니다.

[macOS 앱 빌드 및 릴리스][Build and release a macOS app]는 Flutter 앱을 App Store에 릴리스하는 방법에 대한 보다 자세한 단계별 연습 과정을 제공합니다.

[distribute it through the macOS App Store]: {{site.apple-dev}}/macos/submit/
[documentation on notarizing macOS Applications]:{{site.apple-dev}}/documentation/xcode/notarizing_macos_software_before_distribution
[on distributing an application through the App Store]: https://help.apple.com/xcode/mac/current/#/dev067853c94
[Build and release a macOS app]: /deployment/macos

## 권한(Entitlements) 및 앱 샌드박스 {:#entitlements-and-the-app-sandbox}

macOS 빌드는 기본적으로 서명되도록 구성되고, App Sandbox로 샌드박스됩니다. 
즉, 다음과 같이 macOS 앱에서 특정 기능이나 서비스를 부여하려는 경우:

* 인터넷 액세스
* 내장 카메라에서 영화 및 이미지 캡처
* 파일 액세스

그런 다음 Xcode에서 특정 _자격(entitlements)_ 을 설정해야 합니다. 다음 섹션에서는 이를 수행하는 방법을 설명합니다.

### 권한 설정 {:#setting-up-entitlements}

샌드박스 설정 관리 작업은 `macos/Runner/*.entitlements` 파일에서 수행합니다. 
이러한 파일을 편집할 때는 `debug` 및 `profile` 모드가 올바르게 작동하는 데 필요하므로, 
원본 `Runner-DebugProfile.entitlements` 예외(수신 네트워크 연결 및 JIT 지원)를 제거해서는 안 됩니다.

**Xcode capabilities UI**를 통해 자격 파일을 관리하는 데 익숙하다면, 
기능 편집기가 두 파일 중 하나만 업데이트하거나 어떤 경우에는 완전히 새로운 자격 파일을 생성하여, 
모든 구성에 사용하도록 프로젝트를 전환한다는 점을 알아두십시오. 
어느 시나리오든 문제가 발생합니다. 파일을 직접 편집하는 것이 좋습니다. 
매우 구체적인 이유가 없는 한 항상 두 파일에 동일한 변경 사항을 적용해야 합니다.

앱 샌드박스를 활성화한 상태로 유지하는 경우(앱을 [App Store][]에 배포하려는 경우 필요함), 
특정 플러그인이나 기타 기본 기능을 추가할 때 애플리케이션의 자격을 관리해야 합니다. 
예를 들어, [`file_chooser`][] 플러그인을 사용하려면, 
`com.apple.security.files.user-selected.read-only` 또는 `com.apple.security.files.user-selected.read-write` 자격을 추가해야 합니다. 
또 다른 일반적인 자격은 `com.apple.security.network.client`로, 네트워크 요청을 하는 경우 추가해야 합니다.

예를 들어, `com.apple.security.network.client` 자격이 없으면, 
네트워크 요청은 다음과 같은 메시지와 함께 실패합니다.

```console
flutter: SocketException: Connection failed
(OS Error: Operation not permitted, errno = 1),
address = example.com, port = 443
```

:::important
들어오는 네트워크 연결을 허용하는 `com.apple.security.network.server` 자격은, 
기본적으로 `debug` 및 `profile` 빌드에서만 활성화되어, 
Flutter 도구와 실행 중인 앱 간의 통신을 가능하게 합니다. 
애플리케이션에서 들어오는 네트워크 요청을 허용해야 하는 경우, 
`com.apple.security.network.server` 자격을 `Runner-Release.entitlements`에도 추가해야 합니다. 
그렇지 않으면, 애플리케이션이 디버그 또는 프로필 테스트에서는 제대로 작동하지만, 
릴리스 빌드에서는 실패합니다.
:::

이러한 주제에 대한 자세한 내용은 Apple Developer 사이트에서 [앱 샌드박스][App Sandbox] 및 [자격][Entitlements]을 참조하세요.

[App Sandbox]: {{site.apple-dev}}/documentation/security/app_sandbox
[App Store]: {{site.apple-dev}}/app-store/submissions/
[Entitlements]: {{site.apple-dev}}/documentation/bundleresources/entitlements
[`file_chooser`]: {{site.github}}/google/flutter-desktop-embedding/tree/master/plugins/file_chooser

## 강화된 런타임 {:#hardened-runtime}

App Store 외부에서 애플리케이션을 배포하기로 선택한 경우, 
macOS와의 호환성을 위해 애플리케이션을 공증해야 합니다. 
이를 위해서는 Hardened Runtime 옵션을 활성화해야 합니다. 
활성화한 후에는 빌드하기 위해 유효한 서명 인증서가 필요합니다.

기본적으로, 자격 파일은 디버그 빌드에 JIT를 허용하지만, 
App Sandbox와 마찬가지로 다른 자격을 관리해야 할 수도 있습니다. 
App Sandbox와 Hardened Runtime을 모두 활성화한 경우, 
동일한 리소스에 대해 여러 자격을 추가해야 할 수도 있습니다. 
예를 들어, 마이크 액세스에는 `com.apple.security.device.audio-input`(Hardened Runtime의 경우)과 
`com.apple.security.device.microphone`(App Sandbox의 경우)이 모두 필요합니다.

이 주제에 대한 자세한 내용은, Apple Developer 사이트에서 [Hardened Runtime][]을 참조하세요.

[Hardened Runtime]: {{site.apple-dev}}/documentation/security/hardened_runtime
