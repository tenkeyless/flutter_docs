---
# title: Flutter architectural overview
title: Flutter 아키텍처 개요
# description: A high-level overview of the architecture of Flutter, including the core principles and concepts that form its design.
description: Flutter의 아키텍처에 대한 개략적인(high-level) 개요로, 디자인을 형성하는 핵심 원리와 개념도 포함되어 있습니다.
---

<?code-excerpt path-base="resources/architectural_overview/"?>

이 문서는 Flutter의 아키텍처에 대한 개략적인(high-level) 개요를 제공하고, 디자인을 형성하는 핵심 원칙과 개념을 제공합니다.

Flutter는, iOS 및 Android와 같이, 운영 체제 간에 코드를 재사용할 수 있도록 설계된 크로스 플랫폼 UI 툴킷이며, 
애플리케이션이 기본 플랫폼 서비스와 직접 인터페이스할 수 있도록 합니다. 
목표는 개발자가 다양한 플랫폼에서 자연스럽게 느껴지는 고성능 앱을 제공하고, 
가능한 한 많은 코드를 공유하면서 차이점을 수용할 수 있도록 하는 것입니다.

개발 중에, Flutter 앱은 전체 재컴파일 없이도 변경 사항의 상태 저장 핫 리로드를 제공하는 VM에서 실행됩니다. 
릴리스를 위해, Flutter 앱은, Intel x64 또는 ARM 명령어이든, 머신 코드로 직접 컴파일되거나, 
웹을 대상으로 하는 경우, JavaScript로 컴파일됩니다. 
이 프레임워크는 오픈 소스이며, 허용 가능한 BSD 라이선스가 있으며, 
핵심 라이브러리 기능을 보완하는 타사 패키지의 번창하는 생태계가 있습니다.

이 개요는 여러 섹션으로 나뉩니다.

1. **레이어 모델**: Flutter가 구성된 부분입니다.
2. **반응형 사용자 인터페이스**: Flutter 사용자 인터페이스 개발을 위한 핵심 개념입니다.
3. **위젯** 소개: Flutter 사용자 인터페이스의 기본 구성 요소입니다.
4. **렌더링 프로세스**: Flutter가 UI 코드를 픽셀로 변환하는 방법입니다.
5. **플랫폼 임베더** 개요: 모바일 및 데스크톱 OS에서 Flutter 앱을 실행할 수 있도록 하는 코드입니다.
6. **다른 코드와 Flutter 통합**: Flutter 앱에서 사용할 수 있는 다양한 기술에 대한 정보입니다.
7. **웹 지원**: 브라우저 환경에서 Flutter의 특성에 대한 마무리 설명입니다.

## 아키텍쳐 레이어 {:#architectural-layers}

Flutter는 확장 가능한, 레이어화된 시스템으로 설계되었습니다. 
Flutter는 각각 기본 레이어에 의존하는 일련의 독립적인 라이브러리로 존재합니다. 
어떤 레이어도 아래 레이어에 대한 특권 액세스 권한이 없으며, 
프레임워크 레벨의 모든 부분은 선택 사항이며 대체 가능하도록 설계되었습니다.

{% comment %}
The PNG diagrams in this document were created using draw.io. The draw.io
metadata is embedded in the PNG file itself, so you can open the PNG directly
from draw.io to edit the individual components.

The following settings were used:

 - Select all (to avoid exporting the canvas itself)
 - Export as PNG, zoom 300% (for a reasonable sized output)
 - Enable _Transparent Background_
 - Enable _Selection Only_, _Crop_
 - Enable _Include a copy of my diagram_

{% endcomment %}

![Architectural diagram](/assets/images/docs/arch-overview/archdiagram.png){:width="100%"}

