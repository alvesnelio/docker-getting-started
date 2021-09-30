## Aplicação

> Aplicação de estudo de Docker, ela foi baixada do repositorio docker/getting-started do github com finalidade de aprendizado de docker.

### Especificações

- [Instalação do Docker e Docker Compose](https://alvesnelio.medium.com/instala%C3%A7%C3%A3o-do-docker-no-ubuntu-20-04-aaa20f55755d)
- Node: 12-Alpine

> Criação do Dockerfile com as seguintes configurações.

```
# syntax=docker/dockerfile:1
FROM node:12-alpine
RUN apk add --no-cache python g++ make
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
```

### Subindo aplicação.

> Para visualizar a aplicação no seu navegador.

- Executar o comando na pasta da aplicação. `docker run -dp 3000:3000 getting-started`
- Acessar a aplicação `http://localhost:3000/`
