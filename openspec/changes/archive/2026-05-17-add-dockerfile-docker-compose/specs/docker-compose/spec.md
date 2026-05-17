## ADDED Requirements

### Requirement: Ambiente local com app e PostgreSQL
O `docker-compose.yml` SHALL declarar dois serviços (`app` e `postgres`) em uma rede nomeada, com o serviço `app` fazendo build local (`build: .`) e o serviço `postgres` usando a imagem oficial `postgres:14`.

#### Scenario: Ambiente sobe com um único comando
- **WHEN** o usuário executa `docker compose up --build` na raiz do projeto
- **THEN** os containers de app e postgres iniciam e o app fica acessível em `http://localhost:8080`

#### Scenario: App conecta ao PostgreSQL pelo nome do serviço
- **WHEN** o container `app` inicializa
- **THEN** a variável `DB_HOST` aponta para `postgres` (nome do serviço) e a conexão é estabelecida com sucesso

#### Scenario: Dados do PostgreSQL persistem entre reinicializações
- **WHEN** os containers são parados e reiniciados
- **THEN** os dados do banco permanecem disponíveis via bind mount em `.docker_vol/postgres`

### Requirement: Bind mount para dados do PostgreSQL
O `docker-compose.yml` SHALL usar bind mount apontando para `.docker_vol/postgres` na raiz do projeto para persistência dos dados, nunca named volumes.

#### Scenario: Diretório de dados inspecionável no host
- **WHEN** o container postgres está rodando
- **THEN** os arquivos de dados estão visíveis em `.docker_vol/postgres/` no sistema de arquivos do host

### Requirement: Variáveis de ambiente do banco de dados
O serviço `app` SHALL receber as variáveis `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`, `DB_HOST` e `DB_PORT` via `environment:` no Compose, com valores alinhados às credenciais do serviço `postgres`.

#### Scenario: Conexão com credenciais corretas
- **WHEN** o app inicializa com as variáveis definidas no Compose
- **THEN** a conexão com o PostgreSQL é estabelecida sem erro de autenticação

### Requirement: Resiliência de inicialização do app
O serviço `app` SHALL ter `restart: unless-stopped` para tolerar race condition com o PostgreSQL subindo.

#### Scenario: App reinicia até o banco estar pronto
- **WHEN** o app tenta conectar ao PostgreSQL antes de ele estar pronto
- **THEN** o container reinicia automaticamente até conseguir estabelecer a conexão
