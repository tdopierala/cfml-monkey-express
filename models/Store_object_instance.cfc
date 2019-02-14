<cfcomponent displayname="Store_object_instance" output="false" extends="Model" hint="">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("store_object_instances") />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="" returntype="struct">
		<cfargument name="objectid" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="storeid" type="numeric" required="true" />
		<cfargument name="project" type="string" required="true" />
		
		<cfset var newInstance = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Obiekt został dodany do sklepu" />
		<cfset results.id = "" />
		
		<cftry>
			
			<cfquery name="newInstance" datasource="#get('loc').datasource.intranet#">
				insert into store_object_instances (object_id, user_id, store_id, created, store_project)
				values (
					<cfqueryparam value="#arguments.objectid#" cfsqltype="cf_sql_integer" />,
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
				<cfset results.message = "Nie można dodac obiektu do sklepu: #CFCATCH.Message#" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="createValue" output="false" access="public" hint="" returntype="struct">
		<cfargument name="objectid" type="numeric" required="true" />
		<cfargument name="attributeid" type="numeric" required="true" />
		<cfargument name="typeid" type="numeric" required="true" />
		<cfargument name="instanceid" type="numeric" required="true" />
		<cfargument name="text" type="string" required="true" />
		
		<cfset var newValue = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Wartość została zapisana" />
		<cfset results.id = "" />
		
		<cftry>
			
			<cfquery name="newValue" datasource="#get('loc').datasource.intranet#">
				insert into store_object_instance_values (object_id, attribute_id, attribute_type_id, object_instance_id, value_text)
				values (
					<cfqueryparam value="#arguments.objectid#" cfsqltype="cf_sql_integer" />,
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
				<cfset results.message = "Nie można dodać wartości: #CFCATCH.Message#" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="updateValue" output="false" access="public" hint="" returntype="struct">
		<cfargument name="objectid" type="numeric" required="true" />
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
			update store_object_instance_values 
			set value_text = <cfqueryparam value="#arguments.text#" cfsqltype="cf_sql_varchar" />
			where object_instance_id = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />
				and attribute_id = <cfqueryparam value="#arguments.attributeid#" cfsqltype="cf_sql_integer" />
				and object_id = <cfqueryparam value="#arguments.objectid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="">
		<cfargument name="instanceid" type="numeric" required="true" />
		
		<cfset var usunInstancje = "" />
		<cfset var result = "" />
		<cfquery name="usunInstancje" result="result" datasource="#get('loc').datasource.intranet#">
			delete from store_object_instances
			where id = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn result /> 
	</cffunction>
	
	<cffunction name="getObjectByInstance" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var obiekt = "" />
		<cfquery name="obiekt" datasource="#get('loc').datasource.intranet#">
			select b.* 
			from store_object_instances a
			inner join store_objects b on a.object_id = b.id
			where a.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" /> 
		</cfquery>
		
		<cfreturn obiekt />
	</cffunction>
	
	<cffunction name="getInstanceAttributes" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var atrybuty = "" />
		<cfquery name="atrybuty" datasource="#get('loc').datasource.intranet#">
			select * 
			from store_object_instance_values a
			inner join store_attributes b on a.attribute_id = b.id
			inner join store_attribute_types c on a.attribute_type_id = c.id
			where a.object_instance_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn atrybuty />
	</cffunction>
	
</cfcomponent>