<cfcomponent extends="Model">
	<cfproperty name="months" type="any" />
	<cfproperty name="years" type="any" />

<cfset variables.globalSql = "select
workflowid,
documentid,
workflowcreated,
documentname,
stepdescriptionid,
stepdescriptiondraft,
stepcontrollingid,
stepcontrollingdraft,
stepapproveid,
stepapproveddraft,
stepaccountingid,
stepaccountingdraft,
stepacceptid,
stepacceptdraft,
stependid,
endeddate,
contractorname
from trigger_workflowsteplists" />

	<cffunction name="init">

		<cfset belongsTo("user") />
		<cfset belongsTo("document") />
		<cfset hasOne("workflowStep") />

		<!---<cfset variables.instance.months = arrayNew(1) />
		<cfset variables.instance.months[1] = "Styczeń" />
		<cfset variables.instance.months[2] = "Luty" />
		<cfset variables.instance.months[3] = "Marzec" />
		<cfset variables.instance.months[4] = "Kwiecień" />
		<cfset variables.instance.months[5] = "Maj" />
		<cfset variables.instance.months[6] = "Czerwiec" />
		<cfset variables.instance.months[7] = "Lipiec" />
		<cfset variables.instance.months[8] = "Sierpień" />
		<cfset variables.instance.months[9] = "Wrzesień" />
		<cfset variables.instance.months[10] = "Październik" />
		<cfset variables.instance.months[11] = "Listopad" />
		<cfset variables.instance.months[12] = "Grudzień" />--->
		
		<cfset variables.instance = {
			months = arrayNew(1),
			years = {
				2012	=	"2012",
				2013	=	"2013",
				2014	=	"2014",
				2015	=	"2015"}
			} />
		
		<cfset variables.instance.months[1] = "Styczeń" />
		<cfset variables.instance.months[2] = "Luty" />
		<cfset variables.instance.months[3] = "Marzec" />
		<cfset variables.instance.months[4] = "Kwiecień" />
		<cfset variables.instance.months[5] = "Maj" />
		<cfset variables.instance.months[6] = "Czerwiec" />
		<cfset variables.instance.months[7] = "Lipiec" />
		<cfset variables.instance.months[8] = "Sierpień" />
		<cfset variables.instance.months[9] = "Wrzesień" />
		<cfset variables.instance.months[10] = "Październik" />
		<cfset variables.instance.months[11] = "Listopad" />
		<cfset variables.instance.months[12] = "Grudzień" />

	</cffunction>

	<!---
	Pobieram listę obiegu dokumentów i konwertuje ją do json.
	Metoda jest wykorzystywana do generowania tabelki ExtJS
	--->
	<cffunction name="getWorkflowsList" output="no" access="remote" returnFormat="json"
								hint="Zwrócenie listy obiegu dokumentów w formacie JSON">

		<cfset workflows = model("workflowStep").findAll(include="workflow,document,workflowStepStatus,workflowStatus")>
		<cfreturn workflows>

	</cffunction>

	<cffunction name="getWorkflowsListJson" output="no" returnFormat="json" hint="">

		<cfset variable.workflowsList = getWorkflowsList()>
		<cfset workflows = QueryToStruct(variable.workflowsList)>
		<cfreturn workflows>

	</cffunction>

	<!---
	Lista kroków przy obiegu dokumentów, które są przypisane do użytkownika.
	Zwracane dane są w formacie json.
	--->
	<cffunction name="getUserAssignedWorkflowJson" output="no" returnFormat="json"
								hint="Lista dokumentów, które są w obiegu dla danego użytkownika. Dokłądniej rzecz biorąc
								metoda zwraca kroki przypisane do użytkownika dla odpowiedniego dokumentu w obiegu.">

		<cfargument name="userid" default="-1" type="numeric" hint="Identyfikator użytkownika, którego zadania są pobierane" />
		<cfargument name="workflowstatusid" default="-1" type="numeric" hint="Status kroku: W trakcie lub Zamknięty" />

		<cfset userassignedworkflow = model("workflowStep").findAll(where="userid=#arguments.userid#",include="workflowStepStatus,document,workflowStatus") />

<!--- 		<cfdump var="#userassignedworkflow#"> --->
<!--- 		<cfabort> --->

		<cfset variable.temp = QueryToStruct(userassignedworkflow)>
		<cfreturn variable.temp>

	</cffunction>

	<!---
	getUserActiveWorkflow
	---------------------------------------------------------------------------------------------------------------
	Lista aktywnych dokumentów przypisanych do użytkownika.

	--->
	<cffunction name="getUserActiveWorkflow" returnFormat="json" output="no" hint="Pobieranie aktywnych dokumentów w obiegu przypisanych do uzytkownika">

		<cfargument name="userid" default="0" type="numeric" hint="Identyfikator użytkownika, którego dokumenty są pobierane" />

		<cfset workflowids = model("workflowStep").findAll(where="userid=#arguments.userid# AND workflowstatusid=1",distinct=true,select="workflowid")/>

		<cfset loc.ids = "null," />
		<cfloop query="workflowids">
			<cfset loc.ids = "#loc.ids##workflowid#," />
		</cfloop>

		<cfif Len(loc.ids) gt 0>
			<cfset loc.ids = Left(loc.ids, Len(loc.ids)-1)>
		</cfif>


		<cfquery
			name = "get_user_active_workflow"
			dataSource = "#get('loc').datasource.intranet#" >

			#variables.globalSql# where workflowid in (#loc.ids#)

		</cfquery>

<!--- 		<cfreturn get_user_active_workflow /> --->
		<cfreturn QueryToStruct(get_user_active_workflow) />

	</cffunction>

	<!---
	Metoda zwracająca listę aktywnych dokumentów w formie query
	--->
	<cffunction name="getUserActiveWorkflowQuery" returnFormat="json" output="no" hint="Pobieranie aktywnych dokumentów w obiegu przypisanych do uzytkownika">

		<cfargument name="userid" default="0" type="numeric" hint="Identyfikator użytkownika, którego dokumenty są pobierane" />
		<cfargument name="typeid" default="-1" type="numeric" hint="Identyfikator typu faktur do pobrania" required="false" />

		<cfset workflowids = model("workflowStep").findAll(where="userid=#arguments.userid# AND workflowstatusid=1",distinct=true,select="workflowid")/>

		<cfset loc.ids = "null," />
		<cfloop query="workflowids">
			<cfset loc.ids = "#loc.ids##workflowid#," />
		</cfloop>

		<cfif Len(loc.ids) gt 0>
			<cfset loc.ids = Left(loc.ids, Len(loc.ids)-1)>
		</cfif>


		<cfquery
			name = "get_user_active_workflow"
			dataSource = "#get('loc').datasource.intranet#" >

			#variables.globalSql# where workflowid in (#loc.ids#)

			<!--- Dodaje warunek pobierania odpowiedniego typu dokumentów --->
			<cfif arguments.typeid neq -1>
				and typeid = #arguments.typeid#
			</cfif>

		</cfquery>

		<cfreturn get_user_active_workflow />
