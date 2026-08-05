import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://jcenter.bintray.com") }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Force stable versions of androidx to avoid SDK 36 requirements if possible
subprojects {
    configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.group == "androidx.core" && (requested.name == "core" || requested.name == "core-ktx")) {
                useVersion("1.13.1")
            }
            if (requested.group == "androidx.browser" && requested.name == "browser") {
                useVersion("1.8.0")
            }
            if (requested.group == "androidx.activity" && (requested.name == "activity" || requested.name == "activity-ktx")) {
                useVersion("1.9.0")
            }
        }
    }
}

// Fix for missing namespace and force Kotlin/Java version/target
subprojects {
    plugins.withId("com.android.library") {
        val extension = project.extensions.getByType<com.android.build.gradle.LibraryExtension>()
        if (extension.namespace == null) {
            extension.namespace = "com.frinkels.plugins.${project.name.replace("-", "_")}"
        }
    }

    afterEvaluate {
        if (hasProperty("android")) {
            val android = extensions.findByName("android")
            if (android is com.android.build.gradle.BaseExtension) {
                android.compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
        }
    }

    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = "17"
        targetCompatibility = "17"
    }

    tasks.withType<KotlinCompile>().configureEach {
        kotlinOptions {
            languageVersion = "1.8"
            apiVersion = "1.8"
            jvmTarget = "17"
            freeCompilerArgs = freeCompilerArgs + listOf("-Xskip-metadata-version-check")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
