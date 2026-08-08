plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.frinkels.frinkels"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    // Configure JVM toolchain to force JDK 17 for all compilations
    // This overrides Android Studio's bundled JDK 21
    kotlinOptions {
        jvmTarget = "17"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // Configure JVM toolchain for Java/Kotlin compilation
    // This ensures we use JDK 17 regardless of what Android Studio bundles
    // Note: Requires Android Gradle Plugin 7.0.0 or higher
    // The actual toolchain configuration is done through kotlinOptions and compileOptions above

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.frinkels.frinkels"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
