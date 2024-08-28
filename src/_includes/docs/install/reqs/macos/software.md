
{% assign xcode = '[Xcode][] ' | append: site.appnow.xcode | append: ' : 네이티브 Swift 또는 ObjectiveC 코드를 디버깅하고 컴파일합니다.' %}
{% assign cocoapods = '[CocoaPods][] ' | append: site.appnow.cocoapods | append: ' : 네이티브 앱에서 Flutter 플러그인을 컴파일하여 활성화합니다.' %}
{% capture android -%}
[Android Studio][] {{site.appmin.android_studio}} 이상은 Android용 Java 또는 Kotlin 코드를 디버깅하고 컴파일합니다. 
Flutter에는 Android Studio 전체 버전이 필요합니다.
{% endcapture %}
{% assign chrome = "[Google Chrome][] to debug JavaScript code for web apps." %}
{% assign git-main = '[Git][] ' | append: site.appmin.git_mac | append: ' 이상이 소스코드 관리를 위해 포함됩니다. ' %}
{% assign git-xcode = "Xcode 설치에는 " %}
{% capture git-other -%}
`git`이 설치되어 있는지 확인하려면, 터미널에 `git version`을 입력합니다. 
`git`을 설치해야 하는 경우, `brew install git`을 입력합니다.
{% endcapture %}

{% case include.target %}
{% when 'desktop','iOS' %}

* {{xcode}} {{git-xcode}} {{git-main}}
* {{cocoapods}}

{% when 'Android' %}

* {{android}}
* {{git-main}}
  {{- git-other}}

{% when 'web' -%}

* {{chrome}}
* {{git-main}}
  {{- git-other}}

{% endcase %}

[Git]: https://formulae.brew.sh/formula/git
[Android Studio]: https://developer.android.com/studio/install#mac
[Xcode]: {{site.apple-dev}}/xcode/
[CocoaPods]: https://cocoapods.org/
[Google Chrome]: https://www.google.com/chrome/dr/download/
