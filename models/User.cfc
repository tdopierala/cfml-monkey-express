<cfcomponent extends="Model" >

	<cfset variables.breakCallbackAddresses = "">
	<cfset variables.breakCallbackAddresses = ListAppend(variables.breakCallbackAddresses, 'anction-edit')>

	<cffunction name="init" >

		<cfset hasMany("userAttributes")>
		<cfset hasMany("userGroup")>
		<cfset hasMany("userFeed")>
		<cfset hasMany("object")>
		<cfset hasMany("objectInstance")>
		<cfset hasMany("userObjectInstance")>
		<cfset hasMany("userOrganizationUnit")>
		<cfset hasMany("workflow")>
		<cfset hasMany("sequence")>
		<cfset hasMany("document")>
		<cfset hasMany("documentInstance")>
		<cfset hasMany("workflowStep")>
		<cfset hasMany("usermessages")/>
		<cfset hasMany("userAttributeValue") />
		<cfset hasMany(name="idea", joinType="inner") />

		<cfset belongsTo("department")>

	</cffunction>


	<cffunction name="createThumb">

		<!---
		Tworzę miniaturke zdjęcia, które przesłał użytkownik i zapisuje w katalogu
		thumbs pod taką samą nazwą.
		--->
		<cfif !FileExists(ExpandPath("images/avatars/thumbs")&"/#properties().photo#")>
			<cfset myImage = ImageNew(ExpandPath("images/avatars")&"/#properties().photo#")>
			<cfset ImageResize(myImage, "125", "", "blackman", 2)>
			<cfimage source="#myImage#" action="write" destination="#ExpandPath('images/avatars/thumbs')#/#properties().photo#" overwrite="yes">
		</cfif>

	</cffunction>

	<!---
	generateUserBlankAttributes
	---------------------------------------------------------------------------------------------------------------
	Metoda wyoływana w kontrolerze Users. Tworzy puste atrybuty dla użytkownika, który loguje
	się pierwszy raz do systemu.

	10.05.2012
	Metoda tworząca atrybuty uzytkownika jest usunięta. Musi zostać zmieniona na nową wersję po zmianach w bazie.
	--->
	<!---
	<cffunction name="generateUserBlankAttributes" hint="Generowanie pustych atrybutów użytkownika
															jeśli loguje się po raz pierwszy.">

		<cfargument name="userid" default="-1" required="true" type="numeric"/>

		<cfset usersattributes = model("usersAttribute").findAll(select="id") />

		<cfloop query="usersattributes">

			<cfset userattribute = model("userAttribute").new() />
			<cfset userattribute.userid = arguments.userid />
			<cfset userattribute.usersattributeid = id />
			<cfset userattribute.visible = 1 />
			<cfset userattribute.save(callbacks=false) />

		</cfloop>

	</cffunction>
	--->

	<!---
	updateUserBlankGroups
	---------------------------------------------------------------------------------------------------------------
	Tworzę domyślne powiązania użytkownika z grupami. Na starcie użytkownik jest praktycznie bez uprawnień.

	--->
	<cffunction name="updateUserBlankGroups">

		<cfargument name="userid" default="-1" required="true" type="numeric" />

		<cfset groups = model("group").findAll()>

		<cfloop query="groups">
			<cfset user_group = model("userGroup").new()>
			<cfset user_group.userid = arguments.userid>
			<cfset user_group.groupid = id>
			<cfset user_group.access = 0>
			<cfset user_group.save(callbacks=false)>
		</cfloop>

	</cffunction>

	<!---
	updateUserBlankFeeds
	---------------------------------------------------------------------------------------------------------------
	Tworzę powiązania między użytkownikiem a kanałami RSS.

	--->
