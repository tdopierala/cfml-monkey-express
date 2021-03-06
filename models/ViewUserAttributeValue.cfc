<cfcomponent
	extends="Model"
	output="false">

	<cffunction
		name="init">

		<cfset table("view_userattributevalues") />
		<cfset setPrimaryKey("userid,attributeid") />

	</cffunction>

	<!---
		29.03.2013
		Pobieram atrybuty użytkownika aby je wyświetlić w profilu.
		Zapytanie jest cachowane.
	--->
	<cffunction
		name="getUserAttributes"
		hint="Pobranie atrybutów użytkownika do wyświetlenia w jego profilu.">

		<cfargument
			name="userid"
			required="true" />

		<cfquery
			name="query_get_user_attributes"
			result="result_get_user_attributes"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >

				SELECT
					uav.userid,
					ua.attributeid,
					uav.userattributevaluetext,
					a.attributename,
					a.attributelabel,
					ua.id as userattributeid,
					uav.id as userattributevalueid,
					a.attributetypeid as attributetypeid,
					a.attributerequired as attributerequired,
					a.ord
				FROM userattributes ua
				inner join attributes a on ua.attributeid = a.id
				inner join userattributevalues uav on uav.attributeid=a.id
				where ua.visible=1 and uav.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />

		</cfquery>

		<cfreturn query_get_user_attributes />

	</cffunction>

</cfcomponent>