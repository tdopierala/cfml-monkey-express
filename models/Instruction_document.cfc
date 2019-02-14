<cfcomponent
	extends="Model">

	<cffunction 
		name="init">
	
		<cfset table("instruction_documents") />
		
	</cffunction>
	
	<cffunction name="getUserInstructions">
		
		<cfargument
			name="documenttypeid"
			type="numeric" 
			default="0"
			required="false" />
			
		<cfargument
			name="statusid"
			type="numeric"
			default="0"
			required="false" />
			
		<cfargument
			name="userid"
			type="numeric"
			default="0"
			required="false" />
			
		<cfargument
			name="where_condition"
			type="string"
			default="1=1"
			required="false" />
			
		<cfargument
			name="limit"
			type="numeric"
			default="0"
			required="false" />
		
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_instruction_get_all_instructions"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.documenttypeid#"
				dbVarName="@documenttype_id" />
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.statusid#"
				dbVarName="@status_id" />
				
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.userid#"
				dbVarName="@user_id" />
				
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR" 
				value="#arguments.where_condition#"
				dbVarName="@where_condition" />
				
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER" 
				value="#arguments.limit#"
				dbVarName="@_limit" />
					
			<cfprocresult name="documents" resultSet="1" />
		
		</cfstoredproc>
		 
		<cfreturn documents />
		
	</cffunction>
	
	<cffunction
		name="getInstructions"
		output="false">
	
		<cfargument
			name="limit"
			type="string" 
			default=""
			required="false" />
		
		<cfargument
			name="where"
			type="string"
			default="1=1"
			required="false" />
			
		<cfstoredproc 
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_instruction_get_instructions"
			returnCode="No">
			
			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR" 
				value="#arguments.where#"
				dbVarName="@where_condition" />
			
			<cfprocparam
				type="in"
				cfsqltype="CF_SQL_VARCHAR"
				value="#arguments.limit#"
				dbVarName="@limit_condition" />	
					
			<cfprocresult name="documents" resultSet="1" />
		
		</cfstoredproc>
		
		<cfreturn documents />
	
	</cffunction>
	
	<cffunction name="getInstructionByKey" output="false" access="public" hint="" >
		<cfargument name="k" type="numeric" required="true" />
		<cfargument name="fields" type="string" default="*" />
		
		<cfset var getInstructionDocument = "" />
		<cfquery name="getInstructionDocument" datasource="#get('loc').datasource.intranet#">
			select #arguments.fields# from instruction_documents where id = <cfqueryparam value="#arguments.k#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		 
		 <cfreturn getInstructionDocument />
		 
	</cffunction>
	
	<cffunction name="getAllInstructionDocuments" output="false" access="public" hint="">
		<cfset var qDoc = "" />
		<cfquery name="qDoc" datasource="#get('loc').datasource.intranet#">
			select id, filesrc from instruction_documents where 1=1;
		</cfquery>
		
		<cfreturn qDoc />
	</cffunction>
	
	<cffunction name="updateOcr" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="str" type="string" required="true" />
		
		<cfset var qUpdt = "" />
		<cfquery name="qUpdt" datasource="#get('loc').datasource.intranet#">
			update instruction_documents 
			set ocr = <cfqueryparam value="#arguments.str#" cfsqltype="cf_sql_longvarchar" />
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn true />
	</cffunction>
</cfcomponent>