---
# title: Internationalizing Flutter apps
title: Flutter 앱 국제화
short-title: i18n
# description: How to internationalize your Flutter app.
description: Flutter 앱을 국제화하는 방법.
---

<?code-excerpt path-base="internationalization"?>

{% comment %}
Consider updating the number of languages when touching this page.
{% endcomment %}

{% assign languageCount = '115' -%}

:::secondary 학습할 내용
* 기기의 로케일(locale, 사용자가 선호하는 언어)을 추적하는 방법.
* 로케일별 Material 또는 Cupertino 위젯을 활성화하는 방법.
* 로케일별 앱 값을 관리하는 방법.
* 앱이 지원하는 로케일을 정의하는 방법.
:::

앱이 다른 언어를 사용하는 사용자에게 배포될 수 있는 경우 국제화(internationalize)해야 합니다. 
즉, 앱이 지원하는 각 언어나 로케일(locale)에 대한 텍스트와 레이아웃과 같은 값을 현지화(localize)할 수 있는 방식으로 앱을 작성해야 합니다. 
Flutter는 국제화를 돕는 위젯과 클래스를 제공하며 Flutter 라이브러리 자체도 국제화됩니다.

이 페이지에서는 대부분 앱이 이런 방식으로 작성되므로, `MaterialApp` 및 `CupertinoApp` 클래스를 사용하여, 
Flutter 애플리케이션을 현지화하는 데 필요한 개념과 워크플로를 다룹니다. 
그러나, 하위 레벨 `WidgetsApp` 클래스를 사용하여 작성된 애플리케이션도 동일한 클래스와 로직을 사용하여 국제화할 수 있습니다.

## Flutter에서의 로컬라이제이션 소개 {:#introduction-to-localizations-in-flutter}

이 섹션에서는 새로운 Flutter 애플리케이션을 만들고 국제화하는 방법과, 
대상 플랫폼에 필요한 추가 설정에 대한 튜토리얼을 제공합니다.

이 예제의 소스 코드는 [`gen_l10n_example`][]에서 찾을 수 있습니다.

[`gen_l10n_example`]: {{site.repo.this}}/tree/{{site.branch}}/examples/internationalization/gen_l10n_example

### 국제화된 앱 설정: Flutter<wbr>_localizations 패키지 {:#setting-up}

기본적으로, Flutter는 미국 영어 현지화만 제공합니다. 
다른 언어에 대한 지원을 추가하려면, 애플리케이션에서 추가 `MaterialApp`(또는 `CupertinoApp`) 속성을 지정하고,
`flutter_localizations`라는 패키지를 포함해야 합니다. 
2023년 12월 현재, 이 패키지는 [{{languageCount}}개 언어][language-count] 및 언어 변형을 지원합니다.

시작하려면, `flutter create` 명령으로 선택한 디렉토리에 새 Flutter 애플리케이션을 만드는 것으로 시작합니다.

```console
$ flutter create <name_of_flutter_app>
```

`flutter_localizations`를 사용하려면, `pubspec.yaml` 파일에 `flutter_localizations` 패키지와 `intl` 패키지를 종속성으로 추가하세요.

```console
$ flutter pub add flutter_localizations --sdk=flutter
$ flutter pub add intl:any
```

이렇게 하면 다음 엔트리가 포함된 `pubspec.yml` 파일이 생성됩니다.

<?code-excerpt "gen_l10n_example/pubspec.yaml (flutter-localizations)"?>
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any
```

그런 다음, `flutter_localizations` 라이브러리를 import해서, 
`MaterialApp` 또는 `CupertinoApp`에 대해 `localizationsDelegates` 및 `supportedLocales`를 지정합니다.

<?code-excerpt "gen_l10n_example/lib/main.dart (localization-delegates-import)"?>
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
```

<?code-excerpt "gen_l10n_example/lib/main.dart (material-app)" remove="AppLocalizations.delegate"?>
```dart
return const MaterialApp(
  title: 'Localizations Sample App',
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('en'), // English
    Locale('es'), // Spanish
  ],
  home: MyHomePage(),
);
```

`flutter_localizations` 패키지를 도입하고 이전 코드를 추가한 후, 
`Material` 및 `Cupertino` 패키지는 이제 {{languageCount}}개의 지원되는 locales 중 하나로 올바르게 현지화되어야 합니다.
위젯은 올바른 왼쪽에서 오른쪽(left-to-right) 또는 오른쪽에서 왼쪽(right-to-left) 레이아웃과 함께 현지화된 메시지에 맞게 조정되어야 합니다.

대상 플랫폼의 로케일을 스페인어(`es`)로 전환해 보면 메시지가 현지화되어야 합니다.

`WidgetsApp` 기반 앱은 `GlobalMaterialLocalizations.delegate`가 필요하지 않다는 점을 제외하면 비슷합니다.

`Locale.fromSubtags` 전체 생성자는 [`scriptCode`][]를 지원하므로 선호되지만, 
`Locale` 기본 생성자는 여전히 완전히 유효합니다.

[`scriptCode`]: {{site.api}}/flutter/package-intl_locale/Locale/scriptCode.html

`localizationsDelegates` 리스트의 요소는 지역화된 값의 컬렉션을 생성하는 팩토리입니다. 
`GlobalMaterialLocalizations.delegate`는 Material Components 라이브러리에 대한 지역화된 문자열 및 기타 값을 제공합니다. 
`GlobalWidgetsLocalizations.delegate`는 위젯 라이브러리에 대한 기본 텍스트 방향을, 
왼쪽에서 오른쪽(left-to-right) 또는 오른쪽에서 왼쪽(right-to-left)으로 정의합니다.

이러한 앱 속성, 종속된 타입 및 국제화된 Flutter 앱이 일반적으로 구조화되는 방식에 대한 자세한 내용은 이 페이지에서 다룹니다.

[language-count]: {{site.api}}/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html

<a id="overriding-locale"></a>
### 로케일 재정의 {:#overriding-the-locale}

`Localizations.override`는 `Localizations` 위젯의 팩토리 생성자로, 
애플리케이션의 섹션을 기기에 구성된 로케일과 다른 로케일로 지역화해야 하는 (일반적으로 드문) 상황을 허용합니다.

이 동작을 관찰하려면, `Localizations.override`에 대한 호출과 간단한 `CalendarDatePicker`를 추가합니다.

<?code-excerpt "gen_l10n_example/lib/examples.dart (date-picker)"?>
```dart
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // 다음 코드를 추가하세요
          Localizations.override(
            context: context,
            locale: const Locale('es'),
            // Builder를 사용하여 올바른 BuildContext를 가져옵니다. 
            // 대안으로는, 새 위젯을 만들 수 있으며, 
            // Localizations.override는 업데이트된 BuildContext를 새 위젯에 전달합니다.
            child: Builder(
              builder: (context) {
                // 국제화된 Material 위젯의 토이 예제입니다.
                return CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  onDateChanged: (value) {},
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
```

앱을 핫 리로드하면 `CalendarDatePicker` 위젯이 스페인어로 다시 렌더링됩니다.

<a id="adding-localized-messages"></a>
### 나만의 지역화된 메시지 추가 {:#adding-your-own-localized-messages}

`flutter_localizations` 패키지를 추가한 후, 현지화를 구성할 수 있습니다. 
애플리케이션에 현지화된 텍스트를 추가하려면, 다음 지침을 완료하세요.

