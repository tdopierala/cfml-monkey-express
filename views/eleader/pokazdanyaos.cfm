<tr>
	<td colspan="20" class="leftBorder bottomBorder rightBorder">
		<div class="inside_table inside_table_padding">
			<table class="uiTable aosTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">Nazwa zadania</th>
						<th class="topBorder rightBorder bottomBorder">Uzyskane punkty</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="listaZadan">
						<tr>
							<td class="leftBorder rightBorder bottomBorder whiteBackground l">
								<a href="javascript:void(0)" onclick="pobierzPytania($(this), '#idaktywnosci#', '#iddefinicjizadania#')" title="Pobierz pytania">
								#nazwazadania#
								</a>
							</td>
							<td class="rightBorder bottomBorder whiteBackground l">#uzyskanepunkty#</td>
						</tr>
					</cfoutput>
				</tbody>
			</table>
		</div>
	</td>
</tr>