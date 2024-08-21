---
# title: Set up web development for Flutter
title: Flutter를 위한 웹 개발 설정
# description: Configure your system to develop Flutter for the web.
description: 웹용 Flutter를 개발하기 위해 시스템을 구성하세요.
# short-title: Set up web development
short-title: 웹 개발 설정
target-list: [windows-desktop, android-on-windows, linux-desktop, android-on-linux, macos-desktop, android-on-macos, ios-on-macos, android-on-chromeos]
---

웹을 타겟팅하여 개발 환경을 설정하려면, [시작하기 path][Getting Started path]에 해당하는 가이드나 이미 설정한 플랫폼을 선택하세요.

<div class="card-grid">
{% for target in target-list %}
{% assign targetLink = '/platform-integration/web/install-web/install-web-from-' | append: target | downcase %}
  {% if target contains 'macos' or target contains 'ios' %}
    {% assign bug = 'card-macos' %}
  {% elsif target contains 'windows' %}
    {% assign bug = 'card-windows' %}
  {% elsif target contains 'linux' %}
    {% assign bug = 'card-linux' %}
  {% elsif target contains 'chrome' %}
    {% assign bug = 'card-chromeos' %}
  {% endif %}

  <a class="card card-app-type {{bug}}" id="install-{{target | downcase}}" href="{{targetLink}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase -%}
          {% case icon %}
          {% when 'macos-desktop' -%}
            <span class="material-symbols">laptop_mac</span>
          {% when 'ios-on-macos' -%}
            <span class="material-symbols">phone_iphone</span>
          {% when 'windows-desktop','linux-desktop' -%}
            <span class="material-symbols">desktop_windows</span>
          {% else -%}
            <span class="material-symbols">phone_android</span>
          {% endcase -%}
          <span class="material-symbols">add</span>
          <span class="material-symbols">web</span>
        </span>
        <span class="text-muted d-block">
        웹 및
        {{ target | replace: "-", " " | capitalize | replace: "Macos",
        "macOS" | replace: "macos", "macOS에서 만들기" | replace: "Ios", "iOS" |
        replace: "windows", "Windows에서 만들기" | replace: "linux", "Linux에서 만들기" | replace: "chromeos", "ChromeOS에서 만들기" | 
        replace: "on", "앱 " | replace: "desktop", "데스크톱 앱 만들기" }}
        </span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

[Getting Started path]: /get-started/install
