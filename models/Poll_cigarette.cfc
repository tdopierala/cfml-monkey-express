<cfcomponent 
	extends="Model">
	
	<cffunction 
		name="init" >
			
		<cfset belongsTo(name="User", modelName="User") />
		
	</cffunction>
	
	<cffunction 
		name="countBySymkar">
			
		<cfquery
			name="query_poll"
			result="result_poll"
			datasource="#get('loc').datasource.intranet#">
							
			SELECT 
			    COUNT(pc.id) AS count,
			    pc.symkar
			    
			FROM poll_cigarettes AS pc 
			
			GROUP BY pc.symkar
				
			ORDER BY count DESC

		</cfquery>

		<cfreturn query_poll />
			
	</cffunction> 
	
</cfcomponent>