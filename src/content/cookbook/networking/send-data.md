---
# title: Send data to the internet
title: 인터넷으로 데이터 보내기
# description: How to use the http package to send data over the internet.
description: How to use the http package to send data over the internet.
---

<?code-excerpt path-base="cookbook/networking/send_data/"?>

인터넷으로 데이터를 보내는 것은 대부분 앱에 필수적입니다. `http` 패키지도 이를 처리합니다.

이 레시피는 다음 단계를 사용합니다.

  1. `http` 패키지를 추가합니다.
  2. `http` 패키지를 사용하여 서버로 데이터를 보냅니다.
  3. 응답을 커스텀 Dart 객체로 변환합니다.
  4. 사용자 입력으로부터 `title`을 가져옵니다.
  5. 응답을 화면에 표시합니다.

## 1. `http` 패키지를 추가 {:#1-add-the-http-package}

`http` 패키지를 종속성으로 추가하려면, `flutter pub add`를 실행하세요.

```console
$ flutter pub add http
```

`http` 패키지를 가져옵니다.

<?code-excerpt "lib/main.dart (Http)"?>
```dart
import 'package:http/http.dart' as http;
```

Android용으로 개발하는 경우, `android/app/src/main`에 있는 `AndroidManifest.xml` 파일의 
manifest 태그 내부에 다음 권한을 추가하세요.

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```


## 2. 서버로 데이터를 보내기 {:#2-sending-data-to-server}

이 레시피는 [`http.post()`][] 메서드를 사용하여, 
앨범 제목을 [JSONPlaceholder][]로 보내 `Album`을 만드는 방법을 다룹니다.

`jsonEncode`에 액세스하여 데이터를 인코딩하려면 `dart:convert`를 가져옵니다.

<?code-excerpt "lib/create_album.dart (convert-import)"?>
```dart
import 'dart:convert';
```

`http.post()` 메서드를 사용하여 인코딩된 데이터를 전송합니다.

<?code-excerpt "lib/create_album.dart (CreateAlbum)"?>
```dart
Future<http.Response> createAlbum(String title) {
  return http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
}
```

`http.post()` 메서드는 `Response`를 포함하는 `Future`를 반환합니다.

* [`Future`][]는 비동기 작업을 처리하기 위한 코어 Dart 클래스입니다. 
  Future 객체는 미래의 어느 시점에 사용할 수 있는 잠재적 값 또는 오류를 나타냅니다.
* `http.Response` 클래스는 성공적인 http 호출에서 수신한 데이터를 포함합니다.
* `createAlbum()` 메서드는 `Album`을 만들기 위해 서버로 전송되는 인수 `title`을 사용합니다.

## 3. `http.Response`를 커스텀 Dart 객체로 변환 {:#3-convert-the-http-response-to-a-custom-dart-object}

네트워크 요청을 하는 것은 쉽지만, raw `Future<http.Response>`로 작업하는 것은 그다지 편리하지 않습니다. 
삶을 더 편리하게 하려면, `http.Response`를 Dart 객체로 변환하세요.

### 앨범 클래스 생성 {:#create-an-album-class}

먼저, 네트워크 요청의 데이터를 포함하는 `Album` 클래스를 만듭니다. 
여기에는 JSON에서 `Album`을 만드는 팩토리 생성자가 포함됩니다.

[패턴 매칭][pattern matching]으로 JSON을 변환하는 것은 하나의 옵션일 뿐입니다. 
자세한 내용은 [JSON 및 직렬화][JSON and serialization]에 대한 전체 문서를 참조하세요.

<?code-excerpt "lib/main.dart (Album)"?>
```dart
class Album {
  final int id;
  final String title;