1. `intl` 패키지를 종속성으로 추가하고, `flutter_localizations`에서 고정된 버전을 가져옵니다.

   ```console
   $ flutter pub add intl:any
   ```

2. `pubspec.yaml` 파일을 열고, `generate` 플래그를 활성화합니다. 
   이 플래그는 pubspec 파일의 `flutter` 섹션에서 찾을 수 있습니다.

   <?code-excerpt "gen_l10n_example/pubspec.yaml (generate)"?>
   ```yaml
   # The following section is specific to Flutter.
   flutter:
     generate: true # 이 줄을 추가하세요
   ```

3. Flutter 프로젝트의 루트 디렉토리에 새 yaml 파일을 추가합니다. 
   이 파일의 이름을 `l10n.yaml`로 지정하고, 다음 내용을 포함합니다.

   <?code-excerpt "gen_l10n_example/l10n.yaml"?>
   ```yaml
   arb-dir: lib/l10n
   template-arb-file: app_en.arb
   output-localization-file: app_localizations.dart
   ```

   이 파일은 현지화 도구를 구성합니다. 이 예에서는, 다음을 수행했습니다.

   * [앱 리소스 번들][App Resource Bundle] (`.arb`) 입력 파일을 `${FLUTTER_PROJECT}/lib/l10n`에 넣습니다. 
     `.arb`는 앱에 대한 현지화 리소스를 제공합니다.
   * 영어 템플릿을 `app_en.arb`로 설정합니다.
   * Flutter에 `app_localizations.dart` 파일에서 현지화를 생성하도록 지시했습니다.

4. `${FLUTTER_PROJECT}/lib/l10n`에, `app_en.arb` 템플릿 파일을 추가합니다. 예를 들어:

   <?code-excerpt "gen_l10n_example/lib/l10n/app_en.arb" take="5" replace="/},/}\n}/g"?>
   ```json
   {
     "helloWorld": "Hello World!",
     "@helloWorld": {
       "description": "The conventional newborn programmer greeting"
     }
   }
   ```

5. 같은 디렉토리에 `app_es.arb`라는 또 다른 번들 파일을 추가합니다. 
   이 파일에, 같은 메시지의 스페인어 번역을 추가합니다.

   <?code-excerpt "gen_l10n_example/lib/l10n/app_es.arb"?>
   ```json
   {
       "helloWorld": "¡Hola Mundo!"
   }
   ```

6. 이제, `flutter pub get` 또는 `flutter run`을 실행하면, 코드 생성이 자동으로 진행됩니다. 
   생성된 파일은 `${FLUTTER_PROJECT}/.dart_tool/flutter_gen/gen_l10n`에서 찾을 수 있습니다. 
   또는, `flutter gen-l10n`을 실행하여 앱을 실행하지 않고도 동일한 파일을 생성할 수 있습니다.

7. `MaterialApp` 생성자에 대한 호출에서, 
   `app_localizations.dart` 및 `AppLocalizations.delegate`에 대한 import 문을 추가합니다.

   <?code-excerpt "gen_l10n_example/lib/main.dart (app-localizations-import)"?>
   ```dart
   import 'package:flutter_gen/gen_l10n/app_localizations.dart';
   ```

   <?code-excerpt "gen_l10n_example/lib/main.dart (material-app)"?>
   ```dart
   return const MaterialApp(
     title: 'Localizations Sample App',
     localizationsDelegates: [
       AppLocalizations.delegate, // 이 줄을 추가하세요
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
       GlobalCupertinoLocalizations.delegate,
     ],
     supportedLocales: [
       Locale('en'), // English
       Locale('es'), // Spanish
     ],
     home: MyHomePage(),
   );
   ```

   `AppLocalizations` 클래스는 자동 생성된 `localizationsDelegates` 및 `supportedLocales` 리스트도 제공합니다. 수동으로 제공하는 대신 이를 사용할 수 있습니다.

   <?code-excerpt "gen_l10n_example/lib/examples.dart (material-app)"?>
   ```dart
   const MaterialApp(
     title: 'Localizations Sample App',
     localizationsDelegates: AppLocalizations.localizationsDelegates,
     supportedLocales: AppLocalizations.supportedLocales,
   );
   ```

8. Material 앱이 시작되면, 앱의 어느 곳에서나 `AppLocalizations`를 사용할 수 있습니다.

   <?code-excerpt "gen_l10n_example/lib/main.dart (internationalized-title)"?>
   ```dart
   appBar: AppBar(
     // [AppBar] 제목 텍스트는 대상 플랫폼의 시스템 로케일에 따라 메시지를 업데이트해야 합니다.
     // 영어와 스페인어 로케일 간에 전환하면 이 텍스트가 업데이트되어야 합니다.
     title: Text(AppLocalizations.of(context)!.helloWorld),
   ),
   ```

   :::note
   Material 앱은 실제로 `AppLocalizations`를 초기화하기 위해 시작되어야 합니다. 
   앱이 아직 시작되지 않았다면, `AppLocalizations.of(context)!.helloWorld`는 null 예외를 발생시킵니다.
   :::

   이 코드는 대상 기기의 로케일이 영어로 설정된 경우, "Hello World!"를 표시하고, 
   대상 기기의 로케일이 스페인어로 설정된 경우, "¡Hola Mundo!"를 표시하는 `Text` 위젯을 생성합니다. 
   `arb` 파일에서, 각 엔트리의 키는 getter의 메서드 이름으로 사용되고, 해당 엔트리의 값에는 지역화된 메시지가 포함됩니다.

[`gen_l10n_example`][]은 이 도구를 사용합니다.

기기 앱 설명을 현지화하려면, 현지화된 문자열을 [`MaterialApp.onGenerateTitle`][]에 전달합니다.

<?code-excerpt "intl_example/lib/main.dart (app-title)"?>
```dart
return MaterialApp(
  onGenerateTitle: (context) => DemoLocalizations.of(context).title,
```

[App Resource Bundle]: {{site.github}}/google/app-resource-bundle
[`gen_l10n_example`]: {{site.repo.this}}/tree/{{site.branch}}/examples/internationalization/gen_l10n_example
[`MaterialApp.onGenerateTitle`]: {{site.api}}/flutter/material/MaterialApp/onGenerateTitle.html

### 플레이스홀더, 복수형(plurals) 및 선택(selects) {:#placeholders-plurals-and-selects}

:::tip
VS Code를 사용할 때, [arb-editor 확장][arb-editor extension]을 추가합니다. 
이 확장은 구문 강조, 스니펫, 진단 및 빠른 수정을 추가하여 `.arb` 템플릿 파일을 편집하는 데 도움이 됩니다.
:::

[arb-editor extension]: https://marketplace.visualstudio.com/items?itemName=Google.arb-editor

getter 대신 메서드를 생성하는 _placeholder_ 를 사용하는 특수 구문을 사용하여, 
메시지에 애플리케이션 값을 포함할 수도 있습니다. 
유효한 Dart 식별자 이름이어야 하는 placeholder는 `AppLocalizations` 코드에서 생성된 메서드의 위치 매개변수가 됩니다. 
다음과 같이 중괄호로 묶어 placeholder 이름을 정의합니다.

```json
"{placeholderName}"
```

