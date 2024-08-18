---
# title: Adaptive and responsive design in Flutter
title: Flutter의 적응형 및 반응형 디자인
# description: >-
#   It's important to create an app,
#   whether for mobile or web,
#   that responds to size and orientation changes
#   and maximizes the use of each platform.
description: >-
  모바일이든 웹이든, 크기와 방향(orientation)의 변화에 ​​대응하고, 각 플랫폼의 활용을 극대화하는 앱을 만드는 것이 중요합니다.
# short-title: Adaptive design
short-title: 적응형 디자인
---

![List of supported platforms](/assets/images/docs/ui/adaptive-responsive/platforms.png)

Flutter의 주요 목표 중 하나는 어떤 플랫폼에서든 멋지게 보이고 느껴지는, 
단일 코드베이스에서 앱을 개발할 수 있는 프레임워크를 만드는 것입니다.

즉, 앱은 (스마트 워치에서 시작해, 두 개의 화면이 있는 폴더블 폰, 고화질 모니터에 이르기까지) 
다양한 크기의 화면에 표시될 수 있다는 것을 의미합니다.
그리고 입력 장치는 물리적 또는 가상 키보드, 마우스, 터치스크린 또는 기타 여러 장치가 될 수 있습니다.

이러한 디자인 개념을 설명하는 두 가지 용어는 _적응형(adaptive)_ 과 _반응형(responsive)_ 입니다. 
이상적으로는 앱이 _둘 다_ 되기를 원하지만, 정확히 이것이 무엇을 의미할까요?

## 반응형과 적응형의 차이점은 무엇인가요? {:#what-is-responsive-vs-adaptive}

쉽게 생각해 보면, 

* 반응형 디자인은 UI를 공간에 _맞추는(fit into)_ 것이고, 
* 적응형 디자인은 UI를 공간에서 _사용할 수 있도록(usable)_ 하는 것입니다.

따라서, 반응형 앱은 사용 가능한 공간에 _맞추기(fit)_ 위해 디자인 요소의 배치를 조정합니다. 
그리고, 적응형 앱은 사용 가능한 공간에서 _사용할 수 있는_ 적절한 레이아웃과 입력 장치를 선택합니다. 
예를 들어, 태블릿 UI는 하단 네비게이션을 사용해야 할까요, 아니면 측면 패널 네비게이션을 사용해야 할까요?

:::note
적응형과 반응형 개념은 종종 단일 용어로 축소됩니다. 
대부분 _적응형 디자인(adaptive design)_ 은 적응형과 반응형을 모두 지칭하는 데 사용됩니다.
:::

이 섹션에서는 적응형 및 반응형 디자인의 다양한 측면을 다룹니다.

* [일반적인 접근 방식][General approach]
* [SafeArea 및 MediaQuery][SafeArea & MediaQuery]
* [대형 화면 및 폴더블][Large screens & foldables]
* [사용자 입력 및 접근성][User input & accessibility]
* [기능 및 정책][Capabilities & policies]
* [적응형 앱에 대한 모범 사례][Best practices for adaptive apps]
* [추가 리소스][Additional resources]

[Additional resources]: /ui/adaptive-responsive/more-info
[Best practices for adaptive apps]: /ui/adaptive-responsive/best-practices
[Capabilities & policies]: /ui/adaptive-responsive/capabilities
[General approach]: /ui/adaptive-responsive/general
[Large screens & foldables]: /ui/adaptive-responsive/large-screens
[SafeArea & MediaQuery]: /ui/adaptive-responsive/safearea-mediaquery
[User input & accessibility]: /ui/adaptive-responsive/input

:::note
또한 이 주제에 대한 Google I/O 2024 토크도 확인해 보세요.

{% ytEmbed 'LeKLGzpsz9I', 'Flutter로 적응형 UI를 구축하는 방법' %}
:::
