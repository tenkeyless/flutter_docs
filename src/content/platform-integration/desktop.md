---
# title: Desktop support for Flutter
title: Flutter에 대한 데스크톱 지원
# description: General information about Flutter support for desktop apps.
description: 데스크톱 앱에 대한 Flutter 지원에 대한 일반 정보입니다.
---

Flutter는 네이티브 Windows, macOS 또는 Linux 데스크톱 앱을 컴파일하는 데 대한 지원을 제공합니다. 
Flutter의 데스크톱 지원은 플러그인까지 확장됩니다. 
Windows, macOS 또는 Linux 플랫폼을 지원하는 기존 플러그인을 설치하거나 직접 만들 수 있습니다.

:::note
이 페이지에서는 모든 데스크톱 플랫폼에 대한 앱 개발에 대해 다룹니다. 
이 글을 다 읽고 나면, 다음 링크에서 특정 플랫폼 정보를 자세히 알아볼 수 있습니다.

* [Flutter로 Windows 앱 빌드][Building Windows apps with Flutter]
* [Flutter로 macOS 앱 빌드][Building macOS apps with Flutter]
* [Flutter로 Linux 앱 빌드][Building Linux apps with Flutter]
:::

[Building Windows apps with Flutter]: /platform-integration/windows/building
[Building macOS apps with Flutter]: /platform-integration/macos/building
[Building Linux apps with Flutter]: /platform-integration/linux/building

## 새로운 프로젝트 생성 {:#create-a-new-project}

다음 단계에 따라 데스크톱 지원으로 새 프로젝트를 만들 수 있습니다.

### 데스크탑 DevTools 설정 {:#set-up-desktop-devtools}

대상 데스크톱 환경에 대한 가이드를 참조하세요.

* [Linux 데스크톱 devtools 설치][Linux-devtools]
* [macOS 데스크톱 devtools 설치][macOS-devtools]
* [Windows 데스크톱 devtools 설치][Windows-devtools]

[Linux-devtools]: /get-started/install/linux/desktop
[macOS-devtools]: /get-started/install/macos/desktop
[Windows-devtools]: /get-started/install/windows/desktop

`flutter doctor`가 개발하고 싶지 않은 플랫폼에 대한 문제나 누락된 구성 요소를 발견하면, 해당 경고를 무시할 수 있습니다. 
또는 `flutter config` 명령을 사용하여 플랫폼을 완전히 비활성화할 수 있습니다. 예:

```console
$ flutter config --no-enable-ios
```

사용 가능한 다른 플래그:

* `--no-enable-windows-desktop`
* `--no-enable-linux-desktop`
* `--no-enable-macos-desktop`
* `--no-enable-web`
* `--no-enable-android`
* `--no-enable-ios`

데스크톱 지원을 활성화한 후, IDE를 다시 시작하여 새 장치를 감지할 수 있도록 합니다.

### 생성 및 실행 {:#create-and-run}

데스크톱 지원으로 새 프로젝트를 만드는 것은 다른 플랫폼의 [새 Flutter 프로젝트 만들기][creating a new Flutter project]와 다르지 않습니다.

데스크톱 지원을 위한 환경을 구성한 후에는, IDE나 명령줄에서 데스크톱 애플리케이션을 만들고 실행할 수 있습니다.

[creating a new Flutter project]: /get-started/test-drive

#### IDE 사용 {:#using-an-ide}

데스크톱을 지원하도록 환경을 구성한 후, IDE가 이미 실행 중이었다면, IDE를 다시 시작해야 합니다.

IDE에서 새 애플리케이션을 만들면 자동으로 앱의 iOS, Android, 웹 및 데스크톱 버전이 생성됩니다. 
장치 풀다운(pulldown)에서, **windows(데스크톱)**, **macOS(데스크톱)** 또는 **linux(데스크톱)** 를 선택하고, 
애플리케이션을 실행하면 데스크톱에서 실행되는지 확인할 수 있습니다.

#### 명령줄로부터 {:#from-the-command-line}

데스크톱 지원(모바일 및 웹 지원 포함)을 포함하는 새 애플리케이션을 만들려면 다음 명령을 실행하고, 
`my_app`을 프로젝트 이름으로 바꿉니다.

```console
$ flutter create my_app
$ cd my_app
```

명령줄에서 애플리케이션을 시작하려면, 패키지 상단에서 다음 명령 중 하나를 입력하세요.

```console
C:\> flutter run -d windows
$ flutter run -d macos
$ flutter run -d linux
```

:::note
`-d` 플래그를 제공하지 않으면, `flutter run`은 선택할 수 있는 사용 가능한 대상을 나열합니다.
:::

## 릴리스 앱 빌드 {:#build-a-release-app}

릴리스 빌드를 생성하려면, 다음 명령 중 하나를 실행하세요.

```console
PS C:\> flutter build windows
$ flutter build macos
$ flutter build linux
```

## 기존 Flutter 앱에 데스크톱 지원 추가 {:#add-desktop-support-to-an-existing-flutter-app}

기존 Flutter 프로젝트에 데스크톱 지원을 추가하려면, 
루트 프로젝트 디렉토리에서 터미널에서 다음 명령을 실행합니다.

```console
$ flutter create --platforms=windows,macos,linux .
```

