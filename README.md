# Chicken Up — Flutter

Reescrita em Flutter/Dart do jogo Chicken Up (originalmente HTML5 Canvas +
Capacitor, em `www/index.html` no repositório antigo). Esta é uma versão
**inicial (MVP)**: modo Corrida jogável, física de pulo, obstáculos, coleta
de milho, pontuação, recorde salvo localmente, e uma loja com 12 das 163
galinhas da versão original. O restante do conteúdo (chapéus, pegadas,
conquistas, modo Voo, laboratório, clima, dia/noite, chefes, ranking global
via Firebase, i18n completo) ainda não foi portado — vai entrando aos poucos.

## Build 100% na nuvem (sem instalar nada localmente)

Este projeto builda via GitHub Actions — não precisa de Flutter, Java nem
Android SDK instalados na sua máquina.

### 1. Gerar a keystore de assinatura (uma vez só)

1. Vá em **Actions** → **Generate signing keystore** → **Run workflow**.
2. Quando terminar, baixe o artifact `chickenup-keystore` (fica disponível
   por 7 dias — baixe logo).
3. Abra `keystore-info.txt` dentro do zip. Nele estão as senhas geradas.
4. Vá em **Settings → Secrets and variables → Actions** neste repositório e
   crie 4 *repository secrets*:
   - `KEYSTORE_BASE64` — cole o conteúdo do arquivo `chickenup-release.jks.base64`
   - `KEYSTORE_PASSWORD` — a senha `KEYSTORE_PASSWORD` do `keystore-info.txt`
   - `KEY_ALIAS` — `chickenup-release`
   - `KEY_PASSWORD` — a senha `KEY_PASSWORD` do `keystore-info.txt`
5. **Guarde o arquivo `chickenup-release.jks` e as senhas em local seguro**
   (gerenciador de senhas). Se perder, não dá mais para publicar
   atualizações do mesmo app na Play Store — só um app novo.

### 2. Buildar o APK/AAB assinado

- Todo push na branch `main` builda automaticamente, ou
- Vá em **Actions** → **Build signed APK** → **Run workflow** manualmente.
- Ao terminar, baixe os artifacts `chickenup-release-apk` (para instalar
  direto no celular) e `chickenup-release-aab` (para subir na Play Store).

## Rodar localmente (opcional, exige Flutter instalado)

```bash
flutter create --platforms=android --org com.shiftcriativo --project-name chickenup .
flutter pub get
flutter run
```

O `applicationId` (`com.shiftcriativo.chickenup`) é o mesmo do app antigo em
Capacitor, para permitir publicar como atualização da mesma ficha na Play
Store (desde que assinado com a keystore original ou uma "upload key" ligada
a ela via Play App Signing).
