---
# title: Build and release a Linux app to the Snap Store
title: Snap Store에 Linux 앱 빌드 및 릴리스
# description: How to prepare for and release a Linux app to the Snap store.
description: Linux 앱을 Snap Store에 출시하고 준비하는 방법.
short-title: Linux
---

일반적인 개발 주기 동안, 
명령줄에서 `flutter run`을 사용하거나, 
IDE에서 **Run** 및 **Debug** 옵션을 사용하여 앱을 테스트합니다. 
기본적으로 Flutter는 앱의 _debug_ 버전을 빌드합니다.

앱의 _release_ 버전을 준비할 준비가 되면(예: [Snap Store에 게시][snap]), 이 페이지가 도움이 될 수 있습니다.

## 사전 준비 {:#prerequisites}

Snap Store에 빌드하고 게시하려면 다음 구성 요소가 필요합니다.

* [Ubuntu][] OS, 18.04 LTS(또는 그 이상)
* [Snapcraft][] 명령줄 도구
* [LXD 컨테이너 관리자][LXD container manager]

## 빌드 환경 설정 {:#set-up-the-build-environment}

다음 지침에 따라 빌드 환경을 설정하세요.

### 스냅크래프트(snapcraft) 설치 {:#install-snapcraft}

명령줄에서 다음을 실행합니다.

```console
$ sudo snap install snapcraft --classic
```

### LXD 설치 {:#install-lxd}

LXD를 설치하려면 다음 명령을 사용하세요.

```console
$ sudo snap install lxd
```

LXD는 스냅 빌드 프로세스 중에 필요합니다. 
설치가 완료되면 LXD를 사용하도록 구성해야 합니다. 
기본 답변은 대부분의 사용 사례에 적합합니다.

```console
$ sudo lxd init
Would you like to use LXD clustering? (yes/no) [default=no]:
Do you want to configure a new storage pool? (yes/no) [default=yes]:
Name of the new storage pool [default=default]:
Name of the storage backend to use (btrfs, dir, lvm, zfs, ceph) [default=zfs]:
Create a new ZFS pool? (yes/no) [default=yes]:
Would you like to use an existing empty disk or partition? (yes/no) [default=no]:
Size in GB of the new loop device (1GB minimum) [default=5GB]:
Would you like to connect to a MAAS server? (yes/no) [default=no]:
Would you like to create a new local network bridge? (yes/no) [default=yes]:
What should the new bridge be called? [default=lxdbr0]:
What IPv4 address should be used? (CIDR subnet notation, "auto" or "none") [default=auto]:
What IPv6 address should be used? (CIDR subnet notation, "auto" or "none") [default=auto]:
Would you like LXD to be available over the network? (yes/no) [default=no]:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]:
```

첫 번째 실행에서는, LXD가 소켓에 연결하지 못할 수 있습니다.

```console
An error occurred when trying to communicate with the 'LXD'
provider: cannot connect to the LXD socket
('/var/snap/lxd/common/lxd/unix.socket').
```

즉, LXD(lxd) 그룹에 사용자 이름을 추가해야 하므로, 세션에서 로그아웃한 다음 다시 로그인해야 합니다.

```console
$ sudo usermod -a -G lxd <your username>
```

## 스냅크래프트(snapcraft) 개요 {:#overview-of-snapcraft}

`snapcraft` 도구는 `snapcraft.yaml` 파일에 나열된 지침에 따라 스냅을 빌드합니다. 
스냅크래프트와 핵심 개념에 대한 기본적인 이해를 얻으려면 [스냅 문서][Snap documentation]와 [스냅크래프트 소개][Introduction to snapcraft]를 살펴보세요. 
추가 링크와 정보는 이 페이지 하단에 나열되어 있습니다.

## Flutter snapcraft.yaml 예제 {:#flutter-snapcraft-yaml-example}

YAML 파일을 Flutter 프로젝트의 `<project root>/snap/snapcraft.yaml` 아래에 두세요. 
(그리고 YAML 파일은 공백에 민감하다는 것을 기억하세요!) 예를 들어:

