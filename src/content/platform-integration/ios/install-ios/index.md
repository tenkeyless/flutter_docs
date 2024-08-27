---
# title: Add iOS as a target platform for Flutter
title: Flutter의 대상 플랫폼으로 iOS 추가
# description: Configure your system to develop Flutter for iOS.
description: iOS용 Flutter를 개발하기 위해 시스템을 구성하세요.
# short-title: Set up iOS development
short-title: iOS 개발 설정
target-list: [macOS, Android, web]
---

iOS를 타겟으로 개발 환경을 설정하려면, [시작하기 path][Getting Started path]에 해당하는 가이드나 이미 설정한 플랫폼을 선택하세요.

<div class="card-grid">
{% for target in target-list %}
{% assign targetLink = '/platform-integration/ios/install-ios/install-ios-from-' | append: target | downcase %}
  <a class="card card-app-type card-macos" id="install-{{target | downcase}}" href="{{targetLink}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase -%}
          {% case icon %}
          {% when 'macos' -%}
            <span class="material-symbols">laptop_mac</span>
          {% when 'android' -%}
            <span class="material-symbols">phone_android</span>
          {% when 'web' -%}
            <span class="material-symbols">web</span>
          {% endcase -%}
          <span class="material-symbols">add</span>
          <span class="material-symbols">phone_iphone</span>
        </span>
        <span class="text-muted d-block">
        iOS 및 {{ target }}{% if target == 'macOS' %} 데스크톱{% endif %} 앱 만들기
        </span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

[Getting Started path]: /get-started/install
