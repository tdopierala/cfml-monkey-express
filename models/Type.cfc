<cfcomponent
	extends="Model">

	<cffunction
		name="init">



	</cffunction>

	<cffunction
		name="getUserTypes"
		hint="Lista typów przypisanych do użytkownika">

		<cfargument name="userid" type="numeric" default="0" required="true" />

		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_user_types"
			returnCode="No">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.userid#"
				dbVarName="@user_id" />

			<cfprocresult name="types" resultSet="1" />

		</cfstoredproc>

		<cfreturn types />

	</cffunction>

	<cffunction
		name="getTypes"
		hint="Pobranie typów dokumentów"
		description="Metoda pobierająca typy dokumentów, które następnie będą
			przypisane do faktury aby można było po nich filtrować. Różnica
			między poprzednią metodą polega na tym, że nie filtruje typów
			po grupie użytkownika">

		<cfquery
			name="qTypes"
			result="rTypes"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select id, typename from types order by ord asc

		</cfquery>

		<cfreturn qTypes />

	</cffunction>

</cfcomponent>