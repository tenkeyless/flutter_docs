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

You might be used to having your suite of favorite Flutter debugging tools
available when running `flutter run` or an equivalent command from an IDE.
But you can also use all your Flutter [debugging functionalities][] such as
hot reload, performance overlays, DevTools, and setting breakpoints in
add-to-app scenarios.

The `flutter attach` command provides these functionalities.
To run this command, you can use the SDK's CLI tools, VS Code
or IntelliJ IDEA or Android Studio.

The `flutter attach` command connects once you run your `FlutterEngine`.
It remains attached until you dispose your `FlutterEngine`.
You can invoke `flutter attach` before starting your engine.
The `flutter attach` command waits for the next available Dart VM that
your engine hosts.

## 터미널에서 디버그 {:#debug-from-the-terminal}

To attach from the terminal, run `flutter attach`.
To select a specific target device, add `-d <deviceId>`.

```console
$ flutter attach
```

The command should print output resembling the following:

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

To debug your app over Wi-Fi on an iOS or Android device,
use `flutter attach`.

### iOS 기기에서 Wi-Fi를 통한 디버그 {:#debug-over-wi-fi-on-ios-devices}

For an iOS target, complete the follow steps:

1. Verify your device connects to Xcode over Wi-Fi
   as described in the [iOS setup guide][].

1. On your macOS development machine,
   open **Xcode** <span aria-label="and then">></span>
   **Product** <span aria-label="and then">></span>
   **Scheme** <span aria-label="and then">></span>
   **Edit Scheme...**.

   You can also press <kbd>Cmd</kbd> + <kbd><</kbd>.

1. Click **Run**.

1. Click **Arguments**.

1. In **Arguments Passed On Launch**, Click **+**.

   {:type="a"}
   1. If your dev machine uses IPv4, add `--vm-service-host=0.0.0.0`.

   1. If your dev machine uses IPv6, add `--vm-service-host=::0`.

   {% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"development/add-to-app/debugging/wireless-port.png",
   caption:"Arguments Passed On Launch with an IPv4 network added", width:"100%" %}

#### IPv6 네트워크에 있는지 확인하려면 {:#to-determine-if-youre-on-an-ipv6-network}

1. Open **Settings** <span aria-label="and then">></span> **Wi-Fi**.

1. Click on your connected network.

1. Click **Details...**

1. Click **TCP/IP**.

1. Check for an **IPv6 address** section.

   {% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"development/add-to-app/ipv6.png", caption:"WiFi dialog box for macOS System Settings", width:"60%" %}

### Android 기기에서 Wi-Fi를 통한 디버그 {:#debug-over-wi-fi-on-android-devices}

Verify your device connects to Android Studio over Wi-Fi
as described in the [Android setup guide][].

[iOS setup guide]: /get-started/install/macos/mobile-ios
[Android setup guide]: /get-started/install/macos/mobile-android?tab=physical#configure-your-target-android-device
