<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Edytuj dostawcę</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfform action="index.cfm?controller=store_contractors&action=edit&contractorid=#dostawca.id#"
					name="store_contractors_edit_form">
				
				<cfinput type="hidden" name="id" value="#dostawca.id#" />
				
				<ol class="horizontal">
					<li>
						<label for="contractor_name">Nazwa dostawcy</label>
						<cfinput type="text" name="contractor_name" value="#dostawca.contractor_name#" class="input" />
					</li>
					<li>
						<label for="contractor_type_id">Typ dostawcy</label>
						<select name="contractor_type_id" class="select_box">
							<cfloop query="typyDostawcow">
								<cfoutput>
									<option value="#typyDostawcow.id#" <cfif typyDostawcow.id EQ dostawca.contractor_type_id> selected="selected" </cfif>>#typyDostawcow.type_name#</option>
								</cfoutput>
							</cfloop>
						</select>
					</li>
					<li>
						<label for="contractor_city">Miasto</label>
						<cfinput type="text" name="contractor_city" value="#dostawca.contractor_city#" class="input" />
					</li>
					<li>
						<label for="contractor_street">Ulica</label>
						<cfinput type="text" name="contractor_street" value="#dostawca.contractor_street#" class="input "/>
					</li>
					<li>
						<label for="contractor_postal_code">Kod pocztowy</label>
						<cfinput type="text" name="contractor_postal_code" value="#dostawca.contractor_postal_code#" class="input" />
					</li>
					<li>
						<label for="hour_from">Godzina od</label>
						<cfinput type="text" name="hour_from" value="#dostawca.hour_from#" class="input" />
					</li>
					<li>
						<label for="hour_to">Godzina do</label>
						<cfinput type="text" name="hour_to" value="#dostawca.hour_to#" class="input" />
					</li>
					<li>
						<label for="dni_dostaw">Dni dostaw</label>
						<cfinput type="text" name="dni_dostaw" value="#dostawca.dni_dostaw#" class="input" />
					</li>
					<li>
						<label for="zwroty_towaru">Zwroty towaru</label>
						<cfinput type="text" name="zwroty_towaru" value="#dostawca.zwroty_towaru#" class="input" />
					</li>
					<li>
						<label for="contractor_telephone">Dane kontaktowe</label>
						<cfinput type="text" name="contractor_telephone" value="#dostawca.contractor_telephone#" class="input" />
					</li>
					<li>
						<cfinput type="submit" name="add_store_contractor_form_submit"
								 class="admin_button green_admin_button" value="Zapisz">
					</li>
				</ol>
					
			</cfform>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>