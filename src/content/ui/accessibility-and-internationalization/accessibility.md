---
# title: Accessibility
title: 접근성
# description: Information on Flutter's accessibility support.
description: Flutter의 접근성 지원에 대한 정보.
---

다양한 사용자가 앱을 사용할 수 있도록 하는 것은 고품질 앱을 구축하는 데 필수적인 부분입니다. 
설계가 잘못된 애플리케이션은 모든 연령대의 사람들에게 장벽을 만듭니다. 
[UN 장애인 권리 협약][CRPD]는 정보 시스템에 대한 보편적 접근성을 보장하는 것이 도덕적, 법적 의무라고 명시하고 있으며, 
전 세계 국가는 접근성을 요구 사항으로 시행하고 있으며, 
기업은 서비스에 대한 접근성을 극대화하는 것의 비즈니스적 이점을 인식하고 있습니다.

앱을 출시하기 전에 접근성 체크리스트를 핵심 기준으로 포함하는 것이 좋습니다. 
Flutter는 개발자가 앱을 더 접근성있게 만들 수 있도록 지원하는 데 전념하고 있으며, 
기본 운영 체제에서 제공하는 것 외에도 접근성을 위한 일류 프레임워크 지원을 포함합니다. 
여기에는 다음이 포함됩니다.

[**큰 글꼴**][**Large fonts**]
: 사용자가 지정한 글꼴 크기로 텍스트 위젯 렌더링

[**화면 리더**][**Screen readers**]
: UI 콘텐츠에 대한 음성 피드백 전달

[**충분한 대비**][**Sufficient contrast**]
: 충분한 대비가 있는 색상으로 위젯 렌더링

이러한 기능에 대한 자세한 내용은 아래에서 설명합니다.

## 접근성 지원 검사 {:#inspecting-accessibility-support}

이러한 특정 주제에 대한 테스트 외에도, 자동화된 접근성 스캐너를 사용하는 것이 좋습니다.

* Android의 경우:
  1. Android용 [접근성 스캐너][Accessibility Scanner]를 설치합니다.
  2. **Android Settings > Accessibility > Accessibility Scanner > On**에서 접근성 스캐너를 활성화합니다.
  3. Accessibility Scanner '체크박스' 아이콘 버튼으로 이동하여 스캔을 시작합니다.

* iOS의 경우:
  1. Xcode에서 Flutter 앱의 `iOS` 폴더를 엽니다.
  2. 대상으로 Simulator를 선택하고, **Run** 버튼을 클릭합니다.
  3. Xcode에서 **Xcode > Open Developer Tools > Accessibility Inspector**를 선택합니다.
  4. Accessibility Inspector에서, **Inspection > Enable Point to Inspect**를 선택한 다음, 
     실행 중인 Flutter 앱에서 다양한 사용자 인터페이스 요소를 선택하여, 접근성 속성을 검사합니다.
  5. Accessibility Inspector에서, 도구 모음에서 **Audit**를 선택한 다음, 
     **Run Audit**을 선택하여 잠재적인 문제에 대한 보고서를 받습니다.

* 웹의 경우:
  1. Chrome DevTools(또는 다른 브라우저의 유사한 도구)를 엽니다.
  2. Flutter에서 생성된 ARIA 속성이 포함된 HTML 트리를 검사합니다.
  3. Chrome에서, "Elements" 탭에는 시맨틱 트리로 내보낸 데이터를 검사하는 데 사용할 수 있는 
     "Accessibility" 하위 탭이 있습니다.

## 1. 큰 글꼴 {:#large-fonts}

Android와 iOS 모두 앱에서 사용하는 원하는 글꼴 크기를 구성하기 위한 시스템 설정을 포함합니다. 
Flutter 텍스트 위젯은 글꼴 크기를 결정할 때 이 OS 설정을 따릅니다.

글꼴 크기는 Flutter에서 OS 설정에 따라 자동으로 계산됩니다. 
그러나, 개발자는 글꼴 크기가 증가할 때, 레이아웃에 모든 콘텐츠를 렌더링할 수 있는 충분한 공간이 있는지 확인해야 합니다. 
예를 들어, 가장 큰 글꼴 설정을 사용하도록 구성된 소형 화면 기기에서 앱의 모든 부분을 테스트할 수 있습니다.

### 예제 {:#example}

다음 두 스크린샷은 기본 iOS 글꼴 설정으로 렌더링된 표준 Flutter 앱 템플릿과, 
iOS 접근성 설정에서 선택된 가장 큰 글꼴 설정을 보여줍니다.

