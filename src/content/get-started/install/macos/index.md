---
# title: Choose your first type of app
title: 첫 번째 앱 타입을 선택하세요
# description: Configure your system to develop Flutter on macOS.
description: macOS에서 Flutter를 개발하도록 시스템을 구성하세요.
short-title: macOS
target-list: [iOS, Android, Web, Desktop]
js: [{url: '/assets/js/temp/macos-install-redirector.js'}]
---

{% assign os = 'macos' -%}
{% assign recommend = 'iOS' %}
{% capture rec-target -%}
[{{recommend | strip}}](/get-started/install/{{os | downcase}}/mobile-{{recommend | downcase}})
{%- endcapture %}

<div class="card-grid narrow">
{% for target in target-list %}
  {% case target %}
  {% when "iOS", "Android" %}
  {% assign targetlink = target | downcase | prepend: 'mobile-' %}
  {% else %}
  {% assign targetlink = target | downcase %}
  {% endcase %}

  <a class="card card-app-type card-macos" id="install-{{os | downcase}}" href="/get-started/install/{{os | downcase}}/{{targetlink}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase -%}
          {% case icon %}
          {% when 'desktop' -%}
            <span class="material-symbols">laptop_mac</span>
          {% when 'ios' -%}
            <span class="material-symbols">phone_iphone</span>
          {% when 'android' -%}
            <span class="material-symbols">phone_android</span>
          {% when 'web' -%}
            <span class="material-symbols">web</span>
          {% endcase -%}
        </span>
        <span class="text-muted">{{ target }}</span>
        {% if icon == 'ios' -%}
          <div class="card-subtitle">Recommended</div>
        {% endif -%}
      </header>
    </div>
  </a>

{% endfor %}
</div>

당신의 선택은 첫 번째 Flutter 앱을 실행하기 위해, 
Flutter 툴링의 어떤 부분을 구성할지 알려줍니다. 
나중에 추가 플랫폼을 설정할 수 있습니다. 
_선호 사항이 없으면, **{{rec-target}}** 을(를) 선택하세요._

{% render docs/china-notice.md %}
