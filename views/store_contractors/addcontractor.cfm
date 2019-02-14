<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Formularz dodawania kontrahenta</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<cfif IsDefined("results")>
				<div class="uiMessage <cfif results.success is true> uiConfirmMessage <cfelse> uiErrorMessage </cfif>"><cfoutput>#results.message#</cfoutput>
				</div>
			</cfif>
			
			<cfform name="add_store_contractor_form" action="index.cfm?controller=store_contractors&action=add-contractor">
				
				<ol class="horizontal">
					<li>
						<label for="logo">Numer logo</label>
						<cfinput type="text" name="logo" class="input" /> <a href="javascript:void(0)" class="btn checkStoreContractor" title="Sprawdź kontrahenta">Pobierz z bazy</a>
					</li>
					<li>
						<label for="contractor_name">Nazwa dostawcy</label>
						<cfinput type="text" name="contractor_name" class="input" />
					</li>
					<li>
						<label for="contractor_type_id">Typ dostawcy</label>
						<select name="contractor_type_id" class="select_box">
							<cfoutput query="typyDostawcow">
								<option value="#id#">#type_name#</option>
							</cfoutput>
						</select>
					</li>
					<li>
						<label for="contractor_city">Miasto</label>
						<cfinput type="text" name="contractor_city" class="input" />
					</li>
					<li>
						<label for="contractor_street">Ulica</label>
						<cfinput type="text" name="contractor_street" class="input "/>
					</li>
					<li>
						<label for="contractor_postal_code">Kod pocztowy</label>
						<cfinput type="text" name="contractor_postal_code" class="input" />
					</li>
					<li>
						<label for="hour_from">Godzina od</label>
						<cfinput type="text" name="hour_from" class="input" />
					</li>
					<li>
						<label for="hour_to">Godzina do</label>
						<cfinput type="text" name="hour_to" class="input" />
					</li>
					<li>
						<label for="dni_dostaw">Dni dostaw</label>
						<cfinput type="text" name="dni_dostaw" class="input" />
					</li>
					<li>
						<label for="zwroty_towaru">Zwroty towaru</label>
						<cfinput type="text" name="zwroty_towaru" class="input" />
					</li>
					<li>
						<label for="contractor_telephone">Dane kontaktowe</label>
						<cfinput type="text" name="contractor_telephone" class="input" />
					</li>
					<li>
						<cfinput type="submit" name="add_store_contractor_form_submit"
								 class="admin_button green_admin_button" value="Zapisz">
						<a href="index.cfm?controller=store_contractors&action=contractors" title="Lista kontrahentów" class="">Wróć</a>
					</li>
				</ol>
				
			</cfform>
			
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

<cfset ajaxOnLoad("initStoreContractors") />