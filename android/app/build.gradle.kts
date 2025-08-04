plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.android.libraries.mapsplatform.secrets-gradle-plugin")
}
import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}
android {
    namespace = "com.lostThoughtStudios.time_trails"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    } 
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
    secrets {
        propertiesFileName = "secrets.properties"
    }
    
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.lostThoughtStudios.time_trails"
        minSdk = 28
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    signingConfigs{
        create("release") {
            storeFile = file(keystoreProperties["storeFile"] ?: "release-keystore.jks")
            storePassword = keystoreProperties["storePassword"] as String? ?: ""
            keyAlias = keystoreProperties["keyAlias"] as String? ?: ""
            keyPassword = keystoreProperties["keyPassword"] as String? ?: ""
        }
    }
    buildTypes {
        /* release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        } */
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}