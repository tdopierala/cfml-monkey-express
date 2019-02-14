<cfcomponent extends="Model" displayname="Store_attribute" hibt="">

	<cffunction name="init">
		<cfset table("store_attributes") />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="" returntype="struct">
		<cfargument name="typeid" type="numeric" required="true" />
		<cfargument name="name" type="string" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.messgae = "Atrybut został dodany" />
		<cfset results.id = "" />
		
		<cfset var newAttr = "" />
		
		<cftry>
			
			<cfquery name="newAttr" datasource="#get('loc').datasource.intranet#">
				insert into store_attributes (attribute_name, attribute_type_id)
				values (
					<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />
				);
				
				select LAST_INSERT_ID() as id;
			</cfquery>
			
			<cfset results.id = newAttr.id />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Błąd przy dodawaniu atrybutu: #CFCATCH.Message#" />
			</cfcatch> 
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="createDictionary" output="false" access="public" hint="" returntype="struct">
		<cfargument name="attributeid" type="numeric" required="true" />
		<cfargument name="typeid" type="numeric" required="true" />
		<cfargument name="value" type="string" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Element do słownika został dodany" />
		<cfset results.id = "" />
		
		<cfset var newAttrDict = "" />
		
		<cftry>
			
			<cfquery name="newAttrDict" datasource="#get('loc').datasource.intranet#">
				insert into store_attribute_dictionary (attribute_id, attribute_type_id, dictionary_value)
				values (
					<cfqueryparam value="#arguments.attributeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.value#" cfsqltype="cf_sql_varchar" />
				);
				
				select LAST_INSERT_ID() as id;
			</cfquery>
			
			<cfset results.id = newAttrDict.id />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Błąd przy dodawaniu elementu słownika: #CFCATCH.Message#" />
 			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="listAttributes" output="false" access="public" hint="" returntype="query">
		<cfset var atrybuty = "" />
		<cfquery name="atrybuty" datasource="#get('loc').datasource.intranet#">
			select a.id, a.attribute_name, a.attribute_type_id, b.type_name 
			from store_attributes a
			inner join store_attribute_types b on a.attribute_type_id = b.id;
		</cfquery>
		
		<cfreturn atrybuty />
	</cffunction>
	
	<cffunction name="listTypes" output="false" access="public" hint="">
		<cfset var typy = "" />
		<cfquery name="typy" datasource="#get('loc').datasource.intranet#">
			select id, type_name from store_attribute_types;
		</cfquery>
		
		<cfreturn typy />
	</cffunction>
	
	<cffunction name="getDictionary" output="false" access="public" hint="">
		<cfset var slownik = "" />
		<cfquery name="slownik" datasource="#get('loc').datasource.intranet#">
			select * from store_attribute_dictionary;
		</cfquery>
		
		<cfreturn slownik />
	</cffunction>
	
	<cffunction name="removeObjectAttribute" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var remAttr = "" />
		<cfquery name="remAttr" datasource="#get('loc').datasource.intranet#">
			select object_id, attribute_id into @oid, @aid 
			from store_object_attributes where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
			
			delete from store_object_attributes
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
			
			delete from store_object_instance_values 
			where object_id = @oid and attribute_id = @aid;
		</cfquery>
		
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="removeFormAttribute" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var removeAttr = "" />
		<cfquery name="removeAttr" datasource="#get('loc').datasource.intranet#">
			select form_id, attribute_id into @fid, @aid
			from store_form_attributes where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
			
			delete from store_form_attributes
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
			
			delete from store_form_instance_values
			where form_id = @fid and attribute_id = @aid; 
		</cfquery>
		
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="" returntype="struct">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Atrybut został usunięty" />
		
		<cfset var usunAtrybut = "" />
		<cftry>
			
			<cfquery name="usunAtrybut" datasource="#get('loc').datasource.intranet#">
				delete from store_attributes
				where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="databaase">
				<cfset results.success = false />
				<cfset results.message = "Nie można usunąć atrybutu" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
</cfcomponent>