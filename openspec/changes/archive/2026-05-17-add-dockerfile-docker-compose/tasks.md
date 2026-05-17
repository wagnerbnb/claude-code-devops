## 1. Dockerfile

- [x] 1.1 Criar `Dockerfile` na raiz do projeto com `FROM node:18-alpine`, `WORKDIR /app`, cópia do `src/` e `npm install`
- [x] 1.2 Definir `EXPOSE 8080` e `CMD ["node", "server.js"]` no `Dockerfile`

## 2. Docker Compose

- [x] 2.1 Criar `docker-compose.yml` na raiz com serviço `app` usando `build: .`, porta `8080:8080` e variáveis de ambiente do banco
- [x] 2.2 Adicionar serviço `postgres` com imagem `postgres:14`, variáveis de ambiente e bind mount para `.docker_vol/postgres:/var/lib/postgresql/data`
- [x] 2.3 Adicionar `restart: unless-stopped` ao serviço `app`
- [x] 2.4 Adicionar rede nomeada `kube-news-net` e associar os dois serviços a ela

## 3. Gitignore

- [x] 3.1 Adicionar `.docker_vol/` ao `.gitignore` (criar o arquivo se não existir)

## 4. Validação e Testes

- [x] 4.1 Executar `docker build -t kube-news:test .` e verificar que o build conclui sem erros
- [x] 4.2 Executar `docker compose up --build -d` e verificar que os dois containers sobem com status `running`
- [x] 4.3 Executar `curl -f http://localhost:8080` e verificar que a aplicação responde com status HTTP 200
- [x] 4.4 Executar `curl -f http://localhost:8080/health` e verificar que o endpoint de health retorna 200
- [x] 4.5 Executar `docker compose down` para limpar o ambiente após os testes
