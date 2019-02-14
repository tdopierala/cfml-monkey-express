<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Raport pokrycia produktów</h3>
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
						<th class="topBorder rightBorder bottomBorder leftBorder">#</th>
						<th class="topBorder rightBorder bottomBorder">Sklep</th>
						<th class="topBorder rightBorder bottomBorder">PPS</th>
						<th class="topBorder rightBorder bottomBorder">Miasto</th>
						<th class="topBorder rightBorder bottomBorder">Ulica</th>
						<th class="topBorder rightBorder bottomBorder">Sala Sprzedaży</th>
						<th class="topBorder rightBorder bottomBorder">Suma SKU</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="raportPokrycia">
						<tr>
							<td class="leftBorder bottomBorder rightBorder">&nbsp;</td>
							<td class="bottomBorder rightBorder l">
								<a href="javascript:void(0)" class="" title="Przypisane planogramy do sklepu" onclick="javascript:initCfWindow('index.cfm?controller=raporty&action=planogramy-na-sklepie&sklep=#projekt#', 'planogramy-na-sklepie-#projekt#', 635, 900, 'Planogramy na sklepie', true)">#projekt#</a>
							</td>
							<td class="bottomBorder rightBorder l">#nazwaajenta#</td>
							<td class="bottomBorder rightBorder l">#miasto#</td>
							<td class="bottomBorder rightBorder l">#ulica#</td>
							<td class="bottomBorder rightBorder r">#m2_sale_hall#</td>
							<td class="bottomBorder rightBorder r">
								<a href="index.cfm?controller=raporty&action=indeksy-na-sklepie&sklep=#projekt#" target="blank" title="Plik Excel z indeksami na sklepie" class="">#sku#</a>
							</td>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="7" class="l leftBorder bottomBorder rightBorder">
							<a href="index.cfm?controller=raporty&action=raport-pokrycia-produktow-excel" title="Eksport do excela" class="icon-excel"><span>Eksport do Excel</span></a>
							<a href="index.cfm?controller=raporty&action=indeksy-na-sklepach" title="Eksport wszystkich indeksów do CSV" class="icon-csv" target="blank"><span>Eksport wszystkich indeksów do CSV</span></a>
							
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=raporty&action=raport-pokrycia-produktow-sieci', 'user_profile_cfdiv')" title="Export raportu pokrycia sieci do CSV" class="icon-zip"><span>Export raportu pokrycia sieci do CSV</span></a>
							
							<a href="index.cfm?controller=raporty&action=daty-planogramow" title="Eksportuj daty planogramów do Excela" class="icon-callendar" target="blank"><span>Eksportuj daty planogramów do Excela</span></a>
							
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=raporty&action=prestock-indeksu', 'user_profile_cfdiv')" title="Raport prestock indeksu w sieci" class="icon-stock"><span>Prestock indeksu w sieci</span></a>
							
							<a href="index.cfm?controller=raporty&action=zerowy-prestock" title="Lista regałów o zerowym prestock" class="icon-numbers" target="blank">
								<span>Lista regałów o zerowym prestock</span>
							</a>
						</th>
					</tr>
				</tfoot>
			</table>
			
			<div class="uiFooter">
				<div class="uiPagination">
					<cfset paginator = 1 />
					<cfset count = Ceiling(raportPokryciaCount/elements) />
					<cfloop index="paginator" from="#paginator#" to="#count#" step="1">
						<cfif paginator EQ session.raport_pokrycia.page>
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=raporty&action=raport-pokrycia-produktow&page=<cfoutput>#paginator#</cfoutput>', 'left_site_column')" class="active"><span><cfoutput>#paginator#</cfoutput></span></a>
						<cfelse>
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=raporty&action=raport-pokrycia-produktow&page=<cfoutput>#paginator#</cfoutput>', 'left_site_column')" class=""><span><cfoutput>#paginator#</cfoutput></span></a>
						</cfif>
					</cfloop>
				</div>
			</div>
		</div>
	</div>

	<div class="footerArea">
		
		
	</div>

</div>

</cfdiv>