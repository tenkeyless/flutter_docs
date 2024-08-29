---
# title: Building Windows apps with Flutter
title: Flutter로 Windows 앱 빌드
# description: Platform-specific considerations for building for Windows with Flutter.
description: Flutter를 사용하여 Windows를 위해 빌드할 때 플랫폼별 고려 사항.
toc: true
# short-title: Windows development
short-title: Windows 개발
---

이 페이지에서는 Windows에서 Microsoft Store를 통한 Windows 앱의 셸 통합 및 배포를 포함하여, 
Flutter를 사용하여 Windows 앱을 빌드하는 데 고유한 고려 사항에 대해 설명합니다.

## Windows와 통합 {:#integrating-with-windows}

Windows 프로그래밍 인터페이스는 기존 Win32 API, 
COM 인터페이스 및 최신 Windows Runtime 라이브러리를 결합합니다. 
이 모든 것이 C 기반 ABI를 제공하므로, 
Dart의 Foreign Function Interface 라이브러리(`dart:ffi`)를 사용하여, 
운영 체제에서 제공하는 서비스를 호출할 수 있습니다. 
FFI는 Dart 프로그램이 C 라이브러리를 효율적으로 호출할 수 있도록 설계되었습니다. 
Flutter 앱에 `malloc` 또는 `calloc`을 사용하여 네이티브 메모리를 할당하고, 
포인터, 구조체 및 콜백을 지원하고, `long` 및 `size_t`와 같은 ABI 타입을 제공합니다.

Flutter에서 C 라이브러리를 호출하는 방법에 대한 자세한 내용은 [`dart:ffi`를 사용한 C 상호 운용성][C interop using `dart:ffi`]을 참조하세요.

실제로, 이런 방식으로 Dart에서 기본 Win32 API를 호출하는 것은 비교적 간단하지만, 
COM 프로그래밍 모델의 복잡성을 추상화하는 래퍼 라이브러리를 사용하는 것이 더 쉽습니다. 
[win32 패키지][win32 package]는 일관성과 정확성을 위해, 
Microsoft에서 제공하는 메타데이터를 사용하여, 
수천 개의 일반적인 Windows API에 액세스하기 위한 라이브러리를 제공합니다. 
이 패키지에는 WMI, 디스크 관리, 셸 통합, 시스템 대화 상자와 같은, 
다양한 일반적인 사용 사례의 예도 포함되어 있습니다.

이 기반을 기반으로 구축된 다른 여러 패키지는 [Windows 레지스트리][Windows registry], [게임패드 지원][gamepad support], [생체 인식 스토리지][biometric storage], [작업 표시줄 통합][taskbar integration], [직렬 포트 액세스][serial port access] 등에 대한 관용적인 Dart 액세스를 제공합니다.

보다 일반적으로 [`url_launcher`], [`shared_preferences`], [`file_selector`], [`path_provider`]와 같은 일반적인 패키지를 포함하여 다른 많은 [패키지가 Windows를 지원합니다][packages support Windows].

[C interop using `dart:ffi`]: {{site.dart-site}}/guides/libraries/c-interop
[win32 package]: {{site.pub}}/packages/win32
[Windows registry]: {{site.pub}}/packages/win32_registry
[gamepad support]: {{site.pub}}/packages/win32_gamepad
[biometric storage]: {{site.pub}}/packages/biometric_storage
[taskbar integration]: {{site.pub}}//packages/windows_taskbar
[serial port access]: {{site.pub}}/packages/serial_port_win32
[packages support Windows]: {{site.pub}}/packages?q=platform%3Awindows
[`url_launcher`]: {{site.pub-pkg}}/url_launcher
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[`file_selector`]: {{site.pub-pkg}}/file_selector
[`path_provider`]: {{site.pub-pkg}}/path_provider

## Windows UI 가이드라인 지원 {:#supporting-windows-ui-guidelines}

