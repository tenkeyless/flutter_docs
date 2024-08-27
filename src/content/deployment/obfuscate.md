---
# title: Obfuscate Dart code
title: Dart 코드 난독화(Obfuscate)
# description: How to remove function and class names from your Dart binary.
description: Dart 바이너리에서 함수 및 클래스 이름을 제거하는 방법.
---

<?code-excerpt path-base="deployment/obfuscate"?>

## 코드 난독화(code obfuscation)란 무엇인가요? {:#what-is-code-obfuscation}

[코드 난독화][Code obfuscation]는 앱의 바이너리를 수정하여 사람이 이해하기 어렵게 만드는 프로세스입니다. 
난독화는 컴파일된 Dart 코드에서 함수 및 클래스 이름을 숨기고, 
각 심볼을 다른 심볼로 대체하여, 공격자가 독점 앱을 리버스 엔지니어링하기 어렵게 만듭니다.

**Flutter의 코드 난독화는 [릴리스 빌드][release build]에서만 작동합니다.**

[Code obfuscation]: https://en.wikipedia.org/wiki/Obfuscation_(software)
[release build]: /testing/build-modes#release

## 제한 사항 {:#limitations}

코드를 난독화해도 리소스는 _암호화되지 않고_ 역공학으로부터 보호되지도 않습니다. 
더 모호한 이름을 가진 심볼의 이름만 바꿉니다.

:::warning
앱에 비밀을 저장하는 것은 **보안에 좋지 않은 관행**입니다.
:::

## 지원되는 대상 {:#supported-targets}

다음 빌드 대상은 이 페이지에 설명된 난독화 프로세스를 지원합니다.

* `aar`
* `apk`
* `appbundle`
* `ios`
* `ios-framework`
* `ipa`
* `linux`
* `macos`
* `macos-framework`
* `windows`

:::note
웹 앱은 난독화를 지원하지 않습니다. 웹 앱은 [축소화(minified)][minified]될 수 있으며, 
이는 유사한 결과를 제공합니다. 
Flutter 웹 앱의 릴리스 버전을 빌드하면, 웹 컴파일러가 앱을 축소합니다. 
자세한 내용은 [웹 앱 빌드 및 릴리스][Build and release a web app]를 참조하세요.
:::

[Build and release a web app]: /deployment/web
[minified]: https://en.wikipedia.org/wiki/Minification_(programming)

## 앱을 난독화하세요 {:#obfuscate-your-app}

앱을 난독화하려면, 릴리스 모드에서 `flutter build` 명령을 `--obfuscate` 및 `--split-debug-info` 옵션과 함께 사용합니다. 
`--split-debug-info` 옵션은 Flutter가 디버그 파일을 출력하는 디렉토리를 지정합니다. 
`--obfuscate`의 경우, 심볼 맵을 출력합니다. 예를 들어:

```console
$ flutter build apk --obfuscate --split-debug-info=/<project-name>/<directory>
```

바이너리를 난독화한 후, **심볼 파일을 저장하세요**. 
나중에 스택 추적을 난독화 해제(de-obfuscate)하려면 이 파일이 필요합니다.

:::tip
`--split-debug-info` 옵션은 `--obfuscate` 없이도 사용할 수 있으며, 
Dart 프로그램 심볼을 추출하여 코드 크기를 줄일 수 있습니다. 
앱 크기에 대해 자세히 알아보려면 [앱 크기 측정][Measuring your app's size]을 참조하세요.
:::

[Measuring your app's size]: /perf/app-size

이러한 플래그에 대한 자세한 내용을 보려면 다음과 같이 특정 대상에 대한 help 명령을 실행하세요.

```console
$ flutter build apk -h
```

이러한 플래그가 출력에 나열되지 않으면, `flutter --version`을 실행하여 Flutter 버전을 확인하세요.

## 난독화된 스택 추적 읽기 {:#read-an-obfuscated-stack-trace}

난독화된 앱에서 생성된 스택 추적을 디버깅하려면, 다음 단계를 사용하여, 사람이 읽을 수 있도록 만드세요.

1. 일치하는 심볼 파일을 찾으세요. 
   예를 들어, Android arm64 기기에서 크래시가 발생하면 `app.android-arm64.symbols`가 필요합니다.

2. 스택 추적(파일에 저장됨)과 심볼 파일을 모두 `flutter symbolize` 명령에 제공합니다. 예를 들어:

   ```console
   $ flutter symbolize -i <stack trace file> -d out/android/app.android-arm64.symbols
   ```

   `symbolize` 명령에 대한 자세한 내용을 보려면, `flutter symbolize -h`를 실행하세요.

## 난독화된 이름 읽기 {:#read-an-obfuscated-name}

앱의 이름을 human readable로 난독화하려면, 다음 단계를 따르세요.

1. 앱 빌드 시 이름 난독화 맵을 저장하려면,      
   `--extra-gen-snapshot-options=--save-obfuscation-map=/<your-path>`를 사용합니다. 
   예를 들어:

   ```console
   $ flutter build apk --obfuscate --split-debug-info=/<project-name>/<directory> --extra-gen-snapshot-options=--save-obfuscation-map=/<your-path>
   ```
2. 이름을 복구하려면, 생성된 난독화 맵을 사용합니다.
   난독화 맵은 원본 이름과 난독화된 이름의 쌍이 있는 플랫 JSON 배열입니다. 
   예를 들어, `["MaterialApp", "ex", "Scaffold", "ey"]`, 
   여기서 `ex`는 `MaterialApp`의 난독화된 이름입니다.

## 경고(Caveat) {:#caveat}

결국 난독화된 바이너리가 될 앱을 코딩할 때는 다음 사항에 유의하세요.

* 특정 클래스, 함수 또는 라이브러리 이름과 일치하는 코드는 실패합니다. 
  예를 들어, `expect()`에 대한 다음 호출은 난독화된 바이너리에서 작동하지 않습니다.

<?code-excerpt "lib/main.dart (Expect)"?>
```dart
expect(foo.runtimeType.toString(), equals('Foo'));
```

* 열거형 이름은 현재 난독화되지 않습니다.
