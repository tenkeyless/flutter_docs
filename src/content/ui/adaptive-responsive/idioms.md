---
# title: Platform idioms
title: 플랫폼 관용어
# description: >-
#   Learn how to create a responsive app
#   that responds to changes in the screen size. 
description: >-
  화면 크기의 변화에 ​​따라 반응하는 반응형 앱을 만드는 방법을 알아보세요.
# short-title: Idioms
short-title: 관용어
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

{% comment %}
<b>PENDING: Leave this page out for now... In V2, I'd like to include it. Mariam suggested splitting it up by platform and I like that idea</b>
{% endcomment %}

적응형 앱을 고려할 마지막 영역은 플랫폼 표준입니다. 
각 플랫폼에는 고유한 관용어와 규범이 있습니다. 
이러한 명목상 또는 사실상의 표준은 애플리케이션이 어떻게 작동해야 하는지에 대한 사용자 기대치를 알려줍니다. 
웹 덕분에 사용자는 보다 맞춤화된 경험에 익숙해졌지만, 
이러한 플랫폼 표준을 반영하면 여전히 상당한 이점을 얻을 수 있습니다.

* **인지적 부하 감소 (Reduce cognitive load)**
: 사용자의 기존 정신 모델과 일치함으로써, 작업 수행이 직관적이 되어, 
  사고가 덜 필요하고 생산성이 향상되며 불만이 줄어듭니다.

* **신뢰 구축 (Build trust)**
: 애플리케이션이 기대에 부응하지 않으면 사용자는 경계하거나 의심하게 될 수 있습니다. 
  반대로 친숙하게 느껴지는 UI는 사용자 신뢰를 구축하고 품질에 대한 인식을 개선하는 데 도움이 될 수 있습니다. 
  이는 종종 더 나은 앱 스토어 평가라는 추가 이점을 제공합니다. 
  이는 우리 모두가 감사하게 여기는 것입니다!

## 각 플랫폼에서 예상되는 동작을 고려하세요 {:#consider-expected-behavior-on-each-platform}

첫 번째 단계는 이 플랫폼에서 예상되는 모양, 프레젠테이션 또는 동작이 무엇인지 고려하는 데 시간을 할애하는 것입니다. 
현재 구현의 제한 사항을 잊고, 이상적인 사용자 경험만 상상해 보세요. 거기에서 역으로 작업하세요.

이에 대해 생각하는 또 다른 방법은 "이 플랫폼의 사용자는 이 목표를 어떻게 달성할 것으로 예상할까요?"라고 묻는 것입니다. 
그런 다음 타협 없이 앱에서 어떻게 작동할지 상상해 보세요.

플랫폼을 정기적으로 사용하지 않는 경우 어려울 수 있습니다. 
특정 관용어를 알지 못할 수 있으며 쉽게 완전히 놓칠 수 있습니다. 
예를 들어, 평생 Android를 사용하는 사람은 iOS의 플랫폼 규칙을 알지 못할 가능성이 높으며, 
macOS, Linux 및 Windows도 마찬가지입니다. 
이러한 차이점은 사용자에게는 미묘할 수 있지만, 숙련된 사용자에게는 고통스럽게 분명할 수 있습니다.

### 플랫폼 옹호자 찾기 {:#find-a-platform-advocate}

가능하다면 각 플랫폼에 대한 옹호자를 한 명씩 지정하세요. 
이상적으로는, 옹호자가 플랫폼을 기본 장치로 사용하고, 매우 의견이 강한 사용자의 관점을 제공할 수 있습니다. 
사람의 수를 줄이려면 역할을 결합하세요. 
Windows와 Android에 대한 옹호자 한 명, Linux와 웹에 대한 옹호자 한 명, Mac과 iOS에 대한 옹호자 한 명을 두세요.

목표는 각 플랫폼에서 앱이 훌륭하게 느껴지도록 지속적이고 정보에 입각한 피드백을 받는 것입니다. 
옹호자는 매우 까다로워야 하며, 기기에서 일반적인 애플리케이션과 다르다고 생각되는 모든 것을 지적해야 합니다. 
간단한 예로 대화 상자의 기본 버튼이 일반적으로 Mac과 Linux에서는 왼쪽에 있지만, 
Windows에서는 오른쪽에 있는 것이 있습니다. 
이러한 세부 사항은 플랫폼을 정기적으로 사용하지 않는 경우, 놓치기 쉽습니다.

:::secondary 중요
옹호자는 개발자나 정규 팀원일 필요는 없습니다. 
그들은 정기적인 빌드를 제공받는 디자이너, 이해 관계자 또는 외부 테스터가 될 수 있습니다.
:::

### 독특함을 유지하세요 {:#stay-unique}

