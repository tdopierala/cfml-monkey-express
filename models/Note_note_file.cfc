<cfcomponent extends="Model" displayname="Note_note_file">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("note_note_files") />
	</cffunction>
	
	<cffunction name="getNoteFiles" output="false" access="public" hint="">
		<cfargument name="noteid" type="numeric" required="true" />
		
		<cfset var qFiles = "" />
		<cfquery name="qFiles" datasource="#get('loc').datasource.intranet#">
			select
				f.file_name as filename
				,f.file_src as filesrc 
				,f.file_thumb_src as filethumbsrc
				,nf.id as id
			from note_note_files nf
				inner join note_files f on nf.fileid = f.id
			where nf.noteid = <cfqueryparam value="#arguments.noteid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn qFiles />
	</cffunction>
	
	<cffunction name="delFiles" output="false" access="public" hint="">
		<cfargument name="noteid" type="numeric" required="true" />
		
		<cfset var qFilesDel = "" />
		<cfquery name="qFilesDel" datasource="#get('loc').datasource.intranet#">
			delete 
				from note_note_files 
				where noteid = <cfqueryparam value="#arguments.noteid#" cfsqltype="cf_sql_integer" />;
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getFile" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var qMyFile = "" />
		<cfquery name="qMyFile" datasource="#get('loc').datasource.intranet#">
			select
				f.file_name as filename
				,f.file_src as filesrc
				,f.file_thumb_src as filethumbsrc
			from note_note_files fn
				inner join note_files f on fn.fileid = f.id
			where fn.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn qMyFile />
	</cffunction>
	
	<cffunction name="del" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var delFile = "" />
		<cfset var delFileRes = "" />
		<cfquery name="delFile" result="delFileRes" datasource="#get('loc').datasource.intranet#">
			set @fileId = 0;
			select fileid 
				into @fileId 
			from note_note_files 
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
			
			delete from note_note_files where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />;
			delete from note_files where id = @fileId;
		</cfquery>
		
		<cfreturn delFileRes />
	</cffunction>
</cfcomponent>