<cfcomponent 
	extends="Model">

	<cffunction 
		name="init">
	
		<cfset table("place_fields") />
	
	</cffunction>
	
	<cffunction
		name="getAllFields"
		hint="Pobranie wszystkich pól formularza">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_all_place_form_fields"
			returnCode="No">
				
			<cfprocresult name="fields" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn fields />
	
	</cffunction>
	
	<cffunction
		name="getFieldsByForm"
		hint="Pobranie listy pól formularza">
	
		<cfargument name="formed" type="numeric" default="0" required="true" />
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_fields_by_form"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.formid#"
				dbVarName="@form_id" />
					
			<cfprocresult name="fields" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn fields />
	
	</cffunction>
	
	<cffunction
		name="getFieldsToSelectBox"
		hint="Pobranie wszystkich pól formularza do selectboxów :)">
	
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_all_place_fields_selectbox"
			returnCode="No">
				
			<cfprocresult name="fields" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn fields />
	
	</cffunction>

</cfcomponent>