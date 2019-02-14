<cfcomponent displayname="User_users" output="false" hint="" extends="Controller">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
		<cfset filters(through="loadJs",type="before") />
		<cfset filters(through="merge",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="private" hint="">
		<cfset usesLayout("/layout") />
	</cffunction> 
	
	<cffunction name="loadJs" output="false" access="private" hint="">
	</cffunction>
	
	<cffunction name="merge" output="false" access="private" hint="">
		<cfparam name="r" type="struct" default="#structNew()#" />
		<cfset r.putAll(url) />
		<cfset r.putAll(form) /> 
	</cffunction>
	
	<cffunction name="management" outout="false" access="public" hint="">
		<!---<cfset var u = createObject("component", "cfc.user").init(
			id = session.user.id,
			givenname = session.user.givenname,
			sn = session.user.sn,
			mail = session.user.mail,
			login = session.user.login,
			photo = session.user.photo
		) />--->
		<!---<cfset var u = new cfc.user(id = session.user.id,
			givenname = session.user.givenname,
			sn = session.user.sn,
			mail = session.user.mail,
			login = session.user.login,
			photo = session.user.photo) />--->
		
		<cfset var u = {
			id = session.user.id,
			givenname = session.user.givenname,
			sn = session.user.sn,
			mail = session.user.mail,
			login = session.user.login,
			photo = session.user.photo
		} />
		
		<cfset var jsessionid = "" />
		<cfif IsDefined("cookie.jsessionid")>
			<cfset jsessionid = cookie.jsessionid />
		</cfif>
		<cfset objectSave(u, "ram:///user_#cookie.cfid#_#cookie.cftoken#_#jsessionid#") />
		<cffile action="readbinary" file="ram:///user_#cookie.cfid#_#cookie.cftoken#_#jsessionid#" variable="p" />
		
		<cfset var a = createObject("component", "cfc.s").init(
			dsn = get('loc').datasource.intranet,
			cfid = cookie.cfid,
			cftoken = cookie.cftoken,
			jsessionid = jsessionid).saveBlobObject(p) />
		
		<cfif structKeyExists(a, "success") and a.success is true>
			
			<cfswitch expression="#URL.module#" >
				<cfcase value="users" >
					<cflocation url="http://intranet.monkey.xyz/helpdesk/index.cfm?event=users.index" addtoken="true" />
				</cfcase>
				
				<cfcase value="stores">
					<cflocation url="http://intranet.monkey.xyz/helpdesk/index.cfm?event=stores.index" addtoken="true" />
				</cfcase>
			</cfswitch>
		</cfif>
		
		
		<cfabort />
	</cffunction>
	
	<cffunction name="external" outout="false" access="public" displayname="external" hint="">
		<cfset var u = {
			id = session.user.id,
			givenname = session.user.givenname,
			sn = session.user.sn,
			mail = session.user.mail,
			login = session.user.login,
			photo = session.user.photo
		} />
		
		<cfset var jsessionid = "" />
		<cfif IsDefined("cookie.jsessionid")>
			<cfset jsessionid = cookie.jsessionid />
		</cfif>
		<cfset objectSave(u, "ram:///user_#cookie.cfid#_#cookie.cftoken#_#jsessionid#") />
		<cffile action="readbinary" file="ram:///user_#cookie.cfid#_#cookie.cftoken#_#jsessionid#" variable="p" />
		
		<cfset var a = createObject("component", "cfc.s").init(
			dsn = get('loc').datasource.intranet,
			cfid = cookie.cfid,
			cftoken = cookie.cftoken,
			jsessionid = jsessionid).saveBlobObject(p) />
		
		<cfif structKeyExists(a, "success") and a.success is true>
			
			<cfswitch expression="#URL.module#" >
				<cfcase value="questionnaires" >
					<cflocation url="http://intranet.monkey.xyz/ankieta" addtoken="true" />
				</cfcase>
			</cfswitch>
			
		</cfif>
		
		
		<cfabort />
	</cffunction>
	
	<cffunction name="getUsers" output="false" access="public" hint="">
		<cfif not StructKeyExists(params, "searchvalue")>
			<cfset params.searchvalue = '' />
		</cfif>
		
		<cfset json = model("tree_groupuser").getUsers(params.searchvalue)/>
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
</cfcomponent>