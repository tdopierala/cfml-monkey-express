<cfcomponent displayname="User_user" output="false" extends="Model" hint="">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("users") />
	</cffunction>
	
	<cffunction name="listaWszystkichUzytkownikow" output="false" access="public" hint="" returntype="query">
		<cfargument name="active" type="numeric" default="1" required="false" />
		
		<cfset var listaUzytkownikow = "" />
		<cfquery name="listaUzytkownikow" datasource="#get('loc').datasource.intranet#">
			select * from users 
			where active = <cfqueryparam value="#arguments.active#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn listaUzytkownikow />
	</cffunction>
	
	<cffunction name="listaUzytkownikow" output="false" access="public" hint="" returntype="query">
		<cfargument name="active" type="numeric" default="1" required="false" />
		
		<!--- Paginacja --->
		<cfargument name="elementy" type="numeric" default="30" required="false" />
		<cfargument name="strona" type="numeric" default="1" required="false" />
		<!--- Paginacja --->
		
		<cfset var od = (arguments.strona-1)*arguments.elementy />
		<cfset var uzytkownicy = "" />
		<cfquery name="uzytkownicy" datasource="#get('loc').datasource.intranet#">
			select * from users 
			where active = <cfqueryparam value="#arguments.active#" cfsqltype="cf_sql_integer" />
			order by givenname asc
			limit <cfqueryparam value="#od#" cfsqltype="cf_sql_integer" />,
				  <cfqueryparam value="#arguments.elementy#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn uzytkownicy />
	</cffunction>
	
	<cffunction name="iloscUzytkownikow" output="false" access="public" hint="" returntype="Numeric" >
		<cfargument name="active" type="numeric" default="1" required="false" />
		
		<cfset var ilosc = "" />
		<cfquery name="ilosc" datasource="#get('loc').datasource.intranet#">
			select count(*) as c from users
			where active = <cfqueryparam value="#arguments.active#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn ilosc.c />
	</cffunction>
	
	<cffunction name="iloscAktywnychAnkiet" output="false" access="public" hint="" returntype="query">
		<cfset var iloscAnkiet = "" />
		<cfquery name="iloscAnkiet" datasource="#get('loc').datasource.ankieta#" cachedwithin="#createTimeSpan(
				APPLICATION.cache.query.days,
				APPLICATION.cache.query.hours,
				APPLICATION.cache.query.minutes,
				APPLICATION.cache.query.seconds)#">
			select count(*) as c 
			from ankieta_definicjeAnkiet
			where dataObowiazywaniaOd < <cfqueryparam value="#Now()#" cfsqltype="cf_sql_date" />
				and dataObowiazywaniaDo > <cfqueryparam value="#Now()#" cfsqltype="cf_sql_date" /> 
		</cfquery>
		
		<cfreturn iloscAnkiet />
	</cffunction>
	
	<cffunction name="pobierzAktywnychUzytkownikow" output="false" access="public" hint="" returntype="query">
		<cfset var uzytkownicy = "" />
		<cfquery name="uzytkownicy" datasource="#get('loc').datasource.intranet#">
			select id, givenname, sn, companyemail, mail, photo, login 
			from users
			where active = 1;
		</cfquery>
		<cfreturn uzytkownicy />
	</cffunction>
	
	<cffunction name="pobierzUzytkownikaPoEmailu" output="false" access="public" hint="" returntype="query">
		<cfargument name="text" type="string" required="false" />
		
		<cfset var uzytkownik = "" />
		<cfquery name="uzytkownik" datasource="#get('loc').datasource.intranet#">
			select * from users 
			where LOWER(mail) = <cfqueryparam value="#lCase(arguments.text)#" cfsqltype="cf_sql_varchar" />
			and active = 1
			limit 1;
		</cfquery>
		
		<cfreturn uzytkownik />
	</cffunction>
	
	<cffunction name="iloscNowychMaterialowVideo" output="false" access="public" hint="" returntype="query">
		<cfargument name="userid" type="numeric" required="true" />
		
		<cfset var grupy = "" />
		<cfquery name="grupy" datasource="#get('loc').datasource.intranet#">
			select a.groupid, b.groupname from tree_groupusers a 
			inner join tree_groups b on a.groupid = b.id
			where a.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfquery name="video" datasource="#get('loc').datasource.mssql#">
			select count(distinct c.idMaterialuVideo) as c from video_kategorieMaterialow a
			inner join video_definicjeKategoriiMaterialow b on a.idDefinicjiKategoriiMaterialu = b.idDefinicjiKategoriiMaterialu
			inner join video_materialyVideo c on a.idMaterialuVideo = c.idMaterialuVideo
			where b.nazwaKategoriiMaterialu in ('#ValueList(grupy.groupname, "','")#')
			and c.dataPublikacji > <cfqueryparam value="#session.user.last_login#" cfsqltype="cf_sql_timestamp" /> 
		</cfquery>
		
		<cfreturn video />
	</cffunction>
	
</cfcomponent>