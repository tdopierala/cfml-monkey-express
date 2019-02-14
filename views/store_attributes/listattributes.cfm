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
						<th class="topBorder rightBorder bottomBorder leftBorder">Nazwa atrybutu</th>
						<th class="topBorder rightBorder bottomBorder">Typ atrybutu</th>
						<th class="topBorder rightBorder bottomBorder">Akcje</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="atrybuty">
						<tr>
							<td class="rightBorder bottomBorder leftBorder l">
								#attribute_name#
							</td>
							<td class="rightBorder bottomBorder l">#type_name#</td>
							<td class="rightBorder bottomBorder">
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_attributes&action=remove-attribute&attributeid=#id#', 'uiObjectsContainer')" class="icon-remove" title="Usuń atrybut"><span>Usuń atrybut</span></a>
							</td>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="3" class="rightBorder bottomBorder leftBorder addAttributeLink">
							
						</th>
					</tr>
				</tfoot>
			</table>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">


			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>

<cfset ajaxOnLoad("initAttributes") />