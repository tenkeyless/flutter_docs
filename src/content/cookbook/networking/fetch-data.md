---
# title: Fetch data from the internet
title: 인터넷으로부터 데이터 가져오기
# description: How to fetch data over the internet using the http package.
description: http 패키지를 사용하여 인터넷에서 데이터를 가져오는 방법.
---

<?code-excerpt path-base="cookbook/networking/fetch_data/"?>

인터넷에서 데이터를 가져오는 것은 대부분 앱에 필요합니다. 
다행히도, Dart와 Flutter는 이러한 유형의 작업을 위해, `http` 패키지와 같은, 도구를 제공합니다.

:::note
HTTP 요청을 하기 위해 `dart:io` 또는 `dart:html`을 직접 사용하는 것은 피해야 합니다. 
이러한 라이브러리는 플랫폼에 따라 달라지며 단일 구현에 묶여 있습니다.
:::

이 레시피는 다음 단계를 사용합니다.

  1. `http` 패키지를 추가합니다.
  2. `http` 패키지를 사용하여 네트워크 요청을 합니다.
  3. 응답을 커스텀 Dart 객체로 변환합니다.
  4. Flutter로 데이터를 가져와 표시합니다.

## 1. `http` 패키지를 추가 {:#1-add-the-http-package}

[`http`][] 패키지는 인터넷에서 데이터를 가져오는 가장 간단한 방법을 제공합니다.

`http` 패키지를 종속성으로 추가하려면, `flutter pub add`를 실행합니다.

```console
$ flutter pub add http
```

http 패키지를 가져옵니다.

<?code-excerpt "lib/main.dart (Http)"?>
```dart
import 'package:http/http.dart' as http;
```

Android에 배포하는 경우, `AndroidManifest.xml` 파일을 편집하여 인터넷 권한을 추가합니다.

```xml
<!-- 인터넷에서 데이터를 가져오는 데 필요합니다. -->
<uses-permission android:name="android.permission.INTERNET" />
```

마찬가지로, macOS에 배포하는 경우, 
`macos/Runner/DebugProfile.entitlements` 및 `macos/Runner/Release.entitlements` 파일을 편집하여 
네트워크 클라이언트 자격(network client entitlement)을 포함시킵니다.

```xml
<!-- 인터넷에서 데이터를 가져오는 데 필요합니다. -->
<key>com.apple.security.network.client</key>
<true/>
```

## 2. 네트워크 요청하기 {:#2-make-a-network-request}

이 레시피는 [`http.get()`][] 메서드를 사용하여 [JSONPlaceholder][]에서 샘플 앨범을 가져오는 방법을 다룹니다.

<?code-excerpt "lib/main_step1.dart (fetchAlbum)"?>
```dart
Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
}
```

`http.get()` 메서드는 `Response`를 포함하는 `Future`를 반환합니다.

* [`Future`][]는 async 작업을 처리하기 위한 핵심 Dart 클래스입니다. 
  Future 객체는 미래의 어느 시점에 사용 가능할 수 있는 잠재적 값 또는 오류를 나타냅니다.
* `http.Response` 클래스는 성공적인 http 호출에서 수신된 데이터를 포함합니다.

## 3. 응답을 커스텀 Dart 객체로 변환 {:#3-convert-the-response-into-a-custom-dart-object}

네트워크 요청을 하는 것은 쉽지만, raw `Future<http.Response>`로 작업하는 것은 그다지 편리하지 않습니다. 
삶을 더 편리하게 하려면, `http.Response`를 Dart 객체로 변환하세요.

### `Album` 클래스 생성 {:#create-an-album-class}

먼저, 네트워크 요청의 데이터를 포함하는 `Album` 클래스를 만듭니다. 
여기에는 JSON에서 `Album`을 만드는 팩토리 생성자가 포함됩니다.

[패턴 매칭][pattern matching]을 사용하여 JSON을 변환하는 것은 하나의 옵션일 뿐입니다. 
자세한 내용은 [JSON 및 직렬화][JSON and serialization]에 대한 전체 문서를 참조하세요.

<?code-excerpt "lib/main.dart (Album)"?>
```dart
class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
      } =>
        Album(
          userId: userId,
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
```

### `http.Response`를 `Album`으로 변환 {:#convert-the-http-response-to-an-album}

이제, 다음의 단계를 사용하여 `fetchAlbum()` 함수를 업데이트하여 `Future<Album>`을 반환합니다.

  1. `dart:convert` 패키지를 사용하여 응답 본문(response body)을 JSON `Map`으로 변환합니다.
  2. 서버가 상태 코드 200과 함께 OK 응답을 반환하는 경우, 
     `fromJson()` 팩토리 메서드를 사용하여 JSON `Map`을 `Album`으로 변환합니다.
  3. 서버가 상태 코드 200과 함께 OK 응답을 반환하지 않는 경우, 예외를 throw합니다. 
     ("404 Not Found" 서버 응답의 경우에도 예외를 throw합니다. `null`을 반환하지 마세요. 
      아래에 표시된 대로, `snapshot`의 데이터를 검사할 때 중요합니다.)

