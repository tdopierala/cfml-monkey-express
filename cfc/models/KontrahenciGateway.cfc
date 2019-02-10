<cfcomponent displayname="KontrahenciGateway" output="false" hint="">
	<cffunction name="init" output="false" access="public" hint="" returntype="KontrahenciGateway" >
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="pobierzKontrahentaPoLogo" output="false" access="public" hint="" returntype="Kontrahent">
		<cfargument name="logo" type="string" required="true" />
		
		<cfset var dao = createObject("component", "cfc.models.KontrahentDAO").init(variables.dsn) />
		
		<cfset var szukaj = "" />
		<cfquery name="szukaj" datasource="#variables.dsn#">
			select * from contractors where logo = <cfqueryparam value="#arguments.logo#" cfsqltype="cf_sql_varchar" /> limit 1;
		</cfquery>
		
		<cfset var idKontrahenta = 0 />
		<cfif szukaj.recordCount EQ 1>
			<cfset idKontrahenta = szukaj.id />
		</cfif>
		
		<cfset var kontrahent = createObject("component", "cfc.models.Kontrahent").init(id = idKontrahenta) />
		<cfset dao.read(kontrahent) />
		
		<cfreturn kontrahent />
	</cffunction>
	
</cfcomponent>