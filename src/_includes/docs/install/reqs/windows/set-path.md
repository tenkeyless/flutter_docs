
### Windows PATH 변수 업데이트 {:#update-your-windows-path-variable .no_toc}

{% render docs/help-link.md, location:'win-path', section:'#unable-to-find-the-flutter-command' %}

{{include.terminal}}에서 Flutter 명령을 실행하려면, Flutter를 `PATH` 환경 변수에 추가합니다. 
이 섹션에서는 `%USERPROFILE%\dev\flutter`에 Flutter SDK를 설치했다고 가정합니다.

{% render docs/install/reqs/windows/open-envvars.md %}

1. **User variables for (username)** 섹션에서 **Path** 항목을 찾습니다.

   {:type="a"}
   1. 항목이 있으면, 두 번 클릭합니다.

      **Edit Environment Variable** 대화 상자가 표시됩니다.

      {:type="i"}

      1. 빈 행을 두 번 클릭합니다.

      2. `%USERPROFILE%\dev\flutter\bin`을 입력합니다.

      3. **%USERPROFILE%\dev\flutter\bin** 항목을 클릭합니다.

      4. Flutter 항목이 목록 맨 위에 올 때까지, **Move Up**을 클릭합니다.

      5. **OK**을 세 번 클릭합니다.

   2. 항목이 없으면 **New...** 를 클릭합니다.

      **Edit Environment Variable** 대화 상자가 표시됩니다.

      {:type="i"}
      1. **Variable Name** 상자에 `Path`를 입력합니다.

      2. **Variable Value** 상자에 `%USERPROFILE%\dev\flutter\bin`을 입력합니다.

      3. **OK**을 세 번 클릭합니다.

2. 이러한 변경 사항을 활성화하려면, 기존 명령 프롬프트와 {{include.terminal}} 인스턴스를 닫았다가 다시 엽니다.
