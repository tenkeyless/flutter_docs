---
# title: Flutter fix
title: Flutter fix
# description: Keep your code up to date with the help of the Flutter Fix feature.
description: Flutter Fix 기능을 사용하여 코드를 최신 상태로 유지하세요.
---

Flutter가 계속 진화함에 따라, 
우리는 코드베이스에서 deprecated API를 정리하는 데 도움이 되는 도구를 제공합니다. 
이 도구는 Flutter의 일부로 제공되며, 코드에 적용할 수 있는 변경 사항을 제안합니다. 
이 도구는 명령줄에서 사용할 수 있으며, 
Android Studio 및 Visual Studio Code용 IDE 플러그인에도 통합되어 있습니다.

:::tip
이러한 자동화된 업데이트는 IntelliJ 및 Android Studio에서는 _quick-fixes_ 이라고 하고, 
VS Code에서는 _code actions_ 이라고 합니다.
:::

## 개별 fix 적용 {:#applying-individual-fixes}

지원되는 IDE를 사용하여 한 번에 하나의 fix를 적용할 수 있습니다.

### IntelliJ 및 Android Studio {:#intellij-and-android-studio}

When the analyzer detects a deprecated API, a light bulb appears on that line of code. Clicking the light bulb displays the suggested fix that updates that code to the new API. Clicking the suggested fix performs the update.

분석기가 deprecated API를 감지하면, 해당 코드 줄에 전구가 나타납니다. 
전구를 클릭하면, 해당 코드를 새 API로 업데이트하는 제안된 수정 사항이 표시됩니다. 
제안된 수정 사항을 클릭하면, 업데이트가 수행됩니다.

![Screenshot showing suggested change in IntelliJ](/assets/images/docs/development/tools/flutter-fix-suggestion-intellij.png)<br>
IntelliJ에서의 샘플 quick-fix

### VS Code {:#vs-code}

분석기가 deprecated API를 감지하면, 오류를 표시합니다. 다음 중 하나를 수행할 수 있습니다.

* 오류 위에 마우스를 올려놓고 **Quick Fix** 링크를 클릭합니다. 
  이렇게 하면 _오직_ fix만 표시하는 필터링된 리스트가 표시됩니다.

* 오류가 있는 코드에 캐럿(caret)을 넣고 나타나는 전구 아이콘을 클릭합니다. 
  리팩터링을 포함한 모든 작업 리스트가 표시됩니다.

* 오류가 있는 코드에 캐럿(caret)을 넣고 단축키(macOS에서는 **Command+.**, 그 외의 경우 **Control+.**)를 누릅니다. 
  리팩터링을 포함한 모든 작업 리스트가 표시됩니다.

![Screenshot showing suggested change in VS Code](/assets/images/docs/development/tools/flutter-fix-suggestion-vscode.png)<br>
VS Code의 샘플 code action

## 프로젝트 전체 fix 적용 {:#applying-project-wide-fixes}

[dart fix Flutter 디코딩][dart fix Decoding Flutter]

전체 프로젝트에 대한 변경 사항을 보거나 적용하려면, 명령줄 도구인 [`dart fix`][]를 사용할 수 있습니다.

이 도구에는 두 가지 옵션이 있습니다.

* 사용 가능한 변경 사항의 전체 리스트를 보려면, 다음 명령을 실행하세요.

  ```console
  $ dart fix --dry-run
  ```

* 모든 변경 사항을 대량으로 적용하려면, 다음 명령을 실행하세요.

  ```console
  $ dart fix --apply
  ```

Flutter deprecations에 대한 자세한 내용은, 
Flutter의 Medium 게시물에 있는 무료 글 [Flutter의 Deprecation 수명][Deprecation lifetime in Flutter]을 참조하세요.

[Deprecation lifetime in Flutter]: {{site.flutter-medium}}/deprecation-lifetime-in-flutter-e4d76ee738ad
[`dart fix`]: {{site.dart-site}}/tools/dart-fix
[dart fix Decoding Flutter]: {{site.yt.watch}}?v=OBIuSrg_Quo
