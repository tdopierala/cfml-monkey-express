<cfcomponent
	extends="Model">
		
	<cffunction
		name="init">
			
		<cfset table("store_attributetypes") />
		
	</cffunction>
	
	<cffunction
		name="getTypes"
		hint="Pobranie typów atrybutów opisujących obiekty w sklepie">
	
		<cfstoredproc 
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_store_get_all_attribute_types"
			returnCode = "no">
			
			<cfprocresult name="types" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn types />
	
	</cffunction>
		
		
</cfcomponent>