<!--- 		<cfreturn QueryToStruct(get_user_active_workflow) /> --->

	</cffunction>


	<!---
		Lista wszystkich dokumentów przypisanych do użytkownika.

		20.12.2012
		Zmodyfikowałem metodę. Zamiast wykonywać polecenia SQL napisałem procedurę.
		Procedura zwraca paginowane dane. W tabeli trigger_workflowsteplists utworzyłem
		indeks na kolumnie workflowid.
	--->
	<cffunction name="getUserWorkflow">

		<cfargument name="userid" default="0" type="numeric" hint="Identyfikator użytkownika, którego dokumenty są pobierane" />
		<cfargument name="page" type="numeric" default="1" required="false" />
		<cfargument name="elements" type="numeric" required="true" /> 
		<cfargument name="year" type="numeric" required="true" />
		<cfargument name="month" type="numeric" required="true" />
		<cfargument name="categoryid" type="numeric" required="true" />
		<cfargument name="all" type="numeric" required="true" />
		
		<cfset a = (arguments.page-1)*arguments.elements />
		<cfset b = (arguments.page*arguments.elements) />

		<cfset var qWorkflows = "" />
		<cfquery name="qWorkflows" datasource="#get('loc').datasource.intranet#">
			select 
				distinct ws.workflowid,
				w.documentid, 
				w.workflowcreated,
				w.documentname,
				w.stepdescriptionid,
				w.stepdescriptiondraft,
				w.stepcontrollingid,
				w.stepcontrollingdraft,
				w.stepapproveid,
				w.stepapproveddraft,
				w.stepaccountingid,
				w.stepaccountingdraft,
				w.stepacceptid,
				w.stepacceptdraft,
				w.stependid,
				w.endeddate,
				w.contractorname,
				wfl.todelete
			from workflowsteps ws 
				inner join workflows wfl on ws.workflowid = wfl.id
				inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
				inner join documents d on d.id = wfl.documentid
			where ws.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			
				<cfif arguments.all NEQ 1>
					and Year(w.workflowcreated) = <cfqueryparam value="#arguments.year#" cfsqltype="cf_sql_integer" />  
					and Month(w.workflowcreated) = <cfqueryparam value="#arguments.month#" cfsqltype="cf_sql_integer" />
				
					<cfif arguments.categoryid NEQ 0>
						and d.categoryid = <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />
					</cfif>  
				</cfif>
				
			order by w.workflowid desc 
			limit #a#, #arguments.elements#
		</cfquery>

		<cfreturn qWorkflows />
	</cffunction>

	<cffunction
		name="getUserWorkflowCount"
		hint="Metoda zwracająca liczbę wszystkich dokumentów z obiegu przypisaną użytkownikowi."
		description="Metoda zwracająca liczbę wszystkich dokumentów z obiegu przypisaną
				użytkownikowi. Wartość jest wykorzystywana do zbudowania paginacji." >

		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="year" type="numeric" required="true" />
		<cfargument name="month" type="numeric" required="true" />
		<cfargument name="categoryid" type="numeric" required="true" />
		<cfargument name="all" type="numeric" required="true" />
		
		<cfset var qCount = "" />
		<cfquery name="qCount" datasource="#get('loc').datasource.intranet#">

			<cfif IsDefined("arguments.all") AND arguments.all EQ 1>
				select 
					distinct count(w.workflowid) as c
				from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
				where ws.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			
			<cfelseif IsDefined("arguments.categoryid") AND arguments.categoryid NEQ 0>
				
				select 
					distinct count(w.workflowid) as c
				from workflowsteps ws inner 
					join trigger_workflowsteplists w on ws.workflowid = w.workflowid
					inner join documents d on ws.documentid = d.id
				where 
					ws.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					and Year(w.workflowcreated) = <cfqueryparam value="#arguments.year#" cfsqltype="cf_sql_integer" />
					and Month(w.workflowcreated) = <cfqueryparam value="#arguments.month#" cfsqltype="cf_sql_integer" />
					and d.categoryid = <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />
			
			<cfelse>
				
				select 
					distinct count(w.workflowid) as c
				from workflowsteps ws inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
				where 
					ws.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
					and Year(w.workflowcreated) = <cfqueryparam value="#arguments.year#" cfsqltype="cf_sql_integer" />
					and Month(w.workflowcreated) = <cfqueryparam value="#arguments.month#" cfsqltype="cf_sql_integer" />
				
			</cfif>
	 
		</cfquery>
		
		<cfreturn qCount />

	</cffunction>

	<!---

	---------------------------------------------------------------------------------------------------------------


	--->
	<cffunction name="getWorkflowByStep" hint="Pobieranie dokumentów w obiegu z danego etapu">

		<cfargument name="step" default="0" type="string" />

		<!--- Identyfikatory obiegu dokumentów --->
		<cfset loc.ids = "null," />

		<cfswitch expression="#arguments.step#">

			<cfcase value="description">
				<cfset workflowids = model("workflowStep").findAll(select="workflowid",distinct=true,where="workflowstepstatusid=1 AND workflowstatusid=1")/>
			</cfcase>

			<cfcase value="controlling">
				<cfset workflowids = model("workflowStep").findAll(select="workflowid",distinct=true,where="workflowstepstatusid=2 AND workflowstatusid=1")/>
			</cfcase>

			<cfcase value="commit">
				<cfset workflowids = model("workflowStep").findAll(select="workflowid",distinct=true,where="workflowstepstatusid=3 AND workflowstatusid=1")/>
			</cfcase>

			<cfcase value="approval">
				<cfset workflowids = model("workflowStep").findAll(select="workflowid",distinct=true,where="workflowstepstatusid=5 AND workflowstatusid=1")/>
			</cfcase>

			<cfcase value="accounting">
				<cfset workflowids = model("workflowStep").findAll(select="workflowid",distinct=true,where="workflowstepstatusid=4 AND workflowstatusid=1")/>
			</cfcase>

			<cfcase value="archive">
				<cfset workflowids = model("workflowStep").findAll(select="workflowid",distinct=true,where="workflowstepstatusid=5 AND workflowstatusid=2")/>
			</cfcase>

			<!---
			Zapytanie pobierające wszystkie aktywne dokumenty w obiegu.
			Aktynymi dokumentami są te, które jeszcze nie zostały zamknięte przez księgowość.
			--->
			<cfdefaultcase>
				<cfset workflowids = model("workflowStep").findAll(select="workflowid",distinct=true,where="workflowstatusid=1",order="workflowstepcreated DESC") />
			</cfdefaultcase>

		</cfswitch>

		<cfloop query="workflowids">
			<cfset loc.ids = "#loc.ids##workflowid#," />
		</cfloop>

		<cfif Len(loc.ids) gt 0>
			<cfset loc.ids = Left(loc.ids, Len(loc.ids)-1)>
		</cfif>


		<cfquery
			name = "get_workflow_by_step"
			dataSource = "#get('loc').datasource.intranet#" >

			#variables.globalSql# where workflowid in (#loc.ids#)

		</cfquery>

		<cfreturn get_workflow_by_step />
