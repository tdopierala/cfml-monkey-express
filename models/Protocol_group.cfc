<cfcomponent
	extends="Model">
		
	<cffunction
		name="init">
	
		<cfset table("protocol_groups") />
	
	</cffunction>
	
	<cffunction 
		name="getGroups" >
			
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_protocol_get_groups"
			returnCode="No">
					
			<cfprocresult name="groups" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn groups />
		
	</cffunction>
	
	<cffunction 
		name="getFields" >
			
		<cfargument
			name="groupid"
			type="numeric" 
			default="0"
			required="false" />
		
		<cfargument
			name="where"
			type="string" 
			default="1=1"
			required="false" />
			
		 <cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_protocol_get_group_fields"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.groupid#"
				dbVarName="@group_id" />
				
			<cfprocparam 
				type="in"
				cfsqltype="CF_SQL_VARCHAR"
				value="#arguments.where#"
				dbVarName="@whr" />
					
			<cfprocresult name="fields" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn fields />
		
	</cffunction>
	
	<cffunction
		name="getTypeGroups"
		output="false">
	
		<cfargument
			name="typeid"
			type="numeric"
			default="0"
			required="true" />
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_protocol_get_type_groups"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.typeid#"
				dbVarName="@type_id" />
					
			<cfprocresult name="groups" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn groups />
	
	</cffunction>
		
</cfcomponent>