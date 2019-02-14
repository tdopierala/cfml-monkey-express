<cfcomponent extends="Model" displayname="Note_tag">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("note_tags") />
	</cffunction>
	
	<cffunction name="getTags" output="false" access="public" hint="">
		<cfset var qTags = "" />
		<cfquery name="qTags" datasource="#get('loc').datasource.intranet#">
			select id, tag_name as tagname from note_tags;
		</cfquery>
		
		<cfreturn qTags />
	</cffunction>
	
	<cffunction name="findTag" output="false" access="public" hint="">
		<cfargument name="tgn" type="string" required="true" />
		
		<cfset var ftg = "" />
		<cfquery name="ftg" datasource="#get('loc').datasource.intranet#">
			select id, tag_name as tagname 
			from note_tags 
			where tag_name = <cfqueryparam value="#arguments.tgn#" cfsqltype="cf_sql_varchar" /> 
		</cfquery>
		
		<cfreturn ftg />
	</cffunction>
	
</cfcomponent>