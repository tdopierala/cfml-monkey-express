<cfcomponent
	extends="Model">

	<cffunction 
		name="init" output="false" access="public" hint="">
		
		<cfset table("instruction_instructions") />
	</cffunction>
	
	<cffunction 
		name="getById" output="false" access="public" hint="">
		
		<cfargument name="id" type="numeric" required="true" />
		
		<cfset var instrukcja = "" />
		<cfquery name="instrukcja" datasource="#get('loc').datasource.intranet#">
			select id, department_name, instruction_number, filename from instruction_documents 
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn instrukcja />
	</cffunction>

	<cffunction 
		name="getAllInstructions" output="false" access="public" hint="Pobranie listy wszystkich instrukcji">

		<cfargument name="instructioncategoryid" type="numeric" default="0" true="false" />
		<cfargument name="datefrom" type="string" default="" required="false" />
		<cfargument name="dateto" type="string" default="" required="false" />
		<cfargument name="userid" type="numeric" default="0" required="true" />

		<cfstoredproc
			dataSource="#get('loc').datasource.intranet#"
			procedure="sp_intranet_get_instructions_by_user"
			returnCode="No">

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.instructioncategoryid#"
				dbVarName="@category_id" />

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR"
				value="#arguments.datefrom#"
				dbVarName="@date_from" />

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_VARCHAR"
				value="#arguments.dateto#"
				dbVarName="@date_to" />

			<cfprocparam
				type="in"
				CFSQLType="CF_SQL_INTEGER"
				value="#arguments.userid#"
				dbVarName="@user_id" />

			<cfprocresult name="instructions" resultSet="1" />

		</cfstoredproc>

		<cfreturn instructions />

	</cffunction>

	<!---
		27.09.2012
		Funkcjonalność wyszukiwania w instrukcjach.

		10.04.2013
		Zmieniono metodę wyszukującą instrukcje. Przy wyszukiwaniu są brane pod
		uwagę uprawnienia użytkownika.
	--->

	<cffunction
		name="createWhereCondition"
		hint="Metoda budująca warunek WHERE do wyszukiwania"
		returntype="String" >

		<cfargument
			name="search"
			type="array"
			required="true" />

		<cfif ArrayIsEmpty(arguments.search)>
			<cfreturn "1=1" />
		</cfif>

		<!---
			Przed samym zapytaniem znajduje się metoda tworząca
			odpowiedni warunek wyszukiwania. Warunek jest dość skomplikowany...
		--->
		<cfparam
			name="qWhere"
			default="" />

		<cfset qWhere = "" />

		<cfset qWhere &= " ( " />
		
		<cfloop array="#arguments.search#" index="i">
			<cfset qWhere &= " LOWER(`department_name`) like '%" & #LCase(i)# & "%' and " />
		</cfloop>

		<cfset qWhere = Left(qWhere, Len(qWhere)-4) & " ) or ( " />

		<cfloop array="#arguments.search#" index="i">
			<cfset qWhere &= " LOWER(`instruction_number`) like '%" & #LCase(i)# & "%' and " />
		</cfloop>

		<cfset qWhere = Left(qWhere, Len(qWhere)-4) & " ) or ( " />

		<cfloop array="#arguments.search#" index="i">
			<cfset qWhere &= " LOWER(`instruction_about`) like '%" & #LCase(i)# & "%' and " />
		</cfloop>
		
		<cfset qWhere = Left(qWhere, Len(qWhere)-4) & " ) or ( " />

		<cfloop array="#arguments.search#" index="i">
			<cfset qWhere &= " LOWER(`ocr`) like '%" & #LCase(i)# & "%' and " />
		</cfloop>

		<cfset qWhere = Left(qWhere, Len(qWhere)-4) & " ) " />
		<!---
			Koniec budowania odpowiedniego zapytania.
		--->

		<cfreturn #REReplace(qWhere, "''", "'", "ALL")# />

	</cffunction>

	<cffunction name="search" hint="Wyszukiwanie" description="Metoda odwołująca się do metody w bazie danych." returntype="Query" >

		<cfargument name="search" type="array" required="true" />
		<cfargument name="page" required="true" />
		<cfargument name="elements" default="20" required="false" />
		<cfargument name="userid" required="true" />
		<cfargument name="iorder" required="true" />
		<cfargument name="order" required="true" />
		<cfargument name="status" required="true" />

		<cfset var a = (arguments.page-1) * arguments.elements />

		<!---
			07.03.2013
			Zmieniam sposób wyszukiwania instrukcji. Polecenie SQL
			znajduje się po stronie intranetu.

			10.04.2013
			Zapytanie jest cachowane. Wyniki są stronicowane.
			Instrukcje są wyszukiwane wg uprawnień, które posiada użytkownik.
		--->
		<cfset var qISearch = "" />
		<cfset var rISearch = "" />
		<cfquery name="qISearch" result="rISearch" datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >

			<!---select distinct
				i.id as instruction_id
				,IF( INSTR(i.department_name, 'Departament ')>0,
					REPLACE(i.department_name, 'Departament ', ''), 
					REPLACE(i.department_name, 'Dział Kontroli i Nadzoru', 'DKiN')
				) as department_name 
				-- ,i.department_name as department_name
				,i.instruction_number as instruction_number
				,i.instruction_about as instruction_about
				,i.instruction_date_from as instruction_date_from
				,i.instruction_date_to as instruction_date_to
				,i.thumb_src as thumb_src
				,i.filename as filename
				,i.statusid as statusid
				,dc.documenttypename as documenttypename
				,iv.datetime as instruction_view
			from instruction_documents i
				inner join instruction_documenttypes dc on i.documenttypeid=dc.id
				left join instruction_viewers iv on iv.instructionid = i.id and iv.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			where
			--->
				
			select
				distinct  
				i.id as instruction_id
				,IF( INSTR(i.department_name, 'Departament ')>0,
					REPLACE(i.department_name, 'Departament ', ''), 
					REPLACE(i.department_name, 'Dział Kontroli i Nadzoru', 'DKiN')
				) as department_name
				,i.instruction_number as instruction_number
				,i.instruction_about as instruction_about
				,i.instruction_date_from as instruction_date_from
				,i.instruction_date_to as instruction_date_to
				-- ,i.instruction_created as instruction_created
				,i.thumb_src as thumb_src
				,i.filename as filename
				,i.statusid as statusid
				,c.documenttypename as documenttypename
				,d.statusname as statusname
				,iv.datetime as instruction_view
			from instruction_privileges a 
			inner join instruction_documents i on a.instructionid = i.id
			inner join instruction_documenttypes c on i.documenttypeid = c.id
			inner join instruction_statuses d on i.statusid = d.id
			left join instruction_viewers iv on iv.instructionid = i.id and iv.userid = <cfqueryparam value="#arguments.userid#" />
			where 
				a.groupid in (
					select distinct groupid from tree_groupusers
					where userid = <cfqueryparam value="#arguments.userid#" />
				)
				
				and 
			
				(
					#this.createWhereCondition(search = arguments.search)#
				) 
				
				<!---and
				(
					#sWhere(qU = qUser(userid = arguments.userid))#
				)--->
				
				and i.statusid = "#arguments.status#"
				
			order by #arguments.iorder# #arguments.order#
				
			limit #a#, <cfqueryparam value="#arguments.elements#" cfsqltype="cf_sql_integer" />

		</cfquery>

		<cfreturn qISearch />

	</cffunction>

	<cffunction name="searchCount" hint="Zliczenie wszystkich wyników wyszukiwania">
		<cfargument name="userid" required="true" />
		<cfargument name="search" type="array" required="true" />

		<cfquery name="qISearchCount" result="rISearchCount" datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >

			<!---select 
				count(i.id) as c,
				i.documenttypeid as documenttypeid,
				i.statusid as statusid
			from instruction_documents i
				inner join instruction_documenttypes dc on i.documenttypeid=dc.id
			where
				(

					#this.createWhereCondition(search = arguments.search)#

				) and
				(
					#sWhere(qU = qUser(userid = arguments.userid))#
				)
				-- and i.statusid = --->
				
			select
				count(distinct i.id) as c
				,i.documenttypeid as documenttypeid
				,i.statusid as statusid
			from instruction_privileges a 
			inner join instruction_documents i on a.instructionid = i.id
			inner join instruction_documenttypes c on i.documenttypeid = c.id
			inner join instruction_documenttypes dc on i.documenttypeid = dc.id
			inner join instruction_statuses d on i.statusid = d.id
			left join instruction_viewers iv on iv.instructionid = i.id and iv.userid = <cfqueryparam value="#arguments.userid#" />
			where 
				a.groupid in (
					select distinct groupid from tree_groupusers
					where userid = <cfqueryparam value="#arguments.userid#" />
				)
				
				and 
			
				(
					#this.createWhereCondition(search = arguments.search)#
				)
				
			group by dc.documenttypename, i.statusid
			order by i.statusid asc

		</cfquery>

		<cfreturn qISearchCount />

	</cffunction>

	<!---
		25.01.2013
		Pobieram listę użytkowników do których ma zostać wysłany email o nowej instrukcji.
	--->
	<cffunction
		name="getInstructionUsers"
		hint="Pobieram listę użytkowników, którym wyslany będzie email o nowym dok.">

		<cfargument
			name="condition"
			type="string"
			required="true" />
			
		<cfargument name="typeid" type="numeric" required="false" />
		
		<cfquery
			name="qInstructionUsers"
			result="rInstructionUsers"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >
							
			select 
				u.givenname as givenname
				,u.sn as sn
				,u.mail as mail
			from users u
			where #arguments.condition# and u.mail is not null
				
		</cfquery>
		
		<cfset var typeUsers = "" />
		<cfquery name="typeUsers" datasource="#get('loc').datasource.intranet#">
			select 
				u.givenname as givenname, 
				u.sn as sn,
				u.mail as mail
			from users u
			inner join store_stores s on (u.login = s.projekt and u.active = 1 and s.is_active = 1)
			where #arguments.condition# and u.mail is not null;
		</cfquery>
		
		<cfset var unionUsers = "" />
		<cfquery name="unionUsers" dbtype="query" >
			select * from qInstructionUsers
			union
			select * from typeUsers
		</cfquery> 

		<cfreturn unionUsers />

	</cffunction>

	<cffunction
		name="qUser"
		hint="Pobranie informacji o użytkowniku, które są używane w tym modelu."
		description="Prywatna metoda, która pobiera dane użytkownika odpowiedzialne
				za zbudowanie uprawnień do instrukcji. Metoda jest używana zarówno
				przy pobieraniu danych do widgetu jak i normalnego wyświetlania
				danych."
		access="private">

		<cfargument name="userid" type="numeric" required="true"/>

		<cfquery
			name="qU"
			result="rU"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				centrala
				,dyrektorzy
				,menadzer
				,partner_ds_ekspansji
				,partner_ds_sprzedazy
				,partner_prowadzacy_sklep
				,ifnull(date_from, Now()) as date_from
				,ifnull(date_to, Now()) as date_to
			from users
			where id = <cfqueryparam
							value="#arguments.userid#"
							cfsqltype="cf_sql_type" />
			limit 1

		</cfquery>

		<cfreturn qU />

	</cffunction>

	<cffunction
		name="sWhere"
		hint="Metoda zwracająca string z odpowiednimi uprawnieniami."
		description="Metoda na podstawie użytkownika, który został przekazany,
				zwraca string z jego uprawnieniami."
		access="private"
		returntype="String">

		<cfargument name="qU" type="query" 	required="true" />

		<cfparam name="qUWhere" default="" />
		<cfset qUWhere = "" />

		<cfif arguments.qU.centrala is 1>
			<cfset qUWhere &= " centrala = 1 or " />
		</cfif>

		<cfif arguments.qU.dyrektorzy is 1>
			<cfset qUWhere &= " dyrektorzy = 1 or " />
		</cfif>

		<cfif arguments.qU.menadzer is 1>
			<cfset qUWhere &= " menadzer = 1 or " />
		</cfif>

		<cfif arguments.qU.partner_ds_ekspansji is 1>
			<cfset qUWhere &= " partner_ds_ekspansji = 1 or " />
		</cfif>

		<cfif arguments.qU.partner_ds_sprzedazy is 1>
			<cfset qUWhere &= " partner_ds_sprzedazy = 1 or " />
		</cfif>

		<cfif arguments.qU.partner_prowadzacy_sklep is 1>
			<cfset qUWhere &= " partner_prowadzacy_sklep = 1 or " />
		</cfif>

		<!---
			Obcinam ostatnie OR jeżeli takie istnieje.
		--->
		<cfif Len(qUWhere) gte 4>
			<cfset qUWhere = Left(qUWhere, Len(qUWhere)-4) />
		</cfif>

		<cfreturn qUWhere />

	</cffunction>
	
	<cffunction name="widgetUserInstructions" hint="Lista Wewnętrznych aktów prawnych przypisanych do użytkownika" description="Zapytanie wykorzystywane w widgetach dostępnych dla wszystkich
				użytkowników systemu.">

		<!---
			8.04.2013
			Zapytanie pobierające dane do widgetu z wewnętrznymi aktami prawnymi,
			które są przypisane do użytkownika.
		--->

		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="page" type="numeric" required="false" default="1" />
		<cfargument name="elements" type="numeric" required="true" />
		<cfargument name="departmentName" type="string" default="" required="false" />
		<cfargument name="documentTypeId" type="any" default="" required="false" /> 
		<cfargument name="typeid" type="any" required="false" />
		
		<!--- 25.03.204
			Zmieniła się struktura uprawnień. Teraz pobieram instrukcje na podstawie grup z tree_groups.
		--->
		<cfset var a = (arguments.page - 1) * arguments.elements />
		<cfset var instrukcje = "" />
		<cfquery name="instrukcje" datasource="#get('loc').datasource.intranet#"
				 cachedwithin="#createTimeSpan(
					APPLICATION.cache.query.days,
					APPLICATION.cache.query.hours,
					APPLICATION.cache.query.minutes,
					APPLICATION.cache.query.seconds)#">
			select
				distinct  
				b.id as instruction_id
				,b.department_name as department_name
				,b.instruction_number as instruction_number
				,b.instruction_about as instruction_about
				,b.instruction_date_from as instruction_date_from
				,b.instruction_date_to as instruction_date_to
				,b.instruction_created as instruction_created
				,b.thumb_src as thumb_src
				,b.filename as filename
				,c.documenttypename as documenttypename
				,d.statusname as statusname
			from instruction_privileges a 
			inner join instruction_documents b on a.instructionid = b.id
			inner join instruction_documenttypes c on b.documenttypeid = c.id
			inner join instruction_statuses d on b.statusid = d.id
			where a.groupid in (
				select distinct groupid from tree_groupusers
				where userid = <cfqueryparam value="#arguments.userid#" />
			)
			and b.statusid = 1
			
			<!---<cfif arguments.typeid NEQ 0>
				and b.typeid = <cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />
			</cfif>--->
			
			<cfif Len(arguments.departmentName) NOT EQUAL 0>
				and b.department_name like <cfqueryparam value="%#arguments.departmentName#%" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			<cfif Len(arguments.documentTypeId) NOT EQUAL 0>
				and b.documenttypeid = <cfqueryparam value="#arguments.documentTypeId#" cfsqltype="cf_sql_integer" />
			</cfif>
			
			order by b.instruction_created desc
			limit #a#, #arguments.elements#;
		</cfquery>
		
		<cfreturn instrukcje />
	</cffunction>

	<cffunction name="statUserInstructions" hint="Liczba wewnętrznych aktów prawnych widoczna przez użytkownika">

		<!---
			4.04.2013
			Metoda pobierająca ilość wewnętrznych aktów prawnych, widocznych
			przez użytkownika.
			
			22.10.2013
			Metoda zwraca liczbę instrukcji, które pojawiły się od ostatniego
			logowania.
		--->
		<cfargument name="userid" type="numeric" required="true" />

		<!---
			4.04.2013
			Procedura zliczająca liczbę instrukcji jest o tyle kłopotliwa, że
			trzeba najpierw pobrać użytkownika, sprawdzić jakie ma uprawnienia
			i dopiero na tej podstawie zbudować odpowiednie zapytanie.

			Pierwsze zapytanie pobiera pojedyńczego użytkownika.
		--->
		<cfparam name="qU" type="query" default="#qUser(userid = arguments.userid)#" />

		<!---
			Na podstawie zwróconych informacji o użytkowniku buduje zapytanie.
		--->
		<cfparam name="qUWhere" default="" />
		<cfset qWhere = sWhere(qU = qUser(userid = arguments.userid)) />

		<cfquery
			name="query_stat_user_instructions"
			result="result_stat_user_instructions"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select count(id) as c
			from instruction_documents
			where (
					instruction_created between <cfqueryparam
												value="#qU.date_from#"
												cfsqltype="cf_sql_timestamp" />
										and <cfqueryparam
												value="#qU.date_to#"
												cfsqltype="cf_sql_timestamp" />
					)
			<cfif Len(qUWhere)>
				and (#qUWhere#)
			</cfif>

		</cfquery>

		<cfreturn query_stat_user_instructions />

	</cffunction>

	<cffunction name="userInstructionsCount" hint="Liczba aktów prawnych widoczna dla uzytkownika">
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="page" type="numeric" required="false" default="1" />
		<cfargument name="elements" type="numeric" required="true" />
		<cfargument name="departmentName" type="string" default="" required="false" />
		<cfargument name="documentTypeId" type="any" default="" required="false" /> 
		<cfargument name="typeid" type="numeric" default="0" required="false" />

		<!--- Na podstawie zwróconych informacji o użytkowniku buduje zapytanie. --->
		<cfparam name="qUWhere" default="" />
		<cfset qWhere = sWhere(qU = qUser(userid = arguments.userid)) />

		<cfset var instrukcje = "" />
		<cfquery name="instrukcje" datasource="#get('loc').datasource.intranet#"
				 cachedwithin="#createTimeSpan(
					APPLICATION.cache.query.days,
					APPLICATION.cache.query.hours,
					APPLICATION.cache.query.minutes,
					APPLICATION.cache.query.seconds)#">
			select
				count(distinct  
				b.id) as c
			from instruction_privileges a 
			inner join instruction_documents b on a.instructionid = b.id
			inner join instruction_documenttypes c on b.documenttypeid = c.id
			inner join instruction_statuses d on b.statusid = d.id
			where a.groupid in (
				select distinct groupid from tree_groupusers 
				where userid = <cfqueryparam value="#arguments.userid#" />
			) 
			and b.statusid = 1
			
			<!---<cfif arguments.typeid NEQ 0>
				and b.typeid = <cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_integer" />
			</cfif>--->
			
			<cfif Len(arguments.departmentName) NOT EQUAL 0>
				and b.department_name like <cfqueryparam value="%#arguments.departmentName#%" cfsqltype="cf_sql_varchar" />
			</cfif>
			
			<cfif Len(arguments.documentTypeId) NOT EQUAL 0>
				and b.documenttypeid = <cfqueryparam value="#arguments.documentTypeId#" cfsqltype="cf_sql_integer" />
			</cfif>
			
		</cfquery>

		<cfreturn instrukcje />

	</cffunction>
	
	<cffunction name="toArchive" output="false" access="public" hint="" returntype="void" >
		<cfargument name="documents" type="string" required="true" />
		
		<!---
			Dziele string po przecinku
		--->
		<cfset documentsArray = listToArray(arguments.documents, ",;.", false) />
		<cfloop array="#documentsArray#" index="i">
			<cfset var updateInstruction = "" />
			<cfquery name="updateInstruction" datasource="#get('loc').datasource.intranet#">
				update instruction_documents 
				set statusid = 2 
				where instruction_number = <cfqueryparam value="#Trim(i)#" cfsqltype="cf_sql_varchar" />; 
			</cfquery>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getExpiredInstructions" output="false" returntype="Query" access="public" hint="">
	
		<cfset var expireToday = "" />
		<cfquery name="expireToday" datasource="#get('loc').datasource.intranet#">
			select instruction_number 
			from instruction_documents
			where instruction_date_to is not null
				and Year(instruction_date_to) = Year(Now())
				and Month(instruction_date_to) = Month(Now())
				and Day(instruction_date_to) = Day(Now())
		</cfquery> 
		
		<cfreturn expireToday />
	
	</cffunction>
	
	<cffunction name="addPrivileges" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfargument name="groups" type="string" required="true" />
		
		<cfset var newPrivilege = "" />
		<cfloop list="#arguments.groups#" index="i" >
			<cfquery name="newPrivilege" datasource="#get('loc').datasource.intranet#">
				 insert into instruction_privileges(groupid, instructionid) values (
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
		
		<!--- Pobieram link do instrukcji do dodania w powiadomieniu --->
		<cfset var instrukcja = "" />
		<cfquery name="instrukcja" datasource="#get('loc').datasource.intranet#">
			select id, department_name, instruction_number, filename from instruction_documents 
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfset var usersList = "" />
		
		<cfquery name="usersList" dbtype="query">
			select distinct mail, sn, givenname from users;
		</cfquery>
		
		<cfloop query="usersList">
			<cfmail to="#mail#" cc="intranet@monkey.xyz" from="Monkey<intranet@monkey.xyz>"
				replyto="intranet@monkey.xyz" subject="Wewnętrzne akty prawne" type="html"> 
				<cfoutput>
					Witaj #sn# #givenname#,<br />
			
					W systemie Intranet pojawił się nowy dokument w Wewnętrznych Aktach Prawnych. Aby się z nim zapoznać, przejdź na adres http://intranet.monkey.xyz lub skorzystaj z poniższego odnośnika.

					<br />
					<br />
					
					<a href="http://intranet.monkey.xyz/intranet/files/instructions/#instrukcja.filename#">http://intranet.monkey.xyz/intranet/instructions/#instrukcja.filename#</a>
					
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
	
	<cfscript>	
	 function stringToBinary( String stringValue ){
 
var binaryValue = charsetDecode( stringValue, "utf-8" );
 
return( binaryValue );
 
}
 
 
function binaryToString( Any binaryValue ){
 
var stringValue = charsetEncode( binaryValue, "utf-8" );
 
return( stringValue );
 
}
</cfscript>
</cfcomponent>