<div class="row">
  <div class="col-md-6">
    {% render docs/app-figure.md, image:"a18n/app-regular-fonts.png", caption:"기본 글꼴 설정", img-class:"border" %}
  </div>
  <div class="col-md-6">
    {% render docs/app-figure.md, image:"a18n/app-large-fonts.png", caption:"가장 큰 접근성 글꼴 설정", img-class:"border" %}
  </div>
</div>

## 2. 화면 리더 {:#screen-readers}

모바일의 경우, 화면 리더([TalkBack][], [VoiceOver][])를 사용하면 시각 장애인이 화면 내용에 대한 음성 피드백을 받고, 
모바일에서는 제스처를 사용하고 데스크톱에서는 키보드 단축키를 사용하여, UI와 상호 작용할 수 있습니다. 
모바일 기기에서 VoiceOver 또는 TalkBack을 켜고 앱을 탐색하세요.

**기기에서 화면 리더를 켜려면, 다음 단계를 완료하세요.**

{% tabs %}
{% tab "Android에서 TalkBack 사용" %}

1. 기기에서, **Settings**을 엽니다.
2. **Accessibility**을 선택한 다음, **TalkBack**을 선택합니다.
3. 'Use TalkBack'을 켜거나 끕니다.
4. Ok를 선택합니다.

Android의 접근성 기능을 찾고 커스터마이즈하는 방법을 알아보려면, 다음 비디오를 시청하세요.

{% ytEmbed 'FQyj_XTl01w', 'Pixel 및 Android 접근성 기능 커스터마이즈' %}

{% endtab %}
{% tab "iPhone에서 VoiceOver 사용" %}

1. 기기에서, **Settings > Accessibility > VoiceOver**를 엽니다.
2. VoiceOver 설정을 켜거나 끕니다.

iOS 접근성 기능을 찾고 커스터마이즈 하는 방법을 알아보려면, 다음 비디오를 시청하세요.

{% ytEmbed 'ROIe49kXOc8', 'VoiceOver로 iPhone 또는 iPad를 탐색하는 방법' %}

{% endtab %}
{% tab "브라우저" %}

웹의 경우, 현재 다음 화면 리더가 지원됩니다.

모바일 브라우저:

* iOS - VoiceOver
* Android - TalkBack

데스크톱 브라우저:

* macOS - VoiceOver
* Windows - JAWs & NVDA

웹의 화면 리더 사용자는 "접근성 사용(Enable accessibility)" 버튼을 토글하여 시맨틱 트리를 빌드해야 합니다. 
이 API를 사용하여 앱의 접근성을 프로그래밍 방식으로 자동으로 활성화하는 경우, 사용자는 이 단계를 건너뛸 수 있습니다.

```dart
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

void main() {
  runApp(const MyApp());
  SemanticsBinding.instance.ensureSemantics();
}
```

{% endtab %}
{% tab "데스크탑" %}

Windows에는 Narrator라는 화면 리더가 있지만, 일부 개발자는 더 인기 있는 NVDA 화면 리더를 사용하는 것이 좋습니다. 
NVDA를 사용하여 Windows 앱을 테스트하는 방법에 대해 알아보려면, [프런트엔드 개발자를 위한 화면 리더 101(Windows)][nvda]를 확인하세요.

[nvda]: https://get-evinced.com/blog/screen-readers-101-for-front-end-developers-windows

Mac에서는, macOS에 포함된 VoiceOver의 데스크톱 버전을 사용할 수 있습니다.

{% ytEmbed '5R-6WvAihms', '화면 리더 기초: VoiceOver' %}

Linux에서 인기 있는 화면 리더는 Orca라고 합니다. 
일부 배포판에 미리 설치되어 있으며, `apt`와 같은 패키지 저장소에서 사용할 수 있습니다. 
Orca 사용에 대해 알아보려면 [Gnome 데스크톱에서 Orca 화면 리더 시작하기][orca]를 확인하세요.

[orca]: https://www.a11yproject.com/posts/getting-started-with-orca

{% endtab %}
{% endtabs %}

<br/>

다음 [비디오 데모][video demo]를 확인하여, 
Victor Tsaran이 현재 보관된 [Flutter Gallery][] 웹 앱에서 VoiceOver를 사용하는 것을 확인하세요.

Flutter의 표준 위젯은 접근성 트리를 자동으로 생성합니다. 
그러나, 앱에 다른 것이 필요한 경우, [`Semantics` 위젯][`Semantics` widget]을 사용하여 커스터마이즈 할 수 있습니다.

