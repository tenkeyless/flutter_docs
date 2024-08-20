---
title: Google APIs
# description: How to use Google APIs with Flutter.
description: Flutter와 함께 Google API를 사용하는 방법.
---

<?code-excerpt path-base="googleapis/"?>

[Google API 패키지][Google APIs package]는 Dart 프로젝트에서 사용할 수 있는 수십 개의 Google 서비스를 노출합니다.

이 페이지에서는 Google 인증을 사용하여, 최종 사용자 데이터와 상호 작용하는 API를 사용하는 방법을 설명합니다.

사용자 데이터 API의 예로는 [Calendar][], [Gmail][], [YouTube][], Firebase가 있습니다.

:::note
Flutter 프로젝트에서 직접 사용해야 하는 유일한 API는, Google 인증을 사용하여 사용자 데이터에 액세스하는 API입니다.

[서비스 계정][service accounts]이 필요한 API는, Flutter 애플리케이션에서 **직접 사용해서는 안 됩니다.** 
그렇게 하려면, 애플리케이션의 일부로 배송 서비스 자격 증명(shipping service credentials)이 필요하며, 이는 안전하지 않습니다. 
이러한 API를 사용하려면, 중간 서비스를 만드는 것이 좋습니다.
:::

Firebase에 인증을 명시적으로 추가하려면, [FirebaseUI를 사용하여 Flutter 앱에 사용자 인증 흐름 추가][fb-lab] 코드랩과 [Flutter에서 Firebase 인증 시작하기][fb-auth] 문서를 확인하세요.
 
[fb-lab]: {{site.firebase}}/codelabs/firebase-auth-in-flutter-apps
[Calendar]: {{site.pub-api}}/googleapis/latest/calendar_v3/calendar_v3-library.html
[fb-auth]: {{site.firebase}}/docs/auth/flutter/start
[Gmail]: {{site.pub-api}}/googleapis/latest/gmail_v1/gmail_v1-library.html
[Google APIs package]: {{site.pub-pkg}}/googleapis
[service accounts]: https://cloud.google.com/iam/docs/service-account-overview
[YouTube]: {{site.pub-api}}/googleapis/latest/youtube_v3/youtube_v3-library.html

## 개요 {:#overview}

Google API를 사용하려면, 다음 단계를 따르세요.

1. 원하는 API 선택
1. API 활성화
1. 필요한 범위(scopes)로 사용자 인증
1. 인증된 HTTP 클라이언트 획득
1. 원하는 API 클래스 생성 및 사용

## 1. 원하는 API 선택 {:#1-pick-the-desired-api}

[package:googleapis][]에 대한 문서에는 각 API를 `name_version` 형식으로 별도의 Dart 라이브러리로 나열하고 있습니다. 
[`youtube_v3`][]을 예로 들어 보겠습니다.

각 라이브러리는 여러 타입을 제공할 수 있지만, `Api`로 끝나는 _루트_ 클래스가 하나 있습니다. 
YouTube의 경우 [`YouTubeApi`][]입니다.

`Api` 클래스는 인스턴스화해야 할 클래스일 뿐만 아니라(3단계 참조), API를 사용하는 데 필요한 권한을 나타내는 범위도 노출합니다. 
예를 들어, `YouTubeApi` 클래스의 [Constants 섹션][Constants section]은 사용 가능한 범위를 나열합니다. 
최종 사용자의 YouTube 데이터를 읽을 수 있는 권한(쓰기는 불가)을 요청하려면, 
[`youtubeReadonlyScope`][]로 사용자를 인증합니다.

<?code-excerpt "lib/main.dart (youtube-import)"?>
```dart
/// `YouTubeApi` 클래스를 제공합니다.
import 'package:googleapis/youtube/v3.dart';
```

[Constants section]: {{site.pub-api}}/googleapis/latest/youtube_v3/YouTubeApi-class.html#constants
[package:googleapis]: {{site.pub-api}}/googleapis
[`youtube_v3`]: {{site.pub-api}}/googleapis/latest/youtube_v3/youtube_v3-library.html
[`YouTubeApi`]: {{site.pub-api}}/googleapis/latest/youtube_v3/YouTubeApi-class.html
[`youtubeReadonlyScope`]: {{site.pub-api}}/googleapis/latest/youtube_v3/YouTubeApi/youtubeReadonlyScope-constant.html

