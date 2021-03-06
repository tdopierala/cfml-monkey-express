<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("place_collectionprivileges") />
	
	</cffunction>
	
	<cffunction
		name="getUsersPrivileges"
		hint="Metoda pobierająca z bazy listę użytkowników do uprawnień do zbiorów">
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_get_users_from_collection_privileges"
			returnCode="No">
					
			<cfprocresult name="users" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn users />
	
	</cffunction>
	
	<cffunction
		name="getUserCollections"
		hint="Pobranie listy zbiorów do których ma dostęp użytkownik">
			
		<cfargument name="userid" type="numeric" default="0" required="true" />
		<cfargument name="structure" type="boolean" default="false" required="false" />
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_get_user_collections_from_privileges"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.userid#"
				dbVarName="@user_id" />
				
			<cfprocresult name="collections" resultSet="1" />
		
		</cfstoredproc>
		
		<cfif arguments.structure>
			<cfreturn QueryToStruct(Query=collections) />
		</cfif>
		
		<cfreturn collections />
			
	</cffunction>
	
	
		
</cfcomponent>