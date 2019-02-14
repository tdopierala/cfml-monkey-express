<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset belongsTo("document")>
		<cfset hasMany("documentAttributeValue")>
	
	</cffunction>

</cfcomponent>