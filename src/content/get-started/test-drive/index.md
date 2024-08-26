---
# title: Test drive
title: 테스트 드라이브
# description: How to create a templated Flutter app and use hot reload.
description: 템플릿 기반 Flutter 앱을 만들고 핫 리로드를 사용하는 방법.
prev:
  title: Flutter 설치
  path: /get-started/install
next:
  title: 첫 번째 Flutter 앱을 작성하기
  path: /get-started/codelab
toc: false
---

{% case os %}
{% when 'Windows' -%}
   {% assign path='C:\dev\' %}
   {% assign terminal='PowerShell' %}
   {% assign prompt1='D:>' %}
   {% assign prompt2=path | append: '>' %}
   {% assign dirdl='%CSIDL_DEFAULT_DOWNLOADS%\' %}
{% when "macOS" -%}
   {% assign path='~/development/' %}
   {% assign terminal='the Terminal' %}
   {% assign prompt1='$' %}
   {% assign prompt2='$' %}
   {% assign dirdl='~/Downloads/' %}
{% else -%}
   {% assign path='/usr/bin/' %}
   {% assign terminal='a shell' %}
   {% assign prompt1='$' %}
   {% assign prompt2='$' %}
   {% assign dirdl='~/Downloads/' %}
{% endcase -%}

## 당신이 배울 것 {:#what-youll-learn}

1. 샘플 템플릿에서 새 Flutter 앱을 만드는 방법.
1. 새 Flutter 앱을 실행하는 방법.
1. 앱을 변경한 후 "핫 리로드"를 사용하는 방법.

이러한 작업은 사용하는 통합 개발 환경(IDE)에 따라 달라집니다.

* **옵션 1**은 Visual Studio Code와 Flutter 확장 프로그램을 사용하여 코딩하는 방법을 설명합니다.

* **옵션 2**는 Android Studio 또는 IntelliJ IDEA를 사용하여, Flutter 플러그인을 사용하여 코딩하는 방법을 설명합니다.

  Flutter는 IntelliJ IDEA Community, Educational 및 Ultimate 버전을 지원합니다.

* **옵션 3**은 원하는 편집기로 코딩하고, 터미널을 사용하여 코드를 컴파일하고 디버깅하는 방법을 설명합니다.

## IDE를 선택하세요 {:#choose-your-ide}

Flutter 앱에 적합한 IDE를 선택하세요.

{% tabs %}
{% tab "Visual Studio Code" %}

{% include docs/install/test-drive/vscode.md %}

{% endtab %}
{% tab "Android Studio 및 IntelliJ" %}

{% include docs/install/test-drive/androidstudio.md %}

{% endtab %}
{% tab "Terminal & editor" %}

{% include docs/install/test-drive/terminal.md %}

{% endtab %}
{% endtabs %}
