import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties().apply {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use { load(it) }
    }
}

fun melangeProperty(name: String, fallback: String = ""): String {
    val fromLocalProperties = localProperties.getProperty(name)?.trim().orEmpty()
    val fromProjectProperty = (project.findProperty(name) as String?)?.trim().orEmpty()
    return fromLocalProperties.ifBlank { fromProjectProperty }.ifBlank { fallback }
}

val melangePersonalKey = melangeProperty("MELANGE_PERSONAL_KEY")
val melangeVoiceIntentModelName = melangeProperty(
    "MELANGE_VOICE_INTENT_MODEL_NAME",
    "google/gemma-3n-E2B-it",
)
val melangeInvoiceModelName = melangeProperty(
    "MELANGE_INVOICE_MODEL_NAME",
    "Menlo/Jan-nano",
)
val melangeAsrEncoderModelName = melangeProperty(
    "MELANGE_ASR_ENCODER_MODEL_NAME",
    "vaibhav-zetic/whisper_small_encoder",
)
val melangeAsrDecoderModelName = melangeProperty(
    "MELANGE_ASR_DECODER_MODEL_NAME",
    "OpenAI/whisper-tiny-decoder",
)
val melangeAsrModelName = melangeProperty(
    "MELANGE_ASR_MODEL_NAME",
    melangeAsrEncoderModelName,
)
val melangeLanguageModelName = melangeProperty(
    "MELANGE_LANGUAGE_MODEL_NAME",
    "SentenceTransformers/nli-MiniLM2-L6-H768",
)
val melangeInventoryModelName = melangeProperty(
    "MELANGE_INVENTORY_MODEL_NAME",
    "Qwen/Qwen3-Reranker-0.6B",
)

android {
    namespace = "com.vaani.ai"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.vaani.ai"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        buildConfigField("String", "MELANGE_PERSONAL_KEY", "\"$melangePersonalKey\"")
        buildConfigField("String", "MELANGE_VOICE_INTENT_MODEL_NAME", "\"$melangeVoiceIntentModelName\"")
        buildConfigField("String", "MELANGE_INVOICE_MODEL_NAME", "\"$melangeInvoiceModelName\"")
        buildConfigField("String", "MELANGE_ASR_ENCODER_MODEL_NAME", "\"$melangeAsrEncoderModelName\"")
        buildConfigField("String", "MELANGE_ASR_DECODER_MODEL_NAME", "\"$melangeAsrDecoderModelName\"")
        buildConfigField("String", "MELANGE_ASR_MODEL_NAME", "\"$melangeAsrModelName\"")
        buildConfigField("String", "MELANGE_LANGUAGE_MODEL_NAME", "\"$melangeLanguageModelName\"")
        buildConfigField("String", "MELANGE_INVENTORY_MODEL_NAME", "\"$melangeInventoryModelName\"")
        buildConfigField("String", "MELANGE_MODEL_NAME", "\"$melangeVoiceIntentModelName\"")
    }

    buildTypes {
        release {
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("com.zeticai.mlange:mlange:1.8.1+")
}

flutter {
    source = "../.."
}
