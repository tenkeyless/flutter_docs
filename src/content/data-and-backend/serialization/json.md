---
# title: JSON and serialization
title: JSON 및 직렬화
short-title: JSON
# description: How to use JSON with Flutter.
description: Flutter에서 JSON을 사용하는 방법.
---

<?code-excerpt path-base="data-and-backend/json/"?>

'웹 서버와 통신하거나 동시에 구조화된 데이터를 쉽게 저장'할 필요가 없는 모바일 앱을 생각해내기는 어렵습니다. 
네트워크에 연결된 앱을 만들 때, 조만간 오래된 JSON을 사용해야 할 가능성이 있습니다.

이 가이드에서는 Flutter에서 JSON을 사용하는 방법을 살펴봅니다. 
다양한 시나리오에서 어떤 JSON 솔루션을 사용해야 하는지, 그리고 그 이유를 다룹니다.

:::note 용어
_인코딩 (Encoding)_ 과 _직렬화 (serialization)_ 는 같은 것입니다. 즉, 데이터 구조를 문자열로 변환하는 것입니다. 
_디코딩 (Decoding)_ 과 _역직렬화 (deserialization)_ 는 반대 프로세스입니다. 즉, 문자열을 데이터 구조로 변환하는 것입니다. 
그러나, _직렬화_ 는 일반적으로 데이터 구조를 더 읽기 쉬운 형식으로부터 변환하는 전체 프로세스를 말합니다.

혼동을 피하기 위해, 이 문서에서는 전체 프로세스를 언급할 때 "직렬화"를 사용하고, 
해당 프로세스를 구체적으로 언급할 때 "인코딩"과 "디코딩"을 사용합니다.
:::

## 나에게 맞는 JSON 직렬화 방법은 무엇입니까? {:#which-json-serialization-method-is-right-for-me}

이 글에서는, JSON 작업을 위한 두 가지 일반적인 전략을 다룹니다.

* 수동 직렬화
* 코드 생성을 사용한 자동 직렬화

프로젝트마다 복잡성과 사용 사례가 다릅니다. 
소규모 개념 증명 프로젝트나 빠른 프로토타입의 경우, 코드 생성기를 사용하는 것은 과도할 수 있습니다. 
복잡성이 더 높은 여러 JSON 모델이 있는 앱의 경우, 수동으로 인코딩하는 것은 금방 지루하고 반복적이 될 수 있으며, 
많은 사소한 오류가 발생할 수 있습니다.

### (1) 소규모 프로젝트에는 수동 직렬화 사용 {:#use-manual-serialization-for-smaller-projects}

수동 JSON 디코딩은 `dart:convert`에서 내장된 JSON 디코더를 사용하는 것을 말합니다. 
여기에는 raw JSON 문자열을 `jsonDecode()` 함수에 전달한 다음, 
결과 `Map<String, dynamic>`에서 필요한 값을 찾는 것이 포함됩니다. 
외부 종속성이나 특정 설정 프로세스가 없으며, 빠른 개념 증명에 좋습니다.

프로젝트가 커질수록 수동 디코딩은 성능이 좋지 않습니다. 
디코딩 로직을 직접 작성하면, 관리하기 어렵고 오류가 발생하기 쉽습니다. 
존재하지 않는 JSON 필드에 액세스할 때 오타가 있으면, 런타임 중에 코드에서 오류가 발생합니다.

프로젝트에 JSON 모델이 많지 않고 개념을 빠르게 테스트하려는 경우, 수동 직렬화가 시작 방법일 수 있습니다. 
수동 인코딩의 예는 [dart:convert를 사용하여 JSON을 수동으로 직렬화][Serializing JSON manually using dart:convert]를 참조하세요.