예상되는 동작을 따른다고 해서, 앱에서 기본 구성 요소나 스타일을 사용해야 하는 것은 아닙니다. 
가장 인기 있는 멀티플랫폼 앱 중 다수는 사용자 지정 버튼, 컨텍스트 메뉴, 제목 표시줄을 포함하여, 
매우 독특하고 의견이 뚜렷한 UI를 가지고 있습니다.

플랫폼 간에 스타일과 동작을 통합할수록 개발과 테스트가 더 쉬워집니다. 
요령은 각 플랫폼의 규범을 존중하는 동시에, 강력한 정체성을 갖춘 고유한 경험을 만드는 균형을 맞추는 것입니다.

## 고려해야 할 일반적인 관용어와 규범 {:#common-idioms-and-norms-to-consider}

Flutter에서 고려할 만한 몇 가지 구체적인 규범과 관용어를 살펴보고, 이에 어떻게 접근할 수 있는지 알아보겠습니다.

### 스크롤바 모양 및 동작 {:#scrollbar-appearance-and-behavior}

데스크톱 및 모바일 사용자는 스크롤바를 기대하지만, 다른 플랫폼에서는 다르게 동작할 것으로 기대합니다. 
모바일 사용자는 스크롤하는 동안만 나타나는 더 작은 스크롤바를 기대하는 반면, 
데스크톱 사용자는 일반적으로 클릭하거나 드래그할 수 있는 어디에나 있는 더 큰 스크롤바를 기대합니다.

Flutter에는 현재 플랫폼에 따라 적응형 색상과 크기를 지원하는 기본 제공 `Scrollbar` 위젯이 함께 제공됩니다. 
하고 싶을 수 있는 한 가지 조정은, 데스크톱 플랫폼에 있을 때 `alwaysShown`을 토글하는 것입니다.

<?code-excerpt "lib/pages/adaptive_grid_page.dart (scrollbar-always-shown)"?>
```dart
return Scrollbar(
  thumbVisibility: DeviceType.isDesktop,
  controller: _scrollController,
  child: GridView.count(
    controller: _scrollController,
    padding: const EdgeInsets.all(Insets.extraLarge),
    childAspectRatio: 1,
    crossAxisCount: colCount,
    children: listChildren,
  ),
);
```

이런 섬세한 세부 사항에 대한 관심은 특정 플랫폼에서 앱이 더욱 편안하게 느껴지도록 만들 수 있습니다.

### 다중 선택 {:#multi-select}

목록 내에서 다중 선택을 처리하는 것은 플랫폼 간에 미묘한 차이가 있는 또 다른 영역입니다.

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (multi-select-shift)"?>
```dart
static bool get isSpanSelectModifierDown =>
    isKeyDown({LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftRight});
```

제어나 명령에 대한 플랫폼 인식 검사를 수행하려면, 다음과 같이 작성할 수 있습니다.

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (multi-select-modifier-down)"?>
```dart
static bool get isMultiSelectModifierDown {
  bool isDown = false;
  if (Platform.isMacOS) {
    isDown = isKeyDown(
      {LogicalKeyboardKey.metaLeft, LogicalKeyboardKey.metaRight},
    );
  } else {
    isDown = isKeyDown(
      {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.controlRight},
    );
  }
  return isDown;
}
```

키보드 사용자를 위한 마지막 고려 사항은 **Select All** 작업입니다. 
선택 가능한 항목의 리스트가 큰 경우, 
많은 키보드 사용자는 `Control+A`를 사용하여 모든 항목을 선택할 수 있다고 기대할 것입니다.

#### 터치 장치 {:#touch-devices}

터치 기기에서 다중 선택은 일반적으로 간소화되며, 
예상되는 동작은 데스크톱에서 `isMultiSelectModifier`를 누른 것과 유사합니다. 
한 번의 탭으로 항목을 선택하거나 선택 해제할 수 있으며, 
일반적으로 **Select All** 또는 현재 선택 항목 **Clear** 버튼이 있습니다.

다양한 기기에서 다중 선택을 처리하는 방법은 특정 사용 사례에 따라 다르지만, 
중요한 것은 각 플랫폼에 가능한 최상의 상호 작용 모델을 제공하는 것입니다.

### 선택 가능한 텍스트 {:#selectable-text}

웹(그리고 덜한 정도로 데스크톱)에서 일반적으로 기대되는 것은, 
대부분의 보이는 텍스트가 마우스 커서로 선택될 수 있다는 것입니다. 
텍스트를 선택할 수 없는 경우 웹 사용자는 부정적인 반응을 보이는 경향이 있습니다.

다행히도 [`SelectableText`][] 위젯을 사용하면 쉽게 지원할 수 있습니다.

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (selectable-text)"?>
```dart
return const SelectableText('Select me!');
```

