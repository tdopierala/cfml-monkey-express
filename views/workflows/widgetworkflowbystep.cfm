<!---
	Cache strony ustawiony na 30 minut.
--->

<cfcache
	action="cache"
    timespan="#createTimeSpan(0, 0, 10, 0)#" />

<cfsilent>

	<!---
		Tutaj policzę odchylenie standardowe.
		Aby to policzyć potrzebne jest wyliczenie średniej arytmetycznej.
	--->
	<cfset tmp = 0 />
	<cfloop query="qSWorkflows">
		<cfset tmp += c />
	</cfloop>

	<cfparam
		name="srednia_arytmetyczna"
		default="#tmp#" />

	<cfparam
		name="sigma"
		default="0" />

	<cfloop query="qSWorkflows">
		<cfset sigma += (c - srednia_arytmetyczna)^2 />
	</cfloop>

	<cfif qSWorkflows.RecordCount is 0>
		<cfset sigma /= 1 />
	<cfelse>
		<cfset sigma /= qSWorkflows.RecordCount />
	</cfif>

	<cfset odchylenie_standardowe = Sqr(sigma) />

	<cfparam
		name="myColorList"
		default="" />

	<!---
		Teraz definiuje kolory dla wykresu.
	--->

	<cfloop query="qSWorkflows">

		<cfif c gte srednia_arytmetyczna+(0.5*odchylenie_standardowe)>
			<cfset myColorList &= '##75bd4e,' />
		<cfelseif c lt srednia_arytmetyczna-(0.5*odchylenie_standardowe)>
			<cfset myColorList &= '##eb0f0f,' />
		<cfelse>
			<cfset myColorList &= '##cccccc,' />
		</cfif>

	</cfloop>

	<!---
		Style wykresu
	--->
	<cfxml variable="xml">
	<?xml version="1.0" encoding="UTF-8"?>
		<frameChart is3D="false" font="Tahoma-13">
			<frame xDepth="12" yDepth="11" outline="black"/>
			<yAxis scaleMin="0.9" scaleMax="1.0" isAntialiased="true">
				<labelFormat pattern="#,##0.###"/>
				<parseFormat pattern="#,##0.###"/>
				<groupStyle>
					<format pattern="#,##0.###"/>
				</groupStyle>
			</yAxis>
			<xAxis isAntialiased="true">
				<labelFormat pattern="#,##0.###"/>
				<parseFormat pattern="#,##0.###"/>
				<labelStyle orientation="Vertical"/>
			</xAxis>
			<legend
				allowSpan="true" equalCols="false" isVisible="false" halign="Right" isMultiline="true" isAntialiased="true" >
				<decoration style="None"/>
			</legend>
			<elements drawOutline="false" drawShadow="true" />
			<popup background="#eeeeee" font="Arial-12" isMultiline="true" isAntialiased="true" provideAltText="true" foreground="black"/>
		</frameChart>
	</cfxml>

</cfsilent>


<div class="widgetBox">
<div class="inner">

	<div class="widgetHeaderArea">
		<div class="widgetHeaderArea uiWidgetHeader">
			<h3 class="uiWidgetHeaderTitle">Ilość faktur na każdym etapie</h3>
		</div>
	</div>

	<div class="widgetContentArea">
		<div class="widgetContentArea uiWidgetContent">

			<div class="uiWidgetChart">
				<cfchart
					format="png"
					showmarkers="false"
					showlegend="false"
					yaxistitle="Liczba faktur"
					style="#xml#" >

				<cfchartseries
					type="bar"
					serieslabel="Liczba dokumentów"
					colorlist="#myColorList#"
					query="qSWorkflows"
					valuecolumn="c"
					itemcolumn="workflowstepstatusname"
					paintstyle="plain" >

				</cfchartseries>

				</cfchart>
			</div>

			<div class="uiWidgetFooter">
			Raport prezentuje ilość faktur, która w danej chwili znajduje się na każdym z etapów.
			</div>
		</div>
	</div>

	<div class="clearfix"></div>

</div>
</div>



