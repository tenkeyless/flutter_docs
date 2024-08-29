---
# title: Flutter SDK archive
title: Flutter SDK 아카이브
# short-title: Archive
short-title: 아카이브
# description: "All current Flutter SDK releases: stable, beta, and master."
description: "모든 현재 Flutter SDK 릴리스: stable, beta 및 master."
toc: false
---

<style>
.scrollable-table {
  overflow-y: scroll;
  max-height: 20rem;
}
</style>

{{ site.sdk.channel | capitalize }} 채널에는 가장 안정적인(stable) Flutter 빌드가 포함되어 있습니다.
자세히 알아보려면, [Flutter의 채널][Flutter's channels]을 확인하세요.

{% render docs/china-notice.md %}

주요 Flutter 릴리스의 새로운 기능을 알아보려면, [릴리스 노트][release notes] 페이지를 확인하세요.

:::note provenance에 대한 참고사항
[provenance](https://slsa.dev/provenance)는 소프트웨어 아티팩트가 어떻게 빌드되는지, 
다운로드에 무엇이 포함되어 있고 누가 만들었는지에 대해 설명합니다. 
더 읽기 쉬운 형식으로 그리고 아무것도 다운로드되지 않은 곳에서 provenance를 보려면, 
릴리스의 provenance 파일 URL을 사용하여 다음 명령을 실행합니다.
(JSON을 쉽게 구문 분석하려면 [jq](https://stedolan.github.io/jq/)를 다운로드해야 할 수도 있음)

```console
curl [provenance URL] | jq -r .payload | base64 -d | jq
```
:::


{% tabs "os-archive-tabs" %}
{% tab "Windows" %}

{% include docs/release/archive-release_os.md os="Windows" %}

{% endtab %}
{% tab "macOS" %}

{% include docs/release/archive-release_os.md os="macOS" %}

{% endtab %}
{% tab "Linux" %}

{% include docs/release/archive-release_os.md os="Linux" %}

{% endtab %}
{% endtabs %}

## Master 채널 {:#master-channel}

설치 번들은 master에 사용할 수 없습니다. 
그러나, master 채널을 복제한 다음, SDK 종속성 다운로드를 트리거하여, 
[GitHub repo][]에서 직접 SDK를 가져올 수 있습니다.

```console
$ git clone -b master https://github.com/flutter/flutter.git
$ ./flutter/bin/flutter --version
```

설치 번들의 구조에 대한 추가 세부 정보는, [설치 번들][Installation bundles]을 참조하세요.

[Flutter's channels]: {{site.repo.flutter}}/blob/master/docs/releases/Flutter-build-release-channels.md
[release notes]: /release/release-notes
[GitHub repo]: {{site.repo.flutter}}
[Installation bundles]: {{site.repo.flutter}}/blob/master/docs/infra/Flutter-Installation-Bundles.md
