# Aplicação

> Aplicação de estudo de Docker, ela foi baixada do repositorio docker/getting-started do github com finalidade de aprendizado de docker.

## Especificações

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

## Subindo aplicação "localhost do docker started".

> Para visualizar a aplicação no seu navegador.

- Executar o comando na pasta da aplicação. `docker run -dp 3000:3000 getting-started`
- Acessar a aplicação `http://localhost:3000/`

## Atualização de app | images.

> Para atualizar um app em execução precisamos recriar este container e <br>
> para a recriação do mesmo é necessário o matar e depois levantar novamente.

- Caso o container esteja em execução você precisa derrubar o mesmo: `docker container rm -f [id-do-container]`
- Buildar o docker: `docker build -t getting-started .`
- Iniciar o container que foi derrubado: `docker run -dp 3000:3000 getting-started`
## Publicando imagem no docker hub.

> Publicar imagem no docker hub é como se fosse um git de images do docker.

- Criar uma conta de acesso ao docker hub.
- Criar uma imagem de teste chamada `alvesnelio/getting-started`.
- Logar no docker hub da maquina local.
- Criar uma tag da imagem desejada, de preferencia algo como `docker tag getting-started [user-name-docker-hub]/getting-started`
- Públicar imagem no docker hub;

> Para testar a imagem, só preciso acessar o dockerlab e baixar a imagem do docker hub. Exemplo:

- Rodar o comando de execução da imagem especificando apenas o location da imagem.
- `docker run-dp 3000:3000 alvesnelio/getting-started

## Persistindo Banco de dados.

> Criar uma persistencia de volume.

```
Volumes:

Os volume fornecem a capacidade de conectar caminhos especificos do sistema de arquivos do 
container de volta a maquina host. Se um diretorio no container for montado, as alterações 
nesse diretorio também serão vistas na maquina host. Se montarmos esse mesmo diretorio 
nas reinicializações do container veremos os mesmos arquivos.
```

- Para criar uma persistencia de dados no container será necessáro a criação de volumes e também será necessário vincular estes volumes com o container.

- Criar volume. 
  - `docker volume create [nome-volume]`.
- Após a criação do volume, verifique se o container que deseja vincular o volume se encontra em execução. Caso se encontra em execução sera necessário matar o container.  
  - `docker container rm -f [id-container]`.
- Reinicie o container e adicionae o volume no mesmo container. 
  - `docker run -dp [portas-container:portas-container] -v [nome-volume]:[local-do-volume-no-container-em-execucao] [nome-container]`.
  - Exemplo: `docker run -dp 3000:3000 -v todo-db:/etc/todos getting-started`.
- Inspecionar volume 
  - `docker volume inspect [id-container]`

## Montagem de ligação (Use bind mounts)

> Controle exato da montagem de ligação no host. <br>
> Pode ser usado para persistir os dados, más costuma ser utilizado para fornecer dados adicionais aos container. <br>
> Quando estamos trabalhando em uma aplicação, podemos utilizar o `bind mount` para montar nosso codigo fonte. <br>
> O COntainer respondera e iremos ver as atualizações imediatamente.

|                                                    | Volumes                             | Bind Mount                             |
| -------------------------------------------------- | ----------------------------------- | -------------------------------------- |
| Localização do host                                | Docker escolhe                      | Você controla                          |
| Exemplo de montagem (usando -v)                    | [nome-volume]:[diretorio-container] | [diretorio-host]:[diretorio-container] |
| Preenche o novo volume com o conteúdo do contêiner | Sim                                 | Não                                    |
| Suporta drivers de volume                          | Sim                                 | Não                                    |

### Exemplo de bind mount.

> Inicializar o container no modo de desenvolvimento.

- Monte o código-fonte no contêiner.
- Instale todas as dependências, incluindo as dependências "`dev`".
- Inicie o nodemon [yarn] para observar as mudanças no sistema de arquivos.

- Execução.
  - Certifique-se de não ter nenhum `[nome-container]` contêiner anterior em execução.
  - Execute o seguinte comando.
    ``` 
    docker run -dp 3000:3000 \
    -w /app -v "$(pwd):/app" \
    node:12-alpine \
    sh -c "yarn install && yarn run dev"
    ```

- Explicação do comando.
  - `dp 3000:3000`: Mesmo de antes, container em execução no background na porta 3000.
  - `-w /app`: o item `-w` define o diretorio de trabalho `workdir` do dockerfile ou docker-compose.yml
  - `-v "$(pwd):/app"`: o uitem `-v` faz uma montagem do volume do `host local` no `container` a ser executado
  - `node:12-alpine`: Imagem a ser utilizada. Está é a imagem base do arquivo Dockerfile.
  - `sh -c "yarn install && yarn run dev"` o comando inica um shell no container a ser executado e executa esses dois comandos `yarn`
  - `yarn install`: Instala todas as dependencias do package.json.
  - `yarn run dev`: Executa em background um [nodemon](https://www.npmjs.com/package/nodemon) para ficar ouvindo todas as alterações front-end.

- Visualização dos registros de logs deste comando.
  - `docker logs -f <container-id>`
    ```
    yarn install v1.22.5
    [1/4] Resolving packages...
    success Already up-to-date.
    Done in 0.57s.
    yarn run v1.22.5
    $ nodemon src/index.js
    [nodemon] 1.19.2
    [nodemon] to restart at any time, enter `rs`
    [nodemon] watching dir(s): *.*
    [nodemon] starting `node src/index.js`
    Using sqlite database at /etc/todos/todo.db
    Listening on port 300
    ```

- Qualquer alterações realizadas no node `front-end`, será escutada pelo container e atualizando a página ja pode ser vistas as alterações.
- Sinta-se à vontade para fazer outras alterações que desejar. Quando terminar, remova o contêiner e crie sua nova imagem.
- `docker build -t getting-started .`