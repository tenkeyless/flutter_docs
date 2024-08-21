---
# title: Add Linux as a target platform for Flutter
title: Flutter의 대상 플랫폼으로 Linux 추가
# description: Configure your system to develop Flutter for Linux.
description: Linux용 Flutter를 개발하기 위해 시스템을 구성하세요.
# short-title: Set up Linux development
short-title: Linux 개발 설정
target-list: [Android, web]
---

Linux를 대상으로 개발 환경을 설정하려면, [시작하기 path][Getting Started path]에 해당하는 가이드나 이미 설정한 플랫폼을 선택하세요.

<div class="card-grid">
{% for target in target-list %}
{% assign targetLink = '/platform-integration/linux/install-linux/install-linux-from-' | append: target | downcase %}
  <a class="card card-app-type card-linux" id="install-{{target | downcase}}" href="{{targetLink}}">
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
        </span>
        <span class="text-muted d-block">
        {{ target }} 및 Linux 데스크톱 앱 만들기
        </span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

[Getting Started path]: /get-started/install
