<cfcomponent 
	extends="Model">
		
	<cffunction 
		name="init">
			
		<cfset table("concession_attributevalues_old") />
			
	</cffunction>
	
	<cffunction 
		name="getFormFields" 
		hint="Typy pól dla formularza">
		
		<cfargument
			name="documentid"
			type="numeric"
			required="true" />
			
		<cfargument
			name="documenttype"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_form_fields"
			result="result_form_fields"
			datasource="#get('loc').datasource.intranet#">
				
			SELECT 
			    cav.id AS id,
			    cav.attributeid,
			    cav.attributevalue AS value,
			    ca.attributeid,
			    ca.documenttype AS document,
			    ca.attributetype,
			    ca.attributevisible AS visible,
			    a.attributetypeid,
			    a.attributename AS name,
			    a.created,
			    a.attributerequired AS required,
			    a.defaultdate,
			    a.attributelabel AS label
			
			FROM concession_attributevalues_old AS cav 
			
			INNER JOIN concession_attributes_old ca ON ca.id = cav.attributeid 					
			INNER JOIN attributes a ON a.id = ca.attributeid
			
			WHERE
			    cav.documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />
				AND
				cav.documenttype = <cfqueryparam value="#arguments.documenttype#" cfsqltype="cf_sql_integer" />
				
			ORDER BY ca.ord ASC

		</cfquery>

		<cfreturn query_form_fields />
		
	</cffunction>
</cfcomponent>