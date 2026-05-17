## Context

O kube-news é uma aplicação Node.js/Express que conecta em PostgreSQL via variáveis de ambiente. Os arquivos `Dockerfile` e `docker-compose.yml` foram removidos do repositório e precisam ser recriados. O projeto é usado como material de ensino para Kubernetes/DevOps.

## Goals / Non-Goals

**Goals:**
- `Dockerfile` funcional para build da imagem da aplicação
- `docker-compose.yml` com app + PostgreSQL prontos para `docker compose up --build`
- Bind mounts em `.docker_vol/` para dados do PostgreSQL
- `.gitignore` atualizado

**Non-Goals:**
- Multi-stage build
- Publicação de imagem no Docker Hub (feita separadamente no pipeline CI/CD)
- Configuração de ambiente de produção

## Decisions

### Imagem base: `node:18-alpine`
Alpine reduz o tamanho da imagem sem necessidade de multi-stage. Preferência registrada: imagem única, sem multi-stage em projetos Node.js.

### `build: .` no Docker Compose
O Compose faz o build local da imagem. Permite iterar sem precisar publicar no registry.

### `DB_HOST: postgres`
O nome do host deve bater com o nome do serviço declarado no Compose (`postgres`). Qualquer outro valor impede a conexão entre containers na mesma rede.

### Rede nomeada `kube-news-net`
Rede explícita garante resolução de nomes entre serviços. A rede default do Compose também funcionaria, mas a rede nomeada é mais clara para fins didáticos.

### `restart: unless-stopped` no app
O app chama `initDatabase()` no boot via `sequelize.sync()`. Se o PostgreSQL ainda não estiver aceitando conexões, o container do app falha e reinicia automaticamente até conseguir conectar. `depends_on` garante apenas que o container suba, não que o Postgres esteja pronto.

### Bind mount: `.docker_vol/postgres`
Preferência explícita: nunca named volumes. Bind mount em `.docker_vol/<serviço>` facilita inspeção e limpeza dos dados em desenvolvimento.

## Risks / Trade-offs

- **Race condition no boot** → Mitigado com `restart: unless-stopped`. Alternativa mais robusta seria `healthcheck` no serviço postgres + `depends_on.condition: service_healthy`, mas adiciona complexidade desnecessária para o contexto didático.
- **`.docker_vol/` commitado por acidente** → Mitigado adicionando a entrada no `.gitignore`.
- **Versão do Node.js (18)** → LTS atual à época do projeto. Se o `package.json` não especifica `engines`, não há risco de incompatibilidade.
