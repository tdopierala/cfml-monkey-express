<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("store_shelfs") />
	
	</cffunction>
	
	<cffunction
		name="getShelfs"
		hint="Lista zdefiniowanych regałów."
		description="Metoda pobierająca listę zdefiniowanych regałów.">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_all_shelfs"
			returnCode="No">
				
			<cfprocresult name="shelfs" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn shelfs />
	
	</cffunction>

</cfcomponent>