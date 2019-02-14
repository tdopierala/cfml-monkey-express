<cfcomponent 
	extends="Model">

	<cffunction 
		name="init">
	
		<cfset table("instruction_userinstructions") />
	
	</cffunction>
	
	<cffunction
		name="createAssignment"
		hint="Generowanie powiązań użytkownika z instrukcją">
	
		<cfargument name="instructionid" default="0" required="true" type="numeric" />
		<cfargument name="groups" default="" required="true" type="string" />
		<cfargument name="bound" default="," required="false" type="string" />
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_create_user_to_instruction_assignment"
			returnCode="No">
			
			<cfprocparam 
				type="in"
				CFSQLType="CF_SQL_CHAR"
				value="#arguments.bound#"
				dbVarName="@bound" />
				
			<cfprocparam 
				type="in"
				CFSQLType="CF_SQL_VARCHAR"
				value="#arguments.groups#"
				dbVarName="@where_cond" />
				
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.instructionid#"
				dbVarName="@instruction_id" />
		
		</cfstoredproc>
	
	</cffunction>

</cfcomponent>