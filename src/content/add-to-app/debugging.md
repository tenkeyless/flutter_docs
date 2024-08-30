---
# title: Debug your add-to-app module
title: 앱 to 앱 모듈 디버깅
# short-title: Debugging
short-title: 디버깅
# description: How to run, debug, and hot reload your add-to-app Flutter module.
description: 앱 to 앱 Flutter 모듈을 실행, 디버그, 핫 리로드하는 방법.
---

Flutter 모듈을 프로젝트에 통합하고, Flutter의 플랫폼 API를 사용하여 Flutter 엔진 및/또는 UI를 실행하면, 
일반 Android 또는 iOS 앱을 실행하는 것과 같은 방식으로 Android 또는 iOS 앱을 빌드하고 실행할 수 있습니다.

Flutter는 이제 코드에 `FlutterActivity` 또는 `FlutterViewController`가 포함된 모든 곳에서 UI를 구동합니다.

## 개요 {:#overview}

IDE에서 `flutter run` 또는 동등한 명령을 실행할 때 선호하는 Flutter 디버깅 도구 모음을 사용할 수 있는 데 익숙할 수 있습니다. 
하지만 핫 리로드, 성능 오버레이, DevTools, 앱 추가 시나리오에서 중단점 설정과 같은 
모든 Flutter [디버깅 기능][debugging functionalities]을 사용할 수도 있습니다.

`flutter attachment` 명령은 이러한 기능을 제공합니다. 
이 명령을 실행하려면, SDK의 CLI 도구, VS Code 또는 IntelliJ IDEA 또는 Android Studio를 사용할 수 있습니다.

`flutter attachment` 명령은 `FlutterEngine`을 실행하면 연결됩니다. 
`FlutterEngine`을 폐기할 때까지 연결된 상태로 유지됩니다. 
엔진을 시작하기 전에 `flutter attachment`를 호출할 수 있습니다. 
`flutter attachment` 명령은 엔진이 호스팅하는 다음 사용 가능한 Dart VM을 기다립니다.

## 터미널에서 디버그 {:#debug-from-the-terminal}

터미널에서 연결하려면 `flutter attachment`를 실행합니다. 
특정 대상 장치를 선택하려면 `-d <deviceId>`를 추가합니다.

```console
$ flutter attach
```

이 명령은 다음과 유사한 결과를 출력합니다.

```console
Syncing files to device iPhone 15 Pro...
 7,738ms (!)

To hot reload the changes while running, press "r".
To hot restart (and rebuild state). press "R".
An Observatory debugger and profiler on iPhone 15 Pro is available at:
http://127.0.0.1:65525/EXmCgco5zjo=/
For a more detailed help message, press "h".
To detach, press "d"; to quit, press "q".
```

## Xcode 및 VS Code에서 iOS 확장 프로그램 디버그 {:#debug-ios-extension-in-xcode-and-vs-code}

{% include docs/debug/debug-flow-ios.md add='launch' %}

## Android Studio에서 Android 확장 프로그램 디버그 {:#debug-android-extension-in-android-studio}

{% include docs/debug/debug-flow-androidstudio-as-start.md %}

[debugging functionalities]: /testing/debugging

## USB 연결 없이 디버깅 {:#wireless-debugging}

iOS 또는 Android 기기에서 Wi-Fi를 통해 앱을 디버깅하려면, `flutter attach`를 사용하세요.

### iOS 기기에서 Wi-Fi를 통한 디버그 {:#debug-over-wi-fi-on-ios-devices}

iOS 대상의 경우, 다음 단계를 완료하세요.

1. [iOS 설정 가이드][iOS setup guide]에 설명된 대로 기기가 Wi-Fi를 통해 Xcode에 연결되는지 확인하세요.

1. macOS 개발 컴퓨터에서, **Xcode** <span aria-label="and then">></span> **Product** <span aria-label="and then">></span> **Scheme** <span aria-label="and then">></span> **Edit Scheme...** 을 엽니다.

   <kbd>Cmd</kbd> + <kbd><</kbd>를 누를 수도 있습니다.

1. **Run**을 클릭합니다.

1. **Arguments**를 클릭합니다.

1. **Arguments Passed On Launch**에서 **+** 를 클릭합니다.

   {:type="a"}
   1. 개발 컴퓨터에서 IPv4를 사용하는 경우, `--vm-service-host=0.0.0.0`을 추가합니다.

   1. 개발 컴퓨터에서 IPv6를 사용하는 경우, `--vm-service-host=::0`을 추가합니다.

   {% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"development/add-to-app/debugging/wireless-port.png",
   caption:"IPv4 네트워크가 추가된 Launch에 대한 인수 전달", width:"100%" %}

#### IPv6 네트워크에 있는지 확인하려면 {:#to-determine-if-youre-on-an-ipv6-network}

1. **Settings** <span aria-label="and then">></span> **Wi-Fi**를 엽니다.

1. 연결된 네트워크를 클릭합니다.

1. **Details...**를 클릭합니다.

1. **TCP/IP**를 클릭합니다.

1. **IPv6 address** 섹션을 확인합니다.

   {% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"development/add-to-app/ipv6.png", caption:"macOS 시스템 설정을 위한 WiFi 대화 상자", width:"60%" %}

### Android 기기에서 Wi-Fi를 통한 디버그 {:#debug-over-wi-fi-on-android-devices}

[Android 설정 가이드][Android setup guide]에 설명된 대로 장치가 Wi-Fi를 통해 Android Studio에 연결되어 있는지 확인하세요.

[iOS setup guide]: /get-started/install/macos/mobile-ios
[Android setup guide]: /get-started/install/macos/mobile-android?tab=physical#configure-your-target-android-device
