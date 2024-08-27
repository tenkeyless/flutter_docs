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

To update the Flutter SDK use the `flutter upgrade` command:

```console
$ flutter upgrade
```

This command gets the most recent version of the Flutter SDK
that's available on your current Flutter channel.

If you are using the **stable** channel
and want an even more recent version of the Flutter SDK,
switch to the **beta** channel using `flutter channel beta`,
and then run `flutter upgrade`.

### 계속 정보받기 {:#keeping-informed}

We publish [migration guides][] for known breaking changes.

We send announcements regarding these changes to the
[Flutter announcements mailing list][flutter-announce].

To avoid being broken by future versions of Flutter,
consider submitting your tests to our [test registry][].


## 플러터 채널 전환 {:#switching-flutter-channels}

Flutter has two release channels:
**stable** and **beta**.

### **stable** 채널 {:#the-stable-channel}

We recommend the **stable** channel for new users
and for production app releases.
The team updates this channel about every three months.
The channel might receive occasional hot fixes
for high-severity or high-impact issues.

The continuous integration for the Flutter team's plugins and packages
includes testing against the latest **stable** release.

The latest documentation for the **stable** branch
is at: <https://api.flutter.dev>

### **beta** 채널 {:#the-beta-channel}

The **beta** channel has the latest stable release.
This is the most recent version of Flutter that we have heavily tested.
This channel has passed all our public testing,
has been verified against test suites for Google products that use Flutter,
and has been vetted against [contributed private test suites][test registry].
The **beta** channel receives regular hot fixes
to address newly discovered important issues.

The **beta** channel is essentially the same as the **stable** channel
but updated monthly instead of quarterly.
Indeed, when the **stable** channel is updated,
it is updated to the latest **beta** release.

### 기타 채널 {:#other-channels}

We currently have one other channel, **master**.
People who [contribute to Flutter][] use this channel.

This channel is not as thoroughly tested as
the **beta** and **stable** channels.

We do not recommend using this channel as
it is more likely to contain serious regressions.

The latest documentation for the **master** branch
is at: <https://main-api.flutter.dev>

### 채널 변경 {:#changing-channels}

To view your current channel, use the following command:

```console
$ flutter channel
```

To change to another channel, use `flutter channel <channel-name>`.
Once you've changed your channel, use `flutter upgrade`
to download the latest Flutter SDK and dependent packages for that channel.
For example:

```console
$ flutter channel beta
$ flutter upgrade
```

:::note
If you need a specific version of the Flutter SDK,
you can download it from the [Flutter SDK archive][].
:::


## 패키지 업그레이드 {:#upgrading-packages}

If you've modified your `pubspec.yaml` file, or you want to update
only the packages that your app depends upon
(instead of both the packages and Flutter itself),
then use one of the `flutter pub` commands.

To update to the _latest compatible versions_ of
all the dependencies listed in the `pubspec.yaml` file,
use the `upgrade` command:

```console
$ flutter pub upgrade
```

To update to the _latest possible version_ of
all the dependencies listed in the `pubspec.yaml` file,
use the `upgrade --major-versions` command:

```console
$ flutter pub upgrade --major-versions
```

This also automatically update the constraints
in the `pubspec.yaml` file.

To identify out-of-date package dependencies and get advice
on how to update them, use the `outdated` command. For details, see
the Dart [`pub outdated` documentation]({{site.dart-site}}/tools/pub/cmd/pub-outdated).

```console
$ flutter pub outdated
```

[Flutter SDK archive]: /release/archive
[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce
[pubspec.yaml]: {{site.dart-site}}/tools/pub/pubspec
[test registry]: {{site.repo.organization}}/tests
[contribute to Flutter]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md
[migration guides]: /release/breaking-changes