:::tip
JSON 역직렬화에 대한 실습과 Dart 3의 새로운 기능 활용을 위해, 
[Dart의 패턴과 레코드 살펴보기][Dive into Dart's patterns and records] 코드랩을 확인하세요.
:::

### (2) 중대형 프로젝트에 코드 생성 사용 {:#use-code-generation-for-medium-to-large-projects}

코드 생성을 통한 JSON 직렬화는 외부 라이브러리가 인코딩 보일러플레이트를 생성한다는 것을 의미합니다. 
초기 설정 후, 모델 클래스에서 코드를 생성하는 파일 워처(file watcher)를 실행합니다. 
예를 들어, [`json_serializable`][] 및 [`built_value`][]는 이러한 종류의 라이브러리입니다.

이 접근 방식은 대규모 프로젝트에 잘 맞습니다. 
직접 작성한 보일러플레이트가 필요 없으며, JSON 필드에 액세스할 때 발생하는 오타는 컴파일 시에 발견됩니다. 
코드 생성의 단점은 초기 설정이 필요하다는 것입니다. 
또한, 생성된 소스 파일은 프로젝트 탐색기에서 시각적 혼란을 일으킬 수 있습니다.

중간 또는 대규모 프로젝트가 있는 경우, JSON 직렬화에 생성된 코드를 사용할 수 있습니다. 
코드 생성 기반 JSON 인코딩의 예를 보려면, [코드 생성 라이브러리를 사용하여 JSON 직렬화][Serializing JSON using code generation libraries]를 참조하세요.

## Flutter에서 GSON/<wbr>Jackson/<wbr>Moshi에 대응하는 것이 있나요? {:#is-there-a-gsonjacksonmoshi-equivalent-in-flutter}

간단한 답은 '아니요'입니다.

이러한 라이브러리는 Flutter에서 비활성화된 런타임 [리플렉션][reflection]을 사용해야 합니다. 
런타임 리플렉션은 Dart가 꽤 오랫동안 지원해 온 [트리 셰이킹][tree shaking]을 방해합니다. 
트리 셰이킹을 사용하면, 릴리스 빌드에서 사용하지 않는 코드를 "제거(shake off)"할 수 있습니다.
이렇게 하면 앱의 크기가 상당히 최적화됩니다.

리플렉션은 기본적으로 모든 코드를 암묵적으로 사용하게 하므로, 트리 셰이킹이 어렵습니다. 
도구는 런타임에 어떤 부분이 사용되지 않는지 알 수 없으므로, 중복된 코드를 제거하기 어렵습니다. 
리플렉션을 사용하면, 앱 크기를 쉽게 최적화할 수 없습니다.

Flutter에서 런타임 리플렉션을 사용할 수는 없지만, 
일부 라이브러리는 비슷하게 사용하기 쉬운 API를 제공하지만 대신 코드 생성을 기반으로 합니다. 
이 접근 방식은 [코드 생성 라이브러리][code generation libraries] 섹션에서 더 자세히 설명합니다.

<a id="manual-encoding"></a>
## dart:convert를 사용하여 JSON을 수동으로 직렬화 {:#serializing-json-manually-using-dart-convert}

Flutter의 기본 JSON 직렬화는 매우 간단합니다. 
Flutter에는 간단한 JSON 인코더와 디코더를 포함하는 내장 `dart:convert` 라이브러리가 있습니다.

다음 샘플 JSON은 간단한 사용자 모델을 구현합니다.

<?code-excerpt "lib/manual/main.dart (multiline-json)" skip="1" take="4"?>
```json
{
  "name": "John Smith",
  "email": "john@example.com"
}
```

`dart:convert`를 사용하면, 두 가지 방법으로 이 JSON 모델을 직렬화할 수 있습니다.

### (1) JSON 인라인 직렬화 {:#serializing-json-inline}

[`dart:convert`][] 문서를 살펴보면, 
JSON 문자열을 메서드 인수로 사용하여, 
`jsonDecode()` 함수를 호출하여 JSON을 디코딩할 수 있음을 알 수 있습니다.

<?code-excerpt "lib/manual/main.dart (manual)"?>
```dart
final user = jsonDecode(jsonString) as Map<String, dynamic>;

print('Howdy, ${user['name']}!');
print('We sent the verification link to ${user['email']}.');
```

불행히도, `jsonDecode()`는 `dynamic`을 반환합니다. 즉, 런타임까지 값의 타입을 알 수 없습니다. 
이 접근 방식을 사용하면, 대부분의 정적 타입 언어 기능(타입 안전성, 자동 완성 및 가장 중요한 컴파일 타임 예외)들을 잃게 됩니다. 
코드가 즉시 오류가 발생하기 쉬워집니다.

예를 들어, `name` 또는 `email` 필드에 액세스할 때마다 빠르게 오타가 발생할 수 있습니다. 
JSON이 맵 구조에 있기 때문에 컴파일러가 알지 못하는 오타입니다.

### (2) 모델 클래스 내부에서 JSON 직렬화 {:#serializing-json-inside-model-classes}

이전에 언급한 문제를 해결하기 위해, 이 예에서 `User`라는 일반 모델 클래스를 도입합니다. 
`User` 클래스 내부에서 다음을 찾을 수 있습니다.

* `User.fromJson()` 생성자 : 맵 구조에서 새 `User` 인스턴스를 구성하기 위함.
* `toJson()` 메서드 : `User` 인스턴스를 맵으로 변환하기 위함.

이 접근 방식을 사용하면, _호출 코드_ 에서 타입 안전성, `name` 및 `email` 필드에 대한 자동 완성, 컴파일 타임 예외를 가질 수 있습니다. 
오타를 내거나, 필드를 `String` 대신 `int`로 처리하면, 런타임에 충돌하는 대신 앱이 컴파일되지 않습니다.

**user.dart**

<?code-excerpt "lib/manual/user.dart"?>
```dart
class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        email = json['email'] as String;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
}
```

디코딩 로직의 책임은 이제 모델 자체 내부로 옮겨졌습니다. 
이 새로운 접근 방식을 사용하면, user를 쉽게 디코딩할 수 있습니다.

<?code-excerpt "lib/manual/main.dart (from-json)"?>
```dart
final userMap = jsonDecode(jsonString) as Map<String, dynamic>;
final user = User.fromJson(userMap);

print('Howdy, ${user.name}!');
print('We sent the verification link to ${user.email}.');
```

사용자를 인코딩하려면 `User` 객체를 `jsonEncode()` 함수에 전달합니다. 
`toJson()` 메서드를 호출할 필요가 없습니다. `jsonEncode()`가 이미 처리하기 때문입니다.

<?code-excerpt "lib/manual/main.dart (json-encode)" skip="1"?>
```dart
String json = jsonEncode(user);
```

이 접근 방식을 사용하면, 호출 코드는 JSON 직렬화에 대해 전혀 걱정할 필요가 없습니다. 
그러나, 모델 클래스는 여전히 걱정해야 합니다. 
프로덕션 앱에서는, 직렬화가 제대로 작동하는지 확인해야 합니다. 
실제로, `User.fromJson()` 및 `User.toJson()` 메서드는 모두 올바른 동작을 확인하기 위해 유닛 테스트를 실행해야 합니다.

:::note
쿡북에는 [JSON 모델 클래스 사용의 보다 포괄적인 작업 예제][json background parsing]이 포함되어 있으며, 
isolate을 사용하여 백그라운드 스레드에서 JSON 파일을 파싱합니다. 
이 접근 방식은 JSON 파일이 디코딩되는 동안, 앱이 응답성을 유지해야 하는 경우에 이상적입니다.
:::

하지만, 실제 시나리오는 항상 그렇게 간단하지 않습니다. 
JSON API 응답은 때때로 더 복잡합니다. 
예를 들어, 자체 모델 클래스를 통해 파싱해야 하는 중첩된 JSON 객체가 포함되어 있기 때문입니다.

JSON 인코딩 및 디코딩을 처리하는 것이 있으면 좋겠습니다. 다행히도 있습니다!

<a id="code-generation"></a>
## 코드 생성 라이브러리를 사용하여 JSON 직렬화 {:#serializing-json-using-code-generation-libraries}

사용 가능한 다른 라이브러리도 있지만, 이 가이드에서는 JSON 직렬화 보일러플레이트를 생성하는 자동화된 소스 코드 생성기인, 
[`json_serializable`][]을 사용합니다.

:::note 라이브러리 선택
pub.dev에서 JSON 직렬화 코드를 생성하는 두 개의 [Flutter Favorite][] 패키지인 [`json_serializable`][]과 [`built_value`][]를 알아차렸을 것입니다. 

이 패키지 중에서 어떤 것을 선택하시겠습니까? 

1. `json_serializable` 패키지를 사용하면 어노테이션을 사용하여 일반 클래스를 직렬화할 수 있는 반면, 
2. `built_value` 패키지는 JSON으로 직렬화할 수 있는 immutable 값 클래스를 정의하는 높은 레벨의 방법을 제공합니다.
:::

직렬화 코드가 더 이상 직접 작성되거나 유지 관리되지 않으므로, 
런타임 시 JSON 직렬화 예외가 발생할 위험을 최소화할 수 있습니다.

### 프로젝트에서 json_serializable 설정하기 {:#setting-up-json_serializable-in-a-project}

프로젝트에 `json_serializable`을 포함하려면, 
일반 종속성 하나와 _dev 종속성_ 두 개가 필요합니다. 
간단히 말해서, _dev 종속성_ 은 앱 소스 코드에 포함되지 않은 종속성이며, 개발 환경에서만 사용됩니다.

종속성을 추가하려면, `flutter pub add`를 실행합니다.

```console
$ flutter pub add json_annotation dev:build_runner dev:json_serializable
```

프로젝트 루트 폴더 내에서 `flutter pub get`을 실행하거나, 
편집기에서 **Packages get**을 클릭하면 프로젝트에서 새로운 종속성을 사용할 수 있습니다.

### json_serializable 방식으로 모델 클래스 생성 {:#creating-model-classes-the-json_serializable-way}

다음은 `User` 클래스를 `json_serializable` 클래스로 변환하는 방법을 보여줍니다. 
단순성을 위해, 이 코드는 이전 샘플의 간소화된 JSON 모델을 사용합니다.

**user.dart**

<?code-excerpt "lib/serializable/user.dart"?>
```dart
import 'package:json_annotation/json_annotation.dart';

/// 이렇게 하면 `User` 클래스가 생성된 파일의 private 멤버에 액세스할 수 있습니다. 
/// 이 값은 *.g.dart이며, 별표는 소스 파일 이름을 나타냅니다.
part 'user.g.dart';

/// 이 클래스에 JSON 직렬화 로직을 생성해야 한다는 것을 코드 생성기가 알 수 있도록 하는 어노테이션입니다.
@JsonSerializable()
class User {
  User(this.name, this.email);

  String name;
  String email;

  /// 맵에서 새 User 인스턴스를 만드는 데 필요한 팩토리 생성자입니다. 
  /// 생성된 `_$UserFromJson()` 생성자에 맵을 전달합니다. 
  /// 생성자는 소스 클래스의 이름을 따서 명명되었으며, 이 경우 User입니다.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// `toJson`은 클래스가 JSON에 대한 직렬화 지원을 선언하는 규칙(convention)입니다. 
  /// 구현은 단순히 private 생성된 헬퍼 메서드 `_$UserToJson`을 호출합니다.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

이 설정을 사용하면, 소스 코드 생성기가 JSON에서 `name` 및 `email` 필드를 인코딩하고 디코딩하기 위한 코드를 생성합니다.

필요한 경우, 명명 전략을 커스터마이즈 하는 것도 쉽습니다. 
예를 들어, API가 _snake\_case_ 를 사용하여 객체를 반환하고, 
모델에서 _lowerCamelCase_ 를 사용하려는 경우, 
`@JsonKey` 어노테이션을 name 매개변수와 함께 사용할 수 있습니다.

```dart
/// json_serializable에 "registration_date_millis"가 이 속성에 매핑되어야 한다고 알려줍니다.
@JsonKey(name: 'registration_date_millis')
final int registrationDateMillis;
```

서버와 클라이언트가 모두 동일한 명명 전략을 따르는 것이 가장 좋습니다. 
`@JsonSerializable()`은 Dart 필드를 JSON 키로 완전히 변환하기 위한 `fieldRename` enum을 제공합니다.

`@JsonSerializable(fieldRename: FieldRename.snake)`를 수정하는 것은 
각 필드에 `@JsonKey(name: '<snake_case>')`를 추가하는 것과 같습니다.

서버 데이터가 불확실한 경우가 있으므로, 클라이언트에서 데이터를 확인하고 보호해야 합니다. 
일반적으로 사용되는 또다른 `@JsonKey` 어노테이션은 다음과 같습니다.

```dart
/// JSON에 이 키가 포함되어 있지 않거나 값이 `null`인 경우, 
/// json_serializable에게 "defaultValue"를 사용하도록 지시합니다.
@JsonKey(defaultValue: false)
final bool isAdult;

/// `true`로 설정하면, json_serializable에게 JSON에 키가 포함되어야 함을 알려줍니다. 
/// 키가 없으면, 예외가 발생합니다.
@JsonKey(required: true)
final String id;

/// `true`로 설정하면, json_serializable에게 생성된 코드는 이 필드를 완전히 무시해야 한다고 말해줍니다.
@JsonKey(ignore: true)
final String verificationCode;
```

### 코드 생성 유틸리티 실행 {:#running-the-code-generation-utility}

처음으로 `json_serializable` 클래스를 생성할 때, 아래 이미지에 표시된 것과 비슷한 오류가 발생합니다.

![IDE warning when the generated code for a model class does not exist
yet.](/assets/images/docs/json/ide_warning.png){:.mw-100}

이러한 오류는 완전히 정상적이며, 모델 클래스에 대한 생성된 코드가 아직 존재하지 않기 때문입니다. 
이를 해결하려면, 직렬화 보일러플레이트를 생성하는 코드 생성기를 실행하세요.

코드 생성기를 실행하는 방법에는 두 가지가 있습니다.

#### 일회성(One-time) 코드 생성 {:#one-time-code-generation}

프로젝트 루트에서 `dart run build_runner build --delete-conflicting-outputs`를 실행하면, 
필요할 때마다 모델에 대한 JSON 직렬화 코드를 생성합니다. 
이렇게 하면 소스 파일을 살펴보고, 관련 파일을 선택하고, 해당 파일에 필요한 직렬화 코드를 생성하는, 일회성 빌드가 트리거됩니다.

편리하기는 하지만, 모델 클래스를 변경할 때마다 빌드를 수동으로 실행하지 않아도 된다면 좋을 것입니다.

#### 지속적으로 코드 생성 {:#generating-code-continuously}

_워처(watcher)_ 는 소스 코드 생성 프로세스를 더욱 편리하게 해줍니다. 
프로젝트 파일의 변경 사항을 감시하고, 필요할 때 자동으로 필요한 파일을 빌드합니다. 
프로젝트 루트에서 `dart run build_runner watch --delete-conflicting-outputs`를 실행하여 워처를 시작합니다.

워처를 한 번 시작하고 백그라운드에서 실행 상태로 두는 것이 안전합니다.

### json_serializable 모델 소비(Consuming) {:#consuming-json_serializable-models}

`json_serializable` 방식으로 JSON 문자열을 디코딩하려면, 실제로 이전 코드를 변경할 필요가 없습니다.

<?code-excerpt "lib/serializable/main.dart (from-json)"?>
```dart
final userMap = jsonDecode(jsonString) as Map<String, dynamic>;
final user = User.fromJson(userMap);
```

인코딩도 마찬가지입니다. 호출 API는 이전과 동일합니다.

<?code-excerpt "lib/serializable/main.dart (json-encode)" skip="1"?>
```dart
String json = jsonEncode(user);
```

`json_serializable`을 사용하면, `User` 클래스에서 수동 JSON 직렬화를 잊을 수 있습니다. 
소스 코드 생성기는 `user.g.dart`라는 파일을 생성하는데, 여기에는 모든 필수 직렬화 로직이 들어 있습니다. 
더 이상 직렬화가 작동하는지 확인하기 위해 자동화된 테스트를 작성할 필요가 없습니다. 
이제 직렬화가 적절하게 작동하는지 확인하는 것은 _라이브러리의 책임_ 입니다.

## 중첩 클래스에 대한 코드 생성 {:#generating-code-for-nested-classes}

클래스 내에 중첩된 클래스가 있는 코드가 있을 수 있습니다. 
그런 경우, 클래스를 JSON 형식으로 서비스(예: Firebase)에 인수로 전달하려고 시도했다면, 
`Invalid argument` 오류가 발생했을 수 있습니다.

다음 `Address` 클래스를 고려해 보세요.

<?code-excerpt "lib/nested/address.dart"?>
```dart
import 'package:json_annotation/json_annotation.dart';
part 'address.g.dart';

@JsonSerializable()
class Address {
  String street;
  String city;

  Address(this.street, this.city);

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
```

`Address` 클래스는 `User` 클래스 내부에 중첩되어 있습니다.

<?code-excerpt "lib/nested/user.dart" replace="/explicitToJson: true//g"?>
```dart
import 'package:json_annotation/json_annotation.dart';

import 'address.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(this.name, this.address);

  String name;
  Address address;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

터미널에서 `dart run build_runner build --delete-conflicting-outputs`를 실행하면, 
`*.g.dart` 파일이 생성되지만, private `_$UserToJson()` 함수는 다음과 유사합니다.

```dart
Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'name': instance.name,
  'address': instance.address,
};
```

지금은 모든 것이 괜찮아 보이지만, user 객체에 print()를 실행하면:

<?code-excerpt "lib/nested/main.dart (print)"?>
```dart
Address address = Address('My st.', 'New York');
User user = User('John', address);
print(user.toJson());
```

결과는 다음과 같습니다.

```json
{name: John, address: Instance of 'address'}
```

아마도 당신이 원하는 것은 다음과 같은 출력일 것입니다:

```json
{name: John, address: {street: My st., city: New York}}
```

이것이 동작하도록 하려면, 클래스 선언에 `@JsonSerializable()` 주석에서 `explicitToJson: true`를 전달합니다. 
이제 `User` 클래스는 다음과 같습니다.

<?code-excerpt "lib/nested/user.dart"?>
```dart
import 'package:json_annotation/json_annotation.dart';

import 'address.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  User(this.name, this.address);

  String name;
  Address address;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

자세한 내용은, [`json_annotation`][] 패키지의 [`JsonSerializable`][] 클래스에서, 
[`explicitToJson`][]을 참조하세요.

## 추가 참고 자료 {:#further-references}

자세한 내용은 다음 리소스를 참조하세요.

* [`dart:convert`][] 및 [`JsonCodec`][] 문서
* pub.dev의 [`json_serializable`][] 패키지
* GitHub의 [`json_serializable` 예제][`json_serializable` examples]
* [Dart의 패턴과 레코드 탐구][Dive into Dart's patterns and records] 코드랩
* [Dart/Flutter에서 JSON을 파싱하는 방법][how to parse JSON in Dart/Flutter]에 대한 이 궁극적인 가이드

[`built_value`]: {{site.pub}}/packages/built_value
[code generation libraries]: #code-generation
[`dart:convert`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-convert
[`explicitToJson`]: {{site.pub}}/documentation/json_annotation/latest/json_annotation/JsonSerializable/explicitToJson.html
[Flutter Favorite]: /packages-and-plugins/favorites
[json background parsing]: /cookbook/networking/background-parsing
[`JsonCodec`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-convert/JsonCodec-class.html
[`JsonSerializable`]: {{site.pub}}/documentation/json_annotation/latest/json_annotation/JsonSerializable-class.html
[`json_annotation`]: {{site.pub}}/packages/json_annotation
[`json_serializable`]: {{site.pub}}/packages/json_serializable
[`json_serializable` examples]: {{site.github}}/google/json_serializable.dart/blob/master/example/lib/example.dart
[pubspec file]: https://raw.githubusercontent.com/google/json_serializable.dart/master/example/pubspec.yaml
[reflection]: https://en.wikipedia.org/wiki/Reflection_(computer_programming)
[Serializing JSON manually using dart:convert]: #manual-encoding
[Serializing JSON using code generation libraries]: #code-generation
[tree shaking]: https://en.wikipedia.org/wiki/Tree_shaking
[Dive into Dart's patterns and records]: {{site.codelabs}}/codelabs/dart-patterns-records
[how to parse JSON in Dart/Flutter]: https://codewithandrea.com/articles/parse-json-dart/
