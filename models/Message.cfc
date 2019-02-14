<cfcomponent extends="Model">

	<cffunction name="init">

		<cfset hasMany("messageGroup") />
		<cfset hasMany("userMessage") />
		<cfset belongsTo("user") />
		<cfset belongsTo(name="messagePriority",foreignKey="messagepriorityid") />

	</cffunction>

</cfcomponent>