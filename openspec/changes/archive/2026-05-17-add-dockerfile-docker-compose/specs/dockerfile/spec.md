## ADDED Requirements

### Requirement: Imagem Docker da aplicação Node.js
O `Dockerfile` SHALL produzir uma imagem funcional do app kube-news baseada em `node:18-alpine`, com workdir `/app`, instalação de dependências via `npm install` e exposição da porta `8080`.

#### Scenario: Build bem-sucedido
- **WHEN** o usuário executa `docker build -t kube-news .` na raiz do projeto
- **THEN** a imagem é criada sem erros com todos os pacotes do `package.json` instalados

#### Scenario: Container inicia e ouve na porta 8080
- **WHEN** o container é iniciado com as variáveis de ambiente de banco de dados configuradas
- **THEN** a aplicação responde em `http://localhost:8080`

#### Scenario: Imagem usa estágio único
- **WHEN** o `Dockerfile` é inspecionado
- **THEN** há exatamente um instrução `FROM` (sem multi-stage build)
