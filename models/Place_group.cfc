<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("place_groups") />
	
	</cffunction>
	
	<cffunction
		name="getAllGroups"
		hint="Pobranie listy grup">
			
		<cfargument
			name="columns"
			type="string"
			default=""
			required="false" /> 
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_report_get_all_groups"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR" 
				value="#arguments.columns#"
				dbVarName="@columns" />
				
			<cfprocresult name="groups" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn groups />
	
	</cffunction>
	
	<cffunction
		name="getGroupFields"
		hint="Pobranie pól grupy">
	
		<cfargument
			name="groupid"
			type="numeric"
			default="0"
			required="true" />
			
		 <cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_report_get_group_fields"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.groupid#"
				dbVarName="@groupid_id" />
				
			<cfprocresult name="fields" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn fields />
	
	</cffunction>
		
</cfcomponent>