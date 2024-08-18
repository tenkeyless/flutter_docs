---
# title: Flutter's fonts and typography
title: Flutter의 글꼴과 타이포그래피
# description: Learn about Flutter's support for typography.
description: Flutter의 타이포그래피 지원에 대해 알아보세요.
---

[_타이포그래피_][_Typography_]는 글꼴의 스타일과 모양을 다룹니다. 
글꼴의 굵기(how heavy), 글꼴의 기울기(slant), 글자 사이의 간격(spacing) 및 텍스트의 다른 시각적 측면을 지정합니다.

모든 글꼴이 동일하게 만들어지는 것은 _아닙니다_. 
글꼴은 방대한 주제이며 이 사이트의 범위를 벗어나지만, 
이 페이지에서는 가변(variable) 및 정적(static) 글꼴에 대한 Flutter의 지원에 대해 설명합니다.

[_Typography_]: https://en.wikipedia.org/wiki/Typography

## 가변(Variable) 폰트 {:#variable-fonts}

[가변 글꼴][Variable fonts](OpenType 글꼴이라고도 함)을 사용하면, 
텍스트 스타일의 사전 정의된 측면을 제어할 수 있습니다. 
가변 글꼴은 너비, 두께, 기울기(slant) (몇 가지를 예로 들면)와 같은 특정 축을 지원합니다. 
사용자는 타입을 지정할 때, _연속 축을 따라 임의의 값_ 을 선택할 수 있습니다.

<img src='/assets/images/docs/development/ui/typography/variable-font-axes.png'
class="mw-100" alt="Example of two variable font axes">

그러나, 글꼴은 먼저 어떤 축을 사용할 수 있는지 정의해야 하며, 이는 항상 쉽게 알아낼 수 있는 것은 아닙니다. 
Google Font를 사용하는 경우, 다음 섹션에 설명된, 
**타입 테스터(type tester)** 기능을 사용하여 어떤 축을 사용할 수 있는지 _알아볼 수_ 있습니다.

[Variable fonts]: https://fonts.google.com/knowledge/introducing_type/introducing_variable_fonts

### Google Fonts 타입 테스터 사용 {:#using-the-google-fonts-type-tester}

Google Fonts 사이트는 가변 글꼴과 정적 글꼴을 모두 제공합니다. 
타입 테스터를 사용하여 가변 글꼴에 대해 자세히 알아보세요.

1. 가변 Google 글꼴을 조사하려면, [Google Fonts][] 웹사이트로 이동합니다. 
   각 글꼴 카드의 오른쪽 상단 모서리에, 
   가변 글꼴의 경우 **variable**이라고 표시되거나, 
   정적 글꼴이 지원하는 스타일 수를 나타내는 **x styles**라고 표시됩니다.
2. 모든 가변 글꼴을 보려면, **Show only variable fonts** 확인란을 선택합니다.
3. 아래로 스크롤하거나(또는 검색 필드를 사용하여) Roboto를 찾습니다. 여기에는 여러 Roboto 가변 글꼴이 나열됩니다.
4. **Roboto Serif**를 선택하여, 세부 정보 페이지를 엽니다.
5. 세부 정보 페이지에서, **Type tester** 탭을 선택합니다. 
   Roboto Serif 글꼴의 경우 **Variable axes** 열은 다음과 같습니다.

<img src='/assets/images/docs/development/ui/typography/roboto-serif-font-axes.png'
class="mw-100" alt="Listing of available font axes for Roboto Serif">

실시간으로, 축 중 하나에서 슬라이더를 움직여 글꼴에 어떤 영향을 미치는지 확인하세요. 
가변 글꼴을 프로그래밍할 때, [`FontVariation`][] 클래스를 사용하여 글꼴의 디자인 축을 수정하세요. 
`FontVariation` 클래스는 [OpenType 글꼴 가변(variables) 사양][OpenType font variables spec]을 따릅니다.

[`FontVariation`]: {{site.api}}/flutter/dart-ui/FontVariation-class.html
[Google Fonts]: https://fonts.google.com/
[OpenType font variables spec]: https://learn.microsoft.com/en-us/typography/opentype/spec/otvaroverview

