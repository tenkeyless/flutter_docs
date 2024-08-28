{% if include.target == 'Android' %}
{% assign mod-target = 'mobile' %}
{% else %}
{% assign mod-target = include.target %}
{% endif %}

{% if mod-target == 'desktop' -%}

* [Visual Studio 2022][]는 네이티브 C++ Windows 코드를 디버깅하고 컴파일합니다. 
  **Desktop development with C++** 워크로드를 설치해야 합니다. 
  이렇게 하면, 모든 기본 구성 요소를 포함하여, Windows 앱을 빌드할 수 있습니다. 
  **Visual Studio**는 **[Visual Studio _Code_][]**와 별도의 IDE입니다.

{% elsif mod-target == 'mobile' -%}

* [Android Studio][] {{site.appmin.android_studio}} 이상은 Android용 Java 또는 Kotlin 코드를 디버깅하고 컴파일합니다. 
  Flutter에는 Android Studio 풀버전이 필요합니다.

{% elsif mod-target == 'web' -%}

* 웹 앱의 JavaScript 코드를 디버깅하려면 [Google Chrome][]을 사용하세요.

{% else -%}

* **Desktop development with C++** 워크로드가 있는 [Visual Studio 2022][] 또는 
  [Visual Studio 2022용 빌드 도구][Build Tools for Visual Studio 2022]. 
  이를 통해 모든 기본 구성 요소를 포함하여, Windows 앱을 빌드할 수 있습니다. 
  **Visual Studio**는 **[Visual Studio _Code_][]**와 별도의 IDE입니다.
* Android용 Java 또는 Kotlin 코드를 디버깅하고 컴파일하려면, 
  [Android Studio][] {{site.appmin.android_studio}} 이상이 필요합니다. 
  Flutter에는 Android Studio 풀버전이 필요합니다.
* 웹 앱용 JavaScript 코드를 디버깅하려면, 최신 버전의 [Google Chrome][]이 필요합니다.

{% endif -%}

[Android Studio]: https://developer.android.com/studio/install#windows
[Visual Studio 2022]: https://learn.microsoft.com/visualstudio/install/install-visual-studio?view=vs-2022
[Build Tools for Visual Studio 2022]: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
[Google Chrome]: https://www.google.com/chrome/dr/download/
[Visual Studio _Code_]: https://code.visualstudio.com/
