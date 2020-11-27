#!/usr/bin/env groovy

def call(String url, String request_result) {
	env.url = url
        print ("connecting to:"+url+" and verify resoponse is:"+request_result)
        for (i = 0; i <5; i++) {
           try{
         	result = sh (script: 'curl --connect-timeout 5 ${url} 2>/dev/null', returnStdout: true).trim()
	        if (result == request_result)
		    i = 1000
		else
		    sleep (5)
	   }catch(Exception ex) {
        	println("not ready yet");
      	   }
	}
	if (i > 999)
		return true
	else
		return false        
}

