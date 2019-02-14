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
						<th class="topBorder rightBorder bottomBorder leftBorder">Nazwa obiektu</th>
						<th class="topBorder rightBorder bottomBorder">Ilość atrybutów</th>
						<th class="topBorder rightBorder bottomBorder">Akcje</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="obiekty">
						<tr>
							<td class="rightBorder bottomBorder leftBorder l">
								#object_name#
							</td>
							<td class="rightBorder bottomBorder r">#attributes_number#</td>
							<td class="rightBorder bottomBorder">
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_objects&action=remove-object&objectid=#id#', 'uiObjectsContainer')" class="icon-remove" title="Usuń obiekt i wszystkie jego instancje"><span>Usuń obiekt i wszystkie jego instancje</span></a>
								
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_objects&action=edit-object&objectid=#id#', 'uiObjectsContainer')" class="icon-edit" title="Edytuj obiekt i jego instancje"><span>Edytuj obiekt i jego instancje</span></a>
								
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_objects&action=object-stores&objectid=#id#', 'uiObjectsContainer')" class="icon-shopping-bag" title="Sklepy, które mają przypisany ten obiekt"><span>Sklepy, które mają przypisany ten obiekt</span></a>
							</td>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="3" class="rightBorder bottomBorder leftBorder">
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
