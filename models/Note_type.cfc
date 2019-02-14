<cfcomponent extends="Model" displayname="Note_type">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("note_types") />
	</cffunction>	
	
	<cffunction name="getTypes" output="false" access="public" hint="">
		
		<cfset var qTypes = "" />
		<cfquery name="qTypes" datasource="#get('loc').datasource.intranet#">
			select id, type_name as typename from note_types 
		</cfquery>
		
		<cfreturn qTypes />
		
	</cffunction>
	
</cfcomponent>