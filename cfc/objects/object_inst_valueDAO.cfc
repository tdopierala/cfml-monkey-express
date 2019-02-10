<cfcomponent displayname="object_inst_valueDAO" output="false" hint="">
	
	<cffunction name="init" output="false" access="public" hint="" returntype="object_inst_valueDAO">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" output="false" access="public" hint="" returntype="struct">
		<cfargument name="element" type="object_inst_value" required="true" />
		
		<cfset var createElement = "" />
		<cfset var result = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Wartość atrybutu obiekto została dodana" />
		
		<cftry>
			<cfquery name="createElement" result="result" datasource="#variables.dsn#">
				insert into object_inst_values (def_id, inst_id, attr_id, def_attr_id, attr_type_id, inst_value_text, inst_value_file)
				values (
					<cfqueryparam value="#arguments.element.getDefId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.element.getInstId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.element.getAttrId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.element.getDefAttrId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.element.getAttrTypeId()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.element.getText()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.element.getFile()#" cfsqltype="cf_sql_varchar" />
				);

				select LAST_INSERT_ID() as id;
			</cfquery>
			<cfset arguments.element.setId(createElement.id) />
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie można zapisać wartości atrybutu obiektu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="read" output="false" access="public" hint="" returntype="void">
		<cfargument name="element" type="object_inst_value" required="true" />
		
		<cfset var getElement = "" />
		<cfquery name="getElement" datasource="#variables.dsn#">
			select * from object_inst_values
			where id = <cfqueryparam value="#arguments.element.getId()#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfif getElement.RecordCount EQ 1>
			<cfset arguments.element.init(
				id = getElement.id,
				defid = getElement.def_id,
				instid = getElement.inst_id,
				attrid = getElement.attr_id,
				defattrid = getElement.def_attr_id,
				attrtypeid = getElement.attr_type_id,
				text = getElement.inst_value_text,
				file = getElement.inst_value_file
			) />
		</cfif>
	</cffunction>
	
	<cffunction name="update" output="false" access="public" hint="" returntype="struct">
		<cfargument name="element" type="object_inst_value" required="true" />
		
		<cfset var updateElement = "" />
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Wartość atrybutu obiektu została zaktualizowana" />
		
		<cftry>
			<cfquery name="updateElement" datasource="#variables.dsn#">
				update object_inst_values set
					def_id = <cfqueryparam value="#arguments.element.getDefId()#" cfsqltype="cf_sql_integer" />,
					inst_id = <cfqueryparam value="#arguments.element.getInstId()#" cfsqltype="cf_sql_integer" />,
					attr_id = <cfqueryparam value="#arguments.element.getAttrId()#" cfsqltype="cf_sql_integer" />,
					def_attr_id = <cfqueryparam value="#arguments.element.getDefAttrId()#" cfsqltype="cf_sql_integer" />,
					attr_type_id = <cfqueryparam value="#arguments.element.getAttrTypeId()#" cfsqltype="cf_sql_integer" />,
					inst_value_text = <cfqueryparam value="#arguments.element.getText()#" cfsqltype="cf_sql_varchar" />,
					inst_value_file = <cfqueryparam value="#arguments.element.file()#" cfsqltype="cf_sql_varchar" />
				where id = <cfqueryparam value="#arguments.element.getId()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success= false />
				<cfset results.message = "Nie można zaktualizować wartości atrybutu: #CFCATCH.Message#" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="" returntype="struct">
		<cfargument name="element" type="object_inst_value" required="true" />
		
		<cfset var deleteElement = "" />
		<cfset var results = structNew() />
		<cfset results.success = "true" >/	
		<cfset results.message = "Atrybut instancji obiektu został usunięty">
		
		<cftry>
			<cfquery name="deleteElement" datasource="#variables.dsn#">
				delete from object_instance_values
				where id = <cfqueryparam value="#arguments.element.getId()#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie można usunąć atrybutu instancji obiektu" />
			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
</cfcomponent>