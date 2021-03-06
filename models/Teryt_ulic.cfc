<cfcomponent
	extends="Model"
	output="false">

	<cffunction
		name="init">

		<cfset table("teryt_ulic") />

	</cffunction>

	<cffunction
		name="ulic"
		hint="Pobieranie ulic">

		<cfargument
			name="limit"
			type="numeric"
			default="12" />

		<cfargument
			name="tosearch"
			type="string"
			default="" />

		<cfquery
			name="query_ulic"
			datasource="#get('loc').datasource.intranet#"
			result="result_ulic">

			select
				distinct nazwa_1
				,cecha
			from teryt_ulic
			where nazwa_1 like <cfqueryparam
									value="%#arguments.tosearch#%"
									cfsqltype="cf_sql_varchar" >
			limit #arguments.limit#

		</cfquery>

		<cfreturn super.QueryToStruct(Query=query_ulic) />

	</cffunction>

</cfcomponent>