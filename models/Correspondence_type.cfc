<cfcomponent
	extends="Model">

	<cffunction
		name="init">
			
		<cfset table("correspondence_types") />
			
	</cffunction>
	
	<cffunction
		name="getTypes"
		hint="Pobieram typy listów do wpisania do listy">
			
		<cfquery
			name="query_get_types"
			result="result_get_types"
			datasource="#get('loc').datasource.intranet#" >
		
			select
				distinct
				id
				,typename
			from correspondence_types;
		
		</cfquery>
		
		<cfreturn query_get_types />
			
	</cffunction>
		
</cfcomponent>