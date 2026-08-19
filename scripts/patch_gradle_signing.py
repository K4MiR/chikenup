#!/usr/bin/env python3
"""
Insere a configuracao de assinatura de release no android/app/build.gradle(.kts)
gerado pelo `flutter create`. Roda a cada build no CI (o android/ nao fica
versionado no repo, e recriado do zero pelo Flutter em cada execucao), entao
este patch precisa ser idempotente e tolerar tanto o formato Groovy (.gradle)
quanto o Kotlin DSL (.gradle.kts) usados por diferentes versoes do Flutter.

Estrategia: em vez de tentar localizar o bloco `release { ... }` inteiro
(a sintaxe varia bastante entre versoes do Android Gradle Plugin — `release {`
vs `getByName("release") {`), so troca a linha
`signingConfig = signingConfigs.getByName("debug")` (kts) ou
`signingConfig signingConfigs.debug` (groovy) por uma equivalente apontando
pra "release". Essa linha e gerada pelo `flutter create` de forma bem estavel
em todas as versoes recentes, entao e um alvo mais confiavel.
"""
import pathlib
import re
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

    debug_ref = re.compile(r'signingConfig\s*=\s*signingConfigs\.getByName\("debug"\)')
    if not debug_ref.search(text):
        print("ERRO: referencia 'signingConfig = signingConfigs.getByName(\"debug\")' nao encontrada (kts)")
        print("----- conteudo do arquivo para debug -----")
        print(text)
        sys.exit(1)
    text = debug_ref.sub('signingConfig = signingConfigs.getByName("release")', text, count=1)

    # Android 16 = API 36. Forca compileSdk/targetSdk explicitos em vez de
    # depender do default do Flutter (flutter.compileSdkVersion), que muda
    # de versao pra versao do SDK.
    text = re.sub(r'compileSdk\s*=\s*flutter\.compileSdkVersion', 'compileSdk = 36', text)
    text = re.sub(r'targetSdk\s*=\s*flutter\.targetSdkVersion', 'targetSdk = 36', text)
else:
    header = '''import java.util.Properties
import java.io.FileInputStream

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

'''
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

    debug_ref = re.compile(r'signingConfig\s+signingConfigs\.debug')
    if not debug_ref.search(text):
        print("ERRO: referencia 'signingConfig signingConfigs.debug' nao encontrada (groovy)")
        print("----- conteudo do arquivo para debug -----")
        print(text)
        sys.exit(1)
    text = debug_ref.sub('signingConfig signingConfigs.release', text, count=1)

    text = re.sub(r'compileSdkVersion\s+flutter\.compileSdkVersion', 'compileSdkVersion 36', text)
    text = re.sub(r'targetSdkVersion\s+flutter\.targetSdkVersion', 'targetSdkVersion 36', text)

path.write_text(text)
print(f"Signing config inserida em {path}")
