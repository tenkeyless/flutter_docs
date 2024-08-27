---
# title: DevTools release notes
title: DevTools 릴리스 노트
# description: Learn about the latest changes in Dart and Flutter DevTools.
description: Dart 및 Flutter DevTools의 최신 변경 사항에 대해 알아보세요.
toc: false
---

이 페이지는 DevTools의 공식 stable 릴리스의 변경 사항을 요약합니다. 
변경 사항의 전체 리스트를 보려면, [DevTools git 로그]({{site.repo.organization}}/devtools/commits/master)를 확인하세요.

Dart 및 Flutter SDK에는 DevTools가 포함되어 있습니다. 
DevTools의 현재 버전을 확인하려면 명령줄에서 다음을 실행하세요.

```console
$ dart devtools --version
```

### 릴리즈 노트 {:#release-notes}

{% comment %}
When adding the release notes for a new DevTools release,
make sure to add the version number as an entry to the list
found at `/src/_data/devtools_releases.yml`.
{% endcomment -%}

{% assign releases = devtools_releases.releases %}

{% for release in releases -%}
* [{{release}} 릴리즈 노트](/tools/devtools/release-notes/release-notes-{{release}})
{% endfor -%}
