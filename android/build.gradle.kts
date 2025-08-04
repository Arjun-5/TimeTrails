import java.util.Properties
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
val keystoreProperties = Properties().apply {
    val file = rootProject.file("android/key.properties")
    if (file.exists()) {
        file.inputStream().use { load(it) }
    }
}
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}