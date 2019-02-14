<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">
<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Dodaj makroregion</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfform name="rejonizacja_formularz_dodawania_makroregionu"
					action="index.cfm?controller=rejonizacja&action=dodaj-makroregion">
			
				<ul class="uiList uiForm">
					<li>
						<label for="nazwa">Nazwa makroregionu</label>
						<cfinput type="text" name="nazwa" class="input" />
					</li>
					<li>
						<div class="box lista_rejonow">
							<cfoutput query="rejony">
								<span class="rejon_item {rejonid:#id#}">#nazwa#</span>
							</cfoutput>
						</div>
					</li>
					<li>
						<div class="box dodane_rejony">
							
						</div>
					</li>
					<li>
						<label for="rejonizacja_formularz_dodawania_makroregionu_submit"></label>
						<cfinput type="submit" name="rejonizacja_formularz_dodawania_makroregionu_submit" 
								 class="admin_button green_admin_button" value="Zapisz" />
					</li>
				</ul>
			
			</cfform>

			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<cfset ajaxOnLoad("initRejonizacja") />

</cfdiv>
