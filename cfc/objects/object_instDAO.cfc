<cfcomponent displayname="object_instDAO" output="false" hint="">
	
	<cffunction name="init" output="false" access="public" hint="" returntype="object_instDAO">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this /> 
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="" returntype="struct">
		<cfargument name="element" type="object_inst" required="true" />
		
		<cfset var createElement = "" />
		<cfset var result = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Instancja obiektu została utworzona" />
		
		<cftry>
			<cfquery name="createElement" result="result" datasource="#variables.dsn#">
				insert into object_inst (def_id, inst_userid, inst_create, inst_note, inst_name, parent_id)
				values (
					<cfqueryparam value="#arguments.element.getDefId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.element.getUserId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.element.getCreate()#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#arguments.element.getNote()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.element.getName()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.element.getParentId()#" cfsqltype="cf_sql_varchar" />
				); 
			</cfquery>
			<cfset arguments.element.setId(result.generatedKey) />
			
			<cfcatch type="database">
				
				<cfset results.success = false />
				<cfset results.message = "Nie można utworzyć instancji obiektu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="read" output="false" access="public" hint="" returntype="void">
		<cfargument name="element" type="object_inst" required="true" />
		
		<cfset var getElement = "" />
		<cfquery name="getElement" datasource="#variables.dsn#">
			select * from object_inst
			where id = <cfqueryparam value="#arguments.element.getId()#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfif getElement.RecordCount EQ 1>
			<cfset arguments.element.init(
				id = getElement.id,
				defid = getElement.def_id,
				userid = getElement.inst_userid,
				create = getElement.inst_create,
				note = getElement.inst_note,
				parentid = getElement.parent_id,
				name = getElement.inst_name
			) />
		</cfif>
	</cffunction>
	
	<cffunction name="update" output="false" access="public" hint="" returntype="struct">
		<cfargument name="element" type="object_inst" required="true" />
		
		<cfset var updateElement = "" />
		<cfset var results = "" />
		<cfset results.success = false />
		<cfset results.message = "Instancja została zaktualizowana" />
		
		<cftry>
			<cfquery name="updateElement" datasource="#variables.dsn#">
				update object_inst set
					def_id = <cfqueryparam value="#arguments.element.getDefId()#" cfsqltype="cf_sql_integer" />,
					inst_userid = <cfqueryparam value="#arguments.element.getUserId()#" cfsqltype="cf_sql_integer" />,
					inst_create = <cfqueryparam value="#arguments.element.getCreate()#" cfsqltype="cf_sql_timestamp" />,
					inst_note = <cfqueryparam value="#arguments.element.getNote()#" cfsqltype="cf_sql_varchar" />,
					parent_id = <cfqueryparam value="#arguments.element.getParentId()#" cfsqltype="cf_sql_varchar" />,
					inst_name = <cfqueryparam value="#arguments.element.getName()#" cfsqltype="cf_sql_varchar" />
				where id = <cfqueryparam value="#arguments.element.getId()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie można zaktualizować instancji: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="" returntype="struct">
		<cfargument name="element" type="object_inst" required="true" />
		
		<cfset var delElement = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Instancja obiektu została usunięta" />
		
		<cftry>
			<cfquery name="delElement" datasource="#variables.dsn#">
				delete from object_inst
				where id = <cfqueryparam value="#arguments.element.getId()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie można usunąć instancji obiektu" />
			</cfcatch>
		</cftry>
		<cfreturn results />
		
	</cffunction>
	
</cfcomponent>