<cfcomponent displayname="object_instGateway" output="false" hint="">
	
	<cffunction name="init" output="false" access="public" hint="" returntype="object_instGateway">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getInstances" output="false" access="public" hint="" returntype="query">
		<cfargument name="text" type="string" required="false" default="%" />
		
		<cfset var instancje = "" />
		<cfquery name="instancje" datasource="#variables.dsn#">
			select * from object_inst
		</cfquery>
		
		<cfreturn instancje />
	</cffunction>
	
</cfcomponent>