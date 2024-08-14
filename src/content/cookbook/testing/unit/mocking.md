---
# title: Mock dependencies using Mockito
title: Mockito를 사용하여 종속성 Mock
# description: >
#   Use the Mockito package to mimic the behavior of services for testing.
description: >
  테스트를 위해 서비스의 동작을 모방(mimic)하려면 Mockito 패키지를 사용합니다.
# short-title: Mocking
short-title: Mocking
---

<?code-excerpt path-base="cookbook/testing/unit/mocking"?>

때때로, 유닛 테스트는 라이브 웹 서비스나 데이터베이스에서 데이터를 가져오는 클래스에 의존할 수 있습니다. 
이는 몇 가지 이유로 불편합니다.

  * 라이브 서비스나 데이터베이스를 호출하면 테스트 실행이 느려집니다.
  * 웹 서비스나 데이터베이스가 예상치 못한 결과를 반환하면, 통과 테스트가 실패하기 시작할 수 있습니다. 
    이를 "불안정한 테스트(flaky test)"라고 합니다.
  * 라이브 웹 서비스나 데이터베이스를 사용하여, 모든 가능한 성공 및 실패 시나리오를 테스트하는 것은 어렵습니다.

따라서, 라이브 웹 서비스나 데이터베이스에 의존하는 대신 이러한 종속성을 "mock(모의)"할 수 있습니다. 
mock을 사용하면 라이브 웹 서비스나 데이터베이스를 에뮬레이션하고, 상황에 따라 특정 결과를 반환할 수 있습니다.

일반적으로, 클래스의 대체 구현을 만들어 종속성을 mock 할 수 있습니다. 
이러한 대체 구현을 직접 작성하거나, [Mockito 패키지][Mockito package]를 단축키로 사용하세요.

이 레시피는 다음 단계를 사용하여 Mockito 패키지로 mock 하는 기본 사항을 보여줍니다.

  1. 패키지 종속성을 추가합니다.
  2. 테스트할 함수를 만듭니다.
  3. mock `http.Client`를 사용하여 테스트 파일을 만듭니다.
  4. 각 조건에 대한 테스트를 작성합니다.
  5. 테스트를 실행합니다.

자세한 내용은 [Mockito 패키지][Mockito package] 문서를 참조하세요.

## 1. 패키지 종속성 추가 {:#1-add-the-package-dependencies}

`mockito` 패키지를 사용하려면, 
`dev_dependencies` 섹션에 `flutter_test` 종속성과 함께 `pubspec.yaml` 파일에 추가하세요.

이 예제에서는 `http` 패키지도 사용하므로, `dependencies` 섹션에서 해당 종속성을 정의하세요.

`mockito: 5.0.0`은 코드 생성 덕분에 Dart의 null 안전성을 지원합니다. 
필요한 코드 생성을 실행하려면, `dev_dependencies` 섹션에 `build_runner` 종속성을 추가하세요.

종속성을 추가하려면, `flutter pub add`를 실행하세요.

```console
$ flutter pub add http dev:mockito dev:build_runner
```

## 2. 테스트할 함수 만들기 {:#2-create-a-function-to-test}

이 예에서는, [인터넷에서 데이터 가져오기][Fetch data from the internet] 레시피의 
`fetchAlbum` 함수를 유닛 테스트합니다. 
이 함수를 테스트하려면, 두 가지 변경을 합니다.

  1. 함수에 `http.Client`를 제공합니다. 
     * 이렇게 하면 상황에 따라 올바른 `http.Client`를 제공할 수 있습니다. 
       * Flutter 및 서버 사이드 프로젝트의 경우, `http.IOClient`를 제공합니다. 
       * 브라우저 앱의 경우, `http.BrowserClient`를 제공합니다. 
       * 테스트의 경우, mock `http.Client`를 제공합니다.
  2. mock하기 어려운 static `http.get()` 메서드 대신, 제공된 `client`를 사용하여 인터넷에서 데이터를 가져옵니다.

이제 함수는 다음과 같아야 합니다.

<?code-excerpt "lib/main.dart (fetchAlbum)"?>
```dart
Future<Album> fetchAlbum(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // 서버가 200 OK 응답을 반환한 경우, JSON을 구문 분석합니다.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // 서버가 200 OK 응답을 반환하지 않으면, 예외를 발생시킵니다.
    throw Exception('Failed to load album');
  }
}
```

앱 코드에서, `fetchAlbum(http.Client())`를 사용하여 
`fetchAlbum` 메서드에 `http.Client`를 직접 제공할 수 있습니다. 
`http.Client()`는 기본 `http.Client`를 생성합니다.

## 3. mock `http.Client`를 사용하여 테스트 파일 만들기 {:#3-create-a-test-file-with-a-mock-http-client}

다음으로, 테스트 파일을 만듭니다.