## 정적(Static) 폰트 {:#static-fonts}

Google Fonts에는 정적 글꼴도 포함되어 있습니다. 
가변 글꼴과 마찬가지로, 글꼴이 어떻게 디자인되었는지 알아야 어떤 옵션을 사용할 수 있는지 알 수 있습니다. 
다시 한 번 말씀드리지만, Google Fonts 사이트가 도움이 될 수 있습니다.

### Google Fonts 사이트 사용 {:#using-the-google-fonts-site}

해당 글꼴의 세부 정보 페이지를 통해 정적 글꼴에 대해 자세히 알아보세요.

1. 가변 Google 글꼴을 조사하려면, [Google Fonts][] 웹사이트로 이동합니다. 
   각 글꼴 카드의 오른쪽 상단 모서리에, 
   가변 글꼴의 경우 **variable** 또는 
   정적 글꼴이 지원하는 스타일 수를 나타내는 **x styles**이라고 적혀 있습니다.
2. **Show only variable fonts**가 체크되지 **않았는지** 확인하고, 검색 필드가 비어 있는지 확인합니다.
3. **Font properties** 메뉴를 엽니다. **Number of styles** 확인란을 선택하고, 슬라이더를 10+로 이동합니다.
4. **Roboto**와 같은 글꼴을 선택하여, 세부 정보 페이지를 엽니다.
5. Roboto에는 스타일이 12개 있으며, 각 스타일은 세부 정보 페이지에서, 해당 변형의 이름과 함께 미리 볼 수 있습니다.
6. 실시간으로, 픽셀 슬라이더를 이동하여, 다양한 픽셀 크기로 글꼴을 미리 봅니다.
7. **Type tester** 탭을 선택하여, 글꼴에 지원되는 스타일을 확인합니다. 이 경우, 지원되는 스타일은 3개입니다.
8. **Glyph** 탭을 선택합니다. 이는 글꼴이 지원하는 문자를 보여줍니다.

다음 API를 사용하여 정적 글꼴을 프로그래밍 방식으로 변경합니다. (하지만 이 기능은 글꼴이 해당 기능을 지원하도록 _디자인된_ 경우에만 작동합니다)

* [`FontFeature`][]는 글리프(glyphs)를 선택합니다.
* [`FontWeight`][]는 굵기(weight)를 수정합니다.
* [`FontStyle`][]는 기울임체(italicize)로 표시합니다.

`FontFeature`는 [OpenType 기능 태그][OpenType feature tag]에 해당하며, 
주어진 글꼴의 기능을 활성화하거나 비활성화하는 boolean 플래그로 간주할 수 있습니다. 
다음 예는 CSS를 위한 것이지만 개념을 설명합니다.

<img src='/assets/images/docs/development/ui/typography/feature-tag-example.png'
class="mw-100" alt="Example feature tags in CSS">

[`FontFeature`]: {{site.api}}/flutter/dart-ui/FontFeature-class.html
[`FontStyle`]: {{site.api}}/flutter/dart-ui/FontStyle.html
[`FontWeight`]: {{site.api}}/flutter/dart-ui/FontWeight-class.html
[OpenType feature tag]: https://learn.microsoft.com/en-us/typography/opentype/spec/featuretags

## 기타 리소스 {:#other-resources}

다음 비디오는 Flutter의 타이포그래피의 일부 기능을 보여주고, 
이를 Material _그리고_ Cupertino의 모양과 느낌(앱이 실행되는 플랫폼에 따라 다름), 
애니메이션 및 커스텀 조각 셰이더와 결합합니다.

{% ytEmbed 'sA5MRFFUuOU', 'Flutter로 아름다운 디자인 프로토타입 만들기' %}

한 엔지니어가 가변 글꼴을 커스터마이즈하고 변형하면서 애니메이션을 적용한 경험을 읽어보려면 (위의 비디오의 기초가 됨), 
Medium의 무료 글인 [Flutter로 즐기는 타이포그래피][article]를 확인하세요. 
관련 예에서도 커스텀 셰이더를 사용합니다.

[article]: {{site.flutter-medium}}/playful-typography-with-flutter-f030385058b4
