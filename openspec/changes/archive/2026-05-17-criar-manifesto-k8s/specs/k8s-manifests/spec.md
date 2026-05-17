## ADDED Requirements

### Requirement: Arquivo único de manifesto Kubernetes
O sistema SHALL fornecer um único arquivo `k8s/kube-news.yml` contendo todos os recursos Kubernetes separados por `---`, aplicável com um único comando `kubectl apply -f k8s/kube-news.yml`.

#### Scenario: Apply único cria todos os recursos
- **WHEN** o usuário executa `kubectl apply -f k8s/kube-news.yml` em um cluster com `storageClass: standard` e suporte a `LoadBalancer`
- **THEN** todos os recursos são criados na ordem correta: Namespace, Secret, PVC, Deployment do banco, Service do banco, Deployment da app, Service da app

### Requirement: Namespace isolado
O sistema SHALL criar um namespace `kube-news` e todos os recursos devem referenciar esse namespace no campo `metadata.namespace`.

#### Scenario: Recursos isolados por namespace
- **WHEN** os manifestos são aplicados
- **THEN** todos os recursos (Secret, PVC, Deployments, Services) existem dentro do namespace `kube-news`

### Requirement: Credenciais em Secret
O sistema SHALL armazenar as credenciais do PostgreSQL (`DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`, `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`) em um Secret Kubernetes. Os Deployments do banco e da app DEVEM referenciar esses valores via `secretKeyRef`.

#### Scenario: Deployment não expõe senha em texto plano
- **WHEN** o manifesto é inspecionado via `kubectl get deployment -o yaml`
- **THEN** nenhum campo `env.value` contém a senha; os valores são referenciados via `secretKeyRef`

### Requirement: Persistência do banco com PVC e subPath
O sistema SHALL criar um PersistentVolumeClaim com `storageClassName: standard` para o PostgreSQL. O `volumeMount` do banco DEVE usar `subPath: pgdata` e o env `PGDATA` DEVE apontar para `/var/lib/postgresql/data/pgdata`.

#### Scenario: Banco inicia sem erro de permissão em ext4
- **WHEN** o pod do PostgreSQL inicia pela primeira vez com um volume ext4
- **THEN** o banco inicializa sem erro relacionado a `lost+found` ou permissões no diretório de dados

### Requirement: Readiness probe no banco
O sistema SHALL configurar uma `readinessProbe` no Deployment do PostgreSQL usando `exec` com o comando `pg_isready -U <usuario> -d <banco>`, com `initialDelaySeconds: 5`, `periodSeconds: 5`, `timeoutSeconds: 5` e `failureThreshold: 5`.

#### Scenario: App aguarda banco estar pronto
- **WHEN** o pod do PostgreSQL está iniciando
- **THEN** o pod permanece em estado `Not Ready` até `pg_isready` retornar sucesso, impedindo que a app tente conectar antes do banco estar disponível

### Requirement: Probes da aplicação via endpoints HTTP
O sistema SHALL configurar `livenessProbe` em `/health` porta `8080` e `readinessProbe` em `/ready` porta `8080` no Deployment da aplicação.

#### Scenario: Pod reinicia quando app está unhealthy
- **WHEN** o endpoint `/health` retorna código diferente de 2xx por 3 verificações consecutivas
- **THEN** o Kubernetes reinicia o container automaticamente

#### Scenario: Pod sai do balanceamento quando não está pronto
- **WHEN** o endpoint `/ready` retorna código diferente de 2xx
- **THEN** o pod é removido do pool de endpoints do Service até retornar 2xx

### Requirement: Deployment da aplicação com 2 réplicas
O sistema SHALL configurar o Deployment da aplicação com `replicas: 2`.

#### Scenario: Alta disponibilidade da aplicação
- **WHEN** o Deployment está em estado `Ready`
- **THEN** existem 2 pods da aplicação em execução simultânea

### Requirement: Service da aplicação como LoadBalancer
O sistema SHALL criar um Service do tipo `LoadBalancer` para a aplicação, expondo a porta `80` e redirecionando para `targetPort: 8080`.

#### Scenario: Acesso externo via porta 80
- **WHEN** o Service recebe um IP externo do cluster
- **THEN** a aplicação é acessível na porta `80` sem necessidade de especificar porta no navegador

### Requirement: Service do banco como ClusterIP interno
O sistema SHALL criar um Service do tipo `ClusterIP` para o PostgreSQL, acessível pelo nome `postgres` dentro do namespace `kube-news` na porta `5432`.

#### Scenario: App conecta ao banco via DNS interno
- **WHEN** a aplicação tenta conectar usando `DB_HOST=postgres` e `DB_PORT=5432`
- **THEN** a conexão é resolvida para o pod do PostgreSQL via DNS do cluster
