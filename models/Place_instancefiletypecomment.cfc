<cfcomponent
	extends="Model">
	
	<cffunction
		name="init">
	
		<cfset table("place_instancefiletypecomments") />
	
	</cffunction>
	
	<cffunction
		name="getComments"
		hint="Metoda pobierająca komentarze do plików na podstawie id instancji pliku">
	
		<cfargument name="instancefiletypeid" type="numeric" default="0" required="true" />
		
		<cfstoredproc 
			procedure="sp_intranet_place_get_instance_file_type_comments" 
			datasource="#get('loc').datasource.intranet#" 
			returncode="false" >
			
			<cfprocparam 
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.instancefiletypeid#"
				dbVarName="@instancefiletype_id" />
				
			<cfprocresult name="comments" >
			
		</cfstoredproc>
		
		<cfreturn comments />
	
	</cffunction>

</cfcomponent>