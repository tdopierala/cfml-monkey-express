<cfcomponent displayname="sms_sender_group" output="false" extends="Model">
	
	<cfproperty name="TGroups" type="string" />
	
	<cfscript>
		variables.instance = {
			TGroups = "sms_sender_groups"
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public">
		<cfset table(variables.instance.TGroups) />
	</cffunction>
	
	<cffunction name="getGroups" output="false" access="public" hint="">
		<cfset var grps = "" />
		<cfquery name="grps" datasource="#get('loc').datasource.intranet#">
			select id, sender_group_name as groupname from #variables.instance.TGroups#
		</cfquery>
		
		<cfreturn grps />
	</cffunction>
	
</cfcomponent>