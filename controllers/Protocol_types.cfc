<cfcomponent
	extends="no_login_check">

	<cffunction
		name="init"
		output="false">
	
		<cfset super.init() />
	
	</cffunction>
	
	<cffunction 
		name="index"
		output="false" >
		
		<cfset mytypes = model("protocol_type").getTypes() />
		
	</cffunction>
	
	<cffunction
		name="add"
		output="false" >
			
		<cfset mytype = model("protocol_type").create(params) />
		<cfset redirectTo(back="true") />
			
	</cffunction>
	
	<cffunction
		name="getGroups"
		output="false">
	
		<cfset mygroups = model("protocol_group").getTypeGroups(typeid=params.key) />
	
	</cffunction>
	
	<cffunction
		name="updateAccess"
		output="false" >
			
		<cfset mytypegroup = model("protocol_typegroup").findByKey(params.id) />
		<cfset mytypegroup.update(
			access=1-mytypegroup.access,
			callbacks=false) />
			
	</cffunction>
		
</cfcomponent>