앱의 `.arb` 파일에 있는 `placeholders` 객체에서 각 플레이스홀더를 정의합니다. 
예를 들어, `userName` 매개변수로 hello 메시지를 정의하려면, `lib/l10n/app_en.arb`에 다음을 추가합니다.

<?code-excerpt "gen_l10n_example/lib/l10n/app_en.arb" skip="5" take="10" replace="/},$/}/g"?>
```json
"hello": "Hello {userName}",
"@hello": {
  "description": "A message with a single parameter",
  "placeholders": {
    "userName": {
      "type": "String",
      "example": "Bob"
    }
  }
}
```

이 코드 조각은 `AppLocalizations.of(context)` 객체에 `hello` 메서드 호출을 추가하고, 
이 메서드는 `String` 타입의 매개변수를 받습니다. `hello` 메서드는 문자열을 반환합니다. 
`AppLocalizations` 파일을 다시 생성합니다.

`Builder`에 전달된 코드를 다음으로 바꿉니다.

<?code-excerpt "gen_l10n_example/lib/main.dart (placeholder)" remove="/wombat|Wombats|he'|they|pronoun/"?>
```dart
// 국제화된 문자열의 예.
return Column(
  children: <Widget>[
    // 'Hello John' 리턴
    Text(AppLocalizations.of(context)!.hello('John')),
  ],
);
```

숫자형 자리 표시자를 사용하여 여러 값을 지정할 수도 있습니다. 
언어마다 단어를 복수화하는 방법이 다릅니다. 
구문은 또한 단어를 복수화하는 _방법_ 을 지정하는 것을 지원합니다. 
_복수화 된_ 메시지에는 다양한 상황에서 단어를 복수화하는 방법을 나타내는 `num` 매개변수가 포함되어야 합니다. 

예를 들어, 영어는, "person"을 "people"로 복수화하지만, 이것만으로는 충분하지 않습니다. 
`message0` 복수형은 "no people" 또는 "zero people"일 수 있습니다. 
`messageFew` 복수형은 "several people", "some people" 또는 "a few people"일 수 있습니다. 
`messageMany` 복수형은 "most people" 또는 "many people" 또는 "a crowd"일 수 있습니다. 
보다 일반적인 `messageOther` 필드만 필요합니다. 다음 예는 사용 가능한 옵션을 보여줍니다.

```json
"{countPlaceholder, plural, =0{message0} =1{message1} =2{message2} few{messageFew} many{messageMany} other{messageOther}}"
```

이전 표현식은 `countPlaceholder`의 값에 해당하는 메시지 변형(`message0`, `message1`, ...)으로 대체됩니다. 
`messageOther` 필드만 필요합니다.

다음 예는, 단어 "wombat"을 복수형으로 표현하는 메시지를 정의합니다.

{% raw %}
<?code-excerpt "gen_l10n_example/lib/l10n/app_en.arb" skip="15" take="10" replace="/},$/}/g"?>
```json
"nWombats": "{count, plural, =0{no wombats} =1{1 wombat} other{{count} wombats}}",
"@nWombats": {
  "description": "A plural message",
  "placeholders": {
    "count": {
      "type": "num",
      "format": "compact"
    }
  }
}
```
{% endraw %}

`count` 매개변수를 전달하여 복수형 메서드를 사용합니다.

<?code-excerpt "gen_l10n_example/lib/main.dart (placeholder)" remove="/John|he|she|they|pronoun/" replace="/\[/[\n    .../g"?>
```dart
// 국제화된 문자열의 예.
return Column(
  children: <Widget>[
    ...
    // 'no wombats' 리턴
    Text(AppLocalizations.of(context)!.nWombats(0)),
    // '1 wombat' 리턴
    Text(AppLocalizations.of(context)!.nWombats(1)),
    // '5 wombats' 리턴
    Text(AppLocalizations.of(context)!.nWombats(5)),
  ],
);
```

복수형과 마찬가지로 `String` 플레이스홀더를 기반으로 값을 선택할 수도 있습니다. 
이는 성별 언어를 지원하는 데 가장 자주 사용됩니다. 구문은 다음과 같습니다.

```json
"{selectPlaceholder, select, case{message} ... other{messageOther}}"
```

다음 예에서는 성별에 따라 대명사를 선택하는 메시지를 정의합니다.

{% raw %}
<?code-excerpt "gen_l10n_example/lib/l10n/app_en.arb" skip="25" take="9" replace="/},$/}/g"?>
```json
"pronoun": "{gender, select, male{he} female{she} other{they}}",
"@pronoun": {
  "description": "A gendered message",
  "placeholders": {
    "gender": {
      "type": "String"
    }
  }
}
```
{% endraw %}

성별 문자열을 매개변수로 전달하여 이 기능을 사용합니다.

<?code-excerpt "gen_l10n_example/lib/main.dart (placeholder)" remove="/'He|hello|ombat/" replace="/\[/[\n    .../g"?>
```dart
// 국제화된 문자열의 예.
return Column(
  children: <Widget>[
    ...
    // 'he' 리턴
    Text(AppLocalizations.of(context)!.pronoun('male')),
    // 'she' 리턴
    Text(AppLocalizations.of(context)!.pronoun('female')),
    // 'they' 리턴
    Text(AppLocalizations.of(context)!.pronoun('other')),
  ],
);
```

`select` 문을 사용할 때, 매개변수와 실제 값의 비교는 대소문자를 구분한다는 점을 명심하세요. 
즉, `AppLocalizations.of(context)!.pronoun("Male")`는 기본적으로 "other" 케이스를 사용하고 "they"를 반환합니다.

### 이스케이핑 구문 {:#escaping-syntax}

때로는 `{` 및 `}`와 같은 토큰을 일반 문자로 사용해야 합니다. 
이러한 토큰이 구문 분석되는 것을 무시하려면, `l10n.yaml`에 다음을 추가하여 `use-escaping` 플래그를 활성화합니다.

```yaml
use-escaping: true
```

파서는 작은 따옴표 한 쌍으로 묶인 문자열을 무시합니다. 
일반적인 작은 따옴표 문자를 사용하려면, 연속된 작은 따옴표 한 쌍을 사용합니다. 
예를 들어, 다음 텍스트는 Dart `String`으로 변환됩니다.

```json
{
  "helloWorld": "Hello! '{Isn''t}' this a wonderful day?"
}
```

결과 문자열은 다음과 같습니다.

```dart
"Hello! {Isn't} this a wonderful day?"
```

### 숫자와 통화가 포함된 메시지 {:#messages-with-numbers-and-currencies}

(통화 가치를 나타내는 숫자를 포함하여) 숫자는 로케일마다 매우 다르게 표시됩니다. 
`flutter_localizations`의 지역화 생성 도구는 `intl` 패키지의 [`NumberFormat`]({{site.api}}/flutter/intl/NumberFormat-class.html) 클래스를 사용하여 로케일과 원하는 형식에 따라 숫자를 포맷합니다.

`int`, `double`, `number` 타입은 다음 `NumberFormat` 생성자를 사용할 수 있습니다.