기본 운영 체제에 대해, Flutter 애플리케이션은 다른 네이티브 애플리케이션과 동일한 방식으로 패키징됩니다. 
플랫폼별 임베더는 진입점을 제공하고; 렌더링 표면, 접근성 및 입력과 같은 서비스에 액세스하기 위해 기본 운영 체제와 조정하며; 
메시지 이벤트 루프를 관리합니다. 
임베더는 플랫폼에 적합한 언어로 작성됩니다. 
현재 Android의 경우, Java 및 C++, 
iOS 및 macOS의 경우, Objective-C/Objective-C++, 
Windows 및 Linux의 경우 C++입니다. 
임베더를 사용하면, Flutter 코드를 기존 애플리케이션에 모듈로 통합하거나, 코드가 애플리케이션의 전체 콘텐츠가 될 수 있습니다. 
Flutter에는 일반적인 대상 플랫폼에 대한 여러 임베더가 포함되어 있지만, [다른 임베더](https://hover.build/blog/one-year-in/)도 있습니다.

Flutter의 핵심은, 대부분 C++로 작성되고 모든 Flutter 애플리케이션을 지원하는 데 필요한 기본 요소를 지원하는, 
**Flutter 엔진**입니다. 
이 엔진은 새 프레임을 페인트 할 때마다 합성된 장면을 래스터화하는 역할을 합니다. 
이 엔진은 그래픽(iOS의 [Impeller][]를 통해 Android와 macOS로 출시, 다른 플랫폼의 [Skia][]), 
텍스트 레이아웃, 파일 및 네트워크 I/O, 접근성 지원, 플러그인 아키텍처, Dart 런타임 및 컴파일 툴체인을 포함하여, 
Flutter의 핵심 API에 대한 낮은 레벨(low-level) 구현을 제공합니다.

[Skia]: https://skia.org
[Impeller]: /perf/impeller

엔진은 [`dart:ui`]({{site.repo.engine}}/tree/main/lib/ui)를 통해 Flutter 프레임워크에 노출되며, 
이는 기본 C++ 코드를 Dart 클래스로 래핑합니다. 
이 라이브러리는 입력, 그래픽 및 텍스트 렌더링 하위 시스템을 구동하는 클래스와 같은
가장 낮은 레벨(lowest-level) 기본 요소를 노출합니다.

일반적으로, 개발자는 Dart 언어로 작성된 현대적이고 reactive 프레임워크를 제공하는, 
**Flutter 프레임워크**를 통해 Flutter와 상호 작용합니다. 
여기에는 일련의 레이어로 구성된 풍부한 플랫폼, 레이아웃 및 기본 라이브러리 세트가 포함됩니다. 
아래에서 위로 작업하면, 다음과 같습니다.

- 기본 **[기초(foundational)]({{site.api}}/flutter/foundation/foundation-library.html)** 클래스 및 기본 기반에 일반적으로 사용되는 추상화를 제공하는 **[애니메이션]({{site.api}}/flutter/animation/animation-library.html), [페인팅]({{site.api}}/flutter/painting/painting-library.html) 및 [제스처]({{site.api}}/flutter/gestures/gestures-library.html)** 와 같은 빌딩 블록 서비스.
- **[렌더링 레이어]({{site.api}}/flutter/rendering/rendering-library.html)** 는 레이아웃을 처리하기 위한 추상화를 제공합니다. 이 레이어를 사용하면, 렌더링 가능한 객체의 트리를 빌드할 수 있습니다. 이러한 객체를 동적으로 조작할 수 있으며, 트리는 변경 사항을 반영하도록 레이아웃을 자동으로 업데이트합니다.
- **[위젯 레이어]({{site.api}}/flutter/widgets/widgets-library.html)** 는 구성 추상화입니다. 렌더링 레이어의 각 렌더 객체에는 위젯 레이어에 해당 클래스가 있습니다. 또한, 위젯 레이어를 사용하면 재사용할 수 있는 클래스 조합을 정의할 수 있습니다. 이 레이어에서 reactive 프로그래밍 모델이 도입됩니다.
- **[Material]({{site.api}}/flutter/material/material-library.html)** 및 **[Cupertino]({{site.api}}/flutter/cupertino/cupertino-library.html)** 라이브러리는 위젯 레이어의 구성 기본 요소를 사용하여 Material 또는 iOS 디자인 언어를 구현하는 포괄적인 컨트롤 세트를 제공합니다.

Flutter 프레임워크는 비교적 작습니다. 
개발자가 사용할 수 있는 높은 레벨(higher-level) 기능의 대부분은 패키지로 구현됩니다. 
여기에는 
[camera]({{site.pub}}/packages/camera) 및 
[webview]({{site.pub}}/packages/webview_flutter)와 같은 플랫폼 플러그인이 포함되며, 
핵심 Dart 및 Flutter 라이브러리를 기반으로 하는 
[characters]({{site.pub}}/packages/characters), 
[http]({{site.pub}}/packages/http), 
[animations]({{site.pub}}/packages/animations)와 같은 플랫폼에 독립적인 기능도 포함됩니다. 
이러한 패키지 중 일부는 
[앱 내 결제]({{site.pub}}/packages/square_in_app_payments), 
[Apple 인증]({{site.pub}}/packages/sign_in_with_apple), 
[애니메이션]({{site.pub}}/packages/lottie)과 같은 서비스를 포함하는 더 광범위한 생태계에서 제공됩니다.

이 개요의 나머지 부분은 UI 개발의 reactive 패러다임부터 시작하여, 레이어를 광범위하게 탐색합니다. 
그런 다음, 위젯이 어떻게 함께 구성되고 애플리케이션의 일부로 렌더링될 수 있는 객체로 변환되는지 설명합니다. 
Flutter의 웹 지원이 다른 대상과 어떻게 다른지에 대한 간략한 요약을 제공하기 전에, 
Flutter가 플랫폼 레벨에서 다른 코드와 상호 작용하는 방법을 설명합니다.

## 앱 해부하기 {:#anatomy-of-an-app}

다음 다이어그램은 `flutter create`로 생성된 일반 Flutter 앱을 구성하는 조각에 대한 개요를 제공합니다. 
Flutter Engine이 이 스택에서 어디에 있는지 보여주고, API 경계를 강조하며, 개별 조각이 있는 저장소를 식별합니다. 
아래의 범례는 Flutter 앱의 조각을 설명하는 데 일반적으로 사용되는 용어 중 일부를 명확히 설명합니다.

<img src='/assets/images/docs/app-anatomy.svg' alt='The layers of a Flutter app created by "flutter create": Dart app, framework, engine, embedder, runner'>

**Dart 앱**
* 위젯을 원하는 UI로 구성합니다.
* 비즈니스 로직을 구현합니다.
* 앱 개발자가 소유합니다.

**프레임워크** ([source code]({{site.repo.flutter}}/tree/main/packages/flutter/lib))
* 고품질 앱을 빌드하기 위한 더 높은 레벨 API를 제공합니다. (예: 위젯, 히트 테스트, 제스처 감지, 접근성, 텍스트 입력)
* 앱의 위젯 트리를 장면으로 합성합니다.

**엔진** ([source code]({{site.repo.engine}}/tree/main/shell/common))
* 합성된 장면을 래스터화하는 역할을 담당합니다.
* Flutter의 핵심 API(예: 그래픽, 텍스트 레이아웃, Dart 런타임)의 낮은 레벨 구현을 제공합니다.
* **dart:ui API**를 사용하여, 프레임워크에 기능을 노출합니다.
* Engine의 **Embedder API**를 사용하여, 특정 플랫폼과 통합합니다.

**Embedder** ([source code]({{site.repo.engine}}/tree/main/shell/platform))
* 렌더링 표면, 접근성, 입력과 같은 서비스에 액세스하기 위해 기본 운영 체제와 조정합니다.
* 이벤트 루프를 관리합니다.
* Embedder를 앱에 통합하기 위해 **플랫폼별 API**를 노출합니다.

**Runner**
* Embedder의 플랫폼별 API에서 노출된 부분을 대상 플랫폼에서 실행할 수 있는 앱 패키지로 구성합니다.
* 앱 개발자가 소유한, `flutter create`에서 생성된 앱 템플릿의 일부입니다.

## Reactive 사용자 인터페이스 {:#reactive-user-interfaces}

표면적으로, Flutter는 [Reactive 선언적 UI 프레임워크][faq]로, 
개발자가 애플리케이션 상태로부터 인터페이스 상태로의 매핑을 제공하고, 
프레임워크가 애플리케이션 상태가 변경될 때 런타임에 인터페이스를 업데이트하는 작업을 수행합니다. 
이 모델은 [Facebook에서 자체 React 프레임워크를 위해 만든 작업][fb]에서 영감을 받았으며, 
여기에는 많은 기존 디자인 원칙을 재고하는 내용이 포함됩니다.

[faq]: /resources/faq#what-programming-paradigm-does-flutters-framework-use
[fb]: {{site.yt.watch}}?time_continue=2&v=x7cQ3mrcKaY&feature=emb_logo

대부분의 기존 UI 프레임워크에서, 사용자 인터페이스의 초기 상태는 한 번 표현된 다음, 
이벤트에 대한 응답으로, 런타임에 사용자 코드에 의해 별도로 업데이트됩니다. 
이 접근 방식의 한 가지 과제는, 애플리케이션이 복잡해짐에 따라, 
개발자가 상태 변경이 전체 UI에서 어떻게 계단식으로 진행되는지 알아야 한다는 것입니다. 

예를 들어, 다음 UI를 고려해 보세요.

![Color picker dialog](/assets/images/docs/arch-overview/color-picker.png){:width="66%"}

상태를 변경할 수 있는 곳은 여러 군데 있습니다. 
색상 상자, 색조 슬라이더, 라디오 버튼입니다. 
사용자가 UI와 상호 작용할 때, 변경 사항은 다른 모든 곳에 반영되어야 합니다. 
더 나쁜 점은, 주의를 기울이지 않으면, 사용자 인터페이스의 한 부분을 약간만 변경해도, 
겉보기에 관련 없는 코드 조각에 파장 효과가 생길 수 있다는 것입니다.

이에 대한 한 가지 해결책은 MVC와 같은 접근 방식으로, 
컨트롤러를 통해 데이터 변경 사항을 모델에 푸시한 다음, 
모델이 컨트롤러를 통해 새 상태를 뷰에 푸시합니다. 
그러나, UI 요소를 만들고 업데이트하는 것은 쉽게 동기화되지 않을 수 있는 두 가지 별도의 단계이기 때문에 
이것도 문제가 있습니다.

Flutter는 다른 reactive 프레임워크와 함께, 이 문제에 대한 대안적 접근 방식을 취하는데, 
사용자 인터페이스를 기본 상태에서 명시적으로 분리합니다. 
React 스타일 API를 사용하면, UI 설명만 만들고, 
프레임워크는 해당 구성을 사용하여 사용자 인터페이스를 적절하게 만들고/또는 업데이트합니다.

Flutter에서, 위젯(React의 컴포넌트와 유사)은 객체 트리를 구성하는 데 사용되는 불변(immutable) 클래스로 표현됩니다. 
이러한 위젯은 레이아웃을 위한 별도의 객체 트리를 관리하는 데 사용되며, 
이는 합성을 위한 별도의 객체 트리를 관리하는 데 사용됩니다. 
Flutter는, 코어에서, 트리의 수정된 부분을 효율적으로 탐색하고, 
객체 트리를 더 낮은 레벨 객체 트리로 변환하고, 
이러한 트리에 변경 사항을 전파하기 위한 일련의 메커니즘입니다.

위젯은 상태를 UI로 변환하는 함수인 `build()` 메서드를 재정의하여, 사용자 인터페이스를 선언합니다.

```plaintext
UI = f(state)
```

`build()` 메서드는 설계상 실행 속도가 빠르고, 부수 효과가 없어야 하며, 
필요할 때마다 프레임워크에서 호출할 수 있어야 합니다. (렌더링된 프레임당 한 번 정도)

이 접근 방식은 언어 런타임의 특정 특성(특히, 빠른 객체 인스턴스화 및 삭제)에 의존합니다. 
다행히도 [Dart는 이 작업에 특히 적합]({{site.flutter-medium}}/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30)합니다.

## 위젯 {:#widgets}

언급했듯이, Flutter는 위젯을 유닛 단위로 강조합니다. 
위젯은 Flutter 앱의 사용자 인터페이스의 구성 요소이며, 각 위젯은 사용자 인터페이스의 일부에 대한 불변(immutable) 선언입니다.

위젯은 구성을 기반으로 계층 구조를 형성합니다. 
각 위젯은 부모 위젯 내부에 중첩되어, 부모 위젯에서 컨텍스트를 수신할 수 있습니다. 
이 구조는 루트 위젯(Flutter 앱을 호스팅하는 컨테이너, 일반적으로 `MaterialApp` 또는 `CupertinoApp`)까지 이어지며, 
이 간단한 예에서 알 수 있습니다.

<?code-excerpt "lib/main.dart (main)"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Home Page'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  const Text('Hello World'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Click!');
                    },
                    child: const Text('A button'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
```

이전 코드에서, 인스턴스화된 모든 클래스는 위젯입니다.

앱은 계층 구조의 위젯을 다른 위젯으로 바꾸도록 프레임워크에 알려 
이벤트(예: 사용자 상호작용)에 대한 응답으로 사용자 인터페이스를 업데이트합니다. 
그런 다음 프레임워크는 새 위젯과 이전 위젯을 비교하여, 사용자 인터페이스를 효율적으로 업데이트합니다.

Flutter는 시스템에서 제공하는 것을 따르지 않고 각 UI 컨트롤에 대한 자체 구현을 가지고 있습니다. 
예를 들어, 
순수한 [iOS Dart 구현]({{site.api}}/flutter/cupertino/CupertinoSwitch-class.html)이
[iOS 토글 컨트롤]({{site.apple-dev}}/design/human-interface-guidelines/toggles)에 대해 있으며,
[Android Dart 구현]({{site.api}}/flutter/material/Switch-class.html)도
[Android 스위치]({{site.material}}/components/switch)에 대해 존재합니다.

이 접근 방식은 여러 가지 이점을 제공합니다.

- 무제한 확장성을 제공합니다. 
  - Switch 컨트롤의 변형을 원하는 개발자는 임의의 방식으로 변형을 만들 수 있으며, OS에서 제공하는 확장 지점에 국한되지 않습니다.
- Flutter가 Flutter 코드와 플랫폼 코드 사이를 전환하지 않고도, 
  - 전체 장면을 한 번에 합성할 수 있도록 하여, 상당한 성능 병목 현상을 방지합니다.
- 어떠한 운영 체제 종속성에서라도 애플리케이션 동작을 분리합니다. 
  - OS에서 컨트롤 구현을 변경하더라도, 애플리케이션은 모든 버전의 OS에서 동일하게 보이고 느껴집니다.

### 구성 {:#composition}

위젯은 일반적으로 강력한 효과를 내기 위해 결합되는 여러 다른 작고 단일 목적의 위젯들로 구성됩니다.

가능한 경우, 디자인 개념의 수는 최소한으로 유지하면서 전체 어휘는 많아지도록 합니다. 
예를 들어, 위젯 레이어에서, Flutter는 동일한 핵심 개념(`Widget`)을 사용하여 화면에 그리기, 
레이아웃(위치 및 크기 조정), 사용자 상호 작용, 상태 관리, 테마, 애니메이션 및 네비게이션을 표현합니다. 
애니메이션 레이어에서, `Animation`과 `Tween`이라는 두 가지 개념이 대부분의 디자인 공간을 커버합니다.
렌더링 레이어에서, `RenderObject`는 레이아웃, 페인팅, 히트 테스트 및 접근성을 설명하는 데 사용됩니다. 
이러한 각 경우에, 해당 어휘는 많아집니다. : 수백 개의 위젯과 렌더 객체, 수십 개의 애니메이션 및 트윈 타입이 있습니다.

클래스 계층 구조는 가능한 조합의 수를 최대화하기 위해 의도적으로 얕고 넓게 설계되었으며, 
각각 잘하는 작고 구성 가능한 위젯에 초점을 맞춥니다. 
핵심 기능은 추상적이며, 패딩 및 정렬과 같은 기본 기능조차도 핵심에 내장되지 않고, 별도의 구성 요소로 구현됩니다. 
(이는 패딩과 같은 기능이 모든 레이아웃 구성 요소의 공통 핵심에 내장되는 보다 전통적인 API와도 대조됩니다.) 
예를 들어, 위젯을 가운데 정렬하려면, 명목상의 `Align` 속성을 조정하는 대신, 
[`Center`]({{site.api}}/flutter/widgets/Center-class.html) 위젯으로 래핑합니다.

패딩, 정렬, 행, 열 및 그리드를 위한 위젯이 있습니다. 
이러한 레이아웃 위젯은 자체의 시각적 표현이 없습니다. 
대신, 유일한 목적은 다른 위젯의 레이아웃의 일부 측면을 제어하는 ​​것입니다.
Flutter에는 이러한 구성적 접근 방식을 활용하는 유틸리티 위젯도 포함되어 있습니다.

예를 들어, 일반적으로 사용되는 위젯인 [`Container`]({{site.api}}/flutter/widgets/Container-class.html)는
레이아웃, 페인팅, 위치 지정, 크기를 담당하는 여러 위젯으로 구성됩니다. 
구체적으로, Container는 
[`LimitedBox`]({{site.api}}/flutter/widgets/LimitedBox-class.html), 
[`ConstrainedBox`]({{site.api}}/flutter/widgets/ConstrainedBox-class.html), 
[`Align`]({{site.api}}/flutter/widgets/Align-class.html), 
[`Padding`]({{site.api}}/flutter/widgets/Padding-class.html), 
[`DecoratedBox`]({{site.api}}/flutter/widgets/DecoratedBox-class.html), 및 
[`Transform`]({{site.api}}/flutter/widgets/Transform-class.html) 위젯으로 구성되어 있으며, 
이는 소스 코드를 읽어보면 알 수 있습니다. 
Flutter의 결정적 특징은 어떠한 위젯이라도 소스를 자세히 살펴보고 조사할 수 있다는 것입니다. 
따라서, 커스텀 효과를 만들기 위해 `Container`를 서브클래싱하는 대신, 
새로운 방식으로 `Container`와 다른 위젯을 구성하거나, 
`Container`를 영감으로 삼아 새로운 위젯을 만들 수 있습니다.

### 위젯 빌드 {:#building-widgets}

앞에서 언급했듯이, 위젯의 시각적 표현을 결정하려면 
[`build()`]({{site.api}}/flutter/widgets/StatelessWidget/build.html) 함수를 재정의하여 
새 요소 트리를 반환합니다. 
이 트리는 위젯의 사용자 인터페이스 부분을 더 구체적으로 나타냅니다. 
예를 들어, 툴바 위젯에는 
[텍스트]({{site.api}}/flutter/widgets/Text-class.html)와 
[다양한]({{site.api}}/flutter/material/IconButton-class.html) [버튼]({{site.api}}/flutter/material/PopupMenuButton-class.html)의 [수평 레이아웃]({{site.api}}/flutter/widgets/Row-class.html)을 
반환하는 빌드 함수가 있을 수 있습니다. 
필요에 따라, 프레임워크는 
각 위젯에 [구체적인 렌더링 가능한 객체]({{site.api}}/flutter/widgets/RenderObjectWidget-class.html)로 
트리가 완전히 설명될 때까지 빌드하도록 재귀적으로 요청합니다. 
그런 다음, 프레임워크는 렌더링 가능한 객체를 렌더링 가능한 객체 트리로 연결합니다.

위젯의 빌드 함수는 부수 효과가 없어야 합니다. 함수에 빌드하라는 요청이 있을 때마다, 
위젯은, 위젯이 이전에 반환한 내용과 관계없이, 새 위젯 트리<sup><a href="#a1">1</a></sup>를 반환해야 합니다. 
프레임워크는 렌더 객체 트리(나중에 자세히 설명)를 기반으로 호출해야 하는 빌드 메서드를 결정하는 힘든 작업을 수행합니다. 
이 프로세스에 대한 자세한 내용은 
[Inside Flutter 토픽](/resources/inside-flutter#linear-reconciliation)에서 확인할 수 있습니다.

렌더링된 각 프레임에서, Flutter는 위젯의 `build()` 메서드를 호출하여, 상태가 변경된 UI 부분만 다시 만들 수 있습니다. 
따라서, 빌드 메서드는 빠르게 반환해야 하며, 
무거운 계산 작업은 비동기 방식으로 수행한 다음 빌드 메서드에서 사용할 상태의 일부로 저장해야 합니다.

비교적 순진한 접근 방식이기는 하지만, 이 자동화된 비교는 매우 효과적이어서, 고성능 상호 작용 앱을 구현할 수 있습니다. 
또한, 빌드 함수의 디자인은 사용자 인터페이스를 한 상태에서 다른 상태로 업데이트하는 복잡성보다는, 
위젯이 무엇으로 구성되어 있는지 선언하는 데 중점을 두어 코드를 단순화합니다.

### 위젯 상태 {:#widget-state}

프레임워크는 위젯의 두 가지 주요 클래스인 _stateful_ 및 _stateless_ 위젯을 도입합니다.

많은 위젯에는 변경 가능한(mutable) 상태가 없습니다. 즉, 시간이 지남에 따라 변경되는 속성(예: 아이콘 또는 레이블)이 없습니다. 
이러한 위젯은 [`StatelessWidget`]({{site.api}}/flutter/widgets/StatelessWidget-class.html)의 하위 클래스입니다.

그러나, 위젯의 고유한 특성이 사용자 상호 작용이나 기타 요인에 따라 변경되어야 하는 경우, 해당 위젯은 _stateful_ 입니다. 
예를 들어, 위젯에 사용자가 버튼을 탭할 때마다 증가하는 카운터가 있는 경우, 카운터의 값은 해당 위젯의 상태입니다. 
해당 값이 변경되면, 위젯을 다시 빌드하여, UI의 해당 부분을 업데이트해야 합니다. 
이러한 위젯은 
[`StatefulWidget`]({{site.api}}/flutter/widgets/StatefulWidget-class.html)의 하위 클래스이며, 
(왜냐하면 위젯 자체가 변경 불가능(immutable)하므로) 
[`State`]({{site.api}}/flutter/widgets/State-class.html)의 하위 클래스인 별도의 클래스에 
변경 가능한 상태를 저장합니다. 
`StatefulWidget`에는 빌드 메서드가 없습니다. 대신, 사용자 인터페이스는 `State` 객체를 통해 빌드됩니다.

`State` 객체를 변형(mutate)할 때마다(예: 카운터를 증가시켜서), 
`State`의 빌드 메서드를 다시 호출하여 사용자 인터페이스를 업데이트하도록 프레임워크에 신호를 보내려면
[`setState()`]({{site.api}}/flutter/widgets/State/setState.html)을 호출해야 합니다.

별도의 상태 및 위젯 객체를 사용하면, 다른 위젯이 상태 손실에 대해 걱정하지 않고도,
stateless 위젯과 stateful 위젯을 정확히 같은 방식으로 처리할 수 있습니다. 
상태를 보존하기 위해 자식을 붙잡아둘 필요가 없는 대신, 
부모는 자식의 지속 상태를 잃지 않고, 언제든지 자식의 새 인스턴스를 만들 수 있습니다. 
프레임워크는 적절한 경우 기존 상태 객체를 찾고 재사용하는 모든 작업을 수행합니다.

### 상태 관리 {:#state-management}

그렇다면, 많은 위젯이 상태를 포함할 수 있다면, 상태는 어떻게 관리되고 시스템 주변으로 전달될까요?

다른 클래스와 마찬가지로, 위젯에서 생성자를 사용하여 데이터를 초기화할 수 있으므로, 
`build()` 메서드는 어떠한 자식 위젯이라도 필요한 데이터로 인스턴스화되도록 할 수 있습니다.

```dart
@override
Widget build(BuildContext context) {
   return ContentWidget([!importantState!]);
}
```

여기서 `importantState`는 `Widget`에 중요한 상태를 포함하는 클래스의 플레이스홀더입니다.

그러나, 위젯 트리가 깊어질수록, 트리 계층 구조에서 상태 정보를 위아래로 전달하는 것이 번거로워집니다. 
따라서, 세 번째 위젯 타입인, [`InheritedWidget`][]은 공유된 조상에서 데이터를 가져오는 쉬운 방법을 제공합니다. 
이 예에서 보듯이, `InheritedWidget`을 사용하여 위젯 트리에서 공통 조상을 래핑하는 상태 위젯을 만들 수 있습니다.

![Inherited widgets](/assets/images/docs/arch-overview/inherited-widget.png){:width="50%"}

[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html

`ExamWidget` 또는 `GradeWidget` 객체 중 하나에 `StudentState`의 데이터가 필요할 때마다, 
다음과 같은 명령을 사용하여 해당 데이터에 액세스할 수 있습니다.

```dart
final studentState = StudentState.of(context);
```

`of(context)` 호출은 빌드 컨텍스트(현재 위젯 위치의 핸들)를 가져와서, 
`StudentState` 타입과 일치하는 [트리에서 가장 가까운 조상][the nearest ancestor in the tree]을 반환합니다.
`InheritedWidget`은 또한 `updateShouldNotify()` 메서드를 제공하는데, 
Flutter는 이 메서드를 호출하여 상태 변경이 해당 상태 변경을 사용하는 자식 위젯의 재빌드를 트리거해야 하는지 여부를 판별합니다.

[the nearest ancestor in the tree]: {{site.api}}/flutter/widgets/BuildContext/dependOnInheritedWidgetOfExactType.html

Flutter 자체는 공유 상태를 위한 프레임워크의 일부로 `InheritedWidget`을 광범위하게 사용합니다. 
여기에는 애플리케이션 전체에 걸쳐 널리 퍼져 있는
[색상 및 글꼴 스타일과 같은 속성][properties like color and type styles]이 포함된 
애플리케이션의 _시각적 테마_ 가 포함됩니다. 
`MaterialApp` `build()` 메서드는 빌드할 때 트리에 테마를 삽입한 다음, 
계층 구조에서 더 깊은 위젯은 `.of()` 메서드를 사용하여 관련 테마 데이터를 조회할 수 있습니다.

예를 들어:

<?code-excerpt "lib/main.dart (container)"?>
```dart
Container(
  color: Theme.of(context).secondaryHeaderColor,
  child: Text(
    'Text with a background color',
    style: Theme.of(context).textTheme.titleLarge,
  ),
);
```

[properties like color and type styles]: {{site.api}}/flutter/material/ThemeData-class.html

애플리케이션이 커짐에 따라, stateful 위젯을 만들고 사용하는 의식을 줄이는, 
보다 진보된 상태 관리 접근 방식이 더욱 매력적으로 다가옵니다. 
많은 Flutter 앱은 `InheritedWidget`을 감싸는 래퍼를 제공하는 
[provider]({{site.pub}}/packages/provider)와 같은 유틸리티 패키지를 사용합니다. 
Flutter의 계층적 아키텍처는 [flutter_hooks]({{site.pub}}/packages/flutter_hooks) 패키지와 같이 
상태를 UI로 변환하는 대체 접근 방식도 가능하게 합니다.

## 렌더링 및 레이아웃 {:#rendering-and-layout}

이 섹션에서는 렌더링 파이프라인에 대해 설명합니다. 
렌더링 파이프라인은 Flutter가 위젯 계층을 화면에 실제로 그려지는 픽셀로 변환하는 일련의 단계입니다.

### Flutter의 렌더링 모델 {:#flutters-rendering-model}

Flutter가 크로스 플랫폼 프레임워크라면, 단일 플랫폼 프레임워크와 비슷한 성능을 어떻게 제공할 수 있을까?

기존 Android 앱의 작동 방식에 대해 생각해보는 것으로 시작하는 것이 좋습니다. 
드로잉을 할 때는, 먼저 Android 프레임워크의 Java 코드를 호출합니다. 
Android 시스템 라이브러리는 자체적으로 그리기를 담당하는 구성 요소를 `Canvas` 객체에 제공하고, 
Android는 이를 C/C++로 작성된 그래픽 엔진인 [Skia][]로 렌더링하여, 
CPU 또는 GPU를 호출하여 장치에서 그리기를 완료합니다.

크로스 플랫폼 프레임워크는 _일반적으로_ 기본 네이티브 Android 및 iOS UI 라이브러리 위에 추상 레이어를 생성하여, 
각 플랫폼 표현의 불일치를 매끄럽게 처리하려고 시도합니다. 
앱 코드는 종종 JavaScript와 같은 해석 언어로 작성되며, 
이는 UI를 표시하기 위해 Java 기반 Android 또는 Objective-C 기반 iOS 시스템 라이브러리와 상호 작용해야 합니다. 
이 모든 것이 상당할 수 있는 오버헤드를 추가합니다. 특히, UI와 앱 로직 간에 상호 작용이 많은 경우 더욱 그렇습니다.

반면, Flutter는 이러한 추상화를 최소화하여, 시스템 UI 위젯 라이브러리를 우회하고, 자체 위젯 세트를 사용합니다. 
Flutter의 비주얼을 페인트하는 Dart 코드는 렌더링을 위해, 
Skia(또는 향후 Impeller)를 사용하는, 네이티브 코드로 컴파일됩니다. 
Flutter는 또한 엔진의 일부로 Skia의 자체 사본을 내장하여, 
개발자가, 앱을 업그레이드하여 휴대전화가 새로운 Android 버전으로 업데이트되지 않았더라도, 
최신 성능 개선 사항으로 업데이트 상태를 유지할 수 있습니다. 
Windows나 macOS와 같은, 다른 네이티브 플랫폼의 Flutter도 마찬가지입니다.

:::note
Flutter 3.10은 iOS에서 Impeller를 기본 렌더링 엔진으로 설정했습니다. 
`enable-impeller` 플래그 뒤에서 Android에서 Impeller를 미리 볼 수 있습니다. 
자세한 내용은, [Impeller 렌더링 엔진][Impeller]를 확인하세요.
:::

### 사용자 입력에서 GPU로 {:#from-user-input-to-the-gpu}

Flutter가 렌더링 파이프라인에 적용하는 overriding 원칙은 **간단함이 빠르다**는 것입니다. 
Flutter는, 다음 시퀀싱 다이어그램에서 볼 수 있듯이, 데이터가 시스템으로 흐르는 방식에 대한 간단한 파이프라인을 가지고 있습니다.

![Render pipeline sequencing diagram](/assets/images/docs/arch-overview/render-pipeline.png){:width="100%"}

이러한 단계 중 일부를 더 자세히 살펴보겠습니다.

### 빌드: Widget에서 Element로 {:#build-from-widget-to-element}

위젯 계층구조를 보여주는 이 코드 조각을 고려해 보세요.

<?code-excerpt "lib/main.dart (widget-hierarchy)"?>
```dart
Container(
  color: Colors.blue,
  child: Row(
    children: [
      Image.network('https://www.example.com/1.png'),
      const Text('A'),
    ],
  ),
);
```

Flutter가 이 조각을 렌더링해야 할 때, `build()` 메서드를 호출합니다. 
이 메서드는 현재 앱 상태에 따라 UI를 렌더링하는 위젯의 하위 트리를 반환합니다. 
이 프로세스 중에, `build()` 메서드는, 필요에 따라, 상태에 따라, 새 위젯을 도입할 수 있습니다. 
예를 들어, 앞의 코드 조각에서, `Container`에는 `color` 및 `child` 속성이 있습니다. 
`Container`의 [소스 코드]({{site.repo.flutter}}/blob/02efffc134ab4ce4ff50a9ddd86c832efdb80462/packages/flutter/lib/src/widgets/container.dart#L401)를 살펴보면, 
색상이 null이 아니면, 색상을 나타내는 `ColoredBox`를 삽입하는 것을 볼 수 있습니다.

```dart
if (color != null)
  current = ColoredBox(color: color!, child: current);
```

그에 따라, `Image` 및 `Text` 위젯은 빌드 프로세스 중에 
`RawImage` 및 `RichText`와 같은 자식 위젯을 삽입할 수 있습니다. 
따라서 최종 위젯 계층 구조는 이 경우처럼<sup><a href="#a2">2</a></sup> 코드가 나타내는 것보다 더 깊을 수 있습니다.:

![Render pipeline sequencing diagram](/assets/images/docs/arch-overview/widgets.png){:width="35%"}

이는, Flutter/Dart DevTools의 일부인, [Flutter inspector](/tools/devtools/inspector)와 같은,
디버그 도구를 통해 트리를 검사할 때, 원래 코드에 있는 것보다 상당히 더 깊은 구조를 볼 수 있는 이유를 설명합니다.

빌드 단계에서, Flutter는 코드로 표현된 위젯을, 각 위젯에 대해 하나의 요소가 있는,
해당 **요소 트리(element tree)** 로 변환합니다. 
각 요소는 트리 계층 구조의 지정된 위치에 있는 위젯의 특정 인스턴스를 나타냅니다. 
요소에는 두 가지 기본 타입이 있습니다.

- `ComponentElement` : 다른 요소의 호스트
- `RenderObjectElement` : 레이아웃 또는 페인트 단계에 참여하는 요소

![Render pipeline sequencing diagram](/assets/images/docs/arch-overview/widget-element.png){:width="85%"}

`RenderObjectElement`는 위젯 아날로그와 나중에 살펴볼 기본 `RenderObject` 사이의 중개자(intermediary)입니다.

어떠한 위젯의 요소라도, 트리에서 위젯의 위치에 대한 핸들인, `BuildContext`를 통해 참조할 수 있습니다. 
이는 `Theme.of(context)`와 같은 함수 호출에서 `context`이며, 매개변수로 `build()` 메서드에 제공됩니다.

위젯은, 노드 간의 부모/자식 관계를 포함하여, 변경할 수 없으므로(immutable), 
위젯 트리를 변경하면(예: 이전 예에서 `Text('A')`를 `Text('B')`로 변경) 새 위젯 객체 세트가 반환됩니다. 
하지만 기본 표현을 다시 빌드해야 한다는 의미는 아닙니다. 
요소 트리는 프레임마다 지속되므로, 중요한 성능 역할을 하며, 
Flutter가 위젯 계층 구조가 기본 표현을 캐싱하는 동안 완전히 폐기 가능한 것처럼 작동할 수 있습니다. 
변경된 위젯만 검토함으로써, Flutter는 재구성이 필요한 요소 트리 부분만 다시 빌드할 수 있습니다.

### 레이아웃 및 렌더링 {:#layout-and-rendering}

위젯 하나만 그리는 애플리케이션은 드뭅니다. 
따라서 어떤 UI 프레임워크(An important part of any UI framework)의 중요한 부분은 위젯 계층을 효율적으로 레이아웃하고, 
화면에 렌더링되기 전에 각 요소의 크기와 위치를 결정하는 기능입니다.

렌더 트리의 모든 노드에 대한 베이스 클래스는 
[`RenderObject`]({{site.api}}/flutter/rendering/RenderObject-class.html)로, 
레이아웃과 페인팅을 위한 추상 모델을 정의합니다. 
이는 매우 일반적입니다. 고정된 차원 수나 데카르트 좌표계([이 극좌표계 예]({{site.dartpad}}/?id=596b1d6331e3b9d7b00420085fab3e27)에서 보여짐)에 의존하지 않습니다. 
각 `RenderObject`는 부모를 알고 있지만, 자식과 해당 제약 조건을 _방문_ 하는 방법 외에는, 자식에 대해 거의 알지 못합니다.
이는 다양한 사용 사례를 처리할 수 있는 충분한 추상화를 `RenderObject`에 제공합니다.

빌드 단계에서, Flutter는 요소 트리의 각 `RenderObjectElement`에 대해, 
`RenderObject`를 상속하는 객체를 생성하거나 업데이트합니다. 
`RenderObject`는 기본형(primitives)입니다. 
[`RenderParagraph`]({{site.api}}/flutter/rendering/RenderParagraph-class.html)는 텍스트를 렌더링하고, 
[`RenderImage`]({{site.api}}/flutter/rendering/RenderImage-class.html)는 이미지를 렌더링하고, 
[`RenderTransform`]({{site.api}}/flutter/rendering/RenderTransform-class.html)은 자식을 페인팅하기 전에 변환을 적용합니다.

![Differences between the widgets hierarchy and the element and render trees](/assets/images/docs/arch-overview/trees.png){:width="100%"}

대부분의 Flutter 위젯은, 2D 데카르트 공간에서 고정된 크기의 `RenderObject`를 나타내는, 
`RenderBox` 하위 클래스에서 상속된 객체에 의해 렌더링됩니다. 
`RenderBox`는 _상자 제약 조건 모델_ 의 기반을 제공하여, 렌더링할 각 위젯의 최소 및 최대 너비와 높이를 설정합니다.

레이아웃을 수행하기 위해, Flutter는 깊이 우선 순회(depth-first traversal)에서 렌더 트리를 탐색하고, 
부모에서 자식으로 **크기 제약 조건을 전달(passes down size constraints)** 합니다. 
자식은 크기를 결정할 때, 부모가 제공한 제약 조건을 _반드시_ 존중해야 합니다. 
자식은 부모가 설정한 제약 조건 내에서 부모 객체에 **크기를 전달하여(passing up a size)** 응답합니다.

![Constraints go down, sizes go up](/assets/images/docs/arch-overview/constraints-sizes.png){:width="80%"}

이 단일 트리 워크(this single walk through the tree)가 끝나면, 
모든 객체는 부모의 제약 조건 내에서 정의된 크기를 갖게 되고, 
[`paint()`]({{site.api}}/flutter/rendering/RenderObject/paint.html) 메서드를 호출하여 페인팅할 준비가 됩니다.

상자 제약 모델은 _O(n)_ 시간 내에 객체를 레이아웃하는 방법으로 매우 강력합니다.

- 부모는 최대 및 최소 제약 조건을 동일한 값으로 설정하여 자식 객체의 크기를 지정할 수 있습니다. 
  예를 들어, 휴대폰 앱의 최상위 렌더 객체는 자식을 화면 크기로 제한합니다. 
  (자식은 그 공간을 어떻게 사용할지 선택할 수 있습니다. 
   예를 들어, 지시된 제약 조건 내에서 렌더링하려는 것을 중앙에 배치할 수 있습니다.)
- 부모는 자녀의 너비를 지시하지만 자녀에게 높이에 대한 유연성을 제공할 수 있습니다.
  (또는 높이는 지시하지만 너비에 대한 유연성을 제공할 수 있습니다) 
  실제 사례는, 수평 제약에 맞아야 하지만 텍스트 양에 따라 수직으로 달라야 할 수 있는, 흐름 텍스트입니다.

이 모델은 자식 객체가 콘텐츠를 렌더링하는 방법을 결정하기 위해, 사용 가능한 공간의 양을 알아야 할 때에도 작동합니다. [`LayoutBuilder`]({{site.api}}/flutter/widgets/LayoutBuilder-class.html) 위젯을 사용하면, 
자식 객체가 전달된 제약 조건을 검사하고, 이를 사용하여 사용 방법을 결정할 수 있습니다. 예를 들면, 다음과 같습니다. :

<?code-excerpt "lib/main.dart (layout-builder)"?>
```dart
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return const OneColumnLayout();
      } else {
        return const TwoColumnLayout();
      }
    },
  );
}
```

제약 조건 및 레이아웃 시스템에 대한 자세한 내용과 작업 예제는, 
[제약 조건 이해](/ui/layout/constraints) 토픽에서 확인할 수 있습니다.

모든 `RenderObject`의 루트는 `RenderView`로, 렌더 트리의 전체 출력을 나타냅니다. 
플랫폼에서 새 프레임을 렌더링해야 하는 경우(예: [vsync](https://source.android.com/devices/graphics/implement-vsync) 또는 텍스처 압축 해제/업로드가 완료되었기 때문), 
렌더 트리 루트에 있는 `RenderView` 객체의 일부인 `compositeFrame()` 메서드에 대한 호출이 이루어집니다.
이렇게 하면 장면 업데이트를 트리거하는 `SceneBuilder`가 생성됩니다. 
장면이 완료되면, `RenderView` 객체는 합성된 장면을 `dart:ui`의 `Window.render()` 메서드에 전달하고, 
이 메서드는 GPU에 제어를 전달하여 렌더링합니다.

파이프라인의 구성 및 래스터화 단계에 대한 자세한 내용은 이 높은 레벨(high-level) 글의 범위를 벗어나지만, 
[Flutter 렌더링 파이프라인에 대한 이 강연]({{site.yt.watch}}?v=UUfXWzp0-DU)에서 더 많은 정보를 찾을 수 있습니다.

## 플랫폼 임베딩 {:#platform-embedding}

앞서 살펴본 바와 같이, Flutter 사용자 인터페이스는 동등한 OS 위젯으로 변환되는 것이 아니라, 
Flutter 자체에서 빌드, 레이아웃, 합성, 페인팅합니다. 
기본 운영 체제의 텍스처를 얻고 앱 라이프사이클에 참여하는 메커니즘은 해당 플랫폼의 고유한 관심사에 따라 불가피하게 달라집니다.
엔진은 플랫폼에 구애받지 않으며, _플랫폼 임베더_ 에 Flutter를 설정하고 사용할 수 있는 방법을 제공하는 
[안정적인 ABI(Application Binary Interface)]({{site.repo.engine}}/blob/main/shell/platform/embedder/embedder.h)를 제공합니다.

플랫폼 임베더는 모든 Flutter 콘텐츠를 호스팅하는 네이티브 OS 애플리케이션이며, 
호스트 운영 체제와 Flutter 간의 접착제 역할을 합니다. 
Flutter 앱을 시작하면, 임베더가 진입점을 제공하고, Flutter 엔진을 초기화하고, 
UI 및 래스터링을 위한 스레드를 얻어오고, Flutter가 쓸 수 있는 텍스처를 만듭니다. 
임베더는 또한 입력 제스처(예: 마우스, 키보드, 터치), 창 크기 조정, 스레드 관리 및 플랫폼 메시지를 포함한 
앱 수명 주기를 담당합니다. 
Flutter에는 Android, iOS, Windows, macOS 및 Linux용 플랫폼 임베더가 포함되어 있습니다. 
VNC 스타일 프레임버퍼를 통한 Flutter 세션 원격화를 지원하는 [이 작동 예제]({{site.github}}/chinmaygarde/fluttercast) 또는 [Raspberry Pi를 위한 이 작동 예제]({{site.github}}/ardera/flutter-pi)와 같이 
커스텀 플랫폼 임베더를 만들 수도 있습니다.

각 플랫폼에는 고유한 API와 제약 조건이 있습니다. 플랫폼별 간략한 참고 사항입니다.:

- iOS와 macOS에서, Flutter는 각각 `UIViewController` 또는 `NSViewController`로 임베더에 로드됩니다. 
  플랫폼 임베더는 
  (Dart VM과 Flutter 런타임의 호스트 역할을 하는) `FlutterEngine`과 
  (`FlutterEngine`에 연결되어 UIKit 또는 Cocoa 입력 이벤트를 Flutter에 전달하고 
  Metal 또는 OpenGL을 사용하여 `FlutterEngine`에서 렌더링한 프레임을 표시하는) `FlutterViewController`를 만듭니다.
- Android에서, Flutter는, 기본적으로, 임베더에 `Activity`로 로드됩니다. 
  뷰는 [`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)에 의해 제어되며, Flutter 콘텐츠의 구성 및 z-ordering 요구 사항에 따라, Flutter 콘텐츠를 뷰 또는 텍스처로 렌더링합니다.
