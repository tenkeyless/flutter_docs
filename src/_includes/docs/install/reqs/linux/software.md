{{include.os}}에서 Flutter를 개발하려면:

{% if include.os == "ChromeOS" %}

1. Chromebook에서 [Linux][]를 활성화하세요.

{% endif %}

1. 다음 도구가 설치되어 있는지 확인하세요.
   `bash`, `file`, `mkdir`, `rm`, `which`

   ```console
   $ which bash file mkdir rm which
   /bin/bash
   /usr/bin/file
   /bin/mkdir
   /bin/rm
   which: shell built-in command
   ```

1. 다음 패키지를 설치하세요:
   [`curl`][curl], [`git`][git], [`unzip`][unzip], [`xz-utils`][xz], [`zip`][zip], `libglu1-mesa`

   ```console
   $ sudo apt-get update -y && sudo apt-get upgrade -y;
   $ sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
   ```

{% case include.target %}
{% when 'desktop' -%}

{% include docs/install/reqs/linux/install-desktop-tools.md devos=include.os %}

{% when 'Android' -%}

1. {{include.target}} 앱을 개발하려면:

   {:type="a"}
   1. Android Studio에 대한 다음 필수 패키지를 설치하세요.

      ```console
      $ sudo apt-get install \
          libc6:amd64 libstdc++6:amd64 \
          libbz2-1.0:amd64 libncurses5:amd64
      ```

   1. Android용 Java 또는 Kotlin 코드를 디버깅하고 컴파일하려면, 
      [Android Studio][] {{site.appmin.android_studio}} 이상을 설치하세요.
      Flutter에는 Android Studio 풀버전이 필요합니다.

{% when 'Web' -%}

1. 웹 앱의 JavaScript 코드를 디버깅하려면 [Google Chrome][]을 설치하세요.

{% render docs/install/accordions/install-chrome-from-cli.md %}

{% endcase -%}

[Linux]: https://support.google.com/chromebook/answer/9145439
[curl]: https://curl.se/
[git]: https://git-scm.com/
[unzip]: https://linux.die.net/man/1/unzip
[xz]: https://xz.tukaani.org/xz-utils/
[zip]: https://linux.die.net/man/1/zip
[Android Studio]: https://developer.android.com/studio/install#linux
[Google Chrome]: https://www.google.com/chrome/dr/download/
