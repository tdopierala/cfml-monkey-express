<cfcomponent
	extends="Model">

	<cffunction
		name="init">
			
		<cfset table("place_phototypeprivileges") />
	
	</cffunction>
	
	<cffunction
		name="getUsersPrivileges"
		hint="Pobranie listy uprawnień użytkowników do zdjęć">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_get_users_from_photo_type_privileges"
			returnCode="No">
					
			<cfprocresult name="users" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn users />
	
	</cffunction>
	
	<cffunction
		name="getUserPhotoTypes"
		hint="Pobranie listy zdjęć do których ma dostęp użytkownik">
			
		<cfargument name="userid" type="numeric" default="0" required="true" />
		<cfargument name="structure" type="boolean" default="false" required="false" />
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_get_user_photo_type_privileges"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.userid#"
				dbVarName="@user_id" />
				
			<cfprocresult name="phototypes" resultSet="1" />
		
		</cfstoredproc>
		
		<cfif arguments.structure>
			<cfreturn QueryToStruct(Query=phototypes) />
		</cfif>
		
		<cfreturn phototypes />
			
	</cffunction>
		
</cfcomponent>