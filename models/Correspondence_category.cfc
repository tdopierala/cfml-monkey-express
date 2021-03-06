<cfcomponent
	extends="Model"
	output="false">

	<cffunction
		name="init">

		<cfset table("correspondence_categories") />

	</cffunction>

	<cffunction
		name="getCategories"
		hint="Pobranie listy kategorii">

		<cfquery
			name="query_get_categories"
			result="result_get_categories"
			datasource="#get('loc').datasource.intranet#" >

			select
				id as id
				,categoryname as categoryname
			from correspondence_categories;

		</cfquery>

		<cfreturn query_get_categories />

	</cffunction>

</cfcomponent>