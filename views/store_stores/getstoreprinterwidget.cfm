<cfprocessingdirective pageEncoding="utf-8" />

<!---
	Cache strony ustawiony na 10 minut.
--->

<cfcache
	action="cache"
    timespan="#createTimeSpan(0, 0, 10, 0)#" />

<cfsilent>

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
			<h3 class="uiWidgetHeaderTitle">Licznik wydruku</h3>
		</div>
	</div>

	<div class="widgetContentArea">
		<div class="widgetContentArea uiWidgetContent">

			<div class="uiWidgetChart">
				<cfchart
					format="png"
					showmarkers="false"
					showlegend="false"
					yaxistitle="Wydrukowano"
					style="#xml#" >

				<cfchartseries
					type="bar"
					serieslabel="Liczba dokumentów"
					query="printers"
					valuecolumn="printed"
					itemcolumn="last_successfully_contacted_utctime"
					paintstyle="plain" >

				</cfchartseries>

				</cfchart>
			</div>

			<div class="uiWidgetFooter"><cfoutput>
				<ul>
					<li>Numer seryjny drukarki: <span>#printerStatus.serial_number#</span></li>
					<li>Nazwa drukarki: <span>#printerStatus.printer_name#</span></li>
					<!---<li>Stan licznika na #DateFormat(printerStatus.report_time, "mm.dd.yyyy")#: <span>#printerStatus.device_pages_total_end# stron</span></li>--->
				</ul>
				
				<div class="widgetFooterNote">
					Wszelkie problemy związane z drukarką należy kierować do <span>Centrum Obsługi Klienta firmy New Technology Sp. z o.o.</span>
					<ul>
						<li>Call Center New Technology Poland <span>0801 600 900</span></li>
						<li>z tel. komórkowych: <span>22 539 70 39</span></li>
						<li>fax: <span>22 539 70 01</span></li>
						<li>e-mail: <span>callcenter@new-tec.com.pl</span></li>
						<li>godz. <span>08:00 – 16:00 z wyłączeniem dni ustawowo wolnych od pracy</span></li>
					</ul>
				</div>
			</cfoutput></div>
		</div>
	</div>

	<div class="clearfix"></div>
	
	

</div>
</div>