| 메시지 "형식" 값   | 1200000에 대한 출력 |
|--------------------------|--------------------|
| `compact`                | "1.2M"             |
| `compactCurrency`*       | "$1.2M"            |
| `compactSimpleCurrency`* | "$1.2M"            |
| `compactLong`            | "1.2 million"      |
| `currency`*              | "USD1,200,000.00"  |
| `decimalPattern`         | "1,200,000"        |
| `decimalPatternDigits`*  | "1,200,000"        |
| `decimalPercentPattern`* | "120,000,000%"     |
| `percentPattern`         | "120,000,000%"     |
| `scientificPattern`      | "1E6"              |
| `simpleCurrency`*        | "$1,200,000"       |

{:.table .table-striped}

표에서 별표가 붙은 `NumberFormat` 생성자는 선택적(optional)이고, 명명된 매개변수를 제공합니다. 
이러한 매개변수는 플레이스홀더의 `optionalParameters` 객체의 값으로 지정할 수 있습니다. 
예를 들어, `compactCurrency`에 대한 선택적인(optional) `decimalDigits` 매개변수를 지정하려면, 
`lib/l10n/app_en.arg` 파일을 다음과 같이 변경합니다.

{% raw %}
<?code-excerpt "gen_l10n_example/lib/l10n/app_en.arb" skip="34" take="13" replace="/},$/}/g"?>
```json
"numberOfDataPoints": "Number of data points: {value}",
"@numberOfDataPoints": {
  "description": "A message with a formatted int parameter",
  "placeholders": {
    "value": {
      "type": "int",
      "format": "compactCurrency",
      "optionalParameters": {
        "decimalDigits": 2
      }
    }
  }
}
```
{% endraw %}

### 날짜가 포함된 메시지 {:#messages-with-dates}

날짜 문자열은 로케일과 앱의 요구 사항에 따라 여러 가지 다른 방식으로 포맷됩니다.

`DateTime` 타입의 플레이스홀더 값은 `intl` 패키지의 [`DateFormat`][]으로 포맷됩니다.

41개의 포맷 변형이 있으며, `DateFormat` 팩토리 생성자의 이름으로 식별됩니다. 
다음 예에서, `helloWorldOn` 메시지에 나타나는 `DateTime` 값은 `DateFormat.yMd`로 포맷됩니다.

```json
"helloWorldOn": "Hello World on {date}",
"@helloWorldOn": {
  "description": "A message with a date parameter",
  "placeholders": {
    "date": {
      "type": "DateTime",
      "format": "yMd"
    }
  }
}
```

로케일이 미국 영어인 앱에서, 다음 표현식은 "7/9/1959"를 생성합니다. 
러시아 로케일에서는, "9.07.1959"를 생성합니다.

```dart
AppLocalizations.of(context).helloWorldOn(DateTime.utc(1959, 7, 9))
```

[`DateFormat`]: {{site.api}}/flutter/intl/DateFormat-class.html

<a id="ios-specifics"></a>
### iOS에 대한 현지화: iOS 앱 번들 업데이트 {:#localizing-for-ios-updating-the-ios-app-bundle}

현지화는 Flutter에서 처리하지만, Xcode 프로젝트에서 지원되는 언어를 추가해야 합니다. 
이렇게 하면 App Store에서 항목이 지원되는 언어를 올바르게 표시합니다.

앱에서 지원하는 로케일을 구성하려면 다음 지침을 따르세요.

1. 프로젝트의 `ios/Runner.xcodeproj` Xcode 파일을 엽니다.

2. **Project Navigator**에서 **Projects** 아래에서, `Runner` 프로젝트 파일을 선택합니다.

3. 프로젝트 편집기에서 `Info` 탭을 선택합니다.

4. **Localizations** 섹션에서, `Add` 버튼(`+`)을 클릭하여 프로젝트에 지원되는 언어와 지역을 추가합니다. 
   파일과 참조 언어를 선택하라는 메시지가 표시되면, `Finish`를 선택하기만 하면 됩니다.

5. Xcode는 자동으로 빈 `.strings` 파일을 만들고 `ios/Runner.xcodeproj/project.pbxproj` 파일을 업데이트합니다. 
   이러한 파일은 App Store에서 앱이 지원하는 언어와 지역을 결정하는 데 사용됩니다.

<a id="advanced-customization"></a>
## 추가 커스터마이즈를 위한 고급 주제 {:#advanced-topics-for-further-customization}

이 섹션에서는 지역화된 Flutter 애플리케이션을 커스터마이즈하는 추가적인 방법을 다룹니다.

<a id="advanced-locale"></a>
### 고급 로케일 정의 {:#advanced-locale-definition}

여러 변형이 있는 일부 언어는 언어 코드만으로는 제대로 구별할 수 없습니다.

예를 들어, 중국어의 모든 변형을 완전히 구별하려면, 언어 코드, 스크립트 코드, 국가 코드를 지정해야 합니다. 
이는 간체 및 전통 스크립트가 존재하고, 동일한 스크립트 타입 내에서 문자를 쓰는 방식에 지역적 차이가 있기 때문입니다.

국가 코드 `CN`, `TW`, `HK`에 대한 모든 중국어 변형을 완전히 표현하려면, 지원되는 로케일 리스트에 다음이 포함되어야 합니다.

<?code-excerpt "gen_l10n_example/lib/examples.dart (supported-locales)"?>
```dart
supportedLocales: [
  Locale.fromSubtags(languageCode: 'zh'), // 일반 중국어 'zh'
  Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hans'), // 일반 간체 중국어 'zh_Hans'
  Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hant'), // 일반 중국어 번체 'zh_Hant'
  Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hans',
      countryCode: 'CN'), // 'zh_Hans_CN'
  Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hant',
      countryCode: 'TW'), // 'zh_Hant_TW'
  Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hant',
      countryCode: 'HK'), // 'zh_Hant_HK'
],
```

이 명시적인 전체 정의는, 앱이 이러한 국가 코드의 모든 조합을 구별하고, 완전히 미묘한 현지화된 콘텐츠를 제공할 수 있도록 보장합니다. 
사용자의 기본 로케일이 지정되지 않은 경우, Flutter는 가장 가까운 일치 항목을 선택하는데, 여기에는 사용자가 기대하는 것과 차이가 있을 가능성이 높습니다. 
Flutter는 `supportedLocales`에 정의된 로케일로만 해결하고, 
일반적으로 사용되는 언어에 대해 scriptCode로 구별된 현지화된 콘텐츠를 제공합니다. 
지원되는 로케일과 기본 로케일이 해결되는 방법에 대한 자세한 내용은 [`Localizations`][]를 참조하세요.

중국어가 주요 예이기는 하지만, 
프랑스어(`fr_FR`, `fr_CA`)와 같은 다른 언어도 더욱 미묘한 현지화를 위해 완전히 차별화해야 합니다.

[`Localizations`]: {{site.api}}/flutter/widgets/WidgetsApp/supportedLocales.html

<a id="tracking-locale"></a>
### 로케일 추적: Locale 클래스 및 Localizations 위젯 {:#tracking-the-locale-the-locale-class-and-the-localizations-widget}

[`Locale`][] 클래스는 사용자의 언어를 식별합니다. 
모바일 기기는 일반적으로 시스템 설정 메뉴를 사용하여, 모든 애플리케이션의 로케일을 설정하는 것을 지원합니다. 
국제화된 앱은 로케일별 값을 표시하여 응답합니다. 
예를 들어, 사용자가 기기의 로케일을 영어에서 프랑스어로 전환하면, 
원래 "Hello World"를 표시했던 `Text` 위젯이 "Bonjour le monde"로 다시 빌드됩니다.

