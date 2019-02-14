<cfcomponent extends="Model">
	
	<cffunction name="init">
		<cfset table("place_instanceforms") />
	</cffunction>
	
	<cffunction name="getFormNotes" output="false" access="public" hint="">
		<cfargument name="instanceid" type="numeric" required="true" />
		
		<cfset var notatki = "" />
		<cfquery name="notatki" datasource="#get('loc').datasource.intranet#">
			select a.instanceid, a.formid, a.userid, a.formnote, a.created, b.formname, u.givenname, u.sn
			from place_forminstancenotes a
			inner join place_forms b on a.formid = b.id 
			inner join users u on a.userid = u.id
			where a.instanceid = <cfqueryparam value="#arguments.instanceid#" cfsqltype="cf_sql_integer" />
			order by a.created desc
		</cfquery>
		<cfreturn notatki />
	</cffunction>
	
</cfcomponent>