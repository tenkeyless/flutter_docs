
{% assign id = include.ref-os | downcase -%}
{% assign mainpath = include.filepath -%}
{%- case id %}
{% when 'windows','macos' %}
{%- assign file-format = 'zip' %}
{% else %}
{%- assign file-format = 'tar.xz' %}
{% endcase %}
{%- if id == 'chromeos' %}
{% assign plat = 'linux' %}
{%- else %}
{% assign plat = id %}
{% endif %}
{% capture filepath -%}{{mainpath | replace: "opsys", plat}}{{file-format}} {% endcapture -%}

Flutter SDK의 {{include.ref-os}} 3.13 버전을 다운로드하려면,
원래 URL을:

```console
https://storage.googleapis.com/{{filepath}}
```

다음과 같이 미러 URL로 변경합니다.

```console
https://storage.flutter-io.cn/{{filepath}}
```