```yaml
name: super-cool-app
version: 0.1.0
summary: Super Cool App
description: Super Cool App that does everything!

confinement: strict
base: core22
grade: stable

slots:
  dbus-super-cool-app: # 앱 이름에 맞게 조정하세요
    interface: dbus
    bus: session
    name: org.bar.super_cool_app # 앱 이름에 맞게 조정하세요.
    
apps:
  super-cool-app:
    command: super_cool_app
    extensions: [gnome] # gnome에는 flutter에 필요한 라이브러리가 포함되어 있습니다.
    plugs:
    - network
    slots:
      - dbus-super-cool-app
parts:
  super-cool-app:
    source: .
    plugin: flutter
    flutter-target: lib/main.dart # 애플리케이션의 메인 진입점 파일
```

다음 섹션에서는 YAML 파일의 다양한 부분에 대해 설명합니다.

### Metadata {:#metadata}

`snapcraft.yaml` 파일의 이 섹션은 애플리케이션을 정의하고 설명합니다. 
스냅 버전은 빌드 섹션에서 파생(채택)됩니다.

```yaml
name: super-cool-app
version: 0.1.0
summary: Super Cool App
description: Super Cool App that does everything!
```

### Grade, confinement 및 base {:#grade-confinement-and-base}

이 섹션에서는 스냅이 어떻게 구성되는지 정의합니다.

```yaml
confinement: strict
base: core18
grade: stable
```

**Grade**
: 스냅의 품질을 지정합니다. 이는 나중에 게시 단계와 관련이 있습니다.

**Confinement**
: 스냅이 최종 사용자 시스템에 설치되면, 어떤 레벨의 시스템 리소스에 액세스할지 지정합니다. 
  엄격한 제한은 특정 리소스(`app` 섹션의 플러그인으로 정의됨)에 대한 애플리케이션 액세스를 제한합니다.

**Base**
: 스냅은 독립형 애플리케이션으로 설계되었으므로, `base`라는 자체 private 코어 루트 파일 시스템이 필요합니다. 
  `base` 키워드는 공통 라이브러리의 최소 세트를 제공하는 데 사용되는 버전을 지정하고, 
  런타임에 애플리케이션의 루트 파일 시스템으로 마운트합니다.

### Apps {:#apps}

이 섹션은 스냅 내부에 존재하는 애플리케이션을 정의합니다. 
스냅당 하나 이상의 애플리케이션이 있을 수 있습니다. 
이 예에는 단일 애플리케이션이 있습니다. &mdash; super_cool_app.

```yaml
apps:
  super-cool-app:
    command: super_cool_app
    extensions: [gnome]
```

**Command**
: 스냅의 루트를 기준으로 바이너리를 가리키고, 스냅이 호출될 때 실행됩니다.

**Extensions**
: 하나 이상의 확장 리스트입니다. 
  Snapcraft 확장은 개발자가 포함된 프레임워크에 대한 특정 지식이 없어도, 
  빌드 및 런타임에 라이브러리 및 도구 세트를 스냅에 노출할 수 있는 재사용 가능한 구성 요소입니다. 
  `gnome` 확장은 GTK 3 라이브러리를 Flutter 스냅에 노출합니다. 
  이렇게 하면 더 작은 풋프린트와 시스템과의 더 나은 통합이 보장됩니다.

**Plugs**
: 시스템 인터페이스에 대한 하나 이상의 플러그 리스트입니다. 
  스냅이 엄격하게 제한될 때 필요한 기능을 제공하는 데 필요합니다. 
  이 Flutter 스냅은 네트워크에 액세스해야 합니다.