<!---	<cffunction name="updateUserBlankFeeds">

		<cfargument name="userid" default="-1" required="true" type="numeric" />

		<cfset feed_definition = model("feedDefinition").findAll()>

		<cfloop query="feed_definition">
			<cfset user_feed = model("userFeed").new()>
			<cfset user_feed.userid = arguments.userid>
			<cfset user_feed.feeddefinitionid = id>
			<cfset user_feed.created = Now()>
			<cfset user_feed.save(callbacks=false)>
		</cfloop>
	</cffunction>--->

	<!---
		admin
		4.06.2013
		
		Tworzenie pustych atrybutów użytkownika.
	--->
	<cffunction
		name="generateUserBlankAttributes"
		hint="Tworzenie atrybutów użytkownika"
		description="Dodawanie pustych atrybutów użytkownika."
		returntype="boolean" >

		<cfargument 
			name="userid" 
			required="true" 
			type="numeric" />
		
		<cfquery
			name="qUAP"
			result="rUAP"
			datasource="#get('loc').datasource.intranet#">
				
			call sp_intranet_generate_blank_user_attributes (<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />)
				
		</cfquery>
		
		<cfreturn true />
		
	</cffunction>

	<cffunction
		name="updateUserDepartment"
		hint="Metoda aktulizująca departament użytkownika"
		description="Metoda aktualizująca departament użytkownika. Departament jest pobierany jako pole OU= distinguishedName">

		<cfargument name="userid" type="numeric" />
		<cfargument name="dn" type="string" />

		<!--- Najpierw muszę sparsować pole distinguishedName i wyciągnąć z niego pole OU z departamentem --->
		<cfset dnarray = ListToArray(arguments.dn, ",") />

		<!---
		Przechodzę przez wszystkie pola i wyciągam to właściwe z departamentem
		Przechodzę przez tablice do elementu n-1 aby sprawdzić wartość elementu i oraz i+1
		--->
		<cfset tmpdn = "" />
		<cfloop from="1" to="#ArrayLen(dnarray)-1#" index="i">
			<cfif FindNoCase("CN=", dnarray[i]) and FindNoCase("OU=", dnarray[i+1])>
				<cfset tmpdn = Right(dnarray[i+1], Len(dnarray[i+1])-3) />
				<cfbreak />
			</cfif>
		</cfloop>

		<!--- Jeśli pobrałem prawidłowo departament to aktualizuje go w bazie --->
		<cfif Len(tmpdn)>
			<cfset updatedepartment = model("user").updateByKey(key=arguments.userid,departmentname=tmpdn) />
		</cfif>

	</cffunction>

	<!---
	0 - korzeń, Pan Prezes
	1 - pierwszy poziom - dyrektorzy
	2 - drugi poziom - pracownicy/kierownicy
	3 - trzeci poziom - pracownicy (czasami ten poziom jest pusty)
	--->
	<cffunction
		name="getTree"
		hint="Pobranie struktury firmy"
		description="Metoda wywołująca procedurę na bazie danych i zwracająca pracowników znajdujących się na odpowiedniej głębokości struktury organizacyjnej">

		<cfargument name="depthlevel" type="numeric" default="0" required="false" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "intranet_users_getfulltree"
			returnCode = "No">

			<cfprocresult name="users" resultSet="1" />

		</cfstoredproc>

		<cfreturn users />

	</cffunction>

	<cffunction
		name="getRootBranch"
		hint="Pobieram dzieci rodzica w drzewie.">

		<cfargument name="lft" default="0" type="numeric" required="false" />
		<cfargument name="rgt" default="0" type="numeric" required="false" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_users_get_root_branch"
			returnCode = "no">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.lft#"
				dbVarName="@t_lft" />

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.rgt#"
				dbVarName="@t_rgt" />

			<cfprocresult name="users" resultSet="1" />

		</cfstoredproc>

		<cfreturn users />

	</cffunction>

	<cffunction
		name="moveBranch"
		hint="Przesunięcie elementu w drzewie">

		<cfargument name="userid" default="0" type="numeric" required="true" />
		<cfargument name="parentuserid" default="0" type="numeric" required="true" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "intranet_users_move"
			returnCode = "no">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.userid#"
				dbVarName="@rootuserid" />

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.parentuserid#"
				dbVarName="@parentuserid" />

			<cfprocresult name="users" resultSet="1" />

		</cfstoredproc>

	</cffunction>

	<cffunction
		name="getRoot"
		hint="Pobranie korzenia."
		description="Metoda pobierająca korzeń drzewa użytkowników.">

		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_users_get_root"
			returnCode="No">

			<cfprocresult name="root" resultSet="1" />

		</cfstoredproc>

		<cfreturn root />

	</cffunction>

	<!---
		5.09.2012
		Funkcjonalność wyszukiwania po użytkownikach w systemie.

		13.05.2013
		Wyszukiwanie użytkownika w systemie uległo małej modyfikacji. Zamiast
		procedury zdefiniowanej w bazie jest zapytanie SQL umieszczone w modelu.
		Do tego jest napisana metoda, która generuje warunek where
		do wyszukiwania.

		Warunek WHERE
	--->
	<cffunction
		name="createWhereCond"
		hint="Generowanie warunku where do wyszukiwania użytkowików"
		returntype="String" >

		<cfargument
			name="search"
			type="array"
			required="true" />

		<!---
			Podaje kolumny, po których mam wyszukiwać.
		--->
		<cfset columns = "login,sn,givenname,mail,samaccountname,departmentname,position,memberof" />

		<!---
			Buduje dwie pętle, które tworzą warunek do zapytania.
		--->
		<cfset w = "active=1 and mail is not null " />

		<cfif ArrayIsEmpty(arguments.search)>
			<cfreturn w />
		</cfif>

		<cfset w &= " and (" />

		<cfloop list="#columns#" index="i" delimiters=",">
			<cfset w &= "(" />
			<cfloop array="#arguments.search#" index="j" >
				<cfset w &= " LOWER(`#i#`) like '%"& #LCase(j)# &"%' and " />
			</cfloop>
			<cfset w = Left(w, Len(w)-5) />
			<cfset w &= ") or " />
		</cfloop>

		<cfset w = Left(w, Len(w)-4) />
		<cfset w &= ") " />

		<cfreturn #REReplace(w, "''", "'", "ALL")# />

	</cffunction>

	<cffunction
		name="search"
		hint="Wyszukiwanie użytkowników"
		description="Metoda odwołująca się do metody w bazie danych i 
				wyszukująca użytkowników spełniających kryteria">

		<cfargument
			name="search"
			type="array"
			required="true" />
			
		<cfargument
			name="page"
			type="numeric" 
			required="true" />
			
		<cfargument
			name="elements"
			type="numeric" 
			required="true" />
		
		<cfargument
			name="uorder"
			type="string" 
			required="true" />
			
		<cfargument
			name="order"
			type="string" 
			required="true" />
			
		<cfargument 
			name="groupid" 
			type="numeric" 
			required="true" /> 
			
		<cfset a = (arguments.page-1) * arguments.elements />
			
		<cfquery
			name="qUser"
			result="rUser"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >

			select
				u.id
				,u.login
				,u.photo
				,u.departmentid
				,u.givenname
				,u.sn
				,u.mail
				,u.samaccountname
				,u.departmentname
				,u.lft
				,u.rgt
				,u.parent_id

				,uav.userattributevaluetext as position
				,(select uavp.userattributevaluetext from userattributevalues uavp where uavp.attributeid = 124 and uavp.userid = u.id) as phone
				-- ,uavp.userattributevaluetext as phone
				-- ,tel1
				,(select uavm.userattributevaluetext from userattributevalues uavm where uavm.attributeid = 191 and uavm.userid = u.id) as mobile
				-- ,uavm.userattributevaluetext as mobile
			from users u
			inner join tree_groupusers tgu on tgu.groupid = #arguments.groupid# and tgu.userid = u.id 
			left join userattributevalues uav on uav.attributeid = 123 and uav.userid = u.id
			-- left join userattributevalues uavp on uavp.attributeid = 124 and uavp.userid = u.id
			-- left join userattributevalues uavm on uavm.attributeid = 191 and uavm.userid = u.id
			where
				#this.createWhereCond(arguments.search)# <!--- and id <> 2 ---> <!--- :) --->
					
			order by #arguments.uorder# #arguments.order#
			
			limit #a#, <cfqueryparam
							value="#arguments.elements#"
							cfsqltype="cf_sql_integer" />

		</cfquery>

		<cfreturn qUser />

	</cffunction>
	
	<cffunction 
		name="find"
		hint="Nazwa troszkę myląca. Metoda wyszukuje użytkowników na podstawie
			przesłanych kryteriów"
		description="MEtoda jest używana do: pobierania listy użytkowników
			przy przekazywaniu faktur, rejonizacji ekspansyjnej. Zwracane są
			podstawowe dane, bez fajerwerków :) numerów tel, itp." >
			
		<cfargument name="centrala" type="numeric" default="1" required="false" />
		<cfargument name="dyrektorzy" type="numeric" default="0" required="false" />
		<cfargument name="menadzer" type="numeric" default="0" required="false" />
		<cfargument name="partner_ds_sprzedazy" type="numeric" default="0" required="false" />
		<cfargument name="partner_ds_ekspansji" type="numeric" default="0" required="false" />
		<cfargument name="partner_prowadzacy_sklep" type="numeric" default="0" required="false" />
		<cfargument name="search" type="string" default="" required="false" />
		
		<!--- Parametry związane z prezentowaniem wyniku --->
		<cfargument name="structure" type="boolean" default="false" required="false" /> 
		
		<cfquery
			name="qUserFind"
			result="rUserFind"
			datasource="#get('loc').datasource.intranet#">
			
			select
				id as id
				,givenname as givenname
				,sn as sn
				,login as login
				,photo as photo
				,mail as mail
			from users
			where active = 1
				<!--- and centrala = <cfqueryparam value="#arguments.centrala#" cfsqltype="cf_sql_integer" />
				and dyrektorzy = <cfqueryparam value="#arguments.dyrektorzy#" cfsqltype="cf_sql_integer" />
				and menadzer = <cfqueryparam value="#arguments.menadzer#" cfsqltype="cf_sql_integer" />
				and partner_ds_sprzedazy = <cfqueryparam value="#arguments.partner_ds_sprzedazy#" cfsqltype="cf_sql_integer" />
				and partner_ds_ekspansji = <cfqueryparam value="#arguments.partner_ds_ekspansji#" cfsqltype="cf_sql_integer" />
				and partner_prowadzacy_sklep = <cfqueryparam value="#arguments.partner_prowadzacy_sklep#" cfsqltype="cf_sql_integer" /> --->
				and (
					LOWER(givenname) like <cfqueryparam value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" />
					or LOWER(sn) like <cfqueryparam value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" />
					or LOWER(login) like <cfqueryparam value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" />
					or LOWER(mail) like <cfqueryparam value="%#LCase(arguments.search)#%" cfsqltype="cf_sql_varchar" />
				)
				
		</cfquery>
		
		<cfif arguments.structure is true>
			<cfreturn QueryToStruct(Query=qUserFind) />
		</cfif>
		
		<cfreturn qUserFind />
		
	</cffunction>

	<cffunction
		name="searchCount"
		hint="Zliczanie ilości użytkowników, którzy spełniają
				warunki wyszukiwania">

		<cfargument
			name="search"
			type="array"
			required="true" />

		<cfquery
			name="qUserCount"
			result="rUserCount"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >

			select
				count(u.id) as c
				,tgu.groupid 
			from users u
			inner join tree_groupusers tgu on (tgu.groupid = 8 or tgu.groupid = 9) and tgu.userid = u.id 
			where
				#this.createWhereCond(arguments.search)#
			group by tgu.groupid
			order by tgu.groupid

		</cfquery>

		<cfreturn qUserCount />

	</cffunction>

	<!---
		Metoda pobierająca historię logowania użytkowników na dany dzień.
		Wyniki nie są ograniczane. Lista zawiera wszystkich, którzy
		się logowali danego dnia.

		Wydaje mi się, że metoda jest wykorzystywana do wygenerowania listy
		wszystkich, którzy się logowali (opcja więcej przy ostatnio zalogowanych).
	--->
	<cffunction
		name="getUserHistory"
		output="false" >

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_user_login_history"
			returnCode = "no">

			<cfprocresult name="users" resultSet="1" />

		</cfstoredproc>

		<cfreturn users />

	</cffunction>

	<cffunction
		name="getLastLoggedIn"
		hint="Lista 12 ostatnio zalogowanych użytkowników."
		description="Lista 12 ostatnio zalogowanych użytkoników. Dane są wyświetlane
			w lewym pasku profilu użytkownika. Zapytanie jest cachowane co 15 min">

		<cfquery
			name="query_get_last_logged_in"
			result="result_get_last_logged_in"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				id as id
				,givenname as givenname
				,sn as sn
				,login as login
				,photo as photo
				,mail as mail
			from users
			where active = 1 and
				Year(last_login) = Year(Now()) and Month(last_login) = Month(Now()) and Day(last_login) = Day(Now()) and
				id not IN(2,345) <!--- :) --->
			order by  last_login desc
			limit 12;

		</cfquery>

		<cfreturn query_get_last_logged_in />

	</cffunction>
	
	<cffunction name="getUser" output="false" access="public" hint="" >
		<cfargument name="login" type="string" required="true" />
		<cfargument name="logo" type="string" required="true" />
		
		<cfset var user = "" />
		<cfquery name="user" datasource="#get('loc').datasource.intranet#">
			select * from users where
				login = <cfqueryparam value="#arguments.login#" cfsqltype="cf_sql_varchar" />
				and logo = <cfqueryparam value="#arguments.logo#" cfsqltype="cf_sql_varchar" />
				and active = 1
			limit 1;
		</cfquery>
		
		<cfreturn user />
	</cffunction>
	
	<cffunction name="addUser" output="false" access="public" hint="">
		<cfargument name="f" type="struct" required="true" />
		
		<cfinvoke component="controllers.Controller" method="randomText" returnvariable="randompassword" >
			<cfinvokeargument name="length" value="11" />
		</cfinvoke>
		
		<cfset var newUser = "" />
		<cfquery name="newUser" datasource="#get('loc').datasource.intranet#">
			insert into users (created_date, active, login, password, companyemail, givenname, mail, logo)
			values (
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />,
				<cfqueryparam value="1" cfsqltype="cf_sql_integer" />, 
				<cfqueryparam value="#arguments.f.projekt#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#Encrypt(randompassword, get('loc').intranet.securitysalt)#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.f.projekt#@monkey.xyz" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.f.nazwaajenta#" cfsqltype="cf_sql_varchar" />,
 				<cfqueryparam value="#arguments.f.projekt#@monkey.xyz" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.f.ajent#" cfsqltype="cf_sql_varchar" />
			);
			select LAST_INSERT_ID() as userid;
		</cfquery>
		
		<cfset var uprawnienia = "" />
		<cfquery name="uprawnienia" datasource="#get('loc').datasource.intranet#">
			insert into tree_groupusers (groupid, userid)
			values 
			(8, <cfqueryparam value="#newUser.userid#" cfsqltype="cf_sql_integer" />),
			(11, <cfqueryparam value="#newUser.userid#" cfsqltype="cf_sql_integer" />),
			(62, <cfqueryparam value="#newUser.userid#" cfsqltype="cf_sql_integer" />),
			(20, <cfqueryparam value="#newUser.userid#" cfsqltype="cf_sql_integer" />);
		</cfquery>
		
		<cfmail
			to="#arguments.f.projekt#@monkey.xyz"
			from="Monkey<intranet@monkey.xyz>"
			replyto="intranet@monkey.xyz"
			bcc="intranet@monkey.xyz"
			subject="Nowe konto"
			type="html">
			<cfoutput>
				Dzień dobry #arguments.f.nazwaajenta#,<br />
				W systemie Intranet zostało utworzone Twoje konto. Aby się zalogować przejdź na adres <a href="http://intranet.monkey.xyz">http://intranet.monkey.xyz</a>.<br /><br/>
				Login: #arguments.f.projekt#<br />
				Hasło: #randompassword#<br /><br />
				W razie pytań o działanie Intranetu prosimy o kontakt pod adresem <a href="mailto:intranet@monkey.xyz">intranet@monkey.xyz</a>.<br /><br />
				Pozdrawiamy,<br />
				Zespół Monkey Group
			</cfoutput>
		</cfmail>
		
		<cfreturn newUser />
	</cffunction>
	
	<cffunction name="getUserToWorkflowStep" output="false" access="public" hint="">
		
		<cfargument name="searchvalue" required="true" type="string" />
		<cfargument name="step" required="false" type="numeric" default="0" />
		<cfargument name="searchall" required="false" type="numeric" default="0" />
		
		<cfswitch 
			expression="#arguments.step#">
			
			<cfcase value="1">
				<!--- Etap 1: "Opisywanie" - grupa użytkowników (15) -> Controlling --->
				<cfset groupid = "15" />
				<cfset userout = "38,32" />
			</cfcase>
			
			<cfcase value="2">
				<!--- Etap 1: "Controlling" - grupa użytkowników (31) -> Dyrektorzy --->
				<cfset groupid = "31,144" />
				<cfset userout = "38,32" />
			</cfcase>
			
			<cfcase value="3">
				<!--- Etap 3: "Zatwierdzanie" - grupa użytkowników (43) -> Finansowy --->
				<cfset groupid = "43" />
				<cfset userout = "38,32" />
			</cfcase>
			
			<cfcase value="4">
				<!--- Etap 4: "Księgowość" - grupa użytkowników (35) -> Akceptacja --->
				<cfset groupid = "35" />
				<cfset userout = "2,32" /><!---"2,3,345,32" />--->
			</cfcase>
			
			<cfdefaultcase>
				<!--- Domyślnie - grupa użytkowników (9) -> Centrala --->
				<cfset groupid = "9" />
				<cfset userout = "38,104,62,86,87,88" />
			</cfdefaultcase>
			 
		</cfswitch>
		
		<cfquery 
			name="qSearchUser"
			result="rSearchUser" 
			datasource="#get('loc').datasource.intranet#">
				
			select distinct u.id, u.givenname, u.sn, u.login 
			from users u
			left join tree_groupusers tgu on tgu.userid = u.id  
			where (
						u.login like <cfqueryparam value="%#arguments.searchvalue#%" cfsqltype="cf_sql_varchar" />
					or	u.givenname like <cfqueryparam value="%#arguments.searchvalue#%" cfsqltype="cf_sql_varchar" />
					or	u.memberof like <cfqueryparam value="%#arguments.searchvalue#%" cfsqltype="cf_sql_varchar" />
					or	u.sn like <cfqueryparam value="%#arguments.searchvalue#%" cfsqltype="cf_sql_varchar" />
				)
				
			<cfif ListLen(groupid) gt 0 and arguments.searchall eq 0>
				and (
				<cfset counter=0 />
				<cfloop list="#groupid#" index="group" delimiters=",">
					<cfif counter gt 0> or </cfif>
					tgu.groupid = <cfqueryparam value="#group#" cfsqltype="cf_sql_integer" />
					<cfset counter++ />
				</cfloop>
				)
			</cfif>
			
			<cfif arguments.searchall eq 0>	
				and u.id NOT IN(#userout#)
			</cfif>
			
				and u.active = 1 
				-- and u.id <> 38
				order by u.givenname, u.sn ASC
		</cfquery>
		
		<cfreturn qSearchUser />
	</cffunction>
	
	<cffunction name="getUserByGroup" output="false" access="public" hint="">
		<cfargument name="search" required="true" type="string" />
		<cfargument name="group" required="true" type="string" />
		
		<cfquery 
			name="qSearchUser"
			result="rSearchUser" 
			datasource="#get('loc').datasource.intranet#">
				
			select distinct u.id, concat(u.givenname, ' ', if(u.sn is null, '', u.sn)) as givenname, u.login 
			from users u
			left join tree_groupusers tgu on tgu.userid = u.id
			left join tree_groups tg on tg.id = tgu.groupid
			where 
				tg.groupname like <cfqueryparam value="#arguments.group#" cfsqltype="cf_sql_varchar" /> 
				and u.active=1
				and (
						u.login like <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" />
					or 	u.givenname like <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" />
					or	u.memberof like <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" />
					or	u.sn like <cfqueryparam value="%#arguments.search#%" cfsqltype="cf_sql_varchar" />
				)
				
				and u.id not in(2,3,345)
				order by u.givenname, u.sn ASC
		</cfquery>
		
		<cfreturn qSearchUser />
	</cffunction>
	
</cfcomponent>
