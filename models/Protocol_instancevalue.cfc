<cfcomponent
	extends="Model">
		
	<cffunction
		name="init">
	
		<cfset table("protocol_instancevalues") />
	
	</cffunction>
	
	<cffunction
		name="getRows"
		output="false">
	
		<cfargument
			name="select"
			type="string"
			default=""
			required="true" />
			
		<cfargument
			name="where"
			type="string"
			default=" 1=1"
			required="true" />
			
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_protocol_get_value_rows"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR" 
				value="#arguments.select#"
				dbVarName="@col" />
				
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR" 
				value="#arguments.where#"
				dbVarName="@cond" />
									
			<cfprocresult name="rows" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn rows />
	
	</cffunction>
	
	<!---
		2.01.2013
		Dodanie nowego wiersza do protokołu. Ciekawa metoda na bazie. Dużo dzieje
		się w tle. Zwracany jest tylko wynik.
	--->
	<cffunction
		name="addRow"
		hint="Metoda dodająca nowy wiersz do protokołu">
			
		<cfargument 
			name="instanceid"
			type="numeric"
			required="true" />
		
		<cfargument
			name="typeid"
			type="numeric"
			required="true" />
			
		<cfargument
			name="groupid"
			type="numeric"
			required="true" />
			
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_protocol_add_protocol_instance_row"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER" 
				value="#arguments.typeid#"
				dbVarName="@_type_id" />
				
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER" 
				value="#arguments.instanceid#"
				dbVarName="@_instance_id" />
				
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER" 
				value="#arguments.groupid#"
				dbVarName="@_group_id" />
									
			<cfprocresult name="row" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn row />
			
	</cffunction>
		
</cfcomponent>