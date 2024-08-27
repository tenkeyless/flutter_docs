---
# title: Store key-value data on disk
title: 키-값 데이터를 디스크에 저장
# description: >-
#   Learn how to use the shared_preferences package to store key-value data.
description: >-
  shared_preferences 패키지를 사용하여, 키-값 데이터를 저장하는 방법을 알아보세요.
---

<?code-excerpt path-base="cookbook/persistence/key_value/"?>

저장할 키-값의 비교적 작은 컬렉션이 있는 경우, [`shared_preferences`][] 플러그인을 사용할 수 있습니다.

일반적으로, 각 플랫폼에 데이터를 저장하기 위해 네이티브 플랫폼 통합을 작성해야 합니다. 
다행히도, [`shared_preferences`][] 플러그인을 사용하면 
Flutter가 지원하는 각 플랫폼에서 키-값 데이터를 디스크에 유지할 수 있습니다.

이 레시피는 다음 단계를 사용합니다.

  1. 종속성을 추가합니다.
  2. 데이터를 저장합니다.
  3. 데이터를 읽습니다.
  4. 데이터를 제거합니다.

:::note
자세한 내용을 알아보려면, `shared_preferences` 패키지에 대한 이 짧은 주간 패키지 비디오를 시청하세요.

{% ytEmbed 'sa_U0jffQII', 'shared_preferences | 이번 주의 Flutter 패키지' %}
:::

## 1. 종속성 추가 {:#1-add-the-dependency}

시작하기 전에, [`shared_preferences`][] 패키지를 종속성으로 추가합니다.

`shared_preferences` 패키지를 종속성으로 추가하려면, `flutter pub add`를 실행합니다.

```console
flutter pub add shared_preferences
```

## 2. 데이터 저장 {:#2-save-data}

데이터를 유지하려면, `SharedPreferences` 클래스에서 제공하는 setter 메서드를 사용합니다. 
setter 메서드는, `setInt`, `setBool`, `setString`과 같은, 다양한 primitive 타입에 사용할 수 있습니다.

setter 메서드는 두 가지 작업을 수행합니다. 
먼저, 메모리에서 키-값 쌍을 동기적으로 업데이트합니다. 
그런 다음, 데이터를 디스크에 유지합니다.

<?code-excerpt "lib/partial_excerpts.dart (Step2)"?>
```dart
// 이 앱에 대한 shared preferences을 로드하고 가져옵니다.
final prefs = await SharedPreferences.getInstance();

// 영구 저장소(persistent storage)에 'counter' 키 아래의 카운터 값을 저장합니다.
await prefs.setInt('counter', counter);
```

## 3. 데이터 읽기 {:#3-read-data}

데이터를 읽으려면, `SharedPreferences` 클래스에서 제공하는 적절한 getter 메서드를 사용합니다. 
각 setter에는 해당 getter가 있습니다. 
예를 들어, `getInt`, `getBool`, `getString` 메서드를 사용할 수 있습니다.

<?code-excerpt "lib/partial_excerpts.dart (Step3)"?>
```dart
final prefs = await SharedPreferences.getInstance();

// 영구 저장소에서 카운터 값을 읽어보세요.
// 없으면, null이 반환되므로, 기본값은 0입니다.
final counter = prefs.getInt('counter') ?? 0;
```

저장된 값이 getter 메서드가 예상하는 것과 다른 타입일 경우, getter 메서드는 예외를 발생시킵니다.

## 4. 데이터 제거 {:#4-remove-data}

데이터를 삭제하려면 `remove()` 메서드를 사용합니다.

<?code-excerpt "lib/partial_excerpts.dart (Step4)"?>
```dart
final prefs = await SharedPreferences.getInstance();

// 영구 저장소에서 카운터 키-값 쌍을 제거합니다.
await prefs.remove('counter');
```

## 지원되는 타입 {:#supported-types}

`shared_preferences`에서 제공하는 키-값 저장소는 사용하기 쉽고 편리하지만, 다음과 같은 제한 사항이 있습니다.

* primitive 타입만 사용할 수 있습니다: `int`, `double`, `bool`, `String`, `List<String>`.
* 대량의 데이터를 저장하도록 설계되지 않았습니다.
* 앱 재시작 시 데이터가 유지된다는 보장은 없습니다.

## 테스트 지원 {:#testing-support}

`shared_preferences`를 사용하여 데이터를 유지하는 코드를 테스트하는 것이 좋습니다. 
이를 가능하게 하기 위해, 패키지는 preference 저장소의 인메모리 mock 구현을 제공합니다.

테스트에서 mock ​​구현을 사용하도록 설정하려면, 
테스트 파일의 `setUpAll()` 메서드에서 `setMockInitialValues` static 메서드를 호출합니다. 
초기 값으로 사용할 키-값 쌍의 맵을 전달합니다.

<?code-excerpt "test/prefs_test.dart (setup)"?>
```dart
SharedPreferences.setMockInitialValues(<String, Object>{
  'counter': 2,
});
```

## 완성된 예제 {:#complete-example}

<?code-excerpt "lib/main.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shared preferences demo',
      home: MyHomePage(title: 'Shared preferences demo'),
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
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  /// 시작 시 영구 저장소에서 초기 카운터 값을 로드하거나, 값이 없으면 0으로 대체합니다.
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  /// 클릭 후, 카운터 상태를 증가시키고, 비동기적으로 영구 저장소에 저장합니다.
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times: ',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
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

[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