Material을 포함하여 원하는 시각적 스타일이나 테마를 사용할 수 있지만, 
일부 앱 작성자는 Microsoft의 [Fluent 디자인 시스템][Fluent design system] 규칙과 일치하는 앱을 빌드하고자 할 수 있습니다. 
[fluent_ui][] 패키지는 [Flutter Favorite][]로, 탐색 보기, 콘텐츠 대화 상자, 플라이아웃, 
날짜 선택기, 트리 보기 위젯을 포함하여, 최신 Windows 앱에서 일반적으로 발견되는 시각적 요소와 일반적인 컨트롤을 지원합니다.

또한 Microsoft는 Flutter 앱에서 사용할 수 있는, 
수천 개의 Fluent 아이콘에 쉽게 액세스할 수 있는 패키지인, 
[fluentui_system_icons][]를 제공합니다.

마지막으로, [bitsdojo_window][] 패키지는 "소유자 그리기" 제목 표시줄을 지원하여, 
표준 Windows 제목 표시줄을 앱의 나머지 부분과 일치하는 커스텀 제목 표시줄로 바꿀 수 있습니다.

[Fluent design system]: https://docs.microsoft.com/en-us/windows/apps/design/
[fluent_ui]: {{site.pub}}/packages/fluent_ui
[Flutter Favorite]: /packages-and-plugins/favorites
[fluentui_system_icons]: {{site.pub}}/packages/fluentui_system_icons
[bitsdojo_window]: {{site.pub}}/packages/bitsdojo_window

## Windows 호스트 애플리케이션 커스터마이즈 {:#customizing-the-windows-host-application}

Windows 앱을 만들면, Flutter는 Flutter를 호스팅하는 작은 C++ 애플리케이션을 생성합니다. 
이 "러너 앱"은 기존 Win32 창을 만들고 크기를 조정하고, 
Flutter 엔진과 모든 네이티브 플러그인을 초기화하고, 
Windows 메시지 루프를 실행(추가 처리를 위해 관련 메시지를 Flutter로 전달)하는 역할을 합니다.

물론, 앱 이름과 아이콘을 수정하고, 창의 초기 크기와 위치를 설정하는 등, 
필요에 맞게 이 코드를 변경할 수 있습니다. 
관련 코드는 main.cpp에 있으며, 다음과 유사한 코드를 찾을 수 있습니다.

```cpp
Win32Window::Point origin(10, 10);
Win32Window::Size size(1280, 720);
if (!window.CreateAndShow(L"myapp", origin, size))
{
    return EXIT_FAILURE;
}
```

`myapp`을 Windows 캡션 바에 표시하려는 제목으로 바꾸고, 선택적으로 크기와 창 좌표의 차원을 조정합니다.

Windows 애플리케이션 아이콘을 변경하려면, 
`windows\runner\resources` 디렉터리의 `app_icon.ico` 파일을 원하는 아이콘으로 바꾸세요.

생성된 Windows 실행 파일 이름은, 
`windows/CMakeLists.txt`의 `BINARY_NAME` 변수를 편집하여 변경할 수 있습니다.

```cmake
cmake_minimum_required(VERSION 3.14)
project(windows_desktop_app LANGUAGES CXX)

# 애플리케이션을 위해 생성된 실행 파일의 이름입니다.
# 이것을 변경하여 애플리케이션의 on-disk 이름을 변경합니다.
set(BINARY_NAME "YourNewApp")

cmake_policy(SET CMP0063 NEW)
```

`flutter build windows`를 실행하면, 
`build\windows\runner\Release` 디렉토리에 생성된 실행 파일이 새로 지정된 이름과 일치합니다.

마지막으로, 앱 실행 파일 자체에 대한 추가 속성은 
`windows\runner` 디렉토리의 `Runner.rc` 파일에서 찾을 수 있습니다. 
여기서 Windows 앱에 포함된 저작권 정보와 애플리케이션 버전을 변경할 수 있으며, 
이는 Windows Explorer 속성 대화 상자에 표시됩니다. 
버전 번호를 변경하려면 `VERSION_AS_NUMBER` 및 `VERSION_AS_STRING` 속성을 편집합니다. 
다른 정보는 `StringFileInfo` 블록에서 편집할 수 있습니다.

