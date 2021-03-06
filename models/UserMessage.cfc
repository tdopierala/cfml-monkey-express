<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset belongsTo("message") />
		<cfset belongsTo("user") />
		
	</cffunction>
	
	<cffunction
		name="getMessages"
		hiny="Pobranie listy wiadomości na stronę profilową użytkownika">
	
		<cfargument name="userid" type="numeric" default="0" required="true" />
		<cfargument name="page" type="numeric" default="1" required="false" />
		<cfargument name="num" type="numeric" default="12" required="false" />
	
		<cfstoredproc 
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_message_get_user_unread_messages"
			returnCode = "no">
		
			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.userid#"
				dbVarName = "@user_id" />
			
			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.page#"
				dbVarName = "@pge" />
			
			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.num#"
				dbVarName = "@cnt" />
			
			<cfprocresult name="messages" resultSet="1" />
		
		</cfstoredproc>
	
		<cfreturn messages />
	
	</cffunction>	
	
</cfcomponent>