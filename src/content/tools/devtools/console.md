---
# title: Use the Debug console
title: 디버그 콘솔 사용
# description: Learn how to use the DevTools console.
description: DevTools 콘솔을 사용하는 방법을 알아보세요.
---

DevTools 디버그 콘솔을 사용하면 애플리케이션의 표준 출력(stdout)을 보고, 
디버그 모드에서 일시 중지되거나 실행 중인 앱의 표현식을 평가하고, 
객체에 대한 인바운드 및 아웃바운드 참조를 분석할 수 있습니다.

:::note
이 페이지는 DevTools 2.23.0에 맞춰 최신 상태입니다.
:::

디버그 콘솔은 [Inspector][], [Debugger][] 및 [Memory][] 뷰에서 사용할 수 있습니다.

[Inspector]: /tools/devtools/inspector
[Debugger]:  /tools/devtools/debugger
[Memory]:    /tools/devtools/memory

## 애플리케이션 출력 보기 {:#watch-application-output}

콘솔은 애플리케이션의 표준 출력(`stdout`)을 보여줍니다.

![Screenshot of stdout in Console view](/assets/images/docs/tools/devtools/console-stdout.png)

## 검사된 위젯 탐색 {:#explore-inspected-widgets}

**Inspector** 화면에서 위젯을 클릭하면, 해당 위젯의 변수가 **Console**에 표시됩니다.

![Screenshot of inspected widget in Console view](/assets/images/docs/tools/devtools/console-inspect-widget.png){:width="100%"}

## 표현식 평가 {:#evaluate-expressions}

콘솔에서, 디버그 모드에서 앱을 실행 중이라고 가정하고, 
일시 중지된 애플리케이션이나 실행 중인 애플리케이션에 대한 표현식을 평가할 수 있습니다.

![Screenshot showing evaluating an expression in the console](/assets/images/docs/tools/devtools/console-evaluate-expressions.png)

평가된 객체를 변수에 할당하려면, `var x = $0` 형식으로 `$0`, `$1`(~`$5`)을 사용합니다.

![Screenshot showing how to evaluate variables](/assets/images/docs/tools/devtools/console-evaluate-variables.png){:width="100%"}

## 힙 스냅샷 탐색 {:#browse-heap-snapshot}

힙 스냅샷에서 콘솔로 변수를 드롭하려면, 다음을 수행합니다.

1. **Devtools > Memory > Diff Snapshots**로 이동합니다.
2. 메모리 힙 스냅샷을 기록합니다.
3. 컨텍스트 메뉴 `[⋮]`를 클릭하여 원하는 **Class**에 대한 **Instances** 수를 확인합니다.
4. 단일 인스턴스를 콘솔 변수로 저장할지, 아니면 앱에서 현재 활성화된 _모든_ 인스턴스를 저장할지 선택합니다.

![Screenshot showing how to browse the heap snapshots](/assets/images/docs/tools/devtools/browse-heap-snapshot.png){:width="100%"}

콘솔 화면에는 라이브 및 static 인바운드 및 아웃바운드 참조와 필드 값이 모두 표시됩니다.

![Screenshot showing inbound and outbound references in Console](/assets/images/docs/tools/devtools/console-references.png){:width="100%"}

