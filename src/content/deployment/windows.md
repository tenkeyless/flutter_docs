---
# title: Build and release a Windows desktop app
title: Windows 데스크톱 앱 빌드 및 릴리스
# description: How to release a Flutter app to the Microsoft Store.
description: Microsoft Store에 Flutter 앱을 출시하는 방법.
short-title: windows
---

Windows 앱을 배포하는 편리한 방법 중 하나는 [Microsoft Store][microsoftstore]입니다. 
이 가이드는 이런 방식으로 Flutter 앱을 패키징하고 배포하는 단계별 연습 과정을 제공합니다.

:::note
특히 배포 환경을 더 많이 제어하거나 인증 프로세스를 처리하고 싶지 않은 경우, 
Microsoft Store를 통해 Windows 앱을 게시할 필요는 없습니다. 
Microsoft 문서에는 [Windows Installer][msidocs]를 포함하여, 
기존 설치 방법에 대한 자세한 정보가 포함되어 있습니다.
:::

## 사전 준비 {:#preliminaries}

Microsoft Store에 Flutter Windows 데스크톱 앱을 출시하는 프로세스를 시작하기 전에, 
먼저 [Microsoft Store 정책][storepolicies]를 충족하는지 확인하세요.

또한 앱을 제출하려면 [Microsoft 파트너 네트워크][microsoftpartner]에 가입해야 합니다.

## 파트너 센터(Partner Center)에서 애플리케이션 설정 {:#set-up-your-application-in-the-partner-center}

[Microsoft Partner Center][microsoftpartner]에서 애플리케이션의 수명 주기를 관리합니다.

먼저 애플리케이션 이름을 예약하고, 이름에 필요한 권한이 있는지 확인합니다. 
이름이 예약되면, 애플리케이션이 서비스(예: 푸시 알림)에 프로비저닝되고 애드온을 추가할 수 있습니다.

가격, 가용성, 연령 등급, 범주와 같은 옵션은 첫 번째 제출과 함께 구성해야 하며, 
이후 제출에 자동으로 유지됩니다.

## 패키징 및 배포 {:#packaging-and-deployment}

Microsoft Store에 애플리케이션을 게시하려면 먼저 패키징해야 합니다. 
유효한 형식은 **.msix**, **.msixbundle**, **.msixupload**, **.appx**, **.appxbundle**, **.appxupload**, **.xap**입니다.

### Microsoft Store에 대한 수동 패키징 및 배포 {:#manual-packaging-and-deployment-for-the-microsoft-store}

[MSIX 패키징][msix packaging]을 확인하여, 
Flutter Windows 데스크톱 애플리케이션 패키징에 대해 알아보세요.

각 제품에는 스토어에서 할당하는 고유한 identity가 있습니다.

패키지가 수동으로 빌드되는 경우, 패키징 중에 identity 세부 정보를 수동으로 포함해야 합니다. 
다음 지침에 따라 파트너 센터에서 필수 정보를 검색할 수 있습니다.

1. 파트너 센터에서, 애플리케이션으로 이동합니다.
2. **Product management**를 선택합니다.
3. **Product identity**를 클릭하여, 패키지 identity 이름, 
   게시자 및 게시자 표시 이름을 검색합니다.

애플리케이션을 수동으로 패키징한 후, 
[Microsoft Partner Center][microsoftpartner]에 수동으로 제출합니다. 
새 제출을 만들고 **Packages**로 이동한 다음, 
생성된 애플리케이션 패키지를 업로드하여 이를 수행할 수 있습니다.

### 지속적인 배포 {:#continuous-deployment}

패키지를 수동으로 만들고 배포하는 것 외에도, 
처음으로 Microsoft Store에 애플리케이션을 제출한 후 CI/CD 도구를 사용하여, 
빌드, 패키징, 버전 관리 및 배포 프로세스를 자동화할 수 있습니다.

#### Codemagic CI/CD {:#codemagic-cicd}

[Codemagic CI/CD][codemagic]은 [`msix` pub 패키지][msix package]를 사용하여, 
Flutter Windows 데스크톱 애플리케이션을 패키징합니다.

