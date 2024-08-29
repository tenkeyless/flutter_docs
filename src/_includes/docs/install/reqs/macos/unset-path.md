### macOS PATH에서 Flutter 제거 {:#remove-flutter-from-your-macos-path .no_toc}

{{include.terminal}}에서 Flutter 명령을 제거하려면, Flutter를 `PATH` 환경 변수에서 제거하세요. 
이 가이드에서는 [Mac이 최신 기본 셸][zsh-mac], `zsh`를 실행한다고 가정합니다. 
Zsh는 [환경 변수][envvar]에 `.zshenv` 파일을 사용합니다.

1. 원하는 텍스트 편집기를 실행합니다.

1. Zsh 환경 변수 파일 `~/.zshenv`를 엽니다.

1. `~/.zshenv` 파일 끝에서 다음 줄을 제거합니다.

   ```bash
   export PATH=$HOME/development/flutter/bin:$PATH
   ```

2. `~/.zshenv` 파일을 저장합니다.

3. 이 변경 사항을 적용하려면, 열려 있는 모든 터미널 세션을 다시 시작합니다.

다른 셸을 사용하는 경우 [PATH에서 디렉토리를 제거하는 방법에 대한 이 튜토리얼][other-path]를 확인하세요.

[zsh-mac]: https://support.apple.com/en-us/102360
[envvar]: https://zsh.sourceforge.io/Intro/intro_3.html
[other-path]: https://phoenixnap.com/kb/linux-add-to-path