앱에 특정 음성으로 음성 처리해야 하는 텍스트가 있는 경우, 
[`TextSpan.locale`][]을 호출하여 화면 리더에 사용할 음성을 알립니다. 
`MaterialApp.locale` 및 `Localizations.override`는 화면 리더가 사용하는 음성에 영향을 미치지 않습니다. 
일반적으로, 화면 리더는 `TextSpan.locale`로 명시적으로 설정한 경우를 제외하고 시스템 음성을 사용합니다.

[Flutter Gallery]: {{site.gallery-archive}}
[`TextSpan.locale`]: {{site.api}}/flutter/painting/TextSpan/locale.html

## 3. 충분한 대비 {:#sufficient-contrast}

충분한 색상 대비는 텍스트와 이미지를 읽기 쉽게 만듭니다. 
다양한 시각 장애가 있는 사용자에게 도움이 되는 것 외에도, 
충분한 색상 대비는 직사광선에 노출되거나 밝기가 낮은 디스플레이와 같이 극한 조명 조건에서 장치에서 인터페이스를 볼 때, 
모든 사용자에게 도움이 됩니다.

[W3C][W3C recommends]에서 권장하는 사항:

* 작은 텍스트(18포인트 미만의 일반 글씨 또는 14포인트 굵은 글씨)의 경우 최소 4.5:1
* 큰 텍스트(18포인트 이상 일반 글씨 또는 14포인트 이상 굵은 글씨)의 경우 최소 3.0:1

## 접근성을 염두에 두고 빌드 {:#building-with-accessibility-in-mind}

모든 사람이 앱을 사용할 수 있도록 하려면 처음부터 접근성을 구축해야 합니다. 
어떤 앱의 경우 말하기는 쉽지만 실천하기는 어렵습니다. 
아래 영상에서, 두 명의 엔지니어가 모바일 앱을 접근성이 매우 낮은 상태에서, 
Flutter의 기본 제공 위젯을 활용하여 훨씬 더 접근성 있는 환경을 제공하는 상태로 전환합니다.

{% ytEmbed 'bWbBgbmAdQs', '접근성을 염두에 두고 Flutter 앱 빌드' %}

## 모바일에서 접근성 테스트 {:#testing-accessibility-on-mobile}

Flutter의 [접근성 가이드라인 API][Accessibility Guideline API]를 사용하여 앱을 테스트하세요. 
이 API는 앱의 UI가 Flutter의 접근성 권장 사항을 충족하는지 확인합니다. 
여기에는 텍스트 대비, 대상 크기 및 대상 레이블에 대한 권장 사항이 포함됩니다.

다음 예는 Name Generator에서 Guideline API를 사용하는 방법을 보여줍니다. 
이 앱은 [첫 번째 Flutter 앱 작성](/get-started/codelab) 코드랩의 일부로 만들었습니다. 
앱의 메인 화면에 있는 각 버튼은 18포인트로 표현된 텍스트가 있는 탭 가능한 대상으로 사용됩니다.

<?code-excerpt path-base="codelabs/namer/step_08"?>
<?code-excerpt "test/a11y_test.dart (insideTest)"?>
```dart
final SemanticsHandle handle = tester.ensureSemantics();
await tester.pumpWidget(MyApp());

// Android에서 탭 가능한 노드의 최소 크기가 48x48픽셀인지 확인합니다.
await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

// iOS에서 탭 가능한 노드의 최소 크기가 44x44픽셀인지 확인합니다.
await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));

// 탭하거나 길게 누르는 동작으로 터치 대상에 라벨이 지정되어 있는지 확인합니다.
await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

// 시맨틱 노드가 최소 텍스트 대비 레벨을 충족하는지 확인합니다.
// 더 큰 텍스트(18포인트 이상 일반)의 경우, 권장되는 텍스트 대비는 3:1입니다.
await expectLater(tester, meetsGuideline(textContrastGuideline));
handle.dispose();
```

앱 디렉토리의 `test/widget_test.dart`에 Guideline API 테스트를 추가하거나, 
별도의 테스트 파일(예: Name Generator의 경우 `test/a11y_test.dart`)로 추가할 수 있습니다.

[Accessibility Guideline API]: {{site.api}}/flutter/flutter_test/AccessibilityGuideline-class.html

## 웹에서 접근성 테스트 {:#testing-accessibility-on-web}

프로필 및 릴리스 모드에서 다음 명령줄 플래그를 사용하여 웹 앱에 대해 생성된 시맨틱 노드를 시각화하여 접근성을 디버깅할 수 있습니다.

