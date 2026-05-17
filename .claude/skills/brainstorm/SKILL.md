---
name: brainstorm
description: Entra em modo brainstorm para maturar ideias antes de qualquer implementação. Use esta skill quando o usuário quiser explorar uma ideia, discutir arquitetura, avaliar abordagens ou pensar em voz alta antes de codar — especialmente quando disser "vamos pensar", "quero discutir", "o que acha de", "tenho uma ideia", "brainstorm", ou quando a conversa for claramente exploratória e ainda não houver decisão tomada. Nunca cria, codifica ou executa nada até o usuário pedir explicitamente.
---

## O que esta skill faz

Ativa um modo de exploração livre onde o foco é maturar uma ideia antes de qualquer implementação. Apresenta perspectivas, trade-offs e opções sem tomar decisões pelo usuário. Só avança para código ou arquivos quando o usuário pedir explicitamente.

---

## Regras obrigatórias

### 1. Nenhuma ação sem pedido explícito

Proibido criar arquivos, editar código, rodar comandos ou propor PRs durante o brainstorm. O modo termina somente quando o usuário disser algo como "pode implementar", "vamos fazer", "cria o arquivo", "ok, vai em frente".

### 2. Apresentar no máximo 3 opções

Quando houver múltiplas abordagens, liste no máximo 3 — com nome, descrição curta e o principal trade-off de cada uma. Evite listas longas que dispersam o foco.

### 3. Recomendar explicitamente

Sempre indique qual opção você recomenda e por quê. Brainstorm sem recomendação é conversa sem direção.

### 4. Perguntas para refinar

Se a ideia estiver vaga, faça perguntas curtas e diretas para entender o contexto antes de propor alternativas. No máximo 2 perguntas por vez.

### 5. Contextualizar para o projeto

Todas as discussões devem considerar o contexto do projeto: aplicação Node.js containerizada, orquestrada com Kubernetes, banco PostgreSQL. Evite sugestões genéricas que ignoram essa stack.

---

## Processo de execução

1. **Entenda a ideia:** leia o que o usuário quer explorar. Se estiver vago, faça até 2 perguntas de refinamento.
2. **Explore o contexto:** verifique rapidamente os arquivos relevantes do projeto para embasar a discussão (sem editar nada).
3. **Apresente as opções:** liste até 3 abordagens com trade-offs claros.
4. **Recomende:** indique sua recomendação com justificativa objetiva.
5. **Aguarde decisão:** encerre com uma pergunta clara — "Qual abordagem quer seguir?" ou "Quer que eu implemente a opção X?"

---

## Formato de saída

```
## Brainstorm: <tema>

**Contexto identificado:** <resumo do que foi entendido>

### Opções

**Opção 1 — <nome>**
<descrição em 1-2 linhas>
Trade-off: <vantagem principal> vs <desvantagem principal>

**Opção 2 — <nome>**
...

**Opção 3 — <nome>**
...

### Recomendação
<opção recomendada> — <justificativa em 1-2 linhas>

---
Qual abordagem quer seguir?
```
