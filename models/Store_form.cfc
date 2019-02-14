<cfcomponent displayname="Store_form" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("store_forms") />
	</cffunction>
	
	<cffunction name="listForms" output="false" access="public" hint="">
		<cfset var formularze = "" />
		<cfquery name="formularze" datasource="#get('loc').datasource.intranet#">
			select 
				a.id, a.form_name, 
				(select count(*) from store_form_attributes b where a.id = b.form_id ) as attributes_number
			from store_forms a;
		</cfquery>
		
		<cfreturn formularze />
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
	
	<cffunction name="create" output="false" access="public" hint="" returntype="struct">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Stworzyłem nową definicję formularza" />
		<cfset results.id = "" />
		
		<cfset var newForm = "" />
		<cftry>
			
			<cfquery name="newForm" datasource="#get('loc').datasource.intranet#">
				insert into store_forms (form_name, user_id, created) 
				values (
					<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />  	
				);
				select LAST_INSERT_ID() as id;
			</cfquery>
			
			<cfset results.id = newForm.id />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie mogę stworzyć definicji formularza: #CFCATCH.Message#" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="createFormAttribute" output="false" access="public" hint="" returntype="struct">
		<cfargument name="formid" type="numeric" required="true" />
		<cfargument name="attributeid" type="numeric" required="true" />
		<cfargument name="typeid" type="numeric" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodałem atrybut do formularza" />
		<cfset results.id = "" />
		
		<cfset var newFrmAttr = "" />
		<cftry>
			
			<cfquery name="newFrmAttr" datasource="#get('loc').datasource.intranet#">
				insert into store_form_attributes (form_id, attribute_id, attribute_type_id)
				values (
					<cfqueryparam value="#arguments.formid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.attributeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />
				);
				select LAST_INSERT_ID() as id;
			</cfquery>
			
			<cfset results.id = newFrmAttr.id />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie mogę dodać atrybutu do formularza" />
			</cfcatch>
			
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="" returntype="struct">
		<cfargument name="formid" type="numeric" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Usunąłem formularz" />
		
		<cfset var usunFormularz = "" />
		<cfset var result = "" />
		<cftry>
			
			<cfquery name="usunFormularz" datasource="#get('loc').datasource.intranet#">
				delete from store_forms 
				where id = <cfqueryparam value="#arguments.formid#" cfsqltype="cf_sql_integer" />;
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie mogę usunąć formularza: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="listFormAttributes" output="false" access="public" hint="">
		<cfargument name="formid" type="numeric" required="true" />
		
		<cfset var formularz = "" />
		<cfquery name="formularz" datasource="#get('loc').datasource.intranet#">
			select a.id as form_id, a.form_name, c.attribute_name, d.type_name, b.attribute_id, 
				b.attribute_type_id, b.id as form_attribute_id
			from store_forms a
			inner join store_form_attributes b on a.id = b.form_id
			inner join store_attributes c on b.attribute_id = c.id
			inner join store_attribute_types d on c.attribute_type_id = d.id
			where a.id = <cfqueryparam value="#arguments.formid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn formularz />
	</cffunction>
	
	<cffunction name="addAttribute" output="false" access="public" hint="">
		<cfargument name="formid" type="numeric" required="true" />
		<cfargument name="attributeid" type="numeric" required="true" />
		<cfargument name="typeid" type="numeric" required="true" />
		
		<cfset var newAttr = "" />
		<cfquery name="newAttr" datasource="#get('loc').datasource.intranet#">
			insert into store_form_attributes (form_id, attribute_id, attribute_type_id)
			values (
				<cfqueryparam value="#arguments.formid#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.attributeid#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />
			);
			select LAST_INSERT_ID() as id;
		</cfquery>
		
		<cfset var lastAttr = "" />
		<cfquery name="lastAttr" datasource="#get('loc').datasource.intranet#" >
			select a.id as form_id, a.form_name, c.attribute_name, d.type_name, b.attribute_id, 
				b.attribute_type_id, b.id as form_attribute_id
			from store_forms a
			inner join store_form_attributes b on a.id = b.form_id
			inner join store_attributes c on b.attribute_id = c.id
			inner join store_attribute_types d on c.attribute_type_id = d.id
			where a.id = <cfqueryparam value="#arguments.formid#" cfsqltype="cf_sql_integer" />
				and b.id = <cfqueryparam value="#newAttr.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfset var instances = "" />
		<cfquery name="instances" datasource="#get('loc').datasource.intranet#">
			select id from store_form_instances
			where form_id = <cfqueryparam value="#arguments.formid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfloop query="instances">
			<cfset var newAttrVal = "" />
			<cfquery name="newAttrVal" datasource="#get('loc').datasource.intranet#">
				insert into store_form_instance_values (form_id, attribute_id, attribute_type_id, form_instance_id)
				values (
					<cfqueryparam value="#arguments.formid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.attributeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#instances.id#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
		</cfloop>
		
		<cfreturn lastAttr />
	</cffunction>
	
	<cffunction name="storesForms" output="false" access="public" hint="">
		<cfargument name="page" type="numeric" required="true" />
		<cfargument name="elements" type="numeric" required="true" />
		<cfargument name="search" type="string" required="true" />
		
		<cfset var formularze = "" />
		<cfset var projekty = "" />
		
		<cfquery name="formularze" datasource="#get('loc').datasource.intranet#" cachedwithin="#createTimespan(
			Application.cache.query.days,
			Application.cache.query.hours,
			Application.cache.query.minutes,
			Application.cache.query.seconds)#">
			
			select a.id as store_id, a.projekt, a.miasto, a.ulica, a.ajent, a.nazwaajenta,
				(select count(id) from store_form_instances c where Right(c.project, 5) = Right(a.projekt, 5)) as formsnumber
			from store_stores a
			where a.is_active = 1
			
			<cfif Len(arguments.search)>
				and 
				(
					a.projekt like <cfqueryparam value="%#Trim(arguments.search)#%" cfsqltype="cf_sql_varchar" />
					or a.miasto like <cfqueryparam value="%#Trim(arguments.search)#%" cfsqltype="cf_sql_varchar" />
					or a.ulica like <cfqueryparam value="%#Trim(arguments.search)#%" cfsqltype="cf_sql_varchar" />
					or a.ajent like <cfqueryparam value="%#Trim(arguments.search)#%" cfsqltype="cf_sql_varchar" />
				
					or a.projekt in 
					(
						select x.project from store_form_instances x
						inner join store_form_instance_values y on x.id = y.form_instance_id
						where y.value_text like <cfqueryparam value="%#Trim(arguments.search)#%" cfsqltype="cf_sql_varchar" />
					)
				)
			</cfif>
			
			order by a.projekt asc
		</cfquery>
		
		<cfreturn formularze />
	</cffunction>
	
	<cffunction name="storeForms" output="false" access="public" hint="">
		<cfargument name="storeid" type="numeric" required="true" />
		<cfargument name="projekt" type="string" required="false" />
		
		<cfset var formularze = "" />
		<cfquery name="formularze" datasource="#get('loc').datasource.intranet#">
			select a.form_id, a.store_id, b.form_name, count(a.form_id) as form_count from store_form_instances a
			inner join store_forms b on a.form_id = b.id
			where 1=1
			<cfif IsDefined("arguments.projekt") and Len(arguments.projekt) GT 0>
				and Right(a.project, 5) = <cfqueryparam value="#Right(arguments.projekt, 5)#" cfsqltype="cf_sql_varchar" />
			</cfif>
			<!---where a.project = <cfqueryparam value="#arguments.projekt#" cfsqltype="cf_sql_varchar" />--->
			<!---where a.store_id = <cfqueryparam value="#arguments.storeid#" cfsqltype="cf_sql_integer" />--->
			group by a.form_id
		</cfquery>
		
		<cfreturn formularze />
	</cffunction>
	
	<cffunction name="storeFormDetails" output="false" access="public" hint="" returntype="struct">
		<cfargument name="storeid" type="numeric" required="true" />
		<cfargument name="formid" type="numeric" required="true" />
		<cfargument name="projekt" type="string" required="false" />
		
		<cfset var formularze = "" />
		<cfquery name="formularze" datasource="#get('loc').datasource.intranet#">
			select distinct a.form_id, b.form_name, a.id as id
			from store_form_instances a
			inner join store_forms b on a.form_id = b.id
			where 1=1
				<cfif IsDefined("arguments.projekt") and Len(arguments.projekt) GT 0>
					and Right(a.project, 5) = <cfqueryparam value="#Right(arguments.projekt, 5)#" cfsqltype="cf_sql_varchar" />
				</cfif>
				<!---a.store_id = <cfqueryparam value="#arguments.storeid#" cfsqltype="cf_sql_integer" />--->
				and a.form_id = <cfqueryparam value="#arguments.formid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfset var structFormularze = structNew() />
		<cfset var formAttributes = "" />
		<cfloop query="formularze">
			<cfset structFormularze["#formularze.id#"] = structNew() />
			<cfset structFormularze["#formularze.id#"]["FORM_NAME"] = form_name />
			
			<cfquery name="formAttributes" datasource="#get('loc').datasource.intranet#">
				select a.value_text, b.attribute_name
				from store_form_instance_values a
				inner join store_attributes b on a.attribute_id = b.id
				where a.form_id = <cfqueryparam value="#formularze.form_id#" cfsqltype="cf_sql_integer" />
					and a.form_instance_id = <cfqueryparam value="#formularze.id#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfset structFormularze["#formularze.id#"]["ATTRIBUTES"] = formAttributes />
		</cfloop>
		
		<cfreturn structFormularze />
	</cffunction>
	
</cfcomponent>