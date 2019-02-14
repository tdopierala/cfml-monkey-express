<cfcomponent 
	extends="Model">
	
	<cffunction 
		name="init">
			
			<cfset table("concession_concessions_old") />
	</cffunction>
	
	<!---<cffunction 
		name="insert">
			
		<cfargument
			name="storeid"
			type="numeric"
			required="true" />
			
		<cfargument
			name="concessionproposalid"
			type="numeric"
			required="true" />
			
		<cfargument
			name="userid"
			type="numeric"
			required="true" />
		
	</cffunction>--->
	
	<cffunction 
		name="findAllConcessions">
			
		<cfquery
			name="query_concession"
			result="result_concession"
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
			INNER JOIN concession_steps_old cs ON cs.id = cp.step
			
			WHERE
				cp.type = 2 
				
			ORDER BY cp.created DESC

		</cfquery>

		<cfreturn query_concession />
			
	</cffunction> 
	
</cfcomponent>