<cfcomponent
	extends="Model">
		
	<cffunction
		name="init">
	
		<cfset table("place_stepprivileges") />
	
	</cffunction>
	
	<cffunction
		name="getUsersPrivileges"
		hint="Metoda pobierająca listę użytkowników">
			
		<cfquery
			name="qUserStepPrivileges"
			result="rUserStepPrivileges"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimespan(7, 0, 0, 0)#" >
				
			select 
				distinct sp.userid as userid
				,u.givenname as givenname
				,u.sn as sn
				,u.position as position
			from place_stepprivileges sp inner join users u on sp.userid = u.id;
				
		</cfquery>
		
		<cfreturn qUserStepPrivileges />
	
	</cffunction>
	
	<cffunction
		name="getUserSteps"
		hint="Pobranie listy sroków">
			
		<cfargument name="userid" type="numeric" default="0" required="true" />
		<cfargument name="structure" type="boolean" default="false" required="false" /> 
		
		<cfquery
			name="qStepPrivilege"
			result="rStepPrivilege"
			datasource="#get('loc').datasource.intranet#">
				
			select 
				sp.id as id
				,sp.readprivilege as readprivilege
				,sp.writeprivilege as writeprivilege
				,sp.acceptprivilege as acceptprivilege
				,sp.refuseprivilege as refuseprivilege
				,sp.archiveprivilege as archiveprivilege
				,sp.deleteprivilege as deleteprivilege
				,sp.moveprivilege as moveprivilege
				,sp.restoreprivilege as restoreprivilege
				,sp.controllingprivilege as controllingprivilege
				,sp.dtprivilege as dtprivilege
				,sp.stepid as stepid
				,s.stepname as stepname
			from place_stepprivileges sp inner join place_steps s on sp.stepid = s.id
			where sp.userid = <cfqueryparam
								value="#arguments.userid#"
								cfsqltype="cf_sql_integer" />
				
		</cfquery>
		
		<cfif arguments.structure>
			<cfreturn QueryToStruct(Query=qStepPrivilege) />
		</cfif>
		
		<cfreturn qStepPrivilege />
			
	</cffunction>
		
</cfcomponent>