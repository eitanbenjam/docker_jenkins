# docker_jenkins
# repository goal
perform CI (compile,build test and deploy) on https://github.com/eitanbenjam/tikal_eitan_exam.git repository.

This code will start docker-registry and build jenkins as docker container.
The containerized jenkins will have a multi-branch job that will perform ci to GitHab repository:https://github.com/eitanbenjam/tikal_eitan_exam.git


## Installation

in order to run the docker_jenkins server u need to perform the following steps:
1. clone repository :
```
git clone https://github.com/eitanbenjam/docker_jenkins.git
```
2. after repository cloned to your filesystem, we need to start docker-registry container
```
cd docker_jenkins
. start_docker_register.sh
```
this script will start docker-registry container on port 5000
to check that the registry is up run:
```
docker ps |grep docker-registry
```
the output should be:
```
d1b2dc610241        registry:2          "/entrypoint.sh /etc…"   About a minute ago   Up About a minute   0.0.0.0:5000->5000/tcp              docker-registry
```


3. after docker-registry container started we need to build the jenkins docker image on out docker
```
   . build_docker.sh
```
this script will create a docker images named:jenkins:eitan
check that docker image was created by running the command:
```
    docker images|grep jenkins.*eitan
```
   output should be:
```
   jenkins                        eitan               255d0f9befc4        29 seconds ago      760MB
```
4. after docker image was build we can run it with the following command:
```
    jenkins_listen_port=9997  # the port number you want jenkins container to listen on
    . start_docker.sh
```
this script will bring up the jenkins image that was created in the previous step called jenkins-eitan.
check that jenkins container was created by running the command:
```
docker ps|grep jenkins-eitan
```
the output should be:
```
904416954f88        jenkins:eitan       "/sbin/tini -- /usr/…"   14 minutes ago      Up 14 minutes       50000/tcp, 0.0.0.0:9997->8080/tcp   jenkins-eitan
```
* see container parameters section.
5. open browser and browse to http://localhost:<jenkins_listen_port>

jenkins will come up with the following configuration:
1. Global Pipeline Libraries - shared libraries that all jobs can use (located in local_git/jenkins_library/ on this repository)
2. job called:multi_branch_nodejs_eitan - that job monitor https://github.com/eitanbenjam/tikal_eitan_exam.git repositry and run on every change
   the job clone the https://github.com/eitanbenjam/tikal_eitan_exam.git repository, build a docker image, run it, test it and if all passed it will push it into docker-registry that was created on step 2.

# container parameters section
jenkins container comes up with the following mounts:
1. ${local_folder}/local_git:/var/jenkins_home/local_git - mount the Global Pipeline Libraries src libraries
2. ${local_folder}/xml_conf/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml - mount the Global Pipeline Libraries configuration
3. ${local_folder}/xml_conf/jobs/multi_branch_nodejs_eitan/config.xml - mount the multi_branch_nodejs_eitan job
4. /var/run/docker.sock - mount the local docker socket (all docker command that jenkins run will be executed on host docker)
5. ${local_folder}/xml_conf/org.jenkinsci.plugins.docker.commons.tools.DockerTool.xml : define docker binary (jenkins will download from internet on first time)
6. ${local_folder}/xml_conf/scriptApproval.xml - disable docker security so jenkins container can run docker command on host.

# GitHub integration
because that solution should run on on private networks, github cant trigger a job by itself , in order to perform CI , jenkins scan every 1 minute github repository to check if something changed , in case a change was done , jenkins it-self trigger the job.
