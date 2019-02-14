<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			
			<div class="uiSearch">
				<cfform name="storeFormsSearch" action="index.cfm?controller=store_forms&action=stores-forms" class="form" target="uiStoreForms">
					<div class="form-group">
						<label>Szukana fraza</label>
						<cfinput type="text" name="szukaj" class="input form-control" value="#szukaj#" /> 
					</div>
					<div class="form-group">
						<cfinput type="submit" name="storeFormsSearch" class="btn btn-green" value="Szukaj" > 
					</div>
				</cfform>
			</div>
			
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<table class="uiTable aosTable">
				<thead>
					<tr>
						<th class="topBorder rightBorder bottomBorder leftBorder">&nbsp;
						<th class="topBorder rightBorder bottomBorder"><span>Sklep</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>Ulica</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>Miasto</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>PPS</span></th>
						<th class="topBorder rightBorder bottomBorder">Ilość formularzy</th>
						<th class="topBorder rightBorder bottomBorder">Akcje</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="formularzeNaSklepach">
						<tr>
							<td class="leftBorder rightBorder bottomBorder">
								<a href="javascript:void(0)" class="extend" onclick="pokazFormularzeSklepu(#store_id#, '#projekt#', $(this))" title="Pokaż formularze sklepu"><span>&nbsp;</span></a>
							</td>
							<td class="rightBorder bottomBorder l">#projekt#</td>
							<td class="rightBorder bottomBorder l">#ulica#</td>
							<td class="rightBorder bottomBorder l">#miasto#</td>
							<td class="rightBorder bottomBorder l">#nazwaajenta#</td>
							<td class="rightBorder bottomBorder r">
								<cfif formsnumber GT 0>
									#formsnumber#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td class="rightBorder bottomBorder">
								<!---<a href="index.cfm?controller=store_forms&action=store-forms&format=els" target="_blank" class="icon-excel" title="Eksportuj listę obiektów do Excela"><span>Eksportuj listę formularzy do Excela</span></a>--->
								
								<!---<a href="index.cfm?controller=store_forms&action=store-forms&format=pdf" target="_blank" class="icon-pdf" title="Eksportuj listę obiektów do PDF"><span>Eksportuj listę formularzy do PDF</span></a>--->
								
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_forms&action=add-form-to-store&storeid=#store_id#', 'uiStoreForms')" class="add_store_form" title="Dodaj formularz do sklepu"><span>Dodaj formularz do sklepu</span></a>
							</td>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="7" class="rightBorder bottomBorder leftBorder">
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_forms&action=add-form', 'uiStoreForms')" class="" title="Dodaj nowy formularz">Dodaj nowy formularz</a>
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

<cfset ajaxOnLoad("initStoreForms") />
