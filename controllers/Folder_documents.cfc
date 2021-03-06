<cfcomponent displayname="Folder_documents" access="public" output="false" extends="Controller">

	<cffunction name="init" access="public" output="false" hint="">
		<cfset super.init() />
	</cffunction>
	
	<cffunction name="remove" access="public" output="false" hint="">
		
		<cfset json = {
			STATUS = "ERROR",
			MESSAGE = "Nie usunięto"} />
		
		<cfif IsDefined("params.key")>
			<cfset toDelete = model("folder_document").delete(params.key) /> 
			
			<cfset json = {
				STATUS = "OK",
				MESSAGE = "Usunięto"} />
			
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>

</cfcomponent>