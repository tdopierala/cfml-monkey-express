<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<table class="uiTable aosTable">
				<thead>
					<tr>
						<th class="topBorder rightBorder bottomBorder leftBorder">&nbsp;
						<th class="topBorder rightBorder bottomBorder">Sklep</th>
						<th class="topBorder rightBorder bottomBorder">Ulica</th>
						<th class="topBorder rightBorder bottomBorder">Miasto</th>
						<th class="topBorder rightBorder bottomBorder">PPS</th>
						<th class="topBorder rightBorder bottomBorder">Ilość obiektów</th>
						<th class="topBorder rightBorder bottomBorder">Akcje</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="obiektyNaSklepach">
						<tr>
							<td class="leftBorder rightBorder bottomBorder">
								<a href="##" class="extend" onclick="pokazObiektySklepu(#store_id#, $(this), '#projekt#')" title="Pokaż obiekty sklepu"><span>&nbsp;</span></a>
							</td>
							<td class="rightBorder bottomBorder l">#projekt#</td>
							<td class="rightBorder bottomBorder l">#ulica#</td>
							<td class="rightBorder bottomBorder l">#miasto#</td>
							<td class="rightBorder bottomBorder l">#nazwaajenta#</td>
							<td class="rightBorder bottomBorder r">
								<cfif objectsnumber GT 0>
									#objectsnumber#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td class="rightBorder bottomBorder">
								<a href="index.cfm?controller=store_objects&action=store-objects&format=els" target="_blank" class="icon-excel" title="Eksportuj listę obiektów do Excela"><span>Eksportuj listę pboektów do Excela</span></a>
								
								<a href="index.cfm?controller=store_objects&action=store-objects&format=pdf" target="_blank" class="icon-pdf" title="Eksportuj listę obiektów do PDF"><span>Eksportuj listę obiektów do PDF</span></a>
								
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_objects&action=add-object-to-store-form&storeid=#store_id#', 'uiObjectsContainer')" class="add_store_object" title="Dodaj obiekt do sklepu"><span>Dodaj obiekt do sklepu</span></a>
							</td>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="7" class="rightBorder bottomBorder leftBorder">
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_objects&action=add', 'uiObjectsContainer')" class="" title="Dodaj nowy obiekt">Dodaj nowy obiekt</a>
						</th>
					</tr>
				</tfoot>
			</table>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<div id="uiObjectsContainer"></div>

			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>
