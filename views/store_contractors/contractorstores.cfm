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

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Sklepy przypisane do dostawcy</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<cfoutput>
			<ul class="uiBlankList">
				<li>#dostawca.contractor_name#</li>
				<li>#dostawca.contractor_street#, #dostawca.contractor_postal_code# #dostawca.contractor_city#</li>
				<li>#dostawca.contractor_telephone#</li>
			</ul>
			</cfoutput>
			
			<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_contractors&action=contractor-stores&contractorid=<cfoutput>#contractorid#</cfoutput>', 'uiContractors')" class="btn">Odśwież</a>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<table class="uiTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">Lp.</th>
						<th class="topBorder rightBorder bottomBorder">Numer</th>
						<th class="topBorder rightBorder bottomBorder">Miasto</th>
						<th class="topBorder rightBorder bottomBorder">Ulica</th>
						<th class="topBorder rightBorder bottomBorder">Kod pocztowy</th>
						<th class="topBorder rightBorder bottomBorder"></th>
					</tr>
				</thead>
				<tbody>
					<cfset index = 1 />
					<cfoutput query="przypisaneSklepy">
						<tr>
							<td class="leftBorder bottomBorder rightBorder c">#index#</td>
							<td class="bottomBorder rightBorder l">#projekt#</td>
							<td class="bottomBorder rightBorder l">#miasto#</td>
							<td class="bottomBorder rightBorder l">#ulica#</td>
							<td class="bottomBorder rightBorder l">#kodpsklepu#</td>
							<td class="bottomBorder rightBorder">
								<cfif ((prezes is false) and (partnerS is false) and (departamentS is false) and (dkin is false)) or root is true>
									<a href="javascript:void(0);" class="icon-remove" title="Usuń sklep od dostawcy" onclick="usunDostawce('#projekt#', #contractorid#, $(this))"><span>Usuń sklep od dostawcy</span></a>
									
									<a href="javascript:void(0);" class="icon-exclude" title="Wyklucz produkty" onclick="javascript:initCfWindow('index.cfm?controller=store_contractors&action=exclude-store-indexes&contractorid=#contractorid#&store=#projekt#', 'exclude-indexes-#contractorid#-#projekt#', 535, 600, 'Wykluczony asortyment #ReReplace(dostawca.contractor_name, """", "", "all")#', true)"><span>Wyklucz asortyment</span></a>
								</cfif>
							</td>
						</tr>
						<cfset index++ />
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="6" class="leftBorder bottomBorder rightBorder">
							<cfif ((prezes is false) and (partnerS is false) and (departamentS is false) and (dkin is false)) or root is true>
								<a href="javascript:initCfWindow('index.cfm?controller=store_contractors&action=stores&contractorid=<cfoutput>#contractorid#</cfoutput>', 'contractor_stores-<cfoutput>#contractorid#</cfoutput>', 535, 600, 'SKLEPY', false)" title="Dodaj sklepy">Dodaj sklepy</a>
							</cfif> 
						</th>
					</tr>
				</tfoot>
			</table>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>