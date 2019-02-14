<cfcomponent
	extends="Model">

	<cffunction
		name="init">

		<cfset table("store_types") />

	</cffunction>

	<cffunction
		name="getTypes"
		hint="Pobranie typów sklepów">

		<cfquery
			name="qTypes"
			result="rTypes"
			datasource="#get('loc').datasource.intranet#">

			select
				id as id
				,store_type_name as store_type_name
			from store_types
			order by store_type_name ASC

		</cfquery>

		<cfreturn qTypes />

	</cffunction>

	<cffunction
		name="getStoresByType"
		hint="Pobranie listy sklepów w zależności od typu sklepu">

		<cfargument
			name="storetypeid"
			type="numeric"
			required="true" />

		<cfquery
			name="qStores"
			result="rStores"
			datasource="#get('loc').datasource.intranet#">

			select
				s.id as id
				,s.projekt as projekt
				,s.adressklepu as adressklepu
				,s.loc_mall_name as loc_mall_name
			from store_stores s
			where s.storetype_id = <cfqueryparam
										value="#arguments.storetypeid#"
										cfsqltype="cf_sql_integer" />

		</cfquery>

		<cfreturn qStores />

	</cffunction>

</cfcomponent>