<cfcomponent output="false" hint="" extends="Model">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("workflow_step_users") />
	</cffunction>
	
	<cffunction name="getStepUsers" output="false" access="public" hint="">
		<cfargument name="stepid" type="numeric" required="true" />
		<cfargument name="search" type="string" required="false" default="" />
		
		<cfset var stepUsers = "" />
		<cfquery name="stepUsers" datasource="#get('loc').datasource.intranet#">
			select
				ws.id as id
				,ws.userid as userid
				,ws.workflowstepid as workflowstepid
				,u.givenname as givenname
				,u.sn as sn
			from workflow_step_users ws
			inner join users u on ws.userid = u.id
			where ws.workflowstepid = <cfqueryparam  value="#arguments.stepid#" cfsqltype="cf_sql_integer" />
			and u.active = 1
			
			<cfif Len(arguments.search)>
				and (
					LOWER(u.givenname) like <cfqueryparam value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" /> or
					LOWER(u.sn) like <cfqueryparam value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" /> or
					LOWER(u.login) like <cfqueryparam value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" /> or
					LOWER(u.memberof) like <cfqueryparam value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" />
				)
			</cfif>
			
		</cfquery>
		
		<cfreturn stepUsers />
	</cffunction>
	
</cfcomponent>