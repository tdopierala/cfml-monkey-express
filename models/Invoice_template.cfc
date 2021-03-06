<cfcomponent
	extends="Model">
	
	<cffunction
		name="init">
	
		<cfset table("invoice_templates") />
	
	</cffunction>
	
	<cffunction
		name="getUserTemplates"
		hint="Pobieranie listy szablonów użytkownika">
			
		<cfargument
			name="userid"
			type="numeric"
			default="true" />
			
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_invoice_get_user_invoice_templates"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.userid#"
				dbVarName="@user_id" />
					
			<cfprocresult name="templates" resultSet="1" />
			
		</cfstoredproc>
		
		<cfreturn templates />
			
	</cffunction>
	
</cfcomponent>