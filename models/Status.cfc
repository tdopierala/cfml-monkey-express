<!---
Komponent zawierające statusy, które są przypisane do odpowiedniego kroku w obiegu dokumentów.
--->
<cfcomponent extends="Model">

	<cffunction name="init">
		
		<cfset hasMany("workflowSequence")>
	
	</cffunction>

</cfcomponent>