이렇게 하면 기존 Flutter 프로젝트에 필요한 데스크톱 파일과 디렉토리가 추가됩니다. 
특정 데스크톱 플랫폼만 추가하려면, `platforms` 리스트를 변경하여 추가하려는 플랫폼만 포함시킵니다.

## 플러그인 지원 {:#plugin-support}

데스크톱의 Flutter는 플러그인 사용 및 생성을 지원합니다. 
데스크톱을 지원하는 플러그인을 사용하려면, [패키지 사용][using packages]의 플러그인 단계를 따르세요. 
Flutter는 다른 플랫폼과 마찬가지로, 프로젝트에 필요한 네이티브 코드를 자동으로 추가합니다.

### 플러그인 작성하기 {:#writing-a-plugin}

플러그인을 직접 빌드하기 시작할 때는, 페더레이션(federation, 연합)을 염두에 두어야 합니다. 
페더레이션은 개발자가 사용하기 쉽도록, 
각각 다른 플랫폼 세트를 대상으로 하는 여러 패키지를 정의하여, 단일 플러그인으로 통합하는 기능입니다. 
예를 들어, `url_launcher`의 Windows 구현은 실제로 `url_launcher_windows`이지만, 
Flutter 개발자는 `url_launcher` 패키지를 종속성으로 `pubspec.yaml`에 추가하기만 하면, 
빌드 프로세스에서 대상 플랫폼에 따라 올바른 구현을 가져옵니다. 
페더레이션은 서로 다른 전문 지식을 가진 여러 팀이 서로 다른 플랫폼에 대한 플러그인 구현을 빌드할 수 있기 때문에 편리합니다. 
원본 플러그인 작성자와 이러한 작업을 조정하는 한, pub.dev에서 승인된 페더레이션 플러그인에 새 플랫폼 구현을 추가할 수 있습니다.

승인된 플러그인에 대한 정보를 포함한 자세한 내용은, 다음 리소스를 참조하세요.

* [패키지 및 플러그인 개발][Developing packages and plugins], 특히 [연합된(Federated) 플러그인][Federated plugins] 섹션.
* [Flutter 웹 플러그인 작성 방법, 2부][How to write a Flutter web plugin, part 2]는, 
  페더레이션 플러그인의 구조를 다루고, 데스크톱 플러그인에 적용 가능한 정보를 포함합니다.
* [최신 Flutter 플러그인 개발][Modern Flutter Plugin Development]은 Flutter 플러그인 지원에 대한 최근 개선 사항을 다룹니다.

[using packages]: /packages-and-plugins/using-packages
[Developing packages and plugins]: /packages-and-plugins/developing-packages
[Federated plugins]: /packages-and-plugins/developing-packages#federated-plugins
[How to write a Flutter web plugin, part 2]: {{site.flutter-medium}}/how-to-write-a-flutter-web-plugin-part-2-afdddb69ece6
[Modern Flutter Plugin Development]: {{site.flutter-medium}}/modern-flutter-plugin-development-4c3ee015cf5a

## 샘플 및 코드랩 {:#samples-and-codelabs}

[Flutter 데스크톱 애플리케이션 작성][Write a Flutter desktop application]
: GitHub GraphQL API를 당신의 Flutter 앱과 통합하는 데스크톱 애플리케이션을 빌드하는 과정을 안내하는 코드랩입니다.

다음 샘플을 데스크톱 앱으로 실행할 수 있으며, 
소스 코드를 다운로드하여 검사하여 Flutter 데스크톱 지원에 대해 자세히 알아볼 수 있습니다.

Wonderous 앱 [실행 중인 앱][wonderous-app], [repo][wonderous-repo]
: Flutter를 사용하여 매우 표현력이 뛰어난 사용자 인터페이스를 만드는 쇼케이스 앱입니다. 
  Wonderous는 매력적인 상호 작용과 새로운 애니메이션을 포함하면서, 
  접근성(accessible) 있고 고품질의 사용자 경험을 제공하는 데 중점을 둡니다. 
  Wonderous를 데스크톱 앱으로 실행하려면 프로젝트를 복제하고, 
  [README][wonderous-readme]에 제공된 지침을 따르세요.

Flokk [공지 블로그 게시물][gskinner-flokk-blogpost], [repo][gskinner-flokk-repo]
: GitHub 및 Twitter와 통합되는 Google 연락처 관리자입니다. 
  Google 계정과 동기화하고, 연락처를 가져오고, 관리할 수 있습니다.

[사진 검색 앱][Photo Search app]
: 데스크톱 지원 플러그인을 사용하는 데스크톱 애플리케이션으로 빌드된 샘플 애플리케이션입니다.

[wonderous-app]: {{site.wonderous}}/web
[wonderous-repo]: {{site.repo.wonderous}}
[wonderous-readme]: {{site.repo.wonderous}}#wonderous
[Photo Search app]: {{site.repo.samples}}/tree/main/desktop_photo_search
[gskinner-flokk-repo]: {{site.github}}/gskinnerTeam/flokk
[gskinner-flokk-blogpost]: https://blog.gskinner.com/archives/2020/09/flokk-how-we-built-a-desktop-app-using-flutter.html
[Write a Flutter desktop application]: {{site.codelabs}}/codelabs/flutter-github-client
