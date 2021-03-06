<!---
AJAX FileUploader for ColdFusion
version: 1.1.1
feedback:  sid.maestre@designovermatter.com

-----------update history----------------
1.1.1 on 9/30/2010 by Martin Webb <martin[at]cubicstate.com>
- Change function for Upload to returnformat equals JSON
- local var scoping.
1.1 on 9/9/2010 by Sid Maestre
- Split Upload function to handle fallback uploads for browsers that don't support XHR data transfer
--->
<cfcomponent hint="I handle AJAX File Uploads from Valum's AJAX file uploader library" extends="Controller">

	<cffunction
		name="init">
		
		<cfset provides("html,json,xml") />
		<cfset super.init() />
		
	</cffunction>
	
    <cffunction name="upload" access="remote" output="false" returntype="any" returnformat="JSON">
<!--- 		<cfargument name="qqfile" type="string" required="true"> --->

		<cfset var local = structNew()>
		<cfset local.response = structNew()>
		<cfset local.requestData = GetHttpRequestData() />
		
		<!--- check if XHR data exists --->
        <cfif len(local.requestData.content) GT 0>
			<cfset local.response = UploadFileXhr(params.qqfile, local.requestData) />       
		<cfelse>
		<!--- no XHR data process as standard form submission --->
			<cffile action="upload" fileField="params.qqfile" destination="#ExpandPath('files/uploaded/')#" nameConflict="makeunique">
    		<cfset local.response['success'] = true>
    		<cfset local.response['type'] = 'form'>
		</cfif>
		
<!--- 		<cfreturn local.response> --->
		<cfset renderWith(local.response) />
	</cffunction>
    
    
    <cffunction name="UploadFileXhr" access="private" output="false" returntype="struct">
		<cfargument name="qqfile" type="string" required="true">
		<cfargument name="content" type="any" required="true">
			
		<cfset var local = structNew()>
		<cfset local.response = structNew()>

        <!--- write the contents of the http request to a file.  
		The filename is passed with the qqfile variable --->
		
		<!--- 
		Zanim plik będzie zapisany muszę:
		- usunąć spację i polskie znaki z nazwy
		- sprawdzić czy plik już istnieje. Jeśli istnieje to dodaje timestamp na początku nazwy 
		--->
		
		<!--- Zapisuje oryginalną nazwę pliku --->
		<cfset loc.fileoriginalname = arguments.qqfile />
		
		<!--- Dodaje stempel czasu --->
		<cfset loc.outputname = DateFormat(Now(), "dd-mm-yyyy") & "_" & TimeFormat(Now(), "HH-mm-ss-l") & "__" & arguments.qqfile />
		
		<!--- Usuwam polskie znaki i spacje --->
		<cfset loc.outputname = stripWhiteChars(text=loc.outputname) />
		<cfset loc.outputname = stripPolishChars(text=loc.outputname) />
				
		<!--- Sprawdzam czy plik istnieje na dysku --->
		<cfif FileExists(ExpandPath('files/uploaded/#loc.outputname#'))>
			<cfset loc.outputname = GetTickCount() & "__" & loc.outputname />
		</cfif>
		
		<cffile action="write" file="#ExpandPath('files/uploaded')#/#loc.outputname#" output="#arguments.content.content#">
		
		<!---
		06.08.2012
		Dodaje sprawdzenie, czy przesłanym plikiem jest grafika. Jeśli tak to skaluje ją i zapisuje miniaturke.
		--->
		<cfif isImageFile(ExpandPath('files/uploaded/#loc.outputname#'))>
		
			<cffile action="copy" source="#ExpandPath('files/uploaded/#loc.outputname#')#" destination="#ExpandPath('files/uploaded/thumb/#loc.outputname#')#" />
			<cfset myImage = ImageNew("#ExpandPath('files/uploaded/thumb/#loc.outputname#')#")> 
			<cfset ImageResize(myImage, "500", "300", "highPerformance", 1)>
			<cfimage source="#myImage#" action="write" destination="#ExpandPath('files/uploaded/thumb/#loc.outputname#')#" overwrite="yes"> 
			<!--- <cfimage action="resize" source="#ExpandPath('files/uploaded/thumb_#loc.outputname#')#" width="300" height="200" destination="#ExpandPath('files/uploaded/thumb_#loc.outputname#')#" overwrite="true" /> --->

		</cfif>
		
		<!--- Po zapisaniu pliku na dysku zapisuje go w bazie --->
		<cfset myfile = model('file').New() />
		<cfset myfile.filename = loc.outputname />
		<cfset myfile.filesrc = "#ExpandPath('files/uploaded')#/#loc.outputname#" />
		<cfset myfile.filebinary = arguments.content.content />
		<cfset myfile.filesize = arguments.content.headers["Content-Length"] />
		<cfset myfile.filecontenttype = arguments.content.headers["Content-Type"] />
		<cfset myfile.filecreated = Now() />
		<cfset myfile.userid = session.userid />
		<cfset myfile.fileoriginalname = loc.fileoriginalname />
		<cfset myfile.save(callbacks=false) />

		<!--- if you want to return some JSON you can do it here.  
		I'm just passing a success message	--->
    	<cfset local.response['success'] = true />
    	<cfset local.response['type'] = 'xhr' />
    	<!--- Dodaję dodatkowe informacje, które zwraca skrypt po zapisaniu pliku --->
    	<cfset local.response['fileid'] = myfile.id />
    	<cfset local.response['filename'] = myfile.filename />
    	<cfset local.response['filesrc'] = myfile.filesrc />
    	<cfset local.response['fileoriginalname'] = myfile.fileoriginalname />
		
		<cfreturn local.response>
    </cffunction>
    
</cfcomponent>