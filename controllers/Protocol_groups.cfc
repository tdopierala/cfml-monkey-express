<cfcomponent
	extends="no_login_check">

	<cffunction
		name="init">
	
		<cfset super.init() />
	
	</cffunction>
	
	<cffunction
		name="getFields"
		output="false" >

		<cfset myfields = model("protocol_group").getFields(groupid=params.key) />

	</cffunction>
		
</cfcomponent>