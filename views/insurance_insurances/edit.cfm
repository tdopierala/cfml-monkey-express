<cfprocessingdirective pageencoding="utf-8" />
	
<div class="leftWrapper">
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Edytuj dane polisy</h3>
		</div>
	</div>
	
	<cfinclude template="../insurance_instances/_top.cfm" />
	
	<div class="contentArea">
		<div class="contentArea uiContent">
			<cfform name="insurance_insurance_edit_form"
					action="##">
			
				<ol class="uiList uiForm">
					<li>
						<label for="adres_sklepu">Adres sklepu</label>
						<cfinput type="text" class="input" name="instructionid" />
					</li>
					<li>
						<label for="imie_nazwisko">Imię i naswisko</label>
						<cfinput type="text" class="input" name="imie_nazwisko" />
					</li>
					<li>
						<label for="adres_koresp">Adres korespondencyjny</label>
						<cfinput type="text" class="input" name="adres_koresp" />
					</li>
					<li>
						<label for="telefon_kom">Telefon komórkowy</label>
						<cfinput type="text" class="input" name="telefon_kom" />
					</li>
					<li>
						<label for="adres">Adres</label>
						<cfinput type="text" class="input" name="adres" />
					</li>
					<li>
						<label for="nip">NIP</label>
						<cfinput type="text" class="input" name="nip" />
					</li>
					<li>
						<label for="regon">REGON</label>
						<cfinput type="text" class="input" name="regon" />
					</li>
					<li>
						<cfinput type="submit" 
								 class="admin_button green_admin_button" 
								 value="Zapisz" 
								 name="insurance_insurance_edit_form_submit" />
					</li>
				</ol>
			
			</cfform>
		</div>
	</div>
	
</div>