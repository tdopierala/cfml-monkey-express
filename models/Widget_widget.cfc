<cfcomponent
	extends="Model">

	<cffunction name="init">

		<cfset table("widget_widgets") />

	</cffunction>

	<cffunction
		name="getAllWidgets"
		hint="Pobieram listę dostępnych dashboardów">

		<cfreturn this.findAll(select="id,widgetname,widgetdisplayname,widgetdescription") />

	</cffunction>

	<!---
		Pobieram listę przypisanych do użytkownika widetów.

		2.04.2013
		Pobieram listę dostępnych dla użytkownika widgetów. Lista nie zawiera
		już widgetów, które użytkownik ma przypisane.
	--->
	<cffunction
		name="getUserAvailableWidgets"
		hint="Pobieram widgety przypisane do użytkownika" >

		<cfargument
			name="userid"
			type="numeric"
			required="true" />

		<cfquery
			name="query_get_user_available_widgets"
			result="result_get_user_available_widgets"
			datasource="#get('loc').datasource.intranet#">

			select
				w.widgetdisplayname as widgetdisplayname
				,w.id as id
				,wtg.groupid as groupid
			from widget_tree_groups wtg
			inner join widget_widgets w on wtg.widgetid = w.id
			where wtg.groupid in (
				select distinct groupid from tree_groupusers where
					userid = <cfqueryparam
						value="#arguments.userid#"
						cfsqltype="cf_sql_integer"/>
			)
			and wtg.widgetid not in (
				select distinct widgetid from widget_userwidgets where
					userid = <cfqueryparam
						value="#arguments.userid#"
						cfsqltype="cf_sql_integer" />
			)

		</cfquery>

		<cfreturn query_get_user_available_widgets />

	</cffunction>

	<!---
		21.02.2013
		Pobieram listę widgetów, które są przypisane do użytkownika.
		Widgety są pobierane z tabeli widget_userwidgets.
	--->
	<cffunction
		name="getUserWidgets"
		hint="Pobieram dostępne dla użytkownika widgety">

		<cfargument
			name="userid"
			type="numeric"
			required="true" />

		<cfquery
			name="query_get_user_widgets"
			result="result_get_user_widgets"
			datasource="#get('loc').datasource.intranet#">

			select
				w.widgetdisplayname as widgetdisplayname
				,wuw.widgetid as widgetid
				,wuw.widgetdisplay as widgetdisplay
				,wuw.widgetorder as widgetorder
				,w.widgeturl as widgeturl
				,wuw.id as id
			from widget_userwidgets wuw
			inner join widget_widgets w on wuw.widgetid = w.id
			where wuw.userid =
				<cfqueryparam
					value="#arguments.userid#"
					cfsqltype="cf_sql_integer" />
			order by wuw.widgetorder asc

		</cfquery>

		<cfreturn query_get_user_widgets />

	</cffunction>

	<!---
		Metody używane przy przypisywaniu widgetów do grupy uprawnień.
	--->
	<cffunction
		name="getGroupWidgets"
		hint="Pobieram listę widgetów przypisanych do grupy">

		<cfargument
			name="groupid"
			required="true" />

		<cfargument
			name="structure"
			default="false"
			required="false" />

		<cfquery
			name="query_get_group_widgets"
			result="result_get_group_widgets"
			datasource="#get('loc').datasource.intranet#" >

			select
				wtg.id as id
				,wtg.widgetid as widgetid
				,wtg.groupid as groupid
				,w.widgetdisplayname as widgetdisplayname
				,w.widgetdescription as widgetdescription
			from
				widget_tree_groups wtg
			inner join widget_widgets w on wtg.widgetid = w.id
			where wtg.groupid = <cfqueryparam  value="#arguments.groupid#" cfsqltype="cf_sql_integer" />

		</cfquery>

		<cfif arguments.structure is true>
			<cfreturn super.QueryToStruct(Query=query_get_group_widgets) />
		</cfif>

		<cfreturn query_get_group_widgets />

	</cffunction>

	<cffunction
		name="getAvailableGroupWidgets"
		hint="Pobieram listę dostępnych jeszcze widgetów dla danej grupy">

		<cfargument
			name="groupid"
			required="true" />

		<cfargument
			name="structure"
			required="false"
			default="false" />

		<cfquery
			name="query_get_available_group_widgets"
			result="result_get_available_group_widgets"
			datasource="#get('loc').datasource.intranet#">

			select
				w.id as widgetid
				,w.widgetdisplayname as widgetdisplayname
				,<cfqueryparam value="#arguments.groupid#" cfsqltype="cf_sql_integer" /> as groupid
			from widget_widgets w
			where id not in (
				select widgetid from widget_tree_groups where groupid = <cfqueryparam value="#arguments.groupid#" cfsqltype="cf_sql_integer" />
				)
		</cfquery>

		<cfif arguments.structure is true>
			<cfreturn super.QueryToStruct(Query=query_get_available_group_widgets) />
		</cfif>

		<cfreturn query_get_available_group_widgets />

	</cffunction>

	<!---
	 -
	 - Od tego miejsca znajdują się funkcje z raportami (widgetami)
	 -
	 -
	 -
	--->

	<cffunction
		name="placeStats"
		hint="Raport z iloci nieruchomości w Intranecie">

		<cfquery
			name="query_place_stats"
			datasource="#get('loc').datasource.intranet#"
			result="result_place_stats"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >

			select
				year
				,month
				,c
				,s
				,s_div_c
			from report_view_places_summary
			limit 12;

		</cfquery>

		<cfreturn query_place_stats />

	</cffunction>

	<cffunction
		name="workflowStats"
		hint="Sumaryczny raport z ilości faktur w intranecie">

		<cfquery
			name="query_workflow_stats"
			datasource="#get('loc').datasource.intranet#"
			result="result_workflow_stats">

			select
				year
				,month
				,count
			from report_view_invoices_income_per_month
			order by year desc, month asc
			limit 12;

		</cfquery>

		<cfreturn query_workflow_stats />

	</cffunction>

	<!---
		26.03.2013
		Raport z ilości faktur w obiegu.
		Utworzony jest widok, który agreguje wszystkie dane.

		Zapytanie pobiera liczbę faktur z aktualnego miesiąca z
		podziałem na departamenty.

		29.03.2013
		Zapytanie jest cachowane. Interwał jest ustawiony na 15 minut.
	--->
	<cffunction
		name="invoiceStats"
		hint="Statystyki z ilości faktur w intranecie">

		<cfquery
			name="query_invoice_stats"
			result="result_invoice_stats"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
      			departmentname
      			,year(data_wystawienia) as year
      			,month(data_wystawienia) as month
      			,count(id) as c
				,sum(brutto) as brutto
			from cron_invoicereports
			where Year(data_wystawienia) = Year(Now()) and Month(data_wystawienia) = Month(Now())
			group by departmentname, year(data_wystawienia), month(data_wystawienia);

		</cfquery>

		<cfreturn query_invoice_stats />

	</cffunction>


	<!---
		26.03.2013
		Metoda zlicza średnią liczbę wszystkich faktur z ostatniego
		miesiąca ze wszystkich departamentów.

		29.03.2013
		Zapytanie jest cachowane. Interwał jest ustawiony na 15 minut/
	--->
	<cffunction
		name="invoiceAvg"
		hint="Średnia ilość faktur w danym miesiącu.">

		<cfquery
			name="query_invoice_avg"
			result="reult_invoice_avg"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >

			select
				avg(c) as avg_c
			from (

				select
 	     			departmentname
    	  			,year(data_wystawienia) as year
      				,month(data_wystawienia) as month
      				,count(id) as c
					,sum(brutto) as brutto
				from cron_invoicereports
				where Year(data_wystawienia) = Year(Now()) and Month(data_wystawienia) = Month(Now())
				group by departmentname, year(data_wystawienia), month(data_wystawienia)

			) temp;

		</cfquery>

		<cfreturn query_invoice_avg />

	</cffunction>

	<!---
		26.03.2013
		Raport z sumy faktur z podziałem na departamenty.
		Utworzony jest widok, który agreguje wszystkie dane i ogranicza do ostatnich
		dwóch miesięcy.

		26.03.2013
		Ta metoda celowo zawiera taki sam kod jw. Docelowo raport ma zawierać mediane
		wydatków i do niej ma być przyrównywany raport.

		29.03.2013
		Zapytanie jest cachowane. Interwał jest ustawiony na 15 minut
	--->
	<cffunction
		name="invoicePaymentStats"
		hint="Statystyki z kwotą faktur w intranecie">

		<cfquery
			name="query_invoice_payment_stats"
			result="result_invoice_payment_stats"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#">

			select
				count(id) as count
				,departmentname
				,year(data_wystawienia)
				,month(data_wystawienia)
				,sum(brutto) as brutto
			from cron_invoicereports
			where Year(data_wystawienia) = Year(Now()) and Month(data_wystawienia) = Month(Now())
			group by departmentname, year(data_wystawienia), month(data_wystawienia)
			order by data_wystawienia desc;

		</cfquery>

		<cfreturn query_invoice_payment_stats />

	</cffunction>

	<!---
		26.03.2013
		Metoda zlicza średnią liczbę wszystkich faktur z ostatniego
		miesiąca ze wszystkich departamentów.
	--->
	<cffunction
		name="invoicePaymentAvg"
		hint="Średnia ilość faktur w danym miesiącu.">

		<cfquery
			name="query_invoice_payment_avg"
			result="reult_invoice_payment_avg"
			datasource="#get('loc').datasource.intranet#"
			cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#" >

			select
				avg(brutto) as avg_brutto
			from (

				select
 	     			departmentname
    	  			,year(data_wystawienia) as year
      				,month(data_wystawienia) as month
      				,count(id) as c
					,sum(brutto) as brutto
				from cron_invoicereports
				where Year(data_wystawienia) = Year(Now()) and Month(data_wystawienia) = Month(Now())
				group by departmentname, year(data_wystawienia), month(data_wystawienia)

			) temp;

		</cfquery>

		<cfreturn query_invoice_payment_avg />

	</cffunction>
	
	<!--- 
		Zapytania tworzące raporty z obiegu nieruchomości
	--->
	<cffunction name="PrzetrzymaneFaktury" output="false" access="public" hint="">
		<cfargument name="userid" type="numeric" required="false" />
		
		<cfset var przetrzymaneFaktury = "" />
		<cfquery name="przetrzymaneFaktury" datasource="#get('loc').datasource.intranet#">
			select distinct w.workflowid, w.documentid, w.userid, u.givenname, u.sn,
				wss.workflowstepstatusname, timestampdiff(day, w.workflowstepcreated, Now()) as dni, twsl.documentname
			from workflowsteps w
				inner join trigger_workflowsteplists twsl on w.workflowid = twsl.workflowid
				inner join workflowstepstatuses wss on w.workflowstepstatusid = wss.id
				inner join users u on w.userid = u.id
			where w.workflowstepended is null 
				and w.workflowstatusid = 1 
				and w.workflowstepstatusid in (1, 2, 3)
				and timestampdiff(day, w.workflowstepcreated, Now()) > 3

			<cfif IsDefined("arguments.userid")>
				and w.userid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_integer" />
			</cfif>

			order by timestampdiff(day, w.workflowstepcreated, Now()) desc
			limit 25
		</cfquery>

		<cfreturn przetrzymaneFaktury />
	</cffunction>
	
	<cffunction name="PrzetrzymaneFakturyEtapami" output="false" access="public" hint="">
		<cfset var przetrzymaneFaktury = "" />
		<cfquery name="przetrzymaneFaktury" datasource="#get('loc').datasource.intranet#">
			select wss.workflowstepstatusname,  w.workflowstatusid, sum(TIMESTAMPDIFF(DAY, w.workflowstepcreated, Now())) as dni
			from workflowsteps w
			inner join workflowstepstatuses wss on w.workflowstepstatusid = wss.id
			where  w.workflowstepended is null 
				and workflowstatusid = 1 
				and TIMESTAMPDIFF(DAY, w.workflowstepcreated, Now()) > 3
			group by workflowstepstatusid
		</cfquery>

		<cfreturn przetrzymaneFaktury />
	</cffunction>
	
	<cffunction name="removeDashboardWidget" output="false" access="public">
		<cfargument name="id" type="numeric" required="true" />
		<cfset var deleteQuery = "" />
		<cfset var deleteResult = "" />
		<cfquery name="deleteQuery" result="deleteResult" datasource="#get('loc').datasource.intranet#">
			delete from widget_userwidgets 
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" /> 
		</cfquery>
		<cfreturn false />
	</cffunction>


	<cffunction 
		name="trafficReport" 
		output="false" access="public">
		
		<cfquery
			name="query_traffic_stats"
			result="reult_traffic_stats"
			datasource="#get('loc').datasource.intranet#">
			
			SET @_count = (select count(*) from tbl_log_stats);
			SET @_to = 12;
			SET @_from = @_count - @_to;
			
			PREPARE STMT FROM "SELECT * FROM tbl_log_stats ORDER BY date ASC LIMIT ?,? ";
			EXECUTE STMT USING @_from, @_count;
		</cfquery>

		<cfreturn query_traffic_stats />
		
		<!---cachedwithin="#createTimeSpan(
							APPLICATION.cache.query.days,
							APPLICATION.cache.query.hours,
							APPLICATION.cache.query.minutes,
							APPLICATION.cache.query.seconds)#"--->
		
	</cffunction>
	
	<cffunction 
		name="trafficHourReport" 
		output="false" access="public">
		
		<cfquery
			name="query_traffic_stats"
			result="reult_traffic_stats"
			datasource="#get('loc').datasource.intranet#">
			
			SELECT count(tb.id) as count, hour(logdatetime) as h
			FROM tbl_logs tb
			where logdatetime > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 MONTH) ,'%Y-%m') and logdatetime < DATE_FORMAT(NOW() ,'%Y-%m')
			GROUP BY h
			order by h asc;

		</cfquery>

		<cfreturn query_traffic_stats />
		
	</cffunction>
	
	<cffunction name="helpdesk" output="false" access="public" hint="">
		<cfargument name="sklep" type="string" required="true" />
		
		<cfset var h = "" />
		<cfquery name="h" datasource="#get('loc').datasource.intranet#">
			select * from helpdesk
			where kodSklepu = <cfqueryparam value="#arguments.sklep#" cfsqltype="cf_sql_varchar" />
			order by dataZmianyStatusu desc
			limit 20
		</cfquery>
		<cfreturn h />
	</cffunction>
	
	<cffunction name="video" output="false" access="public" hint="" returntype="query">
		<cfargument name="kategorie" type="query" required="true" />
		
		<cfset var video = "" />
		<cfquery name="video" datasource="#get('loc').datasource.mssql#" maxrows="20">
			select distinct a.idMaterialuVideo, a.nazwaMaterialuVideo, a.opisMaterialuVideo, a.dataPublikacji, a.userId, a.iloscWyswietlen, a.srcMiniaturki, a.srcVideo
			from video_materialyVideo a
			inner join video_kategorieMaterialow b on a.idMaterialuVideo = b.idMaterialuVideo
			inner join video_definicjeKategoriiMaterialow c on c.idDefinicjiKategoriiMaterialu = b.idDefinicjiKategoriiMaterialu
			where c.nazwaKategoriiMaterialu in ('#ValueList(arguments.kategorie.groupName, "','")#')
			order by dataPublikacji desc;
		</cfquery>
		<cfreturn video />
	</cffunction>
	
</cfcomponent>