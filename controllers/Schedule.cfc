<cfcomponent 
	extends="Controller">
		
	<cffunction 
		name="init">
			
		<cfset super.init() />
		<cfset filters(through="authentication") />
		
	</cffunction>
	
	<cffunction 
		name="authentication">
			
		<cfinvoke 
			component="controllers.Tree_groupusers" 
			method="checkUserTreeGroup" 
			returnvariable="priv">
				
			<cfinvokeargument 
				name="groupname" 
				value="Harmonogram sklepów" />
		</cfinvoke>
		
		<cfif priv is false>
			<cfset renderPage(template="/autherror") />
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="index">
			
		
		
	</cffunction>
	
</cfcomponent>