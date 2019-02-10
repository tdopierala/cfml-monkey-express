<cfcomponent displayname="object_attr_type" output="false" hint="">
	
	<cfproperty name="id" type="numeric" default="0" />
	<cfproperty name="attr_type_name" type="string" default="" />
	<cfproperty name="attr_type_create" type="string" default="" />
	<cfproperty name="attr_type_userid" type="numeric" default="0" />
	
	<!--- PSEUDO-CONSTRUCTOR --->
	<cfscript>
		variables = {
			id = "0",
			attr_type_name = "",
			attr_type_create = "",
			attr_type_userid = "0"
		};
	</cfscript> 
	
	<!--- CONSTRUCTOR --->
	<cffunction name="init" output="false" access="public" hint="" returntype="object_attr_type">
		<cfargument name="id" type="numeric" required="false" default="0" />
		<cfargument name="typename" type="string" required="false" default="" />
		<cfargument name="typecreate" type="string" required="false" default="#Now()#" />
		<cfargument name="userid" type="numeric" required="false" default="0" />
		
		<cfscript>
			setId(arguments.id);
			setTypeName(arguments.typename);
			setTypeCreate(arguments.typecreate);
			eetUserId(arguments.userid);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<!--- SETTERS --->
	<cffunction name="setId" output="false" access="public" hint="" returntype="void">
		<cfargument name="id" type="numeric" required="true" />
		<cfset variables.id = arguments.id />
	</cffunction>
	
	<cffunction name="setTypeName" output="false" access="public" hint="" returntype="void">
		<cfargument name="typename" type="string" required="true" />
		<cfset variables.attr_type_name = arguments.typename />
	</cffunction>
	
	<cffunction name="setTypeCreate" output="false" access="public" hint="" returntype="void">
		<cfargument name="typecreate" type="string" required="true" />
		<cfset variables.attr_type_create = arguments.typecreate />
	</cffunction>
	
	<cffunction name="setUserId" output="false" access="public" hint="" returntype="void">
		<cfargument name="userid" type="numeric" required="true" />
		<cfset variables.attr_userid = arguments.userid />
	</cffunction>
	
	<!--- GETTERS --->
	<cffunction name="getId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.id />
	</cffunction>
	
	<cffunction name="getTypeName" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.attr_type_name />
	</cffunction>
	
	<cffunction name="getTypeCreate" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.attr_type_create />
	</cffunction>
	
	<cffunction name="getUserId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.attr_userid />
	</cffunction>
	
</cfcomponent>