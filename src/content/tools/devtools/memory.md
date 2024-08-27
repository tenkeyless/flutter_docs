---
# title: Use the Memory view
title: 메모리 뷰 사용
# description: Learn how to use the DevTools memory view.
description: DevTools 메모리 뷰를 사용하는 방법을 알아보세요.
---

메모리 뷰는 애플리케이션의 메모리 할당에 대한 세부 정보와 특정 문제를 탐지하고 디버깅하는 도구를 제공합니다.

:::note
이 페이지는 DevTools 2.23.0에 맞춰 최신 상태입니다.
:::

다양한 IDE에서 DevTools 화면을 찾는 방법에 대한 정보는 [DevTools 개요](/tools/devtools)를 확인하세요.

이 페이지에서 발견한 통찰력을 더 잘 이해하기 위해, 첫 번째 섹션에서는 Dart가 메모리를 관리하는 방법을 설명합니다. 
이미 Dart의 메모리 관리를 이해하고 있다면, [메모리 뷰 가이드](#memory-view-guide)로 건너뛸 수 있습니다.

## 메모리 뷰를 사용하는 이유 {:#reasons-to-use-the-memory-view}

선제적(preemptive) 메모리 최적화를 위해 또는 애플리케이션에서 다음 조건 중 하나가 발생할 때 메모리 뷰를 사용합니다.

* 메모리가 부족하여 충돌
* 속도가 느려짐
* 기기가 느려지거나 응답하지 않음
* 운영 체제에서 적용하는 메모리 제한을 초과하여 종료됨
* 메모리 사용 제한을 초과함
  * 이 제한은 앱이 타겟팅하는 기기 타입에 따라 다를 수 있습니다.
* 메모리 누수가 의심됨

## 기본 메모리 개념 {:#basic-memory-concepts}

클래스 생성자(예: `MyClass()` 사용)를 사용하여 생성된 Dart 객체는 _힙(heap)_ 이라는 메모리 부분에 있습니다. 
힙의 메모리는 Dart VM(가상 머신)에서 관리합니다. 
Dart VM은 객체 생성 시 객체에 대한 메모리를 할당하고, 
객체가 더 이상 사용되지 않으면 메모리를 해제(releases)(또는 할당 해제(deallocates))합니다.
([Dart 가비지 수집][Dart garbage collection] 참조)

[Dart garbage collection]: {{site.medium}}/flutter/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30

### 객체 타입 {:#object-types}

#### Disposable 객체 {:#disposable-object}

폐기 가능한(disposable) 객체는 `dispose()` 메서드를 정의하는 모든 Dart 객체입니다. 
메모리 누수를 방지하려면, 객체가 더 이상 필요하지 않을 때 `dispose`를 호출합니다.

#### 메모리 위험 객체 {:#memory-risky-object}

메모리 위험 객체란 적절하게 폐기되지 않거나, 
폐기되었지만 GC가 수행되지 않을 경우, 메모리 누수를 _일으킬 수 있는_ 객체입니다.

### 루트 객체, 유지 경로(retaining path) 및 도달 가능성 {:#root-object-retaining-path-and-reachability}

#### 루트 객체{:#root-object}

모든 Dart 애플리케이션은, 
애플리케이션이 할당한 다른 모든 객체를 직접 또는 간접적으로 참조하는, 
_루트 객체_ 를 생성합니다.

#### 도달 가능성 (Reachability) {:#reachability}

애플리케이션이 실행되는 어느 순간에, 루트 객체가 할당된 객체를 참조하지 않으면, 
해당 객체는 _unreachable (도달할 수 없는)_ 상태가 되는데, 
이는 가비지 수집기(GC)가 객체의 메모리 할당을 해제하라는 신호입니다.

#### 유지 경로 (Retaining path) {:#retaining-path}

루트에서 객체로의 참조 시퀀스를 객체의 _보관(retaining)_ 경로라고 하며, 
가비지 수집에서 객체의 메모리를 보관하기 때문입니다. 
한 객체는 여러 개의 보관 경로를 가질 수 있습니다. 
최소한 하나의 보관 경로가 있는 객체를 _도달 가능(reachable)_ 객체라고 합니다.

#### 예제 {:#example}

다음 예는 개념을 설명합니다.

```dart
class Child{}

class Parent {
  Child? child;
}

Parent parent1 = Parent();

void myFunction() {

  Child? child = Child();

  // `child` 객체는 메모리에 할당되었습니다. 
  // 이제 가비지 수집에서, 하나의 유지 경로(root …-> myFunction -> child)에 의해 유지됩니다.

  Parent? parent2 = Parent()..child = child;
  parent1.child = child;

  // 이 시점에서 `child` 객체에는 세 개의 유지 경로가 있습니다.
  // root …-> myFunction -> child
  // root …-> myFunction -> parent2 -> child
  // root -> parent1 -> child

  child = null;
  parent1.child = null;
  parent2 = null;

  // 이 시점에서는, `child` 인스턴스에 접근할 수 없으며 결국 가비지 수집됩니다.

  …
}
```

### 얕은(Shallow) 크기 vs 유지된(retained) 크기 {:#shallow-size-vs-retained-size}

**얕은 크기**에는 객체와 참조의 크기만 포함되고, **유지된 크기**에는 유지된 객체의 크기도 포함됩니다.

루트 객체의 **유지된 크기**에는 도달 가능한 모든 Dart 객체가 포함됩니다.

다음 예에서, `myHugeInstance`의 크기는 부모 또는 자식의 얕은 크기에 포함되지 않지만, 유지된 크기에 포함됩니다.

```dart
class Child{
  /// 인스턴스는 [parent] 및 [parent.child] 유지 크기에 모두 속합니다.
  final myHugeInstance = MyHugeInstance();
}

class Parent {
  Child? child;
}

Parent parent = Parent()..child = Child();
```

DevTools 계산에서, 객체에 두 개 이상의 유지 경로가 있는 경우, 
해당 객체의 크기는 가장 짧은 유지 경로의 멤버에만 유지된 것으로 할당됩니다.

이 예에서 객체 `x`에는 두 개의 유지 경로가 있습니다.

```console
root -> a -> b -> c -> x
root -> d -> e -> x (`x`로 가는 최단 유지 경로)
```

가장 짧은 경로의 멤버(`d`와 `e`)만 `x`를 유지 크기에 포함합니다.

### Dart에서 메모리 누수가 발생하나요? {:#memory-leaks-happen-in-dart}

가비지 컬렉터는 모든 타입의 메모리 누수를 방지할 수 없으며, 
개발자는 여전히 누수 없는 수명 주기를 위해 객체를 감시해야 합니다.

#### 왜 가비지 수집기는 모든 누수를 막을 수 없는 걸까요? {:#why-cant-the-garbage-collector-prevent-all-leaks}

가비지 콜렉터가 도달할 수 없는(unreachable) 모든 객체를 처리하는 반면, 
불필요한 객체가 더 이상 도달할 수 없도록 하는 것은 애플리케이션의 책임입니다. (루트에서 참조됨)

따라서, 불필요한 객체가 참조된 채로 남아 있으면(전역 또는 static 변수 또는 오래 지속되는 객체의 필드로), 
가비지 콜렉터가 이를 인식할 수 없고, 
메모리 할당이 점진적으로 증가하며, 결국 앱이 `out-of-memory` 오류로 인해 충돌합니다.

#### 클로저에 특별한 주의가 필요한 이유 {:#why-closures-require-extra-attention}

잡기 어려운 누수 패턴 중 하나는 클로저 사용과 관련이 있습니다. 
다음 코드에서, 수명이 짧은 `myHugeObject`에 대한 참조는 클로저 컨텍스트에서 암묵적으로 저장되고, 
`setHandler`에 전달됩니다. 
결과적으로, `handler`에 도달할 수 있는 한 `myHugeObject`는 가비지 수집되지 않습니다.

```dart
  final handler = () => print(myHugeObject.name);
  setHandler(handler);
```

#### `BuildContext`에 특별한 주의가 필요한 이유 {:#why-buildcontext-requires-extra-attention}

수명이 긴 영역에 끼어들어 누수를 일으킬 수 있는 크고 수명이 짧은 객체의 예로는,
Flutter의 `build` 메서드에 전달된 `context` 매개변수가 있습니다.

다음 코드는, `useHandler`가 핸들러를 수명이 긴 영역에 저장할 수 있으므로, 누수가 발생하기 쉽습니다.

```dart
// 나쁨: 이렇게 하지 마세요
// 이 코드는 누수되기 쉽습니다:
@override
Widget build(BuildContext context) {
  final handler = () => apply(Theme.of(context));
  useHandler(handler);
…
```

#### 누수가 발생하기 쉬운 코드를 수정하는 방법은? {:#how-to-fix-leak-prone-code}

다음 코드는 누수에 취약하지 않습니다. 그 이유는 다음과 같습니다.

1. 클로저는 크고 수명이 짧은 `context` 객체를 사용하지 않습니다.
2. `theme` 객체(대신 사용됨)는 수명이 깁니다. 한 번 생성되고, `BuildContext` 인스턴스 간에 공유됩니다.


```dart
// 좋음
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final handler = () => apply(theme);
  useHandler(handler);
…
```

#### `BuildContext`에 대한 일반 규칙 {:#general-rule-for-buildcontext}

일반적으로, `BuildContext`에 대해 다음 규칙을 사용합니다. 
클로저가 위젯보다 오래 지속되지 않으면, 컨텍스트를 클로저에 전달해도 됩니다.

Stateful 위젯은 특별한 주의가 필요합니다. 
[위젯과 위젯 상태][interactive]이라는 두 가지 클래스로 구성되어 있으며, 위젯은 수명이 짧고, 상태는 수명이 깁니다. 
위젯이 소유한 빌드 컨텍스트는 상태 필드에서 참조해서는 안 됩니다. 
상태는 위젯과 함께 가비지 수집되지 않으며, 위젯보다 훨씬 오래 지속될 수 있기 때문입니다.

[interactive]: /ui/interactivity#creating-a-stateful-widget

### 메모리 누수(leak) vs 메모리 팽창(bloat) {:#memory-leak-vs-memory-bloat}

메모리 누수에서, 애플리케이션은 점진적으로 메모리를 사용합니다. 
예를 들어, 리스너를 반복적으로 생성하지만, 삭제(disposing)하지 않습니다.

메모리 팽창은 최적의 성능에 필요한 것보다 더 많은 메모리를 사용합니다. 
예를 들어, 지나치게 큰 이미지를 사용하거나, 스트림을 수명 내내 열어 둡니다.

누수와 팽창은 모두 크면, 애플리케이션이 `out-of-memory` 오류로 인해 충돌합니다. 
그러나, 누수는 메모리 문제를 일으킬 가능성이 더 큽니다. 
작은 누수라도 여러 번 반복되면 충돌로 이어지기 때문입니다.

## 메모리 뷰 가이드 {:#memory-view-guide}

DevTools 메모리 뷰는 메모리 할당(힙과 외부 모두), 메모리 누수, 메모리 팽창 등을 조사하는 데 도움이 됩니다. 
이 뷰에는 다음과 같은 기능이 있습니다.

[**확장 가능한 차트**](#expandable-chart)
: 메모리 할당의 높은 레벨 추적을 얻고, 표준 이벤트(가비지 수집 등)와 커스텀 이벤트(이미지 할당 등)를 모두 확인합니다.

[**Profile Memory** 탭](#profile-memory-tab)
: 클래스와 메모리 타입별로 나열된 현재 메모리 할당을 확인합니다.

[**Diff Snapshots** 탭](#diff-snapshots-tab)
: 기능의 메모리 관리 문제를 감지하고 조사합니다.

[**Trace Instances** 탭](#trace-instances-tab)
: 지정된 클래스 집합에 대한 기능의 메모리 관리를 조사합니다.

### 확장 가능한 차트 {:#expandable-chart}

확장 가능한 차트는 다음과 같은 기능을 제공합니다.

#### 메모리 해부학 {:#memory-anatomy}

시계열 그래프는 연속적인 시간 간격으로 Flutter 메모리의 상태를 시각화합니다. 
차트의 각 데이터 포인트는 힙의 측정된 양(y축)의 타임스탬프(x축)에 해당합니다. 
예를 들어, 사용량, 용량, 외부, 가비지 수집 및 상주 세트 크기가 캡처됩니다.

![Screenshot of a memory anatomy page](/assets/images/docs/tools/devtools/memory_chart_anatomy.png){:width="100%"}

#### 메모리 개요 차트 {:#memory-overview-chart}

메모리 개요 차트는 수집된 메모리 통계의 시계열 그래프입니다. 
시간 경과에 따른 Dart 또는 Flutter 힙과 Dart 또는 Flutter의 네이티브 메모리 상태를 시각적으로 보여줍니다.

차트의 x축은 이벤트 타임라인(시계열)입니다. 
y축에 표시된 데이터는 모두 데이터가 수집된 타임스탬프를 가지고 있습니다. 
즉, 500ms마다 메모리의 폴링 상태(용량, 사용, 외부, RSS(상주 세트 크기), GC(가비지 수집))를 보여줍니다. 
이를 통해, 애플리케이션이 실행되는 동안 메모리 상태를 실시간으로 볼 수 있습니다.

**Legend (범례)** 버튼을 클릭하면, 데이터를 표시하는 데 사용된 수집된 측정값, 기호, 색상이 표시됩니다.

![Screenshot of a memory anatomy page](/assets/images/docs/tools/devtools/memory_chart_anatomy.png){:width="100%"}

**메모리 크기 척도 (Memory Size Scale)** y축은 현재 보이는 차트 범위에서 수집된 데이터 범위에 따라 자동으로 조정됩니다.

y축에 표시된 수량은 다음과 같습니다.

**Dart/Flutter Heap**
: 힙의 객체(Dart 및 Flutter 객체).

**Dart/Flutter Native**
: Dart/Flutter 힙에 없지만 여전히 전체 메모리 풋프린트의 일부인 메모리. 
  이 메모리의 객체는 네이티브 객체(예: 메모리로 파일 읽기 또는 디코딩된 이미지)입니다. 
  네이티브 객체는 Dart 임베더를 사용하여 네이티브 OS(예: Android, Linux, Windows, iOS)에서 Dart VM에 노출됩니다. 
  임베더(embedder)는 파이널라이저(finalizer)가 있는 Dart 래퍼를 생성하여, 
  Dart 코드가 이러한 네이티브 리소스와 통신할 수 있도록 합니다. 
  Flutter에는 Android 및 iOS용 임베더가 있습니다. 
  자세한 내용은 [명령줄 및 서버 앱][Command-line and server apps], [Dart Frog를 사용한 서버의 Dart][frog], [커스텀 Flutter 엔진 임베더][Custom Flutter Engine Embedders], [Heroku를 사용한 Dart 웹 서버 배포][heroku]를 참조하세요.

**타임라인 (Timeline)**
: 특정 시점(타임스탬프)에 수집된 모든 메모리 통계 및 이벤트의 타임스탬프.

**래스터 캐시 (Raster Cache)**
: 구성(compositing) 후 최종 렌더링을 수행하는 동안, Flutter 엔진의 래스터 캐시 레이어 또는 그림의 크기입니다. 
  자세한 내용은 [Flutter 아키텍처 개요][Flutter architectural overview] 및 [DevTools 성능 뷰][DevTools Performance view]를 참조하세요.

**할당됨 (Allocated)**
: 힙의 현재 용량은 일반적으로 모든 힙 객체의 총 크기보다 약간 큽니다.

**RSS - 레지던트 세트 크기 (Resident Set Size)**
: 레지던트 세트 크기는 프로세스의 메모리 양을 표시합니다. 
  스왑 아웃된 메모리는 포함되지 않습니다. 
  로드된 공유 라이브러리의 메모리와 모든 스택 및 힙 메모리가 포함됩니다. 
  자세한 내용은 [Dart VM 내부][Dart VM internals]를 참조하세요.

[Command-line and server apps]: {{site.dart-site}}/server
[Custom Flutter engine embedders]: {{site.repo.engine}}/blob/main/docs/Custom-Flutter-Engine-Embedders.md
[Dart VM internals]: https://mrale.ph/dartvm/
[DevTools Performance view]: /tools/devtools/performance
[Flutter architectural overview]: /resources/architectural-overview
[frog]: https://dartfrog.vgv.dev/
[heroku]: {{site.yt.watch}}?v=nkTUMVNelXA

<a id="profile-tab" aria-hidden="true"></a>

### Profile Memory 탭 {:#profile-memory-tab}

**Profile Memory** 탭을 사용하여 클래스 및 메모리 타입별 현재 메모리 할당을 확인합니다. 
Google 시트 또는 다른 도구에서 심층 분석을 위해 CSV 형식으로 데이터를 다운로드합니다. 
**Refresh on GC**을 토글하여, 할당을 실시간으로 확인합니다.

![Screenshot of the profile tab page](/assets/images/docs/tools/devtools/profile-tab-2.png){:width="100%"}

### Diff Snapshots 탭 {:#diff-snapshots-tab}

**Diff Snapshots** 탭을 사용하여, 기능의 메모리 관리를 조사합니다. 
탭의 지침에 따라 애플리케이션과 상호 작용하기 전과 후에 스냅샷을 찍고 스냅샷을 diff합니다.

![Screenshot of the diff tab page](/assets/images/docs/tools/devtools/diff-tab.png){:width="100%"}

**Filter classes and packages** 버튼을 탭하여 데이터를 좁힙니다.

![Screenshot of the filter options ui](/assets/images/docs/tools/devtools/filter-ui.png)

Google 시트나 다른 도구에서 심층적인 분석을 수행하려면, CSV 형식으로 데이터를 다운로드하세요.

<a id="trace-tab" aria-hidden="true"></a>

### Trace Instances 탭 {:#trace-instances-tab}

**Trace Instances** 탭을 사용하여, 기능 실행 중에 클래스 집합에 메모리를 할당하는 방법을 조사합니다.

1. 추적할 클래스 선택
2. 앱과 상호 작용하여, 관심 있는 코드를 트리거합니다.
3. **Refresh**를 탭합니다.
4. 추적된 클래스를 선택합니다.
5. 수집된 데이터를 검토합니다.

![Screenshot of a trace tab](/assets/images/docs/tools/devtools/trace-instances-tab.png){:width="100%"}

#### Bottom up vs 호출 트리 뷰 {:#bottom-up-vs-call-tree-view}

작업의 세부 사항에 따라 bottom-up 및 호출 트리 뷰를 전환합니다.

![Screenshot of a trace allocations](/assets/images/docs/tools/devtools/trace-view.png)

호출 트리 뷰는 각 인스턴스에 대한 메서드 할당을 보여줍니다. 
뷰는 호출 스택의 top-down 표현으로, 메서드를 확장하여 호출자(callees)를 표시할 수 있습니다.

bottom-up 뷰는 인스턴스를 할당한 다양한 호출 스택 목록을 보여줍니다.

## 기타 리소스 {:#other-resources}

자세한 내용은 다음 리소스를 확인하세요.

* DevTools를 사용하여 앱의 메모리 사용량을 모니터링하고, 메모리 누수를 감지하는 방법을 알아보려면, 
  가이드 [메모리 뷰 튜토리얼][memory-tutorial]을 확인하세요.
* Android 메모리 구조를 이해하려면, [Android: 프로세스 간 메모리 할당][Android: Memory allocation among processes]을 확인하세요.

[memory-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-memory-view-part-7-of-8-e7f5aaf07e15
[Android: Memory allocation among processes]: {{site.android-dev}}/topic/performance/memory-management