서식 있는 텍스트(rich text)를 지원하려면, `TextSpan`을 사용하세요.

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (rich-text-span)"?>
```dart
return const SelectableText.rich(
  TextSpan(
    children: [
      TextSpan(text: 'Hello'),
      TextSpan(text: 'Bold', style: TextStyle(fontWeight: FontWeight.bold)),
    ],
  ),
);
```

[`SelectableText`]: {{site.api}}/flutter/material/SelectableText-class.html

### 타이틀 바 {:#title-bars}

최신 데스크톱 애플리케이션에서는, 
앱 창의 제목 표시줄을 커스터마이즈하여 더 강력한 브랜딩을 위해 로고를 추가하거나, 
기본 UI에서 수직 공간을 절약하기 위해 상황에 맞는 컨트롤을 추가하는 것이 일반적입니다.

![Samples of title bars](/assets/images/docs/ui/adaptive-responsive/titlebar.png){:width="100%"}

Flutter에서는 직접 지원되지 않지만, 
[`bits_dojo`][] 패키지를 사용하여 기본 타이틀 바를 비활성화하고, 
사용자 고유의 타이틀 바를 대체할 수 있습니다.

이 패키지는 후드 아래에 순수 Flutter 위젯을 사용하기 때문에, 
`TitleBar`에 원하는 위젯을 추가할 수 있습니다. 
이렇게 하면 앱의 다른 섹션으로 이동할 때, 타이틀 바를 쉽게 조정할 수 있습니다.

[`bits_dojo`]: {{site.github}}/bitsdojo/bitsdojo_window

### 컨텍스트 메뉴 및 툴팁 {:#context-menus-and-tooltips}

데스크톱에서는 오버레이에 표시된 위젯으로 나타나는 여러 가지 상호 작용이 있지만, 
트리거, 해제 및 배치 방식에 차이가 있습니다.

* **컨텍스트 메뉴 (Context menu)**
: 일반적으로 마우스 오른쪽 버튼을 클릭하여 트리거되는, 컨텍스트 메뉴는, 마우스 근처에 배치되며, 
  아무 곳이나 클릭하거나, 메뉴에서 옵션을 선택하거나 메뉴 밖을 클릭하면 해제됩니다.

* **도구 설명 (Tooltip)**
: 일반적으로 대화형 요소 위로 200~400ms 동안 마우스를 올려놓으면 트리거되는, 도구 설명은, 
  일반적으로 위젯에 고정되고(마우스 위치가 아님), 마우스 커서가 해당 위젯을 떠나면 해제됩니다.

* **팝업 패널 (Popup panel, flyout이라고도 함)**
: 도구 설명과 유사하게 팝업 패널은 일반적으로 위젯에 고정됩니다. 
  주요 차이점은 패널이 대부분 탭 이벤트에 표시되고 커서가 떠나도 일반적으로 숨겨지지 않는다는 것입니다. 
  대신 패널은 일반적으로 패널 밖을 클릭하거나 **Close** 또는 **Submit** 버튼을 눌러 해제됩니다.

Flutter에서 기본 도구 설명을 표시하려면, 기본 제공 [`Tooltip`][] 위젯을 사용하세요.

<?code-excerpt "lib/widgets/extra_widget_excerpts.dart (tooltip)"?>
```dart
return const Tooltip(
  message: 'I am a Tooltip',
  child: Text('Hover over the text to show a tooltip.'),
);
```

Flutter는 또한 텍스트를 편집하거나 선택할 때 기본 제공 컨텍스트 메뉴를 제공합니다.

고급 도구 설명, 팝업 패널을 표시하거나 커스텀 컨텍스트 메뉴를 만들려면, 
사용 가능한 패키지 중 하나를 사용하거나 `Stack` 또는 `Overlay`를 사용하여 직접 빌드합니다.

사용 가능한 패키지에는 다음이 포함됩니다.

* [`context_menus`][]
* [`anchored_popups`][]
* [`flutter_portal`][]
* [`super_tooltip`][]
* [`custom_pop_up_menu`][]

이러한 컨트롤은 가속기로서 터치 사용자에게 유용할 수 있지만, 마우스 사용자에게는 필수적입니다. 
이러한 사용자는 마우스 오른쪽 버튼을 클릭하고, 제자리에서 콘텐츠를 편집하고, 
더 많은 정보를 위해 마우스를 올려놓기를 기대합니다. 
이러한 기대에 부응하지 못하면 실망한 사용자, 
또는 적어도 무언가가 잘못되었다는 느낌으로 이어질 수 있습니다.

