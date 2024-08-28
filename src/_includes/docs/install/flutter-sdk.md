{% case include.target %}
{% when 'mobile-ios' %}
   {% assign v-target = 'iOS' %}
{% when 'mobile-android','mobile' %}
   {% assign v-target = 'Android' %}
{% else %}
   {% assign v-target = include.target %}
{% endcase %}

## Flutter SDK 설치 {:#install-the-flutter-sdk}

Flutter SDK를 설치하려면, VS Code Flutter 확장 프로그램을 사용하거나, 
Flutter 번들을 직접 다운로드하여 설치하면 됩니다.

{% tabs "vs-code-or-download" %}
{% tab "VS Code를 사용하여 설치" %}

{% include docs/install/flutter/vscode.md os=include.os terminal=include.terminal target=v-target %}

{% endtab %}
{% tab "다운로드 및 설치" %}

{% include docs/install/flutter/download.md os=include.os terminal=include.terminal target=v-target %}

{% endtab %}
{% endtabs %}
