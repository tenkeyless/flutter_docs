---
# title: Use the debugger
title: 디버거 사용
# description: How to use DevTools' source-level debugger.
description: DevTools의 소스 레벨 디버거를 사용하는 방법.
---

:::note
VS Code에 내장된 디버거가 있기 때문에, 
앱이 VS Code에서 시작된 경우 DevTools는 디버거 탭을 숨깁니다.
:::

## 시작하기 {:#getting-started}

DevTools에는 중단점, stepping, 변수 검사를 지원하는 전체 소스 레벨 디버거가 포함되어 있습니다.

:::note
디버거는 모든 Flutter 및 Dart 애플리케이션에서 작동합니다. 
Android 앱 프로세스 내에서 실행되는 Flutter 엔진을 원격으로 디버깅하기 위해 GDB를 사용할 방법을 찾고 있다면, 
[`flutter_gdb`][]를 확인하세요.
:::

[`flutter_gdb`]: {{site.repo.engine}}/blob/main/sky/tools/flutter_gdb

디버거 탭을 열면, 디버거에 로드된 앱의 주요 진입점에 대한 소스가 표시됩니다.

더 많은 애플리케이션 소스를 탐색하려면 **Libraries**(오른쪽 상단)를 클릭하거나, 
<kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>P</kbd>를 누릅니다. 
그러면 라이브러리 창이 열리고 다른 소스 파일을 검색할 수 있습니다.

![Screenshot of the debugger tab](/assets/images/docs/tools/devtools/debugger_screenshot.png){:width="100%"}

## 중단점 설정 {:#setting-breakpoints}

중단점을 설정하려면, 소스 영역에서 왼쪽 여백(줄 번호 눈금자)을 클릭합니다. 
한 번 클릭하면 중단점이 설정되고, 왼쪽의 **Breakpoints** 영역에도 표시됩니다. 
다시 클릭하면 중단점이 제거됩니다.

## 호출 스택 및 변수 영역 {:#the-call-stack-and-variable-areas}

애플리케이션이 중단점에 부딪히면, 해당 지점에서 일시 정지하고, 
DevTools 디버거는 소스 영역에 일시 정지된 실행 위치를 표시합니다. 
또한 `Call stack` 및 `Variables` 영역은 일시 정지된 isolate에 대한, 
현재 호출 스택과 선택한 프레임에 대한 로컬 변수로 채워집니다. 
`Call stack` 영역에서 다른 프레임을 선택하면 변수의 내용이 변경됩니다.

`Variables` 영역 내에서, 개별 객체를 토글하여 열어서 필드를 확인하여 검사할 수 있습니다. 
`Variables` 영역에서 객체 위에 마우스를 올리면, 해당 객체에 대한 `toString()`이 호출되고 결과가 표시됩니다.

## 소스 코드 단계별 실행 {:#stepping-through-source-code}

일시 정지하면, 세 개의 stepping 버튼이 활성화됩니다.

* **Step in**을 사용하여 메서드 호출에 들어가, 호출된 메서드의 첫 번째 실행 가능 줄에서 멈춥니다.
* **Step over**를 사용하여 메서드 호출을 스텝 오버합니다. 이는 현재 메서드의 소스 줄을 단계별로 실행합니다.
* **Step out**을 사용하여, 중간 줄에서 멈추지 않고, 현재 메서드에서 스텝 아웃합니다.

또한, **Resume** 버튼은 애플리케이션의 일반 실행을 계속합니다.

## 콘솔 출력 {:#console-output}

실행 중인 앱의 콘솔 출력(stdout 및 stderr)은 소스 코드 영역 아래 콘솔에 표시됩니다. 
[Logging 뷰][Logging view]에서도 출력을 볼 수 있습니다.

## 예외에 대한 중단 {:#breaking-on-exceptions}

예외 시 중지 동작을 조정하려면, 디버거 뷰 상단의 **Ignore** 드롭다운을 토글합니다.

처리되지 않은 예외에서 중단하면, 중단점이 애플리케이션 코드에서 포착되지 않은 것으로 간주되는 경우에만, 
실행이 일시 중지됩니다. 
모든 예외에서 중단하면 중단점이 애플리케이션 코드에서 포착되었는지 여부에 관계없이 디버거가 일시 중지됩니다.

## 알려진 문제 {:#known-issues}

Flutter 애플리케이션에서 핫 리스타트을 수행하면, 사용자 중단점이 지워집니다.

[Logging view]: /tools/devtools/logging

## 기타 리소스 {:#other-resources}

디버깅 및 프로파일링에 대한 자세한 내용은 [디버깅][Debugging] 페이지를 참조하세요.

[Debugging]: /testing/debugging
