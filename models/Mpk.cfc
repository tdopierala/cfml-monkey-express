<cfcomponent extends="Model">

	<cffunction name="init">

		<cfset hasMany("workflowStep")/>

	</cffunction>

	<!--- getMpks --->
	<!---
	Metoda odwołuje się do procedury na bazie danych Asseco i pobiera listę 10 wierszy pasujących do
	wyników wyszukiwania.

	13.03.2012
	Usunąłem ograniczenie do 10 MPKów. Pobieram wszystkie raz.
	--->
	<cffunction
		name="getMpks"
		displayname="getMpks"
		returnFormat="json">

		<cfargument
			name="search"
			type="string"
			default=""
			required="false" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.asseco#"
			procedure = "wusr_sp_intranet_monkey_get_mpks"
			returncode = "yes">

			<cfprocparam
				type = "in"
				cfsqltype = "CF_SQL_VARCHAR"
				value = "#arguments.search#"
				dbVarName = "@search" />

			<cfprocresult name="mpks" resultset="1" />

		</cfstoredproc>

		<cfreturn QueryToStruct(mpks) />
<!--- 		<cfreturn mpks/> --->

	</cffunction>

	<!--- getSingleMpk --->
	<!---
	Zwracam wszystkie dane pojedyńczego mpk aby zapisać go w bazie.
	--->
	<cffunction
		name="getSingleMpk"
		displayname="getSingleMpk"
		returnFormat="json">

		<cfargument name="search" type="string" default="" required="false" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.asseco#"
			procedure = "wusr_sp_intranet_monkey_get_single_mpk"
			returncode = "yes">

			<cfprocparam
				type = "in"
				cfsqltype = "CF_SQL_VARCHAR"
				value = "#arguments.search#"
				dbVarName = "@search" />

			<cfprocresult name="mpk" resultset="1" />

		</cfstoredproc>

		<cfreturn QueryToStruct(mpk) />

	</cffunction>

</cfcomponent>