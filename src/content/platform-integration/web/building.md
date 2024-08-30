---
# title: Building a web application with Flutter
title: Flutter로 웹 애플리케이션 구축
# description: Instructions for creating a Flutter app for the web.
description: 웹용 Flutter 앱을 만드는 방법.
# short-title: Web development
short-title: 웹 개발
---

이 페이지에서는 웹 지원을 시작하기 위한 다음 단계를 다룹니다.

* 웹 지원을 위한 `flutter` 도구 구성.
* 웹 지원이 있는 새 프로젝트 만들기.
* 웹 지원이 있는 새 프로젝트 실행.
* 웹 지원이 있는 앱 빌드.
* 기존 프로젝트에 웹 지원 추가.

## 요구 사항 {:#requirements}

웹 지원이 있는 Flutter 앱을 만들려면, 다음 소프트웨어가 필요합니다.

* Flutter SDK. [Flutter SDK][] 설치 지침을 참조하세요.
* [Chrome][]; 웹 앱을 디버깅하려면 Chrome 브라우저가 필요합니다.
* 선택 사항: Flutter를 지원하는 IDE. 
  [Visual Studio Code][], [Android Studio][], [IntelliJ IDEA][]를 설치할 수 있습니다. 
  또한 [Flutter 및 Dart 플러그인을 설치][install the Flutter and Dart plugins]하여, 
  편집기 내에서 웹 앱을 리팩토링, 실행, 디버깅 및 다시 로드하기 위한 언어 지원 및 도구를 활성화합니다. 
  자세한 내용은 [편집기 설정][setting up an editor]을 참조하세요.

[Android Studio]: {{site.android-dev}}/studio
[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[Visual Studio Code]: https://code.visualstudio.com/

자세한 내용은 [웹 FAQ][web FAQ]를 참조하세요.

## 웹 지원으로 새 프로젝트 만들기 {:#create-a-new-project-with-web-support}

다음 단계에 따라 웹 지원을 포함한 새 프로젝트를 만들 수 있습니다.

### 설정 {:#set-up}

Flutter SDK의 최신 버전을 사용하려면, 다음 명령을 실행하세요.

```console
$ flutter channel stable
$ flutter upgrade
```

:::warning
`flutter channel stable`을 실행하면, 현재 버전의 Flutter가 stable 버전으로 바뀌며, 
연결이 느리면 시간이 걸릴 수 있습니다. 
그 후 `flutter upgrade`를 실행하면, 설치가 최신 `stable`로 업그레이드됩니다. 
다른 채널(베타 또는 마스터)로 돌아가려면, `flutter channel <channel>`을 명시적으로 호출해야 합니다.
:::

Chrome이 설치되어 있는 경우, `flutter devices` 명령은, 
앱을 실행하는 Chrome 브라우저를 여는 `Chrome` 장치와 
앱을 제공하는 URL을 제공하는 `Web Server`를 출력합니다.

```console
$ flutter devices
1 connected device:

Chrome (web) • chrome • web-javascript • Google Chrome 88.0.4324.150
```

IDE에서 장치 풀다운 메뉴에 **Chrome(web)**이 표시되어야 합니다.

### 생성하고 실행 {:#create-and-run}

웹 지원을 사용하여 새 프로젝트를 만드는 것은 다른 플랫폼에서 [새 Flutter 프로젝트를 만드는 것][creating a new Flutter project]과 다르지 않습니다.

#### IDE {:#ide}

IDE에서 새 앱을 만들면, 자동으로 앱의 iOS, Android, [데스크톱][desktop] 및 웹 버전이 생성됩니다. 
기기 풀다운에서 **Chrome (web)**을 선택하고, 앱을 실행하면 Chrome에서 실행되는 것을 확인할 수 있습니다.

#### 명령줄 {:#command-line}

모바일 지원 외에 웹 지원이 포함된 새 앱을 만들려면 다음 명령을 실행하고, `my_app`을 프로젝트 이름으로 바꿉니다.

```console
$ flutter create my_app
$ cd my_app
```

Chrome의 `localhost`에서 앱을 제공하려면, 패키지 맨 위에 다음을 입력하세요.

```console
$ flutter run -d chrome
```

:::note
다른 연결된 장치가 없으면, `-d chrome`은 선택 사항입니다.
:::

`flutter run` 명령은 Chrome 브라우저에서 [개발 컴파일러][development compiler]를 사용하여 애플리케이션을 시작합니다.

:::warning
**웹 브라우저에서는 핫 리로드가 지원되지 않습니다.** 
현재 Flutter는 **핫 재시작**을 지원하지만, 
웹 브라우저에서는 **핫 리로드**를 지원하지 않습니다.
:::

### 빌드 {:#build}

다음 명령을 실행하여 릴리스 빌드를 생성하세요.

```console
$ flutter build web
```

`not supported` 오류가 표시되면 다음 명령을 실행하세요.

```console
$ flutter config --enable-web
```

릴리스 빌드는 [dart2js][]([개발 컴파일러][development compiler] 대신)를 사용하여, 
단일 JavaScript 파일 `main.dart.js`를 생성합니다. 
릴리스 모드(`flutter run --release`)를 사용하거나, 
`flutter build web`을 사용하여 릴리스 빌드를 만들 수 있습니다. 
이렇게 하면 `build/web` 디렉터리가 빌드된 파일로 채워지며, 
여기에는 `assets` 디렉터리도 포함되며, 함께 제공해야 합니다.

Flutter web은 여러 빌드 모드와 렌더러를 제공합니다. 자세한 내용은 [웹 렌더러][Web renderers]를 참조하세요.

자세한 내용은 [웹 앱 빌드 및 릴리스][Build and release a web app]를 참조하세요.

## 기존 앱에 웹 지원 추가 {:#add-web-support-to-an-existing-app}

이전 버전의 Flutter를 사용하여 만든 기존 프로젝트에 웹 지원을 추가하려면, 
프로젝트의 최상위 디렉토리에서 다음 명령을 실행하세요.

```console
$ flutter create --platforms web .
```

`not supported` 오류가 표시되면 다음 명령을 실행하세요.

```console
$ flutter config --enable-web
```

[Build and release a web app]: /deployment/web
[creating a new Flutter project]: /get-started/test-drive
[dart2js]: {{site.dart-site}}/tools/dart2js
[desktop]: /platform-integration/desktop
[development compiler]: {{site.dart-site}}/tools/dartdevc
[file an issue]: {{site.repo.flutter}}/issues/new?title=[web]:+%3Cdescribe+issue+here%3E&labels=%E2%98%B8+platform-web&body=Describe+your+issue+and+include+the+command+you%27re+running,+flutter_web%20version,+browser+version
[install the Flutter and Dart plugins]: /get-started/editor
[setting up an editor]: /get-started/editor
[web FAQ]: /platform-integration/web/faq
[Chrome]: https://www.google.com/chrome/
[Flutter SDK]: /get-started/install
[Web renderers]: /platform-integration/web/renderers