**DBus 인터페이스**
: [DBus 인터페이스][DBus interface]는 스냅이 DBus를 통해 통신할 수 있는 방법을 제공합니다. 
  DBus 서비스를 제공하는 스냅은 잘 알려진 DBus 이름과 사용하는 버스가 있는 슬롯을 선언합니다. 
  제공하는 스냅의 서비스와 통신하려는 스냅은 제공하는 스냅에 대한 플러그를 선언합니다. 
  스냅이 스냅 스토어를 통해 전달되고, 이 잘 알려진 DBus 이름을 청구하려면 스냅 선언이 필요합니다.
  (단순히 스냅을 스토어에 업로드하고 수동 검토를 요청하면 검토자가 살펴볼 것입니다)

  제공하는 스냅이 설치되면, snapd는 지정된 버스에서 잘 알려진 DBus 이름을 수신할 수 있는 보안 정책을 생성합니다. 
  시스템 버스가 지정된 경우 snapd는 'root'가 이름을 소유하고, 
  모든 사용자가 서비스와 통신할 수 있는 DBus 버스 정책도 생성합니다. 
  스냅이 아닌 프로세스는 기존 권한 확인에 따라 제공하는 스냅과 통신할 수 있습니다. 
  다른(소비) 스냅은 스냅의 인터페이스를 연결하여 제공하는 스냅과만 통신할 수 있습니다.
  
```plaintext
dbus-super-cool-app: # adjust accordingly to your app name
  interface: dbus
  bus: session
  name: dev.site.super_cool_app 
```

### Parts {:#parts}

이 섹션에서는 스냅을 조립하는 데 필요한 소스를 정의합니다.

플러그인을 사용하여 Parts를 다운로드하고 자동으로 빌드할 수 있습니다. 
확장 프로그램과 마찬가지로 Snapcraft는 다양한 플러그인(예: Python, C, Java, Ruby)을 사용하여 빌드 프로세스를 지원할 수 있습니다. 
Snapcraft에는 몇 가지 특수 플러그인도 있습니다.

**nil** 플러그인
: 아무 작업도 수행하지 않으며, 실제 빌드 프로세스는 수동 재정의를 사용하여 처리됩니다.

**flutter** 플러그인
: 빌드 도구를 수동으로 다운로드하고 설정하지 않고도 사용할 수 있도록, 필요한 Flutter SDK 도구를 제공합니다.

```yaml
parts:
  super-cool-app:
    source: .
    plugin: flutter
    flutter-target: lib/main.dart # The main entry-point file of the application
```


## 데스크탑 파일 및 아이콘 {:#desktop-file-and-icon}

데스크톱 엔트리 파일은 데스크톱 메뉴에 애플리케이션을 추가하는 데 사용됩니다. 
이러한 파일은 애플리케이션의 이름과 아이콘, 해당 애플리케이션이 속한 범주, 관련 검색 키워드 등을 지정합니다. 
이러한 파일은 .desktop 확장자를 가지고 있으며 XDG Desktop Entry Specification 버전 1.1을 따릅니다.
  
### Flutter super-cool-app.desktop 예제 {:#flutter-super-cool-app-desktop-example}

`<project root>/snap/gui/super-cool-app.desktop` 아래의 Flutter 프로젝트에 .desktop 파일을 넣으세요.

**Notice**: 아이콘과 .desktop 파일 이름은 yaml 파일의 앱 이름과 동일해야 합니다!

예를 들어:

```yaml
[Desktop Entry]
Name=Super Cool App
Comment=Super Cool App that does everything
Exec=super-cool-app 
Icon=${SNAP}/meta/gui/super-cool-app.png # 이름을 앱 이름으로 바꾸세요.
Terminal=false
Type=Application
Categories=Education; # 스냅 카테고리에 따라 조정하세요.
```

Flutter 프로젝트의 `<project root>/snap/gui/super-cool-app.png` 아래에 .png 확장자를 가진 아이콘을 넣으세요.

## 스냅(snap) 빌드하기 {:#build-the-snap}

`snapcraft.yaml` 파일이 완성되면, 프로젝트의 루트 디렉토리에서 다음과 같이 `snapcraft`를 실행합니다.

Multipass VM 백엔드를 사용하려면:

```console
$ snapcraft
``` 

LXD 컨테이너 백엔드를 사용하려면:

```console
$ snapcraft --use-lxd
```