[`Localizations`][widgets-global] 위젯은 자식의 로케일과 자식이 의존하는 지역화된 리소스를 정의합니다.
[`WidgetsApp`][] 위젯은 `Localizations` 위젯을 만들고, 시스템 로케일이 변경되면 다시 빌드합니다.

`Localizations.localeOf()`를 사용하여 항상 앱의 현재 로케일을 조회할 수 있습니다.

<?code-excerpt "gen_l10n_example/lib/examples.dart (my-locale)"?>
```dart
Locale myLocale = Localizations.localeOf(context);
```

[`Locale`]: {{site.api}}/flutter/dart-ui/Locale-class.html
[`WidgetsApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html
[widgets-global]: {{site.api}}/flutter/flutter_localizations/GlobalWidgetsLocalizations-class.html

<a id="specifying-supportedlocales"></a>
### 앱의 지원되는 Locales 매개변수 지정 {:#specifying-the-apps-supportedlocales-parameter}

`flutter_localizations` 라이브러리는 현재 {{languageCount}}개의 언어와 언어 변형을 지원하지만, 
기본적으로 영어 번역만 제공됩니다. 
정확히 어떤 언어를 지원할지는 개발자가 결정해야 합니다.

`MaterialApp` [`supportedLocales`][] 매개변수는 로케일 변경을 제한합니다. 
사용자가 기기에서 로케일 설정을 변경하면, 앱의 `Localizations` 위젯은 새 로케일이 이 리스트의 멤버인 경우에만 이를 따릅니다.
기기 로케일과 정확히 일치하는 항목이 없으면, 일치하는 [`languageCode`][]가 있는 첫 번째 지원 로케일이 사용됩니다. 
실패하면, `supportedLocales` 리스트의 첫 번째 요소가 사용됩니다.

다른 "로케일 해상도" 메서드를 사용하려는 앱은 [`localeResolutionCallback`][]을 제공할 수 있습니다. 
예를 들어, 앱이 사용자가 선택한 로케일을 무조건 수락하도록 하려면 다음을 수행합니다.

<?code-excerpt "gen_l10n_example/lib/examples.dart (locale-resolution)"?>
```dart
MaterialApp(
  localeResolutionCallback: (
    locale,
    supportedLocales,
  ) {
    return locale;
  },
);
```

[`languageCode`]: {{site.api}}/flutter/dart-ui/Locale/languageCode.html
[`localeResolutionCallback`]: {{site.api}}/flutter/widgets/LocaleResolutionCallback.html
[`supportedLocales`]: {{site.api}}/flutter/material/MaterialApp/supportedLocales.html

### l10n.yaml 파일 구성 {:#configuring-the-l10n-yaml-file}

`l10n.yaml` 파일을 사용하면 `gen-l10n` 도구를 구성하여 다음을 지정할 수 있습니다.

* 모든 입력 파일의 위치
* 모든 출력 파일을 만들어야 하는 위치
* 지역화 delegate 에게 제공할 Dart 클래스 이름

전체 옵션 리스트를 보려면, 명령줄에서 `flutter gen-l10n --help`를 실행하거나 다음 표를 참조하세요.

| 옵션                              | 설명 |
| ------------------------------------| ------------------ |
| `arb-dir`                           | 템플릿과 번역된 arb 파일이 있는 디렉토리입니다. 기본값은 `lib/l10n`입니다. |
| `output-dir`                        | 생성된 현지화 클래스가 작성되는 디렉토리입니다. 이 옵션은 Flutter 프로젝트의 다른 곳에 현지화 코드를 생성하려는 경우에만 관련이 있습니다. 또한 `synthetic-package` 플래그를 false로 설정해야 합니다.<br /><br />앱은 이 디렉토리에서 `output-localization-file` 옵션에 지정된 파일을 import 해야 합니다. 지정하지 않으면, `arb-dir`에 지정된 입력 디렉토리와 동일한 디렉토리가 기본값으로 지정됩니다. |
| `template-arb-file`                 | Dart 로컬라이제이션 및 메시지 파일을 생성하는 기반으로 사용되는 템플릿 arb 파일입니다. 기본값은 `app_en.arb`입니다. |
| `output-localization-file`          | 출력 로컬라이제이션 및 로컬라이제이션 delegate 클래스의 파일 이름입니다. 기본값은 `app_localizations.dart`입니다. |
| `untranslated-messages-file`        | 아직 번역되지 않은 지역화 메시지를 설명하는 파일의 위치입니다. 이 옵션을 사용하면, 대상 위치에 다음 형식으로 JSON 파일이 생성됩니다. <br /> <br />`"locale": ["message_1", "message_2" ... "message_n"]`<br /><br /> 이 옵션을 지정하지 않으면, 번역되지 않은 메시지의 요약이 명령줄에 출력됩니다. |
| `output-class`                      | 출력 로컬라이제이션 및 로컬라이제이션 delegate 클래스에 사용할 Dart 클래스 이름입니다. 기본값은 `AppLocalizations`입니다. |
| `preferred-supported-locales`       | 애플리케이션에 대한 기본 지원 로케일 리스트입니다. 기본적으로, 도구는 지원되는 로케일 리스트를 알파벳순으로 생성합니다. 이 플래그를 사용하여 다른 로케일로 기본 설정합니다.<br /><br />예를 들어, 장치가 지원하는 경우 `[ en_US ]`를 전달하여 미국 영어로 기본 설정합니다. |
| `header`                            | 생성된 Dart 현지화 파일에 추가할(prepend) 헤더입니다. 이 옵션은 문자열을 받습니다.<br /><br />예를 들어, `"/// 모든 현지화된 파일."`을 전달하여, 생성된 Dart 파일에 이 문자열을 추가(prepend)합니다.<br /><br />또는, `header-file` 옵션을 확인하여 긴 헤더의 경우 텍스트 파일을 전달합니다. |
| `header-file`                       | 생성된 Dart 로컬라이제이션 파일에 추가(prepend)할 헤더입니다. 이 옵션의 값은 생성된 각 Dart 파일의 맨 위에 삽입되는 헤더 텍스트를 포함하는 파일의 이름입니다. <br /><br /> 또는, `header` 옵션을 확인하여 더 간단한 헤더에 대한 문자열을 전달합니다.<br /><br />이 파일은 `arb-dir`에 지정된 디렉토리에 배치해야 합니다. |
| `[no-]use-deferred-loading`         | 지연된(deferred) 로케일로 import한 Dart 현지화 파일을 생성할지 여부를 지정하여, Flutter 웹에서 각 로케일의 지연 로딩(lazy loading)을 허용합니다.<br /><br />이렇게 하면 JavaScript 번들의 크기를 줄여 웹 앱의 초기 시작 시간을 줄일 수 있습니다. 이 플래그를 true로 설정하면, 특정 로케일의 메시지는 필요에 따라 Flutter 앱에서만 다운로드하고 로드합니다. 다양한 로케일과 많은 현지화 문자열이 있는 프로젝트의 경우, 로딩을 지연하면 성능이 향상될 수 있습니다. 로케일 수가 적은 프로젝트의 경우, 차이가 미미하여, 나머지 애플리케이션과 현지화를 번들링하는 것에 비해 시작 속도가 느려질 수 있습니다.<br /><br />이 플래그는 모바일이나 데스크톱과 같은 다른 플랫폼에는 영향을 미치지 않습니다. |
| `gen-inputs-and-outputs-list`      | 지정된 경우, 도구는 도구의 입력 및 출력을 포함하는 JSON 파일을 생성하며, 이름은 `gen_l10n_inputs_and_outputs.json`입니다.<br /><br />이것은 최신 로컬라이제이션 세트를 생성할 때, Flutter 프로젝트의 어떤 파일을 사용했는지 추적하는 데 유용할 수 있습니다. 예를 들어, Flutter 도구의 빌드 시스템은 이 파일을 사용하여 핫 리로드 중에 gen_l10n을 호출할 시기를 추적합니다.<br /><br />이 옵션의 값은 JSON 파일이 생성되는 디렉토리입니다. null인 경우 JSON 파일이 생성되지 않습니다. |
| `synthetic-package`                 | 생성된 출력 파일을 합성(synthetic) 패키지로 생성할지 아니면, Flutter 프로젝트의 지정된 디렉토리에 생성할지 여부를 결정합니다. 이 플래그는 기본적으로 `true`입니다. `synthetic-package`가 `false`로 설정되면, 기본적으로 `arb-dir`로 지정된 디렉토리에 로컬라이제이션 파일을 생성합니다. `output-dir`이 지정되면, 해당 디렉토리에 파일이 생성됩니다. |
| `project-dir`                       | 이 옵션이 지정되면, 도구는 이 옵션으로 전달된 경로를 루트 Flutter 프로젝트의 디렉토리로 사용합니다.<br /><br />null인 경우, 현재 작업 디렉토리에 대한 상대 경로가 사용됩니다. |
| `[no-]required-resource-attributes` | 모든 리소스 ID에 해당 리소스 속성이 포함되어야 합니다.<br /><br />기본적으로, 간단한 메시지에는 메타데이터가 필요하지 않지만, 이는 독자에게 메시지의 의미에 대한 컨텍스트를 제공하므로 적극 권장됩니다.<br /><br />복수형 메시지에도 리소스 속성이 필요합니다. |
| `[no-]nullable-getter`              | 로컬라이제이션 클래스 getter가 null 허용(nullable)인지 여부를 지정합니다.<br /><br />기본적으로, 이 값은 true이므로, `Localizations.of(context)`는 이전 버전과의 호환성을 위해 null 허용 값을 반환합니다. 이 값이 false이면, `Localizations.of(context)`의 반환 값에 대해 null 검사가 수행되어, 사용자 코드에서 null 검사가 필요 없게 됩니다. |
| `[no-]format`                       | 이 옵션을 지정하면 현지화 파일을 생성한 후 `dart format` 명령이 실행됩니다. |
| `use-escaping`                      | 작은따옴표를 이스케이프 구문으로 사용할지 여부를 지정합니다. |
| `[no-]suppress-warnings`            | 이 값을 지정하면 모든 경고가 억제(suppressed)됩니다. |
| `[no-]relax-syntax`                 | 이 옵션을 지정하면, 구문이 완화되어, 특수 문자 "{"는 유효한 자리 표시자가 따르지 않으면 문자열로 처리되고, 이전에 특수 문자로 처리된 "{"를 닫지 않으면 "}"가 문자열로 처리됩니다. |
| `[no-]use-named-parameters`         | 생성된 지역화 방법에 명명된 매개변수를 사용할지 여부입니다. |

{:.table .table-striped}


## Flutter에서 국제화가 작동하는 방식 {:#how-internationalization-in-flutter-works}

이 섹션에서는 Flutter에서 로컬라이제이션이 작동하는 방식에 대한 기술적 세부 사항을 다룹니다. 
고유한 로컬라이제이션 메시지 세트를 지원하려는 경우, 다음 내용이 도움이 될 것입니다. 
그렇지 않은 경우, 이 섹션을 건너뛸 수 있습니다.

<a id="loading-and-retrieving"></a>
### 지역화된 값 로드 및 검색 {:#loading-and-retrieving-localized-values}

`Localizations` 위젯은 지역화된 값의 컬렉션을 포함하는 객체를 로드하고 조회하는 데 사용됩니다. 
앱은 이러한 객체를 [`Localizations.of(context,type)`][]로 참조합니다. 
기기의 로케일이 변경되면, `Localizations` 위젯은 새 로케일에 대한 값을 자동으로 로드한 다음, 이를 사용한 위젯을 다시 빌드합니다. 
이는 `Localizations`가 [`InheritedWidget`][]처럼 작동하기 때문입니다. 
빌드 함수가 상속된 위젯을 참조하면, 상속된 위젯에 대한 암묵적 종속성이 생성됩니다. 
상속된 위젯이 변경되면(`Localizations` 위젯의 로케일이 변경되면), 종속 컨텍스트가 다시 빌드됩니다.

지역화된 값은 `Localizations` 위젯의 [`LocalizationsDelegate`][] 리스트에 의해 로드됩니다. 
각 delegate는 지역화된 값의 컬렉션을 캡슐화하는 객체를 생성하는 비동기 [`load()`][] 메서드를 정의해야 합니다. 
일반적으로 이러한 객체는 지역화된 값당 하나의 메서드를 정의합니다.

대규모 앱에서는, 다양한 모듈이나 패키지가 자체 로컬라이제이션과 함께 번들로 제공될 수 있습니다. 
이것이 `Localizations` 위젯이 `LocalizationsDelegate`당 하나씩 객체 테이블을 관리하는 이유입니다. `LocalizationsDelegate`의 `load` 메서드 중 하나에서 생성된 객체를 검색하려면, 
`BuildContext`와 객체의 타입을 지정합니다.

예를 들어, Material Components 위젯의 로컬라이제이션된 문자열은 [`MaterialLocalizations`][] 클래스에서 정의합니다. 
이 클래스의 인스턴스는 [`MaterialApp`][] 클래스에서 제공하는 `LocalizationDelegate`에서 생성됩니다. 
`Localizations.of()`로 검색할 수 있습니다.

```dart
Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
```

이 특정 `Localizations.of()` 표현식은 자주 사용되므로, `MaterialLocalizations` 클래스는 편리한 단축형을 제공합니다.

```dart
static MaterialLocalizations of(BuildContext context) {
  return Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
}

/// MaterialLocalizations에서 정의한 지역화된 값에 대한 참조는 일반적으로 다음과 같이 작성됩니다.

tooltip: MaterialLocalizations.of(context).backButtonTooltip,
```

[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[`load()`]: {{site.api}}/flutter/widgets/LocalizationsDelegate/load.html
[`LocalizationsDelegate`]: {{site.api}}/flutter/widgets/LocalizationsDelegate-class.html
[`Localizations.of(context,type)`]: {{site.api}}/flutter/widgets/Localizations/of.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`MaterialLocalizations`]: {{site.api}}/flutter/material/MaterialLocalizations-class.html

<a id="defining-class"></a>
### 앱의 지역화된 리소스에 대한 클래스 정의 {:#defining-a-class-for-the-apps-localized-resources}

국제화된 Flutter 앱을 구성하는 것은 일반적으로 앱의 현지화된 값을 캡슐화하는 클래스부터 시작합니다. 
다음 예는 이러한 클래스의 전형입니다.

이 앱의 [`intl_example`][]에 대한 전체 소스 코드.

이 예는 [`intl`][] 패키지에서 제공하는 API와 도구를 기반으로 합니다. 
[앱의 현지화된 리소스에 대한 대체 클래스](#alternative-class) 섹션에서는 `intl` 패키지에 의존하지 않는 [예제][an example]를 설명합니다.

`DemoLocalizations` 클래스(다음 코드 조각에 정의됨)에는 앱이 지원하는 로케일로 변환된 앱의 문자열(예제의 경우 하나만 해당)이 포함되어 있습니다. 
Dart의 [`intl`][] 패키지에서 생성된 `initializeMessages()` 함수인 [`Intl.message()`][]를 사용하여 이를 조회합니다.

<?code-excerpt "intl_example/lib/main.dart (demo-localizations)"?>
```dart
class DemoLocalizations {
  DemoLocalizations(this.localeName);

  static Future<DemoLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null || locale.countryCode!.isEmpty
            ? locale.languageCode
            : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return DemoLocalizations(localeName);
    });
  }

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations)!;
  }

  final String localeName;

  String get title {
    return Intl.message(
      'Hello World',
      name: 'title',
      desc: 'Title for the Demo application',
      locale: localeName,
    );
  }
}
```

`intl` 패키지를 기반으로 하는 클래스는 `initializeMessages()` 함수와 `Intl.message()`에 대한 로케일별 백업 저장소를 제공하는 생성된 메시지 카탈로그를 가져옵니다. 
메시지 카탈로그는 `Intl.message()` 호출을 포함하는 클래스의 소스 코드를 분석하는 [`intl` 도구](#dart-tools)에 의해 생성됩니다. 
이 경우에는 `DemoLocalizations` 클래스가 됩니다.

[an example]: {{site.repo.this}}/tree/{{site.branch}}/examples/internationalization/minimal
[`intl`]: {{site.pub-pkg}}/intl
[`Intl.message()`]: {{site.pub-api}}/intl/latest/intl/Intl/message.html

<a id="adding-language"></a>
### 새 언어에 대한 지원 추가 {:#adding-support-for-a-new-language}

[`GlobalMaterialLocalizations`][]에 포함되지 않은 언어를 지원해야 하는 앱은 몇 가지 추가 작업을 해야 합니다. 
즉, 단어나 구문에 대한 약 70개의 번역("로컬라이제이션")과 로케일의 날짜 패턴 및 기호를 제공해야 합니다.

노르웨이 니노르스크어(Norwegian Nynorsk)에 대한 지원을 추가하는 방법의 예는 다음을 참조하세요.

새로운 `GlobalMaterialLocalizations` 하위 클래스는 Material 라이브러리가 종속된 로컬라이제이션을 정의합니다. 
`GlobalMaterialLocalizations` 하위 클래스의 팩토리 역할을 하는 새로운 `LocalizationsDelegate` 하위 클래스도 정의해야 합니다.

실제 니노르스크어 번역을 제외한, 전체 [`add_language`][] 예제의 소스 코드는 다음과 같습니다.

로케일별 `GlobalMaterialLocalizations` 하위 클래스는 `NnMaterialLocalizations`라고 하며, 
`LocalizationsDelegate` 하위 클래스는 `_NnMaterialLocalizationsDelegate`입니다. `NnMaterialLocalizations.delegate`의 값은 delegate의 인스턴스이며, 이러한 지역화를 사용하는 앱에 필요한 전부입니다.

delegate 클래스에는 기본 날짜 및 숫자 형식 지역화가 포함됩니다. 
다른 모든 지역화는 다음과 같이 `NnMaterialLocalizations`의 `String` 값 속성 getters로 정의됩니다.

<?code-excerpt "add_language/lib/nn_intl.dart (getters)"?>
```dart
@override
String get moreButtonTooltip => r'More';

