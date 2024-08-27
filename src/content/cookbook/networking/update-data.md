---
# title: Update data over the internet
title: 인터넷에서 데이터 업데이트
# description: How to use the http package to update data over the internet.
description: http 패키지를 사용하여 인터넷에서 데이터를 업데이트하는 방법.
---

<?code-excerpt path-base="cookbook/networking/update_data/"?>

인터넷을 통한 데이터 업데이트는 대부분 앱에 필요합니다. `http` 패키지가 이를 처리합니다!

이 레시피는 다음 단계를 사용합니다.

  1. `http` 패키지를 추가합니다.
  2. `http` 패키지를 사용하여 인터넷을 통해 데이터를 업데이트합니다.
  3. 응답을 커스텀 Dart 객체로 변환합니다.
  4. 인터넷에서 데이터를 가져옵니다.
  5. 사용자 입력으로부터 존재하는 `title`을 업데이트합니다.
  6. 응답을 업데이트하고 화면에 표시합니다.

## 1. `http` 패키지 추가 {:#1-add-the-http-package}

`http` 패키지를 종속성으로 추가하려면, `flutter pub add`를 실행하세요.

```console
$ flutter pub add http
```

`http` 패키지를 가져옵니다.

<?code-excerpt "lib/main.dart (Http)"?>
```dart
import 'package:http/http.dart' as http;
```

## 2. `http` 패키지를 사용하여 인터넷을 통해 데이터 업데이트 {:#2-updating-data-over-the-internet-using-the-http-package}

이 레시피는 [`http.put()`][] 메서드를 사용하여 앨범 제목을 [JSONPlaceholder][]로 업데이트하는 방법을 다룹니다.

<?code-excerpt "lib/main_step2.dart (updateAlbum)"?>
```dart
Future<http.Response> updateAlbum(String title) {
  return http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
}
```

`http.put()` 메서드는 `Response`를 포함하는 `Future`를 반환합니다.

* [`Future`][]는 async 작업을 처리하기 위한 핵심 Dart 클래스입니다. 
  `Future` 객체는 미래의 어느 시점에 사용할 수 있는 잠재적 값 또는 오류를 나타냅니다.
* `http.Response` 클래스는 성공적인 http 호출에서 수신한 데이터를 포함합니다.
* `updateAlbum()` 메서드는 `title` 인수를 사용하며, 이 인수는 `Album`을 업데이트하기 위해 서버로 전송됩니다.

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

이제, 다음 단계를 따라 `updateAlbum()` 함수를 업데이트하여 `Future<Album>`을 반환합니다.

  1. `dart:convert` 패키지를 사용하여 응답 본문을 JSON `Map`으로 변환합니다.
  2. 서버가 상태 코드 200과 함께 `UPDATED` 응답을 반환하면, 
     `fromJson()` 팩토리 메서드를 사용하여 JSON `Map`을 `Album`으로 변환합니다.
  3. 서버가 상태 코드 200과 함께 `UPDATED` 응답을 반환하지 않으면, 예외를 throw합니다. 
     ("404 Not Found" 서버 응답의 경우에도 예외를 throw합니다. `null`을 반환하지 마세요. 
      아래에 표시된 대로 `snapshot`의 데이터를 검사할 때 중요합니다.)

<?code-excerpt "lib/main.dart (updateAlbum)"?>
```dart
Future<Album> updateAlbum(String title) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 200) {
    // 서버가 200 OK 응답을 반환한 경우, JSON을 구문 분석합니다.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // 서버가 200 OK 응답을 반환하지 않으면, 예외를 발생시킵니다.
    throw Exception('Failed to update album.');
  }
}
```

만세!
이제 앨범 제목을 업데이트하는 기능이 생겼습니다.

## 4. 인터넷에서 데이터를 가져오기 {:#4-get-the-data-from-the-internet}

업데이트하기 전에 인터넷에서 데이터를 가져오세요. 
전체 예제는 [데이터 가져오기][Fetch data] 레시피를 참조하세요.

<?code-excerpt "lib/main.dart (fetchAlbum)"?>
```dart
Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );

  if (response.statusCode == 200) {
    // 서버가 200 OK 응답을 반환한 경우, JSON을 구문 분석합니다.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // 서버가 200 OK 응답을 반환하지 않으면, 예외를 발생시킵니다.
    throw Exception('Failed to load album');
  }
}
```

