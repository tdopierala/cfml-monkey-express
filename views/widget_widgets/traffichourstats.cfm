<div class="widgetBox">
	<div class="inner">
	
		<div class="widgetHeaderArea">
			<div class="widgetHeaderArea uiWidgetHeader">
				<h3 class="uiWidgetHeaderTitle">Intranet Hour Traffic</h3>
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
						scaleto="120000"
						chartWidth="700">
						
						<cfchartseries
							type="area"
							serieslabel="Intranet Hour Traffic"
							seriescolor="##EB0F0F">
							
							<cfloop query="traffic_report">
								
								<cfchartdata item="#h#" value="#count#">
								
							</cfloop>
					    	
						</cfchartseries>
					</cfchart>
					
				</div>
	
				
			</div>
		</div>
	
		<div class="clearfix"></div>
	</div>
</div>