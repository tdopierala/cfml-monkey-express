<cfcomponent displayname="object_attr_typeDAO" output="false" hint="">
	<cffunction name="init" output="false" access="public" hint="">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" returntype="struct" hint="">
		<cfargument name="element" type="object_attr_type" required="true" />
		
		<cfset var insertElement = "" />
		<cfset var result = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Typ został prawidłowo dodany" />
		
		<cftry>
			
			<cfquery name="insertElement" result="result" datasource="#variables.dsn#">
				insert into object_attr_types (attr_type_name, attr_type_create, attr_type_userid)
				values (
					<cfqueryparam value="#arguments.element.getTypeName()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.element.getTypeCreate()#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#arguments.element.getUserId()#" cfsqltype="cf_sql_integer" />  
				);
			</cfquery>
			<cfset arguments.element.setId(result.generatedKey) />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie można dodać typu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results /> 
	</cffunction>
	
	<cffunction name="read" output="false" access="public" hint="" returntype="void">
		<cfargument name="element" type="object_attr_type" required="true" />
		
		<cfset var readElement = "" />
		<cfquery name="readElement" datasource="#variables.dsn#">
			select * from object_attr_types
			where id = <cfqueryparam value="#arguments.element.getId()#" cfsqltype="cf_sql_integer" />; 
		</cfquery>
		
		<cfif readElement.RecordCount EQ 1>
			<cfset arguments.element.init(
				id = readElement.id,
				typename = readElement.attr_type_name,
				typecreate = readElement.attr_type_create,
				userid = readElement.attr_type_userid) />
		</cfif>
	</cffunction>
	
	<cffunction name="update" output="false" access="public" hint="" returntype="struct">
		<cfargument name="element" type="object_attr_type" required="true" />
		
		<cfset var updateElement = "" />
		<cfset var results = structNew() />
		<cfset results.success = "true" />
		<cfset results.message = "Typ został zapisany prawidłowo." />
		
		<cftry>
			<cfquery name="updateElement" datasource="#variables.dsn#">
				update object_attr_type set
					attr_type_name = <cfqueryparam value="#arguments.element.getTypeName()#" cfsqltype="cf_sql_varchar" />,
					attr_type_create = <cfqueryparam value="#arguments.element.getTypeCreate()#" cfsqltype="cf_sql_timestamp" />,
					attr_type_userid = <cfqueryparam value="#arguments.element.getUserId()#" cfsqltype="cf_sql_integer" />
				where id = <cfqueryparam value="#arguments.element.getId()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie mogę zapisać typu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="" returntype="struct">
		<cfargument name="element" type="object_attr_type" required="true" />
		
		<cfset var deleteElement = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Typ został usunięty prawidłowo" />
		
		<cftry>
			
			<cfquery name="deleteElement" datasource="#variables.dsn#">
				delete from object_attr_types
				where id = <cfqueryparam value="#arguments.element.getId()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Błąd przy usuwaniu typu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>