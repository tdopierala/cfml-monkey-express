<cfcomponent 
	extends="Model">

	<cffunction
		name="init">
	
		<cfset belongsTo("placeStep") />
		<cfset belongsTo("placeStatus") />
		<cfset belongsTo("user") />
	
	</cffunction>
	
	<cffunction
		name="getPlaceWorkflow"
		hint="Pobranie wszystkich kroków obiegu dokumentów">
	
		<cfargument name="placeid" default="0" type="numeric" required="true" />
 	
 		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_place_workflow"
			returnCode="No">
		
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.placeid#"
				dbVarName="@place_id" />
				
			<cfprocresult name="placeworkflow" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn placeworkflow />
 	
	</cffunction>

</cfcomponent>