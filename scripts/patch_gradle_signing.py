#!/usr/bin/env python3
"""
Insere a configuracao de assinatura de release no android/app/build.gradle(.kts)
gerado pelo `flutter create`. Roda a cada build no CI (o android/ nao fica
versionado no repo, e recriado do zero pelo Flutter em cada execucao), entao
este patch precisa ser idempotente e tolerar tanto o formato Groovy (.gradle)
quanto o Kotlin DSL (.gradle.kts) usados por diferentes versoes do Flutter.
"""
import pathlib
import sys

app_dir = pathlib.Path("android/app")
groovy = app_dir / "build.gradle"
kotlin = app_dir / "build.gradle.kts"

if kotlin.exists():
    path = kotlin
    is_kts = True
elif groovy.exists():
    path = groovy
    is_kts = False
else:
    print("ERRO: nem build.gradle nem build.gradle.kts encontrados em android/app/")
    sys.exit(1)

text = path.read_text()

if "signingConfigs.release" in text or "keystoreProperties" in text:
    print("Signing config ja presente, nada a fazer.")
    sys.exit(0)

if is_kts:
    header = '''import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

'''
    text = header + text

    signing_block = '''    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }
'''
    marker = "buildTypes {"
    if marker not in text:
        print("ERRO: bloco buildTypes nao encontrado (kts)")
        sys.exit(1)
    text = text.replace(marker, signing_block + "    " + marker, 1)
    text = text.replace(
        'getByName("release") {\n            signingConfig = signingConfigs.getByName("debug")',
        'getByName("release") {\n            signingConfig = signingConfigs.getByName("release")',
    )
    if 'signingConfig = signingConfigs.getByName("release")' not in text:
        # fallback: insere signingConfig na primeira ocorrencia de getByName("release") { ... }
        idx = text.find('getByName("release") {')
        if idx == -1:
            print("ERRO: bloco release do buildTypes nao encontrado (kts)")
            sys.exit(1)
        insert_at = text.find("{", idx) + 1
        text = text[:insert_at] + '\n            signingConfig = signingConfigs.getByName("release")' + text[insert_at:]
else:
    header = '''import java.util.Properties
import java.io.FileInputStream

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

'''
    # insere apos a ultima linha de "apply plugin" / "plugins {" bloco, ou no topo
    text = header + text

    signing_block = '''    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
'''
    marker = "buildTypes {"
    if marker not in text:
        print("ERRO: bloco buildTypes nao encontrado (groovy)")
        sys.exit(1)
    text = text.replace(marker, signing_block + "    " + marker, 1)
    text = text.replace(
        "signingConfig signingConfigs.debug",
        "signingConfig signingConfigs.release",
    )

path.write_text(text)
print(f"Signing config inserida em {path}")
