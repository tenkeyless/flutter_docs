#### iOS 시뮬레이터 구성 {:#configure-your-ios-simulator}

iOS 시뮬레이터에서 Flutter 앱을 실행하고 테스트할 준비를 하려면, 다음 절차를 따르세요.

1. iOS 시뮬레이터를 설치하려면 다음 명령을 실행하세요.

    ```console
    {{prompt1}} xcodebuild -downloadPlatform iOS
    ```

2. 시뮬레이터를 시작하려면, 다음 명령을 실행하세요.

    ```console
    $ open -a Simulator
    ```

3. 시뮬레이터를 64비트 기기를 사용하도록 설정합니다.
   iPhone 5s 이상에 해당합니다.

   * **Xcode**에서, 시뮬레이터 기기 타입을 선택합니다.

     1. **Window** <span aria-label="and then">></span> **Devices and Simulators**로 이동합니다.

        <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>2</kbd>를 누를 수도 있습니다.

     2. **Devices and Simulators** 대화 상자가 열리면 **Simulators**를 클릭합니다.

     3. 왼쪽 리스트에서 **Simulator**를 선택하거나, **+** 를 눌러 새 시뮬레이터를 만듭니다.

   * **Simulator** 앱에서 **File** <span aria-label="and then">></span> **Open Simulator** <span aria-label="and then">></span>로 이동합니다. 
     대상 iOS 기기를 선택합니다.

   * 시뮬레이터에서 기기 버전을 확인하려면, **Settings** 앱 <span aria-label="그리고">></span> **General** <span aria-label="그리고">></span> **About**를 엽니다.

4. 시뮬레이션된 고화면 밀도 iOS 기기가 화면을 오버플로우 할 수 있습니다. 
   Mac에서 그런 현상이 나타나면, **Simulator** 앱에서 표시된 크기를 변경하세요.

    | **디스플레이 크기**  |                          **메뉴 명령**                          |     **키보드 단축키**     |
    |:-----------------:|:------------------------------------------------------------------:|:-----------------------------:|
    | Small             | **Window** <span aria-label="and then">></span> **Physical Size**  | <kbd>Cmd</kbd> + <kbd>1</kbd> |
    | Moderate          | **Window** <span aria-label="and then">></span> **Point Accurate** | <kbd>Cmd</kbd> + <kbd>2</kbd> |
    | HD accurate       | **Window** <span aria-label="and then">></span> **Pixel Accurate** | <kbd>Cmd</kbd> + <kbd>3</kbd> |
    | Fit to screen     | **Window** <span aria-label="and then">></span> **Fit Screen**     | <kbd>Cmd</kbd> + <kbd>4</kbd> |
    
    {:.table .table-striped}

