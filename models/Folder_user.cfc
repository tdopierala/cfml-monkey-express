<cfcomponent displayname="Folder_user" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("folder_users") />
	</cffunction>
	
	<cffunction name="getUserPrivilege" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var uprawnienia = "" />
		<cfquery name="uprawnienia" datasource="#get('loc').datasource.intranet#">
			select * 
			from folder_users 
			where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn uprawnienia />
	</cffunction>
	
	<cffunction name="grantRead" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="lft" type="numeric" required="true" />
		<cfargument name="rgt" type="numeric" required="true" />
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var folders = "" />
		<cfquery name="folders" datasource="#get('loc').datasource.intranet#">
			select * from folder_folders
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			<!---where lft >= <cfqueryparam value="#arguments.lft#" cfsqltype="cf_sql_integer" />
				and rgt <= <cfqueryparam value="#arguments.rgt#" cfsqltype="cf_sql_integer" />--->
		</cfquery>
		
		<cfloop query="folders">
			<cfset var userFolders = "" />
			<cfquery name="userFolders" datasource="#get('loc').datasource.intranet#">
				select * from folder_users 
				where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					and folderid = <cfqueryparam value="#folders.id#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfif userFolders.RecordCount EQ 0>
				
				<cfset var newPrivilege = "" />
				<cfquery name="newPrivilege" datasource="#get('loc').datasource.intranet#">
					insert into folder_users (folderid, userid, privilege_read)
					values (
						<cfqueryparam value="#folders.id#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="1" cfsqltype="cf_sql_integer" />
					);
				</cfquery>
				
			<cfelse>
				
				<cfset var updatePrivilege = "" />
				<cfquery name="updatePrivilege" datasource="#get('loc').datasource.intranet#">
					update folder_users set privilege_read = 1
					where folderid = <cfqueryparam value="#folders.id#" cfsqltype="cf_sql_integer" />
						and userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				
			</cfif>
		</cfloop>
		
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="revokeRead" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="lft" type="numeric" required="true" />
		<cfargument name="rgt" type="numeric" required="true" />
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var folders = "" />
		<cfquery name="folders" datasource="#get('loc').datasource.intranet#">
			select * from folder_folders
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			<!---where lft >= <cfqueryparam value="#arguments.lft#" cfsqltype="cf_sql_integer" />
				and rgt <= <cfqueryparam value="#arguments.rgt#" cfsqltype="cf_sql_integer" />--->
		</cfquery>
		
		<cfloop query="folders">
			<cfset var userFolders = "" />
			<cfquery name="userFolders" datasource="#get('loc').datasource.intranet#">
				select * from folder_users 
				where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					and folderid = <cfqueryparam value="#folders.id#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfif userFolders.RecordCount EQ 0>
				
				<cfset var newPrivilege = "" />
				<cfquery name="newPrivilege" datasource="#get('loc').datasource.intranet#">
					insert into folder_users (folderid, userid, privilege_read)
					values (
						<cfqueryparam value="#folders.id#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="0" cfsqltype="cf_sql_integer" />
					);
				</cfquery>
				
			<cfelse>
				
				<cfset var updatePrivilege = "" />
				<cfquery name="updatePrivilege" datasource="#get('loc').datasource.intranet#">
					update folder_users set privilege_read = 0
					where folderid = <cfqueryparam value="#folders.id#" cfsqltype="cf_sql_integer" />
						and userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				
			</cfif>
		</cfloop>
		
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="grantWrite" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="lft" type="numeric" required="true" />
		<cfargument name="rgt" type="numeric" required="true" />
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var folders = "" />
		<cfquery name="folders" datasource="#get('loc').datasource.intranet#">
			select * from folder_folders
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			<!---where lft >= <cfqueryparam value="#arguments.lft#" cfsqltype="cf_sql_integer" />
				and rgt <= <cfqueryparam value="#arguments.rgt#" cfsqltype="cf_sql_integer" />--->
		</cfquery>
		
		<cfloop query="folders">
			<cfset var userFolders = "" />
			<cfquery name="userFolders" datasource="#get('loc').datasource.intranet#">
				select * from folder_users 
				where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					and folderid = <cfqueryparam value="#folders.id#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfif userFolders.RecordCount EQ 0>
				
				<cfset var newPrivilege = "" />
				<cfquery name="newPrivilege" datasource="#get('loc').datasource.intranet#">
					insert into folder_users (folderid, userid, privilege_write)
					values (
						<cfqueryparam value="#folders.id#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="1" cfsqltype="cf_sql_integer" />
					);
				</cfquery>
				
			<cfelse>
				
				<cfset var updatePrivilege = "" />
				<cfquery name="updatePrivilege" datasource="#get('loc').datasource.intranet#">
					update folder_users set privilege_write = 1
					where folderid = <cfqueryparam value="#folders.id#" cfsqltype="cf_sql_integer" />
						and userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				
			</cfif>
		</cfloop>
		
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="revokeWrite" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="lft" type="numeric" required="true" />
		<cfargument name="rgt" type="numeric" required="true" />
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var folders = "" />
		<cfquery name="folders" datasource="#get('loc').datasource.intranet#">
			select * from folder_folders
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
			<!---where lft >= <cfqueryparam value="#arguments.lft#" cfsqltype="cf_sql_integer" />
				and rgt <= <cfqueryparam value="#arguments.rgt#" cfsqltype="cf_sql_integer" />--->
		</cfquery>
		
		<cfloop query="folders">
			<cfset var userFolders = "" />
			<cfquery name="userFolders" datasource="#get('loc').datasource.intranet#">
				select * from folder_users 
				where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					and folderid = <cfqueryparam value="#folders.id#" cfsqltype="cf_sql_integer" />
			</cfquery>
			
			<cfif userFolders.RecordCount EQ 0>
				
				<cfset var newPrivilege = "" />
				<cfquery name="newPrivilege" datasource="#get('loc').datasource.intranet#">
					insert into folder_users (folderid, userid, privilege_write)
					values (
						<cfqueryparam value="#folders.id#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />,
						<cfqueryparam value="0" cfsqltype="cf_sql_integer" />
					);
				</cfquery>
				
			<cfelse>
				
				<cfset var updatePrivilege = "" />
				<cfquery name="updatePrivilege" datasource="#get('loc').datasource.intranet#">
					update folder_users set privilege_write = 0
					where folderid = <cfqueryparam value="#folders.id#" cfsqltype="cf_sql_integer" />
						and userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				</cfquery>
				
			</cfif>
		</cfloop>
		
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="checkUserFolderPrivilege" output="false" access="public" hint="" returntype="query">
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="folderid" type="numeric" required="true" />
		
		<cfset var uprawnienia = "" />
		<cfquery name="uprawnienia" datasource="#get('loc').datasource.intranet#">
			select * from folder_users
			where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				and folderid = <cfqueryparam value="#arguments.folderid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn uprawnienia />
	</cffunction>
</cfcomponent>