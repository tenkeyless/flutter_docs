---
# title: Use the CPU profiler view
title: CPU 프로파일러 뷰 사용
# description: Learn how to use the DevTools CPU profiler view.
description: DevTools CPU 프로파일러 뷰를 사용하는 방법을 알아보세요.
---

:::note
CPU 프로파일러 뷰는 Dart CLI 및 모바일 앱에서만 작동합니다. 
Chrome DevTools를 사용하여 웹 앱의 [성능 분석][analyze performance]을 수행합니다. 
:::

CPU 프로파일러 뷰를 사용하면 Dart 또는 Flutter 애플리케이션에서 세션을 기록하고 프로파일링할 수 있습니다. 
프로파일러는 성능 문제를 해결하거나 앱의 CPU 활동을 일반적으로 이해하는 데 도움이 될 수 있습니다. 
Dart VM은 CPU 샘플(단일 시점의 CPU 호출 스택 스냅샷)을 수집하여, 시각화를 위해 DevTools로 데이터를 보냅니다. 
프로파일러는 많은 CPU 샘플을 함께 집계하여, CPU가 대부분의 시간을 어디에 사용하는지 이해하는 데 도움이 될 수 있습니다.

:::note
**Flutter 애플리케이션을 실행 중이라면, profile 빌드를 사용하여 성능을 분석하세요.** 
Flutter 애플리케이션이 profile 모드에서 실행되지 않는 한, CPU profile은 릴리스 성능을 나타내지 않습니다.
:::

## CPU 프로파일러 {:#cpu-profiler}

**Record**를 클릭하여 CPU 프로필 기록을 시작합니다. 기록이 완료되면, **Stop**을 클릭합니다. 
이 시점에서, CPU 프로파일링 데이터가 VM에서 가져와, 
프로파일러 뷰(호출 트리, Bottom up, Method 테이블, Flame 차트)에 표시됩니다.

수동으로 기록하고 중지하지 않고 사용 가능한 모든 CPU 샘플을 로드하려면, 
**Load all CPU samples**를 클릭하면 됩니다. 
이 경우 VM이 링 버퍼에 기록하고 저장한 모든 CPU 샘플을 가져온 다음, 프로파일러 뷰에 해당 CPU 샘플을 표시합니다.

### Bottom up {:#bottom-up}

이 표는 CPU 프로필의 bottom-up 표현을 제공합니다. 
즉, bottom up 표의 각 최상위 메서드 또는 루트는, 
실제로 하나 이상의 CPU 샘플에 대한 호출 스택의 최상위 메서드입니다. 
즉, bottom up 표의 각 최상위 메서드는 top down 표(호출 트리)의 리프 노드입니다. 
이 표에서, 메서드를 확장하여 _호출자(callers)_ 를 표시할 수 있습니다.

이 뷰는 CPU 프로필에서 비용이 많이 드는 _메서드_ 를 식별하는 데 유용합니다. 
이 표의 루트 노드에 _self_ 시간이 높으면, 
이 프로필의 많은 CPU 샘플이 호출 스택 맨 위에 있는 메서드로 끝났다는 것을 의미합니다.

