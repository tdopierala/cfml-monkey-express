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
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<div class="instance_form_ol_bg">
				<table class="uiTable aosTable instance_form_ol instance_form_ol_left">
					<thead>
						<tr>
							<th class="leftBorder topBorder rightBorder bottomBorder">Atrybut</th>
							<th class="topBorder rightBorder bottomBorder">Typ</th>
							<th class="topBorder rightBorder bottomBorder">Akcje</th>
					</thead>
					<tbody>
						<cfoutput query="obiekt">
							<tr>
								<td class="leftBorder bottomBorder rightBorder l">#attribute_name#</td>
								<td class="bottomBorder rightBorder l">#type_name#</td>
								<td class="bottomBorder rightBorder">
									<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_attributes&action=remove-object-attribute&objectid=#object_id#&attributeid=#attribute_id#&objectattributeid=#object_attribute_id#', 'uiObjectsContainer')" class="icon-remove" title="Usuń atrybut"><span>Usuń atrybut</span></a>
								</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
				
				<ol class="horizontal instance_form_ol attribute_type_submit">
					<li>
						<label for="attrid">Atrybut obiektu</label>
						<select name="attrid" id="attrid" class="select_box">
							<cfoutput query="atrybuty">
								<option value="#id#.#attribute_type_id#.#objectid#">#attribute_name#</option>
							</cfoutput>
						</select>
						<a href="#" class="add_object_definition_attribute" title="Dodaj atrybut do obiektu">+</a>
					</li>
				</ol>
				
			</div>

			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<cfset ajaxOnLoad("initObject") />