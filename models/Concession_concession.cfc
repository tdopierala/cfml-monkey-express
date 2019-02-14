<cfcomponent 
	extends="Model">
	
	<cffunction 
		name="init">
			
			<cfset table("concession_concessions") />
			<cfset belongsTo(name="Store", modelName="Store_store", foreignKey="storeid") />
			<cfset belongsTo(name="User") />
			
	</cffunction>
	
	<cffunction 
		name="findConcessions">
		
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
			     cc.id AS id
			    ,cc.statusid AS status
			    ,ss.projekt AS projekt
			    ,cc.createdate AS createdate
			    ,CONCAT(IF(u.givenname IS NULL,'',u.givenname)," ",IF(u.sn IS NULL,'',u.sn)) AS username
			    
			FROM concession_concessions AS cc 
			
			INNER JOIN users u ON u.id = cc.userid 					
			INNER JOIN store_stores ss ON ss.id = cc.storeid
			
			WHERE #arguments.where#<!---<cfqueryparam value="#arguments.where#" cfsqltype="cf_sql_char" />--->
				
			ORDER BY 
				#arguments.orderby#<!---<cfqueryparam value="#arguments.orderby#" cfsqltype="cf_sql_char" />--->
				#arguments.order#<!---<cfqueryparam value="#arguments.order#" cfsqltype="cf_sql_char" />--->
				
			LIMIT #limit#, #arguments.amount#
				

		</cfquery>

		<cfreturn query_concession />
	</cffunction>
	
	<cffunction 
		name="findConcessionsCount">
		
		<cfargument name="where" type="string" required="true" />
			
		<cfquery
			name="query_concession"
			result="result_concession"
			datasource="#get('loc').datasource.intranet#">
							
			SELECT 
			     cc.id AS id
			    ,cc.statusid AS status
			    ,ss.projekt AS projekt
			    ,cc.createdate AS createdate
			    ,CONCAT(IF(u.givenname IS NULL,'',u.givenname)," ",IF(u.sn IS NULL,'',u.sn)) AS username
			    
			FROM concession_concessions AS cc 
			
			INNER JOIN users u ON u.id = cc.userid 					
			INNER JOIN store_stores ss ON ss.id = cc.storeid
			
			WHERE #arguments.where#

		</cfquery>

		<cfreturn query_concession />
	</cffunction>
	
</cfcomponent>