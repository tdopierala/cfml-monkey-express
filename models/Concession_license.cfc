<cfcomponent 
	extends="Model">
	
	<cffunction 
		name="init">
			
	</cffunction>
	
	<cffunction 
		name="findLicenses">
		
		<cfargument name="where" type="string" required="true" />
		
		<cfargument name="amount" type="numeric" required="true" />
			
		<cfargument name="page" type="numeric" required="true" />
		
		<cfargument name="order" type="string" required="true" />
		
		<cfargument name="orderby" type="string" required="true" />
		
		<cfset limit = (arguments.page-1) * arguments.amount />
			
		<cfquery
			name="query_concession"
			result="result_concession"
			datasource="#get('loc').datasource.intranet#">
							
			SELECT 
			     cl.id AS id
			    ,cl.createdate AS createdate
			    ,cl.datefrom
			    ,cl.dateto
			    ,cl.dateofissue
			    ,cl.documentnr
			    ,ct.nameshort AS type
			    
			    ,ss.projekt
			    ,ss.ajent
			    
			FROM concession_licenses AS cl 
			
			<!---INNER JOIN concession_concessions cc ON cc.id = cl.concessionid --->
			INNER JOIN concession_types ct ON ct.id = cl.typeid					
			INNER JOIN store_stores ss ON ss.id = cl.storeid
			
			WHERE #arguments.where#
				
			ORDER BY 
				#arguments.orderby#
				#arguments.order#
				
			LIMIT #limit#, #arguments.amount#
				

		</cfquery>

		<cfreturn query_concession />
	</cffunction>
	
</cfcomponent>