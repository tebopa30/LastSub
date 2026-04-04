plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.tebopa.lastsub"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.tebopa.lastsub"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ── リリース署名設定 ──────────────────────────────────────
    // Google Play 公開時は以下のコメントを解除し、キーストア情報を設定してください。
    // キーストアファイルは VCS にコミットせず、環境変数や local.properties 経由で参照すること。
    //
    // signingConfigs {
    //     create("release") {
    //         storeFile = file(System.getenv("KEYSTORE_PATH") ?: "keystore/lastsub.jks")
    //         storePassword = System.getenv("KEYSTORE_PASSWORD") ?: ""
    //         keyAlias = System.getenv("KEY_ALIAS") ?: "lastsub"
    //         keyPassword = System.getenv("KEY_PASSWORD") ?: ""
    //     }
    // }

    buildTypes {
        release {
            // リリース署名設定が準備できたら signingConfigs.getByName("release") に変更する
            signingConfig = signingConfigs.getByName("debug")
            // コード圧縮・難読化（R8）
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
