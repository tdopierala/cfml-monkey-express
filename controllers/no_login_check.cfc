<cfcomponent 
	extends="Controller">

	<cffunction
		name="init">
	
		<cfset provides("html,xml,json,pdf") />
		<cfset filters("beforeRender") />
		
	</cffunction>
	
	<cffunction 
		name="beforeRender">
	
		<cfset usesLayout(template="/layout",ajax=false) />
	
	</cffunction>

</cfcomponent>