### `PATH`에 Flutter 추가 {:#add-flutter-to-your-path .no_toc}

{{include.terminal}}에서 Flutter 명령을 실행하려면, Flutter를 `PATH` 환경 변수에 추가합니다.

1. 새 콘솔 창을 열 때 어떤 셸이 시작되는지 확인합니다.
   이것이 당신의 _기본 셸_ 입니다.

   ```console
   $ echo $SHELL
   ```

   이는 현재 콘솔에서 어떤 셸이 실행되는지 알려주는 다른 명령과 다릅니다.

   ```console
   $ echo $0
   ```

2. `PATH`에 Flutter를 추가하려면, 기본 셸에 대한 항목을 확장한 다음, 명령을 선택하세요.

{% for shell in shells %}

   <details {% if shell.name == 'bash' %}open{% endif %}>
   <summary><tt>{{shell.name}}</tt> 명령 보기</summary>

   ```console
   $ {{shell.set-path}}
   ```

   {% if shell.name == 'shell' %}
   :::note
   위의 방법이 작동하지 않으면, 로그인이 안된 셸(non-login shell)을 사용하고 있을 수 있습니다. 
   이 경우, 다음의 줄을 ~/.bashrc에 추가합니다. 
   
   `console $ echo 'export PATH="~/development/flutter/bin:$PATH"' >> ~/.bashrc `. 
   
   모든 셸 타입에서 일관성을 유지하려면, 다음을 ~/.bash_profile에 추가하여, ~/.bashrc를 ~/.bash_profile에서 소스합니다. 
   
   ` if [ -f ~/.bashrc ]; then source ~/.bashrc fi `.
   {% endif %}

   </details>

{% endfor %}

1. 이 변경 사항을 적용하려면, 열려 있는 모든 터미널 세션을 다시 시작하세요.
