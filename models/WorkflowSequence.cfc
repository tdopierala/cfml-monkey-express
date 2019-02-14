<!---
Komponent zawierający wszystkie operacje na zdefiniowanych obiegach dokumentów.
Można dodawać nowe sekwencje do obiegu, ustalać kolejność sekwencji, itp.
--->
<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset belongsTo("workflow")>
		<cfset belongsTo("status")>
		<cfset belongsTo("sequence")>
		
	</cffunction>

</cfcomponent>