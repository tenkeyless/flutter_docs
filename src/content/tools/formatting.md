---
# title: Code formatting
title: 코드 포맷팅
# description: >
#     Flutter's code formatter formats your code
#     following recommended style guidelines.
description: >
    Flutter의 코드 포매터는 권장되는 스타일 가이드라인에 따라 코드의 형식을 지정합니다.
---

당신의 코드는 선호하는 스타일을 따를 수 있지만, (경험상) 개발자 팀은 다음을 더 생산적으로 여길 수 있습니다.

* 단일 공유 스타일을 사용하고,
* 자동 서식을 통해 이 스타일을 적용합니다.

대안은 코드 검토 중에 지루한 서식 논쟁을 벌이는 경우가 많으며, 
코드 스타일보다는 코드 동작에 시간을 더 많이 할애하는 것이 좋습니다.

## VS Code에서 코드 자동 포맷팅 {:#automatically-formatting-code-in-vs-code}

VS Code에서 코드 자동 포맷을 적용하려면, `Flutter` 확장 프로그램을 설치하세요.
([편집기 설정](/get-started/editor) 참조) 

현재 소스 코드 창에서 코드를 자동으로 서식 지정하려면, 
코드 창에서 마우스 오른쪽 버튼을 클릭하고 `Format Document`을 선택하세요. 
이 VS Code **Preferences**에 키보드 단축키를 추가할 수 있습니다.

파일을 저장할 때마다 코드를 자동으로 서식 지정하려면, 
`editor.formatOnSave` 설정을 `true`로 설정하세요.

## Android Studio 및 IntelliJ에서 코드 자동 포맷팅 {:#automatically-formatting-code-in-android-studio-and-intellij}

Android Studio와 IntelliJ에서 코드의 자동 서식을 얻으려면, `Dart` 플러그인을 설치하세요. 
([편집기 설정](/get-started/editor) 참조) 
현재 소스 코드 창에서 코드를 서식 지정하려면:

* macOS에서, <kbd>Cmd</kbd> + <kbd>Option</kbd> + <kbd>L</kbd>을 누릅니다.
* Windows와 Linux에서, <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>L</kbd>을 누릅니다.

Android Studio와 IntelliJ는 또한 macOS의 **Preferences** 또는 Windows와 Linux의 **Settings**에 있는, Flutter 페이지에서 **Format code on save**이라는 체크박스를 제공합니다. 
이 옵션은 현재 파일을 저장할 때 서식을 수정합니다.

## `dart` 명령을 사용하여 코드 자동 포맷팅 {:#automatically-formatting-code-with-the-dart-command}

명령줄 인터페이스(CLI)에서 코드 형식을 수정하려면, `dart format` 명령을 실행하세요.

```console
$ dart format path1 path2 [...]
```

## trailing 쉼표 사용 {:#using-trailing-commas}

Flutter 코드는 종종 (`build` 메서드와 같이) 상당히 깊은 트리 모양의 데이터 구조를 구축하는 것을 포함합니다. 
좋은 자동 서식을 얻으려면, 선택 사항인 *마지막 쉼표*를 채택하는 것이 좋습니다. 
마지막 쉼표를 추가하는 지침은 간단합니다. 
항상 함수, 메서드 및 생성자에서 매개변수 목록의 끝에 마지막 쉼표를 추가하여 만든 서식을 유지해야 합니다. 
이렇게 하면, 자동 서식 지정기가 Flutter 스타일 코드에 적절한 양의 줄 바꿈을 삽입하는 데 도움이 됩니다.

다음은 마지막 쉼표가 *있는* 자동 서식 지정 코드의 예입니다.

![Automatically formatted code with trailing commas](/assets/images/docs/tools/android-studio/trailing-comma-with.png){:width="100%"}

그리고, 동일한 코드를 끝에 쉼표 *없이* 자동으로 코드를 포맷한 것의 예입니다.

![Automatically formatted code without trailing commas](/assets/images/docs/tools/android-studio/trailing-comma-without.png){:width="100%"}