@override
String get aboutListTileTitleRaw => r'About $applicationName';

@override
String get alertDialogLabel => r'Alert';
```

물론, 이는 영어 번역입니다. 작업을 완료하려면, 각 getter의 반환 값을 적절한 니노르스크어 문자열로 변경해야 합니다.

getter는 `r'About $applicationName'`과 같이 `r` 접두사가 있는 "raw" Dart 문자열을 반환합니다. 
이는 때때로 문자열에 `$` 접두사가 있는 변수가 포함되기 때문입니다. 
변수는 매개변수화된 지역화 메서드에 의해 확장됩니다.

<?code-excerpt "add_language/lib/nn_intl.dart (raw)"?>
```dart
@override
String get pageRowsInfoTitleRaw => r'$firstRow–$lastRow of $rowCount';

@override
String get pageRowsInfoTitleApproximateRaw =>
    r'$firstRow–$lastRow of about $rowCount';
```

또한 로케일의 날짜 패턴과 기호도 지정해야 합니다. 이는 소스 코드에 다음과 같이 정의되어 있습니다.

{% comment %}
RegEx adds last two lines with commented out code and closing bracket.
{% endcomment %}

<?code-excerpt "add_language/lib/nn_intl.dart (date-patterns)" replace="/  'LLL': 'LLL',/  'LLL': 'LLL',\n  \/\/ ...\n}/g"?>
```dart
const nnLocaleDatePatterns = {
  'd': 'd.',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
  // ...
}
```

{% comment %}
RegEx adds last two lines with commented out code and closing bracket.
{% endcomment %}

<?code-excerpt "add_language/lib/nn_intl.dart (date-symbols)" replace="/  ],/  ],\n  \/\/ ...\n}/g"?>
```dart
const nnDateSymbols = {
  'NAME': 'nn',
  'ERAS': <dynamic>[
    'f.Kr.',
    'e.Kr.',
  ],
  // ...
}
```

이러한 값은 로케일이 올바른 날짜 형식을 사용하도록 수정해야 합니다. 
불행히도, `intl` 라이브러리는 숫자 형식에 대해 동일한 유연성을 공유하지 않으므로, 
기존 로케일의 형식은 `_NnMaterialLocalizationsDelegate`에서 대체 형식으로 사용해야 합니다.

<?code-excerpt "add_language/lib/nn_intl.dart (delegate)"?>
```dart
class _NnMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _NnMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'nn';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String localeName = intl.Intl.canonicalizedLocale(locale.toString());

    // 로케일(이 경우 `nn`)은 Flutter가 사용하는 커스텀 날짜 기호 및 패턴 설정으로 초기화되어야 합니다.
    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: localeName,
      patterns: nnLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(nnDateSymbols),
    );

    return SynchronousFuture<MaterialLocalizations>(
      NnMaterialLocalizations(
        localeName: localeName,
        // `intl` 라이브러리의 NumberFormat 클래스는 CLDR 데이터로부터 생성됩니다.
        // (https://github.com/dart-lang/i18n/blob/main/pkgs/intl/lib/number_symbols_data.dart 참조)
        // 불행히도, 이 맵에 정의되지 않은 로케일을 사용할 방법은 없으며, 
        // 이를 해결할 수 있는 유일한 방법은 나열된 로케일의 NumberFormat 심볼을 사용하는 것입니다. 
        // 따라서, 여기서는 대신 'en_US'의 숫자 형식을 사용합니다.
        decimalFormat: intl.NumberFormat('#,##0.###', 'en_US'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en_US'),
        // 여기의 DateFormat은 위의 `date_symbol_data_custom.initializeDateFormattingCustom` 
        // 호출에서 제공된 심볼과 패턴을 사용합니다. 
        // 그러나, 대안은 위의 NumberFormat과 유사하게 지원되는 로케일의 DateFormat 심볼을 사용하는 것입니다.
        fullYearFormat: intl.DateFormat('y', localeName),
        compactDateFormat: intl.DateFormat('yMd', localeName),
        shortDateFormat: intl.DateFormat('yMMMd', localeName),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', localeName),
        longDateFormat: intl.DateFormat('EEEE, MMMM d, y', localeName),
        yearMonthFormat: intl.DateFormat('MMMM y', localeName),
        shortMonthDayFormat: intl.DateFormat('MMM d'),
      ),
    );
  }

  @override
  bool shouldReload(_NnMaterialLocalizationsDelegate old) => false;
}
```

지역화 문자열에 대한 자세한 내용은, [flutter_localizations README][]를 확인하세요.

`GlobalMaterialLocalizations` 및 `LocalizationsDelegate`의 언어별 하위 클래스를 구현했으면, 
앱에 언어와 delegate 인스턴스를 추가해야 합니다. 
다음 코드는 앱의 언어를 니노르스크어로 설정하고, 
`NnMaterialLocalizations` delegate 인스턴스를 앱의 `localizationsDelegates` 리스트에 추가합니다.

<?code-excerpt "add_language/lib/main.dart (material-app)"?>
```dart
const MaterialApp(
  localizationsDelegates: [
    GlobalWidgetsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    NnMaterialLocalizations.delegate, // 새로 생성된 delegate를 추가합니다.
  ],
  supportedLocales: [
    Locale('en', 'US'),
    Locale('nn'),
  ],
  home: Home(),
),
```

[`add_language`]: {{site.repo.this}}/tree/{{site.branch}}/examples/internationalization/add_language/lib/main.dart

[flutter_localizations README]: {{site.repo.flutter}}/blob/master/packages/flutter_localizations/lib/src/l10n/README.md
[`GlobalMaterialLocalizations`]: {{site.api}}/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html

## 대체 국제화 워크플로 {:#alternative-internationalization-workflows}

이 섹션에서는 Flutter 애플리케이션을 국제화하는 다양한 접근 방식을 설명합니다.

<a id="alternative-class"></a>
### 앱의 지역화된 리소스에 대한 대체 클래스 {:#an-alternative-class-for-the-apps-localized-resources}

이전 예제는 Dart `intl` 패키지의 관점에서 정의되었습니다. 
단순성을 위해 또는 다른 i18n 프레임워크와 통합하기 위해 지역화된 값을 관리하기 위한 고유한 접근 방식을 선택할 수 있습니다.

[`minimal`][] 앱의 전체 소스 코드.

다음 예제에서, `DemoLocalizations` 클래스는 모든 번역을 언어별 맵에 직접 포함합니다.

<?code-excerpt "minimal/lib/main.dart (demo)"?>
```dart
class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'title': 'Hello World',
    },
    'es': {
      'title': 'Hola Mundo',
    },
  };

  static List<String> languages() => _localizedValues.keys.toList();

  String get title {
    return _localizedValues[locale.languageCode]!['title']!;
  }
}
```

minimal 앱에서, `DemoLocalizationsDelegate`는 약간 다릅니다. 
`load` 메서드는 비동기 로딩이 발생할 필요가 없기 때문에, [`SynchronousFuture`][]를 반환합니다.

<?code-excerpt "minimal/lib/main.dart (delegate)"?>
```dart
class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      DemoLocalizations.languages().contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    // DemoLocalizations 인스턴스를 생성하는 데 async "로드" 작업이 필요하지 않으므로, 
    // 여기서는 SynchronousFuture를 반환합니다.
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
```

[`SynchronousFuture`]: {{site.api}}/flutter/foundation/SynchronousFuture-class.html

<a id="dart-tools"></a>
### Dart intl 도구 사용 {:#using-the-dart-intl-tools}

Dart [`intl`][] 패키지를 사용하여 API를 빌드하기 전에, `intl` 패키지의 문서를 검토하세요. 
다음 리스트는 `intl` 패키지에 의존하는 앱을 현지화하는 프로세스를 요약한 것입니다.

데모 앱은 `l10n/messages_all.dart`라는 생성된 소스 파일에 의존하며, 
이 파일은 앱에서 사용하는 모든 현지화 가능한 문자열을 정의합니다.

`l10n/messages_all.dart`를 다시 빌드하려면, 두 단계가 필요합니다.

 1. 앱의 루트 디렉토리를 현재 디렉토리로 지정하고, `lib/main.dart`에서 `l10n/intl_messages.arb`를 생성합니다.

    ```console
    $ dart run intl_translation:extract_to_arb --output-dir=lib/l10n lib/main.dart
    ```

    `intl_messages.arb` 파일은 `main.dart`에 정의된 각 `Intl.message()` 함수에 대한 엔트리가 
    하나씩 있는 JSON 형식 맵입니다. 
    이 파일은 영어와 스페인어 번역인 `intl_en.arb`와 `intl_es.arb`의 템플릿 역할을 합니다. 
    이러한 번역은 개발자인 여러분이 만듭니다.

 2. 앱의 루트 디렉토리를 현재 디렉토리로 지정하고, 각 `intl_<locale>.arb` 파일에 대해, 
    `intl_messages_<locale>.dart`와 모든 메시지 파일을 import 하는 `intl_messages_all.dart`를 생성합니다.

    ```console
    $ dart run intl_translation:generate_from_arb \
        --output-dir=lib/l10n --no-use-deferred-loading \
        lib/main.dart lib/l10n/intl_*.arb
    ```

    **_Windows에서는 파일 이름 와일드카드를 지원하지 않습니다._** 
    대신, `intl_translation:extract_to_arb` 명령으로 생성된 .arb 파일을 나열하세요.

    ```console
    $ dart run intl_translation:generate_from_arb \
        --output-dir=lib/l10n --no-use-deferred-loading \
        lib/main.dart \
        lib/l10n/intl_en.arb lib/l10n/intl_fr.arb lib/l10n/intl_messages.arb
    ```

    `DemoLocalizations` 클래스는 생성된 `initializeMessages()` 함수(`intl_messages_all.dart`에 정의됨)를 사용하여, 지역화된 메시지를 로드하고 `Intl.message()`를 사용하여 해당 메시지를 조회합니다.

## 더 많은 정보 {:#more-information}

코드를 읽는 것으로 가장 잘 배울 수 있다면, 다음 예제를 확인하세요.

* [`minimal`][]<br>
  `minimal` 예제는 가능한 한 간단하게 설계되었습니다.
* [`intl_example`][]<br>
  [`intl`][] 패키지에서 제공하는 API와 도구를 사용합니다.

Dart의 `intl` 패키지가 처음이라면, [Dart intl 도구 사용](#dart-tools)을 확인하세요.

[`intl_example`]: {{site.repo.this}}/tree/{{site.branch}}/examples/internationalization/intl_example
[`minimal`]: {{site.repo.this}}/tree/{{site.branch}}/examples/internationalization/minimal

