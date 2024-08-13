---
# title: Persist data with SQLite
title: SQLite로 데이터 유지
# description: How to use SQLite to store and retrieve data.
description: SQLite를 사용하여 데이터를 저장하고 검색하는 방법.
---

<?code-excerpt path-base="cookbook/persistence/sqlite/"?>

:::note
이 가이드는 [sqflite 패키지][sqflite package]를 사용합니다. 

이 패키지는 macOS, iOS 또는 Android에서 실행되는 앱만 지원합니다.
:::

[sqflite package]: {{site.pub-pkg}}/sqflite

로컬 디바이스에서, 대량의 데이터를 저장하고 쿼리해야 하는 앱을 작성하는 경우, 
로컬 파일이나 키-값 저장소 대신, 데이터베이스를 사용하는 것을 고려하세요. 
일반적으로, 데이터베이스는 다른 로컬 지속성 솔루션에 비해 삽입, 업데이트 및 쿼리가 더 빠릅니다.

Flutter 앱은 pub.dev에서 제공되는 [`sqflite`][] 플러그인을 통해 SQLite 데이터베이스를 활용할 수 있습니다. 
이 레시피는 다양한 개에 대한 데이터를 삽입, 읽기, 업데이트 및 제거하기 위해, `sqflite`를 사용하는 기본 사항을 보여줍니다.

SQLite 및 SQL 문을 처음 사용하는 경우, 
이 레시피를 완료하기 전에 [SQLite 튜토리얼][SQLite Tutorial]을 검토하여 기본 사항을 알아보세요.

이 레시피는 다음 단계를 사용합니다.

  1. 종속성을 추가합니다.
  2. `Dog` 데이터 모델을 정의합니다.
  3. 데이터베이스를 엽니다.
  4. `dogs` 테이블을 만듭니다.
  5. 데이터베이스에 `Dog`를 삽입합니다.
  6. dogs 리스트를 검색합니다.
  7. 데이터베이스에서 `Dog`를 업데이트합니다.
  8. 데이터베이스에서 `Dog`를 삭제합니다.

## 1. 종속성 추가 {:#1-add-the-dependencies}

SQLite 데이터베이스로 작업하려면, `sqflite` 및 `path` 패키지를 가져옵니다.

  * `sqflite` 패키지는 SQLite 데이터베이스와 상호 작용하는 클래스와 함수를 제공합니다.
  * `path` 패키지는 디스크에 데이터베이스를 저장할 위치를 정의하는 함수를 제공합니다.

패키지를 종속성으로 추가하려면, `flutter pub add`를 실행합니다.

```console
$ flutter pub add sqflite path
```

작업할 파일에 패키지를 꼭 가져오세요.

<?code-excerpt "lib/main.dart (imports)"?>
```dart
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
```

## 2. Dog 데이터 모델 정의 {:#2-define-the-dog-data-model}

Dogs에 대한 정보를 저장할 테이블을 만들기 전에, 저장해야 할 데이터를 정의하는 데 잠시 시간을 내세요. 
이 예에서는, 세 가지 데이터를 포함하는 Dog 클래스를 정의합니다. 
각 개의 고유한 `id`, `name`, `age`입니다.

<?code-excerpt "lib/step2.dart"?>
```dart
class Dog {
  final int id;
  final String name;
  final int age;

  const Dog({
    required this.id,
    required this.name,
    required this.age,
  });
}
```

## 3. 데이터베이스 열기 {:#3-open-the-database}

데이터베이스에 데이터를 읽고 쓰기 전에, 데이터베이스에 대한 연결을 엽니다. 여기에는 두 단계가 포함됩니다.

  1. `sqflite` 패키지의 `getDatabasesPath()`를 사용하여 
     (`path` 패키지의 `join` 함수와 결합하여) 데이터베이스 파일에 대한 경로를 정의합니다. 
  2. `sqflite`의 `openDatabase()` 함수로 데이터베이스를 엽니다.

:::note
키워드 `await`를 사용하려면, 코드를 `async` 함수 안에 넣어야 합니다. 
다음 테이블 함수는 모두 `void main() async {}` 안에 넣어야 합니다.
:::

<?code-excerpt "lib/step3.dart (openDatabase)"?>
```dart
// Flutter 업그레이드로 인한 오류를 방지합니다.
// 'package:flutter/widgets.dart'를 import 하는 것이 요구됩니다.
WidgetsFlutterBinding.ensureInitialized();
// 데이터베이스를 열고 참조를 저장합니다.
final database = openDatabase(
  // 데이터베이스 경로를 설정합니다. 
  // 참고: `path` 패키지의 `join` 함수를 사용하는 것이 
  // 각 플랫폼에 대한 경로가 올바르게 구성되도록 하는 가장 좋은 방법입니다.
  join(await getDatabasesPath(), 'doggie_database.db'),
);
```

