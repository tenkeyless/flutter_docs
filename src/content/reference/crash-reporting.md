---
# title: Flutter crash reporting
title: Flutter 충돌 보고
# description: >-
#   How Google uses crash reporting, what is collected, and how to opt out.
description: >-
  Google에서 충돌 보고를 사용하는 방법, 수집되는 정보 및 옵트아웃 방법에 대해 알아보세요.
---

Flutter의 분석 및 충돌 보고를 옵트아웃하지 않은 경우, 
`flutter` 명령이 충돌하면 Google에 충돌 보고서를 보내, 
Google이 시간이 지남에 따라 Flutter를 개선하는 데 도움을 주려고 시도합니다. 
충돌 보고서에는 다음 정보가 포함될 수 있습니다.

* 로컬 운영 체제의 이름과 버전.
* 명령을 실행하는 데 사용된 Flutter 버전.
* 오류의 런타임 타입(예: `StateError` 또는 `NoSuchMethodError`).
* Flutter CLI 자체 코드에 대한 참조를 포함하고, 애플리케이션 코드에 대한 참조는 포함하지 않는 충돌로 생성된 스택 추적.
* 클라이언트 ID: Flutter가 설치된 컴퓨터에 대해 생성된 상수 및 고유 번호. 
  동일한 컴퓨터에서 발생하는 여러 개의 동일한 충돌 보고서를 중복 제거하는 데 도움이 됩니다. 
  또한, Flutter의 다음 버전으로 업그레이드한 후, 수정 사항이 의도한 대로 작동하는지 확인하는 데 도움이 됩니다.

Google은 이 도구에서 보고된 모든 데이터를 [Google 개인정보 보호정책][Google Privacy Policy]에 따라 처리합니다.

`.dart-tool/dart-flutter-telemetry.log` 파일에서 최근에 보고된 데이터를 검토할 수 있습니다. 
macOS 또는 Linux에서 이 로그는 홈 디렉터리(`~/`)에 있습니다. 
Windows에서 이 로그는 Roaming AppData 디렉터리(`%APPDATA%`)에 있습니다.

## 분석 보고 비활성화 {:#disabling-analytics-reporting}

익명의 충돌 보고 및 기능 사용 통계를 거부하려면, 다음 명령을 실행하세요.

```console
$ flutter --disable-analytics
```

분석에서 옵트아웃하면, Flutter에서 옵트아웃 이벤트를 보냅니다.
이 Flutter 설치는 추가 정보를 보내거나 저장하지 않습니다.

분석에 옵트인하려면, 다음 명령을 실행하세요.

```console
$ flutter --enable-analytics
```

현재 설정을 표시하려면, 다음 명령을 실행하세요.

```console
$ flutter config
```

[Google Privacy Policy]: https://policies.google.com/privacy
