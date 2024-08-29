---
# title: Handling user input
title: 사용자 입력 처리
# description: Learn how to handle user input in Flutter.
description: Flutter에서 사용자 입력을 처리하는 방법을 알아보세요.
prev:
  # title: State management
  title: 상태 관리
  path: /get-started/fwe/state-management
next:
  # title: Networking and data
  title: 네트워킹 및 데이터
  path: /get-started/fwe/networking
---

이제 Flutter 앱에서 상태를 관리하는 방법을 알았으니, 
사용자가 앱과 상호작용하고 앱의 상태를 변경하도록 하려면 어떻게 해야 할까요?

## 사용자 입력 소개 {:#introduction-to-user-input}

다중 플랫폼 UI 프레임워크로서, 사용자가 Flutter 앱과 상호 작용하는 방법은 다양합니다. 
이 섹션의 리소스에서는 사용자 상호 작용을 활성화하는 데 사용되는 일반적인 위젯을 소개합니다.

[스크롤][scrolling]과 같은 일부 사용자 입력 타입은 이미 [레이아웃][Layouts]에서 다루었습니다.

사용자 상호 작용에 따라 앱 상태를 변경하는 방법에 대한 소개는, 
"즐겨찾기" 버튼을 만드는 방법을 알려주는 다음 튜토리얼을 확인하세요.

<i class="material-symbols" aria-hidden="true">flutter_dash</i> 튜토리얼: [Flutter 앱에 상호 작용 기능 추가][Add interactivity to your Flutter app]

[Layouts]: /get-started/fwe/layout

## Material 3 데모 {:#material-3-demo}

다음으로, Material 3 구성 요소 라이브러리에서 사용 가능한, 
일부 사용자 입력 위젯을 샘플링하는 [Material 3 데모][Material 3 Demo]를 확인하세요.

:::note
이 페이지는 많은 개발자가 Flutter를 배울 때 시작하는 라이브러리인 Material 3 위젯에 초점을 맞춥니다. 
그러나, Flutter는 iOS 스타일 위젯에 대한 [Cupertino][]도 지원하거나, 
사용자가 직접 위젯 라이브러리를 빌드할 수 있습니다.
:::

[Cupertino]: {{site.api}}/flutter/cupertino/cupertino-library.html

## 사용자 입력 받기 {:#get-user-input}

이 섹션에서는 Flutter 앱에 가장 일반적인 사용자 입력 방법을 빌드하는 데 도움이 되는 위젯을 다룹니다.

### 클릭 또는 탭 (버튼) {:#click-or-tap-buttons}

사용자가 클릭하거나 탭하여 UI에서 작업을 수행하도록 합니다.

다음 Material 3 버튼 유형은 기능적으로 유사하지만, 스타일이 다릅니다.

[`ElevatedButton`][]
: 깊이가 있는 버튼입니다. 대부분 평평한 레이아웃에 차원을 더하기 위해 상승된(elevated) 버튼을 사용합니다.

[`FilledButton`][]
: (**Save**, **Join now** 또는 **Confirm**과 같이) 흐름을 완료하는 
  중요한 최종 작업에 사용해야 하는 채워진 버튼입니다.

[`OutlinedButton`][]
: 텍스트와 보이는 테두리가 있는 버튼. 이러한 버튼에는 중요한 작업이 포함되지만, 앱에서 주요 작업은 아닙니다.

[`TextButton`][]
: 테두리가 없는 클릭 가능한 텍스트. 
  텍스트 버튼에는 테두리가 보이지 않으므로, 컨텍스트를 위해 다른 콘텐츠에 대한 상대적 위치에 의존해야 합니다.

[`IconButton`][]: 아이콘이 있는 버튼.

[`FloatingActionButton`][]
: 주요 작업을 수행하기 위해 콘텐츠 위에 마우스를 올려놓는 원형 아이콘 버튼.

* 비디오: [FloatingActionButton(주간 위젯)][FloatingActionButton (Widget of the Week)]

[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`FilledButton`]: {{site.api}}/flutter/material/FilledButton-class.html
[`FloatingActionButton`]: {{site.api}}/flutter/material/FloatingActionButton-class.html
[FloatingActionButton (Widget of the Week)]: https://youtu.be/2uaoEDOgk_I?si=MQZcSp24oRaS_kiY
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html
[`OutlinedButton`]: {{site.api}}/flutter/material/OutlinedButton-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html

### 텍스트 {:#text}

여러 위젯이 텍스트 입력을 지원합니다.

[`TextField`][]
: 사용자가 하드웨어 키보드나 화면 키보드로 텍스트를 입력할 수 있도록 합니다.

다음 일련의 쿡북 문서에서는 텍스트 필드를 빌드하고, 값을 검색하고, 상태 변경을 처리하는 방법에 대한 모든 단계를 안내합니다.

1. 글: [텍스트 필드 만들기 및 스타일 지정][Create and style a text field]
2. 글: [텍스트 필드 값 검색][Retrieve the value of a text field]
3. 글: [텍스트 필드 변경 처리][Handle changes to a text field]
4. 글: [포커스 및 텍스트 필드][Focus and text fields]

