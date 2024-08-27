---
# title: Read and write files
title: 파일 읽기 및 쓰기
# description: How to read from and write to files on disk.
description: 디스크에 파일을 읽고 쓰는 방법.
---

<?code-excerpt path-base="cookbook/persistence/reading_writing_files/"?>

어떤 경우에는, 디스크에서 파일을 읽고 써야 합니다. 
예를 들어, 앱 실행 간에 데이터를 유지하거나, 
인터넷에서 데이터를 다운로드하여 나중에 오프라인에서 사용할 수 있도록 저장해야 할 수 있습니다.

모바일 또는 데스크톱 앱에서 파일을 디스크에 저장하려면, 
[`path_provider`][] 플러그인을 [`dart:io`][] 라이브러리와 결합합니다.

이 레시피는 다음 단계를 사용합니다.

  1. 올바른 로컬 경로를 찾습니다.
  2. 파일 위치에 대한 참조를 만듭니다.
  3. 파일에 데이터를 씁니다.
  4. 파일에서 데이터를 읽습니다.

자세한 내용은, `path_provider` 패키지에 대한 이 주의 패키지 비디오를 시청하세요.

{% ytEmbed 'Ci4t-NkOY3I', 'path_provider | 이번 주의 Flutter 패키지' %}

:::note
이 레시피는 현재 웹 앱에서 작동하지 않습니다. 
이 문제에 대한 토론을 팔로우하려면, 
`flutter/flutter` [issue #45296]({{site.repo.flutter}}/issues/45296)를 확인하세요.
:::

## 1. 올바른 로컬 경로 찾기 {:#1-find-the-correct-local-path}

이 예제는 카운터를 표시합니다. 
카운터가 변경되면, 디스크에 데이터를 써서 앱이 로드될 때 다시 읽을 수 있습니다. 
이 데이터는 어디에 저장해야 합니까?

[`path_provider`][] 패키지는 플랫폼에 독립적인 방식으로 
기기의 파일 시스템에서 일반적으로 사용되는 위치에 액세스할 수 있는 방법을 제공합니다. 
이 플러그인은 현재 두 가지 파일 시스템 위치에 대한 액세스를 지원합니다.

*임시 디렉토리*
: 시스템이 언제든지 지울 수 있는 임시 디렉토리(캐시). 
iOS에서는, [`NSCachesDirectory`][]에 해당합니다. 
Android에서는, [`getCacheDir()`][]가 반환하는 값입니다.

*문서 디렉토리*
: 앱에서만 접근할 수 있는 파일을 저장하는 디렉토리입니다. 시스템은 앱이 삭제될 때만 디렉토리를 지웁니다. 
iOS에서는, `NSDocumentDirectory`에 해당합니다. 
Android에서는, `AppData` 디렉토리입니다.

이 예제는 문서 디렉토리에 정보를 저장합니다. 다음과 같이 문서 디렉토리 경로를 찾을 수 있습니다.

<?code-excerpt "lib/main.dart (localPath)"?>
```dart
import 'package:path_provider/path_provider.dart';
  // ···
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
```

## 2. 파일 위치에 대한 참조 만들기 {:#2-create-a-reference-to-the-file-location}

파일을 저장할 위치를 알게 되면, 파일의 전체 위치에 대한 참조를 만듭니다. 
[`dart:io`][] 라이브러리의 [`File`][] 클래스를 사용하여 이를 달성할 수 있습니다.

<?code-excerpt "lib/main.dart (localFile)"?>
```dart
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}
```

## 3. 파일에 데이터 쓰기 {:#3-write-data-to-the-file}

이제 작업할 `File`이 있으니, 이를 사용하여 데이터를 읽고 쓰세요. 
먼저, 파일에 데이터를 씁니다. 
카운터는 정수이지만, `'$counter'` 구문을 사용하여 파일에 문자열로 쓰여집니다.

<?code-excerpt "lib/main.dart (writeCounter)"?>
```dart
Future<File> writeCounter(int counter) async {
  final file = await _localFile;

  // 파일을 쓰세요.
  return file.writeAsString('$counter');
}
```

## 4. 파일에서 데이터 읽기 {:#4-read-data-from-the-file}

이제 디스크에 데이터가 있으니, 읽을 수 있습니다. 다시 한번, `File` 클래스를 사용하세요.

<?code-excerpt "lib/main.dart (readCounter)"?>
```dart
Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // 파일을 읽습니다.
    final contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // 오류가 발생하면 0을 반환합니다.
    return 0;
  }
}
```

## 완성된 예제 {:#complete-example}

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: FlutterDemo(storage: CounterStorage()),
    ),
  );
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // 파일을 읽습니다.
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // 오류가 발생하면, 0을 반환합니다.
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // 파일을 작성합니다.
    return file.writeAsString('$counter');
  }
}

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({super.key, required this.storage});

  final CounterStorage storage;

  @override
  State<FlutterDemo> createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });

    // 변수를 파일에 문자열로 씁니다.
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading and Writing Files'),
      ),
      body: Center(
        child: Text(
          'Button tapped $_counter time${_counter == 1 ? '' : 's'}.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

[`dart:io`]: {{site.api}}/flutter/dart-io/dart-io-library.html
[`File`]: {{site.api}}/flutter/dart-io/File-class.html
[`getCacheDir()`]: {{site.android-dev}}/reference/android/content/Context#getCacheDir()
[`NSCachesDirectory`]: {{site.apple-dev}}/documentation/foundation/nssearchpathdirectory/nscachesdirectory
[`path_provider`]: {{site.pub-pkg}}/path_provider
