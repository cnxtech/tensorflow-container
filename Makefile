#M tensorflow-container akefile

default: build

build:
	sed -i -e '/GITHUB_TOKEN/d' ansible/group_vars/all
	echo GITHUB_TOKEN: ${GITHUB_TOKEN} >>ansible/group_vars/all
	ansible-container --debug build 
	sed -i -e '/GITHUB_TOKEN/d' ansible/group_vars/all

run:
	ansible-container run 

debug:
	ansible-container --debug run

venv:
	virtualenv venv
	. venv/bin/activate && \
	pip install ansible-container==0.3.0

push:
	@echo "pushing image to amazon ECR...";\
	ECR_REPO=`basename $$(pwd)`;\
	echo "REPO: $$ECR_REPO";\
	ECR_LOGIN=`aws ecr get-login`;\
	ECR_USER=`echo $$ECR_LOGIN | awk '{print $$4}'`;\
	ECR_PASSWORD=`echo $$ECR_LOGIN | awk '{print $$6}'`;\
	ECR_URL=`echo $$ECR_LOGIN | awk '{print $$9}'`;\
	ansible-container push --username $$ECR_USER --password $$ECR_PASSWORD --push-to $$ECR_URL/sc_tensorflow --tag latest
        
clean:
	rm -rf venv

dockerclean:
	@echo 'Removing all docker images'
	@bash -c '[ "`docker ps -aq | wc -l`" == "0" ] || (docker ps -aq | xargs -n 1 docker rm)'
	@bash -c '[ "`docker images -aq | wc -l`" == "0" ] || (docker images -aq | xargs -n 1 docker rmi -f)'
