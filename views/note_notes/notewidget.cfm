<cfprocessingdirective pageencoding="utf-8" />

<div class="widgetBox">
	<div class="inner">
	
		<div class="widgetHeaderArea">
			<div class="widgetHeaderArea uiWidgetHeader">
				<h3 class="uiWidgetHeaderTitle">Notatki</h3>
			</div>
		</div>
	
		<div class="widgetContentArea">
			<div class="widgetContentArea uiWidgetContent uiContent">
				
				<table class="uiTable aosTable widgetTable">
					<thead>
						<tr>
							<th class="leftBorder topBorder rightBorder bottomBorder">Lp.</th>
							<th class="topBorder rightBorder bottomBorder">Sklep</th>
							<th class="topBorder rightBorder bottomBorder">Kontrola</th>
							<th class="topBorder rightBorder bottomBorder">Data powstania</th>
							<th class="topBorder rightBorder bottomBorder">Twórca</th>
							<th class="topBorder rightBorder bottomBorder">Ocena</th>
							<th class="topBorder rightBorder bottomBorder">&nbsp;</th>
						</tr>
					</thead>
					<tbody>
						<cfset index = 1 />
						<cfoutput query="notes" maxrows="25">
							<tr>
								<td class="leftBorder rightBorder bottomBorder">#index++#</td>
								<td class="rightBorder bottomBorder l">#UCase(projekt)#</td>
								<td class="rightBorder bottomBorder r">#DateFormat(inspectiondate, "yyyy/mm/dd")#</td>
								<td class="rightBorder bottomBorder r">#DateFormat(notecreated, "yyyy/mm/dd")#</td>
								<td class="rightBorder bottomBorder l">#UCase(Left(user_givenname, 1))##LCase(Right(user_givenname, Len(user_givenname)-1))# #UCase(Left(user_sn, 1))##LCase(Left(Right(user_sn, Len(user_sn)-1), 4))#</td>
								<td class="rightBorder bottomBorder r">#score#</td>
								<td class="rightBorder bottomBorder c">
									<a href="index.cfm?controller=note_notes&action=view&key=#id#" class="preview" title="Podgląd notatki">
										<span>Podgląd</span>
									</a>
								</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
				
				<div class="uiWidgetFooter">
	
				</div>
			</div>
		</div>
	
		<div class="clearfix"></div>
	
	</div>
</div>