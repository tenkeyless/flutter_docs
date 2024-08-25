---
# title: Measuring your app's size
title: 앱 크기 측정
# description: How to measure app size for iOS and Android.
description: iOS 및 Android에서 앱 크기를 측정하는 방법.
---

많은 개발자가 컴파일된 앱의 크기에 대해 우려합니다. 
Flutter 앱의 APK, 앱 번들 또는 IPA 버전은 자체 포함되고, 
앱을 실행하는 데 필요한 모든 코드와 assets을 보유하기 때문에, 크기가 문제가 될 수 있습니다. 
앱이 클수록, 기기에서 필요한 공간이 더 많고, 다운로드하는 데 시간이 더 오래 걸리며, 
Android 인스턴트 앱과 같은 유용한 기능의 한계를 깨뜨릴 수 있습니다.

## 디버그 빌드는 대표적(representative)이지 않습니다.  {:#debug-builds-are-not-representative}

기본적으로, `flutter run`으로 앱을 시작하거나, 
IDE에서 **Play** 버튼을 클릭하면([테스트 드라이브][Test drive] 및 [첫 번째 Flutter 앱 작성][Write your first Flutter app]에서 사용), 
Flutter 앱의 _debug_ 빌드가 생성됩니다. 
디버그 빌드의 앱 크기는 핫 리로드 및 소스 레벨 디버깅을 허용하는 디버깅 오버헤드로 인해 큽니다. 
따라서, 최종 사용자 다운로드가 일어나는 프로덕션 앱에는 대표적이지 않습니다.

## 전체 크기 확인 {:#checking-the-total-size}

`flutter build apk` 또는 `flutter build ios`에서 만든 것과 같은, 기본 릴리스 빌드는, 
Play Store 및 App Store에 업로드 패키지를 편리하게 조립하도록 빌드됩니다. 
따라서, 최종 사용자의 다운로드 크기를 나타내지 않습니다. 
일반적으로 스토어는 업로드 패키지를 다시 처리하고 분할하여, 특정 다운로더와 다운로더의 하드웨어를 대상으로 합니다. 
예를 들어, 휴대폰의 DPI를 대상으로 하는 assets을 필터링하고, 
휴대폰의 CPU 아키텍처를 대상으로 하는 네이티브 라이브러리를 필터링합니다.

### 전체 크기 추정 {:#estimating-total-size}

각 플랫폼에서 가장 근접한 대략적인 크기를 알아보려면, 다음 지침을 따르세요.

#### Android {:#android}