- Windows에서, Flutter는 기존 Win32 앱에 호스팅되고, 
  콘텐츠는, OpenGL API 호출을 DirectX 11과 동등한 것으로 변환하는 라이브러리인, 
  [ANGLE](https://chromium.googlesource.com/angle/angle/+/master/README.md)을 사용하여 렌더링됩니다.

## 다른 코드와 통합 {:#integrating-with-other-code}

Flutter는 Kotlin이나 Swift와 같은 언어로 작성된 코드나 API에 액세스하거나, 네이티브 C 기반 API를 호출하거나, 
Flutter 앱에 네이티브 컨트롤을 내장하거나, 기존 애플리케이션에 Flutter를 내장하는 등 다양한 상호 운용성 메커니즘을 제공합니다.

### 플랫폼 채널 {:#platform-channels}

모바일 및 데스크톱 앱의 경우, Flutter를 사용하면 _플랫폼 채널_ 을 통해 커스텀 코드를 호출할 수 있습니다. 
이는 Dart 코드와 호스트 앱의 플랫폼별 코드 간에 통신하는 메커니즘입니다. 
공통 채널(이름과 코덱을 캡슐화)을 생성하면, 
Dart와 Kotlin 또는 Swift와 같은 언어로 작성된 플랫폼 구성 요소 간에 메시지를 보내고 받을 수 있습니다. 
데이터는 `Map`과 같은 Dart 타입에서 표준 형식으로 직렬화된 다음, 
Kotlin(예: `HashMap`) 또는 Swift(예: `Dictionary`)의 동등한 표현으로 역직렬화됩니다.

![How platform channels allow Flutter to communicate with host code](/assets/images/docs/arch-overview/platform-channels.png){:width="70%"}

다음은 Kotlin(Android) 또는 Swift(iOS)에서 이벤트 핸들러를 수신하는 Dart 호출의 짧은 플랫폼 채널 예입니다.

<?code-excerpt "lib/main.dart (method-channel)"?>
```dart
// Dart side
const channel = MethodChannel('foo');
final greeting = await channel.invokeMethod('bar', 'world') as String;
print(greeting);
```

```kotlin
// Android (Kotlin)
val channel = MethodChannel(flutterView, "foo")
channel.setMethodCallHandler { call, result ->
  when (call.method) {
    "bar" -> result.success("Hello, ${call.arguments}")
    else -> result.notImplemented()
  }
}
```

```swift
// iOS (Swift)
let channel = FlutterMethodChannel(name: "foo", binaryMessenger: flutterView)
channel.setMethodCallHandler {
  (call: FlutterMethodCall, result: FlutterResult) -> Void in
  switch (call.method) {
    case "bar": result("Hello, \(call.arguments as! String)")
    default: result(FlutterMethodNotImplemented)
  }
}
```

데스크톱 플랫폼의 예를 포함한, 플랫폼 채널 사용의 추가 예는, 
[flutter/packages]({{site.repo.packages}}) 저장소에서 찾을 수 있습니다. 
또한 Firebase에서 광고, 카메라 및 블루투스와 같은 장치 하드웨어에 이르기까지, 
다양한 일반적인 시나리오를 포괄하는 Flutter용 (이미) [수천 개의 플러그인을 사용할 수]({{site.pub}}/flutter)도 있습니다.

### Foreign Function Interface {:#foreign-function-interface}

Rust나 Go와 같은 최신 언어로 작성된 코드에 대해 생성할 수 있는 API를 포함한 C 기반 API의 경우, 
Dart는 `dart:ffi` 라이브러리를 사용하여 네이티브 코드에 바인딩하기 위한 직접적인 메커니즘을 제공합니다. 
외부 함수 인터페이스(FFI) 모델은, 데이터를 전달하는 데 직렬화가 필요하지 않기 때문에, 플랫폼 채널보다 상당히 빠를 수 있습니다.
대신, Dart 런타임은 Dart 객체로 백업된(backed) 힙에 메모리를 할당하고 
정적 또는 동적으로 연결된 라이브러리를 호출하는 기능을 제공합니다. 
FFI는 웹을 제외한 모든 플랫폼에서 사용할 수 있으며, [js 패키지]({{site.pub}}/packages/js)가 동일한 목적을 제공합니다.

FFI를 사용하려면, 각 Dart 및 관리되지 않는 메서드 시그니처에 대해 
`typedef`를 만들고 Dart VM에 이들 사이를 매핑하도록 지시합니다. 
예를 들어, 다음은 기존 Win32 `MessageBox()` API를 호출하는 코드 조각입니다.

<?code-excerpt "lib/ffi.dart" remove="ignore:"?>
```dart
import 'dart:ffi';
import 'package:ffi/ffi.dart'; // .toNativeUtf16() 확장 메서드가 포함되어 있습니다.

typedef MessageBoxNative = Int32 Function(
  IntPtr hWnd,
  Pointer<Utf16> lpText,
  Pointer<Utf16> lpCaption,
  Int32 uType,
);

typedef MessageBoxDart = int Function(
  int hWnd,
  Pointer<Utf16> lpText,
  Pointer<Utf16> lpCaption,
  int uType,
);

void exampleFfi() {
  final user32 = DynamicLibrary.open('user32.dll');
  final messageBox =
      user32.lookupFunction<MessageBoxNative, MessageBoxDart>('MessageBoxW');

  final result = messageBox(
    0, // 소유자 창 없음 (No owner window)
    'Test message'.toNativeUtf16(), // 메시지 (Message)
    'Window caption'.toNativeUtf16(), // 윈도우 타이틀 (Window title)
    0, // OK 버튼만 (OK button only)
  );
}
```

### Flutter 앱에서 네이티브 컨트롤 렌더링 {:#rendering-native-controls-in-a-flutter-app}

Because Flutter content is drawn to a texture and its widget tree is entirely
internal, there's no place for something like an Android view to exist within
Flutter's internal model or render interleaved within Flutter widgets. That's a
problem for developers that would like to include existing platform components
in their Flutter apps, such as a browser control.

Flutter solves this by introducing platform view widgets
([`AndroidView`]({{site.api}}/flutter/widgets/AndroidView-class.html)
and [`UiKitView`]({{site.api}}/flutter/widgets/UiKitView-class.html))
that let you embed this kind of content on each platform. Platform views can be
integrated with other Flutter content<sup><a href="#a3">3</a></sup>. Each of
these widgets acts as an intermediary to the underlying operating system. For
example, on Android, `AndroidView` serves three primary functions:

- Making a copy of the graphics texture rendered by the native view and
  presenting it to Flutter for composition as part of a Flutter-rendered surface
  each time the frame is painted.
- Responding to hit testing and input gestures, and translating those into the
  equivalent native input.
- Creating an analog of the accessibility tree, and passing commands and
  responses between the native and Flutter layers.

Inevitably, there is a certain amount of overhead associated with this
synchronization. In general, therefore, this approach is best suited for complex
controls like Google Maps where reimplementing in Flutter isn't practical.

Typically, a Flutter app instantiates these widgets in a `build()` method based
on a platform test. As an example, from the
[google_maps_flutter]({{site.pub}}/packages/google_maps_flutter) plugin:

```dart
if (defaultTargetPlatform == TargetPlatform.android) {
  return AndroidView(
    viewType: 'plugins.flutter.io/google_maps',
    onPlatformViewCreated: onPlatformViewCreated,
    gestureRecognizers: gestureRecognizers,
    creationParams: creationParams,
    creationParamsCodec: const StandardMessageCodec(),
  );
} else if (defaultTargetPlatform == TargetPlatform.iOS) {
  return UiKitView(
    viewType: 'plugins.flutter.io/google_maps',
    onPlatformViewCreated: onPlatformViewCreated,
    gestureRecognizers: gestureRecognizers,
    creationParams: creationParams,
    creationParamsCodec: const StandardMessageCodec(),
  );
}
return Text(
    '$defaultTargetPlatform is not yet supported by the maps plugin');
```

Communicating with the native code underlying the `AndroidView` or `UiKitView`
typically occurs using the platform channels mechanism, as previously described.

At present, platform views aren't available for desktop platforms, but this is
not an architectural limitation; support might be added in the future.

### 부모 앱에서 Flutter 콘텐츠 호스팅 {:#hosting-flutter-content-in-a-parent-app}

The converse of the preceding scenario is embedding a Flutter widget in an
existing Android or iOS app. As described in an earlier section, a newly created
Flutter app running on a mobile device is hosted in an Android activity or iOS
`UIViewController`. Flutter content can be embedded into an existing Android or
iOS app using the same embedding API.

The Flutter module template is designed for easy embedding; you can either embed
it as a source dependency into an existing Gradle or Xcode build definition, or
you can compile it into an Android Archive or iOS Framework binary for use
without requiring every developer to have Flutter installed.

The Flutter engine takes a short while to initialize, because it needs to load
Flutter shared libraries, initialize the Dart runtime, create and run a Dart
isolate, and attach a rendering surface to the UI. To minimize any UI delays
when presenting Flutter content, it's best to initialize the Flutter engine
during the overall app initialization sequence, or at least ahead of the first
Flutter screen, so that users don't experience a sudden pause while the first
Flutter code is loaded. In addition, separating the Flutter engine allows it to
be reused across multiple Flutter screens and share the memory overhead involved
with loading the necessary libraries.

More information about how Flutter is loaded into an existing Android or iOS app
can be found at the [Load sequence, performance and memory
topic](/add-to-app/performance).

## Flutter 웹 지원 {:#flutter-web-support}

일반적인 아키텍처 개념은 Flutter가 지원하는 모든 플랫폼에 적용되지만, 
Flutter의 웹 지원에는 주석을 달 만한 고유한 특징이 있습니다.

Dart는 언어가 존재하는 한 오랫동안 JavaScript로 컴파일되어 왔으며, 
개발 및 프로덕션 목적 모두에 최적화된 툴체인이 있습니다. 
오늘날 많은 중요한 앱이 Dart에서 JavaScript로 컴파일되어 프로덕션에서 실행되고 있으며, 
여기에는 [Google Ads용 광고주 툴링](https://ads.google.com/home/)도 포함됩니다. 
Flutter 프레임워크는 Dart로 작성되었기 때문에, JavaScript로 컴파일하는 것이 비교적 간단했습니다.

그러나, C++로 작성된, Flutter 엔진은, 웹 브라우저가 아닌 기본 운영 체제와 인터페이스하도록 설계되었습니다. 
따라서 다른 접근 방식이 필요합니다. 
웹에서, Flutter는 표준 브라우저 API 위에 엔진을 다시 구현합니다. 
현재 웹에서 Flutter 콘텐츠를 렌더링하는 데는 HTML과 WebGL의 두 가지 옵션이 있습니다. 
HTML 모드에서, Flutter는 HTML, CSS, Canvas 및 SVG를 사용합니다. 
WebGL로 렌더링하기 위해, Flutter는 [CanvasKit](https://skia.org/docs/user/modules/canvaskit/)이라는
WebAssembly로 컴파일된 Skia 버전을 사용합니다. 
HTML 모드가 최상의 코드 크기 특성을 제공하는 반면, 
`CanvasKit`은 브라우저의 그래픽 스택으로 가는 가장 빠른 경로를 제공하고, 
기본 모바일 대상에서 다소 더 높은 그래픽 충실도를 제공합니다. <sup><a href="#a4">4</a></sup>

아키텍처 레이어 다이어그램의 웹 버전은 다음과 같습니다.

![Flutter web architecture](/assets/images/docs/arch-overview/web-arch.png){:width="100%"}

아마도 Flutter가 실행되는 다른 플랫폼과 비교했을 때 가장 눈에 띄는 차이점은,
Flutter가 Dart 런타임을 제공할 필요가 없다는 것입니다. 
대신, Flutter 프레임워크(작성하는 모든 코드와 함께)는 JavaScript로 컴파일됩니다. 
또한 Dart는 모든 모드(JIT vs. AOT, 네이티브 vs. 웹 컴파일)에서 언어 의미적 차이가 거의 없으며,
대부분 개발자는 그런 차이가 있는 코드 한 줄도 작성하지 않을 것입니다.

개발 시에, Flutter 웹은, 
증분 컴파일(incremental compilation)을 지원하고 따라서 앱에 대한 핫 리스타트(현재 핫 리로드는 아님)를 허용하는 컴파일러인, 
[`dartdevc`]({{site.dart-site}}/tools/dartdevc)를 사용합니다. 
반대로, 웹용 프로덕션 앱을 만들 준비가 되면, 
Dart의 고도로 최적화된 프로덕션 JavaScript 컴파일러인 [`dart2js`]({{site.dart-site}}/tools/dart2js)가 사용되어,
Flutter 코어와 프레임워크를 애플리케이션과 함께 축소된 소스 파일로 패키징하여, 어떠한 웹 서버에라도 배포할 수 있습니다. 
코드는 단일 파일에 제공하거나, [지연된 가져오기(deferred imports)][deferred imports]를 통해, 
여러 파일로 분할할 수 있습니다.

[deferred imports]: {{site.dart-site}}/language/libraries#lazily-loading-a-library

## Further 정보 {:#further-information}

Flutter의 내부에 대해 더 많은 정보를 원하는 분들을 위해, [Inside Flutter](/resources/inside-flutter) 글은 프레임워크의 디자인 철학에 대한 유용한 가이드를 제공합니다.

---

**Footnotes:**

<sup><a id="a1">1</a></sup> `build` 함수는 새로운 트리를 반환하지만, 통합할 새로운 구성이 있는 경우에만 _다른_ 것을 반환하면 됩니다. 구성이 실제로 동일한 경우, 동일한 위젯을 반환하면 됩니다.

<sup><a id="a2">2</a></sup> 이것은 읽기 편하도록 약간 단순화한 것입니다. 실제로는, 트리가 더 복잡할 수 있습니다.

<sup><a id="a3">3</a></sup> 이 접근 방식에는 몇 가지 제한이 있습니다. 예를 들어, 플랫폼 뷰의 투명도는 다른 Flutter 위젯과 같은 방식으로 합성되지 않습니다.

<sup><a id="a4">4</a></sup> 한 가지 예는 그림자(shadows)인데, 이는 일부 충실도를 희생하고 DOM과 동등한 기본 요소를 사용하여 근사화해야 합니다.
