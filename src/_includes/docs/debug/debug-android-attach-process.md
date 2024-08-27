1. **Attach debugger to Android process** 버튼을 클릭합니다. 
   (![Tiny green bug superimposed with a light grey arrow](/assets/images/docs/testing/debugging/native/android-studio/attach-process-button.png))

    :::tip
    이 버튼이 **Projects** 메뉴 막대에 나타나지 않으면, 
    Flutter _애플리케이션_ 프로젝트를 열었지만, _Flutter 플러그인은 열지 않았는지_ 확인하세요.
    :::

2. **process** 대화 상자는 연결된 각 장치에 대해 하나의 항목을 표시합니다. 
   각 장치에 대해 사용 가능한 프로세스를 표시하려면, **show all processes**를 선택합니다.

3. 연결하려는 프로세스를 선택합니다. 
   이 가이드에서는, **Emulator Pixel_5_API_33**을 사용하여 `com.example.my_app` 프로세스를 선택합니다.

{% comment %}

   @atsansone - 2023-07-24

   These screenshots were commented out for two reasons known for most docs:

   1. The docs should stand on their own.
   2. These screenshots would be painful to maintain.

   If reader feedback urges their return, these will be uncommented.

   ![Attach to Process dialog box open in Android Studio](/assets/images/docs/testing/debugging/native/android-studio/attach-process-dialog.png)
   <div class="figure-caption">

   Flutter app in Android device displaying two buttons.

   </div>
{% endcomment %}

1. **Debug** 창에서 **Android Debugger** 탭을 찾으세요.

2. **Project** 창에서, 다음을 확장하세요.
   **my_app_android** <span aria-label="and then">></span>
   **android** <span aria-label="and then">></span>
   **app** <span aria-label="and then">></span>
   **src** <span aria-label="and then">></span>
   **main** <span aria-label="and then">></span>
   **java** <span aria-label="and then">></span>
   **io.flutter plugins**.

3. **GeneratedProjectRegistrant**를 두 번 클릭하여 **Edit** 창에서 Java 코드를 엽니다.

{% comment %}
   !['The Android Project view highlighting the GeneratedPluginRegistrant.java file.'](/assets/images/docs/testing/debugging/native/android-studio/debug-open-java-code.png){:width="100%"}
   <div class="figure-caption">
   
   The Android Project view highlighting the `GeneratedPluginRegistrant.java` file.
   
   </div>
{% endcomment %}

이 절차가 끝나면 Dart와 Android 디버거는 모두 동일한 프로세스와 상호 작용합니다. 
둘 중 하나 또는 둘 다를 사용하여 중단점을 설정하고, 스택을 검사하고, 실행을 재개하는 등의 작업을 수행합니다. 
즉, 디버그하세요!

{% comment %}
![The Dart debug pane with two breakpoints set in `lib/main.dart`](/assets/images/docs/testing/debugging/native/dart-debugger.png){:width="100%"}
<div class="figure-caption">

The Dart debug pane with two breakpoints set in `lib/main.dart`.

</div>
{% endcomment %}

{% comment %}
!['The Android debug pane with one breakpoint set in GeneratedPluginRegistrant.java.'](/assets/images/docs/testing/debugging/native/android-studio/debugger-active.png)
<div class="figure-caption">

The Android debug pane with one breakpoint set in GeneratedPluginRegistrant.java.

</div>
{% endcomment %}