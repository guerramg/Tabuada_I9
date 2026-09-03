# Mathi9 Kids

Plataforma de matemática infanto-juvenil (Ensino Fundamental 1 e 2) alinhada à BNCC.

**Um app i9** — i9 Soluções Inteligentes.

> Cérebro no 9. Matemática que dá play.

Documento completo do produto: [MANIFESTO.md](MANIFESTO.md).

---

## Versões

### v1-beta — Tabuada I9

Primeira versão do projeto (`1.0.0`). App Flutter simples de tabuada:

- Home com imagem de boas-vindas
- Visualizador de tabuada (número × 0 a 20)
- Exercício aleatório de multiplicação (1–11) com feedback certo/errado
- Sem persistência, perfil, currículo BNCC ou recompensas
- UI em azul-marinho, três abas (Home, Ver Tabuada, Exercício)

Essa linha é a **v1-beta**: válida como estudo de tabuada, mas sem a plataforma completa.

### v2 — Mathi9 Kids (atual)

Versão **2.0.1+2**. Reescrita como plataforma familiar de matemática:

- Conteúdo BNCC do 1º ao 9º ano (5 unidades temáticas)
- Lição + tarefa do dia + quiz + desafio + prova + revisão
- Moeda **I9$** (1 I9$ = R$ 0,01), teto mensal e troca física com o responsável
- Painel do responsável (PIN): gênero, série máxima, **ano foco**, orçamento, modo foco, relatório, resgate
- Ano foco: **75%** das questões da série escolhida, **25%** das anteriores; do 5º ao 9º o bloco de 75% prioriza contas e problemas (+ − × ÷)
- Kits visuais Aventura (menino) / Estrela (menina) sobre a identidade i9
- Conta 100% local (SQLite), sem backend
- Android e desktop (Windows / Linux). iOS não é alvo de publicação

---

## Plataformas

| Alvo | Status |
|---|---|
| Android | APK release (`Mathi9Kids-v2.0.1.apk`) |
| Windows / Linux | Desktop Flutter |
| iOS | Pasta no repo, **não** é alvo |

## Como rodar

```bash
flutter pub get
flutter run -d linux
# ou
flutter run -d android
```

APK Android:

```bash
flutter build apk --release
# saída: build/app/outputs/flutter-apk/app-release.apk
```

## Licença

MIT — criado por [Raphael Guerra](https://github.com/guerramg).
