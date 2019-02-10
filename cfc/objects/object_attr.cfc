<cfcomponent displayname="object_attr" output="false" hint="">

	<cfproperty name="id" type="numeric" default="0" />
	<cfproperty name="attr_name" type="string" default="" />
	<cfproperty name="attr_userid" type="string" default="" />
	<cfproperty name="attr_create" type="string" default="" />
	<cfproperty name="attr_type_id" type="numeric" default="0" />
	
	<cfscript>
		variables = {
			id = "0",
			attr_name = "",
			attr_userid = "0",
			attr_create = "",
			attr_type_id = "0"
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" returntype="object_attr" hint="">
		<cfargument name="id" type="numeric" required="false" default="0" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="userid" type="numeric" require="false" default="0" />
		<cfargument name="create" type="string" required="false" default="#Now()#" />
		<cfargument name="typeid" type="numeric" required="false" default="0" />
		
		<cfscript>
			setId(arguments.id);
			setName(arguments.name);
			setUserId(arguments.userid);
			setCreate(arguments.create);
			setTypeId(arguments.typeid);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setId" output="false" access="public" returntype="void" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfset variables.id = arguments.id />
	</cffunction>
	
	<cffunction name="setName" output="false" access="public" returntype="void" hint="">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.attr_name = arguments.name />
	</cffunction>
	
	<cffunction name="setUserId" output="false" access="public" returntype="void" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		<cfset variables.attr_userid = arguments.userid />
	</cffunction>
	
	<cffunction name="setCreate" output="false" access="public" returntype="void" hint="">
		<cfargument name="create" type="string" required="true" />
		<cfset variables.attr_create = arguments.create />
	</cffunction>
	
	<cffunction name="setTypeId" output="false" access="public" returntype="void" hint="">
		<cfargument name="typeid" type="numeric" required="true" />
		<cfset variables.attr_type_id = arguments.typeid />
	</cffunction>
	
	<cffunction name="getId" output="false" access="public" returntype="numeric" hint="">
		<cfreturn variables.id />
	</cffunction>
	
	<cffunction name="getName" output="false" access="public" returntype="string" hint="">
		<cfreturn variables.attr_name />
	</cffunction>
	
	<cffunction name="getUserId" output="false" access="public" returntype="numeric" hint="">
		<cfreturn variables.attr_userid />
	</cffunction>
	
	<cffunction name="getCreate" output="false" access="public" returntype="String" hint="">
		<cfreturn variables.attr_create />
	</cffunction> 
	
	<cffunction name="getTypeId" output="false" access="public" returntype="numeric" hint="">
		<cfreturn variables.attr_type_id />
	</cffunction>
	
</cfcomponent> 