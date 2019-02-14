<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Dodawanie obiektu</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfdiv id="uiObjectsContainer">
				
				<ul class="uiObjectTreeStruct">
					<cfoutput query="obiekty">
						<li class="level-#level#">
							<span class="object_item">
								#def_name# (Zdefiniowanych: #instancesnumber#. <a href="javascript:ColdFusion.navigate('index.cfm?controller=objects&action=instance-form&defid=#id#', 'uiObjectsContainer')" class="object_add_inst_link" title="Dodaj instancje">Dodaj obiekt</a>)
							</span>
						</li>
					</cfoutput>
				</ul>
				
				<!---<table class="uiTable aosTable">
					<thead>
						<tr>
							<th class="leftBorder topBorder rightBorder bottomBorder">&nbsp;</th>
							<th class="topBorder rightBorder bottomBorder">Nazwa obiektu</th>
							<th class="topBorder rightBorder bottomBorder">Ilość zdefiniowanych obj</th>
							<th class="topBorder rightBorder bottomBorder">Ilość el podrzędnych</th>
							<th class="topBorder rightBorder bottomBorder">Akcje</th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="obiekt">
							<tr>
								<td class="leftBorder bottomBorder rightBorder">
									<a href="javascript:void(0)" onclick="pobierzDzieci('#id#', $(this))" title="Pobierz dzieci" class="extend">
										<span>&nbsp;</span>
									</a>
								</td>
								<td class="bottomBorder rightBorder l">
									<a href="javascript.ColdFusion.navigate('index.cfm?controller=objects&action=def-instances&defid=#id#', 'uiObjectsContainer')" class="object_def_instances" title="Zobacz dodane obiekty">
										#def_name#
									</a>
								</td>
								<td class="bottomBorder rightBorder r">#iloscobiektow#</td>
								<td class="bottomBorder rightBorder r">#iloscdzieci#</td>
								<td class="bottomBorder rightBorder">
									<a href="javascript:ColdFusion.navigate('index.cfm?controller=objects&action=instance-form&defid=#id#', 'uiObjectsContainer')" title="Dodaj instancje" class="object_add_inst"><span>Dodaj instancje</span></a>
								</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>--->

			</cfdiv>

			<div class="uiFooter">
				
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>


</cfdiv>
