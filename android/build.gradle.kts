import com.android.build.gradle.BaseExtension
import com.android.build.gradle.LibraryExtension
import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val customBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(customBuildDir)

subprojects {

    val subprojectBuildDir = customBuildDir.dir(project.name)
    project.layout.buildDirectory.set(subprojectBuildDir)

    afterEvaluate {

        // 🔥 إجبار كل المشاريع تستخدم SDK 36
        extensions.findByType(BaseExtension::class.java)?.apply {
            compileSdkVersion(36)

            defaultConfig {
                targetSdk = 36
            }
        }

        // 🔥 حل مشكلة namespace
        extensions.findByType(LibraryExtension::class.java)?.apply {
            if (namespace == null) {
                namespace = "auto.namespace.${project.name}"
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}