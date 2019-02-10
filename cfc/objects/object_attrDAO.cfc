<cfcomponent displayname="object_attrDAO" output="false" hint="">

	<cffunction name="init" output="false" access="public" returntype="object_attrDAO" hint="">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" output="false" acces="public" returntype="struct" hint="">
		<cfargument name="attr" type="object_attr" required="true" />
		
		<cfset var createAttr = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Atrybut został zapisany" />
		
		<cftry>
			<cfquery name="createAttr" result="result" datasource="#variables.dsn#">
				insert into object_attr (attr_name, attr_userid, attr_create, attr_type_id)
				values (
					<cfqueryparam value="#arguments.attr.getName()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.attr.getUserId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.attr.getCreate()#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#arguments.attr.getTypeId()#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
			<cfset arguments.attr.setId(result.generatedKey) />
			
			<cfcatch type="datasource">
				<cfset results.success = false />
				<cfset results.message = "Wystąpił błąd przy dodawaniu atrybutu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="update" output="false" access="public" hint="" returntype="struct">
		<cfargument name="attr" type="object_attr" required="true" />
		
		<cfset var updateAttr = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Atrybut został zaktualizowany prawidłowo" />
		
		<cftry>
			
			<cfquery name="updateAttr" datasource="#variables.dsn#">
				update object_attr set
					attr_name = <cfqueryparam value="#arguments.attr.getName()#" cfsqltype="cf_sql_varchar" />,
					attr_userid = <cfqueryparam value="#arguments.attr.getUserId()#" cfsqltype="cf_sql_integer" />,
					attr_create = <cfqueryparam value="#arguments.attr.getCreate()#" cfsqltype="cf_sql_timestamp" />,
					attr_type_id = <cfqueryparam value="#arguments.attr.getTypeId()#" cfsqltype="cf_sql_integer" />
				where id = <cfqueryparam value="#arguments.attr.getId()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Błąd przy aktualizacji atrybutu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="read" output="false" access="public" returntype="void" hint="">
		<cfargument name="attr" type="object_attr" required="true" />
		
		<cfset var getAttr = "" />
		<cfquery name="getAttr" datasource="#variables.dsn#">
			select * from object_attr
			where id = <cfqueryparam value="#arguments.attr.getId()#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfif getAttr.RecordCount EQ 1>
			<cfset arguments.attr.init(
				id = getAttr.id,
				name = getAttr.attr_name,
				userid = getAttr.attr_userid,
				create = getAttr.attr_create,
				typeid = getAttr.attr_type_id) />
		</cfif>
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" returntype="struct" hint="">
		<cfargument name="attr" type="object_attr" required="true" />
		
		<cfset var delAttr = "" />
		<cfset results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Atrybut został usunięty prawidłowo" />
		
		<cftry>
			
			<cfquery name="delAttr" datasource="#variables.dsn#">
				delete from object_attr
				where id = <cfqueryparam value="#arguments.attr.getId()#" cfsqltype="cf_sql_integer" />;
			</cfquery>
			
			<cfcatch type="datasource">
				<cfset results.success = false />
				<cfset results.message = "Wystąpił błąd przy usuwaniu atrybutu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
</cfcomponent>