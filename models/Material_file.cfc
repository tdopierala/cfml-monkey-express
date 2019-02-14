<cfcomponent
	extends="Model"
	output="false">
		
	<cffunction name="init">
		<cfset table("material_files") />
	</cffunction>
	
	<cffunction name="deleteFile" output="false" access="public" hint="">
		<cfargument name="fileid" type="numeric" required="true" />
		
		<cfset var df = "" />
		<cfquery name="df" datasource="#get('loc').datasource.intranet#">
			delete from material_files where id = <cfqueryparam value="#arguments.fileid#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn true />
	</cffunction>
		
</cfcomponent>