## 2. API 활성화 {:#2-enable-the-api}

Google API를 사용하려면, Google 계정과 Google 프로젝트가 있어야 합니다. 
또한 원하는 API를 활성화해야 합니다.

이 예에서는 [YouTube Data API v3][YouTube Data API v3]를 활성화합니다. 
자세한 내용은 [시작하기 지침][getting started instructions]을 참조하세요.

[getting started instructions]: https://cloud.google.com/apis/docs/getting-started
[YouTube Data API v3]: https://console.cloud.google.com/apis/library/youtube.googleapis.com

## 3. 필요한 범위(scopes)로 사용자 인증 {:#3-authenticate-the-user-with-the-required-scopes}

[google_sign_in][gsi-pkg] 패키지를 사용하여, 사용자를 Google ID로 인증합니다. 
지원하려는 각 플랫폼에 대한 로그인을 구성합니다.

<?code-excerpt "lib/main.dart (google-import)"?>
```dart
/// `GoogleSignIn` 클래스를 제공합니다
import 'package:google_sign_in/google_sign_in.dart';
```

[`GoogleSignIn`][] 클래스를 인스턴스화할 때, 이전 섹션에서 설명한 대로 원하는 범위를 제공합니다.

<?code-excerpt "lib/main.dart (init)"?>
```dart
final _googleSignIn = GoogleSignIn(
  scopes: <String>[YouTubeApi.youtubeReadonlyScope],
);
```

[`package:google_sign_in`][gsi-pkg]에서 제공하는 지침에 따라, 사용자가 인증하도록 허용하세요.

인증되면, 인증된 HTTP 클라이언트를 얻어야 합니다.

[gsi-pkg]: {{site.pub-pkg}}/google_sign_in
[`GoogleSignIn`]: {{site.pub-api}}/google_sign_in/latest/google_sign_in/GoogleSignIn-class.html

## 4. 인증된 HTTP 클라이언트 획득 {:#4-obtain-an-authenticated-http-client}

[extension_google_sign_in_as_googleapis_auth][] 패키지는 `GoogleSignIn`에서 [`authenticatedClient`][]를 호출하는 [확장 메서드][extension method]를 제공합니다.

<?code-excerpt "lib/main.dart (auth-import)"?>
```dart
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
```

[`onCurrentUserChanged`][]에 리스너를 추가하고, 이벤트 값이 `null`이 아니면, 인증된 클라이언트를 생성할 수 있습니다.

<?code-excerpt "lib/main.dart (signin-call)"?>
```dart
var httpClient = (await _googleSignIn.authenticatedClient())!;
```

이 [`Client`][] 인스턴스에는 Google API 클래스를 호출할 때 필요한 자격 증명(credentials)이 포함되어 있습니다.

[`authenticatedClient`]: {{site.pub-api}}/extension_google_sign_in_as_googleapis_auth/latest/extension_google_sign_in_as_googleapis_auth/GoogleApisGoogleSignInAuth/authenticatedClient.html
[`Client`]: {{site.pub-api}}/http/latest/http/Client-class.html
[extension_google_sign_in_as_googleapis_auth]: {{site.pub-pkg}}/extension_google_sign_in_as_googleapis_auth
[extension method]: {{site.dart-site}}/guides/language/extension-methods
[`onCurrentUserChanged`]: {{site.pub-api}}/google_sign_in/latest/google_sign_in/GoogleSignIn/onCurrentUserChanged.html

## 5. 원하는 API 클래스 생성 및 사용 {:#5-create-and-use-the-desired-api-class}

API를 사용하여 원하는 API 타입을 만들고 메서드를 호출합니다. 예를 들어:

<?code-excerpt "lib/main.dart (playlist)"?>
```dart
var youTubeApi = YouTubeApi(httpClient);

var favorites = await youTubeApi.playlistItems.list(
  ['snippet'],
  playlistId: 'LL', // Liked List
);
```

## 더 많은 정보 {:#more-information}

다음을 확인해 보세요.

* [`extension_google_sign_in_as_googleapis_auth` 예시][auth-ex]는 이 페이지에 설명된 개념의 작동 구현입니다.

[auth-ex]: {{site.pub-pkg}}/extension_google_sign_in_as_googleapis_auth/example
