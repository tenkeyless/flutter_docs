---
# title: Choose your first type of app
title: 첫 번째 앱 타입을 선택하세요
# description: Configure your system to develop Flutter on Linux.
description: Linux에서 Flutter를 개발하도록 시스템을 구성하세요.
short-title: Linux
target-list: [Android, Web, Desktop]
js: [{url: '/assets/js/temp/linux-install-redirector.js'}]
---

{% assign os = 'linux' -%}
{% assign recommend = 'Android' %}
{% capture rec-target -%}
[{{recommend}}](/get-started/install/{{os | downcase}}/{{recommend | downcase}})
{%- endcapture %}

<div class="card-grid narrow">
{% for target in target-list %}
  <a class="card card-app-type card-linux" id="install-{{os | remove: ' ' | downcase}}" href="/get-started/install/{{os | remove: ' ' | downcase}}/{{target | downcase}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase -%}
          {% if icon == 'desktop' -%}
            <span class="material-symbols">desktop_windows</span>
          {% elsif icon == 'android' -%}
            <span class="material-symbols">phone_android</span>
          {% else -%}
            <span class="material-symbols">web</span>
          {% endif -%}
        </span>
        <span class="text-muted text-nowrap">{{target}}</span>
        {% if icon == 'android' -%}
          <div class="card-subtitle">Recommended</div>
        {% endif -%}
      </header>
    </div>
  </a>
{% endfor %}
</div>

당신의 선택은 첫 번째 Flutter 앱을 실행하기 위해 Flutter 툴링의 어떤 부분을 구성할지 알려줍니다. 
나중에 추가 플랫폼을 설정할 수 있습니다. 
_선호 사항이 없으면 **{{rec-target}}** 을 선택하세요._

{% render docs/china-notice.md %}
