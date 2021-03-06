<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("place_formprivileges") />
	
	</cffunction>
	
	<cffunction
		name="getUsersPrivileges"
		hint="Pobranie listy uprawnień użytkowników do formularzy">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_get_users_from_form_privileges"
			returnCode="No">
					
			<cfprocresult name="users" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn users />
	
	</cffunction>
	
	<cffunction
		name="getUserForms"
		hint="Pobranie listy formularzy do których ma dostęp użytkownik">
			
		<cfargument name="userid" type="numeric" default="0" required="true" />
		<cfargument name="structure" type="boolean" default="false" reuired="false" />
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_get_user_forms_from_privileges"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.userid#"
				dbVarName="@user_id" />
				
			<cfprocresult name="forms" resultSet="1" />
		
		</cfstoredproc>
		
		<cfif arguments.structure>
			<cfreturn QueryToStruct(Query=forms) />
		</cfif>
		
		<cfreturn forms />
		
	</cffunction>
		
</cfcomponent>