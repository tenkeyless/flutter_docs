---
# title: Use the app size tool
title: 앱 크기 도구 사용
# description: Learn how to use the DevTools app size tool.
description: DevTools 앱 크기 도구를 사용하는 방법을 알아보세요.
---

## 그것은 무엇입니까? {:#what-is-it}

앱 크기 도구를 사용하면 앱의 전체 크기를 분석할 수 있습니다. 
[Analysis 탭][Analysis tab]을 사용하여 "크기 정보"의 단일 스냅샷을 보거나, 
[Diff 탭][Diff tab]을 사용하여 "크기 정보"의 두 개의 다른 스냅샷을 비교할 수 있습니다.

### "사이즈 정보"란 무엇인가요? {:#what-is-size-information}

"크기 정보"에는 Dart 코드, 네이티브 코드 및 앱의 비코드 요소(예: 애플리케이션 패키지, assets 및 글꼴)에 대한 크기 데이터가 포함됩니다. 
"크기 정보" 파일에는 애플리케이션 크기의 전체 그림에 대한 데이터가 포함됩니다.

### Dart 사이즈 정보 {:#dart-size-information}

Dart AOT 컴파일러는 애플리케이션을 컴파일할 때 코드에 트리 셰이킹을 수행합니다.
(프로필 또는 릴리스 모드만 해당&mdash;AOT 컴파일러는 JIT 컴파일된 디버그 빌드에는 사용되지 않음)
즉, 컴파일러는 사용되지 않거나 도달할 수 없는 코드 부분을 제거하여, 앱의 크기를 최적화하려고 시도합니다.

컴파일러가 코드를 최대한 최적화한 후, 
최종 결과는 바이너리 출력에 있는 패키지, 라이브러리, 클래스 및 함수의 컬렉션과 바이트 단위의 크기로 요약할 수 있습니다. 
이는, 앱 크기 도구에서 Dart 코드를 추가로 최적화하고 크기 문제를 추적하기 위해 분석할 수 있는, 
"크기 정보"의 Dart 부분입니다.

## 사용 방법 {:#how-to-use-it}

DevTools가 이미 실행 중인 애플리케이션에 연결되어 있는 경우, "App Size" 탭으로 이동합니다.

![Screenshot of app size tab](/assets/images/docs/tools/devtools/app_size_tab.png)

DevTools가 실행 중인 애플리케이션에 연결되어 있지 않은 경우, 
DevTools를 실행하면 나타나는 랜딩 페이지에서 도구에 액세스할 수 있습니다. 
([실행 지침][launch instructions] 참조)

![Screenshot of app size access on landing page](/assets/images/docs/tools/devtools/app_size_access_landing_page.png){:width="100%"}

## Analysis 탭 {:#analysis-tab}

분석 탭을 사용하면 크기 정보의 단일 스냅샷을 검사할 수 있습니다. 
트리맵과 테이블을 사용하여 크기 데이터의 계층 구조를 볼 수 있으며, 
도미네이터 트리와 호출 그래프를 사용하여 코드 속성 데이터(예: 컴파일된 애플리케이션에 코드 조각이 포함된 이유)를 볼 수 있습니다.

![Screenshot of app size analysis](/assets/images/docs/tools/devtools/app_size_analysis.png){:width="100%"}

### 사이즈 파일 로딩 {:#loading-a-size-file}

Analysis 탭을 열면 앱 크기 파일을 로드하는 지침이 표시됩니다. 
앱 크기 파일을 대화 상자로 끌어서 놓고, "Analyze Size"을 클릭합니다.

![Screenshot of app size analysis loading screen](/assets/images/docs/tools/devtools/app_size_load_analysis.png){:width="100%"}

크기 파일 생성에 대한 정보는 아래의 [크기 파일 생성][Generating size files]을 참조하세요.

### Treemap 및 테이블 {:#treemap-and-table}

트리맵과 테이블은 앱 크기에 대한 계층적 데이터를 보여줍니다.

#### treemap 사용 {:#use-the-treemap}

