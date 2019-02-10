<cfcomponent displayname="object_def_attrDAO" output="false" hint="">
	
	<cffunction name="init" output="false" access="public" hint="" returntype="object_def_attrDAO">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="" returntype="struct">
		<cfargument name="element" type="object_def_attr" required="true" />
		
		<cfset var createElement = "" />
		<cfset var result = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Atrybut został przypisany do definicji obiektu" />
		
		<cftry>
			<cfquery name="createElement" result="result" datasource="#variables.dsn#">
				insert into object_def_attr (def_id, attr_id, def_attr_userid, def_attr_create)
				values (
					<cfqueryparam value="#arguments.element.getDefId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.element.getAttrId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.element.getUserId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.element.getCreate()#" cfsqltype="cf_sql_timestamp" />
				);
			</cfquery>
			<cfset arguments.element.setId(result.generatedKey) />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie można przypisać atrybutu do definicji: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="read" output="false" access="public" hint="" returntype="void">
		<cfargument name="element" type="object_def_attr" required="true" />
		
		<cfset var getElement = "" />
		<cfquery name="getElement" datasource="#variables.dsn#">
			select * from object_def_attr 
			where id = <cfqueryparam value="#argument.element.getId()#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfif getElement.RecordCount EQ 1>
			<cfset arguments.element.init(
				id = getElement.id,
				defid = getElement.def_id,
				attrid = getElement.attr_id,
				userid = getElement.def_attr_userid,
				create = getElement.def_attr_create 
			) />
		</cfif>
	</cffunction>
	
	<cffunction name="update" output="false" access="public" hint="" returntype="struct">
		<cfargument name="element" type="object_def_attr" required="true" />
		
		<cfset var updateElement = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Atrybut definizji został zaktualizowany" />
		
		<cftry>
			<cfquery name="updateElement" datasource="#variables.dsn#">
				update object_def_attr set
					def_id = <cfqueryparam value="#arguments.element.getDefId()#" cfsqltype="cf_sql_integer" />,
					attr_id = <cfqueryparam value="#arguments.element.getAttrId()#" cfsqltype="cf_sql_integer" />,
					def_attr_userid = <cfqueryparam value="#arguments.element.getUserId()#" cfsqltype="cf_sql_integer" />,
					def_attr_create = <cfqueryparam value="#arguments.element.getCreate()#" cfsqltype="cf_sql_timestamp" />
				where id = <cfqueryparam value="#arguments.element.getId()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie można zaktualizować atrybutu definicji" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="" returntype="struct">
		<cfargument name="element" type="object_def_attr" required="true" />
		
		<cfset var deleteElement = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Atrybut definicji został usunięty" />
		
		<cftry>
			<cfquery name="deleteElement" datasource="#variables.dsn#">
				delete from object_def_attr
				where id = <cfqueryparam value="#arguments.element.getId()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie można usunąć atrybutu definicji" />
 			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>