[`RichText`][]
: 여러 스타일을 사용하는 텍스트를 표시합니다.

* 비디오: [Rich Text(Widget of the Week)][]
* 데모: [Rich Text Editor][]
* 샘플 코드: [Rich Text Editor code][]

[`SelectableText`][]
: 단일 스타일로 사용자가 선택할 수 있는 텍스트 문자열을 표시합니다.

* 비디오: [SelectableText(Widget of the Week)][]

[`Form`][]
: 여러 폼 필드 위젯을 그룹화하기 위한 선택적 컨테이너입니다.

* 글: [유효성 검사가 포함된 폼 빌드][Build a form with validation]
* 데모: [Form 앱][Form app]
* 샘플 코드: [Form 앱 코드][Form app code]

[Build a form with validation]: /cookbook/forms/validation
[Create and style a text field]: /cookbook/forms/text-input
[Focus and text fields]: /cookbook/forms/focus
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[Form app]: https://flutter.github.io/samples/web/form_app/
[Form app code]: https://github.com/flutter/samples/tree/main/form_app
[Handle changes to a text field]: /cookbook/forms/text-field-changes
[Retrieve the value of a text field]: /cookbook/forms/retrieve-input
[`RichText`]: {{site.api}}/flutter/widgets/RichText-class.html
[Rich Text (Widget of the Week)]: https://www.youtube.com/watch?v=rykDVh-QFfw
[Rich Text Editor]: https://flutter.github.io/samples/rich_text_editor.html
[Rich Text Editor code]: https://github.com/flutter/samples/tree/main/simplistic_editor
[`SelectableText`]: {{site.api}}/flutter/material/SelectableText-class.html
[SelectableText (Widget of the Week)]: https://www.youtube.com/watch?v=ZSU3ZXOs6hc
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html

### 옵션 그룹에서 값 선택 {:#select-a-value-from-a-group-of-options}

[`SegmentedButton`][]
: 사용자가 제한된 옵션 세트에서 선택할 수 있도록 합니다.

[`DropdownMenu`][]
: 사용자가 메뉴에서 선택 아이템을 선택하고, 선택한 아이템을 텍스트 입력 필드에 배치할 수 있도록 합니다.

* 비디오: [DropdownMenu(주간 위젯)][DropdownMenu (Widget of the Week)]

[`Slider`][]
: 다양한 값에서 선택합니다.

* 비디오: [Slider, RangeSlider, CupertinoSlider(주간 위젯)][Slider, RangeSlider, CupertinoSlider (Widget of the Week)]

[`DropdownMenu`]: {{site.api}}/flutter/material/DropdownMenu-class.html
[DropdownMenu (Widget of the Week)]: https://youtu.be/giV9AbM2gd8?si=E23hjg72cjMTe_mz
[`SegmentedButton`]: {{site.api}}/flutter/material/SegmentedButton-class.html
[`Slider`]: {{site.api}}/flutter/material/Slider-class.html
[Slider, RangeSlider, CupertinoSlider (Widget of the Week)]: https://www.youtube.com/watch?v=ufb4gIPDmEss

### 값 토글 {:#toggle-values}

[`Checkbox`][]
: 리스트에서 하나 이상의 아이템을 선택하거나 아이템을 토글합니다.

[`CheckboxListTile`][]
: 레이블이 있는 체크박스.

* 비디오: [CheckboxListTile(주간 위젯)][CheckboxListTile (Widget of the Week)]

[`Switch`][]
: 단일 설정의 켜기/끄기 상태를 토글합니다.

[`SwitchListTile`][]
: 레이블이 있는 스위치.

* 비디오 [SwitchListTile(주간 위젯)][SwitchListTile (Widget of the Week)]

[`Radio`][]
: 상호 배타적인 여러 값 중에서 선택합니다. 
  그룹에서 하나의 라디오 버튼을 선택하면, 그룹의 다른 라디오 버튼은 선택되지 않습니다.

[`Chip`][]
: 칩은 속성, 텍스트, 엔터티 또는 작업을 나타내는 컴팩트한 요소입니다.

### 날짜 또는 시간 선택 {:#select-a-date-or-time}

[`showDatePicker`][]
: [Material Design 날짜 선택기][Material Design date picker]를 포함하는 대화 상자를 표시합니다.

[`showTimePicker`][]
: [Material Design 시간 선택기][Material Design time picker]를 포함하는 대화 상자를 표시합니다.

### 스와이프 및 슬라이드 {:#swipe-and-slide}

[`Dismissible`][]
: 왼쪽이나 오른쪽으로 스와이프하여 리스트 아이템을 지웁니다.

* 비디오: [Dismissible 가능(주간 위젯)][Dismissible (Widget of the Week)]
* 글: [스와이프하여 해제(dismiss) 구현][Implement swipe to dismiss]

[pkg:`flutter_slidable`][]
: 해제할 수 있는 방향 슬라이드 동작이 있는 리스트 아이템.