트리맵은 계층적 데이터를 시각화한 것입니다. 
공간은 사각형으로 나뉘며, 각 사각형은 양적 변수(이 경우, 바이트 크기)에 따라 크기가 지정되고 정렬됩니다. 
각 사각형의 면적은 컴파일된 애플리케이션에서 노드가 차지하는 크기에 비례합니다. 
각 사각형(하나를 A라고 함), 내부에는 데이터 계층에서 한 레벨 더 깊은 추가 사각형(A의 자식)이 있습니다.

트리맵에서 셀을 자세히 살펴보려면, 셀을 선택합니다. 
이렇게 하면 트리가 다시 루트되어 선택한 셀이 트리맵의 시각적 루트가 됩니다.

뒤로 이동하거나, 한 단계 위로 이동하려면, 트리맵 맨 위에 있는 브레드크럼(breadcrumb) 탐색기를 사용합니다.

![Screenshot of treemap breadcrumb navigator](/assets/images/docs/tools/devtools/treemap_breadcrumbs.png){:width="100%"}

### 도미네이터 트리와 콜 그래프 {:#dominator-tree-and-call-graph}

이 페이지 섹션은 코드 크기 속성 데이터(예: 컴파일된 애플리케이션에 코드 조각이 포함된 이유)를 보여줍니다. 
이 데이터는 도미네이터 트리와 호출 그래프 형태로 볼 수 있습니다.

#### 도미네이터 트리 사용 {:#use-the-dominator-tree}

[도미네이터 트리][dominator tree]는 각 노드의 자식이 바로 지배하는 노드인 트리입니다. 
노드 `a`가 노드 `b`를 "지배(dominate)"한다고 하는 것은, `b`로 가는 모든 경로가 `a`를 거쳐야 하기 때문입니다.

[dominator tree]: https://en.wikipedia.org/wiki/Dominator_(graph_theory)

앱 크기 분석의 컨텍스트에서 설명하자면, `package:a`가 `package:b`와 `package:c`를 모두 import하고, 
`package:b`와 `package:c`가 모두 `package:d`를 import한다고 가정해 보겠습니다.

```plaintext
package:a
|__ package:b
|   |__ package:d
|__ package:c
    |__ package:d
```

이 예에서, `package:a`는 `package:d`를 dominates 하므로, 이 데이터의 도미네이터 트리는 다음과 같습니다.

```plaintext
package:a
|__ package:b
|__ package:c
|__ package:d
```

이 정보는 특정 코드 조각이 컴파일된 애플리케이션에 존재하는 이유를 이해하는 데 도움이 됩니다. 
예를 들어, 앱 크기를 분석하고 컴파일된 앱에 예상치 못한 패키지가 포함되어 있는 경우, 
도미네이터 트리를 사용하여 패키지를 루트 소스까지 추적할 수 있습니다.

![Screenshot of code size dominator tree](/assets/images/docs/tools/devtools/app_size_dominator_tree.png){:width="100%"}

#### 콜 그래프 사용 {:#use-the-call-graph}

호출 그래프는 컴파일된 애플리케이션에 코드가 존재하는 이유를 이해하는 데 도움이 되는 측면에서, 
도미네이터 트리와 유사한 정보를 제공합니다. 
그러나, 도미네이터 트리와 같이 코드 크기 데이터의 노드 간에 일대다 우세(dominant) 관계를 표시하는 대신, 
호출 그래프는 코드 크기 데이터의 노드 간에 존재하는 다대다 관계를 표시합니다.

다시, 다음 예를 사용합니다.

```plaintext
package:a
|__ package:b
|   |__ package:d
|__ package:c
    |__ package:d
```

이 데이터의 호출 그래프는 "주체(dominator)"인 `package:a` 대신, 
`package:d`를 직접 호출한 `package:b` 및 `package:c`에 연결합니다.

```plaintext
package:a --> package:b -->
                              package:d
package:a --> package:c -->
```

이 정보는 코드 조각(패키지, 라이브러리, 클래스, 함수) 간의 세부적인 종속성을 이해하는 데 유용합니다.

![Screenshot of code size call graph](/assets/images/docs/tools/devtools/app_size_call_graph.png){:width="100%"}

#### 도미네이터 트리를 사용해야 할까요, 아니면 콜 그래프를 사용해야 할까요? {:#should-i-use-the-dominator-tree-or-the-call-graph}

애플리케이션에 코드가 포함된 *root* 원인을 이해하려면, 도미네이터 트리를 사용합니다. 
코드로 가는 모든 호출 경로를 이해하려면, 호출 그래프를 사용합니다.

