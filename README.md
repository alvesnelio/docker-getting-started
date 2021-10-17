# Aplicação

> Aplicação de estudo de Docker, ela foi baixada do repositorio `docker/getting-started/app` </br> do github com finalidade de aprendizagem do docker.

## Especificações

- Ubuntu: 20.04
- [Instalação do Docker e Docker Compose](https://alvesnelio.medium.com/instala%C3%A7%C3%A3o-do-docker-no-ubuntu-20-04-aaa20f55755d)
- Node: 12-Alpine
- Download do projeto de estudo do [Github official do Docker](https://github.com/docker/getting-started/tree/master/app)

## Inicialização

> Criar o arquivo Dockerfile com as seguintes configurações.

```
# syntax=docker/dockerfile:1
FROM node:12-alpine
RUN apk add --no-cache python g++ make
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
```

> levantar container `getting-started` com configurações do simples do Dockerfile no `localhost` da sua maquina.

- Nome da imagem do container: `getting-started`
- Portas de estudo: `3000`
- Username docker hub: `alvesnelio`
- Nome da rede: `todo-app`
- Acessar o diretorio baixado do repositório oficial do docker.
- Executar o comando `docker run -dp 3000:3000 [imagem-do-container]`
- Acessar a aplicação `http://localhost:3000/`

## Atualizações de APP | Images Docker

> Para atualizar um app em execução precisamos recriar este container e para a recriação do mesmo </br>
> será necessário remover o container em execução e depois o recriar novamente.

- Listar containers em execução: `docker container ps`
- Remover container em execução: `docker container rm -f [id-do-container]`
- Reconstruir o container em execução: `docker build -t [imagem-do-container] .`
- Recriar container: `docker run -dp [portas]:[portas] [imagem-do-container]`
## Publicando imagem no docker hub.

> Publicar imagem no docker hub é como se fosse um git de images do docker.

- Criar uma conta de acesso ao docker hub.
  - Apos criar a conta no docker hub e fazer login.
    - Criar uma imagem de teste no docker hub: `username-dockerhub/imagem-do-container`
- Logar no docker hub da maquina local.
  - Exemplo: `docker login -u alvesnelio`
- Criar uma tag da imagem desejada.
  - Exemplo: `docker tag getting-started alvesnelio/getting-started`
- Públicar imagem no docker hub;
  - Exemplo: `docker push alvesnelio/getting-started`

> Para testar se tudo ocorreu com sucesso, é preciso acessar o dockerlab e baixar a imagem do docker hub.

- Rodar o comando de execução da imagem especificando apenas o location da imagem.
- Acessar a plataforma [Play With Docker](https://labs.play-with-docker.com/)
- Executar o comando: `docker run -dp 3000:3000 alvesnelio/getting-started`

## Persistindo Banco de dados.

> Criar uma persistencia de volume. </br>
> 
*Volumes:* </br>
Os volume fornecem a capacidade de conectar caminhos especificos do sistema de arquivos do </br>
container de volta a maquina host. Se um diretorio no container for montado, as alterações </br>
nesse diretorio também serão vistas na maquina host. Se montarmos esse mesmo diretorio </br>
nas reinicializações do container veremos os mesmos arquivos.</br>
</br>

> Para criar uma persistencia de dados no container será necessáro a criação de volumes </br> 
> e também será necessário vincular estes volumes com o container.

- Criar volume. 
  - `docker volume create [nome-volume]`.
- Após a criação do volume, verifique se o container que deseja vincular o volume se encontra em execução. 
- `docker container ps`
- Caso se encontra em execução sera necessário matar o container.  
  - `docker container rm -f [id-container]`.
- Reinicie o container e adicionae o volume no mesmo container. 
  - `docker run -dp [portas:portas] -v [nome-volume]:[local-volume-container] [imagem-do-container]`.
  - Exemplo: `docker run -dp 3000:3000 -v todo-db:/etc/todos getting-started`.
- Inspecionar volume 
  - `docker volume inspect [id-container]`

## Montagem de ligação (Use bind mount)

Controle exato da montagem de ligação no host. </br>
Pode ser usado para persistir os dados, más costuma ser utilizado para fornecer dados adicionais aos container. </br>
Quando estamos trabalhando em uma aplicação, podemos utilizar o `bind mount` para montar nosso codigo fonte. </br>
O COntainer respondera e iremos ver as atualizações imediatamente.

### Tabela de diferenças de volume e bind mount

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
- Inicie o nodemon [nodemon](https://www.npmjs.com/package/nodemon) para observar as mudanças no sistema de arquivos.

#### Passo a passo.

- Certifique-se de não ter nenhuma `[imagem-do-container]` em execução.
- Execute o comando.
  - Comando `docker run -dp 3000:3000 -w /app -v "$(pwd):/app" node:12-alpine sh -c "yarn install && yarn run dev"`

- Explicação do comando.
  - `dp 3000:3000`: Mesmo de antes, container em execução no background na porta 3000.
  - `-w /app`: o item `-w` define o diretorio de trabalho `workdir` do dockerfile ou docker-compose.yml
  - `-v "$(pwd):/app"`: o item `-v` faz uma montagem do volume do `localhost` no `container` a ser executado
  - `node:12-alpine`: Imagem a ser utilizada. Está é a imagem base do arquivo Dockerfile.
  - `sh -c "yarn install && yarn run dev"` o comando inica um shell no container a ser executado e executa esses dois comandos `yarn`
  - `yarn install`: Instala todas as dependencias do package.json.
  - `yarn run dev`: Executa em background um [nodemon](https://www.npmjs.com/package/nodemon) para ficar ouvindo todas as alterações front-end.

- Visualização dos registros de logs deste comando.
  - `docker logs -f <container-id>` - resultad abaixo
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
#### Atualizações no codigo fonte do app ou na imagem

> Qualquer alterações realizadas no node `front-end`, </br>
> será escutada pelo container e atualizando a página web ja pode ser vistas as alterações.

- Sinta-se à vontade para fazer outras alterações que desejar. Quando terminar, remova o contêiner e recrie sua nova imagem.
- `docker build -t [imagem-do-container] .`

## Aplicativos de vários contêineres

> Para se trabalhar com multiplos conteineres em comunicação é necessário a existencia de uma rede. </br>
> Porque os containers conseguem se comunicar apenas se estiverem conectados a mesma rede.

*Observação* </br>
_Se dois contêineres estiverem na mesma rede, eles podem se comunicar. Se não forem, não podem._

### Criar rede comunicação de conteiners.

- Para criar uma rede de comunicação de conteiners é necessário executar o seguinte comando. `docker network create [nome-da-rede]`
  - `docker network create todo-app`

#### Iniciando o MySQL

> Este MySQL tem como foco apenas para rede de estudo do todo-list. (Projeto do próprio docker).
- Inicie um contêiner MySQL e conecte-o à rede. Também definiremos algumas variáveis ​​de ambiente que o banco de dados usará para inicializar o banco de dados (consulte a seção “Variáveis ​​de ambiente” na lista do [MySQL Docker Hub](https://hub.docker.com/_/mysql/) ).
```
docker run -d \
    --network todo-app --network-alias mysql \
    -v todo-mysql-data:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=secret \
    -e MYSQL_DATABASE=todos \
    mysql:5.7
```
- Para confirmar se o banco de dados está instalado e funcionando, conecte-se ao banco de dados e verifique se ele está conectado.
  - Execute o comando `docker exec -it <mysql-container-id> mysql -u root -p`
- Quando a solicitação de senha for exibida, digite secret . No shell do MySQL, liste os bancos de dados e verifique se você vê o todosbanco de dados.
  - Execute o comando `SHOW DATABASES;`

#### Conectando app ao MYSQl.

> Para conectar ao app todo list, segue a documentação que fala sobre o [nicolaka/netshoot](https://docs.docker.com/get-started/07_multi_container/#connect-to-mysql)

- Execute o seguinte comando: `docker run -it --network todo-app nicolaka/netshoot`
- Após levantar o container do nicolaka/netshoot
  - Execute o seguinte comando: `dig mysql`

- Resposta esperada
```
; <<>> DiG 9.14.1 <<>> mysql
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 32162
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;mysql.				IN	A

;; ANSWER SECTION:
mysql.			600	IN	A	172.23.0.2 <<<##### IP do container mysql. #####>>>

;; Query time: 0 msec
;; SERVER: 127.0.0.11#53(127.0.0.11)
;; WHEN: Tue Oct 01 23:47:24 UTC 2019
;; MSG SIZE  rcvd: 44
```

##### Conexão do app todo-list

> Para conectar o app todo-list com o mysql é necessário levantar o container com os parametros de conexão.

- Checar se o container `todo-list` | `getting-started` se encontra em execução.
  - Caso esteja em execução será necessario remover o mesmo.
- Levantar o container `todo-list` | `getting-started`
```
docker run -dp 3000:3000 \
   -w /app -v "$(pwd):/app" \
   --network todo-app \
   -e MYSQL_HOST=mysql \
   -e MYSQL_USER=root \
   -e MYSQL_PASSWORD=secret \
   -e MYSQL_DB=todos \
   node:12-alpine \
   sh -c "yarn install && yarn run dev"
```
- Se olharmos os logs do container (docker logs <container-id>), devemos ver uma mensagem indicando que ele está usando o banco de dados mysql.
- Abra o aplicativo em seu navegador e adicione alguns itens à sua lista de tarefas.
- Conecte-se ao banco de dados mysql e prove que os itens estão sendo gravados no banco de dados.
  - Execute o comando: `docker exec -it <mysql-container-id> mysql -p todos`
  - Após a conexão no container mysql execute o comando abaixo e visualizr os itens cadastrados na todo-list
  - `SELECT * FROM todo_items;`

