---
# title: Validate deep links
title: 딥 링크 검증
# description: Learn how to validate deep links in your app.
description: 앱에서 딥 링크를 검증하는 방법을 알아보세요.
---

:::note
딥 링크 검증기는 Flutter SDK 3.19의 DevTools에 추가되었습니다. 
현재는 Android에서만 작동하지만, 향후 릴리스에서는 iOS를 포함하도록 확장될 예정입니다.

딥 링크 검증기의 데모를 보려면, Google I/O 2024 비디오, 
[더 이상 끊어진 링크 없음: Flutter에서 딥 링크 성공][No more broken links: Deep linking success in Flutter]을 확인하세요.
:::

[No more broken links: Deep linking success in Flutter]: {{site.youtube-site}}/watch?v=d7sZL6h1Elw

딥 링크 뷰는 앱에 정의된 모든 딥 링크를 검증합니다.

이 기능을 사용하려면, DevTools를 열고, **Deep Links** 탭을 클릭한 다음, 
딥 링크가 포함된 Flutter 프로젝트를 가져옵니다.

![Screenshot of the Deep Link Validator](/assets/images/docs/tools/devtools/deep-link-validator.png){:width="100%"}

이 도구는 웹사이트 구성에서 Android 매니페스트 파일에 이르기까지, 
Android 딥 링크 설정의 모든 오류를 식별하고 문제를 해결하는 데 도움이 됩니다. 
DevTools는 모든 문제를 해결하는 방법에 대한 지침을 제공하여 구현 프로세스를 더 쉽게 만듭니다.
