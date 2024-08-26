---
# title: External windows in Flutter Windows apps
title: Flutter Windows 앱의 외부 창
# description: Special considerations for adding external windows to Flutter apps
description: Flutter 앱에 외부 창을 추가할 때의 특별 고려 사항
---

<!-- # Windows lifecycle -->
# 윈도우 라이프사이클

## 누가 영향을 받나요? {:#who-is-affected}

Windows applications built against Flutter versions after 3.13 that open non-Flutter windows.

## 개요 {:#overview}

When adding a non-Flutter window to a Flutter Windows app, it will not be part
of the logic for application lifecycle state updates by default. For example,
this means that when the external window is shown or hidden, the app lifecycle
state will not appropriately update to inactive or hidden. As a result, the app
may receive incorrect lifecycle state changes through
[WidgetsBindingObserver.didChangeAppLifecycle][].

<!-- # What do I need to do? -->
# 어떻게 해야 하나요?

To add the external window to this application logic,
the window's `WndProc` procedure
must invoke `FlutterEngine::ProcessExternalWindowMessage`.

To achieve this, add the following code to a window message handler function:

```diff
LRESULT Window::Messagehandler(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam) {
+    std::optional<LRESULT> result = flutter_controller_->engine()->ProcessExternalWindowMessage(hwnd, msg, wparam, lparam);
+    if (result.has_value()) {
+        return *result;
+    }
    // Original contents of WndProc...
}
```

[documentation of this breaking change.]: /release/breaking-changes/win_lifecycle_process_function
[WidgetsBindingObserver.didChangeAppLifecycle]: {{site.api}}/flutter/widgets/WidgetsBindingObserver/didChangeAppLifecycleState.html
