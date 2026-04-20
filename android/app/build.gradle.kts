import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ── Release signing — reads credentials from android/key.properties ──────────
// key.properties is git-ignored; the keystore lives alongside it in android/.
// Both files must be present for a release build to succeed.
val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties()
if (keyPropertiesFile.exists()) {
    keyProperties.load(FileInputStream(keyPropertiesFile))
}

android {
    namespace = "com.anshin.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            // Falls back gracefully (no crash) when key.properties is absent
            // so debug/CI builds that don't need signing still work.
            if (keyPropertiesFile.exists()) {
                keyAlias      = keyProperties["keyAlias"]      as String
                keyPassword   = keyProperties["keyPassword"]   as String
                storeFile     = rootProject.file(keyProperties["storeFile"] as String)
                storePassword = keyProperties["storePassword"] as String
            }
        }
    }

    defaultConfig {
        applicationId = "com.anshin.app"
        minSdk        = flutter.minSdkVersion
        targetSdk     = flutter.targetSdkVersion
        versionCode   = flutter.versionCode
        versionName   = flutter.versionName
    }

    buildTypes {
        release {
            // Use release signing when key.properties is present;
            // fall back to debug signing only if the file is missing.
            signingConfig = if (keyPropertiesFile.exists())
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")

            isMinifyEnabled   = false   // Flutter manages Dart tree-shaking
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
