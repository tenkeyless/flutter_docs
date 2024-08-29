
### Windows Path 변수에서 Flutter 제거 {:#remove-flutter-from-your-windows-path-variable .no_toc}

{{include.terminal}}에서 Flutter 명령을 제거하려면, `PATH` 환경 변수에서 Flutter를 제거하세요.

{% render docs/install/reqs/windows/open-envvars.md %}

1. **User variables for (username)** 섹션에서, **Path** 항목을 찾습니다.

   {:type="a"}
   1. 더블 클릭합니다.

      **Edit Environment Variable** 대화 상자가 표시됩니다.

   2. **%USERPROFILE%\dev\flutter\bin** 항목을 클릭합니다.

   3. **Delete**를 클릭합니다.

   4. **OK**을 세 번 클릭합니다.

2. 이러한 변경 사항을 활성화하려면, 
   기존 명령 프롬프트와 {{include.terminal}} 인스턴스를 닫았다가 다시 엽니다.
