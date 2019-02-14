<cfprocessingdirective pageencoding="utf-8" />
	
<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Edycja danych</h3>
		</div>
		
		<cfif flashKeyExists("error")>
			<div class="headerArea uiFlash">
				<span class="error"><cfoutput>#flash("error")#</cfoutput></span>
			</div>
		</cfif>
		
		<cfif flashKeyExists("success")>
			<div class="headerArea uiFlash">
				<span class="success"><cfoutput>#flash("success")#</cfoutput></span>
			</div>
		</cfif>
		
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfform name="store_store_edit_form"
					action="#URLFor(controller='Store_stores',action='edit')#" >
				
				<fieldset class="updateUserAttributesForm">
					<legend>Date kontaktowe</legend>
					<ol>
						<li>
							<label for="telefonkom">Telefon komórkowy</label>
							<cfinput type="text"
									 name="telefonkom"
									 class="input required"
									 value="#store.telefonkom#"
									 placeholder="Np. 48728000000" />
						</li>
						<li>
							<label for="telefon">Telefon</label>
							<cfinput type="text"
									 name="telefon"
									 class="input required"
									 value="#store.telefon#" />
						</li>
						<li>
							<cfinput type="checkbox" 
									 name="conditions"
									 value="1" /> Aby zapisać dane musisz zaakceptować <a href="files/priv/Regulamin-powiadomien.pdf" title="Regulamin" target="_blank">regulamin</a>.
						</li>
						<li>
							<cfinput type="submit" 
									 name="store_store_edit_form_submit"
									 class="admin_button green_admin_button"
									 value="Zaisz" /> 
						</li>
					</ol>
				</firldset>
				
			</cfform>

			<div class="uiFooter">
				
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>


<!---<style>
	<!--- .updateUserAttributesForm { background-color: #FAFAFA; border: 1px solid #EBEBEB; padding: 20px; } --->
	.updateUserAttributesForm { margin-bottom: 15px; }
	.updateUserAttributesForm legend { font-weight: bold; }
</style>
<cfoutput>
	
	<div class="wrapper">
		<h3>Edycja: #store.projekt#</h3>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		</cfif>
		
		<div class="wrapper">
			
			#startFormTag(action="passwordChange")#
				
				<fieldset class="updateUserAttributesForm">
					<legend>Zmiana hasła</legend>
					<ol>
						<li>
							#passwordFieldTag(name="old_password", label="Aktualne hasło", labelPlacement="before", class="input")#
						</li>
					
						<li>
							#passwordFieldTag(name="new_password", label="Nowe hasło", labelPlacement="before", class="input")#
						</li>
						
						<li>
							#passwordFieldTag(name="repeat_password", label="Powtórz nowe hasło", labelPlacement="before", class="input")#
						</li>
					</ol>
				</fieldset>
			
			#endFormTag()#
			
			#startFormTag(action="create")#
				
				<fieldset class="updateUserAttributesForm">
					<legend>Edycja danych sklepu</legend>
					<ol>
						<li>
							#textField(objectName="store", property="projekt", label="Numer sklepu", labelPlacement="before", class="input", disabled="true")#
						</li>
					
						<li>
							#textField(objectName="store", property="telefon", label="Numer telefonu stacjonarnego", labelPlacement="before", class="input")#
						</li>
						
						<li>
							#textField(objectName="store", property="telefonkom", label="Numer telefonu komórkowego", labelPlacement="before", class="input")#
						</li>
						
						<li>
							#textField(objectName="store", property="email", label="Adres e-mail", labelPlacement="before", class="input")#
						</li>
						
						<li>
							#textArea(objectName="store", property="adressklepu", label="Adres sklepu", labelPlacement="before", disabled="true")#
						</li>
						
						<li>
							#textField(objectName="store", property="nazwaajenta", label="Imię i nazwisko ajenta", labelPlacement="before", class="input", disabled="true")#
						</li>
					</ol>
				</fieldset>
			
			#endFormTag()#
			
		</div>
	</div>
	
</cfoutput>--->