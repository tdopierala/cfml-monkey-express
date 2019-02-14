<cfcomponent
	extends="Model">

	<cffunction 
		name="init">
	
		<cfset table("proposal_pps") />
		<cfset belongsTo(name="kos", modelName="User", foreignKey="userid") />
		<cfset belongsTo(name="reasons", modelName="Pps_proposal_reason", foreignKey="reasonid") />
		<!---<cfset belongsTo(name="director", modelName="User", foreignKey="directorid") />--->
		<!---<cfset belongsTo(name="stores", modelName="Store_store", foreignKey="projekt", joinKey="projekt") />--->
	
	</cffunction>
	
	<cffunction 
		name="findAllProposals">
			
		<cfargument name="userid" type="numeric" required="no" default="0" />
		<cfargument name="directorid" type="numeric" required="no" default="0" />
		
		<cfquery 
			name="proposal"
			result="result_proposal"
			datasource="#get('loc').datasource.intranet#">
			
			select 
				pp.id 
				,pp.lp
				,pp.projekt
				,pp.statusid
				,pp.reason
				,pp.reasonid
				,pp.methodid
				,pp.changedate
				,pp.directorid
				,pp.userid
				,pp.createddate
				,pp.statusnote
				,pp.completed
				,concat(u1.givenname,' ',if(u1.sn is null,'',u1.sn)) as username
				,concat(u2.givenname,' ',if(u2.sn is null,'',u2.sn)) as direcrotname
			
			from intranet.proposal_pps pp
			left join users u1 on pp.userid = u1.id
			left join users u2 on pp.directorid = u2.id
			
			where 1=1
				
				<cfif arguments.userid neq 0>
					and pp.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				</cfif>
				
				<cfif arguments.directorid neq 0>
					and pp.directorid = <cfqueryparam value="#arguments.directorid#" cfsqltype="cf_sql_integer" />
				</cfif>
			
			order by pp.id desc
		</cfquery>
		
		<cfreturn proposal />
		
	</cffunction>

</cfcomponent>