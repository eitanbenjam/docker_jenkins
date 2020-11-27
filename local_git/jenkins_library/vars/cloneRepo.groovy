#!/usr/bin/env groovy

def call(url, branch, creds) {
        if (creds!=null)
	{
		print "using creds:"+creds
		environment {
    		    USERNAME_PASS     = credentials(creds)
   		 }
        }
        checkout([$class: 'GitSCM', branches: [[name: '*/'+branch]],
    userRemoteConfigs: [[url: url]]])
}

