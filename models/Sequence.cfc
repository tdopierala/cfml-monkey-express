<!---
Komponent, który zawiera listę sekwencji do wykonania przy danym obiegu dokumentów.
--->
<cfcomponent extends="Model">

	<cffunction name="init">

		<cfset hasMany("workflowSequence")>
		<cfset belongsTo("user")>

	</cffunction>

</cfcomponent>