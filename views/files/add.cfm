<cfoutput>

	<div id="file-uploader-demo1">		
		<noscript>			
			<p>Please enable JavaScript to use file uploader.</p>
			<!-- or put a simple form for upload here -->
		</noscript>         
	</div>
    
    <script src="<cfoutput>http://#cgi.server_name#/#get('loc').intranet.directory#/javascripts/fileuploader.js</cfoutput>" type="text/javascript"></script>
    <script>        
        function createUploader(){            
            var uploader = new qq.FileUploader({
                element: document.getElementById('file-uploader-demo1'),
                action: "<cfoutput>#URLFor(controller='Uploader',action='upload',params='&format=json')#</cfoutput>"
            });           
        }
        
        // in your app create uploader as soon as the DOM is ready
        // don't wait for the window to load  
        window.onload = createUploader;     
    </script> 

</cfoutput>