```console
flutter run -d chrome --profile --dart-define=FLUTTER_WEB_DEBUG_SHOW_SEMANTICS=true
```

플래그가 활성화되면, 시맨틱 노드가 위젯 위에 나타납니다. 
시맨틱 요소가 있어야 할 위치에 배치되었는지 확인할 수 있습니다. 
시맨틱 노드가 잘못 배치된 경우, [버그 보고서를 제출하세요][file a bug report].

## 접근성 릴리스 체크리스트 {:#accessibility-release-checklist}

앱 출시를 준비할 때 고려해야 할 사항의 전체 리스트는 다음과 같습니다.

* **활성 상호작용(Active interactions)**. 
  * 모든 활성 상호작용이 무언가를 하는지 확인하세요. 
    * 누를 수 있는 모든 버튼은 누를 때 무언가를 해야 합니다. 
    * 예를 들어, `onPressed` 이벤트에 대한 no-op 콜백이 있는 경우, 
      방금 누른 컨트롤을 설명하는 `SnackBar`를 화면에 표시하도록 변경하세요.
* **스크린 리더 테스트(Screen reader testing)**. 
  * 스크린 리더는 탭할 때 페이지의 모든 컨트롤을 설명할 수 있어야 하며, 설명은 이해할 수 있어야 합니다. 
  * [TalkBack][](Android) 및 [VoiceOver][](iOS)로 앱을 테스트하세요.
* **대비율(Contrast ratios)**. 
  * 비활성화된 구성 요소를 제외하고, 컨트롤 또는 텍스트와 배경 간의 대비율이 최소 4.5:1이 되도록 권장합니다. 
    * 이미지도 충분한 대비를 위해 검토해야 합니다.
* **컨텍스트 전환(Context switching)**. 
  * 정보를 입력하는 동안 사용자의 컨텍스트를 자동으로 변경해서는 안 됩니다. 
  * 일반적으로, 위젯은 일종의 확인 작업 없이 사용자의 컨텍스트를 변경하지 않아야 합니다.
* **탭 가능한 대상(Tappable targets)**. 
  * 모든 탭 가능한 대상은 최소 48x48픽셀이어야 합니다.
* **오류(Errors)**. 
  * 중요한 작업은 실행 취소할 수 있어야 합니다. 
  * 오류가 표시된 필드에서, 가능하면 수정 사항을 제안합니다.
* **색각 결핍 테스트(Color vision deficiency testing)**. 
  * 컨트롤은 색맹 및 회색조 모드에서 사용 가능하고 읽을 수 있어야 합니다.
* **크기 요인(Scale factors)**. 
  * UI는 텍스트 크기 및 디스플레이 크기 조정을 위해 매우 큰 크기 요인에서도 읽을 수 있고 사용할 수 있어야 합니다.

## 더 알아보기 {:#learn-more}

Flutter와 접근성에 대해 자세히 알아보려면, 커뮤니티 멤버가 쓴 다음 기사를 확인하세요.

* [Flutter의 접근성 위젯에 대한 심층 분석][A deep dive into Flutter's accessibility widgets]
* [Flutter의 시맨틱][Semantics in Flutter]
* [Flutter: 스크린 리더를 위한 훌륭한 경험 만들기][Flutter: Crafting a great experience for screen readers]

[CRPD]: https://www.un.org/development/desa/disabilities/convention-on-the-rights-of-persons-with-disabilities/article-9-accessibility.html
[A deep dive into Flutter's accessibility widgets]: {{site.medium}}/flutter-community/a-deep-dive-into-flutters-accessibility-widgets-eb0ef9455bc
[Flutter: Crafting a great experience for screen readers]: https://blog.gskinner.com/archives/2022/09/flutter-crafting-a-great-experience-for-screen-readers.html
[Accessibility Scanner]: https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor&hl=en
[**Large fonts**]: #large-fonts
[**Screen readers**]: #screen-readers
[Semantics in Flutter]: https://www.didierboelens.com/2018/07/semantics/
[`Semantics` widget]: {{site.api}}/flutter/widgets/Semantics-class.html
[**Sufficient contrast**]: #sufficient-contrast
[TalkBack]: https://support.google.com/accessibility/android/answer/6283677?hl=en
[W3C recommends]: https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html
[VoiceOver]: https://www.apple.com/lae/accessibility/iphone/vision/
[video demo]: {{site.yt.watch}}?v=A6Sx0lBP8PI
[file a bug report]: https://goo.gle/flutter_web_issue
