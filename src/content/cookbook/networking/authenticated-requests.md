---
# title: Make authenticated requests
title: 인증된 요청 만들기
# description: How to fetch authorized data from a web service.
description: 웹 서비스에서 인증된 데이터를 가져오는 방법.
---

<?code-excerpt path-base="cookbook/networking/authenticated_requests/"?>

대부분 웹 서비스에서 데이터를 가져오려면, 인증(authorization)을 제공해야 합니다. 
이를 수행하는 방법은 여러 가지가 있지만, 아마도 가장 일반적인 방법은 `Authorization` HTTP 헤더를 사용하는 것입니다.

## 인증(authorization) 헤더 추가 {:#add-authorization-headers}

[`http`][] 패키지는 요청에 헤더를 추가하는 편리한 방법을 제공합니다. 
또는, `dart:io` 라이브러리의 [`HttpHeaders`][] 클래스를 사용하세요.

<?code-excerpt "lib/main.dart (get)"?>
```dart
final response = await http.get(
  Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  // 백엔드로 인증 헤더를 보냅니다.
  headers: {
    HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
  },
);
```

## 완성된 예제 {:#complete-example}

이 예제는 [인터넷에서 데이터 가져오기][Fetching data from the internet] 레시피를 기반으로 합니다.

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    // 백엔드로 인증 헤더를 보냅니다.
    headers: {
      HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
    },
  );
  final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

  return Album.fromJson(responseJson);
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
```


[Fetching data from the internet]: /cookbook/networking/fetch-data
[`http`]: {{site.pub-pkg}}/http
[`HttpHeaders`]: {{site.dart.api}}/stable/dart-io/HttpHeaders-class.html
