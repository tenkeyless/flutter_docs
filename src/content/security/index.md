---
# title: Security
title: 보안
# description: >-
  # An overview of the Flutter's team philosophy and processes for security.
description: >-
  보안을 위한 Flutter 팀의 철학과 프로세스 개요입니다.
show_breadcrumbs: false
---

Flutter 팀은 Flutter와 이를 사용하여 만든 애플리케이션의 보안을 심각하게 생각합니다. 
이 페이지에서는 발견할 수 있는 취약점을 보고하는 방법을 설명하고, 
취약점 도입 위험을 최소화하기 위한 모범 사례를 나열합니다.

## 보안 철학 {:#security-philosophy}

Flutter 보안 전략은 5가지 핵심 기둥을 기반으로 합니다.

* **식별 (Identify)**: 핵심 자산, 주요 위협 및 취약성을 식별하여, 주요 보안 위험을 추적하고 우선순위를 지정합니다.
* **감지 (Detect)**: 취약성 스캐닝, 정적 애플리케이션 보안 테스트, 퍼징(fuzzing)과 같은 기술과 도구를 사용하여, 
  취약성을 탐지하고 식별합니다.
* **보호 (Protect)**: 알려진 취약성을 완화하여 위험을 제거하고, 소스 위협으로부터 중요한 자산을 보호합니다.
* **대응 (Respond)**: 취약성 또는 공격을 보고, 분류하고, 대응하는 프로세스를 정의합니다.
* **복구 (Recover)**: 최소한의 영향으로 사고를 억제하고, 복구할 수 있는 역량을 구축합니다.

## 취약점 보고 {:#reporting-vulnerabilities}

정적 분석 도구에서 발견한 보안 취약성을 보고하기 전에, 
[알려진 거짓 양성][known false positives] 리스트를 확인해 보세요.

취약성을 보고하려면, `security@flutter.dev`로 이메일을 보내, 
문제에 대한 설명, 문제를 만드는 데 취한 단계, 영향을 받는 버전, 알려진 경우 문제에 대한 완화책을 보내주세요.

3 영업일 이내에 회신해 드리겠습니다.

GitHub의 보안 권고 기능을 사용하여 공개된 보안 문제를 추적합니다. 
보고하신 문제를 해결하기 위해 긴밀히 협력할 예정입니다.

신속한 대응과 정기적인 업데이트를 받지 못하면, `security@flutter.dev`로 다시 연락해 주세요. 
공개 [Discord 채팅 채널][Discord chat channels]을 사용하여 팀에 연락할 수도 있지만, 
문제를 보고할 때는 `security@flutter.dev`로 이메일을 보내세요. 
사용자를 위험에 빠뜨릴 수 있는 취약성에 대한 정보를 공개적으로 공개하지 않으려면, 
**Discord에 게시하거나 GitHub 문제를 제출하지 마세요**.

보안 취약점을 처리하는 방법에 대한 자세한 내용은 [보안 정책][security policy]을 참조하세요.

[Discord chat channels]: {{site.repo.flutter}}/blob/master/docs/contributing/Chat.md
[known false positives]: /reference/security-false-positives
[security policy]: {{site.repo.flutter}}/security/policy

## 기존 문제를 보안 관련으로 표시 {:#flagging-existing-issues-as-security-related}

기존 문제가 보안과 관련이 있다고 생각되면, 
`security@flutter.dev`로 이메일을 보내주시기 바랍니다. 
이메일에는 문제 ID와 이 보안 정책에 따라 처리해야 하는 이유에 대한 간략한 설명이 포함되어야 합니다.

## 지원되는 버전 {:#supported-versions}

우리는 현재 `stable` 브랜치에 있는 Flutter 버전에 대한 보안 업데이트를 게시하기 위해 커밋합니다.

## 기대 사항 {:#expectations}

저희는 보안 문제를 P0 priority level과 동일하게 취급하고, 
최신 안정 버전 SDK에서 발견된 모든 주요 보안 문제에 대해, 
베타 또는 핫픽스를 릴리스합니다.

docs.flutter.dev와 같은 flutter 웹사이트에 대해, 
보고된 모든 취약성은 릴리스가 필요하지 않으며 웹사이트 자체에서 수정됩니다.

## Bug Bounty 프로그램 {:#bug-bounty-programs}

기여 팀은 Flutter를 버그 바운티 프로그램 범위에 포함할 수 있습니다. 
프로그램을 등록하려면, `security@flutter.dev`로 연락하세요.

Google은 Flutter를 [Google 오픈 소스 소프트웨어 취약점 보상 프로그램][google-oss-vrp]의 범위에 포함되는 것으로 간주합니다. 
편의를 위해 보고자는 Google의 취약점 보고 흐름을 사용하기 전에, `security@flutter.dev`로 연락해야 합니다.

[google-oss-vrp]: https://bughunters.google.com/open-source-security

## 보안 업데이트 수신 {:#receiving-security-updates}

보안 업데이트를 받는 가장 좋은 방법은 [flutter-announce][] 메일링 리스트를 구독하거나, 
[Discord 채널][Discord channel]에서 업데이트를 감시하는 것입니다. 
또한 기술 릴리스 블로그 게시물에서 보안 업데이트를 발표합니다.

[Discord channel]: https://discord.gg/BS8KZyg
[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce

## 모범 사례 {:#best-practices}

* **최신 Flutter SDK 릴리스를 최신 상태로 유지하세요.**
  Flutter는 정기적으로 업데이트되며, 이러한 업데이트는 이전 버전에서 발견된 보안 결함을 수정할 수 있습니다.

* **애플리케이션의 종속성을 최신 상태로 유지하세요.**
  종속성을 최신 상태로 유지하려면 [패키지 종속성 업그레이드][upgrade your package dependencies]를 수행해야 합니다. 
  종속성에 대해 특정 버전을 고정하지 말고, 
  고정하는 경우 종속성에 보안 업데이트가 있는지 주기적으로 확인하고 그에 따라 고정을 업데이트하세요.

* **Flutter 사본을 최신 상태로 유지하세요.**
  Flutter의 Private 커스터마이즈된 버전은 현재 버전보다 뒤떨어지는 경향이 있으며, 
  중요한 보안 수정 및 개선 사항이 포함되지 않을 수 있습니다. 
  대신 Flutter 사본을 정기적으로 업데이트하세요. 
  Flutter를 개선하기 위해 변경하는 경우, 
  포크를 업데이트하고 커뮤니티와 변경 사항을 공유하는 것을 고려하세요.

[upgrade your package dependencies]: /release/upgrade

