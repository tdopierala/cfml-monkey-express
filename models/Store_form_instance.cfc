<cfcomponent displayname="Store_form_instance" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("store_form_instances") />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="" returntype="struct">
		<cfargument name="formid" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="storeid" type="numeric" required="true" />
		<cfargument name="project" type="string" required="true" />
		
		<cfset var newInstance = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodałem formularz do sklepu" />
		<cfset results.id = "" />
		
		<cftry>
			
			<cfquery name="newInstance" datasource="#get('loc').datasource.intranet#">
				insert into store_form_instances (form_id, user_id, store_id, created, project)
				values (
					<cfqueryparam value="#arguments.formid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.storeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#arguments.project#" cfsqltype="cf_sql_varchar" />
				);
				select LAST_INSERT_ID() as id;
			</cfquery>
			
			<cfset results.id = newInstance.id />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie mogę dodać formularza do sklepu: #CFCATCH.Message#" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="createValue" output="false" access="public" hint="" returntype="struct">
		<cfargument name="formid" type="numeric" required="true" />
		<cfargument name="attributeid" type="numeric" required="true" />
		<cfargument name="typeid" type="numeric" required="true" />
		<cfargument name="instanceid" type="numeric" required="true" />
		<cfargument name="text" type="string" required="true" />
		
		<cfset var newValue = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodałem atrybut do formularza" />
		<cfset results.id = "" />
		
		<cftry>
			
			<cfquery name="newValue" datasource="#get('loc').datasource.intranet#">
				insert into store_form_instance_values (form_id, attribute_id, attribute_type_id, form_instance_id, value_text)
				values (
					<cfqueryparam value="#arguments.formid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.attributeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.text#" cfsqltype="cf_sql_varchar" />
				);
				select LAST_INSERT_ID() as id;
			</cfquery>
			
			<cfset results.id = newValue.id />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie mogę dodać atrybutu do formularza: #CFCATCH.Message#" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="">
		<cfargument name="instanceid" type="numeric" required="true" />
		
		<cfset var usunInstancje = "" />
		<cfset var result = "" />
		<cfquery name="usunInstancje" result="result" datasource="#get('loc').datasource.intranet#">
			delete from store_form_instances
			where id = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn result /> 
	</cffunction>
	
	<cffunction name="updateValue" output="false" access="public" hint="" returntype="struct">
		<cfargument name="formid" type="numeric" required="true" />
		<cfargument name="attributeid" type="numeric" required="true" />
		<cfargument name="typeid" type="numeric" required="true" />
		<cfargument name="instanceid" type="numeric" required="true" />
		<cfargument name="text" type="string" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Wartość została zaktualizowana" />
		
		<cfset var aktualizacjaAtrybutu = "" />
		
		<cfset var result = "" />
		<cfquery name="aktualizacjaAtrybutu" result="result" datasource="#get('loc').datasource.intranet#">
			update store_form_instance_values 
			set value_text = <cfqueryparam value="#arguments.text#" cfsqltype="cf_sql_varchar" />
			where form_instance_id = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />
				and attribute_id = <cfqueryparam value="#arguments.attributeid#" cfsqltype="cf_sql_integer" />
				and form_id = <cfqueryparam value="#arguments.formid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="getFormByInstance" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var formularz = "" />
		<cfquery name="formularz" datasource="#get('loc').datasource.intranet#">
			select b.* 
			from store_form_instances a
			inner join store_forms b on a.form_id = b.id
			where a.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" /> 
		</cfquery>
		
		<cfreturn formularz />
	</cffunction>
	
	<cffunction name="getInstanceAttributes" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var atrybuty = "" />
		<cfquery name="atrybuty" datasource="#get('loc').datasource.intranet#">
			select * 
			from store_form_instance_values a
			inner join store_attributes b on a.attribute_id = b.id
			inner join store_attribute_types c on a.attribute_type_id = c.id
			where a.form_instance_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn atrybuty />
	</cffunction>
	
</cfcomponent>