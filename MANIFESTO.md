# Manifesto — Mathi9 Kids

Documento de produto: o que foi feito, o que a aplicação é hoje, como as versões se relacionam e onde baixar o APK.

- **Produto:** Mathi9 Kids
- **Marca / desenvolvedora:** i9 Soluções Inteligentes
- **Slogan:** Cérebro no 9. Matemática que dá play.
- **Versão atual:** 2.1.1+4 (`pubspec.yaml` → `versionName` 2.1.1, `versionCode` 4)
- **Público:** infanto-juvenil, Ensino Fundamental 1 e 2 (Brasil, BNCC)
- **Modelo:** app familiar, 100% local, recompensa em I9$ trocada em dinheiro físico com o responsável
- **APK vigente:** [`apk/Mathi9Kids-v2.1.1.apk`](https://github.com/guerramg/Tabuada_I9/raw/cursor/tabuada-foco-tema-1a25/apk/Mathi9Kids-v2.1.1.apk)

---

## 1. Linha do tempo

### v1-beta — Tabuada I9 (`1.0.0`)

Estado original do repositório (`main` inicial):

- Flutter com 5 arquivos Dart (`HomePage`, `IndexPage`, `TabuadaPage`, `ExercicioPage`)
- Ver tabuada de 1–999 × 0–20
- Quiz aleatório de multiplicação 1–11, SnackBar verde/vermelho
- Sem banco, sem perfil, sem BNCC, sem gamificação
- Tema navy `#042a49`, navegação em 3 abas
- Pacote `br.com.i9ja.tabuadai9`

A v1-beta permanece como referência histórica. A v2 **substitui** essa UX no fluxo principal; o treino de tabuada volta na v2.1 como menu exclusivo em **Estudar**.

### v2 — plataforma Mathi9 Kids (`2.0.1+2`)

Reescrita na branch `cursor/mathi9-kids-82b1`, com conteúdo BNCC também originado em `cursor/bncc-math-content-4523` (90 JSON de lições/exercícios, 1º–9º).

Entregas principais, nesta ordem:

1. Identidade i9 (splash, Exo 2, paleta `#001220` / `#236AF4` / `#00C2FF`, logo PNG)
2. Onboarding local (nome, gênero, série máxima, teto, PIN)
3. SQLite (perfil, carteira, tarefas diárias, progresso, streaks, conquistas, eventos de foco)
4. Estudo por unidade BNCC: lição, tarefa, quiz, desafio, prova, revisão
5. Economia I9$ com teto mensal (50% diário / 20% extras / 30% bônus de mês completo)
6. Área do responsável (PIN)
7. Modo Foco (detecta saída do app na prova)
8. Kits Aventura / Estrela (só acentos e falas; o chrome continuava azul i9)
9. APK Android (assinatura debug da máquina que gerou o arquivo)
10. **Ano foco** (75% / 25% + prioridade de contas do 5º ao 9º) — **mas o mapa de matérias ainda listava anos acima do foco** (ex.: foco 5º com série máxima 9º mostrava 6º, 7º, 8º e 9º)

### v2.1 — teto do ano foco, tabuada, tema por gênero e APK instalável

Branch `cursor/tabuada-foco-tema-1a25` (PR [#2](https://github.com/guerramg/Tabuada_I9/pull/2)).

Pedido de produto atendido:

1. **Revisão do conteúdo de estudo.** Se o ano foco é 5º, o aluno estuda **5º e abaixo**. Não pode aparecer matéria de 6º, 7º, 8º ou 9º.
2. **Ênfase em multiplicação, divisão e problemas de raciocínio** nas sessões.
3. **Menu exclusivo de Treino de Tabuada** no ícone Estudar.
4. **Layout por gênero:** meninas rosa (kit Estrela); meninos azul i9 padrão (kit Aventura).
5. **APK para atualização**, mesmo pacote Android, sem apagar o SQLite — com correção posterior do erro “Aplicativo não instalado”.

Subversões desta linha:

| Versão | Código | O que aconteceu |
|---|---|---|
| `2.1.0+3` | 3 | Primeiro APK desta linha. `minSdk` 29 (só Android 10+), assinatura debug da VM, APK ~65 MB. **Falhou ao instalar** em aparelhos (“Aplicativo não instalado”). **Não usar.** |
| `2.1.1+4` | 4 | APK vigente. `minSdk` 24 (Android 7+), `targetSdk` 34, keystore estável `i9-release.jks`, libs nativas extraídas, fat APK ~37 MB com `armeabi-v7a` + `arm64-v8a` + `x86_64`. Arquivo publicado no repo. |

---

## 2. Estado atual da aplicação (v2.1.1)

### O que o aluno vê

| Tela | Função |
|---|---|
| Splash | Logo i9, título Mathi9 Kids, slogan, crédito “um app i9” (sempre identidade azul i9 — ainda sem perfil) |
| Onboarding | Nome, gênero (já aplica o tema rosa/azul na hora), **ano em que o aluno está** (vira ano foco e série máxima), teto em R$, PIN |
| Home | Saudação do kit, saldo I9$, tarefa do dia, calendário do mês, orçamento, desafio, revisão. Texto: só o ano foco e abaixo |
| Estudar | **Menu de duas entradas:** Treino de Tabuada (exclusivo) e Matérias BNCC |
| Treino de Tabuada | Ver tabela, treino ×, treino ÷ (tabuada invertida), quiz relâmpago (I9$ extra), contra o relógio. Tabuadas liberadas conforme o foco: 1–5 (até 2º), 1–10 (3º), 1–12 (4º+) |
| Mapa de matérias | Chips **somente de 1º até o ano foco**. 75% das questões no foco, 25% nos anteriores. Nada acima do foco |
| Tópico | Lição da série escolhida (≤ foco) + tarefa + quiz + desafio + prova misturados pelo ano foco |
| Quiz / prova | Questões, explicação descolada (rotina a cada item; prova só no fim) |
| Resultado | Acertos, I9$, conquistas |
| Carteira | Saldo, equivalente em R$, extrato (resgate **não** é do aluno) |
| Perfil | Kit, “estuda até o Nº ano”, streak, porta para a Área do Responsável |
| Conquistas | 20 badges |

### O que o responsável vê (PIN)

Aba **Controle**

- Gênero (Menino / Menina) → **layout inteiro** (azul i9 / rosa) e tom das falas
- Série máxima (1º–9º) → teto que o responsável **pode** liberar no slider de foco (não mostra matérias acima do foco atual)
- **Ano foco** → o que o aluno estuda agora: **este ano e os anteriores**. 75% das perguntas deste ano, 25% dos abaixo. Prioridade para ×, ÷ e problemas de raciocínio. Se o foco é 5º, 6º–9º permanecem bloqueados mesmo com série máxima 9º
- Modo Foco: prova (padrão ligado), desafio, opção de zerar a prova se sair

Aba **Orçamento**

- Teto mensal em R$ (1 I9$ = R$ 0,01)
- Divisão 50 / 20 / 30 (diário / extras / mês completo)
- Calendário de tarefas e I9$ já distribuídos no mês

Aba **Relatório**

- Tópicos fortes/fracos, streak, gráfico da divisão, saídas do app

Aba **Troca**

- Confirma a entrega física do dinheiro e zera o saldo resgatável

### Economia I9$

- Teto definido pelo responsável; o app **nunca** credita acima do teto no mês
- Tarefa do dia: 1 fatia (50% do teto ÷ dias do mês), uma vez por dia
- Quiz / desafio / prova (inclui quiz e desafio de tabuada): extra da fatia de 20% (prova > desafio > quiz)
- Mês 100% verde no último dia: bônus de 30%
- O que não foi conquistado **não é pago**

### Conteúdo e regras de estudo

**Teto do ano foco (obrigatório)**

- `Profile.studyCeiling` = ano foco, limitado pela série máxima
- `Profile.studyGrade` = chip do mapa, sempre `1 … studyCeiling`
- `ContentService.resolveStudyYear` **nunca** carrega pasta `ano{n}` com n maior que o foco
- Exemplo: foco 5º + série máxima 9º → chips 1º–5º; sessões 75% 5º + 25% 1º–4º; zero conteúdo de 6º–9º

**Ênfase em ×, ÷ e raciocínio**

- `SessionMix` (a partir do 2º ano) ordena o pool: habilidades-núcleo (mul/div/tabuada/problema/raciocínio) → outras contas → resto
- `OpsBank` injeta templates extras de multiplicação, divisão e problemas de enunciado em números/álgebra/revisão/misto; nas outras unidades entra problema temático com ×/÷
- Banco BNCC original (90 JSON em `assets/content/`) permanece; o mix é que prioriza contas

**Treino de Tabuada** (código)

- `lib/screens/study/study_menu_screen.dart` — menu da aba Estudar
- `lib/screens/study/tabuada_hub_screen.dart` — hub exclusivo
- `lib/screens/study/tabuada_table_screen.dart` — ver tabela
- `lib/services/tabuada_service.dart` — gera × e ÷

### Tema por gênero

| | Menino (Aventura) | Menina (Estrela) |
|---|---|---|
| Fundo | `#001220` navy i9 | `#1C0814` rosa-escuro |
| Primária | `#236AF4` azul i9 | `#E84A8A` rosa |
| Secundária | `#00C2FF` ciano | `#FF8DC7` rosa claro |
| Acento | laranja aventura | `#FF6BB5` star pink |
| Onde vale | scaffold, cards, circuito, botões, nav, chips, sliders | o mesmo chrome, paleta rosa |

Implementação: `AppPalette` em `lib/theme/app_theme.dart`; `CircuitBackground` e `GradientCard` leem o tema. Splash continua azul i9 (ainda não há perfil).

### Técnico

| Item | Valor |
|---|---|
| Stack | Flutter / Dart 3.9+, Provider, sqflite (+ ffi no desktop) |
| Persistência | SQLite local `mathi9_kids.db` (schema v2, coluna `focus_grade`). **Não** apagar na atualização: saldo, perfil, streak e progresso ficam se o APK for instalado **por cima** com a **mesma assinatura** |
| Pacote Android | `br.com.i9ja.tabuadai9` (mesmo id da v1-beta e da v2) |
| versionName / versionCode | `2.1.1` / `4` |
| minSdk | 24 — Android 7.0 Nougat (piso do Flutter 3.47). Não roda em Android 6 ou inferior |
| targetSdk | 34 (Android 14) — sideload mais estável em Xiaomi/Samsung/OPPO do que 35/36 |
| ABIs | `armeabi-v7a` (32 bits), `arm64-v8a` (64 bits), `x86_64` (emulador/tablet). Fat APK único |
| Native libs | `extractNativeLibs=true` / `useLegacyPackaging` (APK ~37 MB) |
| Assinatura | keystore sideload `android/app/i9-release.jks`, alias `i9upload`, esquemas **v2 + v3** (v1 some no AGP quando minSdk ≥ 24; no Android 7+ o v2 basta) |
| Sem backend | login, sync e loja online **não existem** |

---

## 3. APK — download, instalação e o erro “não instalado”

### Arquivo vigente

- **Nome:** `Mathi9Kids-v2.1.1.apk`
- **Caminho no repo:** `apk/Mathi9Kids-v2.1.1.apk`
- **Download direto:** https://github.com/guerramg/Tabuada_I9/raw/cursor/tabuada-foco-tema-1a25/apk/Mathi9Kids-v2.1.1.apk
- **Página (botão Download):** https://github.com/guerramg/Tabuada_I9/blob/cursor/tabuada-foco-tema-1a25/apk/Mathi9Kids-v2.1.1.apk
- **Build local:** `flutter build apk --release` → `build/app/outputs/flutter-apk/app-release.apk` (a pasta `build/` **não** vai ao GitHub; por isso o APK de distribuição vive em `apk/`)

**Não usar** `Mathi9Kids-v2.1.0.apk` (minSdk 29, assinatura debug da VM).

### Por que a v2.1.0 deu “Aplicativo não instalado”

1. `minSdk` 29 — celular com Android 7, 8 ou 9 recusa o pacote.
2. Android **não substitui** um app já instalado se a **assinatura for outra** (o APK da VM usava debug.keystore novo, diferente do que gerou o app no aparelho). A mensagem do sistema é só “Aplicativo não instalado”.
3. APK ~65 MB com libs nativas compactadas; alguns instaladores de fabricante falham.

A v2.1.1 corrige (1) e (3). O item (2) é regra do Android: **sem a chave original do APK que já está no celular, atualizar por cima é impossível**.

### Como instalar a v2.1.1

1. Baixe `Mathi9Kids-v2.1.1.apk` pelo link acima.
2. Permita instalar apps desta origem (fontes desconhecidas).
3. Tente instalar **por cima** do Mathi9 Kids atual.
4. Se ainda aparecer “Aplicativo não instalado”, o Android está barrando a chave. **Desinstale o Mathi9 Kids antigo e instale este APK.** O progresso local do app antigo some nesse caso (o banco vive no armazenamento privado do pacote).
5. Da v2.1.1 em diante, APKs gerados com `i9-release.jks` **atualizam por cima** sem desinstalar.

O app roda em **qualquer celular Android 7 ou superior**, 32 ou 64 bits.

---

## 4. O que está fora desta versão

- iOS como alvo de loja
- Conta na nuvem / sincronização entre aparelhos
- Loja virtual de I9$ (a troca é física)
- Pix ou pagamento eletrônico
- Monitoramento invasivo (keylogger, captura oculta) — só lifecycle / perda de foco
- Tipo de questão “arrastar ordem” ainda é placeholder na UI
- Publicação na Play Store (o keystore atual é de sideload, não de Play)
- Android 6 ou inferior (limite do Flutter 3.47)
- Recuperar progresso de um APK antigo assinado com outra chave (o SO não permite)

---

## 5. Branches e unificação

| Branch | Papel |
|---|---|
| `main` | Linha oficial após o merge da v2 |
| `cursor/mathi9-kids-82b1` | Desenvolvimento da plataforma v2 |
| `cursor/bncc-math-content-4523` | JSON BNCC 1º–9º (incorporado na v2) |
| `cursor/tabuada-foco-tema-1a25` | v2.1: teto do foco, tabuada, tema rosa/azul, APK 2.1.1 |

v1-beta e v2 estão unificadas em `main`. A v2.1 ainda vive na branch `cursor/tabuada-foco-tema-1a25` até o merge. PR: https://github.com/guerramg/Tabuada_I9/pull/2

---

## 6. Arquivos-chave da v2.1

| Arquivo | Papel |
|---|---|
| `lib/models/profile.dart` | `studyCeiling`, `studyGrade`, clamp do chip ao foco |
| `lib/services/content_service.dart` | `resolveStudyYear` — nunca acima do foco |
| `lib/services/session_mix.dart` | 75/25 + prioridade mul/div/problema |
| `lib/services/ops_bank.dart` | Banco extra de ×, ÷ e raciocínio |
| `lib/services/tabuada_service.dart` | Gerador do treino de tabuada |
| `lib/screens/study/study_menu_screen.dart` | Menu Estudar |
| `lib/screens/study/tabuada_hub_screen.dart` | Hub exclusivo da tabuada |
| `lib/theme/app_theme.dart` | Paletas azul i9 / rosa |
| `android/app/build.gradle.kts` | minSdk 24, targetSdk 34, keystore, ABIs |
| `android/app/i9-release.jks` | Chave sideload (futuras atualizações) |
| `apk/Mathi9Kids-v2.1.1.apk` | Binário de distribuição |

---

## 7. Como verificar

```bash
flutter test test/models_test.dart
flutter analyze lib
flutter build apk --release
```

Testes cobrem: teto do 5º (anos 6–9 bloqueados), `resolveStudyYear`, preferência mul/div, tabuada 7×1=7, OpsBank do 5º.

Fluxo mínimo de aceite:

1. Onboarding com gênero menina → chrome rosa; menino → azul i9
2. Responsável: série máxima 9º, ano foco 5º → Estudar **não** lista 6º–9º
3. Estudar → Treino de Tabuada → ver / × / ÷ / quiz
4. Tarefa do dia / quiz → contas de × ÷ e problemas aparecem com frequência
5. Instalar `Mathi9Kids-v2.1.1.apk` (por cima se a chave bater; senão desinstalar o antigo uma vez)
