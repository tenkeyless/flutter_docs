
{% assign id =  include.os | downcase -%}

1. 프록시를 구성합니다. 
   프록시를 구성하려면, [프록시에 대한 Dart 문서]({{site.dart-site}}/tools/pub/troubleshoot#pub-get-fails-from-behind-a-corporate-firewall)를 확인하세요.

  {% comment %}
  From <https://github.com/flutter/website/issues/2556#issuecomment-481566476>
  {% endcomment %}

1. `PUB_HOSTED_URL` 환경 변수가 설정되지 않았거나 비어 있는지(unset or empty) 확인하세요.

   {% if id == 'windows' -%}

   ```console
   {{prompt}} echo $env:PUB_HOSTED_URL
   ```

   이 명령이 값을 반환하면, 설정을 해제합니다.

   ```console
   {{prompt}} Remove-Item $env:PUB_HOSTED_URL
   ```

   {% else -%}

   ```console
   {{prompt}} echo $PUB_HOSTED_URL
   ```

   이 명령이 값을 반환하면, 설정을 해제합니다.

   ```console
   {{prompt}} unset $PUB_HOSTED_URL
   ```

   {% endif %}
