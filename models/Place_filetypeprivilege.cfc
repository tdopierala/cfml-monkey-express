<cfcomponent
	extends="Model">

	<cffunction
		name="init">

		<cfset table("place_filetypeprivileges") />

	</cffunction>

	<cffunction
		name="getUsersPrivileges"
		hint="Lista użytkownikóe do uprawnień">

		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_get_users_from_file_type_privileges"
			returnCode="No">

			<cfprocresult name="users" resultSet="1" />

		</cfstoredproc>

		<cfreturn users />

	</cffunction>


	<cffunction
		name="getUserFileTypes"
		hint="Pobranie listy plików z uprawnieniami dla użytkownika">

		<cfargument
			name="userid"
			type="numeric"
			default="0"
			required="true" />

		<cfargument
			name="structure"
			type="boolean"
			default="false"
			required="false" />

		<cfquery
			name="qFileTypePriv"
			result="rFileTypePriv"
			datasource="#get('loc').datasource.intranet#">

			select
				ftp.id as id
				,ftp.readprivilege as readprivilege
				,ftp.writeprivilege as writeprivilege
				,ftp.deleteprivilege as deleteprivilege
				,ftp.filetypeid as filetypeid
				,ft.filetypename as filetypename
			from place_filetypeprivileges ftp inner join place_filetypes ft on ftp.filetypeid = ft.id
			where ftp.userid = <cfqueryparam
									value="#arguments.userid#"
									cfsqltype="cf_sql_integer" />

		</cfquery>

		<cfif arguments.structure>
			<cfreturn QueryToStruct(Query=qFileTypePriv) />
		</cfif>

		<cfreturn qFileTypePriv />

	</cffunction>

</cfcomponent>