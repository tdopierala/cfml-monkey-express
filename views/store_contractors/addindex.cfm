<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Dodaj asortyment do dostawcy</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<cfform name="store_contractor_add_index" action="index.cfm?controller=store_contractors&action=add-index&contractorid=#contractorid#">
				
				<cfinput type="hidden" name="store_contractor_id" value="#contractorid#" /> 
				
				<ol class="horizontal">
					
					<li>
						<label for="index_index">Indeks</label>
						<cfinput type="text" class="input" name="index_index" />
						<a href="javascript:void(0)" class="btn checkContractorIndex" title="Sprawdź produkt">Sprawdź</a>
					</li>
					<li>
						<label for="index_name">Nazwa produktu</label>
						<cfinput type="text" class="input" name="index_name" />
					</li>
					<li>
						<label for="index_vat">VAT% [liczba]</label>
						<cfinput type="text" class="input" name="index_vat" />
					</li>
					<li>
						<label for="index_valid">Termin przydatności [dni]</label>
						<cfinput type="text" class="input" name="index_valid" />
					</li>
					<li>
						<label for="index_ean">Kod EAN</label>
						<cfinput type="text" class="input" name="index_ean" />
					</li>
					<li>
						<cfinput type="submit" name="store_contractor_add_index_submit"
								 class="admin_button green_admin_button" value="Zapisz" />
					</li>
				</ol>
				
			</cfform>
			
		</div>
	</div>
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Asortyment dostawcy</h3>
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

<cfset ajaxOnLoad("initContractorIndex") />