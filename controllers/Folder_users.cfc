<cfcomponent displayname="Folder_users" output="false" extends="Controller">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(type="before",through="loadLayout") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
		<cfset application.ajaxImportFiles &= ",initFolders" />
	</cffunction>
	
	<cffunction name="privileges" output="false" access="public" hint="">
		<cfset foldery = model("folder_folder").getFoldersTree() />
	</cffunction>
	
	<cffunction name="userPrivileges" output="false" access="public" hint="">
		<cfif IsDefined("FORM.USERID")>
			<cfset json = model("folder_user").getUserPrivilege(FORM.USERID) />
			<cfset json = QueryToStruct(Query=json) />
		<cfelse>
			<cfset json = structNew() />
			<cfset json = structNew() />
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction name="grantRead" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		<cfset g = model("folder_user").grantRead(
			userid = FORM.USERID,
			lft = FORM.LFT,
			rgt = FORM.RGT,
			id = FORM.ID) />
		
		<cfset json = model("folder_user").getUserPrivilege(FORM.USERID) />
		<cfset json = QueryToStruct(Query=json) />
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction name="revokeRead" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		<cfset g = model("folder_user").revokeRead(
			userid = FORM.USERID,
			lft = FORM.LFT,
			rgt = FORM.RGT,
			id = FORM.ID) />
		
		<cfset json = model("folder_user").getUserPrivilege(FORM.USERID) />
		<cfset json = QueryToStruct(Query=json) />
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction name="grantWrite" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		<cfset g = model("folder_user").grantWrite(
			userid = FORM.USERID,
			lft = FORM.LFT,
			rgt = FORM.RGT,
			id = FORM.ID) />
		
		<cfset json = model("folder_user").getUserPrivilege(FORM.USERID) />
		<cfset json = QueryToStruct(Query=json) />
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction name="revokeWrite" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		<cfset g = model("folder_user").revokeWrite(
			userid = FORM.USERID,
			lft = FORM.LFT,
			rgt = FORM.RGT,
			id = FORM.ID) />
		
		<cfset json = model("folder_user").getUserPrivilege(FORM.USERID) />
		<cfset json = QueryToStruct(Query=json) />
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
</cfcomponent>