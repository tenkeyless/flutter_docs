---
# title: Parse JSON in the background
title: 백그라운드에서 JSON 구문 분석하기
# description: How to perform a task in the background.
description: 백그라운드에서 작업을 수행하는 방법.
---

<?code-excerpt path-base="cookbook/networking/background_parsing/"?>

기본적으로, Dart 앱은 모든 작업을 단일 스레드에서 수행합니다. 
많은 경우, 이 모델은 코딩을 간소화하고 충분히 빠르기 때문에, 
앱 성능이 저하되거나 종종 "jank"라고 불리는 끊기는 애니메이션이 발생하지 않습니다.

그러나, 매우 큰 JSON 문서를 구문 분석하는 것과 같이, 비용이 많이 드는 계산을 수행해야 할 수도 있습니다. 
이 작업에 16밀리초 이상 걸리면, 사용자가 jank를 경험하게 됩니다.

jank를 방지하려면, 이와 같은 비용이 많이 드는 계산을 백그라운드에서 수행해야 합니다. 
Android에서는, 다른 스레드에서 작업을 예약하는 것을 의미합니다. 
Flutter에서는, 별도의 [Isolate][]를 사용할 수 있습니다. 
이 레시피는 다음 단계를 사용합니다.

  1. `http` 패키지를 추가합니다.
  2. `http` 패키지를 사용하여 네트워크 요청을 합니다.
  3. 응답을 사진 리스트로 변환합니다.
  4. 이 작업을 별도의 isolate으로 이동합니다.

## 1. `http` 패키지 추가 {:#1-add-the-http-package}

먼저, 프로젝트에 [`http`][] 패키지를 추가합니다. 
`http` 패키지는, JSON 엔드포인트에서 데이터를 가져오는 것과 같은, 네트워크 요청을 수행하기 쉽게 해줍니다.

`http` 패키지를 종속성으로 추가하려면, `flutter pub add`를 실행합니다.

```console
$ flutter pub add http
```

## 2. 네트워크 요청하기 {:#2-make-a-network-request}

이 예제에서는, [JSONPlaceholder REST API][]에서 [`http.get()`][] 메서드를 사용하여, 
5000개의 사진 객체 리스트가 포함된 대용량 JSON 문서를 가져오는 방법을 다룹니다.

<?code-excerpt "lib/main_step2.dart (fetchPhotos)"?>
```dart
Future<http.Response> fetchPhotos(http.Client client) async {
  return client.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
}
```

:::note
이 예에서 함수에 `http.Client`를 제공하고 있습니다.

이렇게 하면 함수를 다른 환경에서 테스트하고 사용하기가 더 쉬워집니다.
:::

## 3. JSON을 구문 분석하여 사진 리스트로 변환하기 {:#3-parse-and-convert-the-json-into-a-list-of-photos}

다음으로, [인터넷에서 데이터 가져오기][Fetch data from the internet] 레시피의 안내에 따라, 
`http.Response`를 Dart 객체 리스트로 변환합니다. 이렇게 하면 데이터 작업이 더 쉬워집니다.

### `Photo` 클래스 생성 {:#create-a-photo-class}

먼저, 사진에 대한 데이터를 포함하는 `Photo` 클래스를 만듭니다. 
`fromJson()` 팩토리 메서드를 포함하여, JSON 객체로 시작하는 `Photo`를 쉽게 만들 수 있도록 합니다.

<?code-excerpt "lib/main_step3.dart (Photo)"?>
```dart
class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}
```

### 응답을 사진 리스트로 변환 {:#convert-the-response-into-a-list-of-photos}

이제, 다음 지침을 사용하여 `fetchPhotos()` 함수를 업데이트하여, `Future<List<Photo>>`를 반환하도록 합니다.

  1. 응답 본문을 `List<Photo>`로 변환하는 `parsePhotos()` 함수를 만듭니다.
  2. `fetchPhotos()` 함수에서 `parsePhotos()` 함수를 사용합니다.

<?code-excerpt "lib/main_step3.dart (parsePhotos)"?>
```dart
// 응답 본문을 List<Photo>로 변환하는 함수입니다.
List<Photo> parsePhotos(String responseBody) {
  final parsed =
      (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  // parsePhotos를 메인 isolate 에서 동기적으로 실행합니다.
  return parsePhotos(response.body);
}
```

## 4. 이 작업을 별도의 isolate으로 이동 {:#4-move-this-work-to-a-separate-isolate}

느린 기기에서 `fetchPhotos()` 함수를 실행하면, JSON을 구문 분석하고 변환하는 동안 앱이 잠시 정지되는 것을 알 수 있습니다. 
이것이 jank이며, 이를 제거해야 합니다.

Flutter에서 제공하는 [`compute()`][] 함수를 사용하여, 
구문 분석 및 변환을 백그라운드 isolate로 이동하여, jank를 제거할 수 있습니다. 
`compute()` 함수는 백그라운드 isolate에서 비용이 많이 드는 함수를 실행하고 결과를 반환합니다. 
이 경우, 백그라운드에서 `parsePhotos()` 함수를 실행하세요.

<?code-excerpt "lib/main.dart (fetchPhotos)"?>
```dart
Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  // compute 함수를 사용하여, parsePhotos를 별도의 isolate에서 실행합니다. 
  return compute(parsePhotos, response.body);
}
```

## isolates 작업에 대한 참고 사항 {:#notes-on-working-with-isolates}

Isolates는 메시지를 주고받아 통신합니다. 
이러한 메시지는 `null`, `num`, `bool`, `double` 또는 `String`과 같은 primitive 값이거나, 
이 예제에서의 `List<Photo>`와 같은 간단한 객체일 수 있습니다.

`Future` 또는 `http.Response`와 같은, 더 복잡한 객체를 isolates 간에 전달하려고 하면, 오류가 발생할 수 있습니다.

대체 솔루션으로, 백그라운드 처리를 위한 [`worker_manager`][] 또는 [`workmanager`][] 패키지를 확인하세요.

[`worker_manager`]:  {{site.pub}}/packages/worker_manager
[`workmanager`]: {{site.pub}}/packages/workmanager

## 완성된 예제 {:#complete-example}

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  // compute 함수를 사용하여, parsePhotos를 별도의 isolate에서 실행합니다. 
  return compute(parsePhotos, response.body);
}

// 응답 본문을 List<Photo>로 변환하는 함수입니다.
List<Photo> parsePhotos(String responseBody) {
  final parsed =
      (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Isolate Demo';

    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Photo>> futurePhotos;

  @override
  void initState() {
    super.initState();
    futurePhotos = fetchPhotos(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Photo>>(
        future: futurePhotos,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return PhotosList(photos: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  const PhotosList({super.key, required this.photos});

  final List<Photo> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Image.network(photos[index].thumbnailUrl);
      },
    );
  }
}
```

![Isolate demo](/assets/images/docs/cookbook/isolate.gif){:.site-mobile-screenshot}

[`compute()`]: {{site.api}}/flutter/foundation/compute.html
[Fetch data from the internet]: /cookbook/networking/fetch-data
[`http`]: {{site.pub-pkg}}/http
[`http.get()`]: {{site.pub-api}}/http/latest/http/get.html
[Isolate]: {{site.api}}/flutter/dart-isolate/Isolate-class.html
[JSONPlaceholder REST API]: https://jsonplaceholder.typicode.com
