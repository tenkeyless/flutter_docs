---
# title: An introduction to unit testing
title: 유닛 테스트 소개
# description: How to write unit tests.
description: 유닛 테스트를 작성하는 방법.
# short-title: Introduction
short-title: 소개
---

<?code-excerpt path-base="cookbook/testing/unit/counter_app"?>

더 많은 기능을 추가하거나 기존 기능을 변경하더라도 앱이 계속 작동하도록 하려면 어떻게 해야 할까요? 테스트를 작성하면 됩니다.

유닛 테스트는 단일 함수, 메서드 또는 클래스의 동작을 확인하는 데 유용합니다. 
[`test`][] 패키지는 유닛 테스트를 작성하기 위한 코어 프레임워크를 제공하고, 
[`flutter_test`][] 패키지는 위젯을 테스트하기 위한 추가 유틸리티를 제공합니다.

이 레시피는 다음 단계를 사용하여 `test` 패키지에서 제공하는 핵심 기능을 보여줍니다.

  1. `test` 또는 `flutter_test` 종속성을 추가합니다.
  2. 테스트 파일을 만듭니다.
  3. 테스트할 클래스를 만듭니다.
  4. 클래스에 대한 `test`를 작성합니다.
  5. 여러 테스트를 `group`으로 결합합니다.
  6. 테스트를 실행합니다.

테스트 패키지에 대한 자세한 내용은, [테스트 패키지 문서][test package documentation]를 ​​참조하세요.

## 1. 테스트 종속성 추가 {:#1-add-the-test-dependency}

`test` 패키지는 Dart에서 테스트를 작성하기 위한 핵심 기능을 제공합니다. 
이는 웹, 서버 및 Flutter 앱에서 사용하는 패키지를 작성할 때 가장 좋은 방법입니다.

`test` 패키지를 개발 종속성으로 추가하려면, `flutter pub add`를 실행합니다.

```console
$ flutter pub add dev:test
```

## 2. 테스트 파일 만들기 {:#2-create-a-test-file}

이 예에서, `counter.dart`와 `counter_test.dart`라는 두 개의 파일을 만듭니다.

`counter.dart` 파일에는 테스트하려는 클래스가 포함되어 있으며 `lib` 폴더에 있습니다. 
`counter_test.dart` 파일에는 테스트 자체가 포함되어 있으며 `test` 폴더 내부에 있습니다.

일반적으로, 테스트 파일은 Flutter 애플리케이션 또는 패키지의 루트에 있는 `test` 폴더 내부에 있어야 합니다. 
테스트 파일은 항상 `_test.dart`로 끝나야 합니다. 
이는 테스트 러너가 테스트를 검색할 때 사용하는 규칙입니다.

완료되면, 폴더 구조가 다음과 같아야 합니다.

```plaintext
counter_app/
  lib/
    counter.dart
  test/
    counter_test.dart
```

## 3. 테스트할 클래스를 만들기 {:#3-create-a-class-to-test}

다음으로, 테스트할 "유닛"이 필요합니다. 기억하세요: "유닛"은 함수, 메서드 또는 클래스의 또 다른 이름입니다. 
이 예에서는, `lib/counter.dart` 파일 내부에 `Counter` 클래스를 만듭니다. 
`0`에서 시작하는 `value`를 증가 및 감소시키는 역할을 합니다.

<?code-excerpt "lib/counter.dart"?>
```dart
class Counter {
  int value = 0;

  void increment() => value++;

  void decrement() => value--;
}
```

**참고:** 단순성을 위해, 이 튜토리얼은 "테스트 주도 개발(Test Driven Development)" 접근 방식을 따르지 않습니다. 
해당 개발 스타일이 더 편하다면, 언제든지 그 경로를 선택할 수 있습니다.

## 4. 클래스에 대한 테스트 작성 {:#4-write-a-test-for-our-class}

`counter_test.dart` 파일 안에, 첫 번째 유닛 테스트를 작성합니다. 
테스트는 최상위 `test` 함수를 사용하여 정의되며, 최상위 `expect` 함수를 사용하여 결과가 올바른지 확인할 수 있습니다. 
이 두 함수는 모두 `test` 패키지에서 제공됩니다.

<?code-excerpt "test/counter_test.dart"?>
```dart
// test 패키지와 Counter 클래스를 import 합니다.
import 'package:counter_app/counter.dart';
import 'package:test/test.dart';

void main() {
  test('Counter value should be incremented', () {
    final counter = Counter();

    counter.increment();

    expect(counter.value, 1);
  });
}
```

## 5. 여러 테스트를 `group`으로 결합 {:#5-combine-multiple-tests-in-a-group}

일련의 관련 테스트를 실행하려면, `flutter_test` 패키지의 [`group`][] 함수를 사용하여 테스트를 분류합니다. 
그룹에 넣은 후, 한 번의 명령으로 해당 그룹의 모든 테스트에 `flutter test`를 호출할 수 있습니다.

<?code-excerpt "test/group.dart"?>
```dart
import 'package:counter_app/counter.dart';
import 'package:test/test.dart';

void main() {
  group('Test start, increment, decrement', () {
    test('value should start at 0', () {
      expect(Counter().value, 0);
    });

    test('value should be incremented', () {
      final counter = Counter();

      counter.increment();

      expect(counter.value, 1);
    });

    test('value should be decremented', () {
      final counter = Counter();

      counter.decrement();

      expect(counter.value, -1);
    });
  });
}
```

## 6. 테스트 실행 {:#6-run-the-tests}

이제 테스트가 포함된 `Counter` 클래스가 생겼으니, 테스트를 실행할 수 있습니다.

### IntelliJ 또는 VSCode를 사용하여 테스트 실행 {:#run-tests-using-intellij-or-vscode}

IntelliJ 및 VSCode용 Flutter 플러그인은 테스트 실행을 지원합니다. 
이는 테스트를 작성하는 동안 가장 빠른 피드백 루프와 중단점을 설정하는 기능을 제공하기 때문에 종종 가장 좋은 옵션입니다.

- **IntelliJ**

  1. `counter_test.dart` 파일을 엽니다.
  2. **Run** > **Run 'tests in counter_test.dart'**로 이동합니다.
     또한, 당신의 플랫폼에 맞는 키보드 단축키를 누를 수도 있습니다.

- **VSCode**

  1. `counter_test.dart` 파일을 엽니다.
  2. **Run** > **Start Debugging**로 이동합니다.
     또한, 당신의 플랫폼에 맞는 키보드 단축키를 누를 수도 있습니다.

### 터미널에서 테스트 실행 {:#run-tests-in-a-terminal}

터미널에서 모든 테스트를 실행하려면, 프로젝트 루트에서 다음 명령을 실행하세요.

```console
flutter test test/counter_test.dart
```

하나의 `group`에 넣은 모든 테스트를 실행하려면, 프로젝트 루트에서 다음 명령을 실행하세요.

```console
flutter test --plain-name "Test start, increment, decrement"
```

이 예제에서는 **section 5**에서 만든 `group`을 사용합니다.

유닛 테스트에 대해 자세히 알아보려면, 다음 명령을 실행할 수 있습니다.

```console
flutter test --help
```

[`group`]: {{site.api}}/flutter/flutter_test/group.html
[`flutter_test`]: {{site.api}}/flutter/flutter_test/flutter_test-library.html
[`test`]: {{site.pub-pkg}}/test
[test package documentation]: {{site.pub}}/packages/test
