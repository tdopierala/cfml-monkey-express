<!---<cfdump var="#traffic_report#" >--->

<cfset month_name = ArrayNew(1) />
<cfset month_name[1] = "Styczeń" />
<cfset month_name[2] = "Luty" />
<cfset month_name[3] = "Marzec" />
<cfset month_name[4] = "Kwiecień" />
<cfset month_name[5] = "Maj" />
<cfset month_name[6] = "Czerwiec" />
<cfset month_name[7] = "Lipiec" />
<cfset month_name[8] = "Sierpień" />
<cfset month_name[9] = "Wrzesień" />
<cfset month_name[10] = "Październik" />
<cfset month_name[11] = "Listopad" />
<cfset month_name[12] = "Grudzień" />

<div class="widgetBox">
<div class="inner">

	<div class="widgetHeaderArea">
		<div class="widgetHeaderArea uiWidgetHeader">
			<h3 class="uiWidgetHeaderTitle">Intranet Traffic</h3>
		</div>
	</div>
	
	<div class="widgetContentArea">
		<div class="widgetContentArea uiWidgetContent">

			<div class="uiWidgetChart">
				
				<cfchart
			        format="png"
					showmarkers="false"
					showlegend="false"
			        scalefrom="0"
			        scaleto="1200000"
					chartWidth="700">
				
					<cfchartseries
						type="area"
						serieslabel="Intranet Traffic 2012"
						seriescolor="##EB0F0F">
						
						<cfset counter = 0 />
						<cfloop query="traffic_report">
							
							<cfset counter++ />
							
							<cfif counter gt 12>
								<cfcontinue />
							</cfif>
							
							<cfchartdata item="#month_name[month]#" value="#count#">
						
						</cfloop>
					
					</cfchartseries>
				
					<cfchartseries
						type="area"
						serieslabel="Intranet Traffic 2013"
						seriescolor="##cccccc">
						
						<cfset counter = 0 />
						<cfloop query="traffic_report">
							
							<cfset counter++ />
							
							<cfif counter lt 13>
								<cfcontinue />
							</cfif>
							
							<cfchartdata item="#month_name[month]#" value="#count#">
				
						</cfloop>
						
					</cfchartseries>
			
				</cfchart>
			</div>

			
		</div>
	</div>

	<div class="clearfix"></div>
</div>
</div>