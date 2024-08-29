
### `PATH`에 Flutter 추가 {:#add-flutter-to-your-path .no_toc}

{{include.terminal}}에서 Flutter 명령을 실행하려면, Flutter를 `PATH` 환경 변수에 추가합니다. 
이 가이드에서는 [Mac이 최신 기본 셸][zsh-mac]인 `zsh`를 실행한다고 가정합니다. 
Zsh는 [환경 변수][envvar]에 `.zshenv` 파일을 사용합니다.

1. 원하는 텍스트 편집기를 실행합니다.

1. 있으면, 텍스트 편집기에서 Zsh 환경 변수 파일 `~/.zshenv`를 엽니다. 없으면 `~/.zshenv`를 만듭니다.

1. 다음 줄을 복사하여 `~/.zshenv` 파일 끝에 붙여 넣습니다.

   ```bash
   export PATH=$HOME/development/flutter/bin:$PATH
   ```

2. `~/.zshenv` 파일을 저장합니다.

3. 이 변경 사항을 적용하려면, 열려 있는 모든 터미널 세션을 다시 시작합니다.

다른 셸을 사용하는 경우, [PATH 설정에 대한 이 튜토리얼][other-path]를 확인하세요.

[zsh-mac]: https://support.apple.com/en-us/102360
[envvar]: https://zsh.sourceforge.io/Intro/intro_3.html
[other-path]: https://www.cyberciti.biz/faq/unix-linux-adding-path/
