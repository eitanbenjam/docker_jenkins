local_folder=$(pwd)
if [ -z ${jenkins_listen_port} ];then
	jenkins_listen_port=9997
fi
if [ ! -d local_git/jenkins_library/.git ];
then
	git init local_git/jenkins_library
fi
docker run -d -p ${jenkins_listen_port}:8080 -v ${local_folder}/local_git:/var/jenkins_home/local_git  -v ${local_folder}/xml_conf/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml:/var/jenkins_home/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml -v ${local_folder}/xml_conf/jobs/multi_branch_nodejs_eitan/xml_conf/config.xml:/var/jenkins_home/jobs/multi_branch_nodejs_eitan/config.xml -v /var/run/docker.sock:/var/run/docker.sock  -v ${local_folder}/xml_conf/org.jenkinsci.plugins.docker.commons.tools.DockerTool.xml:/var/jenkins_home/org.jenkinsci.plugins.docker.commons.tools.DockerTool.xml -v ${local_folder}/xml_conf/scriptApproval.xml:/var/jenkins_home/scriptApproval.xml --name jenkins-eitan  jenkins:eitan
