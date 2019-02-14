<cfprocessingdirective pageencoding="utf-8" />
	
				<table class="uiTable">
					<thead>
						<tr>
							<th class="leftBorder rightBorder topBorder bottomBorder">Lp.</th>
							<th class="rightBorder topBorder bottomBorder">Numer sklepu</th>
							<th class="rightBorder topBorder bottomBorder">Ulica</th>
							<th class="rightBorder topBorder bottomBorder">Miasto</th>
							<th class="rightBorder topBorder bottomBorder">PPS</th>
							<th class="rightBorder topBorder bottomBorder">KOS</th>
							<th class="rightBorder topBorder bottomBorder">Data obowiązywania od</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<cfset lp = 1 />
							<cfoutput query="listaAos">
								<tr>
									<td class="leftBorder rightBorder bottomBorder">#lp#</td>
									<td class="rightBorder bottomBorder">	
										<a href="javascript:void(0)" onclick="pobierzAosSklepu($(this), '#kodsklepu#')" title="Pobierz Arkusze oceny sklepu">#kodsklepu#</a>
									</td>
									<td class="rightBorder bottomBorder l">#ulica#</td>
									<td class="rightBorder bottomBorder l">#miasto#</td>
									<td class="rightBorder bottomBorder l">#nazwaajenta#</td>
									<td class="rightBorder bottomBorder l">#givenname#</td>
									<td class="rightBorder bottomBorder l">#DateFormat(dataobowiazywaniaod, "dd/mm/yyyy")#</td>
								</tr>
								<cfset lp = lp + 1 />
							</cfoutput>
						</tr>
					</tbody>
				</table>