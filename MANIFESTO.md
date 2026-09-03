# Manifesto — Mathi9 Kids

Documento de produto: o que foi feito, o que a aplicação é hoje e como as versões se relacionam.

- **Produto:** Mathi9 Kids  
- **Marca / desenvolvedora:** i9 Soluções Inteligentes  
- **Slogan:** Cérebro no 9. Matemática que dá play.  
- **Versão atual:** 2.0.1+2 (`pubspec.yaml`)  
- **Público:** infanto-juvenil, Ensino Fundamental 1 e 2 (Brasil, BNCC)  
- **Modelo:** app familiar, 100% local, recompensa em I9$ trocada em dinheiro físico com o responsável  

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

A v1-beta permanece como referência histórica. A v2 **substitui** essa UX; não há mais as telas “Ver Tabuada” / “Gerar Cálculo” no fluxo principal.

### v2 — plataforma Mathi9 Kids

Reescrita na branch `cursor/mathi9-kids-82b1`, com conteúdo BNCC também originado em `cursor/bncc-math-content-4523` (90 JSON de lições/exercícios, 1º–9º).

Entregas principais, nesta ordem:

1. Identidade i9 (splash, Exo 2, paleta `#001220` / `#236AF4` / `#00C2FF`, logo PNG)
2. Onboarding local (nome, gênero, série máxima, teto, PIN)
3. SQLite (perfil, carteira, tarefas diárias, progresso, streaks, conquistas, eventos de foco)
4. Estudo por unidade BNCC: lição, tarefa, quiz, desafio, prova, revisão
5. Economia I9$ com teto mensal (50% diário / 20% extras / 30% bônus de mês completo)
6. Área do responsável (PIN)
7. Modo Foco (detecta saída do app na prova)
8. Kits Aventura / Estrela
9. APK Android
10. **Ano foco** (75% / 25% + prioridade de contas do 5º ao 9º)

---

## 2. Estado atual da aplicação

### O que o aluno vê

| Tela | Função |
|---|---|
| Splash | Logo i9, título Mathi9 Kids, slogan, crédito “um app i9” |
| Onboarding | Primeiro acesso: perfil + PIN + teto + série máxima |
| Home | Saudação do kit, saldo I9$, tarefa do dia, calendário do mês, orçamento, desafio, revisão |
| Estudar | Mapa das 5 unidades; chips de ano até a série máxima (lições) |
| Tópico | Lição + tarefa + quiz + desafio + prova |
| Quiz / prova | Questões, explicação descolada (rotina a cada item; prova só no fim) |
| Resultado | Acertos, I9$, conquistas |
| Carteira | Saldo, equivalente em R$, extrato (resgate **não** é do aluno) |
| Perfil | Dados, streak, porta para a Área do Responsável |
| Conquistas | 20 badges |

### O que o responsável vê (PIN)

Aba **Controle**

- Gênero (Menino / Menina) → kit visual e tom das falas
- Série máxima (1º–9º) → teto de conteúdo liberado
- **Ano foco** → 75% das questões deste ano, 25% dos anos abaixo; do 5º ao 9º o bloco de 75% prioriza contas e problemas (+ − × ÷)
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
- Quiz / desafio / prova: extra da fatia de 20% (prova > desafio > quiz)
- Mês 100% verde no último dia: bônus de 30%
- O que não foi conquistado **não é pago**

### Conteúdo

- 9 anos × 5 unidades: Números, Álgebra, Geometria, Grandezas e Medidas, Probabilidade e Estatística
- Arquivos em `assets/content/ano{n}/{unidade}/lesson.json` e `exercises.json`
- Tipos: numérico (templates com números sorteados), múltipla escolha, verdadeiro/falso
- Mistura de sessão: `lib/services/session_mix.dart`

### Técnico

| Item | Valor |
|---|---|
| Stack | Flutter / Dart 3.9, Provider, sqflite (+ ffi no desktop) |
| Persistência | SQLite local `mathi9_kids.db` (schema v2, coluna `focus_grade`) |
| Pacote Android | `br.com.i9ja.tabuadai9` |
| Assinatura APK | chave **debug** (sideload; não é Play Store) |
| Sem backend | login, sync e loja online **não existem** |

---

## 3. O que está fora desta versão

- iOS como alvo de loja
- Conta na nuvem / sincronização entre aparelhos
- Loja virtual de I9$ (a troca é física)
- Pix ou pagamento eletrônico
- Monitoramento invasivo (keylogger, captura oculta) — só lifecycle / perda de foco
- Tipo de questão “arrastar ordem” ainda é placeholder na UI
- Publicação na Play Store (faltaria keystore de release)

---

## 4. Branches e unificação

| Branch | Papel |
|---|---|
| `main` | Linha oficial após o merge da v2 |
| `cursor/mathi9-kids-82b1` | Desenvolvimento da plataforma v2 |
| `cursor/bncc-math-content-4523` | JSON BNCC 1º–9º (incorporado na v2) |

Todas foram unificadas em `main`. O histórico da v1-beta permanece nos commits iniciais (`Versão 1.0 - Primeiro Commit`).

---

## 5. Como verificar

```bash
flutter test test/models_test.dart
flutter analyze lib
flutter build apk --release
flutter build linux   # se o toolchain desktop estiver instalado
```

Fluxo mínimo de aceite: onboarding → tarefa do dia → resultado com I9$ → Carteira → Perfil → Área do Responsável (PIN) → Ano foco / teto / troca.
