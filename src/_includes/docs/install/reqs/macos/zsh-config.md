
<details>
<summary><strong>셸 구성을 확인하려면, 이 섹션을 확장하세요.</strong></summary>

대부분의 UNIX 유사 운영 체제와 마찬가지로, 
macOS는 `bash`, `zsh`, `sh`와 같은 여러 셸을 지원할 수 있습니다. 
macOS Catalina(macOS 10.15)의 2019년 10월 릴리스부터, 
Zsh 또는 `zsh`가 macOS의 기본 셸입니다.

#### `zsh`를 기본값으로 체크하고 설정 {:#check-and-set-zsh-as-default}

1. `zsh`가 기본 macOS 셸로 설정되었는지 확인하려면, [Directory Services 명령줄 유틸리티][dscl]을 실행하세요.

    ```console
    $ dscl . -read ~/ UserShell
    ```

    이 명령은 다음과 같은 응답을 출력합니다.

    ```console
    UserShell: /bin/zsh
    ```

    나머지 단계는 건너뛸 수 있습니다.

2. `zsh`를 설치해야 하는 경우, [이 위키][install-zsh]의 절차를 따르세요.

3. 기본 셸을 `zsh`로 변경해야 하는 경우, `chsh` 명령을 실행하세요.

    ```console
    $ chsh -s `which zsh`
    ```

macOS 및 `zsh`에 대해 자세히 알아보려면, 
macOS 설명서의 [Mac에서 zsh를 기본 셸로 사용하기][zsh-mac]를 확인하세요.

</details>

[install-zsh]: https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
[dscl]: https://ss64.com/mac/dscl.html
