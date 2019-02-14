<cfsilent>



</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

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
						<th class="leftBorder topBorder rightBorder bottomBorder">Nazwa formularza</th>
						<th class="topBorder rightBorder bottomBorder">Ilość atrybutów/pól</th>
						<th class="topBorder rightBorder bottomBorder">Akcje</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="formularze">
						<tr>
							<td class="leftBorder bottomBorder rightBorder l">#form_name#</td>
							<td class="bottomBorder rightBorder r">#attributes_number#</td>
							<td class="bottomBorder rightBorder">
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_forms&action=remove-form&formid=#id#', 'uiStoreForms')" class="icon-remove" title="Usuń formularz"><span>Usuń formularz</span></a>
								
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_forms&action=edit-form&formid=#id#', 'uiStoreForms')" class="icon-edit" title="Edytuj definicję formularza"><span>Edytuj definicję formularza</span></a>
							</td>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<th class="leftBorder bottomBorder rightBorder" colspan="3">
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_forms&action=add-form', 'uiStoreForms')" title="Dodaj nowy formularz">Dodaj nowy formularz</a>
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
