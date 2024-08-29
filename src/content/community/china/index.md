---
# title: Using Flutter in China
title: 중국에서 Flutter 사용하기
# description: How to use, access, and learn about Flutter in China.
description: 중국에서 Flutter를 사용하고, 접근하고, 학습하는 방법.
toc: true
os-list: [Windows, macOS, Linux, ChromeOS]
---

{% assign flutter-sdk = 'flutter_opsys_v3.13.0-stable.' %}
{% capture sdk-path -%}flutter_infra_release/releases/stable/opsys/{{flutter-sdk}}{%- endcapture %}

{% render docs/china-notice-cn.md %}

중국에서 Flutter의 다운로드 및 설치 속도를 높이려면, [미러 사이트][mirror site] 또는 _미러_ 를 사용하는 것을 고려하세요.

:::important
제공자를 _신뢰_ 하는 경우에만 미러 사이트를 사용하세요.
Flutter 팀은 신뢰성이나 보안성을 검증할 수 없습니다.
:::

[mirror site]: https://en.wikipedia.org/wiki/Mirror_site

## Flutter 미러 사이트 이용 {:#use-a-flutter-mirror-site}

[중국 Flutter 사용자 그룹][China Flutter User Group](CFUG, China Flutter User Group)은 간체 중국어 플러터 웹사이트 [https://flutter.cn](https://flutter.cn)와 미러 사이트를 유지 관리합니다. 
다른 미러 사이트는 [이 가이드의 끝부분](#known-trusted-community-run-mirror-sites)에서 찾을 수 있습니다.

### 미러 사이트를 사용하도록 컴퓨터 구성 {:#configure-your-machine-to-use-a-mirror-site}

중국에서 Flutter를 설치하거나 사용하려면, 신뢰할 수 있는 Flutter 미러를 사용하세요. 
이를 위해서는 머신에 두 개의 환경 변수를 설정해야 합니다.

_다음의 모든 예는 CFUG 미러를 사용한다고 가정합니다._

머신이 미러 사이트를 사용하도록 설정하려면:

{% tabs "china-setup-os" %}

{% for os in os-list %}
{% tab os %}

{% include docs/community/china/os-settings.md ref-os=os sdk=flutter-sdk %}

{% endtab %}
{% endfor -%}

{% endtabs %}

### 미러 사이트를 기반으로 Flutter 아카이브 다운로드 {:#download-flutter-archives-based-on-a-mirror-site}

미러에서 [SDK 아카이브][SDK archive]에서 Flutter를 다운로드하려면, 
`storage.googleapis.com`을 신뢰할 수 있는 미러의 URL로 바꾸세요. 
브라우저나 IDM 또는 Thunder와 같은 다른 애플리케이션에서 미러 사이트를 사용하세요. 
이렇게 하면 다운로드 속도가 향상될 것입니다.

[SDK archive]: /release/archive

다음 예는 Flutter 다운로드 사이트의 URL을 Google 보관소에서, 
CFUG 미러 사이트로 변경하는 방법을 보여줍니다.

{% tabs "china-setup-os" %}

{% for os in os-list %}
{% tab os %}

{% include docs/community/china/download-urls.md ref-os=os filepath=sdk-path %}

{% endtab %}
{% endfor -%}

{% endtabs %}

:::note
일부 미러는 직접 URL을 사용하여 아티팩트를 다운로드하는 것을 지원하지 않습니다.
:::

## 패키지를 게시하기 위해 머신을 구성하세요 {:#configure-your-machine-to-publish-your-package}

`pub.dev`에 패키지를 게시하려면, Google Auth와 `pub.dev` 사이트에 모두 액세스할 수 있어야 합니다.

{% comment %}
From <https://github.com/flutter/website/pull/9338#discussion_r1328077020>
{% endcomment %}

`pub.dev`에 대한 액세스를 활성화하려면:

{% tabs "china-setup-os" %}

{% for os in os-list %}
{% tab os %}

{% include docs/community/china/pub-settings.md os=os filepath=path %}

{% endtab %}
{% endfor -%}

{% endtabs %}

패키지 게시에 대해 자세히 알아보려면, [패키지 게시에 대한 Dart 문서][Dart documentation on publishing packages]를 ​​확인하세요.

[Dart documentation on publishing packages]: {{site.dart-site}}/tools/pub/publishing

## 알려진, 신뢰할 수 있는 커뮤니티 운영 미러 사이트 {:#known-trusted-community-run-mirror-sites}

Flutter 팀은 어떤 미러도 장기적으로 사용할 수 있다고 보장할 수 없습니다. 
다른 미러가 사용 가능해지면 사용할 수 있습니다.

{% for mirror in mirrors %}

<hr>

### {{mirror.group}}

[{{mirror.group}}][]는 `{{mirror.mirror}}` 미러를 유지 관리합니다. 
여기에는 Flutter SDK와 pub 패키지가 포함됩니다.

#### 이 미러를 사용하도록 컴퓨터 구성 (Configure your machine to use a mirror site)

이 미러를 사용하도록 기기를 설정하려면, 다음 명령을 사용하세요.

macOS, Linux 또는 ChromeOS에서:

```console
export PUB_HOSTED_URL={{mirror.urls.pubhosted}};
export FLUTTER_STORAGE_BASE_URL={{mirror.urls.flutterstorage}}
```

Windows에서:

```console
$env:PUB_HOSTED_URL="{{mirror.urls.pubhosted}}";
$env:FLUTTER_STORAGE_BASE_URL="{{mirror.urls.flutterstorage}}"
```

#### 이 미러에 대한 지원 받기 (Get support for this mirror)

`{{mirror.mirror}}` 미러를 사용할 때만 발생하는 문제가 발생하는 경우, 
해당 문제를 [이슈 트래커]({{mirror.urls.issues}})에 보고하세요.

{% endfor %}

{% for mirror in mirrors %}
[{{mirror.group}}]: {{mirror.urls.group}}
{% endfor %}

## 새로운 미러 사이트 호스팅 제안 {:#offer-to-host-a-new-mirror-site}

자체 미러를 설정하는 데 관심이 있으시면, 
[flutter-dev@googlegroups.com](mailto:flutter-dev@googlegroups.com)으로 문의해 도움을 받으세요.