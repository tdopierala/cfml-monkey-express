<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="prezes" >
		<cfinvokeargument name="groupname" value="Prezes" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="partnerS" >
		<cfinvokeargument name="groupname" value="Partner ds sprzedaży" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="departamentS" >
		<cfinvokeargument name="groupname" value="Departament Sprzedaży" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="dkin" >
		<cfinvokeargument name="groupname" value="Departament Kontroli i Nadzoru" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="root" >
		<cfinvokeargument name="groupname" value="root" />
	</cfinvoke>
	
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Kontrahenci</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<cfif ((prezes is false) and (partnerS is false) and (departamentS is false) and (dkin is false)) or root is true>
				<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_contractors&action=add-contractor', 'uiContractors')" title="Dodaj kontrahenta" class="btn btn-green">Dodaj dostawcę</a>
				
				<cfif IsDefined("sklep") and Len(sklep) GT 0>
					
					<a href="index.cfm?controller=store_contractors&action=sent-contractors-to-store&store=<cfoutput>#sklep#</cfoutput>" title="Wyślij listę dostawców na sklep" class="btn">Wyślij listę do sklepu</a>
					
					<a href="index.cfm?controller=store_contractors&action=contractors&store=<cfoutput>#sklep#</cfoutput>&format=xls" title="Eksport do Excela" class="btn">Eksportuj do Excela</a>
					
				</cfif>
				
			</cfif>
			<a href="index.cfm?controller=store_contractors&action=contractors" title="Lista dostawców" class="btn">Lista dostawców</a>
		</div>
		
		<cfform name="store_contractor_form" action="index.cfm?controller=store_contractors&action=contractors">
			<ol class="horizontal">
				<li>
					<cfinput type="text" name="search" class="input" value="#sklep#" placeholder="Numer sklepu" />
					<cfinput type="submit" name="store_contractors_form_submit" class="admin_button green_admin_button" value="Filtruj" />
				</li>
			</ol>
		</cfform>
		
		<cfif IsDefined("results")>
			<div class="uiMessage <cfif results.success is true> uiConfirmMessage <cfelse> uiErrorMessage </cfif>">
				<cfoutput>#results.message#</cfoutput>
			</div>
		</cfif>
		
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<div id="uiContractors">
				<table class="uiTable">
					<thead>
						<tr>
							<th rowspan="2" class="leftBorder topBorder rightBorder bottomBorder">Lp.</th>
							<th rowspan="2" class="topBorder rightBorder bottomBorder">Nazwa dostawcy</th>
							<th rowspan="2" class="topBorder rightBorder bottomBorder">Miasto</th>
							<th rowspan="2" class="topBorder bottomBorder rightBorder">Typ dostawcy</th>
							<th colspan="2" class="topBorder bottomBorder">Godziny zamówień</th>
							<th rowspan="2" class="topBorder leftBorder rightBorder bottomBorder">Dni dostaw</th>
							<th rowspan="2" class="topBorder rightBorder bottomBorder">Zwroty</th>
							<th rowspan="2" class="topBorder rightBorder bottomBorder">Kontakt</th>
							<th rowspan="2" class="topBorder rightBorder bottomBorder w64"></th>
						</tr>
						<tr>
							<th class="bottomBorder rightBorder">od</th>
							<th class="bottomBorder">do</th>
						</tr>
						<tr>
							<th class="leftBorder rightBorder bottomBorder l" colspan="10">
								<cfform name="contractor_search_form" action="index.cfm?controller=store_contractors&action=contractors">
									<cfinput type="text" name="search_contractor" class="input" placeholder="Szukaj w tabelce dostawców" value="#session.store_contractors.szukaj#" />
									<cfinput type="submit" name="contractor_search_form" class="btn" value="Szukaj" />
								</cfform>
							</th>
						</tr>
					</thead>
					<tbody>
						<cfset index = 1 />
						<cfoutput query="dostawcy"> 
							<tr>
								<td class="leftBorder bottomBorder rightBorder c">#index#</td>
								<td class="bottomBorder rightBorder l">
									<a onclick="javascript:initCfWindow('index.cfm?controller=store_contractors&action=contractor-indexes&contractorid=#id#&store=#sklep#', 'contractor-indexes-#id#', 535, 600, 'Asortyment #ReReplace(contractor_name, """", "", "all")#', true)" href="javascript:void(0)" title="Asortyment #contractor_name#">
								#contractor_name#
									</a>
								</td>
								<td class="bottomBorder rightBorder l">#contractor_city#</td>
								<td class="bottomBorder rightBorder l">#type_name#</td>
								<td class="bottomBorder rightBorder r">#hour_from#</td>
								<td class="bottomBorder r">#hour_to#</td>
								<td class="bottomBorder leftBorder rightBorder l">#dni_dostaw#</td>
								<td class="bottomBorder rightBorder l">#zwroty_towaru#</td>
								<td class="bottomBorder rightBorder l">#contractor_telephone#</td>
								<td class="bottomBorder rightBorder w64">
									<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_contractors&action=contractor-stores&contractorid=#id#', 'uiContractors')" class="icon-price" title="Przypisane sklepy"><span>Przypisane sklepy</span></a>
									
									<cfif ((prezes is false) and (partnerS is false) and (departamentS is false) and (dkin is false)) or root is true>
										
										<a href="javascript:void(0)" class="icon-remove" title="Usuń dostawce" onclick="javascript:usunDefDostawcy(#id#, $(this))"><span>Usuń dostawcę</span></a>
										<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_contractors&action=edit&contractorid=#id#', 'uiContractors')" class="icon-edit" title="Edytuj dostawce"><span>Edytuj dostawcę</span></a>
										
										<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_contractors&action=add-index&contractorid=#id#', 'uiContractors')" class="icon-index" title="Asortyment"><span>Asortyment</span></a>
										
									</cfif>
									
									<a onclick="javascript:initCfWindow('index.cfm?controller=store_contractors&action=contractor-files&contractorid=#id#', 'contractor-indexes-#id#', 535, 600, 'Pliki', true)" href="javascript:void(0)" class="icon-folder" title="Pliki"><span>Pliki</span></a>
									
								</td>
							</tr>
							<cfset index++ />
						</cfoutput>
					</tbody>
				</table>
			</div>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