<!--- 		<cfreturn QueryToStruct(get_workflow_by_step) /> --->

	</cffunction>

	<cffunction
		name="getChairmanActiveWorkflow"
		hint="Metoda pobierająca aktywne dokumenty prezesa"
		description="Metoda pobierająca aktywne dokumenty prezesa. Tabelka Prezesa będzie się różnić od zwykłej.">

<!--- 		<cfset rows = model("viewChairmanWorkflow").findAll(where="status=1",maxRows=20) /> --->
		<cfset rows = model("triggerWorkflowStepList").findAll(where="stepacceptid=1") />
		<cfreturn rows />

	</cffunction>

	<cffunction
		name="getNote"
		hint="Pobranie wpisów do notki dekretacyjnej"
		returnType="query">

		<cfargument name="company_code" type="string" default="" required="false" />
		<cfargument name="karta_korespondencji" type="string" default="" required="true" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.asseco#"
			procedure = "wusr_sp_intranet_linijki_dowodu_by_karta_korespondencji"
			returnCode = "yes">

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_VARCHAR"
				value = "#arguments.company_code#"
				dbVarName = "@company_code" />

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_VARCHAR"
				value = "#arguments.karta_korespondencji#"
				dbVarName = "@karta_korespondencji" />

			<cfprocresult name="indexes" resultSet="1" />

		</cfstoredproc>

		<cfreturn indexes />

	</cffunction>

	<!---
		19.11.2012
		Procedura na bazie pobierająca listę najnowszych aktywnych dokumentów użytkownika.
		Procedura jest wykorzystywana do pobierania listy faktur w profilu usera.
	--->
	<cffunction
		name="v2_getUserLastActiveWorkflow"
		hint="Nowa procedura pobierająca listę aktywnych dokumentów. Dane są pobierane do strony profilowej użytkownika.">

		<cfargument name="userid" type="numeric" default="0" required="true" />
		<cfargument name="page" type="numeric" default="1" required="false" />
		<cfargument name="num" type="numeric" default="12" required="false" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_workflow_get_user_active_workflow"
			returnCode = "no">

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.userid#"
				dbVarName = "@user_id" />

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

			<cfprocresult name="workflows" resultSet="1" />

		</cfstoredproc>

		<cfreturn workflows />

	</cffunction>

	<!---
		Pobranie miesięcy do filtrowania dokumentów w obiegu.
	--->
	<cffunction name="getMonths" hint="Funkcja zwracająca listę miesięcy do filtrowania faktur">
		<cfreturn variables.instance.months />
	</cffunction>

	<!---
		Pobranie lat do filtrowania dokumentów w obiegu.
	--->
	<cffunction name="getYears" hint="Funkcja zwracająca listę lat"> 
		<cfreturn variables.instance.years />
	</cffunction>

	<cffunction
		name="v2_getUserActiveWorkflow"
		hint="Pobranie listy dokuemntów w obiegu dla danego użytkownika."
		description="Procedura została zmieniona w celu optymalizacji zapytań.
				Zwracanych jest kilkanaście rekordów a nie wszystkie jak to 
				miało miejsce wcześnij. 
				Z dniem 18.06.2013 szlak trafił procedure :). Teraz zaszyte jest 
				zapytanie SQL w modelu.">

		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="year" type="numeric" required="true" />
		<cfargument name="month" type="numeric" required="true" />
		<cfargument name="page" type="numeric" required="true" />
		<cfargument name="elements" type="numeric" required="true" />
		<cfargument name="categoryid" type="numeric" required="false" default="0" />
		<cfargument name="all" type="numeric" required="true" /> 
		<cfargument name="automated" type="numeric" required="true" />
		
		<cfset a = (arguments.page-1)*arguments.elements />
		
		<cfquery
			name="qActiveWorkflow"
			result="rActiveWorkflow"
			datasource="#get('loc').datasource.intranet#">
		
		select 
			distinct ws.workflowid,
			w.documentid, 
			w.workflowcreated,
			w.documentname,
			w.stepdescriptionid,
			w.stepdescriptiondraft,
			w.stepcontrollingid,
			w.stepcontrollingdraft,
			w.stepapproveid,
			w.stepapproveddraft,
			w.stepaccountingid,
			w.stepaccountingdraft,
			w.stepacceptid,
			w.stepacceptdraft,
			w.stependid,
			w.endeddate,
			w.contractorname,
			w.brutto,
			w.workflowstepnote,
			wfl.todelete as todelete,
			wfl.workflowcreated as workflowcreated
		from workflowsteps ws 
			inner join workflows wfl on ws.workflowid = wfl.id
			inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
			inner join documents d on ws.documentid = d.id
	
		<cfif arguments.all EQ 1>
			
			where ws.workflowstatusid=1 
				and ws.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> 
				
			order by w.workflowid desc
			
		<cfelse>
			
			where ws.workflowstatusid=1
				and ws.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" /> 
				and Year(w.workflowcreated) = <cfqueryparam value="#arguments.year#" cfsqltype="cf_sql_integer" /> 
				and Month(w.workflowcreated) = <cfqueryparam value="#arguments.month#" cfsqltype="cf_sql_integer" />
			
			<cfif arguments.categoryid NEQ 0>
				and d.categoryid = <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />
			</cfif>
				
			order by w.workflowid desc 
			limit #a#, <cfqueryparam value="#arguments.elements#" cfsqltype="cf_sql_integer" /> 
			
		</cfif>

		</cfquery>

		<cfreturn qActiveWorkflow />

	</cffunction>

	<!---
		Zliczenie wszystkich aktywnych dokumentów przypisanych do użytkownika.
	--->
	<cffunction
		name="v2_getUserActiveWorkflowCount"
		hint="Liczba wszystkich aktywnych dokumentów użytkownika."
		description="Metoda obliczająca ilość wszystkich aktywnych dokumentów uzytkownika.
			Metoda jest potrzebna do zbudowania paginacji">

		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="year" type="numeric" required="true" />
		<cfargument name="month" type="numeric" required="true" />
		<cfargument name="categoryid" type="numeric" default="0" required="false" />
		<cfargument name="all" type="numeric" required="true" />
		<cfargument name="automated" type="numeric" required="true" />

		<cfset var qCount = "" />
		<cfquery name="qCount" datasource="#get('loc').datasource.intranet#">
			
			select distinct count(ws.workflowid) as c
			from workflowsteps ws
				inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
				inner join documents d on d.id = w.documentid
			where
				1=1
			<cfif IsDefined("arguments.all") and arguments.all EQ 1>
				and ws.workflowstatusid = 1 
				and ws.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			<cfelse>
				
				and ws.workflowstatusid = 1
				and ws.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				and Year(w.workflowcreated) = <cfqueryparam value="#arguments.year#" cfsqltype="cf_sql_integer" />
				and Month(w.workflowcreated) = <cfqueryparam value="#arguments.month#" cfsqltype="cf_sql_integer" />
				
				<cfif IsDefined("arguments.categoryid") AND arguments.categoryid NEQ 0>
					and d.categoryid = <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />
				</cfif>
				
			</cfif>
			
		</cfquery>

		<cfreturn qCount />

	</cffunction>

	<!---
		Pobranie wszystkich dokumentów, które są w obiegu. Dokumenty są filtrowane po
		roku i miesiącu. Dodatkowo filtruje po etapie, na którym jest aktualnie dokument.
	--->
	<cffunction
		name="getWorkflow"
		hint="Metoda pobierająca listę wszystkich dokumentów, które są w obiegu.
		Wyniki są filtrowane po roku, miesiącu i etapie">

		<cfargument
			name="year"
			type="numeric"
			required="true" />

		<cfargument
			name="month"
			type="numeric"
			required="true" />

		<cfargument
			name="step"
			type="numeric"
			required="true" />

		<cfargument
			name="page"
			type="numeric"
			required="true" />

		<cfargument
			name="elements"
			type="numeric"
			required="true" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_workflow_get_all_documents_in_workflow_v2"
			returnCode = "no">

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.year#"
				dbVarName = "@_year" />

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.month#"
				dbVarName = "@_month" />

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.step#"
				dbVarName = "@_step" />

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.page#"
				dbVarName = "@_page" />

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.elements#"
				dbVarName = "@_elements" />

			<cfprocresult name="workflow" resultSet="1" />

		</cfstoredproc>

		<cfreturn workflow />

	</cffunction>

	<!---
		Zliczenie wszystkich dokumentów w obiegu.
		Metoda potrzebna do wygenerowania linków w paginacji.
	--->
	<cffunction
		name="getWorkflowCount"
		hint="Metoda generująca liczbę wszystkich dokumentów w obiegu, które spełniają
			filtr">

		<cfargument
			name="year"
			type="numeric"
			required="true" />

		<cfargument
			name="month"
			type="numeric"
			required="true" />

		<cfargument
			name="step"
			type="numeric"
			required="true" />

		<cfstoredproc
			dataSource = "#get('loc').datasource.intranet#"
			procedure = "sp_intranet_workflow_get_all_documents_in_workflow_count_v2"
			returnCode = "no">

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.year#"
				dbVarName = "@_year" />

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.month#"
				dbVarName = "@_month" />

			<cfprocparam
				type = "in"
				CFSQLType = "CF_SQL_INTEGER"
				value = "#arguments.step#"
				dbVarName = "@_step" />

			<cfprocresult name="workflowcount" resultSet="1" />

		</cfstoredproc>

		<cfreturn workflowcount />

	</cffunction>
	
	<!---
		28.05.2013
		Metoda sprawdzająca, czy są już w systemie faktury przypisane do danego
		kontrahenta i mająca określony numer zewnętrzny.
		
		Metoda zwraca dane w formacie json.
	--->
	<cffunction
		name="findSimilarInstance"
		hint="Znajdowanie podobnych faktur w intranecie">
			
		<cfargument
			name="invoice"
			type="string"
			required="true"
			hint="Numer zewnętrzny faktury" />
		
		<cfargument
			name="logo"
			type="string"
			required="true"
			hint="Numer logo reprezentujący kontrahenta" />
			
		<cfargument
			name="nazwa1"
			type="string"
			required="true"
			hint="Pole nazwa1 kontrahenta" />
			
		<cfargument
			name="nip"
			type="string"
			required="true"
			hint="Numer nip kontrahenta" />
			
		<cfquery
			name="qSimilarWorkflows"
			result="rSimilarWorkflows"
			datasource="#get('loc').datasource.intranet#">
				
			select 
				numer_faktury, 
				workflowid,
				documentid,
				numer_faktury_zewnetrzny,
				data_wplywu
			from trigger_workflowsearch
			where numer_faktury_zewnetrzny like <cfqueryparam value="%#arguments.invoice#%" cfsqltype="cf_sql_varchar" />
				and nip like <cfqueryparam value="%#arguments.nip#%" cfsqltype="cf_sql_varchar" />
				and nazwa1 like <cfqueryparam value="%#arguments.nazwa1#%" cfsqltype="cf_sql_varchar" /> 
				
		</cfquery> 
		
		<cfreturn qSimilarWorkflows />
			
	</cffunction>

	<cffunction
		name="widgetUserWorkflow"
		hint="Dokumenty w obiegu przypisane do użytkownika"
		description="Zapytanie jest wykorzystywane w widgecie z fakturami w
				obiegu.">
		<!---
			8.04.2013
			Zapytanie pobierające dokumenty z obiegu przypisane do użytkownika.
			Zapytanie jest wykożystywane w widgecie dostępnym dla pracowników
			Centrali
		--->
		<cfargument
			name="userid"
			type="numeric"
			required="true" />

		<cfquery
			name="qUWorkflow"
			result="rUWorkflow"
			datasource="#get('loc').datasource.intranet#">

			select
				distinct ws.workflowid,
				w.documentid,
				w.workflowcreated,
				w.documentname,
				w.stepdescriptionid,
				w.stepdescriptiondraft,
				w.stepcontrollingid,
				w.stepcontrollingdraft,
				w.stepapproveid,
				w.stepapproveddraft,
				w.stepaccountingid,
				w.stepaccountingdraft,
				w.stepacceptid,
				w.stepacceptdraft,
				w.stependid,
				w.endeddate,
				w.contractorname,
				wfl.todelete
			from workflowsteps ws
				inner join workflows wfl on ws.workflowid = wfl.id
				inner join trigger_workflowsteplists w on ws.workflowid = w.workflowid
			where ws.workflowstatusid=1 and ws.userid = <cfqueryparam
															value="#arguments.userid#"
															cfsqltype="cf_sql_integer" />
			order by w.workflowid desc
			limit 12

		</cfquery>

		<cfreturn qUWorkflow />

	</cffunction>

	<!---
		3.04.2013
		Zliczam ilość faktur przypisanych do użytkownika.
		Zapytanie jest cachowane raz na 15 minut. Ma to przyspieszyć
		proces ładowania strony użytkownika. Informacja jest wyświetlana
		w lewym pasku profilu użytkownika.

		TODO
		Przejść przez wszystkie metody w modelu i usunąć te, które nie są
		używane w aplikacji. Wydaje mi się, że górna część pliku
		zawiera wpisy, które już nie są wywoływane w kodzie.
	--->
	<cffunction
		name="statUserWorkflow"
		hint="Liczba faktur przypisanych do użytkownika.">

		<cfargument
			name="userid"
			type="numeric" />

		<cfquery
			name="query_get_user_workflow"
			result="result_get_user_workflow"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				count(id) as c
			from workflowsteps
			where userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
				and workflowstatusid = 1

		</cfquery>

		<cfreturn query_get_user_workflow />

	</cffunction>

	<!---
		15.04.2013
		Zapytanie zliczające ilość faktur na każdym etapie.
	--->
	<cffunction
		name="widgetWorkflowByStep"
		hint="Raport z ilości faktur na kazdym etapie"
		description="Zapytanie zliczające ilość faktur na każdym etapie">

		<cfquery
			name="qWidgetByStep"
			result="rWidgetByStep"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >

			select
				count(w.id) as c
				,w.workflowstepstatusid
				,ws.workflowstepstatusname
			from workflowsteps w
			inner join workflowstepstatuses ws on w.workflowstepstatusid = ws.id
			where w.workflowstatusid = 1
			group by w.workflowstepstatusid;

		</cfquery>

		<cfreturn qWidgetByStep />

	</cffunction>

	<cffunction
		name="widgetWorkflowByDepartmentMember"
		hint="Liczba dokumentów w obiegu przypisana do pracowników departamentu"
		description="Zapytanie generujące ilość faktur przypisaną do każdego
				pracownika departamentu. Zapytanie jest dostępne tylko dla
				dyrektorów aby mogli kontrolować swój zespół.">

		<cfargument
			name="userid"
			type="numeric"
			required="true" />

		<cfquery
			name="qU"
			result="rU"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select givenname, sn from users where id = <cfqueryparam
															value="#arguments.userid#"
															cfsqltype="cf_sql_integer" /> limit 1

		</cfquery>

		<cfquery
			name="qWDepartment"
			result="rWDepartment"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				count(w.id) as c
				,CONCAT(u.givenname, ' ', u.sn) as user
			from workflowsteps w
			inner join users u on w.userid = u.id
			where w.workflowstatusid = 1 and u.manager like <cfqueryparam
																value="CN=#qU.givenname# #qU.sn#%"
																cfsqltype="cf_sql_varchar" />
			group by w.userid

		</cfquery>

		<cfreturn qWDepartment />

	</cffunction>
	
	<cffunction name="getStepUser" output="false" returntype="Numeric" access="public" hint="" >
		<cfargument name="workflowid" type="numeric" required="true" />
		<cfargument name="stepid" type="any" required="true" />
		
		<cfset var getStepUser = "" />
		<cfquery name="getStepUser" datasource="#get('loc').datasource.intranet#">
			select userid 
			from workflowsteps 
			where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer">
				and workflowstepstatusid = <cfqueryparam  value="#arguments.stepid#" cfsqltype="cf_sql_integer" />
			order by workflowstepended desc
			limit 1
		</cfquery>
		
		<cfreturn getStepUser.userid />
	</cffunction>
	
	<cffunction name="markToDelete" output="false" access="public" hint="">
		<cfargument name="workflowid" type="numeric" required="true" />
		<cfargument name="documentid" type="numeric" required="true" />
		
		<cfset var qToDel = "" />
		<cfquery name="qToDel" datasource="#get('loc').datasource.intranet#">
			update workflows 
			set todelete = 1 
			where id = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />
				and documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="getToDelete" output="false" access="public" hint="">
		<cfset var qIds = "" />
		<cfquery name="qIds" datasource="#get('loc').datasource.intranet#">
			select a.id as workflowid, a.documentid, b.documentname from workflows a 
			inner join documents b on a.documentid = b.id 
			where a.todelete = 1;
		</cfquery>
		
		<cfreturn qIds />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="">
		<cfargument name="workflowid" type="numeric" required="true" />
		<cfargument name="documentid" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="ip" type="string" required="true" />
		
		<!--- scope everything --->
		<cfset var deleteWorkflows = "" />
		<cfset var deleteDocuments = "" />
		<cfset var deleteWorkflowStepDescription = "" />
		<cfset var deleteWorkflowStep = "" />
		<cfset var deleteWorkflowToSendMails = "" />
		<cfset var deleteCronInvoiceReports = "" />
		<cfset var deleteTriggerWorkflowSearch = "" />
		<cfset var deleteTriggerWorkflowStepList = "" />
		<cfset var deleteDocumentInstance = "" />
		<cfset var deleteDocumentAttributeValues = "" />
		
		<cfset var dokument = createObject("component", "cfc.models.Dokument").init(id = arguments.documentid) />
		
		<cfset var dokumentDAO = createObject("component", "cfc.models.DokumentDAO").init(get('loc').datasource.intranet) />
		<cfset dokumentDAO.read(dokument) />
		
		<cfif Len( dokument.getDocument_file_name() ) and Len( dokument.getDocumentname() ) and fileExists( expandPath( "#dokument.getDocument_file_name()#" ) )>
			
			<cfif not directoryExists( ExpandPath( "faktury_del/#DateFormat(dokument.getDocumentcreated(), 'yyyy')#/#DateFormat(dokument.getDocumentcreated(), 'mm')#" ) )>
				<cfset directoryCreate( expandPath( "faktury_del/#DateFormat(dokument.getDocumentcreated(), 'yyyy')#/#DateFormat(dokument.getDocumentcreated(), 'mm')#" ) ) />
			</cfif>
			
			<cffile action="move" destination="#expandPath( 'faktury_del/#DateFormat(dokument.getDocumentcreated(), 'yyyy')#/#DateFormat(dokument.getDocumentcreated(), 'mm')#/#reReplace(dokument.getDocumentname(), '/', '_', 'ALL')#.pdf' )#" source="#expandPath( '#dokument.getDocument_file_name()#' )#" />
		</cfif> 
		
		<cftransaction action="begin" isolation="read_committed" >
			<cfquery name="deleteDocuments" datasource="#get('loc').datasource.intranet#">
				delete from del_documents where id = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />; 
				insert into del_documents select * from documents where id = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				delete from documents where id = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				insert into del_history (
					del_historydate, 
					del_historytable, 
					del_historytablefield, 
					del_historytablekey,
					del_historyuserid, 
					del_historyip) 
  				values (
  					NOW(), 
  					'documents', 
  					'id', 
  					<cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />, 
  					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
  					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="deleteWorkflows" datasource="#get('loc').datasource.intranet#" >
				delete from del_workflows where id = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_workflows select * from workflows where id = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from workflows where id = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_history (
					del_historydate, 
					del_historytable, 
					del_historytablefield, 
					del_historytablekey, 
					del_historyuserid, 
					del_historyip) 
				values (
					NOW(), 
					'workflows', 
					'id', 
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="deleteWorkflowStepDescription" datasource="#get('loc').datasource.intranet#">
				delete from del_workflowstepdescriptions where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_workflowstepdescriptions select * from workflowstepdescriptions where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from workflowstepdescriptions where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_history (
					del_historydate, 
					del_historytable, 
					del_historytablefield, 
					del_historytablekey, 
					del_historyuserid, 
					del_historyip) 
				values (
					NOW(), 
					'workflowstepdescriptions', 
					'workflowid', 
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="deleteWorkflowStep" datasource="#get('loc').datasource.intranet#" >
				delete from del_workflowsteps where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_workflowsteps select * from workflowsteps where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from workflowsteps where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_history (
					del_historydate, 
					del_historytable, 
					del_historytablefield, 
					del_historytablekey, 
					del_historyuserid, 
					del_historyip) 
				values (
					NOW(), 
					'workflowsteps', 
					'workflowid', 
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="deleteWorkflowToSendMails" datasource="#get('loc').datasource.intranet#">
				delete from del_workflowtosendmails where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_workflowtosendmails select * from workflowtosendmails where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from workflowtosendmails where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_history (
					del_historydate, 
					del_historytable, 
					del_historytablefield, 
					del_historytablekey, 
					del_historyuserid, 
					del_historyip) 
				values (
					NOW(), 
					'workflowtosendmails', 
					'workflowid', 
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="deleteCronInvoiceReports" datasource="#get('loc').datasource.intranet#">
				delete from del_cron_invoicereports where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_cron_invoicereports select * from cron_invoicereports where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from cron_invoicereports where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_history (
					del_historydate, 
					del_historytable, 
					del_historytablefield, 
					del_historytablekey, 
					del_historyuserid, 
					del_historyip) 
				values (
					NOW(), 
					'cron_invoicereports', 
					'workflowid', 
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="deleteTriggerWorkflowSearch" datasource="#get('loc').datasource.intranet#">
				delete from del_trigger_workflowsearch where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_trigger_workflowsearch select * from trigger_workflowsearch where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from trigger_workflowsearch where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_history (
					del_historydate, 
					del_historytable, 
					del_historytablefield, 
					del_historytablekey, 
					del_historyuserid, 
					del_historyip) 
				values (
					NOW(), 
					'trigger_workflowsearch', 
					'workflowid',
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="deleteTriggerWorkflowStepList" datasource="#get('loc').datasource.intranet#">
				delete from del_trigger_workflowsteplists where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_trigger_workflowsteplists select * from trigger_workflowsteplists where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from trigger_workflowsteplists where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into del_history (
					del_historydate, 
					del_historytable, 
					del_historytablefield, 
					del_historytablekey, 
					del_historyuserid, 
					del_historyip) 
				values (
					NOW(), 
					'trigger_workflowsteplists',
					'workflowid', 
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<!---
			<cfquery name="deleteDocumentInstance" datasource="#get('loc').datasource.intranet#">
				delete from del_documentinstances where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				insert into del_documentinstances select * from documentinstances where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				delete from documentinstances where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				insert into del_history (
					del_historydate, 
					del_historytable, 
					del_historytablefield, 
					del_historytablekey, 
					del_historyuserid, 
					del_historyip) 
				values (
					NOW(), 
					'documentinstances', 
					'documentid', 
					<cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			--->
			
			<cfquery name="deleteDocumentAttributeValues" datasource="#get('loc').datasource.intranet#">
				delete from del_documentattributevalues where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				insert into del_documentattributevalues select * from documentattributevalues where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				delete from documentattributevalues where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				insert into del_history (
					del_historydate, 
					del_historytable, 
					del_historytablefield, 
					del_historytablekey, 
					del_historyuserid, 
					del_historyip) 
				values (
					NOW(), 
					'documentattributevalues', 
					'documentid', 
					<cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
		</cftransaction>

	</cffunction>
	
	<cffunction name="pobierzInformacjeOFakturze" output="false" access="public" hint="">
		<cfargument name="documentid" type="numeric" required="true" />
		
		<cfset var dokument = "" />
		<cfquery name="dokument" datasource="#get('loc').datasource.intranet#">
			select * from trigger_workflowsearch
			where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn dokument />
	</cffunction>
	
	<cffunction name="pobierDoArchiwum" output="false" access="public" hint="">
		<cfset var lista = "" />
		<cfquery name="lista" datasource="#get('loc').datasource.intranet#">
			select a.id as workflowid, a.documentid, b.numer_faktury from workflows a 
			left join trigger_workflowsearch b on a.documentid = b.documentid
			where a.to_archive = 1;
		</cfquery>
		
		<cfreturn lista />
	</cffunction>
	
	<cffunction name="przeniesDoArchiwum" output="false" access="public" hint="">
		<cfargument name="workflowid" type="numeric" required="true" />
		<cfargument name="documentid" type="numeric" required="true" />
		<cfargument name="userid" type="numeric" required="true" />
		<cfargument name="ip" type="string" required="true" />
		
		<!--- scope everything --->
		<cfset var archWorkflows = "" />
		<cfset var archDocuments = "" />
		<cfset var archWorkflowStepDescription = "" />
		<cfset var archWorkflowStep = "" />
		<cfset var archWorkflowToSendMails = "" />
		<cfset var archCronInvoiceReports = "" />
		<cfset var archTriggerWorkflowSearch = "" />
		<cfset var archTriggerWorkflowStepList = "" />
		<cfset var archDocumentInstance = "" />
		<cfset var archDocumentAttributeValues = "" />
		
		<cfset var dokument = createObject("component", "cfc.models.Dokument").init(id = arguments.documentid) />
		
		<cfset var dokumentDAO = createObject("component", "cfc.models.DokumentDAO").init(get('loc').datasource.intranet) />
		<cfset dokumentDAO.read(dokument) />
		
		<cfif Len( dokument.getDocument_file_name() ) and Len( dokument.getDocumentname() ) and fileExists( expandPath( "#dokument.getDocument_file_name()#" ) )>
			
			<cfif not directoryExists( ExpandPath( "faktury_arch/#DateFormat(dokument.getDocumentcreated(), 'yyyy')#/#DateFormat(dokument.getDocumentcreated(), 'mm')#" ) )>
				<cfset directoryCreate( expandPath( "faktury_arch/#DateFormat(dokument.getDocumentcreated(), 'yyyy')#/#DateFormat(dokument.getDocumentcreated(), 'mm')#" ) ) />
			</cfif>
			
			<cffile action="move" destination="#expandPath( 'faktury_arch/#DateFormat(dokument.getDocumentcreated(), 'yyyy')#/#DateFormat(dokument.getDocumentcreated(), 'mm')#/#reReplace(dokument.getDocumentname(), '/', '_', 'ALL')#.pdf' )#" source="#expandPath( '#dokument.getDocument_file_name()#' )#" />
		</cfif> 
		
		<cftransaction action="begin" isolation="read_committed" >
			<cfquery name="archDocuments" datasource="#get('loc').datasource.intranet#">
				delete from arch_documents where id = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />; 
				insert into arch_documents select * from documents where id = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				delete from documents where id = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				insert into arch_history (
					arch_historydate, 
					arch_historytable, 
					arch_historytablefield, 
					arch_historytablekey,
					arch_historyuserid, 
					arch_historyip) 
  				values (
  					NOW(), 
  					'documents', 
  					'id', 
  					<cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />, 
  					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
  					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="archWorkflows" datasource="#get('loc').datasource.intranet#" >
				delete from arch_workflows where id = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_workflows select * from workflows where id = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from workflows where id = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_history (
					arch_historydate, 
					arch_historytable, 
					arch_historytablefield, 
					arch_historytablekey, 
					arch_historyuserid, 
					arch_historyip) 
				values (
					NOW(), 
					'workflows', 
					'id', 
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="archWorkflowStepDescription" datasource="#get('loc').datasource.intranet#">
				delete from arch_workflowstepdescriptions where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_workflowstepdescriptions select * from workflowstepdescriptions where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from workflowstepdescriptions where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_history (
					arch_historydate, 
					arch_historytable, 
					arch_historytablefield, 
					arch_historytablekey, 
					arch_historyuserid, 
					arch_historyip) 
				values (
					NOW(), 
					'workflowstepdescriptions', 
					'workflowid', 
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="archWorkflowStep" datasource="#get('loc').datasource.intranet#" >
				delete from arch_workflowsteps where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_workflowsteps select * from workflowsteps where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from workflowsteps where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_history (
					arch_historydate, 
					arch_historytable, 
					arch_historytablefield, 
					arch_historytablekey, 
					arch_historyuserid, 
					arch_historyip) 
				values (
					NOW(), 
					'workflowsteps', 
					'workflowid', 
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="archWorkflowToSendMails" datasource="#get('loc').datasource.intranet#">
				delete from arch_workflowtosendmails where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_workflowtosendmails select * from workflowtosendmails where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from workflowtosendmails where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_history (
					arch_historydate, 
					arch_historytable, 
					arch_historytablefield, 
					arch_historytablekey, 
					arch_historyuserid, 
					arch_historyip) 
				values (
					NOW(), 
					'workflowtosendmails', 
					'workflowid', 
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="archCronInvoiceReports" datasource="#get('loc').datasource.intranet#">
				delete from arch_cron_invoicereports where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_cron_invoicereports select * from cron_invoicereports where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from cron_invoicereports where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_history (
					arch_historydate, 
					arch_historytable, 
					arch_historytablefield, 
					arch_historytablekey, 
					arch_historyuserid, 
					arch_historyip) 
				values (
					NOW(), 
					'cron_invoicereports', 
					'workflowid', 
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="archTriggerWorkflowSearch" datasource="#get('loc').datasource.intranet#">
				delete from arch_trigger_workflowsearch where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_trigger_workflowsearch select * from trigger_workflowsearch where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from trigger_workflowsearch where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_history (
					arch_historydate, 
					arch_historytable, 
					arch_historytablefield, 
					arch_historytablekey, 
					arch_historyuserid, 
					arch_historyip) 
				values (
					NOW(), 
					'trigger_workflowsearch', 
					'workflowid',
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<cfquery name="archTriggerWorkflowStepList" datasource="#get('loc').datasource.intranet#">
				delete from arch_trigger_workflowsteplists where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_trigger_workflowsteplists select * from trigger_workflowsteplists where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				delete from trigger_workflowsteplists where workflowid = <cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />;
				insert into arch_history (
					arch_historydate, 
					arch_historytable, 
					arch_historytablefield, 
					arch_historytablekey, 
					arch_historyuserid, 
					arch_historyip) 
				values (
					NOW(), 
					'trigger_workflowsteplists',
					'workflowid', 
					<cfqueryparam value="#arguments.workflowid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
			<!---
			<cfquery name="archDocumentInstance" datasource="#get('loc').datasource.intranet#">
				delete from arch_documentinstances where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				insert into arch_documentinstances select * from documentinstances where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				delete from documentinstances where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				insert into arch_history (
					arch_historydate, 
					arch_historytable, 
					arch_historytablefield, 
					arch_historytablekey, 
					arch_historyuserid, 
					arch_historyip) 
				values (
					NOW(), 
					'documentinstances', 
					'documentid', 
					<cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			--->
			
			<cfquery name="archDocumentAttributeValues" datasource="#get('loc').datasource.intranet#">
				delete from arch_documentattributevalues where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				insert into arch_documentattributevalues select * from documentattributevalues where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				delete from documentattributevalues where documentid = <cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />;
				insert into arch_history (
					arch_historydate, 
					arch_historytable, 
					arch_historytablefield, 
					arch_historytablekey, 
					arch_historyuserid, 
					arch_historyip) 
				values (
					NOW(), 
					'documentattributevalues', 
					'documentid', 
					<cfqueryparam value="#arguments.documentid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />, 
					<cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar" />);
			</cfquery>
			
		</cftransaction>
	</cffunction>
	
	<cffunction name="pobierzMpkProjektZAbs" output="false" access="public" hint="" returntype="query">
		<cfargument name="numerDok" type="string" required="true" />
		<cfargument name="IDDokumentu" type="numeric" required="true" />
		<cfargument name="IDObiegu" type="numeric" required="true" />
		<cfargument name="nrZew" type="string" required="true" />
		<cfargument name="netto" type="numeric" required="true" />
		<cfargument name="brutto" type="numeric" required="true" />
		 
		<cfset var tmpNazwaDok = listToArray(arguments.numerDok, "/") />
		<cfset var nrDok = tmpNazwaDok[1] & "/" & tmpNazwaDok[2] & "/" & tmpNazwaDok[3] & "/" & tmpNazwaDok[4] />
		
		<cfset var nrFak = "" />
		<cfquery name="nrFak" datasource="#get('loc').datasource.asseco#" cachedwithin="#CreateTimeSpan(0, 0, 0, 0)#">
			SELECT
				ISNULL(n.[NagId], 0) as nagID
				,nk.NumerFA as numerFA
				,n.PD_NrKartyKorespondencji
			FROM 
				dbo.fk7_tbl_NagDow AS n WITH(NOLOCK) 
			JOIN dbo.fk7_rd rd WITH(NOLOCK) ON n.Rd = rd.RD 
			LEFT JOIN dbo.NagDok nk WITH(NOLOCK) ON n.NagId = nk.NagId 
			WHERE rd.RR <> 'DOW' 
			AND REPLACE(n.[PD_NrKartyKorespondencji], ' ', '') = '#replaceNoCase(nrDok, ' ', '', 'ALL')#' 
			and REPLACE(nk.NumerFA, ' ', '') = '#replaceNoCase(arguments.nrZew, ' ', '', 'ALL')#'
			and (SELECT SUM (lk.Brutto) FROM dbo.LinDok lk WITH (NOLOCK) WHERE n.NagId = lk.NagId) = #replaceNoCase(arguments.brutto, ',', '.', 'ALL')# 
			and (SELECT SUM (lk.Netto) FROM dbo.LinDok lk WITH (NOLOCK) WHERE n.NagId = lk.NagId) = #replaceNoCase(arguments.netto, ',', '.', 'ALL')#
			AND n.[Obroty] = 1 
			AND n.[Status] > 0;
		</cfquery>
		
		<cfset var linijki = queryNew("id") />
		<cfquery name="linijki" datasource="#get('loc').datasource.asseco#">
			SELECT 
			distinct
			REPLACE(lg.[Gniazdo;PR], ' ', '') AS 'projekt' 
			, REPLACE(lg.[Gniazdo;MP], ' ', '') AS 'mpk' 
			FROM dbo.LinDow AS l WITH(NOLOCK) 
			LEFT OUTER JOIN dbo.[fk7_vv_lindoweditwnma] AS lwn WITH (NOLOCK) ON lwn.NagId = l.NagId AND lwn.Lp = l.Lp AND lwn.WnMa=-1 
			LEFT OUTER JOIN dbo.[fk7_vv_lindoweditwnma] AS lma WITH (NOLOCK) ON lma.NagId = l.NagId AND lma.Lp = l.Lp AND lma.WnMa= 1 
			LEFT OUTER JOIN dbo.[fk7_vv_lindowmpkedit] AS lg WITH (NOLOCK) ON l.NagId = lg.nagid_mpk AND l.Lp = lg.lp_mpk 
			WHERE 
			l.[NagId] = <cfqueryparam value="#nrFak.nagID#" cfsqltype="cf_sql_varchar" />
			and lg.[Gniazdo;PR] is not null and lg.[Gniazdo;PR] <> '********************'
			and lg.[Gniazdo;MP] is not null and lg.[Gniazdo;MP] <> '********************'
			order by REPLACE(lg.[Gniazdo;PR], ' ', ''), REPLACE(lg.[Gniazdo;MP], ' ', ''); 
		</cfquery>
		
		<cfreturn linijki />
	</cffunction>
	
	<cffunction name="pobierzMpkProjektZIntranetu" output="false" access="public" hint="" returntype="query">
		<cfargument name="numerDok" type="string" required="true" />
		<cfargument name="IDDokumentu" type="numeric" required="true" />
		<cfargument name="IDObiegu" type="numeric" required="true" />
		<cfargument name="nrZew" type="string" required="true" />
		<cfargument name="netto" type="numeric" required="true" />
		<cfargument name="brutto" type="numeric" required="true" />
		
		<cfset var linijki = "" />
		<cfquery name="linijki" datasource="#get('loc').datasource.intranet#">
			select distinct b.projekt, c.mpk from workflowstepdescriptions a
			inner join projects b on a.projectid = b.id
			inner join mpks c on a.mpkid = c.id
			where workflowid = <cfqueryparam value="#arguments.IDObiegu#" cfsqltype="cf_sql_integer" />
			order by b.projekt, c.mpk;
		</cfquery>
		
		<cfreturn linijki />
	</cffunction>
	
	<cffunction name="pobierzFakturyNaEtapieKsiegowosci" output="false" access="public" hint="" returntype="query">
		<cfset var faktury = "" />
		<cfquery name="faktury" datasource="#get('loc').datasource.intranet#">
			start transaction;
			create temporary table tmp_do_zaksiegowania as 
			select distinct a.workflowid, a.documentid from workflowsteps a
			where a.workflowstatusid = 1 and a.workflowstepstatusid = 4;
			
			select a.*, b.numer_faktury_zewnetrzny, b.numer_faktury, b.netto, b.brutto from tmp_do_zaksiegowania a
			inner join trigger_workflowsearch b on a.documentid = b.documentid and a.workflowid = b.workflowid;
			drop table tmp_do_zaksiegowania;
			commit;
		</cfquery>
		<cfreturn faktury />
	</cffunction>
	
	<cffunction name="zaksiegujDokumentWIntranecie" output="false" access="public" hint="" returntype="struct">
		<cfargument name="nazwaDok" type="string" required="true" />
		
		<cfset var results = {
			success = true,
			message = "Dokument został zaksiegowany" 
		} />
		
		<cftry>
			
			<!--- Pobieram informacje o dokumencie --->
			<cfset var dokument = "" />
			<cfquery name="dokument" datasource="#get('loc').datasource.intranet#">
				select * from documents where documentname = <cfqueryparam value="#arguments.nazwaDok#" cfsqltype="cf_sql_varchar" /> limit 1;
			</cfquery>
			
			<cfif dokument.recordCount eq 0>
				<cfthrow message = "Brak dokumentu #arguments.nazwaDok#" />
			</cfif>
			
			<cfset var wrk = "" />
			<cfquery name="wrk" datasource="#get('loc').datasource.intranet#">
				select * from workflows where documentid = <cfqueryparam value="#dokument.id#" cfsqltype="cf_sql_integer" />;
			</cfquery>
		
			<!--- Ksieguje dokument i przenosze na etap Prezesa --->
			<cfset var ksiegowanie = "" />
			<cfset var dataKsiegowania = Now() />
			<cfset var dataZamkniecia = dateAdd("n", RandRange(60, 360), Now()) />
			
			<cfquery name="ksiegowanie" datasource="#get('loc').datasource.intranet#">
				update workflowsteps set 
					workflowstepended = <cfqueryparam value="#dataKsiegowania#" cfsqltype="cf_sql_timestamp" />,
					workflowstatusid = <cfqueryparam value="2" cfsqltype="cf_sql_integer" />,
					workflowsteptransfernote = <cfqueryparam value="Faktura zaksiegowana automatycznie" cfsqltype="cf_sql_varchar" />
				where documentid = <cfqueryparam value="#dokument.id#" cfsqltype="cf_sql_integer" />
					and workflowstatusid = <cfqueryparam value="1" cfsqltype="cf_sql_integer" />
					and workflowstepstatusid = <cfqueryparam value="4" cfsqltype="cf_sql_integer" />;
				
				insert into workflowsteps (workflowstepcreated, workflowstepended, userid, workflowstatusid, workflowstepstatusid, workflowid, documentid) values (
					<cfqueryparam value="#dataKsiegowania#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#dataZamkniecia#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="38" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="2" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="5" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#wrk.id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#dokument.id#" cfsqltype="cf_sql_integer" />
				); 
			</cfquery>
		
			<cfcatch type="any">
				
				<cfset results = {
					success = false,
					message = cfcatch.Message 
				} />
				
				<cfmail to="admin@monkey.xyz" from="intranet@monkey.xyz" subject="Automatyczne ksiegowanie" type="html">
					<cfdump var="#dokument#" />
					<cfdump var="#cfcatch#" />
				</cfmail>
				

			</cfcatch>
		</cftry>
		
		<cfreturn results />
	</cffunction>

</cfcomponent>