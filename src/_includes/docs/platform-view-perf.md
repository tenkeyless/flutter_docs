## 성능 {:#performance}

Platform views in Flutter come with performance trade-offs.

For example, in a typical Flutter app, the Flutter UI is composed
on a dedicated raster thread. This allows Flutter apps to be fast,
as the main platform thread is rarely blocked.

While a platform view is rendered with hybrid composition,
the Flutter UI is composed from the platform thread,
which competes with other tasks like handling OS or plugin messages.

Prior to Android 10, hybrid composition copied each Flutter frame
out of the graphic memory into main memory, and then copied it back
to a GPU texture. As this copy happens per frame, the performance of
the entire Flutter UI might be impacted. In Android 10 or above, the
graphics memory is copied only once.

Virtual display, on the other hand,
makes each pixel of the native view
flow through additional intermediate graphic buffers,
which cost graphic memory and drawing performance.

For complex cases, there are some techniques that
can be used to mitigate these issues.

For example, you could use a placeholder texture
while an animation is happening in Dart.
In other words, if an animation is slow while a
platform view is rendered,
then consider taking a screenshot of the
native view and rendering it as a texture.

For more information, see:

* [`TextureLayer`][]
* [`TextureRegistry`][]
* [`FlutterTextureRegistry`][]
* [`FlutterImageView`][]

[`FlutterImageView`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterImageView.html
[`FlutterTextureRegistry`]: {{site.api}}/ios-embedder/protocol_flutter_texture_registry-p.html
[`TextureLayer`]: {{site.api}}/flutter/rendering/TextureLayer-class.html
[`TextureRegistry`]: {{site.api}}/javadoc/io/flutter/view/TextureRegistry.html
