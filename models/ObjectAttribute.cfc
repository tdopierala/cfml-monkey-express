<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset belongsTo("object")>
		<cfset belongsTo("attribute")>
		<cfset hasMany("objectInstanceAttributeValue")>
	
	</cffunction>

</cfcomponent>