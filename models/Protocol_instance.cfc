<cfcomponent
	extends="Model">

	<cffunction
		name="init">

		<cfset table("protocol_instances") />

	</cffunction>

	<cffunction
		name="getDates"
		hint="Pobranie listy ostatnich 7 dni z ilością protokołów">

		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_protocol_get_summary_dates"
			returnCode="No">

			<cfprocresult name="rows" resultSet="1" />

		</cfstoredproc>

		<cfreturn rows />

	</cffunction>

	<cffunction
		name="getProtocols"
		hint="Lista protokołów na dany dzień"
		description="Metoda generująca listę protokoów na dany dzień. Dzień jest podawany jako argument
			do metody.">

		<cfargument
			name="day"
			type="any"
			required="true" />

		<cfargument
			name="month"
			type="any"
			required="true" />

		<cfargument
			name="year"
			type="any"
			required="true" />

		<cfstoredproc
			procedure="sp_intranet_protocol_get_day_protocols"
			datasource="#get('loc').datasource.intranet#"
			returncode="false" >

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.day#"
				dbVarName = "@_day" />

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.month#"
				dbVarName = "@_month" />

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.year#"
				dbVarName = "@_year" />

			<cfprocresult name="rows" />

		</cfstoredproc>

		<cfreturn rows />

	</cffunction>

	<cffunction
		name="widgetGetStoreProtocols"
		hint="Pobranie protokołów przypisanych do sklepu."
		description="Zapytanie pobierające listę protokołów przypisaną do sklepu.">

		<!---
			17.04.2013
			Zapytanie pobierające ostatnie 8 protokołów przypisanych do sklepu.
			Listowane są wszystkie protokoły bez względu na ich typ. Sortowanie
			odbywa się po dacie dodania.
		--->

		<cfargument
			name="userid"
			type="numeric"
			required="true" />

		<cfargument
			name="limit"
			type="numeric"
			default="8"
			required="false" />

		<cfquery
			name="qStoreProt"
			result="rStoreProt"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				pi.id as id
				,pi.typeid as typeid
				,pi.instance_created as instance_created
				,pi.protocolnumber as protocolnumber
				,pt.typename as typename
			from protocol_instances pi
			inner join protocol_types pt on pi.typeid = pt.id
			where pi.userid = <cfqueryparam
									value="#arguments.userid#"
									cfsqltype="cf_sql_integer" />
			order by pi.instance_created desc
			limit <cfqueryparam
						value="#arguments.limit#"
						cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfreturn qStoreProt />

	</cffunction>

</cfcomponent>