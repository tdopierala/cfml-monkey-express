<cfcomponent 
	extends="Model">
		
	<cffunction 
		name="init">
		
		<cfset table("concession_proposals_old") />
		<cfset belongsTo(name="user", foreignKey="userid") />
		<cfset belongsTo(name="concession_stepname", foreignKey="step") />
	</cffunction>
	
	<cffunction 
		name="findAllProposals">
			
		<cfquery
			name="query_concession_proposals"
			result="result_concession_proposals"
			datasource="#get('loc').datasource.intranet#">
							
			SELECT 
			    
			    cp.id AS id
			    ,cp.type AS type
			    ,cp.status AS status
			    ,cs.stepname AS step
			    ,cp.userid AS userid
			    ,CONCAT(IF(u.givenname IS NULL,'',u.givenname)," ",IF(u.sn IS NULL,'',u.sn)) AS givenname
			    ,cp.created AS createddate
			    ,ss.projekt AS store
			    
			FROM concession_proposals_old AS cp 
			
			INNER JOIN users u ON u.id = cp.userid 					
			INNER JOIN store_stores ss ON ss.ajent = u.logo
			INNER JOIN concession_stepnames_old cs ON cs.id = cp.step
			
			WHERE
				cp.type = 2 
				
			ORDER BY cp.created DESC

		</cfquery>

		<cfreturn query_concession_proposals />
			
	</cffunction>
	
	<cffunction 
		name="findUserProposals">
		
		<cfargument
			name="userid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_concession_proposals"
			result="result_concession_proposals"
			datasource="#get('loc').datasource.intranet#">
				
			SELECT 
			    
			    cp.id AS id
			    ,cp.type AS type
			    ,cp.status AS status
			    ,cs.stepname AS step
			    ,cp.userid AS userid
			    ,CONCAT(IF(u.givenname IS NULL,'',u.givenname)," ",IF(u.sn IS NULL,'',u.sn)) AS givenname
			    ,cp.created AS createddate
			    ,ss.projekt AS store
			    
			FROM concession_proposals_old AS cp 
			
			INNER JOIN users u ON u.id = cp.userid 					
			INNER JOIN store_stores ss ON ss.ajent = u.logo
			INNER JOIN concession_stepnames_old cs ON cs.id = cp.step
			
			WHERE
				cp.type = 2 
				AND 
				cp.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> 
				
			ORDER BY cp.created DESC

		</cfquery>

		<cfreturn query_concession_proposals />
			
	</cffunction>
	
	<cffunction 
		name="findProposalsByKos">
		
		<cfargument
			name="userid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_concession_kos_proposals"
			result="result_concession_kos_proposals"
			datasource="#get('loc').datasource.intranet#">
				
			SELECT 
			    
			    cp.id AS id
			    ,cp.type AS type
			    ,cp.status AS status
			    ,cs.stepname AS step
			    ,cp.userid AS userid
			    ,CONCAT(IF(u.givenname IS NULL,'',u.givenname)," ",IF(u.sn IS NULL,'',u.sn)) AS givenname
			    ,cp.created AS createddate
			    ,ss.projekt AS store
			    
			FROM concession_proposals_old AS cp 
			
			INNER JOIN users u ON u.id = cp.userid 					
			INNER JOIN store_stores ss ON ss.ajent = u.logo
			INNER JOIN concession_stepnames_old cs ON cs.id = cp.step
			
			WHERE
				cp.type = 2 
				AND ss.partnerid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				AND cp.step >= 2
				
			ORDER BY cp.created DESC

		</cfquery>

		<cfreturn query_concession_kos_proposals />
			
	</cffunction>
	
	<cffunction 
		name="storeByProposal">
			
		<cfargument
			name="proposalid"
			type="numeric"
			required="true" />
			
		<cfquery
			name="query_store_by_proposal"
			result="result_store_by_proposal"
			datasource="#get('loc').datasource.intranet#">
				
			SELECT			    
			    cp.userid AS userid
			    ,CONCAT(IF(u.givenname IS NULL,'',u.givenname)," ",IF(u.sn IS NULL,'',u.sn)) AS givenname
			    ,ss.projekt AS storeid
			    
			FROM concession_proposals_old AS cp 
			
			INNER JOIN users u ON u.id = cp.userid 					
			INNER JOIN store_stores ss ON ss.ajent = u.logo
			
			WHERE 
				cp.id = <cfqueryparam value="#arguments.proposalid#" cfsqltype="cf_sql_integer" /> 

		</cfquery>

		<cfreturn query_store_by_proposal />
			
	</cffunction>
	
</cfcomponent>