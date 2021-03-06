<cfcomponent extends="Model">

	<cffunction name="init">

		<cfset hasMany("workflowStep")/>

	</cffunction>

	<!--- getProjects --->
	<!---
	Metoda odwołuje się do procedury na bazie danych Asseco i pobiera listę wszystkich projektów.
	--->
	<cffunction
		name="getProjects"
		displayname="getProjects"
		returnFormat="json">

		<cfargument name="search" type="string" default="" required="false"/>

		<cfstoredproc
			dataSource = "#get('loc').datasource.asseco#"
			procedure = "wusr_sp_intranet_monkey_get_projects"
			returncode = "yes">

			<cfprocparam
				type = "in"
				cfsqltype = "CF_SQL_VARCHAR"
				value = "#arguments.search#"
				dbVarName = "@search" />

			<cfprocresult name="projects" resultset="1" />

		</cfstoredproc>

		<cfreturn QueryToStruct(projects) />
<!--- 		<cfreturn mpks/> --->

	</cffunction>

	<!--- getSingleProject --->
	<!---
	Zwracam wszystkie dane pojedyńczego projektu aby zapisać go w bazie.
	--->
	<cffunction
		name="getSingleProject"
		displayname="getSingleProject"
		returnFormat="json">

		<cfargument name="search" type="string" default="" required="false" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.asseco#"
			procedure = "wusr_sp_intranet_monkey_get_single_project"
			returncode = "yes">

			<cfprocparam
				type = "in"
				cfsqltype = "CF_SQL_VARCHAR"
				value = "#arguments.search#"
				dbVarName = "@search" />

			<cfprocresult name="projects" resultset="1" />

		</cfstoredproc>

		<cfreturn QueryToStruct(projects) />

	</cffunction>

</cfcomponent>