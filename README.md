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

### Subindo aplicação no localhost.

> Para visualizar a aplicação no seu navegador.

- Executar o comando na pasta da aplicação. `docker run -dp 3000:3000 getting-started`
- Acessar a aplicação `http://localhost:3000/`

#### Atualização de app | images.

> Para atualizar um app em execução precisamos recriar este container e para a recriação do mesmo é necessário o matar e depois levantar novamente.

- Caso o container esteja em execução você precisa derrubar o mesmo: `docker container rm -f [id-do-container]`
- Buildar o docker: `docker build -t getting-started .`
- Iniar o container que foi derrubado: `docker run -dp 3000:3000 getting-started`
#### Publicando imagem no docker hub.

> Publicar imagem no docker hub é como se fosse um git de images do docker.

- Criar uma conta de acesso ao docker hub.
- Criar uma imagem de teste chamada `alvesnelio/getting-started`.
- Logar no docker hub da maquina local.
- Criar uma tag da imagem desejada, de preferencia algo como `docker tag getting-started USER-NAME-DOCKER-HUB/getting-starte`
- Públicar imagem no docker hub;

> Para testar a imagem, só preciso acessar o dockerlab e baixar a imagem do docker hub. Exemplo:

- Rodar o comando de execução da imagem especificando apenas o location da imagem.
- `docker run-dp 3000:3000 alvesnelio/getting-started

#### Persistindo Banco de dados.

> Criar uma persistencia de volume.

```
Volumes:

OS volume fornecem a capacidade de conectar caminhos especificos do sistema de arquivos do container de volta a maquina host. Se um diretorio no container for montado, as alterações nesse diretorio também serão vistas na maquina host. Se montarmos esse mesmo diretorio nas reinicializações do container veremos os mesmos arquivos.
```

- Para criar uma persistencia de dados no container será necessáro a criação de volumes e também será necessário vincular estes volumes com o container.

- Criar volume. `docker volume create ***nome-exemplo-volume***`.
- Após a criação do volume, verifique se o container que deseja vincular o volume se encontra em execução. Caso se encontra em execução sera necessário matar o container.  `docker container rm -f ***id-container***`.
- Reinicie o container e adicionae o volume no mesmo container. `docker run -dp 3000:3000 -v ***nome-exemplo-volume***:***local-de-armazenamento-do-volume-no-container-em-execucao*** ***nome-container***`.
  - Exemplo: `docker run -dp 3000:3000 -v todo-db:/etc/todos getting-started`.
- Inspecionar volume `docker volume inspect ***id-container***`

#### Montagem de ligação (Use bind mounts)

> Controle exato do ponto de montagem no host. Pode ser usado para persistir os dados, porém normalmente se utiliza para fornecer dados ao container.