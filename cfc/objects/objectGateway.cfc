<cfcomponent displayname="objectGateway" output="false" hint="">
	
	<cffunction name="init" iutout="false" access="public" hint="" returntype="objectGateway">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	
	
</cfcomponent>