[`anchored_popups`]: {{site.pub}}/packages/anchored_popups
[`context_menus`]: {{site.pub}}/packages/context_menus
[`custom_pop_up_menu`]: {{site.pub}}/packages/custom_pop_up_menu
[`flutter_portal`]: {{site.pub}}/packages/flutter_portal
[`super_tooltip`]: {{site.pub}}/packages/super_tooltip
[`Tooltip`]: {{site.api}}/flutter/material/Tooltip-class.html

### 수평 버튼 순서 {:#horizontal-button-order}

Windows에서 버튼 행을 표시할 때, 확인 버튼은 행의 시작 부분(왼쪽)에 배치됩니다. 
다른 모든 플랫폼에서는 그 반대입니다. 확인 버튼은 행의 끝(오른쪽)에 배치됩니다.

Flutter에서 `Row`의 `TextDirection` 속성을 사용하여 이를 쉽게 처리할 수 있습니다.

<?code-excerpt "lib/widgets/ok_cancel_dialog.dart (row-text-direction)"?>
```dart
TextDirection btnDirection =
    DeviceType.isWindows ? TextDirection.rtl : TextDirection.ltr;
return Row(
  children: [
    const Spacer(),
    Row(
      textDirection: btnDirection,
      children: [
        DialogButton(
          label: 'Cancel',
          onPressed: () => Navigator.pop(context, false),
        ),
        DialogButton(
          label: 'Ok',
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  ],
);
```

![Sample of embedded image](/assets/images/docs/ui/adaptive-responsive/embed_image1.png){:width="75%"}

![Sample of embedded image](/assets/images/docs/ui/adaptive-responsive/embed_image2.png){:width="90%"}

### 메뉴 바 {:#menu-bar}

데스크톱 앱에서 흔히 볼 수 있는 또 다른 패턴은 메뉴 모음입니다. 
Windows와 Linux에서는 이 메뉴가 Chrome 제목 모음의 일부로 표시되는 반면, 
macOS에서는 기본 화면 상단에 있습니다.

현재 프로토타입 플러그인을 사용하여, 커스텀 메뉴 모음 항목을 지정할 수 있지만, 
이 기능이 결국 기본 SDK에 통합될 것으로 예상됩니다.

Windows와 Linux에서는 커스텀 제목 바와 메뉴 모음을 결합할 수 없다는 점을 언급할 가치가 있습니다. 
커스텀 제목 바를 만들면, 기본 제목 바를 완전히 대체하게 되므로, 통합된 기본 메뉴 모음도 잃게 됩니다.

커스텀 제목 바과 메뉴 모음이 모두 필요한 경우, 
커스텀 컨텍스트 메뉴와 비슷하게 Flutter에서 구현하여 이를 달성할 수 있습니다.

### 드래그 앤 드롭 {:#drag-and-drop}

터치 기반 및 포인터 기반 입력의 핵심 상호 작용 중 하나는 드래그 앤 드롭입니다. 
이 상호 작용은 두 타입의 입력에 모두 예상되지만, 
드래그 가능한 항목의 리스트를 스크롤할 때 고려해야 할 중요한 차이점이 있습니다.

일반적으로 터치 사용자는 드래그 가능한 영역과 스크롤 가능한 영역을 구분하기 위해, 
드래그 핸들을 보거나 길게 누르기 제스처를 사용하여 드래그를 시작하기를 기대합니다. 
스크롤과 드래그는 모두 입력을 위해 단일 손가락을 공유하기 때문입니다.

마우스 사용자는 더 많은 입력 옵션을 갖습니다. 
휠이나 스크롤바를 사용하여 스크롤할 수 있으므로, 
일반적으로 전용 드래그 핸들이 필요하지 않습니다. 
macOS Finder 또는 Windows Explorer를 살펴보면, 
이런 방식으로 작동한다는 것을 알 수 있습니다. 
항목을 선택하고 드래그를 시작하면 됩니다.

Flutter에서는, 여러 가지 방법으로 드래그 앤 드롭을 구현할 수 있습니다. 
구체적인 구현에 대해 논의하는 것은 이 문서의 범위를 벗어나지만, 몇 가지 고급 옵션은 다음과 같습니다.

* 커스텀 모양과 느낌을 위해 [`Draggable`][] 및 [`DragTarget`][] API를 직접 사용합니다.

* `onPan` 제스처 이벤트에 연결하고 부모 `Stack` 내에서 직접 객체를 이동합니다.

* pub.dev에서 [사전 제작된 리스트 패키지][pre-made list packages] 중 하나를 사용합니다.

[`Draggable`]: {{site.api}}/flutter/widgets/Draggable-class.html
[`DragTarget`]: {{site.api}}/flutter/widgets/DragTarget-class.html
[pre-made list packages]: {{site.pub}}/packages?q=reorderable+list
