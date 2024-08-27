---
# title: Add Android as a target platform for Flutter
title: Flutter의 대상 플랫폼으로 Android 추가
# description: Configure your system to develop Flutter for Android.
description: Android용 Flutter를 개발하기 위해 시스템을 구성하세요.
# short-title: Set up Android development
short-title: Android 개발 설정
target-list: [Windows, 'web on Windows', Linux, 'web on Linux', macOS, 'web on macOS', iOS, 'web on ChromeOS']
---

Android를 대상으로 개발 환경을 설정하려면, 
[시작하기 path][Getting Started path]에 해당하는 가이드나 이미 설정한 플랫폼을 선택하세요.

<div class="card-grid">
{% for target in target-list %}
{% assign targetLink = '/platform-integration/android/install-android/install-android-from-' | append: target | downcase | replace: " ", "-" %}

  {% if target contains 'macOS' or target contains 'iOS' %}
    {% assign bug = 'card-macos' %}
  {% elsif target contains 'Windows' %}
    {% assign bug = 'card-windows' %}
  {% elsif target contains 'Linux' %}
    {% assign bug = 'card-linux' %}
  {% elsif target contains 'ChromeOS' %}
    {% assign bug = 'card-chromeos' %}
  {% endif %}

  <a class="card card-app-type {{bug}}" id="install-{{target | downcase}}" href="{{targetLink}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase | replace: " ", "-" -%}
          {% case icon %}
          {% when 'macos' -%}
            <span class="material-symbols">laptop_mac</span>
          {% when 'windows','linux' -%}
            <span class="material-symbols">desktop_windows</span>
          {% when 'ios' -%}
            <span class="material-symbols">phone_iphone</span>
          {% else -%}
            <span class="material-symbols">web</span>
          {% endcase -%}
          <span class="material-symbols">add</span>
          <span class="material-symbols">phone_android</span>
        </span>
        <span class="text-muted d-block">
        Android 및
        {% if target contains "iOS" -%}
        {{target}} 앱 macOS에서 만들기
        {%- elsif target contains "on" -%}
        {{ target | replace: "on", "앱 " }}에서 만들기
        {%- else -%}
        {{target}} 데스크톱 앱 만들기
        {%- endif -%}
        </span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

[Getting Started path]: /get-started/install
