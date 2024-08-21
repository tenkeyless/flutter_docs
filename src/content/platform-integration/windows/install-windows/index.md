---
# title: Add Windows as a target platform for Flutter
title: Flutter의 대상 플랫폼으로 Windows 추가
# description: Configure your system to develop Flutter for Windows.
description: Windows용 Flutter를 개발하기 위해 시스템을 구성하세요.
# short-title: Set up Windows development
short-title: Windows 개발 설정
target-list: [Android, web]
---

Windows를 대상으로 개발 환경을 설정하려면, [시작하기 path][Getting Started path]에 해당하는 가이드나 이미 설정한 플랫폼을 선택하세요.

<div class="card-grid">
{% for target in target-list %}
{% assign targetLink = '/platform-integration/windows/install-windows/install-windows-from-' | append: target | downcase %}
  <a class="card card-app-type card-windows" id="install-{{target | downcase}}" href="{{targetLink}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase -%}
          {% case icon %}
          {% when 'android' -%}
            <span class="material-symbols">phone_android</span>
          {% when 'web' -%}
            <span class="material-symbols">web</span>
          {% endcase -%}
          <span class="material-symbols">add</span>
          <span class="material-symbols">desktop_windows</span>
        </span>
        <span class="text-muted d-block">
        Windows 데스크톱 및 {{ target }} 앱 만들기
        </span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

[Getting Started path]: /get-started/install