Flutter 애플리케이션의 경우, 
[Codemagic Workflow Editor][cmworkfloweditor] 또는 [codemagic.yaml][cmyaml]을 사용하여, 
애플리케이션을 패키징하고 Microsoft 파트너 센터에 배포합니다. 
이 패키지를 사용하여 추가 옵션(패키지에 포함된 기능 및 언어 리소스 리스트 등)을 구성할 수 있습니다.

게시의 경우 Codemagic은 [파트너 센터 제출 API][partnercenterapi]를 사용하므로, 
Codemagic에는 [Azure Active Directory 및 파트너 센터 계정 연결][azureadassociation]이 필요합니다.

#### GitHub Actions CI/CD {:#github-actions-cicd}

GitHub Actions는 [Microsoft Dev Store CLI](https://learn.microsoft.com/windows/apps/publish/msstore-dev-cli/overview)를 사용하여, 
애플리케이션을 MSIX로 패키징하고 Microsoft Store에 게시할 수 있습니다. 
[setup-msstore-cli](https://github.com/microsoft/setup-msstore-cli) GitHub Action은 Action이 패키징 및 게시에 사용할 수 있도록 cli를 설치합니다.

MSIX를 패키징하는 데 [`msix` pub 패키지][msix package]가 사용되므로, 
프로젝트의 `pubspec.yaml`에는 적절한 `msix_config` 노드가 포함되어야 합니다.

Dev Center에서 [전역 관리자 권한](https://azure.microsoft.com/documentation/articles/active-directory-assign-admin-roles/)으로 Azure AD 디렉터리를 만들어야 합니다.

GitHub Action에는 파트너 센터의 환경 비밀(environment secrets)이 필요합니다. 
`AZURE_AD_TENANT_ID`, `AZURE_AD_ClIENT_ID`, `AZURE_AD_CLIENT_SECRET`는 [Windows Store Publish Action](https://github.com/marketplace/actions/windows-store-publish#obtaining-your-credentials)에 대한 지침에 따라, Dev Center에 표시됩니다. 
또한 **Account Settings** > **Organization Profile** > **Legal Info**에서, 
Dev Center에서 찾을 수 있는 `SELLER_ID` 비밀도 필요합니다.

애플리케이션은 적어도 하나의 완전한 제출과 함께 Microsoft Dev Center에 이미 있어야 하며, 
Action을 수행하기 전에 리포지토리 내에서 `msstore init`를 한 번 실행해야 합니다. 
완료되면, GitHub Action에서 [`msstore package .`](https://learn.microsoft.com/windows/apps/publish/msstore-dev-cli/package-command)와 [`msstore publish`](https://learn.microsoft.com/windows/apps/publish/msstore-dev-cli/publish-command)를 실행하여, 
애플리케이션을 MSIX로 패키징하고 개발자 센터의 새 제출에 업로드합니다.

MSIX 게시에 필요한 단계는 다음과 유사합니다.

```yaml
- uses: microsoft/setup-msstore-cli@v1

- name: Configure the Microsoft Store CLI
  run: msstore reconfigure --tenantId ${{ secrets.AZURE_AD_TENANT_ID }} --clientId ${{ secrets.AZURE_AD_ClIENT_ID }} --clientSecret ${{ secrets.AZURE_AD_CLIENT_SECRET }} --sellerId ${{ secrets.SELLER_ID }}

- name: Install Dart dependencies
  run: flutter pub get

- name: Create MSIX package
  run: msstore package .

- name: Publish MSIX to the Microsoft Store
  run: msstore publish -v
```

## 앱 버전 번호 업데이트 {:#updating-the-apps-version-number}

Microsoft Store에 게시된 앱의 경우, 패키징 프로세스 중에 버전 번호를 설정해야 합니다.

앱의 기본 버전 번호는 `1.0.0.0`입니다.

:::note
Microsoft Store 앱은 0이 아닌 수정 번호가 있는 버전을 가질 수 없습니다. 
따라서, 모든 릴리스에서 버전의 마지막 번호는 0으로 유지되어야 합니다. 
Microsoft의 [버전 관리 지침][windowspackageversioning]을 따르세요.
:::

Microsoft Store에 게시되지 않은 앱의 경우, 
앱 실행 파일의 파일 및 제품 버전을 설정할 수 있습니다. 
실행 파일의 기본 파일 버전은 `1.0.0.1`이고, 기본 제품 버전은 `1.0.0+1`입니다. 
이를 업데이트하려면, `pubspec.yaml` 파일로 이동하여 다음 줄을 업데이트합니다.

```yaml
version: 1.0.0+1
```

빌드 이름은 점으로 구분된 세 개의 숫자이며, 그 뒤에는 `+`로 구분된 선택적 빌드 번호가 옵니다. 
위의 예에서 빌드 이름은 `1.0.0`이고 빌드 번호는 `1`입니다.

빌드 이름은 파일 및 제품 버전의 처음 세 숫자가 되고, 
빌드 번호는 파일 및 제품 버전의 네 번째 숫자가 됩니다.

빌드 이름과 번호는 각각 `--build-name`과 `--build-number`를 지정하여, 
`flutter build windows`에서 재정의할 수 있습니다.

:::note
Flutter 3.3 이전에 생성된 Flutter 프로젝트는, 
실행 파일의 버전 정보를 설정하도록 업데이트해야 합니다. 
자세한 내용은 [버전 마이그레이션 가이드][version migration guide]를 참조하세요.
:::

## 앱 아이콘 추가 {:#add-app-icons}

패키징하기 전에 Flutter Windows 데스크톱 애플리케이션의 아이콘을 업데이트하려면, 다음 지침을 따르세요.

1. Flutter 프로젝트에서 **windows\runner\resources**로 이동합니다.
2. **app_icon.ico**를 원하는 아이콘으로 바꿉니다.
3. 아이콘 이름이 **app_icon.ico**가 아닌 경우, 
   **windows\runner\Runner.rc** 파일에서 
   **IDI_APP_ICON** 값을 변경하여 새 경로를 가리키도록 합니다.

[`msix` pub 패키지][msix package]로 패키징하는 경우, 
로고 경로도 `pubspec.yaml` 파일 내부에서 구성할 수 있습니다.

스토어 리스트에서 애플리케이션 이미지를 업데이트하려면, 
제출의 스토어 리스트 단계로 이동하여 스토어 로고를 선택합니다. 
거기에서 300 x 300픽셀 크기의 로고를 업로드할 수 있습니다.

업로드된 모든 이미지는 후속 제출을 위해 보관됩니다.

## 애플리케이션 패키지 검증 {:#validating-the-application-package}

Microsoft Store에 게시하기 전에, 먼저 로컬에서 애플리케이션 패키지를 검증합니다.

[Windows 앱 인증 키트][windowsappcertification]은 Windows 소프트웨어 개발 키트(SDK)에 포함된 도구입니다.

애플리케이션을 검증하려면:

1. Windows App Cert Kit를 시작합니다.
2. Flutter Windows 데스크톱 패키지(**.msix**, **.msixbundle** 등)를 선택합니다.
3. 테스트 보고서의 대상을 선택합니다.

인증에 통과하더라도, 보고서에는 중요한 경고와 정보가 포함될 수 있습니다.

[azureadassociation]: https://docs.microsoft.com/windows/uwp/publish/associate-azure-ad-with-partner-center
[cmworkfloweditor]: https://docs.codemagic.io/flutter-publishing/publishing-to-microsoft-store/
[cmyaml]: https://docs.codemagic.io/yaml-publishing/microsoft-store/
[codemagic]: https://codemagic.io/start/
[microsoftstore]: https://www.microsoft.com/store/apps/windows
[msidocs]: https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-portal
[microsoftpartner]: https://partner.microsoft.com/
[msix package]: {{site.pub}}/packages/msix
[msix packaging]: /platform-integration/windows/building#msix-packaging
[partnercenterapi]: https://docs.microsoft.com/azure/marketplace/azure-app-apis
[storepolicies]: https://docs.microsoft.com/windows/uwp/publish/store-policies/
[visualstudiopackaging]: https://docs.microsoft.com/windows/msix/package/packaging-uwp-apps
[visualstudiosubmission]: https://docs.microsoft.com/windows/msix/package/packaging-uwp-apps#automate-store-submissions
[windowspackageversioning]: https://docs.microsoft.com/windows/uwp/publish/package-version-numbering
[windowsappcertification]: https://docs.microsoft.com/windows/uwp/debug-test-perf/windows-app-certification-kit
[version migration guide]: /release/breaking-changes/windows-version-information