  const Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String title,
      } =>
        Album(
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
```

### `http.Response`를 `Album`으로 변환 {:#convert-the-http-response-to-an-album}

다음 단계를 사용하여 `createAlbum()` 함수를 업데이트하여 `Future<Album>`을 반환합니다.

  1. `dart:convert` 패키지를 사용하여 응답 본문을 JSON `Map`으로 변환합니다.
  2. 서버가 상태 코드 201과 함께 `CREATED` 응답을 반환하면, 
     `fromJson()` 팩토리 메서드를 사용하여 JSON `Map`을 `Album`으로 변환합니다.
  3. 서버가 상태 코드 201과 함께 `CREATED` 응답을 반환하지 않으면, 예외를 throw합니다. 
     ("404 Not Found" 서버 응답의 경우에도 예외를 throw합니다. `null`을 반환하지 마세요. 
      아래에 표시된 대로, `snapshot`의 데이터를 검사할 때 중요합니다.)

<?code-excerpt "lib/main.dart (createAlbum)"?>
```dart
Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 201) {
    // 서버가 201 CREATED 응답을 반환한 경우, JSON을 구문 분석합니다. 
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // 서버가 201 CREATED 응답을 반환하지 않으면, 예외를 발생시킵니다.
    throw Exception('Failed to create album.');
  }
}
```

만세!
이제 제목을 서버로 보내 앨범을 만드는 기능이 생겼습니다.

## 4. 사용자 입력으로부터 제목 가져오기 {:#4-get-a-title-from-user-input}

다음으로, 제목을 입력하기 위한 `TextField`와 서버로 데이터를 전송하기 위한 `ElevatedButton`을 만듭니다. 
또한 `TextEditingController`를 정의하여 `TextField`에서 사용자 입력을 읽습니다.

`ElevatedButton`을 누르면, `_futureAlbum`이 `createAlbum()` 메서드에서 반환된 값으로 설정됩니다.

<?code-excerpt "lib/main.dart (Column)" replace="/^return //g;/^\);$/)/g"?>
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    TextField(
      controller: _controller,
      decoration: const InputDecoration(hintText: 'Enter Title'),
    ),
    ElevatedButton(
      onPressed: () {
        setState(() {
          _futureAlbum = createAlbum(_controller.text);
        });
      },
      child: const Text('Create Data'),
    ),
  ],
)
```

**Create Data** 버튼을 누르면, 네트워크 요청을 합니다. 
그러면, `TextField`의 데이터가 `POST` 요청으로 서버에 전송됩니다. 
Future인 `_futureAlbum`은 다음 단계에서 사용됩니다.

## 5. 응답을 화면에 표시하기 {:#5-display-the-response-on-screen}

화면에 데이터를 표시하려면, [`FutureBuilder`][] 위젯을 사용합니다. 
`FutureBuilder` 위젯은 Flutter와 함께 제공되며 비동기 데이터 소스로 작업하기 쉽습니다. 
두 가지 매개변수를 제공해야 합니다.

  1. 작업하려는 `Future`. 
     * 이 경우 `createAlbum()` 함수에서 반환된 future입니다.
  2. `builder` 함수.
     * `Future`의 상태(loading, success 또는 error)에 따라 
       Flutter에 렌더링할 내용을 알려주는 함수입니다.

`snapshot.hasData`는 스냅샷에 null이 아닌 데이터 값이 포함된 경우에만 `true`를 반환합니다. 
이것이 `createAlbum()` 함수가 "404 Not Found" 서버 응답의 경우에도 예외를 throw해야 하는 이유입니다. 
`createAlbum()`가 `null`을 반환하면 `CircularProgressIndicator`가 무기한 표시됩니다.

<?code-excerpt "lib/main.dart (FutureBuilder)" replace="/^return //g;/^\);$/)/g"?>
```dart
FutureBuilder<Album>(
  future: _futureAlbum,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text(snapshot.data!.title);
    } else if (snapshot.hasError) {
      return Text('${snapshot.error}');
    }

    return const CircularProgressIndicator();
  },
)
```

## 완성된 예제 {:#complete-example}

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 201) {
    // 서버가 201 CREATED 응답을 반환한 경우, JSON을 구문 분석합니다. 
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // 서버가 201 CREATED 응답을 반환하지 않으면, 예외를 발생시킵니다.
    throw Exception('Failed to create album.');
  }
}

class Album {
  final int id;
  final String title;

  const Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String title,
      } =>
        Album(
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  Future<Album>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Title'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum = createAlbum(_controller.text);
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
```

[ConnectionState]: {{site.api}}/flutter/widgets/ConnectionState-class.html
[`didChangeDependencies()`]: {{site.api}}/flutter/widgets/State/didChangeDependencies.html
[Fetch Data]: /cookbook/networking/fetch-data
[`Future`]: {{site.api}}/flutter/dart-async/Future-class.html
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[`http`]: {{site.pub-pkg}}/http
[`http.post()`]: {{site.pub-api}}/http/latest/http/post.html
[`http` package]: {{site.pub-pkg}}/http/install
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Introduction to unit testing]: /cookbook/testing/unit/introduction
[`initState()`]: {{site.api}}/flutter/widgets/State/initState.html
[JSONPlaceholder]: https://jsonplaceholder.typicode.com/
[JSON and serialization]: /data-and-backend/serialization/json
[Mock dependencies using Mockito]: /cookbook/testing/unit/mocking
[pattern matching]: {{site.dart-site}}/language/patterns
[`State`]: {{site.api}}/flutter/widgets/State-class.html
