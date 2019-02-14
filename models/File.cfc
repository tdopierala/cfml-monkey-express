<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	</cffunction>

	<cffunction
		name="getComments"
		hint="Pobranie komentarzy do pliku"
		description="Procedura odwołująca się do procedury na bazie danych i pobierająca komentarze do pliku">
	
		<cfargument name="fileid" default="0" type="numeric" />
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_file_comments"
			returnCode="No">
		
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.fileid#"
				dbVarName="@fileId" />
				
			<cfprocresult name="comments" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn comments />
	
	</cffunction>

</cfcomponent>