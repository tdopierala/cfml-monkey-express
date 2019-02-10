<cfcomponent displayname="object_def_attrGateway" output="false" hint="">
	<cffunction name="init" output="false" access="public" hint="" returntype="object_def_attrGateway">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getDefAttrId" output="false" access="public" hint="" returntype="numeric">
		<cfargument name="defid" type="numeric" required="true" />
		<cfargument name="attrid" type="numeric" required="true" />
		
		<cfset var identyfikator = "" />
		<cfquery name="identyfikator" datasource="#variables.dsn#">
			select id from object_def_attr
			where
				def_id = <cfqueryparam value="#arguments.defid#" cfsqltype="cf_sql_integer" />
				and attr_id = <cfqueryparam value="#arguments.attrid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn identyfikator.id />
	</cffunction>
</cfcomponent>