![Screenshot of the Bottom up view](/assets/images/docs/tools/devtools/bottom-up-view.png)
이 이미지에서 보이는 파란색과 녹색 수직선을 활성화하는 방법을 알아보려면, 
아래의 [가이드라인](#guidelines) 섹션을 참조하세요.

도구 설명은 각 열의 값을 이해하는 데 도움이 될 수 있습니다.

**총 시간 (Total time)**
: bottom-up 트리의 최상위 메서드(최소 한 CPU 샘플의 맨 위에 있는 스택 프레임)의 경우, 
  이는 메서드가 자체 코드를 실행하는 데 소요된 시간과, 호출한 모든 메서드의 코드입니다.

**자체 시간 (Self time)**
: bottom-up 트리의 최상위 메서드(최소 한 CPU 샘플의 맨 위에 있는 스택 프레임)의 경우, 
  이는 메서드가 자체 코드만 실행하는 데 소요된 시간입니다.<br><br> 
  bottom-up 트리(호출자)의 자식 메서드의 경우, 
  이는 자식 메서드(호출자)를 통해 호출될 때 최상위 메서드(호출자)의 자체 시간입니다.

**테이블 요소**(자체 시간)
![Screenshot of a bottom up table](/assets/images/docs/tools/devtools/table-element.png)

### Call 트리 {:#call-tree}

이 표는 CPU 프로필의 top-down 표현을 제공합니다. 
즉, 호출 트리의 각 최상위 메서드는 하나 이상의 CPU 샘플의 루트입니다. 
이 표에서 메서드를 확장하여 _호출 대상(callees)_ 을 표시할 수 있습니다.

이 뷰는 CPU 프로필에서 비용이 많이 드는 _경로(paths)_ 를 식별하는 데 유용합니다. 
이 표의 루트 노드에 _총_ 시간이 높으면, 
이 프로필의 많은 CPU 샘플이 호출 스택의 맨 아래에 있는 해당 메서드에서 시작되었음을 의미합니다.

![Screenshot of a call tree table](/assets/images/docs/tools/devtools/call-tree.png)
이 이미지에서 보이는 파란색과 녹색 수직선을 활성화하는 방법을 알아보려면, 
아래의 [가이드라인](#guidelines) 섹션을 참조하세요.

도구 설명은 각 열의 값을 이해하는 데 도움이 될 수 있습니다.

**총 시간 (Total time)**
: 메서드가 자체 코드와 호출한 모든 메서드의 코드를 실행하는 데 소요된 시간입니다.

**자체 시간 (Self time)**
: 메서드가 자체 코드만 실행하는 데 소요된 시간입니다.

### Method 테이블 {:#method-table}

메서드 테이블은 CPU 프로필에 포함된 각 메서드에 대한 CPU 통계를 제공합니다. 
왼쪽의 표에는 사용 가능한 모든 메서드가 **전체 (total)** 및 **자체 (self)** 시간과 함께 나열되어 있습니다.

**전체** 시간은 메서드가 호출 스택의 **어디서나 (anywhere)** 소요한 시간을 합친 시간입니다. 
즉, 메서드가 자체 코드와 호출한 메서드의 모든 코드를 실행하는 데 소요한 시간입니다.

**자체** 시간은 메서드가 호출 스택 위에서 소요한 시간을 합친 시간입니다. 
즉, 메서드가 자체 코드만 실행하는 데 소요한 시간입니다.

![Screenshot of a call tree table](/assets/images/docs/tools/devtools/method-table.png)

왼쪽 표에서 메서드를 선택하면, 해당 메서드에 대한 호출 그래프가 표시됩니다. 
호출 그래프는 메서드의 호출자와 호출 대상자 및 해당 호출자/호출 대상자 백분율을 보여줍니다.

### Flame 차트 {:#flame-chart}

Flame 차트 뷰는 [호출 트리](#call-tree)의 그래픽 표현입니다. 
이것은 CPU 프로필의 top-down 뷰이므로, 
이 차트에서 가장 위에 있는 메서드는 그 아래에 있는 메서드를 호출합니다. 
각 Flame 차트 요소의 너비는 메서드가 호출 스택에서 소비한 시간을 나타냅니다.

호출 트리와 마찬가지로, 이 뷰는 CPU 프로필에서 비용이 많이 드는 경로를 식별하는 데 유용합니다.

![Screenshot of a flame chart](/assets/images/docs/tools/devtools/cpu-flame-chart.png)

검색 창 옆에 있는 `?` 아이콘을 클릭하면 열리는 도움말 메뉴에는, 
차트 내에서 탐색하고 확대/축소하는 방법에 대한 정보와 색상으로 구분된 범례가 제공됩니다.
![Screenshot of flame chart help](/assets/images/docs/tools/devtools/flame-chart-help.png){:width="70%"}


### CPU 샘플링 비율 {:#cpu-sampling-rate}

DevTools는 VM이 ​​CPU 샘플을 수집하는 속도를 설정합니다: 1 샘플 / 250 μs(마이크로초). 
이는 CPU 프로파일러 페이지에서 기본적으로 "Cpu 샘플링 속도: 중간"으로 선택됩니다. 
이 속도는 페이지 상단의 선택기를 사용하여 수정할 수 있습니다.

![Screenshot of cpu sampling rate menu](/assets/images/docs/tools/devtools/cpu-sampling-rate-menu.png){:width="70%"}

**low**, **medium**, **high** 샘플링 속도는 각각 1,000Hz, 4,000Hz, 20,000Hz입니다. 
이 설정을 수정하는 것의 장단점을 아는 것이 중요합니다.

**higher** 샘플링 속도로 기록된 프로필은 더 많은 샘플이 있는 더 세분화된 CPU 프로필을 생성합니다. 
이는 VM이 ​​샘플을 수집하기 위해 더 자주 중단되므로, 앱 성능에 영향을 미칠 수 있습니다. 
또한 이로 인해 VM의 CPU 샘플 버퍼가 더 빨리 오버플로됩니다. 
VM은 CPU 샘플 정보를 저장할 수 있는 공간이 제한되어 있습니다. 
더 높은 샘플링 속도에서는, 공간이 가득 차고 낮은 샘플링 속도를 사용한 경우보다 더 빨리 오버플로되기 시작합니다. 
즉, 기록하는 동안 버퍼가 오버플로되는지 여부에 따라, 기록된 프로필의 시작부터 CPU 샘플에 액세스할 수 없을 수도 있습니다.

더 낮은 샘플링 속도로 기록된 프로필은 샘플이 적은 더 거친(coarse-grained) CPU 프로필을 생성합니다. 
이렇게 하면 앱 성능에 미치는 영향은 적지만, 프로필 시간 동안 CPU가 수행한 작업에 대한 정보에 덜 접근할 수 있습니다. 
VM의 샘플 버퍼도 더 느리게 채워지므로, 앱 실행 시간 동안 CPU 샘플을 더 오랫동안 볼 수 있습니다. 
즉, 기록된 프로필의 시작 부분에서 CPU 샘플을 볼 가능성이 더 높아집니다.

### 필터링 {:#filtering}

CPU 프로필을 볼 때 라이브러리, 메서드 이름 또는 [`UserTag`][]로 데이터를 필터링할 수 있습니다.

![Screenshot of filter by tag menu](/assets/images/docs/tools/devtools/filter-by-tag.png)

[`UserTag`]: {{site.api}}/flutter/dart-developer/UserTag-class.html

## 가이드라인 {:#guidelines}

호출 트리나 bottom up 뷰를 볼 때, 때때로 트리가 매우 깊을 수 있습니다. 
깊은 트리에서 부모-자식 관계를 보는 데 도움이 되도록, **Display guidelines** 옵션을 활성화합니다. 
이렇게 하면 트리에서 부모와 자식 사이에 수직 가이드라인이 추가됩니다.

![Screenshot of display options](/assets/images/docs/tools/devtools/display-options.png)

[analyze performance]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/
  
## 기타 리소스 {:#other-resources}

DevTools를 사용하여 컴퓨팅 집약적 Mandelbrot 앱의 CPU 사용량을 분석하는 방법을 알아보려면, 
가이드 [CPU Profiler View 튜토리얼][profiler-tutorial]을 확인하세요. 
또한 앱이 병렬 컴퓨팅을 위해 isolates를 사용할 때, CPU 사용량을 분석하는 방법도 알아보세요.

[profiler-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-cpu-profiler-view-part-6-of-8-31e24eae6bf8
