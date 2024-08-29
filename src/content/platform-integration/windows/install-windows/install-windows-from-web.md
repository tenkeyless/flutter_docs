---
# title: Add Windows as a target platform for Flutter from Web start
title: 웹으로부터 시작하여, Flutter의 대상 플랫폼으로 Windows 추가 ([Windows] Web + Windows)
# description: Configure your system to develop Flutter apps on Windows desktop.
description: Windows 데스크톱에서 Flutter 앱을 개발하도록 시스템을 구성하세요.
# short-title: Starting from Web
short-title: 웹으로부터 시작
---

Flutter 앱 대상으로 Windows 데스크톱을 추가하려면, 다음 절차를 따르세요.

## Visual Studio 설치 및 구성 {:#install-and-configure-visual-studio}

1. Visual Studio에 최소 26GB의 스토리지를 할당합니다.
   최적의 구성을 위해 10GB의 스토리지를 할당하는 것을 고려하세요.
1. 네이티브 C++ Windows 코드를 디버그하고 컴파일하려면, [Visual Studio 2022][]를 설치하세요.
   **Desktop development with C++** 워크로드를 설치하세요.
   이렇게 하면 모든 기본 구성 요소를 포함하여 Windows 앱을 빌드할 수 있습니다.
   **Visual Studio**는 **[Visual Studio _Code_][]** 와 별도의 IDE입니다.

{% include docs/install/flutter-doctor.md target='Windows' devos='Windows' config='WindowsDesktopWeb' %}

[Visual Studio 2022]: https://learn.microsoft.com/visualstudio/install/install-visual-studio?view=vs-2022
[Visual Studio _Code_]: https://code.visualstudio.com/
