<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset table('view_chairmanworkflows') />
		<cfset setPrimaryKey(property="workflowid,documentid")>
		
	</cffunction>

</cfcomponent>