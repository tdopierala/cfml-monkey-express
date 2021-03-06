<cfcomponent
	extends="Model">

	<cffunction
		name="init">

		<cfset belongsTo(name="file",foreignKey="fileid") />
		<cfset belongsTo(name="user",foreignKey="userid") />

	</cffunction>

	<cffunction
		name="getPostList"
		hint="Pobranie listy najnowszych aktualności"
		description="Funkcja pobierająca listę najnowszych aktualności z bazy">

		<cfargument name="page" type="numeric" default="1" required="false" />
		<cfargument name="num" type="numeric" default="6" required="false" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_get_posts_list"
			returncode = "no">

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.page#"
				dbVarName = "@pge" />

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.num#"
				dbVarName = "@cnt" />

			<cfprocresult name="posts" resultset="1" />

		</cfstoredproc>

		<cfreturn posts />

	</cffunction>

	<!---
		8.04.2013
		Pobranie listy aktualności. Widok ma być stronicowany.
	--->
	<cffunction
		name="getPosts"
		hint="Pobranie aktualności z systemu."
		description="Pobranie aktualności z systemu. Wyniki są stronicowane.
				Argumenty są przesłane do metody." >

		<cfargument
			name="page"
			type="numeric"
			default="1"
			required="false" />

		<cfargument
			name="elements"
			type="numeric"
			default="20"
			required="false" />
			
		<!--- ID użytkownika, który przegląda aktualności --->
		<cfargument 
			name="userid" 
			type="numeric" 
			required="true" />

		<cfset a = (arguments.page -1) * arguments.elements />

		<!--- Wyciągam dane użytkownika --->
		<!---<cfquery
			name="qPostUser"
			result="rPostUser"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							1,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">
			
			select centrala, partner_prowadzacy_sklep from users where id = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />;
			
		</cfquery>--->
		
		<!---<cfset qWhere = "" />
		<cfif qPostUser.centrala EQ 1>
			<cfset qWhere &= " p.centrala = 1 or " />
		</cfif>
		
		<cfif qPostUser.partner_prowadzacy_sklep EQ 1>
			<cfset qWhere &= " p.partner_prowadzacy_sklep = 1 or " />
		</cfif>
		
		<cfif Len(qWhere)>
			<cfset qWhere = left(qWhere, len(qWhere) - 3) />
		</cfif>--->
		
		<cfquery
			name="qPosts"
			result="rPosts"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">
							
			<!---select
				p.id as id
				,p.posttitle as posttitle
				,p.postcontent as postcontent
				,p.postcreated as postcreated
				,p.userid as userid
				,p.filename as filename
				,u.givenname as givenname
				,u.sn as sn
			from posts p
			inner join users u on p.userid = u.id
			
			<!--- ELEMENT WHERE --->
			<cfif Len(qWhere)>
				where #qWhere#
			</cfif>
			<!--- ELEMENT WHERE --->
			
			order by postcreated desc
			limit #a#, <cfqueryparam
						value="#arguments.elements#"
						cfsqltype="cf_sql_integer" />;--->
						
			select 
				p.id as id
				,p.posttitle as posttitle
				,p.postcontent as postcontent
				,p.postcreated as postcreated
				,p.userid as userid
				,p.filename as filename
				,u.givenname as givenname
				,u.sn as sn
			
				-- p.posttitle, pp.postid, tgu.groupid 
			from tree_groupusers tgu
			
			join post_privileges pp on pp.groupid = tgu.groupid
			join posts p on p.id = pp.postid
			join users u on u.id = p.userid
			
			where tgu.userid = <cfqueryparam
									value="#arguments.userid#"
									cfsqltype="cf_sql_integer" />
			group by p.id
			order by p.postcreated desc
			limit #a#, <cfqueryparam
						value="#arguments.elements#"
						cfsqltype="cf_sql_integer" />;

		</cfquery>

		<cfreturn qPosts />

	</cffunction>

	<!---
		8.04.201
		Zliczenie wszystkich aktualności w systemie.
	--->
	<cffunction
		name="getPostCount"
		hint="Zliczanie wszystkich aktualności w tabeli"
		description="Zliczanie wszystkich aktualności w tabeli.
				Metoda jest potrzebna do zbudowania paginacji na stronie.">

		<cfquery
			name="qPostCount"
			result="rPostCount"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				count(id) as c
			from posts;

		</cfquery>

		<cfreturn qPostCount />

	</cffunction>

	<cffunction
		name="statUserPost"
		hint="Zliczenie aktualności dodanych do systemu, i których nie czytał
			użytkownik">

		<cfargument
			name="userid"
			type="numeric"
			required="true" />

		<cfquery
			name="qUser"
			result="rUser"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				ifnull(date_from, Now()) as date_from,
				ifnull(date_to, Now()) as date_to
			from users
			where id = <cfqueryparam
							value="#arguments.userid#"
							cfsqltype="cf_sql_integer" />
			limit 1

		</cfquery>

		<cfquery
			name="uPosts"
			result="rPosts"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				count(id) as c
			from posts
			where postcreated between <cfqueryparam
										value="#qUser.date_from#"
										cfsqltype="cf_sql_timestamp" />
							and <cfqueryparam
									value="#qUser.date_to#"
									cfsqltype="cf_sql_timestamp" />

		</cfquery>

		<cfreturn uPosts />

	</cffunction>
	
	<cffunction
		name="getPostUsers"
		hint="Pobranie listy użytkowników, którzy mogą widzieć daną aktualność">
			
		<cfargument name="postid" type="numeric" required="true" />
		
		<cfquery
			name="qGetPostInfo"
			result="rGetPostInfo"
			datasource="#get('loc').datasource.intranet#">
			
			select centrala, partner_prowadzacy_sklep 
				from posts 
				where id = <cfqueryparam value="#arguments.postid#" cfsqltype="cf_sql_integer" />
			
		</cfquery>
		
		<!--- Zbudowanie where --->
		<cfset qWhere = "" />
		<cfif qGetPostInfo.centrala EQ 1>
			<cfset qWhere &= " centrala = 1 or " />
		</cfif>
		
		<cfif qGetPostInfo.partner_prowadzacy_sklep EQ 1>
			<cfset qWhere &= " partner_prowadzacy_sklep = 1 or " />
		</cfif>
		
		<cfif Len(qWhere)>
			<cfset qWhere = left(qWhere, len(qWhere) - 3) />
		</cfif>
		
		<cfquery
			name="qGetPostUSers"
			result="rGetPostUsers"
			datasource="#get('loc').datasource.intranet#">
			
			select id, login, givenname, sn, mail
			from users
			
			<!--- WHERE --->
			<cfif Len(qWhere)>
				where (#qWhere#) and active=1
			<cfelse>
				where active=1
			</cfif>
			<!--- WHERE --->
			
		</cfquery>
		
		<cfreturn qGetPostUSers />
			
	</cffunction>
	
	<cffunction name="addPrivileges" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="groups" type="string" required="true" />
		
		<cfset var newPrivilege = "" />
		<cfloop list="#arguments.groups#" index="i" >
			<cfquery name="newPrivilege" datasource="#get('loc').datasource.intranet#">
				 insert into post_privileges(groupid, postid) values (
				 	<cfqueryparam value="#i#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
				 );
			</cfquery>
		</cfloop>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="sendNotification" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="groups" type="string" required="true" />
		
		<!--- Lista użytkowników do wysłania powiadomienia --->
		<cfset var users = queryNew("userid,mail,givenname,sn") />
		<cfloop list="#arguments.groups#" index="i" >
			<cfset var tmp = model("tree_groupuser").getGroupUsersFull(i) />
			<cfloop query="tmp">
				<cfif Len(mail) EQ 0>
					<cfcontinue />
				</cfif>
				
				<cfset queryAddRow(users) />
				<cfset querySetCell(users, "userid", tmp.userid) />
				<cfset querySetCell(users, "mail", "#tmp.mail#") />
				<cfset querySetCell(users, "givenname", JavaCast("string", givenname)) />
				<cfset querySetCell(users, "sn", "#sn#") />
			</cfloop>
		</cfloop>
		
		<cfset post = model("post").findByKey(arguments.id) />
		<cfset postFiles = model("post_attachment").findAll(where="postid=#arguments.id#") />
		
		<cfset var usersList = "" />		
		<cfquery name="usersList" dbtype="query">
			select distinct mail, sn, givenname from users;
		</cfquery>
		
		<cfloop query="usersList">
			<cfmail to="#mail#" cc="intranet@monkey.xyz" from="Monkey<intranet@monkey.xyz>"
				replyto="intranet@monkey.xyz" subject="Powiadomienie o aktualności" type="html"> 
				<cfoutput>
					Witaj #sn# #givenname#,<br />
					
					W Intranecie pojawiła się nowa aktualność. Jej treść zamieszczona 
					jest poniżej. 
					<br />
					----------------------------------------------------------------------------------------------------------------------------------------
					<br /><br />
					#post.postcontent#
					
					<cfloop query="postFiles">
						<cfmailparam file = "#ExpandPath('files/posts/#attachment_src#')#" />
					</cfloop>
					
					<br />
					<br />
					
					<div class="clear"></div>
			
					<br /><br />
					W razie pytań odnośnie Intranetu prosimy o kontakt pod adresem intranet@monkey.xyz.
					<br /><br />
			
					Pozdrawiamy,<br />
					Monkey Group
				</cfoutput>
			</cfmail>
		</cfloop>
		
		<cfreturn true />
	</cffunction>

</cfcomponent>