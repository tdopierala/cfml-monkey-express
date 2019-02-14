<cfprocessingdirective pageencoding="utf-8" />
	
<tr class="expand-child">
	<td class="leftBorder rightBorder bottomBorder">&nbsp;</td>
	<td colspan="6" class="rightBorder bottomBorder">
		<table class="uiTable aosTable storeObjectTable">
			<thead>
				<tr>
					<th class="leftBorder bottomBorder rightBorder topBorder">Formularz</th>
					<th class="bottomBorder rightBorder topBorder">Ilość</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="formularze">
					<tr>
						<td class="leftBorder bottomBorder rightBorder l">
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_forms&action=form-details&storeid=#storeid#&formid=#form_id#&projekt=#projekt#', 'formContent#storeid#')" title="Szczegóły formularza">#form_name#</a>
						</td>
						<td class="bottomBorder rightBorder r">#form_count#</td>
					</tr>
				</cfoutput>
			</tbody>
		</table>
		
		<div id="formContent<cfoutput>#storeid#</cfoutput>"></div>
		
	</td>
</tr>