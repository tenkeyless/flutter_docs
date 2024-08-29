---
# title: Build Linux apps with Flutter
title: Flutter로 Linux 앱 빌드
# description: Platform-specific considerations when building for Linux with Flutter.
description: Flutter로 Linux를 빌드할 때 플랫폼별 고려 사항.
toc: true
# short-title: Linux development
short-title: Linux 개발
---

이 페이지에서는 셸 통합과 배포를 위한 앱 준비를 포함하여, 
Flutter를 사용하여 Linux 앱을 빌드하는 데 고유한 고려 사항에 대해 설명합니다.

## Linux와 통합 {:#integrate-with-linux}

라이브러리 함수와 시스템 호출로 구성된 Linux 프로그래밍 인터페이스는 C 언어와 ABI를 중심으로 설계되었습니다. 
다행히도 Dart는 Dart 프로그램이 C 라이브러리를 호출할 수 있도록 하는 `dart:ffi` 패키지를 제공합니다.

외부 함수 인터페이스(FFI)를 사용하면, Flutter 앱이 네이티브 라이브러리로 다음을 수행할 수 있습니다.

* `malloc` 또는 `calloc`로 네이티브 메모리를 할당합니다.
* 포인터, 구조체 및 콜백을 지원합니다.
* `long` 및 `size_t`와 같은 애플리케이션 바이너리 인터페이스(ABI, Application Binary Interface) 타입을 지원합니다.

Flutter에서 C 라이브러리를 호출하는 방법에 대해 자세히 알아보려면, [C interop using `dart:ffi`][]를 참조하세요.

많은 앱은 더 편리하고, 관용적인 Dart API로 기본 라이브러리 호출을 래핑하는 패키지를 사용하는 데서 이점을 얻습니다.
Canonical은, 데스크톱 알림, DBUS, 네트워크 관리, Bluetooth에 대한 지원을 포함하여, 
Linux에서 Dart와 Flutter를 활성화하는 데 중점을 둔 [일련의 패키지를 구축했습니다][Canonical].

일반적으로, [`url_launcher`], [`shared_preferences`], [`file_selector`], [`path_provider`]와 같은 
일반적인 패키지를 포함하여 다른 많은 [패키지가 Linux 앱 생성을 지원합니다][support-linux].

[C interop using `dart:ffi`]: {{site.dart-site}}/guides/libraries/c-interop
[Canonical]: {{site.pub}}/publishers/canonical.com/packages
[support-linux]: {{site.pub}}/packages?q=platform%3Alinux
[`url_launcher`]: {{site.pub-pkg}}/url_launcher
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[`file_selector`]: {{site.pub-pkg}}/file_selector
[`path_provider`]: {{site.pub-pkg}}/path_provider

## 배포를 위한 Linux 앱 준비 {:#prepare-linux-apps-for-distribution}

실행 가능한 바이너리는 프로젝트에서 `build/linux/x64/<build mode>/bundle/`에서 찾을 수 있습니다. 
`bundle` 디렉토리의 실행 가능한 바이너리와 함께 두 개의 디렉토리를 찾을 수 있습니다.

* `lib`에는 필요한 `.so` 라이브러리 파일이 들어 있습니다.
* `data`에는 글꼴이나 이미지와 같은 애플리케이션의 데이터 assets이 들어 있습니다.

이러한 파일 외에도 애플리케이션은 컴파일된 다양한 운영 체제 라이브러리에 의존합니다. 
라이브러리의 전체 리스트를 보려면 애플리케이션 디렉토리에서 `ldd` 명령을 사용하세요.

예를 들어, `linux_desktop_test`라는 Flutter 데스크톱 애플리케이션이 있다고 가정해 보겠습니다. 
해당 시스템 라이브러리 종속성을 검사하려면 다음 명령을 사용하세요.

```console
$ flutter build linux --release
$ ldd build/linux/x64/release/bundle/linux_desktop_test
```

이 애플리케이션을 배포하기 위해 `bundle` 디렉토리에 있는 모든 것을 포함하여, 
대상 Linux 시스템에 필요한 모든 시스템 라이브러리가 있는지 확인하고 래핑합니다.

다음 명령만 사용하면 될 수 있습니다.

```console
$ sudo apt-get install libgtk-3-0 libblkid1 liblzma5
```

[Snap Store]에 Linux 애플리케이션을 게시하는 방법을 알아보려면, 
[Snap Store에 Linux 애플리케이션 빌드 및 릴리스][Build and release a Linux application to the Snap Store]를 참조하세요.

## 추가적인 리소스 {:#additional-resources}

Flutter 데스크톱 앱의 Linux Debian(`.deb`) 및 RPM(`.rpm`) 빌드를 만드는 방법을 알아보려면, 
단계별 [Linux 패키징 가이드][linux_packaging_guide]를 참조하세요.

[Snap Store]: https://snapcraft.io/store
[Build and release a Linux application to the Snap Store]: /deployment/linux
[linux_packaging_guide]: https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-3-linux-24ef8d30a5b4
