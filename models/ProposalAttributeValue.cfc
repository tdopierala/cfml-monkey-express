<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset belongsTo("attribute") />
		<cfset belongsTo("proposalType") />
		<cfset belongsTo(name="proposalAttribute",foreignKey="proposaltypeid") />
	
	</cffunction>
	
	<cffunction 
		name="getProposalFields" 
		hint="Wartości pól dla formularza wniosków" 
		description="Funkcja pobiera typy, nazwy i wartości pól dla formularza wniosków">
		
		<cfargument
			name="proposalid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_proposal_fields"
			result="result_proposal_fields"
			datasource="#get('loc').datasource.intranet#">
				
			SELECT 
			    proposalattributevalues.id,
			    proposalattributevalues.proposalid,
			    proposalattributevalues.proposaltypeid,
			    proposalattributevalues.attributeid,
			    proposalattributevalues.proposalattributevaluetext,
			    attributes.attributetypeid,
			    attributes.attributename,
			    attributes.created,
			    attributes.attributerequired,
			    attributes.defaultdate,
			    attributes.ord,
			    attributes.header,
			    attributes.content,
			    attributes.attributelabel,
			    attributes.footer,
			    proposalattributes.id AS proposalAttributeid,
			    proposalattributes.attributeid AS proposalAttributeattributeid,
			    proposalattributes.proposaltypeid AS proposalAttributeproposaltypeid,
			    proposalattributes.proposalid AS proposalAttributeproposalid,
			    proposalattributes.proposalattributevisible,
			    proposalattributes.ord AS proposalAttributeord
			FROM
				proposalattributes inner join proposalattributevalues on 
					proposalattributes.attributeid = proposalattributevalues.attributeid and
					proposalattributes.proposaltypeid = proposalattributevalues.proposaltypeid
					
			   <!---  proposalattributevalues
			        INNER JOIN proposalattributes ON 
							proposalattributevalues.attributeid 	= proposalattributes.attributeid 
						AND proposalattributevalues.proposaltypeid 	= proposalattributes.proposaltypeid--->
					INNER JOIN attributes ON 
							proposalattributevalues.attributeid 	= attributes.id
			WHERE
			    proposalattributevalues.proposalid = <cfqueryparam
														value="#arguments.proposalid#"
														cfsqltype="cf_sql_integer" />
			ORDER BY proposalattributes.ord ASC

		</cfquery>

		<cfreturn query_proposal_fields />
		
	</cffunction>
	
	
	<cffunction 
		name="findAllProposalAttributesValue">
		
		<cfargument
			name="proposalid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_proposal_attributes_value"
			result="result_proposal_attributes_value"
			datasource="#get('loc').datasource.intranet#">
				
			SELECT 
			
				 proposaltypes.proposaltypename as proposaltypename
				,proposalattributevalues.attributeid as attributeid
				,proposalattributevalues.proposalattributevaluetext as proposalattributevaluetext
				,attributes.attributename as attributename
				,attributes.attributetypeid as attributetypeid
				/*
			    proposalattributevalues.id,
			    proposalattributevalues.proposalid,
			    proposalattributevalues.proposaltypeid,			    
			    
			    attributes.created,
			    attributes.attributerequired,
			    attributes.defaultdate,
			    attributes.ord,
			    attributes.header,
			    attributes.content,
			    attributes.attributelabel,
			    attributes.footer,
			    proposalattributes.id AS proposalAttributeid,
			    proposalattributes.attributeid AS proposalAttributeattributeid,
			    proposalattributes.proposaltypeid AS proposalAttributeproposaltypeid,
			    proposalattributes.proposalid AS proposalAttributeproposalid,
			    proposalattributes.proposalattributevisible,
			    proposalattributes.ord AS proposalAttributeord
			    */
			FROM
				proposalattributes 
			
			inner join proposalattributevalues on 
				proposalattributes.attributeid = proposalattributevalues.attributeid and
				proposalattributes.proposaltypeid = proposalattributevalues.proposaltypeid

			INNER JOIN attributes ON 
				proposalattributevalues.attributeid = attributes.id
				
			INNER JOIN proposaltypes ON 
				proposalattributevalues.proposaltypeid = proposaltypes.id
				
			WHERE
			    proposalattributevalues.proposalid = <cfqueryparam
														value="#arguments.proposalid#"
														cfsqltype="cf_sql_integer" />
			ORDER BY proposalattributes.ord ASC

		</cfquery>

		<cfreturn query_proposal_attributes_value />
		
	</cffunction>
	
	<cffunction 
		name="getProposalFieldsByType" 
		hint="Wartości pól dla formularza wniosków" 
		description="Funkcja pobiera typy, nazwy i wartości pól dla formularza wniosków">
		
		<cfargument
			name="typeid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_proposal_fields"
			result="result_proposal_fields"
			datasource="#get('loc').datasource.intranet#">
				
			SELECT 
			    proposalattributes.attributeid as id,
			    proposalattributes.proposalid as proposalid,
			    proposalattributes.proposaltypeid as proposaltypeid,
			    proposalattributes.attributeid as attributeid,
			    '' as proposalattributevaluetext,
			    
			    attributes.attributetypeid,
			    attributes.attributename,
			    attributes.created,
			    attributes.attributerequired,
			    attributes.defaultdate,
			    attributes.ord,
			    attributes.header,
			    attributes.content,
			    attributes.attributelabel as label,
			    attributes.footer,
			    proposalattributes.id AS proposalAttributeid,
			    proposalattributes.attributeid AS proposalAttributeattributeid,
			    proposalattributes.proposaltypeid AS proposalAttributeproposaltypeid,
			    proposalattributes.proposalid AS proposalAttributeproposalid,
			    proposalattributes.proposalattributevisible,
			    proposalattributes.ord AS proposalAttributeord
			FROM
				proposalattributes 
													
				INNER JOIN attributes ON 
					proposalattributes.attributeid 	= attributes.id
			WHERE
			    proposalattributes.proposaltypeid = <cfqueryparam
														value="#arguments.typeid#"
														cfsqltype="cf_sql_integer" />
			ORDER BY proposalattributes.ord ASC

		</cfquery>

		<cfreturn query_proposal_fields />
		
	</cffunction>
</cfcomponent>