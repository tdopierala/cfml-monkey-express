<cfcomponent displayname="Store_object" output="false" extends="Model" hint="">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("store_objects") />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="" returntype="struct">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Obiekt został dodany" />
		<cfset results.id = "" />
		
		<cfset var newObj = "" />
		
		<cftry>
			
			<cfquery name="newObj" datasource="#get('loc').datasource.intranet#">
				insert into store_objects (object_name, user_id, created)
				values (
					<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />
				);
				
				select LAST_INSERT_ID() as id;
			</cfquery>
			
			<cfset results.id = newObj.id />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie można dodać obiektu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="" returntype="struct">
		<cfargument name="objectid" type="numeric" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Obiekt został usunięty" />
		
		<cfset var usunietyObiekt = "" />
		<cftry>
			
			<cfquery name="usunietyObiekt" datasource="#get('loc').datasource.intranet#">
				delete from store_objects 
				where id = <cfqueryparam value="#arguments.objectid#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="datasource">
				<cfset results.success = false />
				<cfset results.message = "Błąd przy usuwaniu obiektu: #CFCATCH.Message#" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="listObjects" output="false" access="public" hint="" >
		<cfset var obiekty = "" />
		<cfquery name="obiekty" datasource="#get('loc').datasource.intranet#">
			select 
				a.id, a.object_name, 
				(select count(*) from store_object_attributes b where a.id = b.object_id ) as attributes_number
			from store_objects a;
		</cfquery>
		
		<cfreturn obiekty />
	</cffunction>
	
	<cffunction name="createObjectAttribute" output="false" access="public" hint="">
		<cfargument name="objectid" type="numeric" required="true" />
		<cfargument name="attributeid" type="numeric" required="true" />
		<cfargument name="typeid" type="numeric" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Atrybut został przypisany do obiektu" />
		<cfset results.id = "" />
		
		<cfset var newObjAttr = "" />
		<cftry>
			
			<cfquery name="newObjAttr" datasource="#get('loc').datasource.intranet#">
				insert into store_object_attributes (object_id, attribute_id, attribute_type_id)
				values (
					<cfqueryparam value="#arguments.objectid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.attributeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie mogę dodać atrybutu do obiektu: #CFCATCH.Message#" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="storesSummary" output="false" access="public" hint="">
		<cfargument name="page" type="numeric" required="true" />
		<cfargument name="elements" type="numeric" required="true" />
		
		<cfset var obiekty = "" />
		<cfquery name="obiekty" datasource="#get('loc').datasource.intranet#">
			select a.id as store_id, a.projekt, a.miasto, a.ulica, a.ajent, a.nazwaajenta,
				(select count(id) from store_object_instances c where c.store_id = a.id) as objectsnumber
			from store_stores a
			where a.is_active = 1
			order by a.projekt asc
		</cfquery>
		
		<cfreturn obiekty />
	</cffunction>
	
	<cffunction name="storesSummaryByObject" output="false" access="public" hint="">
		<cfargument name="objectid" type="numeric" required="true" />
		
		<cfset var obiekty = "" />
		<cfquery name="obiekty" datasource="#get('loc').datasource.intranet#">
			select distinct b.id as store_id, b.projekt, b.miasto, b.ulica, b.ajent, b.nazwaajenta,
				(select count(id) from store_object_instances c where c.store_id = a.store_id) as objectsnumber 
			from store_object_instances a
			inner join store_stores b on (a.store_id = b.id and b.is_active = 1)
			where a.object_id = <cfqueryparam value="#arguments.objectid#" cfsqltype="cf_sql_integer" />
			order by b.projekt asc
		</cfquery>
		
		<cfreturn obiekty />
	</cffunction>
	
	<cffunction name="listStores" output="false" access="public" hint="">
		<cfargument name="page" type="numeric" required="false" />
		<cfargument name="elements" type="numeric" required="false" />
		<cfargument name="text" type="string" required="false"/>
		
		<cfset var sklepy = "" />
		<cfquery name="sklepy" datasource="#get('loc').datasource.intranet#">
			select a.projekt, a.id, a.adressklepu, a.nazwaajenta, a.miasto, a.ulica
			from store_stores a
			where a.is_active = 1
			
			<cfif IsDefined("arguments.text")>
				and ( a.nazwaajenta like <cfqueryparam value="%#arguments.text#%" cfsqltype="cf_sql_varchar" />
					or a.adressklepu like <cfqueryparam value="%#arguments.text#%" cfsqltype="cf_sql_varchar" />
					or a.projekt like <cfqueryparam value="%#arguments.text#%" cfsqltype="cf_sql_varchar" />
				
			</cfif>
			
		</cfquery>
		
		<cfreturn sklepy />
	</cffunction>
	
	<cffunction name="listObjectAttributes" output="false" access="public" hint="">
		<cfargument name="objectid" type="numeric" required="true" />
		
		<cfset var obiekt = "" />
		<cfquery name="obiekt" datasource="#get('loc').datasource.intranet#">
			select a.id as object_id, a.object_name, c.attribute_name, d.type_name, b.attribute_id, 
				b.attribute_type_id, b.id as object_attribute_id
			from store_objects a
			inner join store_object_attributes b on a.id = b.object_id
			inner join store_attributes c on b.attribute_id = c.id
			inner join store_attribute_types d on c.attribute_type_id = d.id
			where a.id = <cfqueryparam value="#arguments.objectid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn obiekt />
	</cffunction>
	
	<cffunction name="getObjectDostionary" output="false" access="public" hint="">
		<cfargument name="attributeid" type="numeric" required="true" />
		
		<cfset var slownik = "" />
		<cfquery name="slownik" datasource="#get('loc').datasource.intranet#">
			select * from store_attribute_dictionary
			where attribute_id = <cfqueryparam value="#arguments.attributeid#" />
		</cfquery>
		
		<cfreturn slownik />
	</cffunction>
	
	<cffunction name="storeObjects" output="false" access="public" hint="" returntype="query">
		<cfargument name="storeid" type="numeric" required="true" />
		<cfargument name="project" type="string" required="true" />
		
		<cfset var obiekty = "" />
		<cfquery name="obiekty" datasource="#get('loc').datasource.intranet#">
			select a.object_id, a.store_id, b.object_name, count(a.object_id) as object_count 
			from store_object_instances a
			inner join store_objects b on a.object_id = b.id
			where a.store_project = <cfqueryparam value="#arguments.project#" cfsqltype="cf_sql_varchar" />
			group by a.object_id
		</cfquery>
		
		<cfreturn obiekty />
	</cffunction>
	
	<cffunction name="storeObjectsDetails" output="false" access="public" hint="" returntype="struct">
		<cfargument name="storeid" type="numeric" required="true" />
		<cfargument name="objectid" type="numeric" required="true" />
		
		<cfset var objects = "" />
		<cfquery name="objects" datasource="#get('loc').datasource.intranet#">
			select distinct a.object_id, b.object_name, a.id as id
			from store_object_instances a
			inner join store_objects b on a.object_id = b.id
			where a.store_id = <cfqueryparam value="#arguments.storeid#" cfsqltype="cf_sql_integer" />
				and a.object_id = <cfqueryparam value="#arguments.objectid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfset var structObiekty = structNew() />
		<cfset var objectAttributes = "" />
		<cfloop query="objects">
			<cfset structObiekty["#objects.id#"] = structNew() />
			<cfset structObiekty["#objects.id#"]["OBJECT_NAME"] = object_name />
			
			<cfquery name="objectAttributes" datasource="#get('loc').datasource.intranet#">
				select a.value_text, b.attribute_name
				from store_object_instance_values a
				inner join store_attributes b on a.attribute_id = b.id
				where a.object_id = <cfqueryparam value="#objects.object_id#" cfsqltype="cf_sql_integer" />
					and a.object_instance_id = <cfqueryparam value="#objects.id#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfset structObiekty["#objects.id#"]["ATTRIBUTES"] = objectAttributes />
		</cfloop>
		
		<cfreturn structObiekty />
	</cffunction>
	
	<cffunction name="addAttribute" output="false" access="public" hint="">
		<cfargument name="objectid" type="numeric" required="true" />
		<cfargument name="attributeid" type="numeric" required="true" />
		<cfargument name="typeid" type="numeric" required="true" />
		
		<cfset var newAttr = "" />
		<cfquery name="newAttr" datasource="#get('loc').datasource.intranet#">
			insert into store_object_attributes (object_id, attribute_id, attribute_type_id)
			values (
				<cfqueryparam value="#arguments.objectid#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.attributeid#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />
			);
		</cfquery>
		
		<cfset var instances = "" />
		<cfquery name="instances" datasource="#get('loc').datasource.intranet#">
			select id from store_object_instances
			where object_id = <cfqueryparam value="#arguments.objectid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfloop query="instances">
			<cfset var newAttrVal = "" />
			<cfquery name="newAttrVal" datasource="#get('loc').datasource.intranet#">
				insert into store_object_instance_values (object_id, attribute_id, attribute_type_id, object_instance_id)
				values (
					<cfqueryparam value="#arguments.objectid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.attributeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#instances.id#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
		</cfloop>
		
		<cfreturn "" />
	</cffunction>
	
</cfcomponent>