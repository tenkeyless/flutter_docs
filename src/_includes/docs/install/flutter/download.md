
### Flutter를 다운로드한 후 설치 {:#download-then-install-flutter .no_toc}

{% assign osl = include.os | downcase | replace: "chromeos","linux" %}
{% case include.os %}
{% when 'Windows' -%}
   {% assign unzip='Expand-Archive .\\' %}
   {% assign path='C:\\user\\{username}\\dev' %}
   {% assign flutter-path='C:\\user\\{username}\\dev\\flutter' %}
   {% assign terminal='PowerShell' %}
   {% assign prompt='PS C:\\>' %}
   {% assign prompt2=path | append: '>' %}
   {% assign diroptions='`%USERPROFILE%` (`C:\\Users\\{username}`) or `%LOCALAPPDATA%` (`C:\\Users\\{username}\\AppData\\Local`)' %}
   {% assign dirinstall='`%USERPROFILE%\\dev\\`' %}
   {% assign dirdl='%USERPROFILE%\\Downloads' %}
   {% assign ps-dir-dl='$env:USERPROFILE\\Downloads\\' %}
   {% assign ps-dir-target='$env:USERPROFILE\\dev\\' %}
   {% capture uz %}
     {{prompt}} Expand-Archive `
         –Path {{ps-dir-dl}}flutter_sdk_v1.0.0.zip `
         -Destination {{ps-dir-target}}
   {%- endcapture %}
{% when "macOS" -%}
   {% assign diroptions='`~/development/`' %}
   {% assign dirinstall='`~/development/`' %}
   {% assign unzip='unzip' %}
   {% assign path='~/development/' %}
   {% assign flutter-path='~/development/flutter' %}
   {% assign terminal='the Terminal' %}
   {% assign prompt='\$' %}
   {% assign dirdl='~/Downloads/' %}
   {% capture uz -%}
      {{prompt}} {{unzip}} {{dirdl}}flutter_sdk_v1.0.0.zip \
          -d {{path}}
   {%- endcapture %}
{% else -%}
   {% assign diroptions='`~/development/`' %}
   {% assign dirinstall='`~/development/`' %}
   {% assign unzip='tar' %}
   {% assign path='~/development/' %}
   {% assign flutter-path='~/development/flutter' %}
   {% assign terminal='a shell' %}
   {% assign prompt='\$' %}
   {% assign dirdl='~/Downloads/' %}
   {% capture uz -%}
     {{prompt}} {{unzip}} -xf {{dirdl}}flutter_sdk_v1.0.0.zip -C {{path}}
   {%- endcapture %}
{% endcase -%}

Flutter를 설치하려면, Flutter SDK 번들을 아카이브에서 다운로드하고, 
번들을 저장하려는 위치로 옮긴 다음, SDK를 압축해제합니다.

1. Flutter SDK의 최신 {{site.sdk.channel}} 릴리스를 받으려면 다음 설치 번들을 다운로드하세요.

   {% if include.os=='macOS' %}

   | 인텔                                         | 애플 실리콘  |
   |---------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
   | [(loading...)](#){:.download-latest-link-{{osl}} .btn .btn-primary} | [(loading...)](#){:.download-latest-link-{{osl}}-arm64 .apple-silicon .btn .btn-primary}  |

   {% else %}

   [(loading...)](#){:.download-latest-link-{{osl}} .btn .btn-primary}

   {% endif -%}

   다른 릴리스 채널 및 이전 빌드의 경우, [SDK 아카이브][SDK archive]를 확인하세요.

   Flutter SDK는 {{include.os}} 기본 다운로드 디렉토리인 `{{dirdl}}`에 다운로드되어야 합니다: 
   {% if include.os=='Windows' %}
   다운로드 디렉토리의 위치를 ​​변경한 경우 이 경로를 해당 경로로 바꾸세요. 
   다운로드 디렉토리 위치를 찾으려면, 이 [Microsoft 커뮤니티 게시물][move-dl]을 확인하세요.
   {% endif %}

2. Flutter를 설치할 수 있는 폴더를 만듭니다.

   {{diroptions}}에 디렉토리를 만드는 것을 고려하세요.
   {% if include.os == "Windows" -%}
   {% render docs/install/admonitions/install-paths.md %}
   {% endif %}

3. Flutter SDK를 저장하려는 디렉토리에 파일을 압축해제합니다.

   ```console
   {{uz}}
   ```

   완료되면, Flutter SDK가 `{{flutter-path}}` 디렉토리에 있게 됩니다.

[SDK archive]: /release/archive
[move-dl]: https://answers.microsoft.com/en-us/windows/forum/all/move-download-folder-to-other-drive-in-windows-10/67d58118-4ccd-473e-a3da-4e79fdb4c878

{% case include.os %}
{% when 'Windows' %}
{% include docs/install/reqs/windows/set-path.md terminal=terminal target=include.target %}
{% when 'macOS' %}
{% include docs/install/reqs/macos/set-path.md terminal=terminal target=include.target dir=dirinstall %}
{% else %}
{% include docs/install/reqs/linux/set-path.md terminal=terminal target=include.target %}
{% endcase %}
