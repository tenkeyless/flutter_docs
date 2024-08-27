---
# title: Flutter compatibility policy
title: Flutter 호환성 정책
# description: How Flutter approaches the question of breaking changes.
description: Flutter가 주요 변경 사항의 문제에 접근하는 방식.
---

Flutter 팀은 API 안정성에 대한 필요성과 버그를 수정하고, 
API 인체공학을 개선하고, 일관된 방식으로 새로운 기능을 제공하기 위해, 
진화하는 API를 유지해야 하는 필요성 사이에서 균형을 맞추려고 노력합니다.

이를 위해, 우리는 여러분이 자신의 애플리케이션이나 라이브러리에 대한 유닛 테스트를 제공할 수 있는 테스트 레지스트리를 만들었으며, 우리는 모든 변경에 대해 이를 실행하여 기존 애플리케이션을 손상시킬 수 있는 변경 사항을 추적할 수 있도록 돕습니다. 
우리는 
(a) 변경 사항이 충분히 가치 있는지 확인하고, 
(b) 테스트가 계속 통과할 수 있도록 코드에 대한 수정 사항을 제공하기 위해, 
해당 테스트 개발자와 협력하지 않고는 이러한 테스트를 손상시키는 변경 사항을 하지 않을 것을 약속합니다.

이 프로그램의 일부로 테스트를 제공하려면, [flutter/tests repository][]에 PR을 제출하세요. 
해당 저장소의 [README][flutter-tests-readme]에서 프로세스를 자세히 설명합니다.

[flutter/tests repository]: {{site.github}}/flutter/tests
[flutter-tests-readme]: {{site.github}}/flutter/tests#adding-more-tests

## 공지사항 및 마이그레이션 가이드 {:#announcements-and-migration-guides}

만약 우리가 중대한 변경(제출된 테스트 중 하나 이상이 변경을 필요로 하는 변경으로 정의됨)을 한다면, 
우리는 [flutter-announce][] 메일링 리스트와 릴리스 노트에 변경 사항을 발표할 것입니다.

우리는 중대한 변경 사항의 영향을 받는 [코드 마이그레이션 가이드][guides for migrating code] 리스트를 제공합니다.

[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce
[guides for migrating code]: /release/breaking-changes

## Deprecation 정책 {:#deprecation-policy}

우리는, 때때로, 특정 API를 밤새 완전히 중단하기(outright break)보다는, deprecate 처리할 것입니다. 
이는, 위에서 설명한 대로, 제출된 테스트가 실패하는지 여부에만 전적으로 기반을 둔 호환성 정책과는 별개입니다.

Flutter 팀은 예정된 기준(scheduled basis)으로, deprecated API를 제거하지 않습니다. 
팀이 deprecated API를 제거하는 경우, 주요 변경 사항과 동일한 절차를 따릅니다.

## Flutter에서 사용하는 Dart 및 기타 라이브러리 {:#dart-and-other-libraries-used-by-flutter}

Dart 언어 자체에는 [별도의 변경 정책][separate breaking-change policy]이 있으며, 
[Dart 발표][Dart announce]에서 공지합니다.

일반적으로, Flutter 팀은 현재 다른 종속성에 대한 중단 변경(breaking changes)에 대해 아무런 약속도 하지 않습니다. 
예를 들어, 새로운 버전의 Skia(Flutter의 일부 플랫폼에서 사용하는 그래픽 엔진) 또는, 
Harfbuzz(Flutter에서 사용하는 글꼴 셰이핑 엔진)를,
사용하는 새로운 버전의 Flutter에는, 기여된 테스트에 영향을 미치는 변경 사항이 있을 수 있습니다. 
이러한 변경 사항에는 반드시 마이그레이션 가이드가 수반되지 않습니다.

[separate breaking-change policy]: {{site.github}}/dart-lang/sdk/blob/main/docs/process/breaking-changes.md
[Dart announce]: {{site.groups}}/a/dartlang.org/g/announce
