# Chicken Up — App Android (Capacitor)

O jogo já está 100% pronto e jogável em `www/index.html` (abra esse arquivo direto no navegador pra testar agora mesmo, sem instalar nada).

Este pacote já vem com o **projeto Android nativo pronto** (pasta `android/`), gerado pelo Capacitor — ou seja, o trabalho de "criar o projeto" já está feito. Só falta compilar, o que precisa ser feito na sua máquina porque exige baixar o Android SDK/Gradle da Google (esse download está bloqueado no meu ambiente sandbox).

## Passo a passo (uns 15-20 min, incluindo downloads)

### 1. Pré-requisitos
- Instalar o **Node.js** (se ainda não tiver).
- Instalar o **Android Studio** (já vem com o SDK e o JDK necessários).

### 2. Reinstalar as dependências do projeto
Abra um terminal dentro da pasta `ChickenUpApp` e rode:

```bash
npm install
npx cap sync android
```

### 3. Abrir no Android Studio
- Abra o Android Studio → **Open** → selecione a pasta `ChickenUpApp/android`.
- Aguarde o Gradle sincronizar sozinho (primeira vez demora mais, baixa tudo).

### 4. Testar
Clique em **Run ▶** com um emulador ou celular conectado via USB (modo desenvolvedor + depuração USB ativados). O jogo deve abrir em tela cheia.

### 5. Trocar o ícone (opcional, recomendado)
O app usa o ícone padrão do Capacitor por enquanto. Pra trocar: no painel do projeto, clique com o botão direito em `app` → **New > Image Asset** → em "Path" selecione uma imagem quadrada (ex: 512×512px) com a arte da galinha → Next → Finish. Isso gera todos os tamanhos de ícone automaticamente.

### 6. Gerar o pacote para a Play Store
`Build > Generate Signed Bundle / APK` → escolha **Android App Bundle** → **Create new...** para criar seu keystore (defina senha e guarde em local seguro — sem ele você não consegue atualizar o app depois) → **release** → **Finish**.

Isso gera o arquivo `app-release.aab`, que é o que você sobe na Play Console.

### 7. Publicar
Siga o `GUIA_PUBLICACAO_PLAYSTORE.md` (do pacote enviado anteriormente) a partir do passo 4 em diante (conta de desenvolvedor, ficha da loja, classificação de conteúdo, upload) — esses passos são os mesmos independente de o app ter sido feito em Unity ou aqui em Capacitor.

## Se quiser só testar rápido sem Android Studio
Abra `www/index.html` direto no Chrome do seu celular — já dá pra jogar via navegador, só não fica instalável como app nativo até passar pelos passos acima.
