---
# title: Add ads to your mobile Flutter app or game
title: 모바일 Flutter 앱이나 게임에 광고 추가
# short-title: Show ads
short-title: 광고 표시
# description: How to use the google_mobile_ads package to show ads in Flutter.
description: Flutter에서 google_mobile_ads 패키지를 사용하여 광고를 표시하는 방법.
---

<?code-excerpt path-base="cookbook/plugins/google_mobile_ads"?>

{% comment %}
  이것은 여기의 AdMob 설명서를 부분적으로 복제한 것입니다: https://developers.google.com/admob/flutter/quick-start

  이 페이지의 부가 가치는 Flutter 앱이나 게임만 있고 여기에 수익 창출을 추가하려는 사람에게 더 간단하다는 것입니다.

  간단히 말해서, 이것은 Flutter에서 광고에 대한 더 친근한 --- 하지만 포괄적이지는 않은 --- 소개입니다.
{% endcomment %}


많은 개발자가 모바일 앱과 게임을 수익화하기 위해 광고를 사용합니다. 
이를 통해 앱을 무료로 다운로드할 수 있어, 앱의 인기가 향상됩니다.

![광고가 표시된 스마트폰의 일러스트레이션](/assets/images/docs/cookbook/ads-device.jpg){:.site-illustration}

