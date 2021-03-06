<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("place_collectioninstances") />
	
	</cffunction>
	
	<cffunction
		name="getCollectionInstanceFields"
		hint="Pobranie pól formularza zbioru">
	
		<cfargument name="collectioninstanceid" type="numeric" required="false" default="0" />
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_get_collection_instance_fields"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.collectioninstanceid#"
				dbVarName="@collectioninstance_id" />
					
			<cfprocresult name="fields" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn fields />
	
	</cffunction>
		
</cfcomponent>