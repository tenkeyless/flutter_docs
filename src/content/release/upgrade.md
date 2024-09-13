---
# title: Upgrading Flutter
title: Flutter 업그레이드
# short-title: Upgrading
short-title: 업그레이드
# description: How to upgrade Flutter.
description: Flutter를 업그레이드하는 방법.
---

어떤 Flutter 릴리스 채널을 따르든, 
`flutter` 명령을 사용하여 Flutter SDK 또는 앱이 사용하는 패키지를 업그레이드할 수 있습니다.

## Flutter SDK 업그레이드 {:#upgrading-the-flutter-sdk}

Flutter SDK를 업데이트하려면 `flutter upgrade` 명령을 사용하세요.

```console
$ flutter upgrade
```

이 명령은 현재 Flutter 채널에서 사용할 수 있는 Flutter SDK의 최신 버전을 가져옵니다.

**stable** 채널을 사용하고 있고 Flutter SDK의 최신 버전을 원하는 경우, 
`flutter channel beta`를 사용하여 **beta** 채널로 전환한 다음, 
`flutter upgrade`를 실행합니다.

### 계속 정보받기 {:#keeping-informed}

알려진 중단 변경 사항에 대한 [마이그레이션 가이드][migration guides]를 게시합니다.

이러한 변경 사항에 대한 공지 사항은 [Flutter 공지 메일링 리스트][flutter-announce]으로 보냅니다.

향후 Flutter 버전에서 중단되는 것을 방지하려면, 
테스트를 [테스트 레지스트리][test registry]에 제출하는 것을 고려하세요.

## Flutter 채널 전환 {:#switching-flutter-channels}

Flutter에는 **stable**과 **beta**라는 두 가지 릴리스 채널이 있습니다.

### **stable** 채널 {:#the-stable-channel}

새로운 사용자와 프로덕션 앱 릴리스에는 **stable** 채널을 권장합니다. 
팀은 이 채널을 약 3개월마다 업데이트합니다. 
채널은 심각도가 높거나(high-severity) 큰 영향이 있는(high-impact) 문제에 대한 핫픽스를 가끔 받을 수 있습니다.

Flutter 팀의 플러그인과 패키지에 대한 지속적인 통합에는, 
최신 **stable** 릴리스에 대한 테스트가 포함됩니다.

**stable** 브랜치에 대한 최신 문서는 <https://api.flutter.dev>에 있습니다.

### **beta** 채널 {:#the-beta-channel}

**beta** 채널에는 최신 stable 릴리스가 있습니다. 
이것은 우리가 철저히 테스트한 Flutter의 가장 최신 버전입니다. 
이 채널은 모든 공개 테스트를 통과했으며, 
Flutter를 사용하는 Google 제품에 대한 테스트 모음에 대해 검증되었으며, 
[기여된 비공개 테스트 모음][test registry]에 대해 검증되었습니다.
**beta** 채널은 새로 발견된 중요한 문제를 해결하기 위해 정기적으로 핫픽스를 받습니다.

**beta** 채널은 기본적으로 **stable** 채널과 동일하지만, 분기별이 아닌 월별로 업데이트됩니다. 실제로, **stable** 채널이 업데이트될 때는, 최신 **beta** 릴리스로 업데이트됩니다.

### 기타 채널 {:#other-channels}

현재 **master**라는 다른 채널이 하나 있습니다. 
[Flutter에 기여하는][contribute to Flutter] 사람들이 이 채널을 사용합니다.

이 채널은 **beta** 및 **stable** 채널만큼 철저하게 테스트되지 않았습니다.

심각한 회귀(serious regressions)가 포함될 가능성이 더 높으므로 이 채널을 사용하지 않는 것이 좋습니다.

**master** 브랜치에 대한 최신 문서는 <https://main-api.flutter.dev>에 있습니다.

### 채널 변경 {:#changing-channels}

현재 채널을 보려면, 다음 명령을 사용하세요.

```console
$ flutter channel
```

다른 채널로 변경하려면, `flutter channel <channel-name>`을 사용합니다. 
채널을 변경한 후, `flutter upgrade`를 사용하여, 
해당 채널의 최신 Flutter SDK와 종속 패키지를 다운로드합니다. 예를 들어:

```console
$ flutter channel beta
$ flutter upgrade
```

## Switching to a specific Flutter version

특정 Flutter 버전으로 전환하려면:

1. [Flutter SDK 아카이브][Flutter SDK archive]에서 원하는 **Flutter 버전**을 찾으세요.

2. Flutter SDK로 이동합니다.

   ```console
   $ cd /path/to/flutter
   ```

   :::tip
   `flutter doctor --verbose`를 사용하여 Flutter SDK의 경로를 찾을 수 있습니다.
   :::

3. `git checkout`을 사용하여 원하는 **Flutter 버전**으로 전환합니다.

   ```console
   $ git checkout <Flutter version>
   ```

## 패키지 업그레이드 {:#upgrading-packages}

`pubspec.yaml` 파일을 수정했거나, 
앱이 종속된 패키지만 업데이트하려는 경우(패키지와 Flutter 자체가 아닌), 
`flutter pub` 명령 중 하나를 사용하세요.

`pubspec.yaml` 파일에 나열된 모든 종속성의 _최신 호환 버전_ 으로 업데이트하려면, 
`upgrade` 명령을 사용하세요.

```console
$ flutter pub upgrade
```

`pubspec.yaml` 파일에 나열된 모든 종속성의 _가능한 최신 버전_ 으로 업데이트하려면, 
`upgrade --major-versions` 명령을 사용합니다.

```console
$ flutter pub upgrade --major-versions
```

이렇게 하면 `pubspec.yaml` 파일의 제약 조건도 자동으로 업데이트됩니다.

오래된 패키지 종속성을 식별하고 이를 업데이트하는 방법에 대한 조언을 얻으려면, 
`outdated` 명령을 사용합니다. 
자세한 내용은 Dart [`pub outdated` 문서]({{site.dart-site}}/tools/pub/cmd/pub-outdated)를 참조하세요.

```console
$ flutter pub outdated
```

[Flutter SDK archive]: /release/archive
[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce
[pubspec.yaml]: {{site.dart-site}}/tools/pub/pubspec
[test registry]: {{site.repo.organization}}/tests
[contribute to Flutter]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md
[migration guides]: /release/breaking-changes
