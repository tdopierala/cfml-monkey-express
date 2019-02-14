<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Planogramy na sklepie <cfoutput>#projekt#</cfoutput></h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			<table class="uiTable">
				<thead>
					<tr>
						<th rowspan="2" class="topBorder rightBorder bottomBorder leftBorder">Sklep</th>
						<th rowspan="2" class="topBorder rightBorder bottomBorder">Typ</th>
						<th rowspan="2" class="topBorder rightBorder bottomBorder">Kategoria</th>
						<th rowspan="2" class="topBorder rightBorder bottomBorder">SKU na planogramie</th>
						<th rowspan="2" class="topBorder rightBorder bottomBorder">TU na planogramie</th>
						<th colspan="3" class="topBorder rightBorder bottomBorder">Daty</th>
						<th rowspan="2" class="topBorder rightBorder bottomBorder">Osoba</th>
						<th rowspan="2" class="topBorder rightBorder bottomBorder">Pliki</th>
					</tr>
					<tr>
						<th class="bottomBorder rightBorder">Planogramu</th>
						<th class="bottomBorder rightBorder">TU</th>
						<th class="bottomBorder rightBorder">Obowiązywania</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="planogramy">
						<tr>
							<td class="l leftBorder bottomBorder rightBorder">#store_type_name#</td>
							<td class="l bottomBorder rightBorder">#shelf_type_name#</td>
							<td class="l bottomBorder rightBorder">#shelf_category_name#</td>
							<td class="r bottomBorder rightBorder">#ilosc_sku_na_planogramie#</td>
							<td class="r bottomBorder rightBorder">#suma_tu_na_planogramie#</td>
							<td class="r bottomBorder rightBorder">#DateFormat(data_dodania_planogramu, "yyyy/mm/dd")#</td>
							<td class="r bottomBorder rightBorder">#DateFormat(data_dodania_total_units, "yyyy/mm/dd")#</td>
							<td class="r bottomBorder rightBorder">#DateFormat(data_obowiazywania_od, "yyyy/mm/dd")#</td>
							<td class="l bottomBorder rightBorder">#givenname# #sn#</td>
							<td class="l bottomBorder rightBorder">
								<a href="files/planograms_totalunits/#file_src#" title="Plik Excel z TU" class="icon-excel" target="blank"><span>Plik Excel z TU</span></a>
								<a href="files/planograms/#plik_planogramu#" title="Plik z planogramem" class="icon-pdf" target="blank"><span>Plik z planogramem</span></a>
							</td>
						</tr>
					</cfoutput>
				</tbody>
			</table>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>