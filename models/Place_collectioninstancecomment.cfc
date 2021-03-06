<cfcomponent
	extends="Model">

	<cffunction
		name="init">
		
		<cfset table("place_collectioninstancecomments") />
	
	</cffunction>
	
	<cffunction
		name="getComments"
		hint="Pobranie komentarzy do zbioru">
		
		<cfargument name="collectioninstanceid" type="numeric" default="0" required="true" />
		
		<cfstoredproc 
			procedure="sp_intranet_place_get_collection_instance_comments" 
			datasource="#get('loc').datasource.intranet#" 
			returncode="false" >
			
			<cfprocparam 
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.collectioninstanceid#"
				dbVarName="@collectioninstance_id" />
				
			<cfprocresult name="comments" >
			
		</cfstoredproc>
		
		<cfreturn comments />
		
	</cffunction>
		
</cfcomponent>