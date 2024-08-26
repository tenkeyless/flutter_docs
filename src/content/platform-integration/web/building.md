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

To create a Flutter app with web support,
you need the following software:

* Flutter SDK. See the
  [Flutter SDK][] installation instructions.
* [Chrome][]; debugging a web app requires
  the Chrome browser.
* Optional: An IDE that supports Flutter.
  You can install [Visual Studio Code][],
  [Android Studio][], [IntelliJ IDEA][].
  Also [install the Flutter and Dart plugins][]
  to enable language support and tools for refactoring,
  running, debugging, and reloading your web app
  within an editor. See [setting up an editor][]
  for more details.

[Android Studio]: {{site.android-dev}}/studio
[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[Visual Studio Code]: https://code.visualstudio.com/


For more information, see the [web FAQ][].

## 웹 지원으로 새 프로젝트 만들기 {:#create-a-new-project-with-web-support}

You can use the following steps
to create a new project with web support.

### 설정 {:#set-up}

Run the following commands to use the latest version of the Flutter SDK:

```console
$ flutter channel stable
$ flutter upgrade
```

:::warning
Running `flutter channel stable` replaces your current version of Flutter
with the stable version and can take time if your connection is slow.
After this, running `flutter upgrade` upgrades your install to the latest
`stable`.  Returning to another channel (beta or master) requires calling
`flutter channel <channel>` explicitly.
:::

If Chrome is installed,
the `flutter devices` command outputs a `Chrome` device
that opens the Chrome browser with your app running,
and a `Web Server` that provides the URL serving the app.

```console
$ flutter devices
1 connected device:

Chrome (web) • chrome • web-javascript • Google Chrome 88.0.4324.150
```

In your IDE, you should see **Chrome (web)** in the device pulldown.

### 생성하고 실행 {:#create-and-run}

Creating a new project with web support is no different
than [creating a new Flutter project][] for other platforms.

#### IDE {:#ide}

Create a new app in your IDE and it automatically
creates iOS, Android, [desktop][], and web versions of your app.
From the device pulldown, select **Chrome (web)**
and run your app to see it launch in Chrome.

#### 명령줄 {:#command-line}

To create a new app that includes web support
(in addition to mobile support), run the following commands,
substituting `my_app` with the name of your project:

```console
$ flutter create my_app
$ cd my_app
```

To serve your app from `localhost` in Chrome,
enter the following from the top of the package:

```console
$ flutter run -d chrome
```

:::note
If there aren't any other connected devices,
the `-d chrome` is optional.
:::

The `flutter run` command launches the application using the
[development compiler] in a Chrome browser.

:::warning
**Hot reload is not supported in a web browser**
Currently, Flutter supports **hot restart**,
but not **hot reload** in a web browser.
:::

### 빌드 {:#build}

Run the following command to generate a release build:

```console
$ flutter build web
```

If you receive a `not supported` error, run the following command:

```console
$ flutter config --enable-web
```

A release build uses [dart2js][]
(instead of the [development compiler][])
to produce a single JavaScript file `main.dart.js`.
You can create a release build using release mode
(`flutter run --release`) or by using `flutter build web`.
This populates a `build/web` directory
with built files, including an `assets` directory,
which need to be served together.

You can also include `--web-renderer html`  or `--web-renderer canvaskit` to
select between the HTML or CanvasKit renderers, respectively. For more
information, see [Web renderers][].

To learn more, see
[Build and release a web app][].

## 기존 앱에 웹 지원 추가 {:#add-web-support-to-an-existing-app}

To add web support to an existing project
created using a previous version of Flutter,
run the following command
from your project's top-level directory:

```console
$ flutter create --platforms web .
```

If you receive a `not supported` error, run the following command:

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
