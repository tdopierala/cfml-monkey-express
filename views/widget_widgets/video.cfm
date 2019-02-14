<cfprocessingdirective pageencoding="utf-8" />

<div class="widgetBox">
	<div class="inner">
	
		<div class="widgetHeaderArea">
			<div class="widgetHeaderArea uiWidgetHeader">
				<h3 class="uiWidgetHeaderTitle">Materiały video</h3>
			</div>
		</div>
	
		<div class="widgetContentArea">
			<div class="widgetContentArea uiWidgetContent uiContent">
				
				<table class="uiTable aosTable widgetTable">
					<thead>
						<tr>
							<th class="topBorder rightBorder bottomBorder">Tytuł video</th>
							<th class="topBorder rightBorder bottomBorder">Ilość wyświetleń</th>
							<th class="topBorder rightBorder bottomBorder">Data dodania</th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="video">
							<tr>
								<td class="leftBorder rightBorder bottomBorder l">
									<cfif dateCompare( dateAdd( "d", 3, dataPublikacji ), Now() ) EQ 1>
										<span class="label label-new">nowy</span>
									</cfif> 
									#nazwaMaterialuVideo#
								</td>
								<td class="bottomBorder rightBorder r">#iloscWyswietlen#</td>
								<td class="bottomBorder rightBorder r">#dateFormat(dataPublikacji, "yyyy/mm/dd")# #timeFormat(dataPublikacji, "HH:mm")#</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
				
				<div class="uiWidgetFooter">
					Aby obejżeć materiał video, proszę odwiedzić stronę <a href="http://intranet.monkey.xyz/video" target="blank" title="Materiały video">http://intranet.monkey.xyz/video</a>.
				</div>
			</div>
		</div>
	
		<div class="clearfix"></div>
	
	</div>
</div>