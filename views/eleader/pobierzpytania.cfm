<cfprocessingdirective pageencoding="utf-8" />

<tr>
	<td colspan="20" class="leftBorder bottomBorder rightBorder">
		<div class="inside_table inside_table_padding">
			<table class="uiTable aosTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">Pytanie</th>
						<th class="topBorder rightBorder bottomBorder">Odpowiedź</th>
						<th class="topBorder rightBorder bottomBorder">Punkty</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="listaPytan">
						<tr>
							<td class="leftBorder rightBorder bottomBorder whiteBackground l">#nazwapola#</td>
							<td class="rightBorder bottomBorder whiteBackground">
								<cfif UCase(wartoscpola) EQ 'NIE'>
									<span class="redText">#wartoscpola#</span>
								<cfelse>
									
									<cfif Len(wartoscbinaria)>
										<a href="index.cfm?controller=eleader&action=pobierz-zdjecie&idzadania=#iddefinicjizadania#&idpola=#iddefinicjipola#&idaktywnosci=#idaktywnosci#&ajax=true" class="prettyphoto" title="Pobierz zdjęcie" rel="prettyPhoto">#wartoscpola#</a>
										
									<cfelse>
										#wartoscpola#
									</cfif>
									
								</cfif>
							</td>
							<td class="rightBorder bottomBorder whiteBackground">
								#punkty#
							</td>
						</tr>
					</cfoutput>
				</tbody>
			</table>
		</div>
	</td>
</tr>