<cfcomponent displayname="Paragon_adres" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("paragon_adresy") />
	</cffunction>
	
	<cffunction name="pobierzAdresy" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		<cfset var adresy = "" />
		<cfquery name="adresy" datasource="#get('loc').datasource.intranet#">
			select * from paragon_adresy 
			where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn adresy />
	</cffunction>
</cfcomponent>