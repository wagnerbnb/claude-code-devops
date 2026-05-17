## Why

A aplicação kube-news não possui manifestos Kubernetes, impedindo seu deploy em clusters. Com o `k8s-bo/` removido do repositório, é necessário criar manifestos genéricos que funcionem em qualquer cluster para uso em demonstrações e no evento Claude Code para DevOps.

## What Changes

- Criação do arquivo `k8s/kube-news.yml` com todos os recursos Kubernetes em um único manifesto separado por `---`
- Configuração de Secret para credenciais do PostgreSQL (sem hardcode em Deployments)
- PersistentVolumeClaim para persistência do banco com `subPath` para evitar conflito com `lost+found`
- Deployment do PostgreSQL com `readinessProbe` via `pg_isready`
- Deployment da aplicação com 2 réplicas, `livenessProbe` em `/health` e `readinessProbe` em `/ready`
- Service interno (`ClusterIP`) para o PostgreSQL
- Service externo (`LoadBalancer`) para a aplicação na porta 80

## Capabilities

### New Capabilities

- `k8s-manifests`: Manifesto único com todos os recursos Kubernetes para rodar kube-news + PostgreSQL em qualquer cluster

### Modified Capabilities

## Impact

- Novo diretório `k8s/` na raiz do projeto
- Novo arquivo `k8s/kube-news.yml`
- Sem impacto em código existente (`src/`), Dockerfile ou docker-compose.yml
- Dependência de cluster com suporte a `LoadBalancer` e `StorageClass: standard`
