<cfcomponent output="false" displayname="User_photos" extends="Controller">
	
	<cffunction name="init" access="public" output="false" hint="">
		<cfset super.init() />
		
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="index" access="public" output="false" hint="">
		
	</cffunction>
	
	<cffunction name="crop" access="public" output="false" hint="">
		
		<cfdump var="#FORM#" />
		<cfdump var="#FILE#" />
		<cfdump var="#params#" />
		
		<cfabort />
		
	</cffunction>
	
	<cffunction name="iframe" access="public" output="false" hint="">
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="add" access="public" output="false" hint="">
	</cffunction>
	
	<cffunction name="uploadFile" access="public" output="false" hint="">
		<cfset my_file = APPLICATION.cfc.upload.SetDirName(dirName="jcrop") />
		<cfset my_file = APPLICATION.cfc.upload.upload(file_field="file") />
		
		<cfset json = {} />
		<cfif isStruct(my_file) AND StructKeyExists(my_file, "SUCCESS")> <!--- Plik został zapisany na serwerze --->
			<cfset json.STATUS = 200 /> 
			<cfset json.MESSAGE = my_file.NEWSERVERNAME />
			<cfset json.FILENAME = my_file.NEWSERVERNAME />
			
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) /> 
	</cffunction>
	
	
</cfcomponent>