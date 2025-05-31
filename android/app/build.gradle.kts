plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.Mikiyas6.code2codes"
    ndkVersion = "27.0.12077973"

    // ✅ Add this line to fix the error
    // compileSdk = 34

    compileSdk = 35


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.Mikiyas6.code2codes"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    // defaultConfig {
    //     applicationId = "com.Mikiyas6.code2codes"
    //     minSdk = flutter.minSdkVersion
    //     targetSdk = flutter.targetSdkVersion
    //     versionCode = flutter.versionCode
    //     versionName = flutter.versionName
    // }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
