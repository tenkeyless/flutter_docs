---
title: SafeArea & MediaQuery
# description: >-
#   Learn how to use SafeArea and MediaQuery
#   to create an adaptive app.
description: >-
  SafeArea와 MediaQuery를 사용하여 적응형 앱을 만드는 방법을 알아보세요.
---

이 페이지에서는 `SafeArea`와 `MediaQuery` 위젯을 사용하는 방법과 시기를 설명합니다.

## SafeArea

최신 기기에서 앱을 실행할 때, 기기 화면의 컷아웃으로 인해 UI 일부가 차단되는 경우가 있습니다. 
[`SafeArea`][] 위젯을 사용하여 이를 수정할 수 있습니다. 
이 위젯은 (노치 및 카메라 컷아웃과 같은) 침입을 피하기 위해 자식 위젯을 삽입(insets)하고, 
(Android의 상태 표시줄과 같은) 운영 체제 UI나, 물리적 디스플레이의 둥근 모서리를 삽입합니다.

이러한 동작을 원하지 않는 경우, `SafeArea` 위젯을 사용하여 네 면의 패딩을 비활성화할 수 있습니다. 
기본적으로, 네 면 모두 활성화됩니다.

일반적으로 `Scaffold` 위젯의 본문을 `SafeArea`로 래핑하는 것이 시작하기에 좋은 위치이지만, 
항상 `Widget` 트리에서 이렇게 높은 위치에 둘 필요는 없습니다.

예를 들어, 의도적으로 앱이 컷아웃 아래로 늘어나게 하려면, 
의미 있는 콘텐츠를 래핑하도록 `SafeArea`를 이동하여, 
나머지 앱이 전체 화면을 차지하도록 할 수 있습니다.

`SafeArea`를 사용하면 앱 콘텐츠가 물리적 디스플레이 기능이나 운영 체제 UI에 의해 잘리지 않고, 
다양한 모양과 스타일의 컷아웃이 있는 새로운 기기가 시장에 출시되더라도 앱이 성공할 수 있도록 준비할 수 있습니다.

`SafeArea`는 어떻게 적은 양의 코드로 이렇게 많은 작업을 수행할 수 있을까요? 
내부적으로는 `MediaQuery` 객체를 사용합니다.

[`SafeArea`]: {{site.api}}/flutter/widgets/SafeArea-class.html

## MediaQuery

[SafeArea](#safearea) 섹션에서 설명한 대로, `MediaQuery`는 적응형 앱을 만드는 데 강력한 위젯입니다. 
때로는 `MediaQuery`를 직접 사용하고, 때로는 `MediaQuery`를 무대 뒤에서 사용하는 `SafeArea`를 사용합니다.

`MediaQuery`는 앱의 현재 창 크기를 포함하여 많은 정보를 제공합니다. 
(고대비 모드 및 텍스트 크기 조정과 같은) 접근성 설정이나, 
(사용자가 TalkBack 또는 VoiceOver와 같은) 접근성 서비스를 사용하는지 여부를 노출합니다. 
`MediaQuery`에는 (힌지 또는 폴드가 있는지와 같은) 장치 디스플레이의 기능에 대한 정보도 포함됩니다.

`SafeArea`는 `MediaQuery`의 데이터를 사용하여 자식 `Widget`을 얼마나 삽입(inset)할지 파악합니다. 
구체적으로, `MediaQuery` 패딩 속성을 사용하는데, 
이는 기본적으로 시스템 UI, 디스플레이 노치 또는 상태 표시줄에 의해 부분적으로 가려지는 디스플레이의 양입니다.

그렇다면, 왜 `MediaQuery`를 직접 사용하지 않을까요?

답은 `SafeArea`가 raw `MediaQueryData` 대신 사용하기에 유익한 영리한 일을 한다는 것입니다. 
구체적으로, `SafeArea`의 자식에 노출된 `MediaQuery`를 수정하여, 
`SafeArea`에 추가된 패딩이 존재하지 않는 것처럼 보이게 합니다. 
즉, `SafeArea`를 중첩할 수 있으며, 가장 위에 있는 것만 시스템 UI로 노치를 피하는 데 필요한 패딩을 적용합니다.

앱이 커지고 위젯을 이동하면, 
여러 개의 `SafeArea`가 있는 경우에도 패딩이 너무 많이 적용되는 것에 대해 걱정할 필요가 없지만, 
`MediaQueryData.padding`을 직접 사용하는 경우 문제가 발생합니다.

`Scaffold` 위젯의 본문을 `SafeArea`로 _래핑할 수 있지만_, 위젯 트리에서 이렇게 _높은 위치에 둘 필요는 없습니다_. `SafeArea`는 앞서 언급한 하드웨어 기능에 의해 잘려나가면 정보 손실이 발생할 수 있는 콘텐츠만 래핑하면 됩니다.

예를 들어, 의도적으로 앱이 컷아웃 아래로 늘어나게 하려면, 
`SafeArea`를 이동하여 의미 있는 콘텐츠를 래핑하고, 나머지 앱은 전체 화면을 차지하게 할 수 있습니다. 
참고로 `AppBar` 위젯은 기본적으로 이렇게 시스템 상태 표시줄 아래에 배치됩니다. 
이것이 `Scaffold` 자체 전체를 래핑하는 대신, `SafeArea`로 `Scaffold` body를 래핑하는 것이 권장되는 이유이기도 합니다.

`SafeArea`는 앱 콘텐츠가 일반적인 방식으로 잘리지 않도록 보장하고, 
다양한 모양과 스타일의 컷아웃이 있는 새로운 기기가 시장에 출시되더라도 앱이 성공할 수 있도록 준비합니다.