Flutter 프로젝트에 광고를 추가하려면, 
Google의 모바일 광고 플랫폼인 [AdMob](https://admob.google.com/home/)을 사용하세요. 
이 레시피는 [`google_mobile_ads`]({{site.pub-pkg}}/google_mobile_ads) 패키지를 사용하여,
앱이나 게임에 배너 광고를 추가하는 방법을 보여줍니다.

:::note
AdMob 외에도, `google_mobile_ads` 패키지는 대규모 퍼블리셔를 위한 플랫폼인 Ad Manager도 지원합니다.
Ad Manager를 통합하는 것은 AdMob을 통합하는 것과 비슷하지만, 이 쿡북 레시피에서는 다루지 않습니다. 
Ad Manager를 사용하려면, [Ad Manager 설명서]({{site.developers}}/ad-manager/mobile-ads-sdk/flutter/quick-start)를 따르세요.
:::

## 1. AdMob 앱 ID 받기 {:#1-get-admob-app-ids}

1. [AdMob](https://admob.google.com/)으로 이동하여 계정을 설정합니다. 
   은행 정보를 제공하고, 계약서에 서명해야 하므로, 시간이 다소 걸릴 수 있습니다.

2. AdMob 계정이 준비되면, AdMob에서 두 개의 *앱*을 만듭니다. 
   하나는 Android용이고 다른 하나는 iOS용입니다.

3. **App settings** 섹션을 엽니다.

4. Android 앱과 iOS 앱 모두에 대한 AdMob *앱 ID*를 가져옵니다.
   `ca-app-pub-1234567890123456~1234567890`처럼 생겼습니다. 
   두 숫자 사이에 틸드(`~`)가 있습니다. 
   {% comment %} https://support.google.com/admob/answer/7356431 (나중에 참조) {% endcomment %}

    ![Screenshot from AdMob showing the location of the App ID](/assets/images/docs/cookbook/ads-app-id.png)

## 2. 플랫폼별 설정 {:#2-platform-specific-setup}

앱 ID를 포함하도록 Android 및 iOS 구성을 업데이트하세요.

{% comment %}
    아래 내용은 devsite에서 복사해서 붙여넣은 것입니다.
    https://developers.google.com/admob/flutter/quick-start#platform_specific_setup
{% endcomment %}

### Android

Android 앱에 AdMob 앱 ID를 추가합니다.

1. 앱의 `android/app/src/main/AndroidManifest.xml` 파일을 엽니다.

2. 새 `<meta-data>` 태그를 추가합니다.

3. `android:name` 요소를 `com.google.android.gms.ads.APPLICATION_ID` 값으로 설정합니다.

4. `android:value` 요소를 이전 단계에서 얻은 자체 AdMob 앱 ID 값으로 설정합니다. 
   표시된 대로 따옴표로 묶습니다.

    ```xml
    <manifest>
        <application>
            ...
    
            <!-- 샘플 AdMob 앱 ID: ca-app-pub-3940256099942544~3347511713 -->
            <meta-data
                android:name="com.google.android.gms.ads.APPLICATION_ID"
                android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
        </application>
    </manifest>
    ```

### iOS

iOS 앱에 AdMob 앱 ID를 추가합니다.

1. 앱의 `ios/Runner/Info.plist` 파일을 엽니다.

2. `GADApplicationIdentifier`를 `key` 태그로 묶습니다.

3. AdMob 앱 ID를 `string` 태그로 묶습니다. 이 AdMob 앱 ID는 [1단계](#1-get-admob-app-ids)에서 생성했습니다.

    ```xml
    <key>GADApplicationIdentifier</key>
    <string>ca-app-pub-################~##########</string>
    ```

## 3. `google_mobile_ads` 플러그인 추가 {:#3-add-the-google_mobile_ads-plugin}

`google_mobile_ads` 플러그인을 종속성으로 추가하려면, `flutter pub add`를 실행하세요.

```console
$ flutter pub add google_mobile_ads
```

:::note
플러그인을 추가하면, Android 앱이 `DexArchiveMergerException`과 함께 빌드에 실패할 수 있습니다.

```plaintext
Error while merging dex archives:
The number of method references in a .dex file cannot exceed 64K.
```

이를 해결하려면, IDE 플러그인이 아닌 터미널에서 `flutter run` 명령을 실행하세요. 
`flutter` 도구는 문제를 감지하고 해결을 시도할지 묻습니다. 
`y`를 선택하면 문제가 사라집니다. 그 후 IDE에서 앱을 다시 실행할 수 있습니다.

![Screenshot of the `flutter` tool asking about multidex support](/assets/images/docs/cookbook/ads-multidex.png)
:::

## 4. Mobile Ads SDK 초기화 {:#4-initialize-the-mobile-ads-sdk}

광고를 로드하기 전에 Mobile Ads SDK를 초기화해야 합니다.

1. `MobileAds.instance.initialize()`를 호출하여 Mobile Ads SDK를 초기화합니다.

    <?code-excerpt "lib/main.dart (main)"?>
    ```dart
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      unawaited(MobileAds.instance.initialize());
    
      runApp(MyApp());
    }
    ```

위에 표시된 대로 시작 시 초기화 단계를 실행하여, AdMob SDK가 필요하기 전에 초기화할 충분한 시간을 확보합니다.

:::note
`MobileAds.instance.initialize()`는 `Future`를 반환하지만, SDK가 빌드된 방식에서는 `await`할 필요가 없습니다.
`Future`가 완료되기 전에 광고를 로드하려고 하면, SDK는 초기화될 때까지 우아하게 기다렸다가 _그런 다음_ 광고를 로드합니다. AdMob SDK가 준비되는 정확한 시간을 알고 싶다면 `Future`를 await할 수 있습니다.
:::

## 5. 배너 광고 로드 {:#5-load-a-banner-ad}

광고를 표시하려면, AdMob에 요청해야 합니다.

배너 광고를 로드하려면, `BannerAd` 인스턴스를 생성하고, `load()`를 호출합니다.

:::note
다음 코드 조각은 `adSize`, `adUnitId` 및 `_bannerAd`와 같은 필드를 참조합니다. 
이는 모두 나중 단계에서 더 의미가 있을 것입니다.
:::

<?code-excerpt "lib/my_banner_ad.dart (loadAd)"?>
```dart
/// 배너 광고를 로드합니다.
void _loadAd() {
  final bannerAd = BannerAd(
    size: widget.adSize,
    adUnitId: widget.adUnitId,
    request: const AdRequest(),
    listener: BannerAdListener(
      // 광고가 성공적으로 수신되면 호출됩니다.
      onAdLoaded: (ad) {
        if (!mounted) {
          ad.dispose();
          return;
        }
        setState(() {
          _bannerAd = ad as BannerAd;
        });
      },
      // 광고 요청이 실패하면 호출됩니다.
      onAdFailedToLoad: (ad, error) {
        debugPrint('BannerAd failed to load: $error');
        ad.dispose();
      },
    ),
  );

  // 로딩을 시작합니다.
  bannerAd.load();
}
```

전체 예를 보려면, 이 쿡북의 마지막 단계를 확인하세요.


## 6. 배너 광고 보기 {:#6-show-banner-ad}

`BannerAd` 인스턴스를 로드하면, `AdWidget`을 사용하여 표시합니다.

```dart
AdWidget(ad: _bannerAd)
```

위젯을 `SafeArea`로 감싸서(광고의 어떤 부분도 기기 노치에 의해 가려지지 않도록)하고, 
`SizedBox`로 감싸서(로딩 전후에 지정된 일정한 크기를 유지하도록)하는 것이 좋습니다.

<?code-excerpt "lib/my_banner_ad.dart (build)"?>
```dart
@override
Widget build(BuildContext context) {
  return SafeArea(
    child: SizedBox(
      width: widget.adSize.width.toDouble(),
      height: widget.adSize.height.toDouble(),
      child: _bannerAd == null
          // 아직 렌더링할 것이 없습니다.
          ? SizedBox()
          // 실제 광고
          : AdWidget(ad: _bannerAd!),
    ),
  );
}
```

더 이상 액세스할 필요가 없을 때 광고를 폐기해야 합니다. 
`dispose()`를 호출하는 가장 좋은 방법은 
위젯 트리에서 `AdWidget`을 제거한 후 또는 
`BannerAdListener.onAdFailedToLoad()` 콜백에서 호출하는 것입니다.

<?code-excerpt "lib/my_banner_ad.dart (dispose)"?>
```dart
_bannerAd?.dispose();
```


## 7. 광고 구성 {:#7-configure-ads}

테스트 광고 외에 무엇이든 표시하려면, 광고 단위(unit)를 등록해야 합니다.

1. [AdMob](https://admob.google.com/)을 엽니다.

2. 각 AdMob 앱에 대한 *광고 단위*를 만듭니다.

    여기서는 광고 단위의 형식을 묻습니다. 
    AdMob은 배너 광고 외에도 여러 형식을 제공합니다. (전면 광고, 보상형 광고, 앱 오픈 광고 등)
    이러한 광고의 API는 비슷하며, [AdMob 문서]({{site.developers}}/admob/flutter/quick-start)와 [공식 샘플](https://github.com/googleads/googleads-mobile-flutter/tree/main/samples/admob)에 설명되어 있습니다.

3.  배너 광고를 선택하세요.

4.  Android 앱과 iOS 앱 모두에 대한 *광고 단위 ID*를 가져옵니다. **Ad units** 섹션에서 찾을 수 있습니다. 
    `ca-app-pub-1234567890123456/1234567890`처럼 생겼습니다. 
    형식은 *앱 ID*와 비슷하지만, 두 숫자 사이에 슬래시(`/`)가 있습니다. 
    이는 *광고 단위 ID*와 *앱 ID*를 구분합니다.

    ![Screenshot of an Ad Unit ID in AdMob web UI](/assets/images/docs/cookbook/ads-ad-unit-id.png)

5.  대상 앱 플랫폼에 따라 `BannerAd` 생성자에 이러한 *광고 단위 ID*를 추가합니다.

    <?code-excerpt "lib/my_banner_ad.dart (adUnitId)"?>
    ```dart
    final String adUnitId = Platform.isAndroid
        // Android에서 이 광고 단위를 사용하세요...
        ? 'ca-app-pub-3940256099942544/6300978111'
        // ... 또는 iOS에서 이 광고 단위를 사용하세요.
        : 'ca-app-pub-3940256099942544/2934735716';
    ```

## 8. 마지막 마무리 {:#8-final-touches}

게시된 앱이나 게임에 광고를 표시하려면(디버그 또는 테스트 시나리오와 대조적으로), 앱이 추가 요구 사항을 충족해야 합니다.

1. 앱은 광고를 완전히 게재하기 전에 검토 및 승인을 받아야 합니다. 
   AdMob의 [앱 준비 가이드라인](https://support.google.com/admob/answer/10564477)을 따르세요. 
   예를 들어, 앱은 Google Play Store나 Apple App Store와 같이 지원되는 스토어 중 하나 이상에 등록되어야 합니다.

2. [`app-ads.txt`](https://support.google.com/admob/answer/9363762) 파일을 만들어 
   개발자 웹사이트에 게시해야 합니다.

![An illustration of a smartphone showing an ad](/assets/images/docs/cookbook/ads-device.jpg){:.site-illustration}

앱 및 게임 수익 창출에 대해 자세히 알아보려면, 
[AdMob](https://admob.google.com/) 및 
[Ad Manager](https://admanager.google.com/)의 공식 사이트를 방문하세요.


## 9. 예제 완성하기 {:#9-complete-example}

다음 코드는 배너 광고를 로드하고 표시하는 간단한 stateful 위젯을 구현합니다.

<?code-excerpt "lib/my_banner_ad.dart"?>
```dart
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAdWidget extends StatefulWidget {
  /// 요청된 배너 크기입니다. 기본값은 [AdSize.banner]입니다.
  final AdSize adSize;

  /// 표시할 AdMob 광고 단위입니다.
  ///
  /// TODO: 이 테스트 광고 단위를 귀하의 광고 단위로 바꾸세요.
  final String adUnitId = Platform.isAndroid
      // Android에서 이 광고 단위를 사용하세요...
      ? 'ca-app-pub-3940256099942544/6300978111'
      // ... 또는 iOS에서 이 광고 단위를 사용하세요.
      : 'ca-app-pub-3940256099942544/2934735716';

  MyBannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  State<MyBannerAdWidget> createState() => _MyBannerAdWidgetState();
}

class _MyBannerAdWidgetState extends State<MyBannerAdWidget> {
  /// 표시할 배너 광고입니다. 광고가 실제로 로드될 때까지는 `null`입니다.
  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: widget.adSize.width.toDouble(),
        height: widget.adSize.height.toDouble(),
        child: _bannerAd == null
            // 아직 렌더링할 것이 없습니다.
            ? SizedBox()
            // 실제 광고입니다.
            : AdWidget(ad: _bannerAd!),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// 배너 광고를 로드합니다.
  void _loadAd() {
    final bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        // 광고가 성공적으로 수신되면 호출됩니다.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // 광고 요청이 실패하면 호출됩니다.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // 로딩을 시작합니다.
    bannerAd.load();
  }
}
```

:::tip
많은 경우, 위젯 _외부_ 에 광고를 로드하고 싶을 것입니다.

예를 들어, `ChangeNotifier`, BLoC, 컨트롤러 또는 앱 레벨 상태에 사용하는 다른 것에 로드할 수 있습니다. 
이렇게 하면, 배너 광고를 미리 로드하여, 사용자가 새 화면으로 네비게이션 할 때 표시할 준비를 할 수 있습니다.

`AdWidget`으로 표시하기 전에 `BannerAd` 인스턴스를 로드했는지 확인하고, 더 이상 필요하지 않으면 인스턴스를 폐기합니다.
:::
