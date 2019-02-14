<cfprocessingdirective pageencoding="utf-8" />

<div class="widgetBox">
	<div class="inner">
	
		<div class="widgetHeaderArea">
			<div class="widgetHeaderArea uiWidgetHeader">
				<h3 class="uiWidgetHeaderTitle">Helpdesk</h3>
			</div>
		</div>
	
		<div class="widgetContentArea">
			<div class="widgetContentArea uiWidgetContent uiContent">
				
				<table class="uiTable aosTable widgetTable">
					<thead>
						<tr>
							<th class="leftBorder topBorder rightBorder bottomBorder">Numer zgłoszenia</th>
							<th class="topBorder rightBorder bottomBorder">Tytuł</th>
							<th class="topBorder rightBorder bottomBorder">Status</th>
							<th class="topBorder rightBorder bottomBorder">Data</th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="zgloszenia">
							<tr>
								<td class="leftBorder rightBorder bottomBorder l">#numerZgloszenia#</td>
								<td class="rightBorder bottomBorder l">#tytulZgloszenia#</td>
								<td class="rightBorder bottomBorder l">#statusZgloszenia#</td>
								<td class="rightBorder bottomBorder r">#dateFormat(dataZmianyStatusu, "yyyy/mm/dd")#</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>

				<div class="uiWidgetFooter">
					Tabela prezentuje zgłoszenia w systemie Helpdesk, które sa przypisane do Twojego sklepu. Dane odświeżają się co godzina.
				</div>
			</div>
		</div>
	
		<div class="clearfix"></div>
	
	</div>
</div>