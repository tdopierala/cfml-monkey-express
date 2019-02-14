<cfcomponent displayname="AssecoGateway" output="false" hint="">
	<cffunction name="init" output="false" access="public" hint="" returntype="AssecoGateway">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="szukajKontrahenta" output="false" access="public" returntype="query">
		<cfargument name="text" type="string" default="" required="true" />
		
		<cfset var kontrahenci = "" />
		<cfstoredproc dataSource="#variables.dsn#" procedure="wusr_sp_intranet_monkey_get_contractors" returncode="yes">
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="%" dbVarName = "@search" />
			<cfprocparam type="in" cfsqltype="cf_sql_varchar" value="#arguments.text#" dbVarName = "@logo" />
			<cfprocresult name="kontrahenci" resultset="1" />
		</cfstoredproc>
		
		<cfreturn kontrahenci />
	</cffunction>
</cfcomponent>