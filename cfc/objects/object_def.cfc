<cfcomponent displayname="object_def" output="false" hint="">

	<cfproperty name="def_id" type="numeric" default="0" />
	<cfproperty name="def_userid" type="string" default="" />
	<cfproperty name="def_create" type="string" default="" />
	<cfproperty name="def_name" type="string" default="" />
	<cfproperty name="def_rgt" type="numeric" default="0" />
	<cfproperty name="def_lft" type="numeric" default="0" />
	
	<!--- PSEUDO CONSTRUCTOR --->
	<cfscript>
		variables = {
			def_id = "",
			def_userid = "",
			def_create = "#Now()#",
			def_name = "",
			def_rgt = "0",
			def_lft = "0"
		};
	</cfscript> 
	
	<cffunction name="init" output="false" access="public" hint="" returntype="object_def">
		<cfargument name="id" type="numeric" required="false" default="0" />
		<cfargument name="userid" type="numeric" required="false" default="0" />
		<cfargument name="create" type="string" required="false" default="#Now()#" />
		<cfargument name="name" type="string" required="false" default="" />
		<cfargument name="rgt" type="numeric" required="false" default="0" />
		<cfargument name="lft" type="numeric" required="false" default="0" />
		
		<cfscript>
			setId(arguments.id);
			setUserId(arguments.userid);
			setCreate(arguments.create);
			setName(arguments.name);
			setLft(arguments.lft);
			setRgt(arguments.rgt);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setId" outut="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfset variables.def_id = arguments.id />
	</cffunction>
	
	<cffunction name="setUserId" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		<cfset variables.def_userid = arguments.userid />
	</cffunction>
	
	<cffunction name="setCreate" output="false" access="public" hint="">
		<cfargument name="create" type="string" require="true" />
		<cfset variables.def_create = arguments.create />
	</cffunction>
	
	<cffunction name="setName" output="false" access="public" hint="">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.def_name = arguments.name />
	</cffunction>
	
	<cffunction name="setLft" output="false" access="public" hint="">
		<cfargument name="lft" type="numeric" required="true" />
		<cfset variables.def_lft = arguments.lft />
	</cffunction>
	
	<cffunction name="setRgt" output="false" access="public" hint="">
		<cfargument name="rgt" type="numeric" required="true" />
		<cfset variables.def_rgt = arguments.rgt />
	</cffunction>
	
	<cffunction name="getId" output="false" access="public" returntype="numeric" hint="">
		<cfreturn variables.def_id />
	</cffunction>
	
	<cffunction name="getUserId" output="false" access="public" returntype="numeric" hint="">
		<cfreturn variables.def_userid />
	</cffunction>
	
	<cffunction name="getCreate" output="false" access="public" returntype="string" hint="">
		<cfreturn variables.def_create />
	</cffunction>
	
	<cffunction name="getName" output="false" access="public" returntype="string" hint="">
		<cfreturn variables.def_name />
	</cffunction>
	
	
</cfcomponent>