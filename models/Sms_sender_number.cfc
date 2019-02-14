<cfcomponent displayname="Sms_sender_number" output="false" extends="Model">

	<cfproperty name="TNumbers" type="string" />
	<cfproperty name="TGroups" type="string" />
	<cfproperty name="TGroupNumbers" type="string" />
	
	<cfscript>
		variables.instance = {
			TNumbers = "sms_sender_numbers",
			TGroups = "sms_sender_groups",
			TGroupNumbers = "sms_sender_group_numbers"
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("sms_sender_numbers") />
	</cffunction>
	
	<cffunction name="ifNumberExists" output="false" returntype="boolean" access="public" hint="">
		<cfargument name="number" type="string" required="true" />
		<cfargument name="groupid" type="numeric" required="true" />
		
		<cfset var numbCnt = "" />
		<cfquery name="numbCnt" datasource="#get('loc').datasource.intranet#">
			select 
				count(distinct tn.id) as cnt
			from #variables.instance.TGroupNumbers# tgn
			inner join #variables.instance.TNumbers# tn on tgn.numberid = tn.id
			inner join #variables.instance.TGroups# tg on tgn.groupid = tg.id
			where tn.sender_number like <cfqueryparam value="%#arguments.number#%" cfsqltype="cf_sql_varchar" />
				and tgn.groupid = <cfqueryparam value="#arguments.groupid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfif numbCnt.cnt GT 0>
			<cfreturn true />
		</cfif>
		
		<cfreturn false />
	</cffunction>

</cfcomponent>