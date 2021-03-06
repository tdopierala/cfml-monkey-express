<cfcomponent
	extends="Model"
	output="false">

	<cffunction
		name="init">

		<cfset table("teryt_simc") />

	</cffunction>

	<cffunction
		name="simc"
		hint="Pobranie miast">

		<cfargument
			name="limit"
			type="numeric"
			default="12" />

		<cfargument
			name="tosearch"
			type="string"
			default="" />

		<cfquery
			name="query_simc"
			datasource="#get('loc').datasource.intranet#"
			result="result_simc">

			select
				nazwa
			from teryt_simc
			where nazwa like <cfqueryparam
									value="%#arguments.tosearch#%"
									cfsqltype="cf_sql_varchar" >
			limit #arguments.limit#

		</cfquery>

		<cfreturn super.QueryToStruct(Query=query_simc) />

	</cffunction>

</cfcomponent>