## 스냅 테스트하기 {:#test-the-snap}

스냅이 빌드되면, 루트 프로젝트 디렉토리에 `<name>.snap` 파일이 생성됩니다.

```console
$ sudo snap install ./super-cool-app_0.1.0_amd64.snap --dangerous
```

## 게시하기 {:#publish}

이제 스냅을 게시할 수 있습니다. 프로세스는 다음과 같습니다.

1. 아직 만들지 않았다면, [snapcraft.io][]에서 개발자 계정을 만듭니다.
1. 앱 이름을 등록합니다. 
   등록은 Snap Store 웹 UI 포털을 사용하거나, 다음과 같이 명령줄에서 수행할 수 있습니다.
  
   ```console
   $ snapcraft login
   $ snapcraft register
   ```

2. 앱을 릴리스합니다. 
   다음 섹션을 읽고 Snap Store 채널 선택에 대해 알아본 후 Snap을 스토어로 푸시합니다.
 
   ```console
   $ snapcraft upload --release=<channel> <file>.snap
   ```

### Snap Store 채널 {:#snap-store-channels}

Snap Store는 채널을 사용하여 다양한 버전의 스냅을 구분합니다.

`snapcraft upload` 명령은 스냅 파일을 스토어에 업로드합니다. 
그러나, 이 명령을 실행하기 전에 다양한 릴리스 채널에 대해 알아야 합니다. 
각 채널은 세 가지 구성 요소로 구성됩니다.

**Track**
: 모든 스냅에는 최신이라는 기본 트랙이 있어야 합니다. 달리 지정하지 않는 한 이는 암묵적 트랙입니다.

**Risk**
: 애플리케이션의 준비 상태를 정의합니다. 
  스냅 스토어에서 사용되는 위험 수준은 `stable`, `candidate`, `beta`, `edge`입니다.

**Branch**
: 버그 수정을 테스트하기 위해 단기 스냅 시퀀스를 만들 수 있습니다.

### Snap Store 자동 리뷰 {:#snap-store-automatic-review}

Snap Store는 귀하의 스냅에 대해 여러 가지 자동화된 검사를 실행합니다. 
스냅이 어떻게 만들어졌는지와 특정 보안 문제가 있는지에 따라 수동 검토가 있을 수도 있습니다. 
검사가 오류 없이 통과되면 스냅이 스토어에서 사용 가능해집니다.

## 추가 자료 {:#additional-resources}

[snapcraft.io][] 사이트의 다음 링크에서 더 자세히 알아볼 수 있습니다.

* [채널][Channels]
* [환경 변수][Environment variables]
* [인터페이스 관리][Interface management]
* [파트 환경 변수][Parts environment variables]
* [Snap Store에 출시][Releasing to the Snap Store]
* [Snapcraft 확장 프로그램][Snapcraft extensions]
* [지원되는 플러그인][Supported plugins]

[Environment variables]: https://snapcraft.io/docs/environment-variables
[Flutter wiki]: {{site.repo.flutter}}/tree/master/docs
[Interface management]: https://snapcraft.io/docs/interface-management
[DBus interface]: https://snapcraft.io/docs/dbus-interface
[Introduction to snapcraft]: https://snapcraft.io/blog/introduction-to-snapcraft
[LXD container manager]: https://linuxcontainers.org/lxd/downloads/
[Multipass virtualization manager]: https://multipass.run/
[Parts environment variables]: https://snapcraft.io/docs/parts-environment-variables
[Releasing to the Snap Store]: https://snapcraft.io/docs/releasing-to-the-snap-store
[Channels]: https://docs.snapcraft.io/channels
[snap]: https://snapcraft.io/store
[Snap documentation]: https://snapcraft.io/docs
[Snapcraft]: https://snapcraft.io/snapcraft
[snapcraft.io]: https://snapcraft.io/
[Snapcraft extensions]: https://snapcraft.io/docs/snapcraft-extensions
[Supported plugins]: https://snapcraft.io/docs/supported-plugins
[Ubuntu]: https://ubuntu.com/download/desktop
