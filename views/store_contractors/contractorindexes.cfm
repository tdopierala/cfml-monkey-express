<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Asortyment</h3>
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
						<th class="leftBorder topBorder rightBorder bottomBorder">Lp.</th>
						<th class="topBorder rightBorder bottomBorder">Nazwa produktu</th>
						<th class="topBorder rightBorder bottomBorder">Indeks</th>
						<th class="topBorder rightBorder bottomBorder">VAT</th>
						<th class="topBorder rightBorder bottomBorder">Termin przydatności</th>
					</tr>
				</thead>
				<tbody>
					<cfset indeks = 1 />
					<cfoutput query="produkty">
						<tr>
							<td class="leftBorder bottomBorder rightBorder">#indeks#</td>
							<td class="bottomBorder rightBorder l">#index_name#</td>
							<td class="bottomBorder rightBorder r">#index_index#</td>
							<td class="bottomBorder rightBorder r">#index_vat#</td>
							<td class="bottomBorder rightBorder r">#index_valid#</td>
						</tr>
						<cfset indeks++ />
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