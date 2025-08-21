# Keep Flutter embedding + plugin
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }

# Abaikan missing classes untuk Play Core (Dynamic Feature / SplitInstall)
-dontwarn com.google.android.play.core.**
-dontnote com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
