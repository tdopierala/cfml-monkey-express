<cfcomponent displayname="object_inst_value" output="false" hint="">
	
	<cfproperty name="id" type="numeric" default="0" />
	<cfproperty name="def_id" type="numeric" default="0" />
	<cfproperty name="inst_id" type="numeric" default="0" />
	<cfproperty name="attr_id" type="numeric" default="0" />
	<cfproperty name="def_attr_id" type="numeric" default="0" />
	<cfproperty name="attr_type_id" type="numeric" default="0" />
	<cfproperty name="inst_value_text" type="string" default="" />
	<!---<cfproperty name="inst_value_blob" type="binary" default="0" />---> 
	<cfproperty name="inst_value_file" type="string" default="" />
	
	<cfscript>
		variables = {
			id = "0",
			def_id = "0",
			inst_id = "0",
			attr_id = "0",
			def_attr_id = "0",
			attr_type_id = "0",
			inst_value_text = "",
			inst_value_file = ""
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" hint="" returntype="object_inst_value">
		<cfargument name="id" type="numeric" required="false" default="0" />
		<cfargument name="defid" type="numeric" required="false" default="0" />
		<cfargument name="instid" type="numeric" required="false" default="0" />
		<cfargument name="attrid" type="numeric" required="false" default="0" />
		<cfargument name="defattrid" type="numeric" required="false" default="0" />
		<cfargument name="attrtypeid" type="numeric" required="false" default="0" />
		<cfargument name="text" type="string" required="false" default="" />
		<cfargument name="file" type="string" required="false" default="" />
		
		<cfscript>
			setId(arguments.id);
			setDefId(arguments.defid);
			setInstId(arguments.instid);
			setAttrId(arguments.attrid);
			setDefAttrId(arguments.defattrid);
			setAttrTypeId(arguments.attrtypeid);
			setText(arguments.text);
			setFile(arguments.file);
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
	
	<cffunction name="setInstId" output="false" access="public" hint="" returntype="void">
		<cfargument name="instid" type="numeric" required="true" />
		<cfset variables.inst_id = arguments.instid />
	</cffunction>
	
	<cffunction name="setAttrId" output="false" access="public" hint="" returntype="void">
		<cfargument name="attrid" type="numeric" required="true" />
		<cfset variables.attr_id = arguments.attrid />
	</cffunction>
	
	<cffunction name="setDefAttrId" output="false" access="public" hint="" returntype="void">
		<cfargument name="attrid" type="numeric" required="true" />
		<cfset variables.def_attr_id = arguments.attrid />
	</cffunction>
	
	<cffunction name="setAttrTypeId" output="false" access="public" hint="" returntype="void">
		<cfargument name="typeid" type="numeric" required="true" />
		<cfset variables.attr_type_id = arguments.typeid />
	</cffunction>
	
	<cffunction name="setText" output="false" access="public" hint="" returntype="void">
		<cfargument name="text" type="string" required="true" />
		<cfset variables.inst_value_text = arguments.text />
	</cffunction>
	
	<cffunction name="setFile" output="false" access="public" hint="" returntype="void">
		<cfargument name="file" type="string" required="true" />
		<cfset variables.inst_value_file = arguments.file />
	</cffunction>
	
	<cffunction name="getId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.id />
	</cffunction>
	
	<cffunction name="getDefId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.def_id />
	</cffunction>
	
	<cffunction name="getInstId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.inst_id />
	</cffunction>
	
	<cffunction name="getAttrId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.attr_id />
	</cffunction>
	
	<cffunction name="getDefAttrId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.def_attr_id />
	</cffunction>
	
	<cffunction name="getAttrTypeId" output="false" access="public" hint="" returntype="numeric">
		<cfreturn variables.attr_type_id />
	</cffunction>
	
	<cffunction name="getText" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.inst_value_text />
	</cffunction>
	
	<cffunction name="getFile" output="false" access="public" hint="" returntype="string">
		<cfreturn variables.inst_value_file />
	</cffunction>
	
</cfcomponent>