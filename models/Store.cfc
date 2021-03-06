<cfcomponent 
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("store_stores") />
	
	</cffunction>
	
	<!---
	TODO
	Dorobić paginację do listy sklepów
	--->
	<cffunction
		name="getStores"
		hint="Pobranie listy sklepów"
		description="Pobranie listy sklepów. Procedura na bazie zwraca listę wyników.">
		
		<cfstoredproc 
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_get_stores_list"
			returnCode = "no">
			
			<cfprocresult name="stores" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn stores />
		
	</cffunction>
	
	<cffunction 
		name="getUserByNip"
		hint="Pobranie użytkownika za pomocą nip'u ajenta">
		
		<cfargument name="nip" type="string" required="false" />
		
		<cfquery name="qUser" datasource="#get('loc').datasource.intranet#">
			select *
			from store_stores ss

			inner join users u 
				on u.login = ss.projekt

			where ss.nip = <cfqueryparam value="#arguments.nip#" cfsqltype="cf_sql_varchar" /> 
			
		</cfquery>
		
		<cfreturn qUser />	
		
	</cffunction>

</cfcomponent>