이상적으로는, 이 메서드를 사용하여 `initState` 중에 인터넷에서 데이터를 가져와서 `_futureAlbum`를 set 합니다.

## 5. 사용자 입력으로부터 존재하는 `title`을 업데이트 {:#5-update-the-existing-title-from-user-input}

`TextField`를 만들어 제목을 입력하고 `ElevatedButton`을 만들어 서버에서 데이터를 업데이트합니다. 
또한 `TextEditingController`를 정의하여 `TextField`에서 사용자 입력을 읽습니다.

`ElevatedButton`을 누르면, `updateAlbum()` 메서드에서 반환된 값으로 `_futureAlbum`이 설정됩니다.

<?code-excerpt "lib/main_step5.dart (Column)"?>
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: 'Enter Title'),
      ),
    ),
    ElevatedButton(
      onPressed: () {
        setState(() {
          _futureAlbum = updateAlbum(_controller.text);
        });
      },
      child: const Text('Update Data'),
    ),
  ],
);
```

**Update Data** 버튼을 누르면, 네트워크 요청이 `TextField`의 데이터를 `PUT` 요청으로 서버에 보냅니다.
`_futureAlbum` 변수는 다음 단계에서 사용됩니다.

## 6. 응답을 업데이트하고 화면에 표시 {:#5-display-the-response-on-screen}

화면에 데이터를 표시하려면, [`FutureBuilder`][] 위젯을 사용합니다. 
`FutureBuilder` 위젯은 Flutter와 함께 제공되며, async 데이터 소스로 작업하기 쉽습니다. 
두 가지 매개변수를 제공해야 합니다.

1. 작업하려는 `Future`. 
   * 이 경우 `updateAlbum()` 함수에서 반환된 future입니다.
2. `builder` 함수
   * `Future`의 상태(loading, success 또는 error)에 따라 Flutter에 렌더링할 내용을 알려주는 함수입니다.

`snapshot.hasData`는 스냅샷에 null이 아닌 데이터 값이 포함된 경우에만 `true`를 반환합니다. 
이것이 `updateAlbum` 함수가 "404 Not Found" 서버 응답의 경우에도 예외를 throw해야 하는 이유입니다. 
`updateAlbum`이 `null`을 반환하면 `CircularProgressIndicator`가 무기한으로 표시됩니다.

<?code-excerpt "lib/main_step5.dart (FutureBuilder)"?>
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
);
```

## 완성된 예제 {:#complete-example}

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );

  if (response.statusCode == 200) {
    // 서버가 200 OK 응답을 반환한 경우, JSON을 구문 분석합니다.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // 서버가 200 OK 응답을 반환하지 않으면, 예외를 발생시킵니다.
    throw Exception('Failed to load album');
  }
}

Future<Album> updateAlbum(String title) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 200) {
    // 서버가 200 OK 응답을 반환한 경우, JSON을 구문 분석합니다.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // 서버가 200 OK 응답을 반환하지 않으면, 예외를 발생시킵니다.
    throw Exception('Failed to update album.');
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
  late Future<Album> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Update Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data!.title),
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter Title',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _futureAlbum = updateAlbum(_controller.text);
                          });
                        },
                        child: const Text('Update Data'),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
```

[ConnectionState]: {{site.api}}/flutter/widgets/ConnectionState-class.html
[`didChangeDependencies()`]: {{site.api}}/flutter/widgets/State/didChangeDependencies.html
[Fetch data]: /cookbook/networking/fetch-data
[`Future`]: {{site.api}}/flutter/dart-async/Future-class.html
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[`http`]: {{site.pub-pkg}}/http
[`http.put()`]: {{site.pub-api}}/http/latest/http/put.html
[`http` package]: {{site.pub}}/packages/http/install
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Introduction to unit testing]: /cookbook/testing/unit/introduction
[`initState()`]: {{site.api}}/flutter/widgets/State/initState.html
[JSONPlaceholder]: https://jsonplaceholder.typicode.com/
[JSON and serialization]: /data-and-backend/serialization/json
[Mock dependencies using Mockito]: /cookbook/testing/unit/mocking
[pattern matching]: {{site.dart-site}}/language/patterns
[`State`]: {{site.api}}/flutter/widgets/State-class.html
