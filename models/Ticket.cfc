<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset belongsTo("user")>
		<cfset belongsTo("ticketStatus")>
		<cfset belongsTo("ticketType")>
	
	</cffunction>

</cfcomponent>