# CONFIGURAÇÃO DAS VARIÁVEIS DO TERMINAL.
BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
WHITE=`tput setaf 7`
RESET=`tput sgr0`

#CONFIGURAÇÕES DE BANCO DE DADOS
MYSQL_HOST=`mysql`
MYSQL_USER=`root`
MYSQL_PASSWORD=`secret`
MYSQL_ROOT_PASSWORD=MYSQL_PASSWORD
MYSQL_DATABASE=`todos`
MYSQL_DB=MYSQL_DATABASE

#Comandos de docker
docker-up-basic:
	@$(MAKE) docker-up-localhost-80
	@$(MAKE) docker-up-localhost-mysql
	@$(MAKE) docker-up-localhost-3000
# 	@$(MAKE) docker-op-localhost-mysql-nicolaka-netshoot
.PHONY: up-basic

docker-up-localhost-mysql:
	@echo "${RESET}${BLUE}Levantando o container ${GREEN}Mysql 5.7${RESET}"
	@docker run -d --network todo-app --network-alias mysql -v todo-mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=todos mysql:5.7;
.PHONY: docker-up-localhost-mysql

docker-op-localhost-mysql-nicolaka-netshoot:
	@echo "${RESET}${BLUE}Levantando o container para solução de problemas e depuração de rede.${RESET}"
	@docker run -it --network todo-app nicolaka/netshoot;
.PHONY: docker-up-localhost-mysql

docker-up-localhost-80:
	@echo "${RESET}${BLUE}Levantando o container ${GREEN}docker/getting-started ${YELLOW} http:localhost:80${RESET}"
	@docker run -dp 80:80 docker/getting-started;
.PHONY: docker-up-localhost-80

docker-up-localhost-3000:
	@echo "${RESET}${BLUE}Levantando o container ${GREEN}getting-started ${YELLOW} http:localhost:3000${RESET}"
	@docker run -dp 3000:3000 -w /app -v "/home/nelio/DEV/estudos/docker/docker-getting-started:/app" --network todo-app -e MYSQL_HOST=mysql -e MYSQL_USER=root -e MYSQL_PASSWORD=secret -e MYSQL_DB=todos node:12-alpine sh -c "yarn install && yarn run dev";
.PHONY: docker-up-localhost-3000

docker-list-all:
	@echo "${RESET}${BLUE}Listando todos os ${GREEN}ID ${BLUE}Containers em execução ${RESET}"
	@docker container ps -q -a;
.PHONY: docker-list-all