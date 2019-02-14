<cfcomponent extends="Model">

	<cffunction name="init">
		
		<cfset table("grouprules")>
		<cfset belongsTo("group")>
		<cfset belongsTo("rule")>
	
	</cffunction>

</cfcomponent>