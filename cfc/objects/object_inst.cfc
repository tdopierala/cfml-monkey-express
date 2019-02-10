<cfcomponent displayname="object_inst" output="false" hint="">
	
	<cfproperty name="id" type="numeric" default="0" />
	<cfproperty name="def_id" type="numeric" default="0" />
	<cfproperty name="inst_userid" type="numeric" default="0" />
	<cfproperty name="inst_create" type="string" default="" />
	<cfproperty name="inst_note" type="string" default="" />
	<cfproperty name="inst_lft" type="numeric" default="0" />
	<cfproperty name="inst_rgt" type="numeric" default="0" />
	<cfproperty name="parent_id" type="string" default="" />
	<cfproperty name="inst_name" type="string" default="" />
	
	<cfscript>
		variables = {
			id = "",
			def_id = "",
			inst_userid = "",
			inst_create = "",
			inst_note = "",
			inst_lft = "0",
			inst_rgt = "0",
			parent_id = "",
			inst_name = ""
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" hint="" returntype="object_inst">
		<cfargument name="id" type="numeric" required="false" default="0" />
		<cfargument name="defid" type="numeric" required="false" default="0" />
		<cfargument name="userid" type="numeric" required="false" default="0" />
		<cfargument name="create" type="string" required="false" default="#Now()#" />
		<cfargument name="note" type="string" required="false" default="" />
		<cfargument name="lft" type="numeric" required="false" default="0" />
		<cfargument name="rgt" type="numeric" required="false" default="0" />
		<cfargument name="parentid" type="string" required="false" default="" />
		<cfargument name="name" type="string" required="false" default="" />
		
		<cfscript>
			setId(arguments.id);
			setDefId(arguments.defid);
			setUserId(arguments.userid);
			setCreate(arguments.create);
			setNote(arguments.note);
			setLft(arguments.lft);
			setRgt(arguments.rgt);
			setParentId(arguments.parentid);
			setName(arguments.name);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setId" output="false" access="public" hint="" returntype="void">
		<cfargument name="id" type="numeric" required="true" />
		<cfset variables.id = arguments.id />
	</cffunction>
	
	<cffunction name="setDefId" output="false" access="public" hint="" returntype="void">
		<cfargument name="defid" type="numeric" required="true" />
		<cfset variables.def_id = arguments.defid />
	</cffunction>
	
	<cffunction name="setUserId" output="false" access="public" hint="" returntype="void">
		<cfargument name="userid" type="numeric" required="true" />
		<cfset variables.inst_userid = arguments.userid />
	</cffunction>
	
	<cffunction name="setCreate" output="false" access="public" hint="" returntype="void">
		<cfargument name="create" type="string" required="true" />
		<cfset variables.inst_create = arguments.create />
	</cffunction>
	
	<cffunction name="setNote" output="false" access="public" hint="" returntype="void">
		<cfargument name="note" type="string" required="true" />
		<cfset variables.inst_note = arguments.note />
	</cffunction>

	<cffunction name="setLft" output="false" access="public" hint="" returntype="void">
		<cfargument name="lft" type="numeric" required="true" />
		<cfset variables.inst_lft = arguments.lft />
	</cffunction>

	<cffunction name="setRgt" output="false" access="public" hint="" returntype="void">
		<cfargument name="rgt" type="numeric" required="true" />
		<cfset variables.inst_rgt = arguments.rgt />
	</cffunction>

	<cffunction name="setParentId" output="false" access="public" hint="" returntype="void">
		<cfargument name="parentid" type="string" required="true" />
		<cfset variables.parent_id = arguments.parentid />
	</cffunction>
	
	<cffunction name="setName" output="false" access="public" hint="" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.inst_name = arguments.name />
	</cffunction>
	
	<cffunction name="getId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.id />
	</cffunction>
	
	<cffunction name="getDefId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.def_id />
	</cffunction>
	
	<cffunction name="getUserId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.inst_userid />
	</cffunction>
	
	<cffunction name="getCreate" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.inst_create />
	</cffunction>
	
	<cffunction name="getNote" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.inst_note />
	</cffunction>

	<cffunction name="getLft" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.inst_lft />
	</cffunction>

	<cffunction name="getRgt" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.inst_rgt />
	</cffunction>

	<cffunction name="getParentId" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.parent_id />
	</cffunction>
	
	<cffunction name="getName" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.inst_name />
	</cffunction>
	
</cfcomponent>