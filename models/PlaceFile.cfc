<cfcomponent
	extends="Model">
	
	<cffunction
		name="init">
	
		<cfset belongsTo("placeFileCategory") />
		<cfset belongsTo(name="user",foreignKey="placefileuserid") />
		<cfset belongsTo(name="file",foreignKey="fileid") />
	
	</cffunction>

</cfcomponent>