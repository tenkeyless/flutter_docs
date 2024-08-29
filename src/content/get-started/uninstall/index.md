---
# title: Uninstall Flutter
title: Flutter 제거 
# description: How to remove the Flutter SDK.
description: Flutter SDK를 제거하는 방법.
toc: false
os-list: [Windows, macOS, Linux, ChromeOS]
---

개발 머신에서 Flutter를 모두 제거하려면, Flutter와 해당 구성 파일이 저장된 디렉토리를 삭제하세요.

## Flutter SDK 제거 {:#uninstall-the-flutter-sdk}

다음 탭에서 개발 플랫폼을 선택하세요.

{% tabs %}

{% for os in os-list %}
{% tab os %}

{% assign id = os | downcase -%}
{% case os %}
{% when 'Windows' -%}
{% assign dirinstall='C:\\user\{username}\dev\' %}
{% assign localappdata='%LOCALAPPDATA%\' %}
{% assign appdata='%APPDATA%\' %}
{% assign ps-localappdata='$env:LOCALAPPDATA\' %}
{% assign ps-appdata='$env:APPDATA\' %}
{% assign unzip='Expand-Archive' %}
{% assign path='C:\\user\{username}\dev' %}
{% assign prompt='C:\\>' %}
{% assign terminal='PowerShell' %}
{% assign rm = 'Remove-Item -Recurse -Force -Path' %}
{% capture rm-sdk %}Remove-Item -Recurse -Force -Path '{{dirinstall}}flutter'{% endcapture %}
{% capture dart-files %}
{{localappdata}}.dartServer
{{appdata}}.dart
{{appdata}}.dart-tool
{% endcapture %}
{% capture rm-dart-files %}
{{prompt}} {{rm}} {{ps-localappdata}}.dartServer,{{ps-appdata}}.dart,{{ps-appdata}}.dart-tool
{% endcapture %}
{% capture flutter-files %}{{appdata}}.flutter-devtools{% endcapture %}
{% capture rm-flutter-files %}
{{prompt}} {{rm}} {{ps-appdata}}.flutter-devtools
{% endcapture %}
{% capture rm-pub-dir %}
{{prompt}} {{rm}} {{ps-localappdata}}Pub\Cache
{% endcapture %}
{% else -%}
{% assign dirinstall='~/development' %}
{% assign dirconfig='~/' %}
{% assign path='~/development/' %}
{% assign prompt='$' %}
{% assign rm = 'rm -rf ' %}
{% assign rm-sdk = rm | append: dirinstall | append: '/flutter' %}
{% capture dart-files %}
{{dirconfig}}.dart
{{dirconfig}}.dart-tool
{{dirconfig}}.dartServer
{% endcapture %}
{% capture rm-dart-files %}
{{prompt}} {{rm}} {{dirconfig}}.dart*
{% endcapture %}
{% capture flutter-files %}
{{dirconfig}}.flutter
{{dirconfig}}.flutter-devtools
{{dirconfig}}.flutter_settings
{% endcapture %}
{% capture rm-flutter-files %}
{{prompt}} {{rm}} {{dirconfig}}.flutter*
{% endcapture %}
{% capture rm-pub-dir %}
{{prompt}} {{rm}} {{dirconfig}}.pub-cache
{% endcapture %}
{% endcase -%}

이 가이드에서는 Flutter를 {{os}}의 `{{path}}`에 설치했다고 가정합니다.

SDK를 제거하려면, `flutter` 디렉토리를 제거하세요.

```console
{{prompt}} {{rm-sdk}}
```

## 구성 및 패키지 디렉토리 제거 (Remove configuration and package directories) {:.no_toc}

Flutter와 Dart는 홈 디렉토리에 추가적인 디렉토리를 설치합니다. 
여기에는 구성 파일과 패키지 다운로드가 포함됩니다. 
다음 절차는 모두 _선택 사항_ 입니다.

<!-- ### Remove Flutter configuration files {:.no_toc} -->
### Flutter 구성 파일 제거 (Remove Flutter configuration files) {:.no_toc}

Flutter 구성을 보존하지 않으려면, 홈 디렉토리에서 다음 디렉토리를 제거하세요.

```plaintext
{{ flutter-files | strip }}
```

이러한 디렉토리를 제거하려면, 다음 명령을 실행하세요.

```console
{{rm-flutter-files | strip}}
```

### Dart 구성 파일 제거 (Remove Dart configuration files) {:.no_toc}

Dart 구성을 보존하지 않으려면, 홈 디렉토리에서 다음 디렉토리를 제거하세요.

```plaintext
{{ dart-files | strip}}
```

이러한 디렉토리를 제거하려면, 다음 명령을 실행하세요.

```console
{{rm-dart-files | strip}}
```

### Pub 패키지 파일 제거 (Remove pub package files) {:.no_toc}

:::important
Flutter는 제거하지만 Dart는 제거하지 않으려는 경우, 이 섹션을 완료하지 마세요.
:::

Pub 패키지를 보존하지 않으려면, 홈 디렉토리에서 `.pub-cache` 디렉토리를 제거하세요.

```console
{{rm-pub-dir | strip}}
```

{% case os %}
{% when 'Windows','macOS' -%}
{% include docs/install/reqs/{{os | downcase}}/unset-path.md terminal=terminal -%}
{% endcase %}

{% endtab %}
{% endfor -%}

{% endtabs %}

## Flutter 재설치 {:#reinstall-flutter}

언제든지 [Flutter를 다시 설치](/get-started/install)할 수 있습니다. 
구성 디렉토리를 제거한 경우, Flutter를 다시 설치하면 기본 설정으로 복원됩니다.