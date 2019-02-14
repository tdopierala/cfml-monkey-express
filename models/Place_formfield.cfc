<cfcomponent
	extends="Model">

	<cffunction
		name="init">
			
		<cfset table("place_formfields") />
			
	</cffunction>
	
	<cffunction name="removeFormField" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var deleteFormField = "" />
		<cfset var deteleFormFieldResult = "" />
		<cfset var formField = "" />
		
		<cfquery name="formField" datasource="#get('loc').datasource.intranet#">
			select id, formid, fieldid from place_formfields where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" /> ;
		</cfquery>
		
		<cfquery name="deleteFormField" result="deleteFormFieldResult" datasource="#get('loc').datasource.intranet#">
			delete from place_formfields where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
			<!---
			delete from place_instanceforms where formfieldid = <cfqueryparam value="#formField.fieldid#" cfsqltype="cf_sql_integer" />;
			--->
			<!---
			delete from place_instanceformcomments where formfieldid = <cfqueryparam value="#formField.fieldid#" cfsqltype="cf_sql_integer" />; 
			--->
			<!---
			delete from place_fieldgroups where fieldid = <cfqueryparam value="#formField.fieldid#" cfsqltype="cf_sql_integer" />;
			--->
		</cfquery>
		
		<cfreturn deleteFormFieldResult />
	</cffunction>
		
</cfcomponent>