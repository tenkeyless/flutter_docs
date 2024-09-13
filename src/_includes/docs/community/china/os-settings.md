{% assign id = include.ref-os | downcase -%}
{% assign jsonurl = 'https://storage.googleapis.com/flutter_infra_release/releases/releases_{{id}}.json' %}
{% assign os = include.ref-os -%}
{% assign sdk = include.sdk -%}

{% if id == 'windows' -%}
   {% assign shell = 'Powershell' -%}
   {% assign prompt = 'C:\>' -%}
   {% assign comtoset = '$env:' -%}
   {% assign installdirsuggestion = '`%USERPROFILE%\dev`' %}
   {% capture envvarset -%}{{prompt}} {{comtoset}}{% endcapture -%}
   {% capture setpath -%}{{envvarset}}PATH = $pwd.PATH + "/flutter/bin",$env:PATH -join ";"{% endcapture -%}
   {% capture newdir -%}{{prompt}} New-Item -Path '{{installdirsuggestion}}' -ItemType Directory{% endcapture -%}
   {% capture unzip -%} {{prompt}} Expand-Archive .\{% endcapture -%}
   {% capture permaddexample -%}
$newPath = $pwd.PATH + "/flutter/bin",$env:PATH -join ";"
[System.Environment]::SetEnvironmentVariable('Path',$newPath,User)
[System.Environment]::SetEnvironmentVariable('PUB_HOSTED_URL','https://pub.flutter-io.cn',User)
[System.Environment]::SetEnvironmentVariable('FLUTTER_STORAGE_BASE_URL','https://storage.flutter-io.cn',User)
   {% endcapture -%}
{% else -%}
   {% assign shell = '당신의 terminal' -%}
   {% assign prompt = '$' -%}
   {% assign comtoset = 'export ' -%}
   {% assign installdirsuggestion = '`~/dev`' %}
   {% capture envvarset -%}{{prompt}} {{comtoset}}{% endcapture -%}
   {% capture setpath -%}{{envvarset}}PATH="$PWD/flutter/bin:$PATH"{% endcapture -%}
   {% capture newdir -%}{{prompt}} mkdir ~/dev{% endcapture -%}
   {% if id == 'macos' %}
      {% capture unzip -%} {{prompt}} unzip {% endcapture -%}
   {% else %}
      {% capture unzip -%} {{prompt}} tar -xf {% endcapture -%}
   {% endif %}
   {% capture permaddexample -%}
cat <<EOT >> ~/.zprofile
{{envvarset}}PUB_HOSTED_URL="https://pub.flutter-io.cn"
{{envvarset}}FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
{{setpath}}
EOT
   {% endcapture -%}
{% endif -%}
{%- case id %}
   {% when 'windows','macos' %}
      {%- assign file-format = 'zip' %}
      {%- assign download-os = id %}
   {% when 'linux','chromeos' %}
      {%- assign download-os = 'linux' %}
      {%- assign file-format = 'tar.xz' %}
{% endcase %}

이 절차에서는 {{shell}}을 사용해야 합니다.

1. {{shell}}에서 새 창을 열어 실행 스크립트를 준비합니다.

2. `PUB_HOSTED_URL`을 미러 사이트로 설정합니다.

   ```console
   {{envvarset}}PUB_HOSTED_URL="https://pub.flutter-io.cn"
   ```

3. `FLUTTER_STORAGE_BASE_URL`을 미러 사이트로 설정합니다.

   ```console
   {{envvarset}}FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
   ```

4. 미러 사이트에서 Flutter 아카이브를 다운로드합니다. 
   선호하는 브라우저에서, [Flutter SDK 아카이브](https://docs.flutter.cn/release/archive?tab={{id}})로 이동합니다.

5. Flutter를 설치할 수 있는 폴더를 만듭니다. 그런 다음 폴더로 변경합니다.

   {{installdirsuggestion}}과 같은 경로를 고려합니다.

   ```console
   {{newdir}}; cd {{installdirsuggestion}}
   ```

6. {{file-format}} 보관 파일에서 SDK를 압축 해제합니다.

   이 예에서는 Flutter SDK의 {{os}} 버전을 다운로드했다고 가정합니다.

   ```console
   {{unzip}}{{sdk | replace: "opsys", download-os}}{{file-format}}
   ```

7. `PATH` 환경 변수에 Flutter를 추가합니다.

   ```console
   {{setpath}}
   ```

8. Flutter Doctor를 실행하여 설치를 확인하세요.

   ```console
   {{prompt}} flutter doctor
   ```

9. [Flutter 설정](/get-started/editor) 가이드로 돌아가서 해당 절차를 계속 진행합니다.

이 예에서, `flutter pub get`은, 
`PUB_HOSTED_URL`과 `FLUTTER_STORAGE_BASE_URL`을 설정한 모든 터미널에서, 
`flutter-io.cn`에서 패키지를 가져옵니다.

이 절차에서 `{{comtoset}}`를 사용하여 설정된 모든 환경 변수는 현재 창에만 적용됩니다.

이러한 값을 영구적으로 설정하려면, 
{% if id == 'windows' -%}
다음 예와 같이 환경 변수를 설정하세요.
{% else -%}
선호하는 셸에서 사용하는 `*rc` 또는 `*profile` 파일에 이 세 개의 `export` 명령을 추가합니다. 
이는 다음과 유사합니다.
{% endif -%}

```console
{{permaddexample}} 
```
