<cfcomponent 
	extends="Model">
	
	<cffunction 
		name="init">
			
		<cfset table("product_exposteps") />
		
	</cffunction>
	
	<cffunction 
		name="findSteps">
		
		<cfargument name="expoid" type="numeric" required="true" />
		
		<cfquery 
			name="qSteps"
			result="rSteps"
			datasource="#get('loc').datasource.intranet#">
				
			select 
				ps.id
				,ps.createddate
				,ps.userid
				,u.givenname
				,u.sn
				,ps.comment
				,ps.stepid
				,concat(psn.department) as stepname
				,ps.stepstatusid
				,pss.stepstatusname as stepstatusname
				,ps.stepbegin
				,ps.stepend  
			
			from product_exposteps ps
			
			join product_stepnames psn on psn.id = ps.stepid
			join product_stepstatuses pss on pss.id = ps.stepstatusid
			left join users u on u.id = ps.userid
			
			where expoid = <cfqueryparam value="#arguments.expoid#" cfsqltype="cf_sql_integer" />
			
			order by ps.stepbegin desc;
			
		</cfquery>
		
		<cfreturn qSteps />
		
	</cffunction>
	
</cfcomponent>