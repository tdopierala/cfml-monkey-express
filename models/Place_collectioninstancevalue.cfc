<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("place_collectioninstancevalues") />
	
	</cffunction>
	
	<cffunction
		name="getComments"
		hint="Pobranie komentarzy pola opisującego zbiór">
	
		<cfargument name="collectioninstancevalueid" type="numeric" default="0" required="true" />
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_place_get_collection_instance_field_value_comments"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.collectioninstancevalueid#"
				dbVarName="@collectioninstancevalue_id" />
					
			<cfprocresult name="comments" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn comments />
	
	</cffunction>
	
</cfcomponent>