* 비디오: [flutter_slidable(주간 패키지)][flutter_slidable (Package of the Week)]

## GestureDetector로 상호 작용성 추가 {:#add-interactivity-with-gesturedetector}

Flutter 위젯 중 원하는 기능에 맞는 것이 없다면, 
`GestureDetector`를 사용하여 위젯에 상호 작용을 추가할 수 있습니다.

* 비디오: [GestureDetector(주간 위젯)][GestureDetector (Widget of the Week)]
* 문서: [탭, 드래그 및 기타 제스처][Taps, drags, and other gestures]
* 글: [탭 처리][Handle taps]

접근성(accessibility)을 잊지 마세요! 
커스텀 위젯을 빌드하는 경우, `Semantics` 위젯으로 의미에 주석을 달 수 있습니다. 
이를 통해, 화면 판독기 및 기타 의미 분석 기반 도구에 설명, 메타데이터 등을 제공할 수 있습니다.

* 비디오: [Semantics(주간 Flutter 위젯)][Semantics (Flutter Widget of the Week)]

보너스: Flutter의 `GestureArena`가 raw 사용자 상호 작용 데이터를, 
탭, 드래그 및 핀치와 같은 사람이 인식할 수 있는 개념으로 변환하는 방법에 대한, 
자세한 내용은 다음 비디오를 확인하세요.

* 비디오: [GestureArena(Flutter 디코딩)][GestureArena (Decoding Flutter)]

## 테스트 {:#testing}

앱에 사용자 상호작용을 구축하는 것을 마쳤다면, 
모든 것이 예상대로 작동하는지 확인하기 위해 테스트를 작성하는 것을 잊지 마세요!

* 글: [탭, 드래그, 텍스트 입력][Tap, drag, and enter text]
* 글: [스크롤 처리][Handle scrolling]

[GestureArena (Decoding Flutter)]: https://www.youtube.com/watch?v=Q85LBtBdi0U
[GestureDetector (Widget of the Week)]: https://www.youtube.com/watch?v=WhVXkCFPmK4
[Handle taps]: /cookbook/gestures/handling-taps
[Semantics (Flutter Widget of the Week)]: https://youtu.be/NvtMt_DtFrQ?si=o79BqAg9NAl8EE8_
[Tap, drag, and enter text]: /cookbook/testing/widget/tap-drag
[Taps, drags, and other gestures]: /ui/interactivity/gestures#gestures


## 다음: 네트워킹 {:#next-networking}

이 페이지는 사용자 입력을 처리하는 방법에 대한 소개였습니다. 
이제 앱 사용자로부터 입력을 수락하는 방법을 알았으므로, 
외부 데이터를 추가하여 앱을 더욱 흥미롭게 만들 수 있습니다. 
다음 섹션에서는 네트워크를 통해 앱의 데이터를 가져오는 방법, 
JSON으로 데이터를 변환하는 방법, 인증 및 기타 네트워킹 기능을 알아봅니다.

[scrolling]: /get-started/fwe/layout#scrolling-widgets

[Add interactivity to your Flutter app]: /ui/interactivity
[Material 3 Demo]: https://flutter.github.io/samples/web/material_3_demo/



[`Checkbox`]: {{site.api}}/flutter/material/Checkbox-class.html
[`CheckboxListTile`]: {{site.api}}/flutter/material/CheckboxListTile-class.html
[CheckboxListTile (Widget of the Week)]: https://www.youtube.com/watch?v=RkSqPAn9szs
[`Switch`]: {{site.api}}/flutter/material/Switch-class.html
[`SwitchListTile`]: {{site.api}}/flutter/material/SwitchListTile-class.html
[SwitchListTile (Widget of the Week)]: https://www.youtube.com/watch?v=0igIjvtEWNU
[`Radio`]: {{site.api}}/flutter/material/Radio-class.html
[`Chip`]: {{site.api}}/flutter/material/Chip-class.html

[Material Design date picker]: https://m3.material.io/components/date-pickers/overview
[Material Design time picker]: https://m3.material.io/components/time-pickers/overview
[`showDatePicker`]: {{site.api}}/flutter/material/showDatePicker.html
[`showTimePicker`]: {{site.api}}/flutter/material/showTimePicker.html

[`Dismissible`]: {{site.api}}/flutter/widgets/Dismissible-class.html
[Dismissible (Widget of the Week)]: https://youtu.be/iEMgjrfuc58?si=f0S7IdaA9PIWIYvl
[Implement swipe to dismiss]: /cookbook/gestures/dismissible
[pkg:`flutter_slidable`]: https://pub.dev/packages/flutter_slidable
[flutter_slidable (Package of the Week)]: https://www.youtube.com/watch?v=QFcFEpFmNJ8

[Handle scrolling]: /cookbook/testing/widget/scrolling

## 피드백 {:#feedback}

이 웹사이트의 이 섹션이 발전하기 때문에, 우리는 [당신의 피드백을 환영합니다][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="user-input"
