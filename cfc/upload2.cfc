<cfcomponent displayname="upload2" output="false" hint="">
	
	<cfproperty name="directory" type="string" default="global_files" />
	<cfproperty name="maxSize" type="numeric" default="768000" />
	<cfproperty name="fileInfo" type="struct" />
	<cfproperty name="response" type="struct" />
	
	<!--- PSEUDO-CONSTRUCTOR --->
	<cfscript>
		variables = {
			directory = "global_files",
			maxSize = 768000,
			fileInfo = structNew(),
			response = structNew()
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" hint="" returntype="upload2">
		<cfargument name="directory" type="string" required="false" default="global_files" />
		<cfargument name="maxSize" type="numeric" required="false" default="768000" />
		
		<cfscript>
			setDirectory(arguments.directory);
			setMaxSize(arguments.maxSize);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<!--- SETTERS / GETTERS --->
	<cffunction name="setDirectory" output="false" access="public" hint="" returntype="void">
		<cfargument name="directory" type="string" required="true" />
		<cfset variables.directory = arguments.directory />
	</cffunction>
	
	<cffunction name="setMaxSize" output="false" access="public" hint="" returntype="void">
		<cfargument name="maxSize" type="numeric" required="true" />
		<cfset variables.maxSize = arguments.maxSize />
	</cffunction>
	
	<cffunction name="setResponse" output="false" access="public" hint="" returntype="void">
		<cfargument name="response" type="struct" required="true" />
		<cfset variables.response = arguments.response />
	</cffunction>
	
	<cffunction name="getDirectory" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.directory />
	</cffunction>
	
	<cffunction name="getMaxSize" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.maxSize />
	</cffunction>
	
	<cffunction name="getResponse" output="false" access="public" hint="" returntype="struct">
		<cfreturn variables.response />
	</cffunction>
	
	<!--- FUNCTIONS --->
	<cffunction name="uploadFile" output="false" access="public" hint="" returntype="struct">
		<cfargument name="fileField" type="string" required="true" />
		
		<cfset var res = structNew() />
		<cfset var fileInfo = structNew() />
		
		<cfif StructKeyExists(FORM, arguments.fileField) AND Len(FORM[arguments.fileField])>
			<cfset fileInfo = GetFileInfo(GetTempDirectory() & GetFileFromPath(FORM[arguments.fileField])) />
		</cfif>
		
		<cfif IsDefined("fileInfo.size") AND fileInfo.size GT getMaxSize()>
			<cfset var tmpMaxSize = getMaxSize() />
			<cfset res.error = {
				fileSize = fileInfo.size,
				maxSize = tmpMaxSize,
				error = "Przesłany plik jest za duży. Maksymalna wielkość pliku to " & getMaxSize()/1024 & "KB"
			} />
			
			<cfset setResponse(res) />
			<cfreturn getResponse() />
		</cfif>
		
		<cfif StructKeyExists(FORM, arguments.fileField) AND Len(FORM[arguments.fileField]) >

			<cffile action="upload" filefield="#arguments.fileField#" destination="#ExpandPath( './files/#getDirectory()#' )#" nameconflict="makeunique" />
			
			<cfset res['file_name'] = randomText(11) & "." & CFFILE.CLIENTFILEEXT />
			<!---<cfset res['file_name'] = CFFILE.SERVERFILE />--->
			<!---<cfset res['file_name'] = StripPolishChars(text=res['file_name']) />--->
			<!---<cfset res['file_name'] = StripSpecialChars(text=res['file_name']) />--->
			<cfset res['file_name'] = DateFormat(CFFILE.TIMECREATED, "dd-mm-yyyy") & "_" & TimeFormat(CFFILE.TIMECREATED, "HH-mm-ss") & "_" & res['file_name'] />

			<cffile action = "rename" destination = "#CFFILE.SERVERDIRECTORY#/#res['file_name']#" 
					source = "#CFFILE.SERVERDIRECTORY#/#CFFILE.SERVERFILE#" mode = "777" />

			<!---<cfparam name="CFFILE.NEWSERVERNAME" default="#res['file_name']#" />--->

			<cfif IsImageFile("#CFFILE.SERVERDIRECTORY#/#res['file_name']#")> <!--- GRAFIKA --->
				
				<cfset res["out"] = structNew() />
				<cfset res.out["THUMBFILENAME"] = "thumb_#res['file_name']#" />

				<cfset myResizedImage = ImageNew("#CFFILE.SERVERDIRECTORY#/#res['file_name']#") />
				<cfset ImageResize(myResizedImage, "", 75, "highestperformance") />
				<cfset imageWrite(myResizedImage, "#CFFILE.SERVERDIRECTORY#/#res.out['THUMBFILENAME']#") />

				<cfset var imageInfo = structNew() />
				<cfimage action="info" source="#CFFILE.SERVERDIRECTORY#/#res['file_name']#" 
						 structname="imageInfo" />

				<cfset var newImageSize = 1600 />
				<cfset var newPercentSize = 0 />
				<cfif imageInfo.width GTE imageInfo.height>
					<cfset newPercentSize = (newImageSize / imageInfo.width) />
				<cfelse>
					<cfset newPercentSize = (newImageSize / imageInfo.height) />
				</cfif>

				<cfset myOriginalImage = ImageNew("#CFFILE.SERVERDIRECTORY#/#res['file_name']#") />
				<cfset ImageResize(myOriginalImage, "#round(imageInfo.width * newPercentSize)#", "#round(imageInfo.height * newPercentSize)#", "highestperformance") />
				<cfset imageWrite(myOriginalImage, "#CFFILE.SERVERDIRECTORY#/#res['file_name']#", "true") />


			<cfelseif LCase(CFFILE.SERVERFILEEXT) is "pdf"> <!--- PDF --->
				
				<cfset res["out"] = structNew() />
				<cfset res.out["THUMBFILENAME"] = res['file_name'] />
				<cfset res.out["THUMBFILENAME"] = Left(res.out["THUMBFILENAME"], Len(res.out["THUMBFILENAME"])-4) />

				<cfpdf action = "thumbnail" source = "#CFFILE.SERVERDIRECTORY#/#res['file_name']#"
					   destination = "#CFFILE.SERVERDIRECTORY#" format = "png" overwrite = "yes"
					   pages = "1" resolution= "low" transparent = "no" />

    			<cffile action = "rename" destination = "#CFFILE.SERVERDIRECTORY#/thumb_#res.out['THUMBFILENAME']#.png"
						source = "#CFFILE.SERVERDIRECTORY#/#res.out['THUMBFILENAME']#_page_1.png" mode = "777" />

				<cfset res.out['THUMBFILENAME'] = "thumb_" & res.out['THUMBFILENAME'] & ".png" />
			
			<cfelseif LCase(CFFILE.SERVERFILEEXT) is "xls" OR LCase(CFFILE.SERVERFILEEXT) is "xlsx">
				
			</cfif>

			<cfset res.out['SUCCESS'] = true />
			<cfset res.out['CLIENTFILENAME'] = CFFILE.CLIENTFILENAME />
			<cfset res.out['CLIENTFILEEXT'] = CFFILE.CLIENTFILEEXT />
			<cfset res.out['FILESIZE'] = CFFILE.FILESIZE />
			<cfset res.out['SERVERDIRECTORY'] = CFFILE.SERVERDIRECTORY />
			<!---<cfset THIS.response.out['NEWSERVERNAME'] = CFFILE.NEWSERVERNAME />--->
			<cfset res.out['NEWSERVERNAME'] = res['file_name'] />
			<cfset res.out['TIMECREATED'] = CFFILE.TIMECREATED />
			<cfset res.out['BINARYCONTENT'] = FileReadBinary("#CFFILE.SERVERDIRECTORY#/#res['file_name']#") />

		</cfif>
		
		<cfset setResponse(res.out) />
		<cfreturn getResponse() />
		
	</cffunction>
	
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

		<cfreturn to_translate />

	</cffunction>
	
	<cffunction name="randomText" output="false" access="private" hint="" returntype="string">
		<cfargument name="size" type="numeric" required="false" default="11" />
		
		<cfset var charSet = "QWERTYUIOPASDFGHJKLZXCVBNM" />
		<cfset var str = "" />
		<cfset var tempstr = ""/>

		<cfloop from="1" to="#arguments.size#" index="i">
			<cfset tempstr = Mid(charSet, RandRange(1,
Len(charSet)), 1) />

			<cfset str = str & tempstr />
		</cfloop>

		<cfreturn str>
		
	</cffunction>
	
</cfcomponent>