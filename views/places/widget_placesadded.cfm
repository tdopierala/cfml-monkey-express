<!---
	Cache strony ustawiony na 30 minut.
--->

<cfcache
	action="cache"
    timespan="#createTimeSpan(0, 0, 10, 0)#" />

<cfsilent>

	<!---
		Liczę średnią arytmetyczną z ilości wprowadzonych nieruchomości.
	--->
	<cfset sum = 0 />
	<cfloop query="qPlaces">
		<cfset sum += c />
	</cfloop>

	<cfset srednia_arytmetyczna = sum / qPlaces.RecordCount />

	<cfparam
		name="myColorList"
		default="" />

	<!---
		Teraz definiuje kolory dla wykresu.
	--->
	<cfset max = 0 />

	<cfloop query="qPlaces">
		<cfif c GTE max>
			<cfset max = c />
		</cfif>
	</cfloop>

	<cfset min = max />
	<cfloop query="qPlaces">
		<cfif c LTE min>
			<cfset min = c />
		</cfif>
	</cfloop>

	<cfloop query="qPlaces">
		<cfif c EQ max>
			<cfset myColorList &= '##75bd4e,' />
		<cfelseif c EQ min>
			<cfset myColorList &= '##eb0f0f,' />
		<cfelse>
			<cfset myColorList &= '##c2c2c2,' />
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
			<xAxis isAntialiased="true" isReversed="true">
				<labelFormat pattern="#,##0.###"/>
				<parseFormat pattern="#,##0.###"/>
				<labelStyle ismultilevel="true" orientation="Parallel"/>
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
			<h3 class="uiWidgetHeaderTitle">Liczba dodanych nieruchomości</h3>
		</div>
	</div>

	<div class="widgetContentArea">
		<div class="widgetContentArea uiWidgetContent">

			<div class="uiWidgetChart">
				<cfchart
					format="png"
					showmarkers="false"
					showlegend="false"
					yaxistitle="Liczba nieruchomości"
					style="#xml#" >

				<cfchartseries
					type="bar"
					serieslabel="Liczba nieruchomości"
					<!---colorlist="#myColorList#"--->
					query="qPlaces"
					valuecolumn="c"
					itemcolumn="month"
					paintstyle="plain"
					seriesColor="##ddc9ae" >

				</cfchartseries>

				<cfchartseries
					type="line"
					paintstyle="plain"
					seriesColor="##eb0f0f" >

					<cfloop query="qPlaces">
						<cfchartdata item="#qPlaces.month#" value="#srednia_arytmetyczna#" />
					</cfloop>

				</cfchartseries>

				<cfchartseries
					type="curve"
					<!---colorlist="#myColorList#"--->
					query="qPlaces"
					valuecolumn="c"
					itemcolumn="month"
					paintstyle="plain"
					seriesColor="##75bd4e" >

				</cfchartseries>

				</cfchart>
			</div>

			<div class="uiWidgetFooter">
			Raport prezentuje ilość dodanych nieruchomości na przestrzeni ostatnich 12 miesięcy.
			</div>
		</div>
	</div>

	<div class="clearfix"></div>

</div>
</div>



