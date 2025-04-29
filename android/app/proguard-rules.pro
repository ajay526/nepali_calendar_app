# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep your application classes
-keep class com.hawkeyepatro.** { *; }

# Keep native libraries
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Gson classes
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.** { *; }

# Keep Retrofit classes
-keepattributes Signature
-keepattributes Exceptions
-keep class retrofit2.** { *; }
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeInvisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes RuntimeInvisibleParameterAnnotations

-keepattributes EnclosingMethod
-keepclasseswithmembers class * {
    @retrofit2.http.* <methods>;
}

# Keep encryption related classes
-keep class javax.crypto.** { *; }
-keep class javax.crypto.spec.** { *; }
-keep class java.security.** { *; }

# Keep device info classes
-keep class android.os.Build { *; }
-keep class android.os.Build$VERSION { *; }

# Keep root detection related classes
-keep class com.scottyab.rootbeer.** { *; }

# Keep WebView related classes
-keep class android.webkit.** { *; }

# Keep database related classes
-keep class androidx.room.** { *; }
-keep class * extends androidx.room.RoomDatabase { *; }

# Keep notification related classes
-keep class androidx.core.app.NotificationCompat { *; }
-keep class androidx.core.app.NotificationCompat$* { *; }

# Keep location related classes
-keep class android.location.** { *; }
-keep class com.google.android.gms.location.** { *; }

# Keep media related classes
-keep class android.media.** { *; }
-keep class com.google.android.exoplayer.** { *; }

# Keep calendar related classes
-keep class java.util.Calendar { *; }
-keep class java.util.TimeZone { *; }

# Keep secure storage related classes
-keep class com.facebook.crypto.** { *; }
-keep class com.facebook.android.crypto.** { *; }

# Keep API models
-keep class com.hawkeyepatro.models.** { *; }

# Keep enum classes
-keepclassmembers enum * { *; }

# Keep parcelable classes
-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}

# Keep serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Ignore missing Play Core classes
-dontwarn com.google.android.play.core.**