## 4. `dogs` 테이블 만들기 {:#4-create-the-dogs-table}

다음으로, 다양한 Dogs에 대한 정보를 저장할 테이블을 만듭니다. 
이 예에서는, 저장될 수 있는 데이터를 정의하는 `dogs`라는 테이블을 만듭니다. 
각 `Dog`에는 `id`, `name`, `age`가 포함됩니다. 
따라서, 이것들은 `dogs` 테이블에서 세 개의 열로 표현됩니다.

  1. `id`는 Dart `int`이며, `INTEGER` SQLite 데이터 타입으로 저장됩니다. 
     쿼리 및 업데이트 시간을 개선하기 위해 테이블의 primary 키로 `id`를 사용하는 것도 좋은 방법입니다.
  2. `name`은 Dart `String`이며, `TEXT` SQLite 데이터 타입으로 저장됩니다.
  3. `age`도 Dart `int`이며, `INTEGER` 데이터 타입으로 저장됩니다.

SQLite 데이터베이스에 저장될 수 있는 사용 가능한 데이터 타입에 대한 자세한 내용은 
[공식 SQLite 데이터 타입 문서][official SQLite Datatypes documentation]를 ​​참조하세요.

<?code-excerpt "lib/main.dart (openDatabase)"?>
```dart
final database = openDatabase(
  // 데이터베이스 경로를 설정합니다.
  // 참고: `path` 패키지의 `join` 함수를 사용하는 것이 
  // 각 플랫폼에 대한 경로가 올바르게 구성되도록 하는 가장 좋은 방법입니다.
  join(await getDatabasesPath(), 'doggie_database.db'),
  // 데이터베이스를 처음 생성할 때, dogs를 저장할 테이블을 생성합니다.
  onCreate: (db, version) {
    // 데이터베이스에서 CREATE TABLE 문을 실행합니다.
    return db.execute(
      'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
    );
  },
  // 버전을 설정합니다. 
  // 이것은 onCreate 함수를 실행하고 데이터베이스 업그레이드 및 다운그레이드를 수행하는 경로를 제공합니다.
  version: 1,
);
```

## 5. 데이터베이스에 `Dog` 삽입 {:#5-insert-a-dog-into-the-database}

이제 다양한 개에 대한 정보를 저장하는 데 적합한 테이블이 있는 데이터베이스가 있으므로, 데이터를 읽고 쓸 시간입니다.

먼저, `Dog`를 `dogs` 테이블에 삽입합니다. 여기에는 두 단계가 포함됩니다.

1. `Dog`를 `Map`으로 변환합니다.
2. [`insert()`][] 메서드를 사용하여, `Map`을 `dogs` 테이블에 저장합니다.

<?code-excerpt "lib/main.dart (Dog)"?>
```dart
class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  // Dog를 Map으로 변환합니다. 
  // 키는 데이터베이스의 열 이름과 일치해야 합니다.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // print 문을 사용할 때 각 개에 대한 정보를 더 쉽게 볼 수 있도록 toString을 구현합니다.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
```

<?code-excerpt "lib/main.dart (insertDog)"?>
```dart
// 데이터베이스에 개를 삽입하는 함수를 정의합니다.
Future<void> insertDog(Dog dog) async {
  // 데이터베이스에 대한 참조를 가져옵니다.
  final db = await database;

  // 올바른 테이블에 Dog를 삽입합니다. 
  // 같은 개가 두 번 삽입되는 경우 사용할 `conflictAlgorithm`을 지정할 수도 있습니다.
  //
  // 이 경우, 이전 데이터를 모두 대체합니다.
  await db.insert(
    'dogs',
    dog.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
```

<?code-excerpt "lib/main.dart (fido)"?>
```dart
// Dog를 생성하여 dogs 테이블에 추가합니다.
var fido = Dog(
  id: 0,
  name: 'Fido',
  age: 35,
);

await insertDog(fido);
```

## 6. dogs 리스트 검색 {:#6-retrieve-the-list-of-dogs}

이제 `Dog`가 데이터베이스에 저장되었으므로, 특정 개나 모든 개 리스트를 데이터베이스에 쿼리합니다. 여기에는 두 단계가 포함됩니다.

   1. `dogs` 테이블에 대해 `query`를 실행합니다. 이는 `List<Map>`를 반환합니다.
   2. `List<Map>`를 `List<Dog>`로 변환합니다.

