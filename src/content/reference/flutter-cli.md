---
# title: "flutter: The Flutter command-line tool"
title: "flutter: Flutter 명령줄 도구"
# description: "The reference page for using 'flutter' in a terminal window."
description: "터미널 창에서 'flutter'를 사용하는 방법에 대한 참조 페이지입니다."
---

`flutter` 명령줄 도구는 개발자(또는 개발자를 대신하는 IDE)가 Flutter와 상호 작용하는 방식입니다. 
Dart 관련 명령의 경우, [`dart`][] 명령줄 도구를 사용할 수 있습니다.

`flutter` 도구를 사용하여 앱을 만들고, 분석하고, 테스트하고, 실행하는 방법은 다음과 같습니다.

```console
$ flutter create my_app
$ cd my_app
$ flutter analyze
$ flutter test
$ flutter run lib/main.dart
```

`flutter` 도구를 사용하여 [`pub`][`dart pub`] 명령을 실행하려면:

```console
$ flutter pub get
$ flutter pub outdated
$ flutter pub upgrade
```

`flutter`가 지원하는 모든 명령을 보려면:

```console
$ flutter --help --verbose
```

프레임워크, 엔진, 도구를 포함한 Flutter SDK의 현재 버전을 받으려면:

```console
$ flutter --version
```

## `flutter` 명령 {:#flutter-commands}

다음 표는 `flutter` 도구와 함께 사용할 수 있는 명령을 보여줍니다.

| 명령         | 사용 예시                                 | 더 많은 정보                                                                  |
|-----------------|------------------------------------------------|-----------------------------------------------------------------------------------|
| analyze         | `flutter analyze -d <DEVICE_ID>`               | 프로젝트의 Dart 소스 코드를 분석합니다. <br> [`dart analyze`][] 대신 사용하세요.    |
| assemble        | `flutter assemble -o <DIRECTORY>`              | Flutter 리소스를 조립(Assemble)하고 빌드합니다. |
| attach          | `flutter attach -d <DEVICE_ID>`                | 실행 중인 애플리케이션에 연결(Attach)합니다.                                           |
| bash-completion | `flutter bash-completion`                      | 출력 명령줄 셸 완성 설정 스크립트입니다.                                |
| build           | `flutter build <DIRECTORY>`                    | Flutter 빌드 명령. |
| channel         | `flutter channel <CHANNEL_NAME>`               | Flutter 채널을 나열하거나 전환합니다.                                         |
| clean           | `flutter clean`                                | `build/` 및 `.dart_tool/` 디렉토리를 삭제합니다.                                |
| config          | `flutter config --build-dir=<DIRECTORY>`       | Flutter 설정을 구성합니다. 설정을 제거하려면 빈 문자열로 구성합니다.  |
| create          | `flutter create <DIRECTORY>`                   | 새로운 프로젝트를 만듭니다.                                                            |
| custom-devices  | `flutter custom-devices list`                  | 커스텀 장치를 추가, 삭제, 나열 및 재설정합니다.                              |
| devices         | `flutter devices -d <DEVICE_ID>`               | 연결된 모든 장치를 나열합니다.                                                       |
| doctor          | `flutter doctor`                               | 설치된 도구에 대한 정보를 표시합니다.                                     |
| downgrade       | `flutter downgrade`                            | 현재 채널의 마지막 활성 버전으로 Flutter를 다운그레이드합니다.             |
| drive           | `flutter drive`                                | 현재 프로젝트에 대해 Flutter Driver 테스트를 실행합니다.                               |
| emulators       | `flutter emulators`                            | 에뮬레이터를 나열하고 실행하고 생성합니다.                                               |
| gen-l10n        | `flutter gen-l10n <DIRECTORY>`                 | Flutter 프로젝트에 대한 현지화(localizations)를 생성합니다.                             |
| install         | `flutter install -d <DEVICE_ID>`               | 연결된 기기에 Flutter 앱을 설치합니다.                                      |
| logs            | `flutter logs`                                 | Flutter 앱 실행에 대한 로그 출력을 표시합니다.                     |
| precache        | `flutter precache <ARGUMENTS>`                 | Flutter 도구의 바이너리 아티팩트 캐시를 채웁니다.          |
| pub             | `flutter pub <PUB_COMMAND>`                    | 패키지와 함께 작동합니다.<br> [`dart pub`][] 대신 사용하세요.        |
| run             | `flutter run <DART_FILE>`                      | Flutter 프로그램을 실행합니다.                                              |
| screenshot      | `flutter screenshot`                           | 연결된 기기에서 Flutter 앱의 스크린샷을 찍습니다.     |
| symbolize       | `flutter symbolize --input=<STACK_TRACK_FILE>` | AOT로 컴파일된 Flutter 애플리케이션의 스택 추적을 상징합니다.                |
| test            | `flutter test [<DIRECTORYDART_FILE>]`          | 이 패키지에서 테스트를 실행합니다.<br>[`dart test`][`dart test`] 대신 사용하세요.        |
| upgrade         | `flutter upgrade`                              | Flutter를 업그레이드하세요.                                                     |

{:.table .table-striped .nowrap}

명령에 대한 추가 도움말을 보려면, `flutter help <command>`를 입력하거나, 
**자세한 정보** 열의 링크를 따르세요. 
`pub` 명령에 대한 세부 정보도 얻을 수 있습니다. (예: `flutter help pub outdated`)

[`dart`]: {{site.dart-site}}/tools/dart-tool
[`dart analyze`]: {{site.dart-site}}/tools/dart-analyze
[`dart format`]: {{site.dart-site}}/tools/dart-format
[`dart pub`]: {{site.dart-site}}/tools/dart-pub
[`dart test`]: {{site.dart-site}}/tools/dart-test
