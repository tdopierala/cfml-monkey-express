<cfcomponent 
	extends="Model">
	
	<cffunction 
		name="init">
		
		<cfset table('product_steps') />
		<cfset belongsTo(name="User", foreignKey="userid") />
		<cfset belongsTo(name="Product_stepname", foreignKey="step") />
		
	</cffunction>
	
	<cffunction 
		name="findLastStatuses">
			
		<cfargument name="date" type="string" required="true" />
		
		<cfargument name="version" type="numeric" required="false" default="1"/>
			
		<cfquery 
			name="qLastStatuses"
			result="rLastStatuses"
			datasource="#get('loc').datasource.intranet#">
			
			select
				ps.userid
				,ps.indexid
				,ps.step
				,ps.comment
				,pp.name
			
			from product_steps ps
			
			inner join product_index pi 
				on pi.id = ps.indexid and pi.version = <cfqueryparam value="#arguments.version#" cfsqltype="cf_sql_integer" /> 
			left join product_products pp 
				on pp.id = pi.productid  
			
			where
				ps.date > <cfqueryparam value="#arguments.date#" cfsqltype="CF_SQL_VARCHAR" /> 
				AND ps.notice_sent=0
			
			order by ps.step ASC
			
		</cfquery>
		
		<cfreturn qLastStatuses />
		
	</cffunction>
	
	<cffunction 
		name="findSteps">
			
		<cfargument name="indexid" type="numeric" required="true" />
		
		<cfquery 
			name="qSteps"
			result="rSteps"
			datasource="#get('loc').datasource.intranet#">
				
			select 
				ps.id
				,ps.date
				,ps.userid
				,u.givenname
				,u.sn, ps.comment
				,ps.step as stepid
				,concat(psn.name,IF(psn.department is null,'',concat(' - ',psn.department))) as stepname
				,ps.stepstatusid
				,pss.stepstatusname as stepstatusname
				,ps.stepstatusdatebegin
				,ps.stepstatusdateend  
			
			from product_steps ps
			
			join product_stepnames psn on psn.id = ps.step
			join product_stepstatuses pss on pss.id = ps.stepstatusid
			left join users u on u.id = ps.userid
			
			where indexid = <cfqueryparam value="#arguments.indexid#" cfsqltype="cf_sql_integer" />
			
			order by ps.date desc;
			
		</cfquery>
		
		<cfreturn qSteps />
	</cffunction>
	
</cfcomponent>