## Visual Studio로 컴파일하기 {:#compiling-with-visual-studio}

대부분 앱의 경우, `flutter run` 및 `flutter build` 명령을 사용하여, 
Flutter가 컴파일 프로세스를 처리하도록 허용하는 것으로 충분합니다. 
러너 앱을 크게 변경하거나 Flutter를 기존 앱에 통합하는 경우, 
Visual Studio 자체에서 Flutter 앱을 로드하거나 컴파일할 수 있습니다.

다음 단계를 따르세요.

1. `flutter build windows`를 실행하여 `build\` 디렉터리를 만듭니다.

1. Windows 러너용 Visual Studio 솔루션 파일을 엽니다. 
   이 파일은 이제 `build\windows` 디렉터리에서 찾을 수 있으며, 
   부모 Flutter 앱에 따라 이름이 지정됩니다.

3. 솔루션 탐색기에서 여러 프로젝트를 볼 수 있습니다. 
   Flutter 앱과 이름이 같은 프로젝트를 마우스 오른쪽 버튼으로 클릭하고, 
   **Set as Startup Project**을 선택합니다.

4. 필요한 종속성을 생성하려면, **Build** > **Build Solution**를 실행합니다.

   <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd>를 누를 수도 있습니다.

   Visual Studio에서 Windows 앱을 실행하려면, **Debug** > **Start Debugging**으로 이동합니다.

   <kbd>F5</kbd>를 누를 수도 있습니다.

1. 도구 모음을 사용하여, 필요에 따라 디버그 및 릴리스 구성 간에 전환합니다.

## Windows 앱 배포 {:#distributing-windows-apps}

Windows 애플리케이션을 배포하는 데 사용할 수 있는 다양한 접근 방식이 있습니다. 다음은 몇 가지 옵션입니다.

* 도구를 사용하여 애플리케이션에 대한 MSIX 설치 프로그램(다음 섹션에 설명됨)을 구성하고, 
  Microsoft Windows App Store를 통해 배포합니다. 
  이 옵션의 경우, 서명 인증서를 수동으로 만들 필요가 없습니다. 자동으로 처리해 주기 때문입니다.
* MSIX 설치 프로그램을 구성하고 자체 웹사이트를 통해 배포합니다. 
  이 옵션의 경우 애플리케이션에 `.pfx` 인증서 형태의 디지털 서명을 제공해야 합니다.
* 필요한 모든 부분을 수집하고 자체 zip 파일을 빌드합니다.

### MSIX 패키징 {:#msix-packaging}

새로운 Windows 애플리케이션 패키지 형식인 [MSIX][]는 최신 패키징 형식과 설치 프로그램을 제공합니다. 
이 형식은 Windows에서 Microsoft Store로 애플리케이션을 배송하는 데 사용할 수도 있고, 
앱 설치 프로그램을 직접 배포할 수도 있습니다.

Flutter 프로젝트에 대한 MSIX 배포를 만드는 가장 쉬운 방법은 
[`msix` pub 패키지][msix package]를 사용하는 것입니다. 
Flutter 데스크톱 앱에서 `msix` 패키지를 사용하는 예는 [Desktop Photo Search][] 샘플을 참조하세요.

[MSIX]: https://docs.microsoft.com/en-us/windows/msix/overview
[msix package]: {{site.pub}}/packages/msix
[Desktop Photo Search]: {{site.repo.samples}}/tree/main/desktop_photo_search

#### 로컬 테스트를 위해 자체 서명된 .pfx 인증서를 만듭니다.{:#create-a-self-signed-pfx-certificate-for-local-testing}

MSIX 설치 프로그램의 도움으로 private 배포 및 테스트를 위해, 
애플리케이션에 `.pfx` 인증서 형태의 디지털 서명을 제공해야 합니다.

Windows Store를 통한 배포의 경우, `.pfx` 인증서를 생성할 필요가 없습니다. 
Windows Store는 자체 스토어를 통해 배포된 애플리케이션에 대한 인증서 생성 및 관리를 처리합니다.

웹사이트에서 자체 호스팅하여 애플리케이션을 배포하려면, 
Windows에서 알려진 인증 기관에서 서명한 인증서가 필요합니다.

다음 지침을 사용하여 자체 서명된 `.pfx` 인증서를 생성하세요.

1. 아직 다운로드하지 않았다면, [OpenSSL][] 툴킷을 다운로드하여 인증서를 생성하세요.
2. OpenSSL을 설치한 위치(예: `C:\Program Files\OpenSSL-Win64\bin`)로 이동합니다.
3. 어디에서나 `OpenSSL`에 액세스할 수 있도록 환경 변수를 설정합니다.<br> 
   `"C:\Program Files\OpenSSL-Win64\bin"`
4. 다음과 같이 private 키를 생성합니다.<br> 
   `openssl genrsa -out mykeyname.key 2048`
5. private 키를 사용하여, 인증서 서명 요청(CSR, certificate signing request) 파일을 생성합니다.<br> 
   `openssl req -new -key mykeyname.key -out mycsrname.csr`
6. private 키와 CSR 파일을 사용하여 서명된 인증서(CRT, certificate) 파일을 생성합니다.<br> 
   `openssl x509 -in mycsrname.csr -out mycrtname.crt -req -signkey mykeyname.key -days 10000`
7. private 키와 CRT 파일을 사용하여 `.pfx` 파일을 생성합니다.<br> 
   `openssl pkcs12 -export -out CERTIFICATE.pfx -inkey mykeyname.key -in mycrtname.crt`
8. 앱을 설치하기 전에 먼저 로컬 머신에 `Certificate store`에서 
   `Trusted Root Certification Authorities`으로 `.pfx` 인증서를 설치합니다.

[OpenSSL]: https://slproweb.com/products/Win32OpenSSL.html

### Windows용 당신만의 자체 zip 파일 빌드 {:#building-your-own-zip-file-for-windows}

Flutter 실행 파일 `.exe`는 프로젝트의 `build\windows\runner\<build mode>\`에서 찾을 수 있습니다. 
해당 실행 파일 외에도 다음이 필요합니다.

* 동일한 디렉토리에서:
  * 모든 `.dll` 파일
  * `data` 디렉토리
* Visual C++ 재배포 가능 패키지. 
  Microsoft 사이트의 [배포 예제 연습][deployment example walkthroughs]에 표시된 모든 방법을 사용하여, 
  최종 사용자에게 C++ 재배포 가능 패키지가 있는지 확인할 수 있습니다. 
  `application-local` 옵션을 사용하는 경우, 다음을 복사해야 합니다.
  * `msvcp140.dll`
  * `vcruntime140.dll`
  * `vcruntime140_1.dll`
  
  DLL 파일을 실행 파일과 다른 DLL 옆의 디렉토리에 넣고 zip 파일로 묶습니다. 결과 구조는 다음과 같습니다.
  
  ```plaintext
  Release
  │   flutter_windows.dll
  │   msvcp140.dll
  │   my_app.exe
  │   vcruntime140.dll
  │   vcruntime140_1.dll
  │
  └───data
  │   │   app.so
  │   │   icudtl.dat

  ...
  ```

이 시점에서 원한다면 Inno Setup, WiX 등의 Windows 설치 프로그램에 이 폴더를 추가하는 것이 비교적 간단합니다.

## 추가적인 자료 {:#additional-resources}

Inno Setup을 사용하여 Windows용 Flutter 데스크톱 앱을 배포하기 위해, 
`.exe`를 빌드하는 방법을 알아보려면, 
단계별 [Windows 패키징 가이드][windows_packaging_guide]를 확인하세요.

[deployment example walkthroughs]: https://docs.microsoft.com/en-us/cpp/windows/deployment-examples
[windows_packaging_guide]: https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-2-windows-0b468d5e9e70