<?code-excerpt "lib/main.dart (dogs)"?>
```dart
// dogs 테이블에서 모든 개를 검색하는 메서드.
Future<List<Dog>> dogs() async {
  // 데이터베이스에 대한 참조를 가져옵니다.
  final db = await database;

  // 모든 개에 대해 테이블을 쿼리합니다.
  final List<Map<String, Object?>> dogMaps = await db.query('dogs');

  // 각 개의 필드 리스트를 `Dog` 객체 리스트로 변환합니다.
  return [
    for (final {
          'id': id as int,
          'name': name as String,
          'age': age as int,
        } in dogMaps)
      Dog(id: id, name: name, age: age),
  ];
}
```

<?code-excerpt "lib/main.dart (print)"?>
```dart
// 이제, 위의 메서드를 사용해 모든 개를 찾아보세요.
print(await dogs()); // Fido가 포함된 리스트를 출력합니다.
```

## 7. 데이터베이스에서 `Dog` 업데이트 {:#7-update-a-dog-in-the-database}

데이터베이스에 정보를 삽입한 후, 나중에 해당 정보를 업데이트하고 싶을 수 있습니다. 
`sqflite` 라이브러리의 [`update()`][] 메서드를 사용하여 이를 수행할 수 있습니다.

여기에는 두 단계가 포함됩니다.

  1. Dog를 Map으로 변환합니다.
  2. `where` 절을 사용하여, 올바른 Dog를 업데이트합니다.

<?code-excerpt "lib/main.dart (update)"?>
```dart
Future<void> updateDog(Dog dog) async {
  // 데이터베이스에 대한 참조를 가져옵니다.
  final db = await database;

  // 주어진 Dog를 업데이트합니다.
  await db.update(
    'dogs',
    dog.toMap(),
    // 일치하는 id의 Dog가 있는지 확인하세요.
    where: 'id = ?',
    // SQL 인젝션을 방지하기 위해, Dog의 id를 whereArg로 전달합니다.
    whereArgs: [dog.id],
  );
}
```

<?code-excerpt "lib/main.dart (update2)"?>
```dart
// Fido의 나이를 업데이트하여, 데이터베이스에 저장합니다.
fido = Dog(
  id: fido.id,
  name: fido.name,
  age: fido.age + 7,
);
await updateDog(fido);

// 업데이트된 결과를 출력합니다.
print(await dogs()); // 42세의 피도를 출력합니다.
```

:::warning
항상 `whereArgs`를 사용하여, `where` 문에 인수를 전달합니다.
이렇게 하면 SQL 인젝션 공격으로부터 보호하는 데 도움이 됩니다.

`where: "id = ${dog.id}"`와 같은, 문자열 보간을 사용하지 마세요!
:::


## 8. 데이터베이스에서 `Dog` 삭제 {:#8-delete-a-dog-from-the-database}

Dogs에 대한 정보를 삽입하고 업데이트하는 것 외에도, 데이터베이스에서 개를 제거할 수도 있습니다. 
데이터를 삭제하려면, `sqflite` 라이브러리의 [`delete()`][] 메서드를 사용합니다.

이 섹션에서는, id를 가져와 데이터베이스에서 일치하는 id를 가진 개를 삭제하는 함수를 만듭니다. 
이를 작동시키려면, `where` 절을 제공하여 삭제되는 레코드를 제한해야 합니다.

<?code-excerpt "lib/main.dart (deleteDog)"?>
```dart
Future<void> deleteDog(int id) async {
  // 데이터베이스에 대한 참조를 가져옵니다.
  final db = await database;

  // 데이터베이스에서 Dog를 제거합니다.
  await db.delete(
    'dogs',
    // `where` 절을 사용하여 특정 개를 삭제합니다.
    where: 'id = ?',
    // SQL 인젝션을 방지하려면 Dog의 id를 whereArg로 전달합니다.
    whereArgs: [id],
  );
}
```

## 예제 {:#example}

