<cfcomponent extends="Model">

	<cffunction
		name="init">
		
		<cfset table('view_protocolcontents') />
		<cfset setPrimaryKey(property="lp,protocoled,protocoltypeid")>
	
	</cffunction>

</cfcomponent>