
## 개발 설정 확인하기 {:#check-your-development-setup}

{% render docs/help-link.md, location:'win-doctor' %}

{% assign compiler = include.compiler %}

{% case include.devos %}
{% when 'Windows' -%}
   {% assign terminal='PowerShell' %}
   {% assign prompt='PS C:\>' %}
{% when "macOS" -%}
   {% assign terminal='your Terminal' %}
   {% assign prompt='$' %}
{% else -%}
   {% assign terminal='a shell' %}
   {% assign prompt='$' %}
{% endcase -%}
{% case include.target %}
{% when 'macOS','Windows','Linux' %}
{% assign work-target = include.target | append: ' desktop' %}
{% when 'desktop' %}
{% assign work-target = include.devos | append: ' desktop' %}
{% else %}
{% assign work-target = include.target | append: ' on ' | append: include.devos %}
{% endcase %}
{% case work-target %}
{% when 'macOS desktop','Web on macOS','iOS on macOS' %}
{% assign compiler = 'Xcode' %}
{% when 'Android on Windows','Android on macOS','Android on Linux' %}
{% assign compiler = 'Android Studio' %}
{% when 'Linux desktop','Web on Linux' %}
{% assign compiler = 'one of the Linux libraries' %}
{% when 'Windows desktop','Web on Windows' %}
{% assign compiler = 'Visual Studio' %}
{% endcase %}

### Flutter doctor 실행 {:#run-flutter-doctor}

`flutter doctor` 명령은 {{include.devos}}에 대한 완전한 Flutter 개발 환경의 모든 구성 요소를 검증합니다.

1. {{terminal}}을 엽니다.

1. 모든 구성 요소의 설치를 확인하려면, 다음 명령을 실행합니다.

   ```console
   {{prompt}} flutter doctor
   ```

{{include.target}}을(를) 개발하기로 선택했으므로, _모든_ 구성 요소가 필요하지 않습니다. 
이 가이드를 따랐다면, 명령의 결과는 다음과 비슷해야 합니다.

{% include docs/install/flutter-doctor-success.md config=include.config devos=include.devos -%}

### Flutter Doctor 문제 해결 {:#troubleshoot-flutter-doctor-issues}

`flutter doctor` 명령이 오류를 반환하는 경우, 
Flutter, VS Code, {{compiler}}, 연결된 기기 또는 네트워크 리소스 때문일 수 있습니다.

`flutter doctor` 명령이 이러한 구성 요소에 대한 오류를 반환하는 경우, 
verbose 플래그를 사용하여 다시 실행합니다.

```console
{{prompt}} flutter doctor -v
```

설치해야 할 다른 소프트웨어나, 수행해야 할 추가 작업에 대한 출력을 확인하세요.

Flutter SDK 또는 관련 구성 요소의 구성을 변경하는 경우, `flutter doctor`를 _다시_ 실행하여 설치를 확인하세요.

<!-- ## Start developing {{work-target}} apps with Flutter -->
## Flutter로 {{work-target}} 앱 개발을 시작하세요

**축하합니다.** 
모든 필수 구성 요소와 Flutter SDK를 설치했으므로, 
이제 {{work-target}}에 대한 Flutter 앱 개발을 시작할 수 있습니다.

학습 여정을 계속하려면, 다음 가이드를 참조하세요.

- [첫 번째 Flutter 앱 작성 방법 알아보기][codelab]
- [Flutter 첫 주 경험][fwe]

[codelab]: /get-started/codelab/
[fwe]: /get-started/fwe/
