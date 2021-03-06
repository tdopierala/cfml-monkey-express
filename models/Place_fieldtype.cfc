<cfcomponent 
	extends="Model">

	<cffunction 
		name="init">
	
		<cfset table("place_fieldtypes") />
	
	</cffunction>
	
	<cffunction
		name="getTypes"
		description="Pobieranie wszystkich możliwych typów pól formularza">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_all_field_types"
			returnCode="No">
				
			<cfprocresult name="types" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn types />
	
	</cffunction>

</cfcomponent>