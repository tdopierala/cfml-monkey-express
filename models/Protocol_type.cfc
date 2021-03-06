<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("protocol_types") />
	
	</cffunction>
	
	<cffunction
		name="getTypes"
		output="false">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_protocol_get_types"
			returnCode="No">
					
			<cfprocresult name="types" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn types />
	
	</cffunction>
		
</cfcomponent>