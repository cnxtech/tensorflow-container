
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
