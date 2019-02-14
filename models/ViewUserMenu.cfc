<cfcomponent extends="Model">

	<cffunction
		name="init">
	
		<cfset table("view_usermenus") />
		<cfset setPrimaryKey("userid,menuid") />
	
	</cffunction>

</cfcomponent>