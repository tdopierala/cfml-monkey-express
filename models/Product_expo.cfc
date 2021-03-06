<cfcomponent 
	extends="Model">
	
	<cffunction 
		name="init">
			
		<cfset table("product_expo") />
		
	</cffunction>
	
	<cffunction 
		name="insert">
		
		<cfargument	name="params" required="true" type="struct" />
		
		<cfset columns='' />
		<cfloop collection="#arguments.params#" item="arg">
			<cfset columns &= "," & arg />
		</cfloop>
		
		<cfset fields='' />
		<cfloop collection="#arguments.params#" item="arg">
			<cfif arguments.params[arg] neq ''>
				<cfset fields &= ',"' & arguments.params[arg] & '"' />
			<cfelse>
				<cfset fields &= ',null' />
			</cfif>
		</cfloop>
		
		<cfset query = "insert into product_expo ( " & Right(columns, Len(columns)-1) & ", createddate ) values ( " & Right(fields, Len(fields)-1) & ", NOW() );" />

		<cfquery
			name="query_new_index"
			result="result_index"
			datasource="#get('loc').datasource.intranet#">
			
			#REReplace(query,"''","'","ALL")#
			
		</cfquery>

		<cfreturn result_index />
	
	</cffunction>
	
	<cffunction 
		name="findAllExpo">
			
		<cfquery 
			name="qExpo"
			result="rExpo"
			datasource="#get('loc').datasource.intranet#">
				
			select 
				pe.id
				,pe.purpose
				,pe.ean
				,pe.amount
				,pe.producer
				,pe.termbegin
				,pe.termend
				,pe.deliverydate
				,pe.delivery
				,pe.label
				,pe.createddate
				,pe.userid 
				,s.stepid as stepid
				,concat(psn.department) as stepname
			from product_expo pe
			join (SELECT expoid, max(stepid) as stepid FROM intranet.product_exposteps group by expoid) s on s.expoid = pe.id
			join product_stepnames psn on psn.id = s.stepid
			
			order by pe.createddate desc;
			
		</cfquery>
		
		<cfreturn qExpo />
		
	</cffunction>
	
	<cffunction 
		name="findOneExpo">
		
		<cfargument name="key" type="numeric" required="true" />
		
		<cfquery 
			name="qExpo"
			result="rExpo"
			datasource="#get('loc').datasource.intranet#">
				
			select 
				 pe.id
				,pe.purpose
				,pe.ean
				,pe.amount
				,pe.height
				,pe.width
				,pe.length
				,pe.producer
				,pe.termbegin
				,pe.termend
				,pe.deliverydate
				,pe.delivery
				,pe.startdate
				,pe.contact
				,pe.actionend
				,pe.label
				,pe.additionalinfo
				,pe.createddate
				,pe.userid
				,pe.productfile 
				,s.stepid as stepid
				,s.stepstatusid as stepstatusid
				,concat(psn.department) as stepname
			from product_expo pe
			join (SELECT expoid, max(stepid) as stepid, min(stepstatusid) as stepstatusid FROM intranet.product_exposteps group by expoid) s on s.expoid = pe.id
			join product_stepnames psn on psn.id = s.stepid
			
			where pe.id = <cfqueryparam value="#arguments.key#" cfsqltype="cf_sql_integer" />
			
			order by pe.createddate desc;
			
		</cfquery>
		
		<cfreturn qExpo />
		
	</cffunction>
	
	<cffunction 
		name="updateStep">
			
		<cfargument name="expoid" type="numeric" required="true" />
		
		<cfargument name="stepstatus" type="numeric" required="true" />
		
		<cfargument name="stepcomment" type="string" required="false" />
		
		<cfstoredproc 
			datasource="#get('loc').datasource.intranet#" 
			procedure="sp_intranet_product_expo_step"
			returncode="false" >
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.expoid#" dbVarName="@_expoid" />
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#arguments.stepstatus#" dbVarName="@_stepstatus" />
			
			<cfprocparam cfsqltype="CF_SQL_INTEGER" type="in" value="#session.user.id#" dbVarName="@_userid">
			
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="in" value="#arguments.stepcomment#" dbVarName="@_comment" />
			
			<cfprocresult name="step" resultSet="1" />
			
		</cfstoredproc>
		
	</cffunction>
	
</cfcomponent>