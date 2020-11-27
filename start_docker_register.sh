registry_name="docker-registry"
if (docker ps |grep ${registry_name});then
	echo register already running
else
	docker run -d -p 5000:5000 --name ${registry_name} --restart=always registry:2
fi
