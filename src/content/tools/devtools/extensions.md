---
# title: DevTools extensions
title: DevTools 확장 프로그램
# description: Learn how to use and build DevTools extensions.
description: DevTools 확장 기능을 사용하고 빌드하는 방법을 알아보세요.
---

## DevTools 확장 프로그램은 무엇인가요? {:#what-are-devtools-extensions}

[DevTools 확장][DevTools extensions]은 DevTools 툴링 모음에 긴밀하게 통합된, 
타사 패키지에서 제공하는 개발자 도구입니다. 
확장은 pub 패키지의 일부로 배포되며, 사용자가 앱을 디버깅할 때 DevTools에 동적으로 로드됩니다.

[DevTools extensions]: {{site.pub-pkg}}/devtools_extensions

## DevTools 확장 프로그램 사용 {:#use-a-devtools-extension}

앱이 DevTools 확장 기능을 제공하는 패키지에 의존하는 경우, 
DevTools를 열면 해당 확장 기능이 자동으로 새 탭에 표시됩니다.

### 확장 활성화 상태 구성 {:#configure-extension-enablement-states}

확장 프로그램을 처음 로드하기 전에 수동으로 활성화해야 합니다. 
활성화하기 전에, 신뢰할 수 있는 출처에서 확장 프로그램을 제공했는지 확인하세요.

![Screenshot of extension enablement prompt](/assets/images/docs/tools/devtools/extension_enable_prompt.png)

확장 기능 활성화 상태는 사용자 프로젝트 루트에 있는 `devtools_options.yaml` 파일에 저장됩니다.
(`analysis_options.yaml`과 유사)
이 파일은 DevTools에 대한 프로젝트별(또는 선택적으로 사용자별) 설정을 저장합니다.

이 파일이 **checked into source control**되면, 지정된 옵션이 프로젝트에 대해 구성됩니다. 
즉, 프로젝트의 소스 코드를 pull한 프로젝트에서 작업하는 모든 사람이 동일한 설정을 사용합니다.

이 파일이 **omitted from source control**되면,
(예: `devtools_options.yaml`을 `.gitignore` 파일에 항목으로 추가) 
지정된 옵션이 각 사용자에 대해 별도로 구성됩니다. 
이 경우, 프로젝트의 각 사용자 또는 기여자는 `devtools_options.yaml` 파일의 로컬 복사본을 사용하므로, 
지정된 옵션은 프로젝트 기여자 간에 다를 수 있습니다.

## DevTools 확장 프로그램 빌드 {:#build-a-devtools-extension}

DevTools 확장 프로그램을 빌드하는 방법에 대한 심층적인 가이드는, 
Medium의 무료 글인 [Dart 및 Flutter DevTools 확장 프로그램][article]를 확인하세요.

DevTools 확장 프로그램을 작성하고 사용하는 방법에 대해 자세히 알아보려면 다음 비디오를 확인하세요.

{% ytEmbed 'gOrSc4s4RWY', 'DevTools 확장 프로그램 빌드 | Flutter Build Show' %}

[article]: {{site.flutter-medium}}/dart-flutter-devtools-extensions-c8bc1aaf8e5f
