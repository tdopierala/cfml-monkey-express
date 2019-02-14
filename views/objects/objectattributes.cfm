<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle"><cfoutput>#object.getName()#</cfoutput></h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent" id="dynamicDiv">
	
		<table class="uiTable aosTable">
			<thead>
				<tr>
					<th class="leftBorder topBorder rightBorder bottomBorder">Lp.</th>
					<th class="topBorder rightBorder bottomBorder">Nazwa atrybutu</th>
					<th class="topBorder rightBorder bottomBorder">Typ atrybutu</th>
					<th class="topBorder rightBorder bottomBorder">Akcje</th>
				</tr>
			</thead>
			<tbody>
				<cfset lp = 1 />
				<cfoutput query="atrybuty">
					<tr>
						<td class="leftBorder bottomBorder rightBorder r">#lp#</td>
						<td class="bottomBorder rightBorder l">#attr_name#</td>
						<td class="bottomBorder rightBorder l">#attr_type_name#</td>
						<td class="bottomBorder rightBorder c">
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=objects&action=remove-object-attr&defid=#object.getId()#&attrid=#attr_id#', 'dynamicDiv')" title="Usuń atrybut" class="object_remove_def_attr">
								<span>Usuń atrybut</span>
							</a>
						</td>
					</tr>
					<cfset lp++ />
				</cfoutput>
			</tbody>
			<tfoot>
				<tr>
					<th class="leftBorder bottomBorder rightBorder" colspan="4">
						<a href="javascript:ColdFusion.navigate('index.cfm?controller=objects&action=add-object-attr&defid=<cfoutput>#object.getId()#</cfoutput>', 'dynamicDiv')" title="Dodaj atrybut" class="objects_add_def_attr"><span>Dodaj atrybut</span></a>
					</th>
				</tr>
			</tfoot>
		</table>

		<div class="uiFooter">
		</div>
	</div>
</div>