도미네이터 트리는 호출 그래프 데이터의 분석 또는 슬라이스로, 
노드가 부모-자식 계층 구조 대신 "우세(dominance)"로 연결됩니다. 
부모 노드가 자식 노드를 우세(dominates)하게 하는 경우, 
호출 그래프와 도미네이터 트리의 관계는 동일하지만, 항상 그런 것은 아닙니다.

호출 그래프가 완전한(모든 노드 쌍 사이에 에지가 있는) 시나리오에서, 
도미네이터 트리는 그래프의 모든 노드에 대한 `root`가 도미네이터임을 보여줍니다. 
이는 호출 그래프가 애플리케이션에 코드가 포함된 이유를 더 잘 이해할 수 있게 해주는 예입니다.

## Diff 탭 {:#diff-tab}

diff 탭을 사용하면 두 개의 크기 정보 스냅샷을 비교할 수 있습니다. 
비교하는 두 개의 크기 정보 파일은 동일한 앱의 두 가지 다른 버전에서 생성되어야 합니다. 
예를 들어, 코드 변경 전후에 생성된 크기 파일입니다. 
트리맵과 테이블을 사용하여 두 데이터 세트 간의 차이를 시각화할 수 있습니다.

![Screenshot of app size diff](/assets/images/docs/tools/devtools/app_size_diff.png){:width="100%"}

### 크기 파일 로딩 {:#loading-size-files}

**Diff** 탭을 열면, "이전" 및 "새로운" 크기 파일을 로드하는 지침이 표시됩니다. 
다시 말하지만, 이러한 파일은 동일한 애플리케이션에서 생성해야 합니다. 
이러한 파일을 각각의 대화 상자로 끌어서 놓고, **Analyze Diff**을 클릭합니다.

![Screenshot of app size diff loading screen](/assets/images/docs/tools/devtools/app_size_load_diff.png){:width="100%"}

이러한 파일을 생성하는 방법에 대한 정보는 아래의 [크기 파일 생성][Generating size files]을 참조하세요.

### Treemap 및 테이블 {:#treemap-and-table-1}

diff 뷰에서, 트리맵과 트리 테이블은 두 개의 가져온 크기 파일 간에 차이가 있는 데이터만 표시합니다.

트리맵 사용에 대한 질문은 위의 [트리맵 사용][Use the treemap]을 참조하세요.

## 크기 파일 생성 {:#generating-size-files}

앱 크기 도구를 사용하려면, Flutter 크기 분석 파일을 생성해야 합니다. 
이 파일에는 전체 애플리케이션(네이티브 코드, Dart 코드, 에셋, 글꼴 등)의 크기 정보가 포함되어 있으며, 
`--analyze-size` 플래그를 사용하여 생성할 수 있습니다.

```console
flutter build <your target platform> --analyze-size
```

이렇게 하면 애플리케이션을 빌드하고, 명령줄에 크기 요약을 출력하고, 
크기 분석 파일을 찾을 수 있는 위치를 알려주는 줄을 출력합니다.

```console
flutter build apk --analyze-size --target-platform=android-arm64
...
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
app-release.apk (total compressed)                               6 MB
...
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
A summary of your APK analysis can be found at: build/apk-code-size-analysis_01.json
```

이 예에서, `build/apk-code-size-analysis_01.json` 파일을 앱 크기 도구로 가져와서 추가로 분석합니다. 
자세한 내용은, [앱 크기 문서][App Size Documentation]를 ​​참조하세요.

## 기타 리소스 {:#other-resources}

DevTools를 사용하여 Wonderous App의 단계별 크기 분석을 수행하는 방법을 알아보려면, 
[App Size Tool 튜토리얼][app-size-tutorial]을 확인하세요. 
앱 크기를 줄이기 위한 다양한 전략도 논의합니다.

[Use the treemap]: #use-the-treemap
[Generating size files]: #generating-size-files
[Analysis tab]: #analysis-tab
[Diff tab]: #diff-tab
[launch instructions]: /tools/devtools#start
[App Size Documentation]: /perf/app-size#breaking-down-the-size
[app-size-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-app-size-tool-part-3-of-8-9be6e9ec42a2
