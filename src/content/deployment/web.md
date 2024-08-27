---
# title: Build and release a web app
title: 웹 앱 빌드 및 릴리스
# description: How to prepare for and release a web app.
description: 웹 앱을 준비하고 출시하는 방법.
# short-title: Web
short-title: 웹
---

일반적인 개발 주기 동안, 명령줄에서 `flutter run -d chrome`(예시)을 사용하여 앱을 테스트합니다. 
이렇게 하면, 앱의 _debug_ 버전이 빌드됩니다.

이 페이지에서는 앱의 _release_ 버전을 준비하는 데 도움이 되며 다음 주제를 다룹니다.

* [릴리스를 위한 앱 빌드](#building-the-app-for-release)
* [웹에 배포](#deploying-to-the-web)
* [Firebase Hosting 호스팅에 배포](#deploying-to-firebase-hosting)
* [웹에서 이미지 처리](#handling-images-on-the-web)
* [빌드 모드 및 렌더러 선택](#choosing-a-build-mode-and-a-renderer)
* [최소화(Minification)](#minification)

## 릴리스를 위한 앱 빌드 {:#building-the-app-for-release}

`flutter build web` 명령을 사용하여 배포용 앱을 빌드합니다. 
이렇게 하면 assets을 포함한 앱이 생성되고, 해당 파일이 프로젝트의 `/build/web` 디렉터리에 저장됩니다.

간단한 앱의 릴리스 빌드는 다음과 같은 구조를 갖습니다.

```plaintext
/build/web
  assets
    AssetManifest.json
    FontManifest.json
    NOTICES
    fonts
      MaterialIcons-Regular.ttf
      <other font files>
    <image files>
    packages
      cupertino_icons
        assets
          CupertinoIcons.ttf
    shaders
      ink_sparkle.frag
  canvaskit
    canvaskit.js
    canvaskit.wasm
    <other files>
  favicon.png
  flutter.js
  flutter_service_worker.js
  index.html
  main.dart.js
  manifest.json
  version.json
```

<!-- :::note
`canvaskit` 디렉토리와 그 내용은 CanvasKit 렌더러가 선택된 경우에만 존재하며, 
HTML 렌더러가 선택된 경우에는 존재하지 않습니다.
::: -->

웹 서버를 시작하고(예: `python -m http.server 8000` 또는 [dhttpd][] 패키지 사용), 
/build/web 디렉토리를 엽니다. 
브라우저에서 `localhost:8000`으로 이동하여(python SimpleHTTPServer 예제의 경우), 앱의 릴리스 버전을 확인하세요.

## 웹에 배포 {:#deploying-to-the-web}

앱을 배포할 준비가 되면, 릴리스 번들을 Firebase, 클라우드 또는 유사한 서비스에 업로드합니다. 
다음은 몇 가지 가능성이지만, 그 외에도 많은 가능성이 있습니다.

* [Firebase 호스팅][Firebase Hosting]
* [GitHub 페이지][GitHub Pages]
* [Google 클라우드 호스팅][Google Cloud Hosting]

## Firebase Hosting 호스팅에 배포 {:#deploying-to-firebase-hosting}

Firebase 호스팅으로 Firebase CLI를 사용하여 Flutter 앱을 빌드하고 릴리스할 수 있습니다.

### 시작하기 전에 {:#before-you-begin}

시작하려면, Firebase CLI를 [설치 또는 업데이트][install-firebase-cli]하세요.

```console
npm install -g firebase-tools
```

### Firebase 초기화 {:#initialize-firebase}

1. [Firebase 프레임워크 인식 CLI][Firebase framework-aware CLI]에 웹 프레임워크 미리 보기를 활성화합니다.:

    ```console
    firebase experiments:enable webframeworks
    ```

2. 빈 디렉토리나 기존 Flutter 프로젝트에서, 초기화 명령을 실행합니다.:

    ```console
    firebase init hosting
    ```

1. 웹 프레임워크를 사용할지 묻는 질문에 `yes`라고 대답합니다.

2. 빈 디렉토리에 있는 경우, 웹 프레임워크를 선택하라는 메시지가 표시됩니다. `Flutter Web`을 선택합니다.

3. 호스팅 소스 디렉토리를 선택합니다. 기존 Flutter 앱일 수 있습니다.

4. 파일을 호스팅할 지역(region)을 선택합니다.

5. GitHub에서 자동 빌드 및 배포를 설정할지 여부를 선택합니다.

6. Firebase Hosting에 앱 배포:

    ```console
    firebase deploy
    ```

    이 명령을 실행하면, `flutter build web --release`가 자동으로 실행되므로, 
    별도의 단계에서 앱을 빌드할 필요가 없습니다.

자세한 내용은 웹에서 Flutter에 대한 공식 [Firebase Hosting][] 문서를 참조하세요.

## 웹에서 이미지 처리 {:#handling-images-on-the-web}

웹은 이미지를 표시하기 위한 표준 `Image` 위젯을 지원합니다. 
설계상, 웹 브라우저는 호스트 컴퓨터에 해를 끼치지 않고, 신뢰할 수 없는 코드를 실행합니다. 
이는 모바일 및 데스크톱 플랫폼에 비해 이미지로 할 수 있는 작업을 제한합니다.

자세한 내용은 [웹에서 이미지 표시][Displaying images on the web]를 참조하세요.

## 빌드 모드 및 렌더러 선택 {:choosing-a-build-mode-and-a-renderer}

Flutter 웹은 두 가지 빌드 모드(default와 WebAssembly)와, 두 가지 렌더러(`canvaskit`과 `skwasm`)를 제공합니다.

자세한 내용은 [웹 렌더러][Web renderers]를 참조하세요.

## 최소화(Minification) {:#minification}

앱 시작을 개선하기 위해 컴파일러는 사용하지 않는 코드(_트리 셰이킹_ 이라고 함)를 제거하고, 
코드 심볼의 이름을 더 짧은 문자열로 변경하여(예: `AlignmentGeometryTween`을 `ab`와 비슷한 이름으로 변경), 
컴파일된 코드의 크기를 줄입니다. 
이 두 가지 최적화 중 어느 것이 적용되는지는 빌드 모드에 따라 달라집니다.

| 웹 앱 빌드 타입 | 코드가 최소화되나요? | 트리 쉐이킹이 수행되나요? |
|-----------------------|----------------|-------------------------|
| debug | 아니요 | 아니요 |
| profile | 아니요 | 예 |
| release | 예 | 예 |

{:.table .table-striped}

## HTML 페이지에 Flutter 앱 임베딩하기 {:#embedding-a-flutter-app-into-an-html-page}

[Flutter 웹 임베딩][Embedding Flutter web]을 참조하세요.

[Embedding Flutter web]: /platform-integration/web/embedding-flutter-web

## PWA 지원 {:#pwa-support}

릴리스 1.20부터, 웹 앱용 Flutter 템플릿에는 설치 가능하고, 오프라인이 가능한 PWA 앱에 필요한, 핵심 기능에 대한 지원이 포함됩니다. 
Flutter 기반 PWA는 다른 웹 기반 PWA와 같은 방식으로 설치할 수 있습니다. 
Flutter 앱이 PWA임을 나타내는 설정은 `manifest.json`에서 제공하는데, 
이 설정은 `web` 디렉터리의 `flutter create`에서 생성됩니다.

PWA 지원은 진행 중인 작업입니다. 예상대로 작동하지 않는 것이 보이면 [피드백을 보내주세요][give us feedback].

[dhttpd]: {{site.pub}}/packages/dhttpd
[Displaying images on the web]: /platform-integration/web/web-images
[Firebase Hosting]: {{site.firebase}}/docs/hosting/frameworks/flutter
[Firebase framework-aware CLI]: {{site.firebase}}/docs/hosting/frameworks/frameworks-overview
[install-firebase-cli]: {{site.firebase}}/docs/cli#install_the_firebase_cli
[GitHub Pages]: https://pages.github.com/
[give us feedback]: {{site.repo.flutter}}/issues/new?title=%5Bweb%5D:+%3Cdescribe+issue+here%3E&labels=%E2%98%B8+platform-web&body=Describe+your+issue+and+include+the+command+you%27re+running,+flutter_web%20version,+browser+version
[Google Cloud Hosting]: https://cloud.google.com/solutions/web-hosting
[Web renderers]: /platform-integration/web/renderers
