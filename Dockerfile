FROM jenkins/jenkins:lts

RUN jenkins-plugin-cli --plugins git workflow-aggregator workflow-api workflow-basic-steps workflow-cps workflow-cps-global-lib workflow-durable-task-step workflow-job workflow-scm-step workflow-step-api workflow-support pipeline-stage-view jquery-detached momentjs handlebars pipeline-rest-api docker-workflow
USER root
#CMD apt install docker.io -y
COPY xml_conf/config.xml /usr/share/jenkins/ref/config.xml.override