<?code-excerpt "lib/main.dart (fetchAlbum)"?>
```dart
Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // 서버가 200 OK 응답을 반환한 경우, JSON을 파싱합니다.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // 서버가 200 OK 응답을 반환하지 않으면, 예외를 발생시킵니다.
    throw Exception('Failed to load album');
  }
}
```

만세!
이제 인터넷에서 앨범을 가져오는 기능이 생겼습니다.

## 4. 데이터 읽어오기 {:#4-fetch-the-data}

[`initState()`][] 또는 [`didChangeDependencies()`][] 메서드에서 `fetchAlbum()` 메서드를 호출합니다.

`initState()` 메서드는 정확히 한 번 호출되고, 그 이후로는 다시 호출되지 않습니다. 
[`InheritedWidget`][] 변경에 대한 응답으로 API를 다시 로드하는 옵션을 원하면, 
호출을 `didChangeDependencies()` 메서드에 넣습니다. 
자세한 내용은 [`State`][]를 참조하세요.

<?code-excerpt "lib/main.dart (State)"?>
```dart
class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }
  // ···
}
```

이 Future는 다음 단계에서 사용됩니다.

## 5. 데이터 표시하기 {:#5-display-the-data}

데이터를 화면에 표시하려면, [`FutureBuilder`][] 위젯을 사용합니다. 
`FutureBuilder` 위젯은 Flutter와 함께 제공되며 비동기 데이터 소스로 작업하기 쉽습니다.

두 개의 매개변수를 제공해야 합니다.

  1. 작업하려는 `Future`. 
     * 이 경우, `fetchAlbum()` 함수에서 반환된 future 입니다.
  2. `builder` 함수.
     * `Future`의 상태(loading, success 또는 error)에 따라, Flutter에 렌더링할 내용을 알려주는 함수입니다.

`snapshot.hasData`는 스냅샷에 null이 아닌 데이터 값이 포함된 경우에만 `true`를 반환합니다.

`fetchAlbum`은 null이 아닌 값만 반환할 수 있으므로, 
"404 Not Found" 서버 응답의 경우에도 함수가 예외를 throw해야 합니다. 
예외를 throw하면, `snapshot.hasError`가 `true`로 설정되어 오류 메시지를 표시하는 데 사용할 수 있습니다.

그렇지 않으면, 스피너가 표시됩니다.

<?code-excerpt "lib/main.dart (FutureBuilder)" replace="/^child: //g;/^\),$/)/g"?>
```dart
FutureBuilder<Album>(
  future: futureAlbum,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text(snapshot.data!.title);
    } else if (snapshot.hasError) {
      return Text('${snapshot.error}');
    }

    // 기본적으로, 로딩 스피너가 표시됩니다.
    return const CircularProgressIndicator();
  },
)
```

## initState()에서 fetchAlbum()이 호출되는 이유는 무엇입니까? {:#why-is-fetchalbum-called-in-initstate}

편리하기는 하지만, `build()` 메서드에 API 호출을 넣는 것은 권장하지 않습니다.

Flutter는 뷰에서 무언가를 변경해야 할 때마다 `build()` 메서드를 호출하는데, 이는 놀라울 정도로 자주 발생합니다. `fetchAlbum()` 메서드는, `build()` 내부에 배치하면, 각 재빌드에서 반복적으로 호출되어 앱 속도가 느려집니다.

`fetchAlbum()` 결과를 상태 변수에 저장하면, `Future`가 한 번만 실행되고 이후 재빌드를 위해 캐시됩니다.

## 테스트 {:#testing}

이 기능을 테스트하는 방법에 대한 정보는, 다음 레시피를 참조하세요.

* [유닛 테스트 소개][Introduction to unit testing]
* [Mockito를 사용하여 종속성 Mock][Mock dependencies using Mockito]

## 완성된 예제 {:#complete-example}

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // 서버가 200 OK 응답을 반환한 경우, JSON을 구문 분석합니다.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // 서버가 200 OK 응답을 반환하지 않으면, 예외를 발생시킵니다.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
      } =>
        Album(
          userId: userId,
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // 기본적으로, 로딩 스피너가 표시됩니다.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
```


[`didChangeDependencies()`]: {{site.api}}/flutter/widgets/State/didChangeDependencies.html
[`Future`]: {{site.api}}/flutter/dart-async/Future-class.html
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[JSONPlaceholder]: https://jsonplaceholder.typicode.com/
[`http`]: {{site.pub-pkg}}/http
[`http.get()`]: {{site.pub-api}}/http/latest/http/get.html
[`http` package]: {{site.pub-pkg}}/http/install
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Introduction to unit testing]: /cookbook/testing/unit/introduction
[`initState()`]: {{site.api}}/flutter/widgets/State/initState.html
[Mock dependencies using Mockito]: /cookbook/testing/unit/mocking
[JSON and serialization]: /data-and-backend/serialization/json
[pattern matching]: {{site.dart-site}}/language/patterns
[`State`]: {{site.api}}/flutter/widgets/State-class.html
