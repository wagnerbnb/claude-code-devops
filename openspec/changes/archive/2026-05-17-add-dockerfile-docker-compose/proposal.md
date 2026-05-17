## Why

O projeto kube-news não possui `Dockerfile` nem `docker-compose.yml` — eles foram removidos em um commit anterior. Sem esses arquivos, não é possível rodar o ambiente local de desenvolvimento de forma reproduzível nem fazer o build da imagem para publicação.

## What Changes

- Criação de `Dockerfile` para o app Node.js (imagem única, sem multi-stage)
- Criação de `docker-compose.yml` com serviços `app` e `postgres`
- Adição de `.docker_vol/` ao `.gitignore` para os bind mounts de dados

## Capabilities

### New Capabilities

- `dockerfile`: Imagem Docker do app Node.js pronta para build e push
- `docker-compose`: Ambiente local completo com app + PostgreSQL via `docker compose up --build`

### Modified Capabilities

## Impact

- Novo arquivo `Dockerfile` na raiz do projeto
- Novo arquivo `docker-compose.yml` na raiz do projeto
- `.gitignore` atualizado com entrada `.docker_vol/`
- Nenhuma alteração em código da aplicação
