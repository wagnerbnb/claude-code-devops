## Context

A aplicação kube-news é um portal de notícias Node.js + Express que depende de um PostgreSQL. Atualmente só existe `docker-compose.yml` para execução local. O repositório não possui manifestos Kubernetes — o diretório `k8s-bo/` foi removido em commit anterior. O objetivo é criar manifestos genéricos que funcionem em qualquer cluster Kubernetes sem assumir provedor específico.

## Goals / Non-Goals

**Goals:**
- Arquivo único `k8s/kube-news.yml` com todos os recursos separados por `---`
- Namespace isolado `kube-news`
- Credenciais em Secret (sem hardcode em Deployment)
- PVC genérico com `storageClass: standard`
- Deployment do PostgreSQL com probe de readiness
- Deployment da app com 2 réplicas e probes via `/health` e `/ready`
- Service `ClusterIP` para o banco e `LoadBalancer` porta 80 para a app

**Non-Goals:**
- StatefulSet para o banco (fora do escopo da skill)
- Helm chart ou Kustomize
- Secrets gerenciados externamente (Vault, AWS Secrets Manager)
- Ingress ou TLS
- HorizontalPodAutoscaler
- Redis, cache ou outras dependências além do PostgreSQL

## Decisions

| Decisão | Escolha | Alternativa considerada | Justificativa |
|---|---|---|---|
| Organização | Arquivo único `k8s/kube-news.yml` | Múltiplos arquivos por recurso | Simplicidade para demos; um único `kubectl apply -f` |
| Namespace | `kube-news` (nome do diretório raiz) | `app` (nome do serviço no compose) | `app` é genérico e colide em clusters multi-app |
| Credenciais | Secret Kubernetes com base64 | Hardcode em env | Separação de config e segredo; padrão do ecossistema |
| Storage | PVC `storageClass: standard` | `hostPath` | Genérico; funciona em qualquer cluster com dynamic provisioning |
| subPath | `pgdata` + env `PGDATA` | Mount direto | Evita erro em sistemas ext4 com `lost+found` no root do volume |
| Imagem do banco | `postgres:14-alpine` | `postgres:14` | Alpine é menor; mesma versão major do docker-compose |
| Réplicas da app | `2` | `1` | Demonstra alta disponibilidade no contexto do evento |
| Service da app | `LoadBalancer` porta 80 | `NodePort` | Mais simples para o usuário final; evita mapear porta manualmente |

## Risks / Trade-offs

- **StorageClass `standard` pode não existir no cluster** → Mitigação: documentar no YAML que o usuário deve verificar com `kubectl get storageclass`
- **`LoadBalancer` sem suporte local** (Minikube sem MetalLB, kind) → Mitigação: comentar no YAML que pode ser substituído por `NodePort` ou usar `minikube tunnel`
- **Secret com base64 hardcoded no arquivo** → Mitigação: adicionar comentário alertando para não commitar o arquivo com senhas reais em produção
- **Deployment do banco sem StatefulSet** → Comportamento: reinicialização do pod pode causar perda de dados se o PVC não for remontado corretamente. Aceitável para ambiente de demo.
- **2 réplicas da app compartilham estado in-memory** (`PUT /unhealth`, `PUT /unreadyfor`) → Comportamento esperado em demo; não há sessão compartilhada entre réplicas
