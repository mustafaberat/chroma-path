-keep class com.arusoft.chromapath.** { *; }

# shared_preferences_android calls its Kotlin API from Dart over JNI.
# R8 can't see those calls and strips the methods.
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class com.github.dart_lang.jni.** { *; }
-keep class kotlin.coroutines.** { *; }
-keep class kotlin.Result { *; }
-keep class kotlin.Result$* { *; }
-keep class kotlin.Unit { *; }
-keep class kotlin.jvm.internal.** { *; }
