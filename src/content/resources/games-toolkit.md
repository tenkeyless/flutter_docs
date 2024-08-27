---
# title: Casual Games Toolkit
title: 캐주얼 게임 툴킷
# description: >-
#   Learn about free & open source multiplatform 2D game development in Flutter.
description: >-
  Flutter에서 무료 & 오픈 소스 멀티플랫폼 2D 게임 개발에 대해 알아보세요.
---

Flutter Casual Games Toolkit은 새로운 리소스와 기존 리소스를 모아 
모바일 플랫폼에서 게임 개발을 가속화할 수 있도록 도와줍니다.

:::recommend
Flutter 3.22에 대한 최신 [게임 업데이트 및 리소스](#updates)를 확인하세요!
:::

이 페이지에서는 이러한 이용 가능한 리소스를 찾을 수 있는 위치를 설명합니다.

## 게임에 Flutter를 사용하는 이유는? {:#why-flutter-for-games}

Flutter 프레임워크는 데스크톱에서 모바일 기기, 웹에 이르기까지 6가지 대상 플랫폼에 대해 성능이 뛰어난 앱을 만들 수 있습니다.

Flutter의 크로스 플랫폼 개발, 성능 및 오픈 소스 라이선싱의 이점 덕분에 게임에 적합한 선택이 됩니다.

캐주얼 게임은 턴 기반 게임과 실시간 게임의 두 가지 범주로 나뉩니다. 
두 가지 타입의 게임에 익숙할 수도 있지만, 이런 쪽으로는 생각하지는 않았을 수도 있습니다.

* _턴 기반 게임_ 은 간단한 규칙과 게임 플레이를 갖춘 대중 시장을 위한 게임을 포함합니다. 
  * 여기에는 보드 게임, 카드 게임, 퍼즐 및 전략 게임이 포함됩니다. 
  * 이러한 게임은 카드를 탭하거나 숫자나 문자를 입력하는 것과 같은 간단한 사용자 입력에 반응합니다. 
  * 이러한 게임은 Flutter에 적합합니다.
* _실시간 게임_ 은 일련의 동작에 실시간 응답이 필요한 게임을 포함합니다. 
  * 여기에는 무한 러너 게임, 레이싱 게임 등이 포함됩니다. 
  * 충돌 감지, 카메라 뷰, 게임 루프 등과 같은 고급 기능이 있는 게임을 만들고 싶을 수 있습니다. 
  * 이런 타입의 게임은 Flutter를 사용하여 구축된 [Flame 게임 엔진][Flame game engine]과 같은 
    오픈소스 게임 엔진을 사용할 수 있습니다.

## 툴킷에 포함된 내용 {:#whats-included-in-the-toolkit}

Casual Games Toolkit은 다음과 같은 무료 리소스를 제공합니다.

* 캐주얼 게임을 만드는 시작점을 제공하는 3개의 새로운 게임 템플릿이 포함된 저장소.

  1. [베이스 게임 템플릿][basic-template]에는 다음 기본 사항이 포함되어 있습니다.

     * 메인 메뉴
     * 탐색
     * 설정
     * 레벨 선택
     * 플레이어 진행 상황
     * 플레이 세션 관리
     * 사운드
     * 테마

  2. [카드 게임 템플릿][card-template]에는 베이스 템플릿의 모든 내용과 다음이 포함되어 있습니다.

     * 드래그 앤 드롭
     * 게임 상태 관리
     * 멀티플레이어 통합 후크

  3. 오픈 소스 게임 엔진인 Flame과 협력하여 만든 [무한 러너 템플릿][runner-template]에는 다음이 구현되어 있습니다.

     * FlameGame 베이스 템플릿
     * 플레이어 조종(steering)
     * 충돌 감지
     * Parallax 효과
     * 스폰
     * 다양한 시각 효과

  4. SuperDash라는 무한 러너 템플릿을 기반으로 구축된 샘플 게임. 
     * iOS, Android, 또는 [웹][web]에서 게임을 플레이하거나, 
     * [오픈 소스 코드 저장소 보기][view the open source code repo], 
     * 또는 [6주 만에 게임이 만들어진 과정][read how the game was created in 6 weeks]을 읽어보세요.

* 필요한 서비스를 통합하기 위한 개발자 가이드.
* [Flame Discord][game-discord] 채널로의 링크.
  Discord 계정이 있다면, 이 [다이렉트 링크][discord-direct]를 사용하세요.

포함된 게임 템플릿과 쿡북 레시피는 개발을 가속화하기 위한 특정 선택을 합니다. 
여기에는 `provider`, `google_mobile_ads`, `in_app_purchase`, `audioplayers`, `crashlytics`, `games_services`와 같은 특정 패키지가 포함됩니다. 
다른 패키지를 선호하는 경우, 코드를 변경하여 사용할 수 있습니다.

Flutter 팀은 수익 창출이 향후 고려 사항이 될 수 있음을 알고 있습니다. 
광고 및 앱 내 구매를 위한 쿡북 레시피가 추가되었습니다.

[게임][Games] 페이지에서 설명한 대로, [클라우드, Firebase][Cloud, Firebase], [광고][Ads]와 같은 
Google 서비스를 게임에 통합하면 최대 900달러의 혜택을 활용할 수 있습니다.

:::important
Firebase 서비스에 대한 크레딧을 사용하려면, Firebase와 GCP 계정을 연결해야 하며, 
가입 시 비즈니스 이메일을 인증하여, 일반 $300 크레딧에 추가로 $100을 획득해야 합니다. 
광고 혜택을 받으려면, [해당 지역의 적격 여부를 확인][check your region's eligibility]하세요.
:::

## 시작하기 {:#get-started}

준비되셨나요? 시작해봅시다:

1. 아직 하지 않았다면, [Flutter 설치][install Flutter].
1. [게임 리포지토리 복제][game-repo].
1. 만들고 싶은 첫 번째 게임 타입의 `README` 파일을 검토합니다.

   * [기본 게임][basic-template-readme]
   * [카드 게임][card-template-readme]
   * [러너 게임][runner-template-readme]

2. [Discord의 Flame 커뮤니티에 가입][game-discord]
   (이미 Discord 계정이 있는 경우, [다이렉트 링크][discord-direct]를 사용하세요)
1. 코드랩과 쿡북 레시피를 검토합니다.

   * {{recipe-icon}} Cloud Firestore로 [멀티플레이어 게임][multiplayer-recipe]을 빌드하세요.
   * {{codelab}} Flutter로 [워드 퍼즐][word puzzle]을 빌드하세요.—**신규**
   * {{codelab}} Flutter와 Flame으로 [2D 물리 게임][2D physics game]을 빌드하세요.—**신규**
   * {{codelab}} SoLoud로 Flutter 게임에 [사운드와 음악][Add sound and music]을 추가하세요.—**신규**
   * {{recipe-icon}} [리더보드와 업적][leaderboard-recipe]로 게임을 더욱 매력적으로 만드세요.
   * {{recipe-icon}} [게임 내 광고][ads-recipe] 및 {{codelab}} [앱 내 구매][iap-recipe]로 게임을 수익화하세요.
   * {{recipe-icon}} [Firebase 인증][firebase-auth]로 게임에 사용자 인증 흐름을 추가하세요.
   * {{recipe-icon}} [Firebase Crashlytics][firebase-crashlytics]를 사용하여, 
     게임 내 충돌 및 오류에 대한 분석을 수집합니다.

1. 필요에 따라 AdMob, Firebase, Cloud에 계정을 설정합니다.
2. 게임을 작성하세요!
3. Google Play와 Apple 스토어에 모두 배포합니다.

[Add sound and music]: {{site.codelabs}}/codelabs/flutter-codelab-soloud
[2D physics game]: {{site.codelabs}}/codelabs/flutter-flame-forge2d
[word puzzle]: {{site.codelabs}}/codelabs/flutter-word-puzzle

## 예제 게임 {:#example-games}

Google I/O 2022에서, Flutter 팀과 Very Good Ventures는 모두 새로운 게임을 만들었습니다.

* VGV는 Flame 엔진을 사용하여 [I/O Pinball 게임][pinball-game]을 만들었습니다. 
  * 이 게임에 대해 알아보려면, 
    * Medium에서 [Flutter와 Firebase가 지원하는 I/O Pinball][I/O Pinball Powered by Flutter and Firebase]를 확인하고, 
    * 브라우저에서 [게임 플레이][pinball-game]를 확인하세요.
* Flutter 팀은 가상 [CCG]인 [I/O Flip][flip-game]을 만들었습니다. 
  * I/O Flip에 대해 자세히 알아보려면, 
    * Google Developers 블로그에서 [제작 방법: I/O FLIP은 생성 AI로 클래식 카드 게임에 새로운 변화를 더합니다.][flip-blog]를 확인하고, 
    * 브라우저에서 [게임 플레이][flip-game]를 확인하세요.

## 다른 리소스 {:#other-resources}

이러한 게임 템플릿을 넘어서 더 많은 것을 배우고 싶다면, 
커뮤니티에서 추천하는 다른 리소스를 조사해 보세요.

{% assign pkg-icon = '<span class="material-symbols">package_2</span>' %}
{% assign doc-icon = '<span class="material-symbols">quick_reference_all</span>' %}
{% assign codelab = '<span class="material-symbols">science</span>' %}
{% assign engine = '<span class="material-symbols">manufacturing</span>' %}
{% assign tool-icon = '<span class="material-symbols">handyman</span>' %}
{% assign recipe-icon = '<span class="material-symbols">book_5</span>' %}
{% assign assets-icon = '<span class="material-symbols">photo_album</span>' %}
{% assign api-icon = '<span class="material-symbols">api</span>' %}

:::secondary
{{pkg-icon}} Flutter 패키지<br>
{{api-icon}} API 문서<br>
{{codelab}} 코드랩 <br>
{{recipe-icon}} 쿡북 레시피<br>
{{tool-icon}} 데스크탑 어플리케이션<br>
{{assets-icon}} 게임 assets<br>
{{doc-icon}} 가이드<br>
:::

<table class="table table-striped">
<tr>
<th>특징</th>
<th>리소스</th>
</tr>

<tr>
<td>애니메이션 및 스프라이트(sprites)</td>
<td>

{{recipe-icon}} [특수 효과][Special effects]<br>
{{tool-icon}} [Spriter Pro][Spriter Pro]<br>
{{pkg-icon}} [rive][]<br>
{{pkg-icon}} [spriteWidget][]

</td>
</tr>

<tr>
<td>앱 리뷰</td>
<td>

{{pkg-icon}} [app_review][]

</td>
</tr>

<tr>
<td>오디오</td>
<td>

{{pkg-icon}} [audioplayers][]<br>
{{pkg-icon}} [flutter_soloud][]—**NEW**<br>
{{codelab}}  [SoLoud로 Flutter 게임에 사운드와 음악을 추가하세요][Add sound and music to your Flutter game with SoLoud]—**NEW**

</td>
</tr>

<tr>
<td>인증</td>
<td>

{{codelab}} [Firebase를 사용한 사용자 인증][firebase-auth]

</td>
</tr>

<tr>
<td>클라우드 서비스</td>
<td>

{{codelab}} [Flutter 게임에 Firebase 추가][Add Firebase to your Flutter game]

</td>
</tr>

<tr>
<td>디버깅</td>
<td>

{{doc-icon}} [Firebase Crashlytics 개요][firebase-crashlytics]<br>
{{pkg-icon}} [firebase_crashlytics][]

</td>
</tr>

<tr>
<td>드라이버</td>
<td>

{{pkg-icon}} [win32_gamepad][]

</td>
</tr>

<tr>
<td>게임 assets<br>및 asset 툴</td>
<td>

{{assets-icon}} [CraftPix][]<br>
{{assets-icon}} [Game Developer Studio][]<br>
{{tool-icon}} [GIMP][]

</td>
</tr>

<tr>
<td>게임 엔진</td>
<td>

{{pkg-icon}} [Flame][flame-pkg]<br>
{{pkg-icon}} [Bonfire][bonfire-pkg]<br>
{{pkg-icon}} [forge2d][]

</td>
</tr>

<tr>
<td>게임 특징</td>
<td>

{{recipe-icon}} [게임에 업적과 리더보드 추가][leaderboard-recipe]<br>
{{recipe-icon}} [게임에 멀티플레이어 지원 추가][multiplayer-recipe]

</td>
</tr>

<tr>
<td>게임 서비스 통합</td>
<td>

{{pkg-icon}} [games_services][game-svc-pkg]

</td>
</tr>

<tr>
<td>레거시 코드</td>
<td>

{{codelab}} [Flutter 플러그인에서 Foreign Function Interface 사용][Use the Foreign Function Interface in a Flutter plugin]

</td>
</tr>

<tr>
<td>레벨 에디터</td>
<td>

{{tool-icon}} [Tiled][]

</td>
</tr>

<tr>
<td>수익화</td>
<td>

{{recipe-icon}} [Flutter 게임에 광고를 추가하세요][ads-recipe]<br>
{{codelab}}  [Flutter 앱에 AdMob 광고 추가][Add AdMob ads to a Flutter app]<br>
{{codelab}}  [Flutter 앱에 앱 내 구매 추가][iap-recipe]<br>
{{doc-icon}} [앱을 위한 게임 UX 및 수익 최적화][Gaming UX and Revenue Optimizations for Apps] (PDF)

</td>
</tr>

<tr>
<td>저장</td>
<td>

{{pkg-icon}} [shared_preferences][]<br>
{{pkg-icon}} [sqflite][]<br>
{{pkg-icon}} [cbl_flutter][] (Couchbase Lite)<br>

</td>
</tr>

<tr>
<td>특수 효과</td>
<td>

{{api-icon}} [Paint API][]<br>
{{recipe-icon}} [특수 효과][Special effects]

</td>
</tr>

<tr>
<td>사용자 경험</td>
<td>

{{codelab}} [Flutter에서 차세대 UI 구축][Build next generation UIs in Flutter]<br>
{{doc-icon}} [Flutter 웹 로딩 속도 최적화를 위한 모범 사례][Best practices for optimizing Flutter web loading speed]—**NEW**

</td>
</tr>
</table>

{% assign games-gh = site.github | append: '/flutter/games' -%}

[Ads]: https://ads.google.com/intl/en_us/home/flutter/#!/
[Air Hockey]: https://play.google.com/store/apps/details?id=com.ignacemaes.airhockey
[CCG]: https://en.wikipedia.org/wiki/Collectible_card_game
[Cloud, Firebase]: https://cloud.google.com/free
[Flame game engine]: https://flame-engine.org/
[Games]: {{site.main-url}}/games
[I/O Pinball Powered by Flutter and Firebase]: {{site.medium}}/flutter/di-o-pinball-powered-by-flutter-and-firebase-d22423f3f5d
[install Flutter]: /get-started/install
[Tomb Toad]: https://play.google.com/store/apps/details?id=com.crescentmoongames.tombtoad
[basic-template-readme]: {{games-gh}}/blob/main/templates/basic/README.md
[basic-template]: {{games-gh}}/tree/main/templates/basic
[card-template-readme]: {{games-gh}}/blob/main/templates/card/README.md
[card-template]: {{games-gh}}/tree/main/templates/card
[check your region's eligibility]: https://www.google.com/intl/en/ads/coupons/terms/flutter/
[discord-direct]: https://discord.com/login?redirect_to=%2Fchannels%2F509714518008528896%2F788415774938103829
[firebase_crashlytics]: {{site.pub}}/packages/firebase_crashlytics
[flame-pkg]: {{site.pub}}/packages/flame
[flip-blog]: {{site.google-blog}}/2023/05/how-its-made-io-flip-adds-twist-to.html
[flip-game]: https://flip.withgoogle.com/#/
[game-discord]: https://discord.gg/qUyQFVbV45
[game-repo]: {{games-gh}}
[pinball-game]: https://pinball.flutter.dev/#/
[runner-template-readme]: {{games-gh}}/blob/main/templates/endless_runner/README.md
[runner-template]: {{games-gh}}/tree/main/templates/endless_runner

[Add AdMob ads to a Flutter app]: {{site.codelabs}}/codelabs/admob-ads-in-flutter
[Build next generation UIs in Flutter]: {{site.codelabs}}/codelabs/flutter-next-gen-uis
[firebase-crashlytics]: {{site.firebase}}/docs/crashlytics/get-started?platform=flutter
[ads-recipe]: /cookbook/plugins/google-mobile-ads
[iap-recipe]: {{site.codelabs}}/codelabs/flutter-in-app-purchases#0
[leaderboard-recipe]: /cookbook/games/achievements-leaderboard
[multiplayer-recipe]: /cookbook/games/firestore-multiplayer
[firebase-auth]: {{site.firebase}}/codelabs/firebase-auth-in-flutter-apps#0
[Use the Foreign Function Interface in a Flutter plugin]: {{site.codelabs}}/codelabs/flutter-ffigen
[bonfire-pkg]: {{site.pub}}/packages/bonfire
[CraftPix]: https://craftpix.net
[Add Firebase to your Flutter game]: {{site.firebase}}/docs/flutter/setup
[GIMP]: https://www.gimp.org
[Game Developer Studio]: https://www.gamedeveloperstudio.com
[Gaming UX and Revenue Optimizations for Apps]: {{site.main-url}}/go/games-revenue
[Paint API]: {{site.api}}/flutter/dart-ui/Paint-class.html
[Special effects]: /cookbook/effects
[Spriter Pro]: https://store.steampowered.com/app/332360/Spriter_Pro/
[app_review]: {{site.pub-pkg}}/app_review
[audioplayers]: {{site.pub-pkg}}/audioplayers
[cbl_flutter]: {{site.pub-pkg}}/cbl_flutter
[firebase_crashlytics]: {{site.pub-pkg}}/firebase_crashlytics
[forge2d]: {{site.pub-pkg}}/forge2d
[game-svc-pkg]: {{site.pub-pkg}}/games_services
[rive]: {{site.pub-pkg}}/rive
[shared_preferences]: {{site.pub-pkg}}/shared_preferences
[spriteWidget]: {{site.pub-pkg}}/spritewidget
[sqflite]: {{site.pub-pkg}}/sqflite
[win32_gamepad]: {{site.pub-pkg}}/win32_gamepad
[read how the game was created in 6 weeks]: {{site.flutter-medium}}/how-we-built-the-new-super-dash-demo-in-flutter-and-flame-in-just-six-weeks-9c7aa2a5ad31
[view the open source code repo]: {{site.github}}/flutter/super_dash
[web]: https://superdash.flutter.dev/
[Tiled]: https://www.mapeditor.org/
[flutter_soloud]: {{site.pub-pkg}}/flutter_soloud
[SoLoud codelab]: {{site.codelabs}}/codelabs/flutter-codelab-soloud

## Flutter 3.22용 게임 Toolkit 업데이트 {:#updates}

다음 코드랩과 가이드는 Flutter 3.22 릴리스에 추가되었습니다.

**낮은 대기 시간, 고성능 사운드**
: Flutter 커뮤니티([@Marco Bavagnoli][])와 협력하여, SoLoud 오디오 엔진을 활성화했습니다. 
이 무료 휴대용 엔진은 많은 게임에 필수적인 낮은 대기 시간과 고성능 사운드를 제공합니다. 
시작하는 데 도움이 되도록, 새로운 코드랩 [SoLoud로 Flutter 게임에 사운드와 음악 추가][Add sound and music to your Flutter game with SoLoud]를 확인하세요. 
이 코드랩은 게임에 사운드와 음악을 추가하는 데 전념합니다.

**단어 퍼즐 게임**
: 새로운 코드랩 [Flutter로 단어 퍼즐 만들기][Build a word puzzle with Flutter]를 확인하세요. 
이 코드랩은 단어 퍼즐 게임을 만드는 데 중점을 두고 있습니다. 
이 장르는 Flutter의 UI 기능을 탐색하기에 완벽하며, 
이 코드랩은 Flutter의 백그라운드 처리를 사용하여, 사용자 경험을 손상시키지 않으면서, 
상호 연결된 단어의 방대한 크로스워드 스타일 그리드를 손쉽게 생성하는 방법을 다룹니다.

**Forge 2D 물리 엔진**
: 새로운 Forge2D 코드랩인, [Flutter와 Flame으로 2D 물리 게임 만들기][Build a 2D physics game with Flutter and Flame]는 
[Forge2D][]라는 Box2D와 유사한 2D 물리 시뮬레이션을 사용하여, 
Flutter와 Flame 게임에서 게임 메커니즘을 만드는 방법을 안내합니다.

**Flutter 웹 기반 게임의 로딩 속도 최적화**
: 빠르게 움직이는 웹 기반 게임의 세계에서, 로딩 속도가 느린 게임은 큰 장애물입니다. 
플레이어는 즉각적인 만족을 기대하며, 즉시 로드되지 않는 게임은 금방 포기합니다. 
따라서, [Cheng Lin][]이 작성한 [Flutter 웹 로딩 속도 최적화를 위한 모범 사례][Best practices for optimizing Flutter web loading speed] 가이드를 게시하여, 
Flutter 웹 기반 게임과 앱을 번개처럼 빠른 로딩 속도로 최적화하는 데 도움을 드립니다.

[@Marco Bavagnoli]: {{site.github}}/alnitak
[Add sound and music to your Flutter game with SoLoud]: {{site.codelabs}}/codelabs/flutter-codelab-soloud
[Best practices for optimizing Flutter web loading speed]: {{site.flutter-medium}}/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
[Build a word puzzle with Flutter]: {{site.codelabs}}/codelabs/flutter-word-puzzle
[Build a 2D physics game with Flutter and Flame]: {{site.codelabs}}/codelabs/flutter-flame-forge2d
[Cheng Lin]: {{site.medium}}/@mhclin113_26002
[Forge2D]: {{site.pub-pkgs}}/forge2d

## 다른 새로운 리소스 {:#other-new-resources}

다음 비디오를 확인하세요.

* [Flutter로 멀티플랫폼 게임 빌드][gdc-talk], [게임 개발자 컨퍼런스(GDC)][Game Developer Conference (GDC)] 2024에서 진행된 강연.
* [Flutter와 Flame의 Forge2D로 물리 기반 게임을 빌드하는 방법][forge2d-video], Google I/O 2024에서 진행.

[Game Developer Conference (GDC)]: https://gdconf.com/
[forge2d-video]: {{site.youtube-site}}/watch?v=nsnQJrYHHNQ
[gdc-talk]: {{site.youtube-site}}/watch?v=7mG_sW40tsw
