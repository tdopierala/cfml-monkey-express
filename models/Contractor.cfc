<!---  Contractor.cfc --->
<!--- @@Created By: TD Ma?pka S.A. 2012 --->
<!---
Model obs?uguj?cy wyci?ganie danych z bazy Asseco.

Dost?pne procedury:
	wusr_sp_intranet_monkey_get_contractors	-	Pobieranie listy 10 kontrahentów pasuj?cych do szukanej frazy.

--->
<cfcomponent extends="Model">

	<cffunction name="init">

	</cffunction>

	<!--- getContractors --->
	<!---
	Metoda odwo?uj?ca si? do procedury na bazie danych i pobieraj?ca list?  kontrahentów.
	Argumentem metody jest ci?g znaków po którym s? wyszukiwane rekordy.
	--->
	<cffunction
		name="getContractors"
		displayname="getContractors"
		returnFormat="json">

		<cfargument name="search" type="string" default="%" required="false" />
		<cfargument name="logo" type="string" default="%" required="false" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.asseco#"
			procedure = "wusr_sp_intranet_monkey_get_contractors"
			returncode = "yes">

			<cfprocparam type = "in" cfsqltype = "CF_SQL_VARCHAR" value = "#arguments.search#" dbVarName = "@search" />
			<cfprocparam type = "in" cfsqltype = "CF_SQL_VARCHAR" value = "#arguments.logo#" dbVarName = "@logo" />

			<cfprocresult name="contractors" resultset="1" />

		</cfstoredproc>

		<cfreturn QueryToStruct(contractors) />

	</cffunction>
	
	<cffunction name="kontrachentZIntranetu" output="false" access="public" hint="">
		<cfargument name="text" type="string" required="true" />
		
		<cfset var kontrahenci = "" />
		<cfquery name="kontrahenci" datasource="#get('loc').datasource.intranet#">
			select * from contractors 
			where str_logo like <cfqueryparam value="%#arguments.text#%" cfsqltype="cf_sql_varchar" />
		</cfquery>
		<cfreturn kontrahenci />
	</cffunction>
	
	<cffunction name="kontrahentZIntranetuPoId" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var kontrahent = "" />
		<cfquery name="kontrahent" datasource="#get('loc').datasource.intranet#">
			select * from contractors
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn kontrahent />
	</cffunction>

</cfcomponent>