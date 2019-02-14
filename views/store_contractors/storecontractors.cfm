<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="prezes" >
		<cfinvokeargument name="groupname" value="Prezes" />
	</cfinvoke>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Dostawcy regionalni</h3>
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
						<th rowspan="2" class="leftBorder topBorder rightBorder bottomBorder">Lp.</th>
						<th rowspan="2" class="topBorder rightBorder bottomBorder">Nazwa dostawcy</th>
						<th rowspan="2" class="topBorder rightBorder bottomBorder">Miasto</th>
						<th rowspan="2" class="topBorder bottomBorder rightBorder">Typ dostawcy</th>
						<th colspan="2" class="topBorder bottomBorder">Godziny zamówień</th>
						<th rowspan="2" class="topBorder leftBorder rightBorder bottomBorder">Dni dostaw</th>
						<th rowspan="2" class="topBorder rightBorder bottomBorder">Zwroty</th>
						<th rowspan="2" class="topBorder rightBorder bottomBorder">Kontakt</th>
						<th rowspan="2" class="topBorder rightBorder bottomBorder"></th>
					</tr>
					<tr>
						<th class="bottomBorder rightBorder">od</th>
						<th class="bottomBorder">do</th>
					</tr>
				</thead>
				<tbody>
					<cfset index = 1 />
					<cfoutput query="dostawcy">
						<tr>
							<td class="leftBorder bottomBorder rightBorder c">#index#</td>
							<td class="bottomBorder rightBorder l">
								<a onclick="javascript:initCfWindow('index.cfm?controller=store_contractors&action=contractor-indexes&contractorid=#id#', 'contractor-indexes-#id#', 535, 600, 'Asortyment #ReReplace(contractor_name, """", "", "all")#', true)" href="javascript:void(0)" title="Asortyment #contractor_name#">
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
							<td class="bottomBorder rightBorder l">
								<a onclick="javascript:initCfWindow('index.cfm?controller=store_contractors&action=contractor-files&contractorid=#id#', 'contractor-indexes-#id#', 535, 600, 'Pliki', true)" href="javascript:void(0)" class="icon-folder" title="Pliki"><span>Pliki</span></a>
							</td>
						</tr>
						<cfset index++ />
					</cfoutput>
				</tbody>
			</table>
			
			<div class="uiFooter">
				Wszelkie uwagi odnośnie dostawców regionalnych, prosimy kierować na adres <a href="mailto:zakupy_regionalne@monkey.xyz" title="zakupy_regionalne@monkey.xyz">zakupy_regionalne@monkey.xyz</a>.
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>