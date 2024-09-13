---
# title: Delete data on the internet
title: 인터넷에서 데이터 삭제
# description: How to use the http package to delete data on the internet.
description: http 패키지를 사용하여 인터넷의 데이터를 삭제하는 방법.
---

<?code-excerpt path-base="cookbook/networking/delete_data/"?>

이 레시피는 `http` 패키지를 사용하여 인터넷에서 데이터를 삭제하는 방법을 다룹니다.

이 레시피는 다음 단계를 사용합니다.

  1. `http` 패키지를 추가합니다.
  2. 서버에서 데이터를 삭제합니다.
  3. 화면을 업데이트합니다.

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

Android에 배포하는 경우, `AndroidManifest.xml` 파일을 편집하여 인터넷 권한을 추가합니다.

```xml
<!-- 인터넷에서 데이터를 가져오는 데 필요합니다. -->
<uses-permission android:name="android.permission.INTERNET" />
```

마찬가지로, macOS에 배포하는 경우, 
`macos/Runner/DebugProfile.entitlements` 및 `macos/Runner/Release.entitlements` 
파일을 편집하여 네트워크 클라이언트 자격을 포함시킵니다.

```xml
<!-- 인터넷에서 데이터를 가져오는 데 필요합니다. -->
<key>com.apple.security.network.client</key>
<true/>
```

## 2. 서버에서 데이터 삭제 {:#2-delete-data-on-the-server}

이 레시피는 `http.delete()` 메서드를 사용하여 [JSONPlaceholder][]에서 앨범을 삭제하는 방법을 다룹니다. 
여기에는 삭제하려는 앨범의 `id`가 필요합니다. 
이 예에서는, 이미 알고 있는 것을 사용합니다. (예: `id = 1`)

<?code-excerpt "lib/main_step1.dart (deleteAlbum)"?>
```dart
Future<http.Response> deleteAlbum(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  return response;
}
```

`http.delete()` 메서드는 `Response`를 포함하는 `Future`를 반환합니다.

* [`Future`][]는 async 작업을 처리하기 위한 코어 Dart 클래스입니다. 
  Future 객체는 미래의 어느 시점에 사용할 수 있는 잠재적 값이나 오류를 나타냅니다.
* `http.Response` 클래스는 성공적인 http 호출에서 수신한 데이터를 포함합니다.
* `deleteAlbum()` 메서드는 서버에서 삭제할 데이터를 식별하는 데 필요한 `id` 인수를 사용합니다.

## 3. 화면 업데이트 {:#3-update-the-screen}

데이터가 삭제되었는지 확인하려면, 먼저 `http.get()` 메서드를 사용하여, 
[JSONPlaceholder][]에서 데이터를 가져와서, 화면에 표시합니다. 
(전체 예제는 [데이터 가져오기][Fetch Data] 레시피를 참조하세요.) 
이제 **Delete Data** 버튼이 생겼고, 이 버튼을 누르면, `deleteAlbum()` 메서드가 호출됩니다.

<?code-excerpt "lib/main.dart (Column)" replace="/return //g"?>
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    Text(snapshot.data?.title ?? 'Deleted'),
    ElevatedButton(
      child: const Text('Delete Data'),
      onPressed: () {
        setState(() {
          _futureAlbum =
              deleteAlbum(snapshot.data!.id.toString());
        });
      },
    ),
  ],
);
```

이제 ***Delete Data*** 버튼을 클릭하면, `deleteAlbum()` 메서드가 호출되고, 
전달하는 id는 인터넷에서 검색한 데이터의 id입니다. 
즉, 인터넷에서 가져온 동일한 데이터를 삭제한다는 의미입니다.

### deleteAlbum() 메서드에서 응답 반환 {:#returning-a-response-from-the-deletealbum-method}

삭제 요청이 이루어지면, `deleteAlbum()` 메서드에서 응답을 반환하여, 데이터가 삭제되었음을 화면에 알릴 수 있습니다.

<?code-excerpt "lib/main.dart (deleteAlbum)"?>
```dart
Future<Album> deleteAlbum(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // 서버가 200 OK 응답을 반환했다면, 빈 앨범을 반환하세요. 
    // 삭제한 후에는, 빈 JSON `{}` 응답을 받게 됩니다. `null`을 반환하지 마세요. 
    // 그렇지 않으면, `snapshot.hasData`가 항상 `FutureBuilder`에서 false를 반환합니다.
    return Album.empty();
  } else {
    // 서버가 "200 OK 응답"을 반환하지 않으면, 예외를 발생시킵니다.
    throw Exception('Failed to delete album.');
  }
}
```

`FutureBuilder()`는 이제 응답을 받으면 다시 빌드합니다. 
요청이 성공하면 응답 본문에 데이터가 없으므로, 
`Album.fromJson()` 메서드는 기본값(이 경우 `null`)을 사용하여 `Album` 객체의 인스턴스를 만듭니다. 
이 동작은 원하는 대로 변경할 수 있습니다.

그게 전부입니다!
이제 인터넷에서 데이터를 삭제하는 함수가 생겼습니다.

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

Future<Album> deleteAlbum(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // 서버가 200 OK 응답을 반환했다면, 빈 앨범을 반환하세요. 
    // 삭제한 후에는, 빈 JSON `{}` 응답을 받게 됩니다. `null`을 반환하지 마세요. 
    // 그렇지 않으면, `snapshot.hasData`가 항상 `FutureBuilder`에서 false를 반환합니다.
    return Album.empty();
  } else {
    // 서버가 "200 OK 응답"을 반환하지 않으면, 예외를 발생시킵니다.
    throw Exception('Failed to delete album.');
  }
}

class Album {
  int? id;
  String? title;

  Album({this.id, this.title});

  Album.empty();

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
  late Future<Album> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delete Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Delete Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              // 연결이 완료되면, 응답 데이터나 오류를 확인하세요.
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data?.title ?? 'Deleted'),
                      ElevatedButton(
                        child: const Text('Delete Data'),
                        onPressed: () {
                          setState(() {
                            _futureAlbum =
                                deleteAlbum(snapshot.data!.id.toString());
                          });
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
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

[Fetch Data]: /cookbook/networking/fetch-data
[ConnectionState]: {{site.api}}/flutter/widgets/ConnectionState-class.html
[`didChangeDependencies()`]: {{site.api}}/flutter/widgets/State/didChangeDependencies.html
[`Future`]: {{site.api}}/flutter/dart-async/Future-class.html
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[JSONPlaceholder]: https://jsonplaceholder.typicode.com/
[`http`]: {{site.pub-pkg}}/http
[`http.delete()`]: {{site.pub-api}}/http/latest/http/delete.html
[`http` package]: {{site.pub-pkg}}/http/install
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Introduction to unit testing]: /cookbook/testing/unit/introduction
[`initState()`]: {{site.api}}/flutter/widgets/State/initState.html
[Mock dependencies using Mockito]: /cookbook/testing/unit/mocking
[JSON and serialization]: /data-and-backend/serialization/json
[`State`]: {{site.api}}/flutter/widgets/State-class.html
