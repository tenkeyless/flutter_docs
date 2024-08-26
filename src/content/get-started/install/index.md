---
# title: Choose your development platform to get started
title: 시작하려면 개발 플랫폼을 선택하세요
# short-title: Install
short-title: 설치
# description: Install Flutter and get started. Downloads available for Windows, macOS, Linux, and ChromeOS operating systems.
description: Flutter를 설치하고 시작하세요. Windows, macOS, Linux, ChromeOS 운영 체제에 대한 다운로드가 가능합니다.
os-list: [Windows, macOS, Linux, ChromeOS]
js: [{url: '/assets/js/page/install-current.js'}]
---

<div class="card-grid narrow">
{% for os in os-list %}
  <a class="card" id="install-{{os | remove: ' ' | downcase}}" href="/get-started/install/{{os | remove: ' ' | downcase}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = os | downcase -%}
            <img src="/assets/images/docs/brand-svg/{{icon}}.svg" width="72" height="72" aria-hidden="true" alt="{{os}} logo"> 
        </span>
        <span class="text-muted text-nowrap">{{os}}</span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

{% render docs/china-notice.md %}
