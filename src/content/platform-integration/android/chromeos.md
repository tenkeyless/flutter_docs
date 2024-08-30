---
# title: Targeting ChromeOS with Android
title: Android로 ChromeOS 타겟팅
# description: Platform-specific considerations for building for ChromeOS with Flutter.
description: Flutter로 ChromeOS를 위해 빌드하기 위한 플랫폼별 고려 사항.
---

이 페이지에서는 Flutter를 사용하여 ChromeOS를 지원하는 Android 앱을 빌드하는 데 고유한 고려 사항에 대해 설명합니다.

## Flutter 및 Chrome OS 팁과 요령 {:#flutter-chromeos-tips-tricks}

현재 버전의 ChromeOS의 경우, Linux의 특정 포트만 나머지 환경에 노출됩니다. 
다음은 작동하는 포트가 있는 Android 앱에 Flutter DevTools를 시작하는 방법의 예입니다.

```console
$ flutter pub global run devtools --port 8000
$ cd path/to/your/app
$ flutter run --observatory-port=8080
```

그런 다음, Chrome 브라우저에서 http://127.0.0.1:8000/# 으로 이동하여, 애플리케이션의 URL을 입력합니다. 
방금 실행한 마지막 `flutter run` 명령은, 
`http://127.0.0.1:8080/auth_code=/` 형식과 유사한 URL을 출력해야 합니다. 
이 URL을 사용하고, "Connect"를 선택하여 Android 앱의 Flutter DevTools를 시작합니다.

#### Flutter ChromeOS 린트 분석 {:#flutter-chromeos-lint-analysis}

Flutter에는 ChromeOS 전용 lint 분석 검사가 있어, 빌드하는 앱이 ChromeOS에서 잘 작동하는지 확인합니다. 
ChromeOS 기기에서 사용할 수 없는 Android Manifest의 필수 하드웨어, 
지원되지 않는 하드웨어에 대한 요청을 암시하는 권한, 
이러한 기기에서 낮은 경험을 제공하는 기타 속성 또는 코드와 같은 항목을 찾습니다.

이를 활성화하려면, 프로젝트 폴더에 새 analysis_options.yaml 파일을 만들어, 이러한 옵션을 포함해야 합니다. 
(기존 analysis_options.yaml 파일이 있는 경우 업데이트할 수 있음)

```yaml
include: package:flutter/analysis_options_user.yaml
analyzer:
 optional-checks:
   chrome-os-manifest-checks
```

명령줄에서 실행하려면 다음 명령을 사용하세요.

```console
$ flutter analyze
```

이 명령에 대한 샘플 출력은 다음과 같습니다.

```console
Analyzing ...
warning • This hardware feature is not supported on ChromeOS •
android/app/src/main/AndroidManifest.xml:4:33 • unsupported_chrome_os_hardware
```
