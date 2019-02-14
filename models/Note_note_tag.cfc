<cfcomponent extends="Model" displayname="Note_note_tag">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("note_note_tags") />
	</cffunction>
	
	<cffunction name="getNoteTags" output="false" access="public" hint="">
		<cfargument name="noteid" type="numeric" required="true" />
		
		<cfset var qTags = "" />
		<cfquery name="qTags" datasource="#get('loc').datasource.intranet#">
			select 
				t.id as tagid
				,t.tag_name as tagname
				,nt.id as id
			from note_note_tags nt 
				inner join note_tags t on nt.tagid = t.id
			where nt.noteid = <cfqueryparam value="#arguments.noteid#" cfsqltype="cf_sql_type" />
		</cfquery>
		
		<cfreturn qTags />
	</cffunction>
	
	<cffunction name="delTags" output="false" access="public" hint="">
		<cfargument name="noteid" type="numeric" required="true" />
		
		<cfset var qTagDel = "" />
		<cfquery name="qTagDel" datasource="#get('loc').datasource.intranet#">
			delete 
				from note_note_tags
				where noteid = <cfqueryparam value="#arguments.noteid#" cfsqltype="cf_sql_integer" /> 
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="del" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var delTag = "" />
		<cfset var delTagRes = "" />
		<cfquery name="delTag" result="delTagRes" datasource="#get('loc').datasource.intranet#">
			delete from note_note_tags where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn delTagRes />
	</cffunction>
</cfcomponent>