<cfcomponent displayname="upload" hint="Komponent obsługujący operacje na plikach" output="false" >

	<cfproperty name="dir_name" type="string" required="false" default="global_files" />
	<cfproperty name="response" type="struct" required="true" />
	<cfproperty name="max_file_size" type="numeric" required="false" default="5*1024*1024" />


	<!--- INICJALIZACJA --->
	<cfscript>
		variables = {
			dir_name = "global_files",
			max_file_size = 5*1024*1024,
			response = structNew()
		};
	</cfscript>


	<!--- KONSTRUKTOR --->
	<cffunction name="init" output="false" access="public" hint="" returntype="upload">
		<cfargument name="dir_name" required="false" type="string" default="global_files" />
		<cfargument name="max_file_size" required="false" type="numeric" default="768000" />

		<cfscript>
			setDirName(arguments.dir_name);
			setMaxFileSize(arguments.max_file_size);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<!--- SETTERS / GETTERS --->
	<cffunction name="setDirName" output="false" access="public" hint="" returntype="void">
		<cfargument name="dirName" type="string" required="true" />
		<cfset variables.dir_name = arguments.dirName />
	</cffunction>
	
	<cffunction name="setMaxFileSize" output="false" access="public" hint="" returntype="void">
		<cfargument name="size" type="numeric" required="true" />
		<cfset variables.max_file_size = arguments.size />
	</cffunction>
	
	<cffunction name="setResponse" output="false" access="public" hint="" returntype="void">
		<cfargument name="str" type="struct" required="true" />
		<cfset variables.response = arguments.str />
	</cffunction>
	
	<cffunction name="getDirName" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.dir_name />
	</cffunction>
	
	<cffunction name="getMaxFileSize" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.max_file_size />
	</cffunction>
	
	<cffunction name="getResponse" output="false" access="public" hint="" returntype="struct">
		<cfreturn variables.response />
	</cffunction>

	<!--- METODY PRYWATNE --->

	<cffunction
		name="StripPolishChars"
		hint="Usunięcie polskich znaków."
		access="private"
		returntype="String" >

		<cfargument name="text" type="string" default="" required="true" />

		<cfset var to_translate = arguments.text />

		<cfset to_translate = ReplaceNoCase(to_translate, "ó", "o", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "Ó", "O", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "ć", "c", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "Ć", "C", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "ś", "s", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "Ś", "S", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "ę", "e", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "Ę", "E", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "Ą", "A", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "ą", "a", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "ł", "l", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "Ł", "L", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "ż", "z", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "Ż", "Z", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "ź", "z", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "Ź", "Z", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "ń", "n", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "Ń", "N", "all") />

		<cfreturn to_translate />

	</cffunction>

	<cffunction
		name="StripSpecialChars"
		hint="Usunięcie białych spacji i innych znaków, których nie powinno być w nazwie pliku.">

		<cfargument name="text" type="string" default="" required="true" />

		<cfset var to_translate = arguments.text />

		<cfset to_translate = ReplaceNoCase(to_translate, " ", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, ",", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, ";", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "[", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "]", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "+", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "-", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "(", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, ")", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "/", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "\", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "|", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "!", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "@", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "##", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "$", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "%", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "^", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "&", "", "all") />
		<cfset to_translate = ReplaceNoCase(to_translate, "*", "", "all") />

		<cfreturn to_translate />

	</cffunction>

	<!--- METODY PUBLICZNE --->

	<cffunction name="upload" hint="Zapisanie pliku na dysku" access="public" output="false" returntype="struct">
		<cfargument name="file_field" type="string" required="true" />
		<cfset var tmpResponse = structNew() />
		<cfset tmpResponse.error = structNew() />
		<cfset tmpResponse['out'] = structNew() />
		
		<cfset var imageinfo = structNew() />
<!---
		<cfset THIS.response.out = StructNew() />
		<!---
			Zmienna przechowująca komunikat o błędzie
		--->
		<cfset THIS.response.error = StructNew() />
		<cfset THIS.imageinfo = StructNew() />
		<cfset var fileInfo = "" />
--->
		<!---
			Pobranie wielkości przesłanego pliku.
		--->
		<cfif StructKeyExists(FORM, arguments.file_field) AND Len(FORM[arguments.file_field])>
			<cfset fileInfo = GetFileInfo(GetTempDirectory() & GetFileFromPath(FORM[arguments.file_field])) />
		</cfif>

		<!---
			Sprawdzanie wielkości przesyłanego pliku.
		--->
		<cfif IsDefined("fileInfo.size") AND fileInfo.size GT getMaxFileSize()>
			<cfset tmpResponse.error = {
				fileSize = fileInfo.size,
				maxFileSize = getMaxFileSize(),
				error = "Przesłany plik jest za duży. Maksymalna wielkość pliku to " & getMaxFileSize()/1024 & "KB"
			} />
			
			<cfset setResponse(tmpResponse) />
			<cfreturn getResponse() />
		</cfif>

		<!--- Jeżeli przesłano plik do metody to robię upload na serwer --->
		<cfif StructKeyExists(FORM, arguments.file_field) AND Len(FORM[arguments.file_field]) >

			<!--- Upload na serwer --->
			<cffile
				action="upload"
				filefield="#arguments.file_field#"
				destination="#ExpandPath( './files/#getDirName()#' )#"
				nameconflict="makeunique" />
			
			<cfset tmpResponse['file_name'] = CFFILE.SERVERFILE />
			<cfset tmpResponse['file_name'] = StripPolishChars(text=tmpResponse['file_name']) />
			<cfset tmpResponse['file_name'] = StripSpecialChars(text=tmpResponse['file_name']) />
			<cfset tmpResponse['file_name'] = DateFormat(CFFILE.TIMECREATED, "dd-mm-yyyy") & "_" & TimeFormat(CFFILE.TIMECREATED, "HH-mm-ss") & "_" & tmpResponse['file_name'] />

			<!--- Zmiana nazwy --->
			<cffile
				action = "rename"
				destination = "#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#"
				source = "#CFFILE.SERVERDIRECTORY#/#CFFILE.SERVERFILE#"
				mode = "777" >

			<cfparam name="CFFILE.NEWSERVERNAME" default="#tmpResponse['file_name']#" />

			<!--- Sprawdzam, czy plikiem jest grafika. Jak tak to robię miniaturkę --->
			<cfif IsImageFile("#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#")>
				
				<cfset tmpResponse.out['THUMBFILENAME'] = "thumb_#tmpResponse['file_name']#" />

				<cfset myResizedImage = ImageNew("#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#") />
				<cfset ImageResize(myResizedImage, "", 75, "highestperformance") />
				<cfset imageWrite(myResizedImage, "#CFFILE.SERVERDIRECTORY#/#tmpResponse.out['THUMBFILENAME']#") />

				<!---<cffile
					action="copy"
					source="#CFFILE.SERVERDIRECTORY#/#THIS.response['file_name']#"
					destination="#CFFILE.SERVERDIRECTORY#/#THIS.response.out['THUMBFILENAME']#" />--->

				<!---<cfimage
					action="resize"
					height="75"
					source="#CFFILE.SERVERDIRECTORY#/#THIS.response.out['THUMBFILENAME']#"
					width=""
					destination="#CFFILE.SERVERDIRECTORY#/#THIS.response.out['THUMBFILENAME']#"
					overwrite="yes" />--->

				<!---
					17.03.2013
					Skaluje plik do mniejszego rozmiaru. To może być przyczyną,
					dlaczego upload zdjęć jest tak wolny.
				--->
				<cfimage
					action="info"
					source="#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#"
					structname="imageinfo" />

				<!---
					Ustawiam skalowanie grafiki
				--->
				<cfset new_imagesize = 1600 />
				<cfset new_percent_size = 0 />
				<cfif imageinfo.width GTE imageinfo.height>
					<cfset new_percent_size = (new_imagesize / imageinfo.width) />
				<cfelse>
					<cfset new_percent_size = (new_imagesize / imageinfo.height) />
				</cfif>

				<cfset myOriginalImage = ImageNew("#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#") />
				<cfset ImageResize(myOriginalImage, "#round(imageinfo.width * new_percent_size)#", "#round(imageinfo.height * new_percent_size)#", "highestperformance") />
				<cfset imageWrite(myOriginalImage, "#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#", "true") />

				<!---<cfimage
					source="#CFFILE.SERVERDIRECTORY#/#THIS.response['file_name']#"
					action="resize"
					width="#round(THIS.imageinfo.width * new_percent_size)#"
					height="#round(THIS.imageinfo.height * new_percent_size)#"
					destination="#CFFILE.SERVERDIRECTORY#/#THIS.response['file_name']#"
					overwrite="yes" />--->

			<cfelseif LCase(CFFILE.SERVERFILEEXT) is "pdf">

				<cfparam name="tmpResponse.out['THUMBFILENAME']" default="#tmpResponse['file_name']#" />
				<cfset tmpResponse.out['THUMBFILENAME'] = Left(tmpResponse.out['THUMBFILENAME'], Len(tmpResponse.out['THUMBFILENAME'])-4) />

				<cfpdf
    				action = "thumbnail"
    				source = "#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#"
					destination = "#CFFILE.SERVERDIRECTORY#"
    				format = "png"
    				overwrite = "yes"
    				pages = "1"
    				resolution= "low"
    				transparent = "no" />

    			 <cffile
					action = "rename"
					destination = "#CFFILE.SERVERDIRECTORY#/thumb_#tmpResponse.out['THUMBFILENAME']#.png"
    				source = "#CFFILE.SERVERDIRECTORY#/#tmpResponse.out['THUMBFILENAME']#_page_1.png"
    				mode = "777">

				<cfset tmpResponse.out['THUMBFILENAME'] = "thumb_" & tmpResponse.out['THUMBFILENAME'] & ".png" />
				
			<!---<cfelseif LCase(CFFILE.SERVERFILEEXT) is "xls"> <!--- Jeżeli przesyłam plik Excel --->

				<cfparam name="THIS.response.out['THUMBFILENAME']" default="#THIS.response['file_name']#" />
				<cfset THIS.response.out['THUMBFILENAME'] = Left(THIS.response.out['THUMBFILENAME'], Len(THIS.response.out['THUMBFILENAME'])-4) />
				
				<cfparam name="THIS.response.out['PDFFILENAME']" default="#THIS.response['file_name']#" />
				<cfset THIS.response.out['PDFFILENAME'] = Left(THIS.response.out['THUMBFILENAME'], Len(THIS.response.out['THUMBFILENAME'])-1) />
				
				<!--- Pierwszym krokiem jest eksport Excela do PDF --->
				<cfdocument 
					format="pdf" 
					srcfile="#CFFILE.SERVERDIRECTORY#/#THIS.response['file_name']#" 
					filename="#CFFILE.SERVERDIRECTORY#/#THIS.response['file_name']#.pdf"> 
				</cfdocument>--->

			</cfif>

			<cfset tmpResponse.out['SUCCESS'] = true />
	    	<cfset tmpResponse.out['CLIENTFILENAME'] = CFFILE.CLIENTFILENAME />
			<cfset tmpResponse.out['CLIENTFILEEXT'] = CFFILE.CLIENTFILEEXT />
			<cfset tmpResponse.out['FILESIZE'] = CFFILE.FILESIZE />
			<cfset tmpResponse.out['SERVERDIRECTORY'] = CFFILE.SERVERDIRECTORY />
			<!---<cfset THIS.response.out['NEWSERVERNAME'] = CFFILE.NEWSERVERNAME />--->
			<cfset tmpResponse.out['NEWSERVERNAME'] = tmpResponse['file_name'] />
			<cfset tmpResponse.out['TIMECREATED'] = CFFILE.TIMECREATED />
			<cfset tmpResponse.out['BINARYCONTENT'] = FileReadBinary("#CFFILE.SERVERDIRECTORY#/#CFFILE.NEWSERVERNAME#") />

		</cfif>

		<cfset setResponse(tmpResponse.out) />
		<cfreturn getResponse() />
	</cffunction>
	
	<cffunction name="uploadImage" hint="Zapisanie pliku graficznego na dysku" access="public" output="false" returntype="struct">
		<cfargument name="file_field" type="string" required="true" />

		<cfset var tmpResponse = structNew() />
		<cfset tmpResponse.error = structNew() />
		<cfset tmpResponse['out'] = structNew() />
		
		<cfset var imageinfo = structNew() />
		<cfset var fileInfo = "" />

		<!---
			Pobranie wielkości przesłanego pliku.
		--->
		<cfif StructKeyExists(FORM, arguments.file_field) AND Len(FORM[arguments.file_field])>
			<cfset fileInfo = GetFileInfo(GetTempDirectory() & GetFileFromPath(FORM[arguments.file_field])) />
		</cfif>

		<!---
			Sprawdzanie wielkości przesyłanego pliku.
		--->
		<cfif IsDefined("fileInfo.size") AND fileInfo.size GT getMaxFileSize()>
			<cfset var tmpResponse = structNew() />
			<cfset tmpResponse.error = structNew() />
			<cfset tmpResponse.error = {
				fileSize = fileInfo.size,
				maxFileSize = getMaxFileSize(),
				error = "Przesłany plik jest za duży. Maksymalna wielkość pliku to " & getMaxFileSize()/1024 & "KB"
			} />
			
			<cfset setResponse(tmpResponse) />
			<cfreturn getResponse() />
		</cfif>

		<!--- Jeżeli przesłano plik do metody to robię upload na serwer --->
		<cfif StructKeyExists(FORM, arguments.file_field) AND Len(FORM[arguments.file_field]) >

			<!--- Upload na serwer --->
			<cffile
				action="upload"
				filefield="#arguments.file_field#"
				destination="#ExpandPath( './images/#getDirName()#' )#"
				nameconflict="makeunique" />

			<cfset tmpResponse['file_name'] = CFFILE.SERVERFILE />
			<cfset tmpResponse['file_name'] = StripPolishChars(text=tmpResponse['file_name']) />
			<cfset tmpResponse['file_name'] = StripSpecialChars(text=tmpResponse['file_name']) />
			<cfset tmpResponse['file_name'] = DateFormat(CFFILE.TIMECREATED, "dd-mm-yyyy") & "_" & TimeFormat(CFFILE.TIMECREATED, "HH-mm-ss") & "_" & tmpResponse['file_name'] />

			<!--- Zmiana nazwy --->
			<cffile
				action = "rename"
				destination = "#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#"
				source = "#CFFILE.SERVERDIRECTORY#/#CFFILE.SERVERFILE#"
				mode = "777" >

			<cfparam name="CFFILE.NEWSERVERNAME" default="#tmpResponse['file_name']#" />

			<!--- Sprawdzam, czy plikiem jest grafika. Jak tak to robię miniaturkę --->
			<cfif IsImageFile("#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#")>
				
				<cfset tmpResponse.out = structNew() />
				<cfset tmpResponse.out['THUMBFILENAME'] = "thumb_#tmpResponse['file_name']#" />

				<cfset myResizedImage = ImageNew("#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#") />
				<cfset ImageResize(myResizedImage, "", 75, "highestperformance") />
				<cfset imageWrite(myResizedImage, "#CFFILE.SERVERDIRECTORY#/#tmpResponse.out['THUMBFILENAME']#") />

				<!---
					17.03.2013
					Skaluje plik do mniejszego rozmiaru. To może być przyczyną,
					dlaczego upload zdjęć jest tak wolny.
				--->
				<cfimage
					action="info"
					source="#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#"
					structname="imageinfo" />

				<!---
					Ustawiam skalowanie grafiki
				--->
				<cfif imageinfo.width gt 600 or imageinfo.height gt 600>
					
					<cfset new_imagesize = 600 />
					<cfset new_percent_size = 0 />
					<cfif imageinfo.width GTE imageinfo.height>
						<cfset new_percent_size = (new_imagesize / imageinfo.width) />
					<cfelse>
						<cfset new_percent_size = (new_imagesize / imageinfo.height) />
					</cfif>
	
					<cfset myOriginalImage = ImageNew("#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#") />
					<cfset ImageResize(myOriginalImage, "#round(imageinfo.width * new_percent_size)#", "#round(imageinfo.height * new_percent_size)#", "highestperformance") />
					<cfset imageWrite(myOriginalImage, "#CFFILE.SERVERDIRECTORY#/#tmpResponse['file_name']#", "true") />

				</cfif>
				
			</cfif>

			<cfset tmpResponse.out['SUCCESS'] = true />
	    	<cfset tmpResponse.out['CLIENTFILENAME'] = CFFILE.CLIENTFILENAME />
			<cfset tmpResponse.out['CLIENTFILEEXT'] = CFFILE.CLIENTFILEEXT />
			<cfset tmpResponse.out['FILESIZE'] = CFFILE.FILESIZE />
			<cfset tmpResponse.out['SERVERDIRECTORY'] = CFFILE.SERVERDIRECTORY />
			<!---<cfset THIS.response.out['NEWSERVERNAME'] = CFFILE.NEWSERVERNAME />--->
			<cfset tmpResponse.out['NEWSERVERNAME'] = tmpResponse['file_name'] />
			<cfset tmpResponse.out['TIMECREATED'] = CFFILE.TIMECREATED />
			<cfset tmpResponse.out['BINARYCONTENT'] = FileReadBinary("#CFFILE.SERVERDIRECTORY#/#CFFILE.NEWSERVERNAME#") />

		</cfif>

		<cfset setResponse(tmpResponse.out) />
		<cfreturn getResponse() />

	</cffunction>
	
	<cffunction 
		name="cropAndSaveImage"
		access="public"
		output="false"
		returntype="Struct">
		
		<cfargument name="filename" type="string" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
			
		<cfargument name="x1" type="numeric" required="true" />
		<cfargument name="y1" type="numeric" required="true" />
		<cfargument name="x2" type="numeric" required="true" />
		<cfargument name="y2" type="numeric" required="true" />
		<cfargument name="w" type="numeric" required="true" />
		<cfargument name="h" type="numeric" required="true" />
		
		<cfset THIS.response.out = StructNew() />
		<!---
			Zmienna przechowująca komunikat o błędzie
		--->
		<cfset THIS.response.error = StructNew() />
		<cfset THIS.imageinfo = StructNew() />
		<cfset THIS.sourcepath = ExpandPath( './images/users/' ) />
		<cfset THIS.destinationpath = ExpandPath( './images/avatars/' ) />
		
		<cfset var fileInfo = "" />
		
		<cfset fileext = ListLast(arguments.filename,".")>
		<cfset fileInfo = GetFileInfo(THIS.sourcepath & arguments.filename) />
		
		<cfimage
		   name="cfimage"
		   source="#THIS.sourcepath##arguments.filename#"
		   action = "read"/>
		
		<cfset ImageCrop(cfimage, arguments.x1, arguments.y1, arguments.w, arguments.h) />
		
		<!---<cffile
			action = "rename"
			destination = "#CFFILE.SERVERDIRECTORY#/#THIS.response['file_name']#"
			source = "#CFFILE.SERVERDIRECTORY#/#CFFILE.SERVERFILE#"
			mode = "777" >
		
		<cfset myResizedImage = ImageNew("#CFFILE.SERVERDIRECTORY#/#THIS.response['file_name']#") />
		<cfset ImageResize(myResizedImage, "", 75, "highestperformance") />
		<cfset imageWrite(myResizedImage, "#CFFILE.SERVERDIRECTORY#/#THIS.response.out['THUMBFILENAME']#") />--->
		
		<cfimage
		    action="write"
		    destination="#THIS.destinationpath##arguments.userid#.#fileext#"
		    source="#cfimage#"
			overwrite="true">
			
		<cfimage
		   name="cfimage2"
		   source="#THIS.destinationpath##arguments.userid#.#fileext#"
		   action="read"/>
			
		<cfset myResizedImage = ImageNew(cfimage2) />
		<cfset ImageResize(myResizedImage, 150, "", "highestperformance") />
		<cfset ImageWrite(myResizedImage, "#THIS.destinationpath#thumbnail/#arguments.userid#.#fileext#") />
		
		<cfset myResizedImage = ImageNew(cfimage2) />
		<cfset ImageResize(myResizedImage, 50, "", "highestperformance") />
		<cfset ImageWrite(myResizedImage, "#THIS.destinationpath#thumbnailsmall/#arguments.userid#.#fileext#") />
		
		<cfset THIS.response.out['SUCCESS'] = true />
		<cfset THIS.response.out['FILENAME'] = arguments.userid & '.' & fileext />
		
		<cfreturn THIS.response.out />
		
	</cffunction>



</cfcomponent>