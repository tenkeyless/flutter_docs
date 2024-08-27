---
# title: Create useful bug reports
title: 유용한 버그 보고서 작성
# description: >
#   Where to file bug reports and enhancement requests for 
#   flutter and the website.
description: >
  Flutter와 웹사이트에 대한 버그 리포트와 개선 요청을 제출할 수 있는 곳입니다.
---

이 문서의 지침은 충돌 및 기타 잘못된 동작에 대한, 가장 실행 가능한 버그 보고서를 제공하는 데 필요한, 
현재 단계를 자세히 설명합니다. 
각 단계는 선택 사항이지만, 문제를 진단하고 해결하는 속도를 크게 개선할 것입니다. 
가능한 한 많은 피드백을 보내주신 데 감사드립니다.

## GitHub에서 이슈 생성 {:#create-an-issue-on-github}

* Flutter 크래시나 버그를 보고하려면, [flutter/flutter 프로젝트에서 이슈를 만드세요][Flutter issue].
* 웹사이트 문제를 보고하려면, [flutter/website 프로젝트에서 문제를 만드세요][Website issue].

## 최소한의 재현 가능한 코드 샘플 제공 {:#provide-a-minimal-reproducible-code-sample}

문제를 보여주는 최소한의 Flutter 앱을 만들고, GitHub 이슈에 붙여넣습니다.

이를 만들려면 `flutter create bug` 명령을 사용하고, `main.dart` 파일을 업데이트할 수 있습니다.

또는, 작은 Flutter 앱을 만들고, 실행할 수 있는 [DartPad][]를 사용할 수 있습니다.

문제가 단일 파일에 넣을 수 있는 범위를 벗어나는 경우(예: 네이티브 채널에 문제가 있는 경우), 
재현의 전체 코드를 별도의 리포지토리에 업로드하고 링크하세요.

If your problem goes out of what can be placed in a single file, for example you have a problem with native channels, you can upload the full code of the reproduction into a separate repository and link it.

## 약간의 Flutter 진단 제공 {:#provide-some-flutter-diagnostics}

* 프로젝트 디렉토리에서 `flutter doctor -v`를 실행하고 결과를 GitHub 이슈에 붙여넣습니다.

```plaintext
[✓] Flutter (Channel stable, 1.22.3, on Mac OS X 10.15.7 19H2, locale en-US)
    • Flutter version 1.22.3 at /Users/me/projects/flutter
    • Framework revision 8874f21e79 (5 days ago), 2020-10-29 14:14:35 -0700
    • Engine revision a1440ca392
    • Dart version 2.10.3

[✓] Android toolchain - develop for Android devices (Android SDK version 29.0.2)
    • Android SDK at /Users/me/Library/Android/sdk
    • Platform android-30, build-tools 29.0.2
    • Java binary at: /Applications/Android Studio.app/Contents/jre/jdk/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 12.2)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Xcode 12.2, Build version 12B5035g
    • CocoaPods version 1.9.3

[✓] Android Studio (version 4.0)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin version 50.0.1
    • Dart plugin version 193.7547
    • Java version OpenJDK Runtime Environment (build 1.8.0_242-release-1644-b3-6222593)

[✓] VS Code (version 1.50.1)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.13.2

[✓] Connected device (1 available)
    • iPhone (mobile) • 00000000-0000000000000000 • ios • iOS 14.0
```

## verbose 모드에서 명령 실행 {:#run-the-command-in-verbose-mode}

이슈가 `flutter` 도구와 관련된 경우에만 다음 단계를 따르세요.

* 모든 Flutter 명령은 `--verbose` 플래그를 허용합니다. 
  문제에 첨부하면, 이 명령의 출력이 문제를 진단하는 데 도움이 될 수 있습니다.
* 명령의 결과를 GitHub 이슈에 첨부하세요.
![flutter verbose](/assets/images/docs/verbose_flag.png){:width="100%"}

## 최신 로그 제공 {:#provide-the-most-recent-logs}

* 현재 연결된 기기의 로그는 `flutter logs`를 사용하여 액세스합니다.
* 충돌이 재현 가능한 경우, 로그를 지우고(Mac에서는 ⌘ + k), 
  크래시를 재현한 다음, 새로 생성된 로그를 버그 보고서에 첨부된 파일에 복사합니다.
* 프레임워크에서 예외가 발생하는 경우, 첫 번째 예외의 점선과 그 사이의 모든 출력을 포함합니다.
![flutter logs](/assets/images/docs/logs.png){:width="100%"}

## 충돌 보고서 제공 {:#provide-the-crash-report}

* iOS 시뮬레이터가 충돌하면, `~/Library/Logs/DiagnosticReports/`에 충돌 보고서가 생성됩니다.
* iOS 기기가 충돌하면, `~/Library/Logs/CrashReporter/MobileDevice`에 충돌 보고서가 생성됩니다.
* 충돌에 해당하는 보고서(보통 최신 보고서)를 찾아 GitHub 이슈에 첨부합니다.
![crash report](/assets/images/docs/crash_reports.png){:width="100%"}


[DartPad]: {{site.dartpad}}
[Flutter issue]: {{site.repo.flutter}}/issues/new/choose
[Website issue]: {{site.repo.this}}/issues/new/choose
