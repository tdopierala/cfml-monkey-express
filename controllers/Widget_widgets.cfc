<cfcomponent
	extends="Controller">

	<cffunction name="init">
		<cfset super.init() />
		<cfset filters(through="loadJs",type="before") />
	</cffunction>
	
	<cffunction name="loadJs" output="false" access="private" hint="">
		
	</cffunction>

	<cffunction name="index" hint="Widok prezentujący wszystkie dostępne Dashboardy."
		description="Widok prezentujący dostępne dashboardy. Dodatkowo na
				stronie można przypisać każde okienko do dowolnego użytkownika." >

		<!---
			Pobieram wszystkie dostępne dashboardy.
		--->
		<cfset dashboards = model("dashboard_dashboard").getAllDashboards() />

		<!---
			Pobieram dashboardy przypidane do mnie.
		--->
		<!---<cfset my_dashboard = model(dashboard_dashboard).getUserDashboards() />--->

	</cffunction>

	<!---
		21.02.2013
		Lista przypisanych dashboardów do użytkownika.
	--->
	<cffunction
		name="userDashboards"
		hint="Pobieram listę przypisanych dashboardów dla użytkownika.">

		<cfset dashboards = model("dashboard_dashboard").getUserDashboards(
			userid		=	params.key) />

		<cfset dashboards = model("dashboard_dashboard").QueryToStruct(Query=dashboards) />

		<cfset renderWith(data=dashboards,layout=false) />

	</cffunction>

	<!---
		21.02.2013
		Lista dostępnych dashboardów dla użytkownika.
	--->
	<cffunction
		name="userAvailableDashboards"
		hint="Pobieram listę dostępnych dashboardów dla użytkownika">

		<cfset available_dashboards = model("dashboard_dashboard").getUserAvailableDashboards(
			userid		=	params.key) />

		<cfset available_dashboards = model("dashboard_dashboard").QueryToStruct(Query=available_dashboards) />

		<cfset renderWith(data=available_dashboards,layout=false) />

	</cffunction>

	<!---
		22.02.2013
		Przypisanie użytkownika do widgetu. Akcja jest wywoływana Ajaxowo.
	--->
	<cffunction
		name="assignWidgetToUser"
		hint="Przypisanie użytkownika do dashboardu">

		<!---
			Sprawdzam, czy przesłano wszystkie dane do skojarzenia uzytkownika
			z widgetem.
		--->
		<cfif structKeyExists(session, "userid") and structKeyExists(params, "widgetid")>

			<cfset new_user_widget = model("widget_userwidget").new() />
			<cfset new_user_widget.userid = session.userid />
			<cfset new_user_widget.widgetid = params.widgetid />
			<cfset new_user_widget.widgetorder = 1 />
			<cfset new_user_widget.widgetdisplay = "top" />
			<cfset new_user_widget.save(callbacks=false) />

			<cfset new_user_widget.widget = model("widget_widget").findByKey(new_user_widget.widgetid) />

		</cfif>

	</cffunction>

	<cffunction
		name="reorder">

		<cfif IsAjax() and Len(Trim(params.neworder))>

			<cfset params.neworder = params.neworder & "," />

			<cfset j = 1 />
			<cfloop list="#params.neworder#" index="i" delimiters=",">
				<cfset element_id = ListToArray(i, "-", false) />

				<cfset my_widget = model("widget_userwidget").findByKey(element_id[3]) />
				<cfset my_widget.update(widgetorder=j,widgetdisplay=params.display) />
				<cfset j++ />
			</cfloop>

			<cfset renderWith(data="",layout=false) />

		</cfif>

	</cffunction>

	<!---

		TUTAJ ZNAJDUJĄ SIĘ RAPORTY DOSTĘPNE W WIDGETACH

		01.03.2013
		Raport z ilości wszystkich dodanych nieruchomości do Intranetu.
		Raport jest pogrupowany po latach i miesiącach
	--->
	<cffunction
		name="placeStats"
		hint="Raport prezentujący liczbę faktur dodanych do Intranetu">

		<cfset my_report = model("widget_widget").placeStats() />

	</cffunction>

	<!---
		01.03.2013
		Lista wszystkich dodanych faktur do Intranetu.
		Raport jest grupowany po latach i miesiącach.
	--->
	<cffunction
		name="workflowStats"
		hint="Sumaryczny raport z obiegu faktur w intranecie">

		<cfset my_report = model("widget_widget").workflowStats() />

	</cffunction>

	<!---
		26.03.2013
		Raport z dokumentów finansowo-księgowych.
		Liczba faktur z podziałem na departamenty
	--->
	<cffunction
		name="invoiceStats"
		hint="Faktury z podziałem na departamenty">

		<cfset my_report = model("widget_widget").invoiceStats() />
		<cfset my_report_avg = model("widget_widget").invoiceAvg() />

	</cffunction>

	<!---
		26.03.2013
		Raport z dokumentów finansowo-księgowych.
		Koszty faktur z podziałem na departamenty.
	--->
	<cffunction
		name="invoicePaymentStats"
		hint="Koszty faktur z podziałem na departamenty">

		<cfset my_report = model("widget_widget").invoicePaymentStats() />
		<cfset my_report_avg = model("widget_widget").invoicePaymentAvg() />

	</cffunction>
	
	<cffunction name="PrzetrzymaneFaktury" output="false" access="public" hint="Raport z przetrzymanych faktur">
		<cfset renderWith(data="",layout=false) />
	</cffunction>
	
	<cffunction name="PrzetrzymaneFakturyWidget" output="false" access="public" hint="">
		<cfset faktury = model("widget_widget").PrzetrzymaneFaktury() />
		<cfset renderWith(data="faktury",layout=false) />
	</cffunction>
	
	<cffunction name="PrzetrzymaneFakturyEtapami" output="false" access="public" hint="">
		<cfset renderWith(data="",layout=false) />
	</cffunction>
	
	<cffunction name="PrzetrzymaneFakturyEtapamiWidget" output="false" access="public" hint="Raport z przetrzymanych faktur etapami">
		<cfset faktury = model("widget_widget").PrzetrzymaneFakturyEtapami() />
		<cfset renderWith(data="faktury",layout=false) />
	</cffunction>
	
	<cffunction name="PrzetrzymaneFakturyUzytkownika" output="false" access="public" hint="">
		<cfset renderWith(data="",layout=false) />
	</cffunction>
	
	<cffunction name="PrzetrzymaneFakturyUzytkownikaWidget" output="false" access="public" hint="">
		<cfset faktury = model("widget_widget").PrzetrzymaneFaktury(session.user.id) />
		<cfset renderWith(data="faktury",layout=false) />
	</cffunction>

	<cffunction name="removeDashboardWidget" output="false" access="public">
		<cfif IsDefined("FORM.ROW")>
			<cfset removedWidget = model("widget_widget").removeDashboardWidget(FORM.ROW) />
		</cfif>
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="trafficStats" hint="Statystyki ruchu w intranecie">			
		<cfset traffic_report = model("widget_widget").trafficReport() />		
	</cffunction>
	
	<cffunction name="trafficHourStats" hint="Statystyki godzinne ruchu w intranecie">			
		<cfset traffic_report = model("widget_widget").trafficHourReport() />		
	</cffunction>
	
	<cffunction name="helpdesk" output="false" access="public" hint="">
		<cfset zgloszenia = model("widget_widget").helpdesk(session.user.login) />
		<cfset renderWith(data="zgloszenia",layout=false) />
	</cffunction>
	
	<cffunction name="video" output="false" access="public" hint="">
		<cfset grupy = model("tree_groupuser").getUserTreePrivileges(session.user.id) />
		<cfset video = model("widget_widget").video(grupy) />
		<cfset renderWith(data="video",layout=false) />
	</cffunction>
</cfcomponent>