[유닛 테스트 소개][Introduction to unit testing] 레시피의 조언을 따라, 
루트 `test` 폴더에 `fetch_album_test.dart`라는 파일을 만듭니다.

`mockito`를 사용하여 `MockClient` 클래스를 생성하기 위해, 
메인 함수에 어노테이션 `@GenerateMocks([http.Client])`를 추가합니다.

생성된 `MockClient` 클래스는 `http.Client` 클래스를 구현합니다. 
이를 통해 `MockClient`를 `fetchAlbum` 함수에 전달하고, 각 테스트에서 다른 http 응답을 반환할 수 있습니다.

생성된 mock은 `fetch_album_test.mocks.dart`에 위치합니다. 
이 파일을 import해서 사용합니다.

<?code-excerpt "test/fetch_album_test.dart (mockClient)" plaster="none"?>
```dart
import 'package:http/http.dart' as http;
import 'package:mocking/main.dart';
import 'package:mockito/annotations.dart';

// Mockito 패키지를 사용하여 MockClient를 생성합니다.
// 각 테스트에서 이 클래스의 새 인스턴스를 만듭니다.
@GenerateMocks([http.Client])
void main() {
}
```

다음으로, 다음 명령을 실행하여 mock을 생성합니다.

```console
$ dart run build_runner build
```

## 4. 각 조건에 대한 테스트 작성 {:#4-write-a-test-for-each-condition}

`fetchAlbum()` 함수는 두 가지 중 하나를 수행합니다.

  1. http 호출이 성공하면 `Album`을 반환합니다.
  2. http 호출이 실패하면 `Exception`을 throw합니다.

따라서, 이 두 가지 조건을 테스트하고 싶습니다. 
`MockClient` 클래스를 사용하여 성공 테스트에 대한 "Ok" 응답과 실패 테스트에 대한 오류 응답을 반환합니다. 
Mockito에서 제공하는 `when()` 함수를 사용하여 이러한 조건을 테스트합니다.

<?code-excerpt "test/fetch_album_test.dart"?>
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocking/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_album_test.mocks.dart';

// Mockito 패키지를 사용하여 MockClient를 생성합니다.
// 각 테스트에서 이 클래스의 새 인스턴스를 만듭니다.
@GenerateMocks([http.Client])
void main() {
  group('fetchAlbum', () {
    test('returns an Album if the http call completes successfully', () async {
      final client = MockClient();

      // 제공된 http.Client를 호출할 때, 성공적인 응답을 반환하려면 Mockito를 사용합니다.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async =>
              http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      expect(await fetchAlbum(client), isA<Album>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // 제공된 http.Client를 호출할 때, 실패한 응답을 반환하려면 Mockito를 사용합니다.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchAlbum(client), throwsException);
    });
  });
}
```

## 5. 테스트 실행 {:#5-run-the-tests}

이제 테스트를 포함한 `fetchAlbum()` 함수가 준비되었으므로, 테스트를 실행합니다.

```console
$ flutter test test/fetch_album_test.dart
```

[유닛 테스트 소개][Introduction to unit testing] 레시피의 지침에 따라, 
원하는 편집기 내에서 테스트를 실행할 수도 있습니다.

## 완성된 예제 {:#complete-example}

##### lib/main.dart

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum(http.Client client) async {
  final response = await client
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

  const Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(http.Client());
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

##### test/fetch_album_test.dart

<?code-excerpt "test/fetch_album_test.dart"?>
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocking/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_album_test.mocks.dart';

// Mockito 패키지를 사용하여 MockClient를 생성합니다.
// 각 테스트에서 이 클래스의 새 인스턴스를 만듭니다.
@GenerateMocks([http.Client])
void main() {
  group('fetchAlbum', () {
    test('returns an Album if the http call completes successfully', () async {
      final client = MockClient();

      // 제공된 http.Client를 호출할 때, 성공적인 응답을 반환하려면 Mockito를 사용합니다.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async =>
              http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      expect(await fetchAlbum(client), isA<Album>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // 제공된 http.Client를 호출할 때, 실패한 응답을 반환하려면 Mockito를 사용합니다.
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchAlbum(client), throwsException);
    });
  });
}
```

## 요약 {:#summary}

이 예제에서는, Mockito를 사용하여 웹 서비스나 데이터베이스에 의존하는 함수나 클래스를 테스트하는 방법을 배웠습니다. 
이는 Mockito 라이브러리와 mock 개념에 대한 간단한 소개일 뿐입니다. 
자세한 내용은 [Mockito 패키지][Mockito package]에서 제공하는 문서를 참조하세요.

[Fetch data from the internet]: /cookbook/networking/fetch-data
[Introduction to unit testing]: /cookbook/testing/unit/introduction
[Mockito package]: {{site.pub-pkg}}/mockito
