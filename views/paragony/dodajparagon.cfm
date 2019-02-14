<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

	<div class="leftWrapper">
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Paragony</h3>
			</div>
		</div>
		
		<div class="headerNavArea">
			<div class="headerNavArea uiHeaderNavArea">
				
			</div>
		</div>
		
		<div class="contentArea">
			<div class="contentArea uiContent">
				
				<cfif IsDefined("komunikat")>
					<span class="message-yes-long">Formularz został zapisany.</span>
				</cfif>
				
				<cfform action="#URLFor(controller='Paragony',action='dodajParagon')#" 
						name="paragony_paragon_formularz" class="uiForm">	
					<h6 class="top">Ilość klientów z paragonu</h6>
						
					<ol>
						<li>
							<label for="adresid">Sklep</label>
							<select name="adresid" class="select_box">
							<cfoutput query="adresy">
								<option value="#id#">#nazwasklepu#</option>
							</cfoutput>
							</select>
						</li>
						<li>
							<label for="iloscklientow">Ilość klientów</label>
							<cfinput type="text" name="iloscklientow" class="input" value="0" />
						</li>
						<li class="poleData">
							<label for="databaragonu">Data paragonu</label>
							<cfinput type="datefield" name="dataparagonu" class="input"
							 value="#Now()#" 
							 validate="eurodate" 
							 mask="dd/mm/yyyy" />
						</li>
						<li>
							<cfinput type="submit" name="paragony_paragon_formularz_submit" class="admin_button green_admin_button" value="Zapisz" />
						</li>
					</ol>

				</cfform>
				
			</div>
		</div>
	</div>

</cfdiv>

