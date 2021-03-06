<cfcomponent displayname="Folder_document" output="false" extends="Model">
	
	<cfproperty name="tableName" type="string" default="" />
	
	<!--- PSEUDO-CONSTRUCTOR --->
	<cfscript> 
		variables.instance = {
			tableName = "folder_documents"
		};
	</cfscript>

	<cffunction name="init" access="public" output="false" hint="">
		<cfset table("folder_documents") />
	</cffunction>
	
	<cffunction name="getDocuments" access="public" output="false" hint="">
		<cfargument name="folderid" type="numeric" required="true" />
		
		<cfset var doc = "" />
		<cfquery name="doc" datasource="#get('loc').datasource.intranet#">
			select
				id as id, 
				document_name as documentname,
				document_src as documentsrc
			from #variables.instance.tableName#
			where folderid = <cfqueryparam value="#arguments.folderid#" cfsqltype="cf_sql_integer" /> 
		</cfquery>
		
		<cfreturn doc />
	</cffunction>
	
	<cffunction name="getParentDocuments" output="false" access="public" hint="">
		<cfargument name="folderId" type="numeric" required="true" />
		
		<cfset var parentDocuments = "" />
		<cfquery name="parentDocuments" datasource="#get('loc').datasource.intranet#">
			<!--- Najpierw muszę wyszukać id rodzica --->
			set @parent_id = 0;
			set @lft = 0;
			set @rgt = 0;
			
			select lft, rgt
			into @lft, @rgt
			from folder_folders
			where id = <cfqueryparam value="#arguments.folderId#" cfsqltype="cf_sql_integer" />;
			
			select 
				id
			into @parent_id
			from folder_folders
			where lft < @lft and rgt > @rgt
			order by rgt - @rgt asc
			limit 1;
			
			select
				id as id, 
				document_name as documentname,
				document_src as documentsrc
			from #variables.instance.tableName#
			where folderid = @parent_id;
		</cfquery>
		
		<cfreturn parentDocuments />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="">
		<cfargument name="documentId" type="numeric" required="true" />
		
		<cfset var delDoc = "" />
		<cfquery name="delDoc" datasource="#get('loc').datasource.intranet#">
			delete from #variables.instance.tableName# 
			where id = <cfqueryparam value="#arguments.documentId#" cfsqltype="cf_sql_integer" />; 
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="statNewDocuments" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var documentStat = "" />
		<cfquery name="documentStat" datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
				APPLICATION.cache.query.days,
				APPLICATION.cache.query.hours,
				APPLICATION.cache.query.minutes,
				APPLICATION.cache.query.seconds)#">
				
			set @d_from = 0;
			set @d_to = 0;
			
			select
				ifnull(date_from, Now()) as date_from,
				ifnull(date_to, Now()) as date_to
			into @d_from, @d_to
			from users
			where id = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			limit 1;
			
			select count(id) as c 
			from #variables.instance.tableName#
			where created between @d_from and @d_to;
		</cfquery>
		
		<cfreturn documentStat />
	</cffunction>

</cfcomponent>