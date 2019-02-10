<cfcomponent displayname="object_def_attr" output="false" hint="">
	
	<cfproperty name="id" type="numeric" default="0" />
	<cfproperty name="def_id" type="numeric" default="0" />
	<cfproperty name="attr_id" type="numeric" default="0" />
	<cfproperty name="def_attr_userid" type="numeric" default="0" />
	<cfproperty name="def_attr_create" type="string" default="" />
	
	<!--- PSEUDO-CONSTRUCTOR --->
	<cfscript>
		variables = {
			id = "0",
			def_id = "0",
			attr_id = "0",
			def_attr_userid = "0",
			def_attr_create = ""
		};
	</cfscript>
	
	<!--- CONSTRUCTOR --->
	<cffunction name="init" output="false" access="public" returntype="object_def_attr" hint="">
		<cfargument name="id" type="numeric" default="0" required="false" />
		<cfargument name="defid" type="numeric" default="0" required="false" />
		<cfargument name="attrid" type="numeric" default="0" required="false" />
		<cfargument name="userid" type="numeric" default="0" required="false" />
		<cfargument name="create" type="string" default="#Now()#" required="false" />
		
		<cfscript>
			setId(arguments.id);
			setDefId(arguments.defid);
			setAttrId(arguments.attrid);
			setUserId(arguments.userid);
			setCreate(arguments.create);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<!--- SETTERS --->
	<cffunction name="setId" output="false" access="public" hint="" returntype="void">
		<cfargument name="id" type="numeric" required="true" />
		<cfset variables.id = arguments.id />
	</cffunction>
	
	<cffunction name="setDefId" output="false" access="public" hint="" returntype="void">
		<cfargument name="defid" type="numeric" required="true" />
		<cfset variables.def_id = arguments.defid />
	</cffunction>
	
	<cffunction name="setAttrId" output="false" access="public" hint="" returntype="void">
		<cfargument name="attrid" type="numeric" required="true" />
		<cfset variables.attr_id = arguments.attrid />
	</cffunction>
	
	<cffunction name="setUserId" output="false" access="public" hint="" returntype="void">
		<cfargument name="userid" type="numeric" required="true" />
		<cfset variables.def_attr_userid = arguments.userid />
	</cffunction>
	
	<cffunction name="setCreate" output="false" access="public" hint="" returntype="void">
		<cfargument name="create" type="string" required="true" />
		<cfset variables.def_attr_create = arguments.create />
	</cffunction>
	
	<!--- GETTERS --->
	<cffunction name="getId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.id />
	</cffunction>
	
	<cffunction name="getDefId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.def_id />
	</cffunction>
	
	<cffunction name="getAttrId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.attr_id />
	</cffunction>
	
	<cffunction name="getUserId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.def_attr_userid />
	</cffunction>
	
	<cffunction name="getCreate" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.def_attr_create />
	</cffunction>
	
</cfcomponent>