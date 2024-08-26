---
# title: Differentiate between ephemeral state and app state
title: 일시적(ephemeral) 상태와 앱 상태의 차이점
# description: How to tell the difference between ephemeral and app state.
description: 일시적 상태와 앱 상태의 차이점을 설명하는 방법.
prev:
  # title: Start thinking declaratively
  title: 선언적으로 생각하기 시작하세요
  path: /development/data-and-backend/state-mgmt/declarative
next:
  # title: Simple app state management
  title: 간단한 앱 상태 관리
  path: /development/data-and-backend/state-mgmt/simple
---

_이 문서에서는 앱 상태, 일시적(ephemeral) 상태, 그리고 Flutter 앱에서 각각을 관리하는 방법을 소개합니다._

가장 광범위한 의미에서, 앱의 상태는 앱이 실행될 때 메모리에 존재하는 모든 것입니다. 
여기에는 앱의 assets, Flutter 프레임워크가 UI에 대해 유지하는 모든 변수, 애니메이션 상태, 텍스처, 글꼴 등이 포함됩니다. 
상태에 대한 이 가장 광범위한 정의는 유효하지만, 앱을 설계하는 데는 그다지 유용하지 않습니다.

1. 첫째, 일부 상태(예: 텍스처)는 관리하지도 않습니다. 프레임워크가 대신 처리합니다. 
   따라서, 상태에 대한 더 유용한 정의는 "언제든지 UI를 다시 빌드하는 데 필요한 모든 데이터"입니다. 
2. 둘째, _직접 관리하는_ 상태는 일시적(ephemeral) 상태와 앱 상태라는 두 가지 개념적 타입으로 나눌 수 있습니다.

## 1. 일시적(ephemeral) 상태 {:#ephemeral-state}

일시적(Ephemeral) 상태(때로는 _UI 상태_ 또는 _로컬 상태_ 라고도 함)는 단일 위젯에 깔끔하게 포함할 수 있는 상태입니다.

의도적으로, 모호한 정의이므로, 몇 가지 예를 들어보겠습니다.

* [`PageView`][]의 현재 페이지
* 복잡한 애니메이션의 현재 진행 상황
* `BottomNavigationBar`의 현재 선택된 탭

위젯 트리의 다른 부분은 이런 종류의 상태에 액세스할 필요가 거의 없습니다. 
직렬화할 필요가 없고, 복잡한 방식으로 변경되지 않습니다.

즉, 이런 종류의 상태에서는 상태 관리 기술(ScopedModel, Redux 등)을 사용할 필요가 없습니다. 
`StatefulWidget`만 있으면 됩니다.

아래에서, 하단 네비게이션 바에서 현재 선택된 항목이 `_MyHomepageState` 클래스의 `_index` 필드에 보관되는 방식을 볼 수 있습니다. 
이 예에서, `_index`는 일시적 상태입니다.

<?code-excerpt "state_mgmt/simple/lib/src/set_state.dart (ephemeral)" plaster="// ... items ..."?>
```dart
class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (newIndex) {
        setState(() {
          _index = newIndex;
        });
      },
      // ... items ...
    );
  }
}
```

여기서, `setState()`와 StatefulWidget의 State 클래스 내부의 필드를 사용하는 것은 완전히 자연스러운 일입니다. 
앱의 다른 부분은 `_index`에 액세스할 필요가 없습니다. 
변수는 `MyHomepage` 위젯 내부에서만 변경됩니다. 
그리고, 사용자가 앱을 닫았다가 다시 시작하면, `_index`가 0으로 재설정되는 것은 상관없습니다.

## 2. 앱 상태 {:#app-state}

일시적이지 않고, 앱의 여러 부분에서 공유하고, 사용자 세션 간에 유지하려는 상태를, 
애플리케이션 상태(때로는 공유 상태라고도 함)라고 합니다.

애플리케이션 상태의 예:

* 사용자 기본 설정 (User preferences)
* 로그인 정보
* 소셜 네트워킹 앱의 알림
* 전자 상거래 앱의 쇼핑 카트
* 뉴스 앱의 기사 읽음/읽지 않음 상태

앱 상태를 관리하려면, 옵션을 조사해야 합니다. 
당신의 선택은 앱의 복잡성과 특성, 팀의 이전 경험 및 기타 여러 측면에 따라 달라집니다. 
계속 읽어보세요.

## 명확한 규칙은 없습니다 {:#there-is-no-clear-cut-rule}

명확히 하자면, `State`와 `setState()`를 사용하여 앱의 모든 상태를 _관리할 수_ 있습니다. 
사실, Flutter 팀은 많은 간단한 앱 샘플(모든 `flutter create`에서 제공되는 시작 앱 포함)에서 이를 수행합니다.

반대의 경우도 마찬가지입니다. 
예를 들어, (특정 앱의 컨텍스트에서) 하단 네비게이션 바에서 선택한 탭이 일시적 상태가 _아니_ 라고 결정할 수 있습니다. 
클래스 외부에서 변경하거나, 세션 간에 유지하는 등의, 작업이 필요할 수 있습니다. 
이 경우, `_index` 변수는 앱 상태입니다.

특정 변수가 일시적 변수인지 앱 상태인지 구분하는 명확하고 보편적인 규칙은 없습니다. 
때로는, 하나를 다른 상태로 리팩토링해야 합니다. 
예를 들어, 분명히 일시적 상태로 시작하지만, 애플리케이션의 기능이 커짐에 따라 앱 상태로 이동해야 할 수 있습니다.

이러한 이유로, 다음 다이어그램을 큰 소금 한 알 정도로 받아들이십시오.

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/ephemeral-vs-app-state.png' width="100%" alt="A flow chart. Start with 'Data'. 'Who needs it?'. Three options: 'Most widgets', 'Some widgets' and 'Single widget'. The first two options both lead to 'App state'. The 'Single widget' option leads to 'Ephemeral state'.">

{% comment %}
Source drawing for the png above: : https://docs.google.com/drawings/d/1p5Bvuagin9DZH8bNrpGfpQQvKwLartYhIvD0WKGa64k/edit?usp=sharing
{% endcomment %}

React의 setState 대(vs) Redux의 store에 대한 질문에, Redux의 저자인 Dan Abramov는 다음과 같이 답했습니다.

> "경험의 법칙은 [덜 어색한 것을 하라][Do whatever is less awkward]입니다."

요약하자면, 모든 Flutter 앱에는 두 가지 개념적 타입의 상태가 있습니다. 
일시적(Ephemeral) 상태는 `State`와 `setState()`를 사용하여 구현할 수 있으며, 종종 단일 위젯에 로컬합니다. 
나머지는 앱 상태입니다. 
두 타입 모두 모든 Flutter 앱에서 자리를 차지하고 있으며, 두 가지의 구분은 사용자의 선호도와 앱의 복잡성에 따라 달라집니다.

[Do whatever is less awkward]: {{site.github}}/reduxjs/redux/issues/1287#issuecomment-175351978
[`PageView`]: {{site.api}}/flutter/widgets/PageView-class.html
