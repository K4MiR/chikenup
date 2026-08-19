#!/usr/bin/env python3
"""
Configura a assinatura de release no build.gradle do app Capacitor
(legacy-capacitor/android/app/build.gradle), lendo as credenciais de
android/key.properties. Idempotente: se ja tiver sido aplicado, nao repete.
"""
import pathlib
import re
import sys

path = pathlib.Path("legacy-capacitor/android/app/build.gradle")
if not path.exists():
    print(f"ERRO: {path} nao encontrado")
    sys.exit(1)

text = path.read_text()

if "signingConfigs" in text:
    print("Signing config ja presente, nada a fazer.")
    sys.exit(0)

header = """import java.util.Properties
import java.io.FileInputStream

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

"""
text = header + text

signing_block = """    signingConfigs {
        release {
            if (keystoreProperties['storeFile']) {
                storeFile file(keystoreProperties['storeFile'])
                storePassword keystoreProperties['storePassword']
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
            }
        }
    }
"""

marker = "    buildTypes {"
if marker not in text:
    print("ERRO: bloco buildTypes nao encontrado")
    sys.exit(1)
text = text.replace(marker, signing_block + marker, 1)

# aponta o buildType release para a signingConfig criada
text = re.sub(
    r"(buildTypes \{\s*\n\s*release \{)",
    r"\1\n            signingConfig signingConfigs.release",
    text,
    count=1,
)

if "signingConfig signingConfigs.release" not in text:
    print("ERRO: nao consegui inserir o signingConfig no buildType release")
    print(text)
    sys.exit(1)

path.write_text(text)
print(f"Signing config inserida em {path}")
