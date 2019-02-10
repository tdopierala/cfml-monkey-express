<cfcomponent displayname="object_attrGateway" output="false" hint="" >
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="listTypes" output="false" access="public" hint="" returntype="query">
		<cfset var typy = "" />
		<cfquery name="typy" datasource="#variables.dsn#">
			select id, attr_type_name, attr_type_create
			from object_attr_types
		</cfquery>
		
		<cfreturn typy />
	</cffunction>
	
	<cffunction name="listAttr" output="false" access="public" hint="" returntype="query">
		<cfset var attr = "" />
		<cfquery name="attr" datasource="#variables.dsn#">
			select * from object_attr;
		</cfquery>
		
		<cfreturn attr />
	</cffunction>
	
</cfcomponent>