## Flutter SDK 관리 {:#manage-your-flutter-sdk}

Flutter SDK 설치 관리에 대한 자세한 내용은, 다음 리소스를 참조하세요.


{% assign choice = include.config %}
{% assign next-step = doctor[include.config] %}
{% assign mod-target = include.target | remove: 'mobile-' | downcase %}
{% if mod-target == 'desktop' %}
  {% assign webtarget = include.devos | append: '-desktop' | downcase %}
  {% assign andtarget = include.devos | downcase %}
  {% assign mod-target = include.devos | downcase %}
{% elsif mod-target == 'web' %}
  {% assign andtarget = 'web-on-' | append: include.devos | downcase %}
{% else %}
  {% assign webtarget = mod-target | append: '-on-' | append: include.devos | downcase %}
  {% assign andtarget = include.devos | downcase %}
{% endif %}

* [Flutter 업그레이드][upgrade]
{%- case next-step.add-android %}
{%- when 'Y' %}
* [Android 컴파일 도구 추가](/platform-integration/android/install-android/install-android-from-{{andtarget}})
{%- endcase %}
{%- case next-step.add-chrome %}
{%- when 'Y' %}
* [웹 디버깅 도구 추가](/platform-integration/web/install-web/install-web-from-{{webtarget}})
{%- endcase %}
{%- case next-step.add-simulator %}
{%- when 'Y' %}
* [iOS 시뮬레이터 또는 장치 추가](/platform-integration/ios/install-ios/install-ios-from-{{mod-target}})
{%- endcase %}
{%- case next-step.add-xcode %}
{%- when 'Y' %}
* [macOS 컴파일 도구 추가](/platform-integration/macos/install-macos/install-macos-from-{{mod-target}})
{%- endcase %}
{%- case next-step.add-linux-tools %}
{%- when 'Y' %}
* [Linux 컴파일 도구 추가](/platform-integration/linux/install-linux/install-linux-from-{{mod-target}})
{%- endcase %}
{%- case next-step.add-visual-studio %}
{%- when 'Y' %}
* [Windows 데스크톱 컴파일 도구 추가](/platform-integration/windows/install-windows/install-windows-from-{{mod-target}})
{%- endcase %}
* [Flutter 제거][uninstall]

[upgrade]: /release/upgrade
[uninstall]: /get-started/uninstall?tab={{include.devos}}
