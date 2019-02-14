<cfprocessingdirective pageencoding="utf-8" />
	
<tr class="expand-child">
	<td class="leftBorder bottomBorder">&nbsp;</td>
	<td colspan="6" class="leftBorder rightBorder bottomBorder">
		<table class="uiTable aosTable storeObjectTable">
			<thead>
				<tr>
					<th class="leftBorder bottomBorder rightBorder topBorder">Obiekt</th>
					<th class="bottomBorder rightBorder topBorder">Ilość</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="obiekty">
					<tr>
						<td class="leftBorder bottomBorder rightBorder l">
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_objects&action=object-details&storeid=#storeid#&objectid=#object_id#', 'objectsContent#storeid#')" title="Szczegóły obiektu">#object_name#</a>
						</td>
						<td class="bottomBorder rightBorder r">#object_count#</td>
					</tr>
				</cfoutput>
			</tbody>
		</table>
		
		<div id="objectsContent<cfoutput>#storeid#</cfoutput>"></div>
		
	</td>
</tr>