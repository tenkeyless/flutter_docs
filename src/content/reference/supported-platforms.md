---
# title: Supported deployment platforms
title: 지원되는 배포 플랫폼
# short-title: Supported platforms
short-title: 지원되는 플랫폼
# description: The platforms that Flutter supports by platform version.
description: Flutter가 지원하는 플랫폼 버전입니다.
---

Flutter {{site.appnow.flutter}}부터, 
Flutter는 다음 하드웨어 아키텍처와 운영 체제 버전의 조합으로 앱을 배포하는 것을 지원합니다. 
이러한 조합을 _플랫폼_ 이라고 합니다.

Flutter는 3단계의 플랫폼을 지원합니다.

* **지원됨 (Supported)**: Flutter 팀은 모든 커밋에서 이러한 플랫폼을 테스트합니다.
* **최선의 노력 (Best effort)**: Flutter 팀은 코딩 관행을 통해 이러한 플랫폼을 지원하려고 합니다. 
  팀은 이러한 플랫폼을 임시 기준(ad-hoc basis)으로 테스트합니다.
* **지원되지 않음 (Unsupported)**: Flutter 팀은 이러한 플랫폼을 테스트하거나 지원하지 않습니다.

이러한 단계에 따라, Flutter는 다음 플랫폼에 배포하는 것을 지원합니다.

{% assign opsys = platforms %}

| 타겟 플랫폼 | 하드웨어 아키텍쳐 | 지원되는 버전 | 최선의 노력 버전 | 지원되지 않는 버전 |
|---|:---:|:---:|:---:|:---:|
{%- for platform in opsys %}
  | {{platform.platform}} | {{platform.chipsets}} | {{platform.supported}} | {{platform.besteffort}} | {{platform.unsupported}} |
{%- endfor %}

{:.table .table-striped}
