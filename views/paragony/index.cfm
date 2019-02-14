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
				
				<cfform action="#URLFor(controller='Paragony',action='dodajAdres')#" 
						name="paragony_adres_formularz" class="uiForm">	
					<h6 class="top">Adres sklepu konkurencji</h6>
						
					<ol>
						<li>
							<label for="nazwasklepu">Nazwa konkurencyjnego sklepu</label>
							<cfinput type="text" name="nazwasklepu" class="input" />
						</li>
						<li>
							<label for="miasto">Miasto</label>
							<cfinput type="text" name="miasto" class="input" />
						</li>
						<li>
							<label for="adres">Adres</label>
							<cfinput type="text" name="adres" class="input" />
						</li>
						<li>
							<cfinput type="submit" name="paragony_adresy_formularz_submit" class="admin_button green_admin_button" value="Zapisz" />
						</li>
					</ol>

				</cfform>
				
			</div>
		</div>
	</div>

</cfdiv>