예제를 실행하려면:

  1. 새 Flutter 프로젝트를 만듭니다.
  2. `sqflite` 및 `path` 패키지를 `pubspec.yaml`에 추가합니다.
  3. 다음 코드를 `lib/db_test.dart`라는 새 파일에 붙여넣습니다.
  4. `flutter run lib/db_test.dart`로 코드를 실행합니다.

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // 플러터 업그레이드로 인한 오류를 방지합니다.
  // 'package:flutter/widgets.dart'를 import 하는 것이 요구됩니다.
  WidgetsFlutterBinding.ensureInitialized();
  // 데이터베이스를 열고 참조를 저장합니다.
  final database = openDatabase(
    // 데이터베이스 경로를 설정합니다. 
    // 참고: `path` 패키지의 `join` 함수를 사용하는 것이 
    // 각 플랫폼에 대한 경로가 올바르게 구성되도록 하는 가장 좋은 방법입니다.
    join(await getDatabasesPath(), 'doggie_database.db'),
    // 데이터베이스를 처음 생성할 때, 개를 저장할 테이블을 생성합니다.
    onCreate: (db, version) {
      // 데이터베이스에서 CREATE TABLE 문을 실행합니다.
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    },
    // 버전을 설정합니다. 
    // 이것은 onCreate 함수를 실행하고, 데이터베이스 업그레이드 및 다운그레이드를 수행하는 경로를 제공합니다.
    version: 1,
  );

  // 데이터베이스에 개를 삽입하는 함수를 정의합니다.
  Future<void> insertDog(Dog dog) async {
    // 데이터베이스에 대한 참조를 가져옵니다.
    final db = await database;

    // 올바른 테이블에 Dog를 삽입합니다. 
    // 같은 개가 두 번 삽입되는 경우 사용할 `conflictAlgorithm`을 지정할 수도 있습니다.
    //
    // 이 경우, 기존의 데이터를 모두 교체합니다.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // dogs 테이블에서 모든 개를 검색하는 메서드.
  Future<List<Dog>> dogs() async {
    // 데이터베이스에 대한 참조를 가져옵니다.
    final db = await database;

    // 모든 dogs에 대해 테이블을 쿼리합니다.
    final List<Map<String, Object?>> dogMaps = await db.query('dogs');

    // 각 개의 필드의 리스트를 `Dog` 객체의 리스트로 변환합니다.
    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'age': age as int,
          } in dogMaps)
        Dog(id: id, name: name, age: age),
    ];
  }

  Future<void> updateDog(Dog dog) async {
    // 데이터베이스에 대한 참조를 가져옵니다.
    final db = await database;

    // 주어진 Dog를 업데이트합니다.
    await db.update(
      'dogs',
      dog.toMap(),
      // Dog에 일치하는 ID가 있는지 확인합니다.
      where: 'id = ?',
      // SQL 인젝션을 방지하기 위해 Dog의 id를 whereArg로 전달합니다.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    // 데이터베이스에 대한 참조를 가져옵니다.
    final db = await database;

    // 데이터베이스에서 Dog를 제거합니다.
    await db.delete(
      'dogs',
      // `where` 절을 사용하여 특정 개를 삭제합니다.
      where: 'id = ?',
      // SQL 인젝션을 방지하기 위해 Dog의 id를 whereArg로 전달합니다.
      whereArgs: [id],
    );
  }

  // Dog를 생성하여 dogs 테이블에 추가합니다.
  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );

  await insertDog(fido);

  // 이제, 위의 메서드를 사용해 모든 개를 찾아보세요.
  print(await dogs()); // Fido가 포함된 리스트를 출력합니다.

  // Fido의 나이를 업데이트하여 데이터베이스에 저장합니다.
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await updateDog(fido);

  // 업데이트된 결과를 인쇄합니다.
  print(await dogs()); // 42세의 Fido를 출력합니다.

  // 데이터베이스에서 Fido를 삭제합니다.
  await deleteDog(fido.id);

  // dogs 리스트를 출력합니다. (비어 있음)
  print(await dogs());
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  // Dog를 Map으로 변환합니다. 
  // 키는 데이터베이스의 열 이름과 일치해야 합니다.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // print 문을 사용할 때 각 개에 대한 정보를 더 쉽게 볼 수 있도록 toString을 구현합니다.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
```


[`delete()`]: {{site.pub-api}}/sqflite_common/latest/sqlite_api/DatabaseExecutor/delete.html
[`insert()`]: {{site.pub-api}}/sqflite_common/latest/sqlite_api/DatabaseExecutor/insert.html
[`sqflite`]: {{site.pub-pkg}}/sqflite
[SQLite Tutorial]: http://www.sqlitetutorial.net/
[official SQLite Datatypes documentation]: https://www.sqlite.org/datatype3.html
[`update()`]: {{site.pub-api}}/sqflite_common/latest/sqlite_api/DatabaseExecutor/update.html