앱 다운로드 및 설치 크기를 확인하려면 Google [Play Console의 지침][Play Console's instructions]을 따르세요.

애플리케이션에 대한 업로드 패키지를 생성하세요.

```console
flutter build appbundle
```

[Google Play Console][]에 로그인합니다. .aab 파일을 끌어서 놓아 애플리케이션 바이너리를 업로드합니다.

**Android vitals** -> **App size** 탭에서, 애플리케이션의 다운로드 및 설치 크기를 확인합니다.

{% render docs/app-figure.md, image:"perf/vital-size.png", alt:"Google Play Console의 앱 크기 탭" %}

다운로드 크기는 arm64-v8a 아키텍처의 XXXHDPI(~640dpi) 장치를 기준으로 계산됩니다. 
최종 사용자의 다운로드 크기는 하드웨어에 따라 다를 수 있습니다.

상단 탭에는 다운로드 크기와 설치 크기에 대한 토글이 있습니다. 
이 페이지에는 아래에 최적화 팁도 포함되어 있습니다.

#### iOS {:#ios}

[Xcode 앱 크기 보고서][Xcode App Size Report]를 ​​만듭니다.

먼저, [iOS 빌드 아카이브 생성 지침][iOS create build archive instructions]에 설명된 대로 앱 버전과 빌드를 구성합니다.

그런 다음:

1. `flutter build ipa --export-method development`를 실행합니다.
2. `open build/ios/archive/*.xcarchive`를 실행하여, Xcode에서 아카이브를 엽니다.
3. **Distribute App**를 클릭합니다.
4. 배포 방법을 선택합니다. 애플리케이션을 배포하지 않으려면, **Development**이 가장 간단합니다.
5. **App Thinning**에서 'all compatible device variants'을 선택합니다.
6. **Strip Swift symbols**를 선택합니다.

IPA에 서명하고 내보냅니다. 
내보낸 디렉토리에는 다양한 기기와 iOS 버전에서 예상되는 애플리케이션 크기에 대한 세부 정보가 포함된 `App Thinning Size Report.txt`가 들어 있습니다.

Flutter 1.17의 기본 데모 앱에 대한 앱 크기 보고서는 다음을 보여줍니다.

```plaintext
Variant: Runner-7433FC8E-1DF4-4299-A7E8-E00768671BEB.ipa
Supported variant descriptors: [device: iPhone12,1, os-version: 13.0] and [device: iPhone11,8, os-version: 13.0]
App + On Demand Resources size: 5.4 MB compressed, 13.7 MB uncompressed
App size: 5.4 MB compressed, 13.7 MB uncompressed
On Demand Resources size: Zero KB compressed, Zero KB uncompressed
```

이 예에서, 
앱은 iOS 13.0을 실행하는 iPhone12,1(iPhone 11의 경우 [모델 ID/하드웨어 번호][Model ID / Hardware number]) 및 iPhone11,8(iPhone XR)에서, 대략 5.4MB의 다운로드 크기와 대략 13.7MB의 설치 크기를 갖습니다.

iOS 앱을 정확히 측정하려면, 릴리스 IPA를 Apple의 App Store Connect([지침][instructions])에 업로드하고, 
거기에서 크기 보고서를 얻어야 합니다. 
IPA는 일반적으로 Flutter [FAQ][]의 섹션의 [Flutter 엔진은 얼마나 큰가요?][How big is the Flutter engine?]에서 설명한 대로 APK보다 큽니다.

## 크기를 분해하기 {:#breaking-down-the-size}

Flutter 버전 1.22와 DevTools 버전 0.9.1부터, 
개발자가 애플리케이션 릴리스 빌드의 세부 내용을 이해하는 데 도움이 되는 크기 분석 도구가 포함되었습니다.

:::warning
위의 [전체 크기 확인](#checking-the-total-size) 섹션에서 언급했듯이, 
업로드 패키지는 최종 사용자의 다운로드 크기를 나타내지 않습니다. 
분석 도구에서 볼 수 있는 중복 네이티브 라이브러리 아키텍처와 asset 밀도는, 
Play Store와 App Store에서 필터링할 수 있습니다.
:::

크기 분석 도구는 빌드할 때 `--analyze-size` 플래그를 전달하여 호출됩니다.

- `flutter build apk --analyze-size`
- `flutter build appbundle --analyze-size`
- `flutter build ios --analyze-size`
- `flutter build linux --analyze-size`
- `flutter build macos --analyze-size`
- `flutter build windows --analyze-size`

이 빌드는 두 가지 면에서 표준 릴리스 빌드와 다릅니다.

1. 이 도구는 Dart 패키지의 코드 크기 사용을 기록하는 방식으로 Dart를 컴파일합니다.
2. 이 도구는 터미널에 크기 분석의 높은 레벨의 요약을 표시하고, 
   DevTools에서 더 자세한 분석을 위해 `*-code-size-analysis_*.json` 파일을 남깁니다.

단일 빌드를 분석하는 것 외에도, 두 개의 `*-code-size-analysis_*.json` 파일을 DevTools에 로드하여, 두 개의 빌드를 비교할 수도 있습니다. 
자세한 내용은 [DevTools 문서][DevTools documentation]를 ​​확인하세요.

{% render docs/app-figure.md, image:"perf/size-summary.png", alt:"터미널에서 Android 애플리케이션의 크기 요약" %}

요약을 통해, 카테고리(asset, 네이티브 코드, Flutter 라이브러리 등)별 크기 사용량을 빠르게 파악할 수 있습니다. 
컴파일된 Dart 네이티브 라이브러리는 빠른 분석을 위해 패키지별로 더 세분화됩니다.

:::warning
iOS의 이 도구는 IPA가 아닌 .app을 만듭니다. 
이 도구를 사용하여 .app 콘텐츠의 상대적 크기를 평가합니다. 
다운로드 크기를 더 자세히 추정하려면, 위의 [전체 크기 추정](#estimating-total-size) 섹션을 참조하세요.
:::

### DevTools에서 더 심층적인 분석 {:#deeper-analysis-in-devtools}

위에서 생성된 `*-code-size-analysis_*.json` 파일은 DevTools에서 더 자세히 분석할 수 있습니다. 
여기서 트리 또는 트리맵 뷰는 애플리케이션의 내용을 개별 파일 수준과 Dart AOT 아티팩트의 기능 수준까지 세분화할 수 있습니다.

`dart devtools`에서 `Open app size tool`를 선택하고, JSON 파일을 업로드하여 이를 수행할 수 있습니다.

{% render docs/app-figure.md, image:"perf/devtools-size.png", alt:"DevTools에서 앱의 분해 예시" %}

DevTools 앱 크기 도구 사용에 대한 자세한 내용은 [DevTools 문서][DevTools documentation]를 ​​확인하세요.

## 앱 크기 줄이기 {:#reducing-app-size}

앱의 릴리스 버전을 빌드할 때, `--split-debug-info` 태그를 사용하는 것을 고려하세요. 
이 태그는 코드 크기를 극적으로 줄일 수 있습니다. 
이 태그를 사용하는 예는, [Dart 코드 난독화][Obfuscating Dart code]를 참조하세요.

앱을 더 작게 만들기 위해 할 수 있는 다른 몇 가지 작업은 다음과 같습니다.

* 사용하지 않는 리소스 제거
* 라이브러리에서 가져온 리소스 최소화
* PNG 및 JPEG 파일 압축

[FAQ]: /resources/faq
[How big is the Flutter engine?]: /resources/faq#how-big-is-the-flutter-engine
[instructions]: /deployment/ios
[Xcode App Size Report]: {{site.apple-dev}}/documentation/xcode/reducing_your_app_s_size#3458589
[iOS create build archive instructions]: /deployment/ios#update-the-apps-build-and-version-numbers
[Model ID / Hardware number]: https://en.wikipedia.org/wiki/List_of_iOS_devices#Models
[Obfuscating Dart code]: /deployment/obfuscate
[Test drive]: /get-started/test-drive
[Write your first Flutter app]: /get-started/codelab
[Play Console's instructions]: https://support.google.com/googleplay/android-developer/answer/9302563?hl=en
[Google Play Console]: https://play.google.com/apps/publish/
[DevTools documentation]: /tools/devtools/app-size
