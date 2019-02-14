<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Przypisz użytkownika do rejonu</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfform name="rejonizacja_formularz_uzytkownicy_rejonu"
					action="index.cfm?controller=rejonizacja&action=uzytkownicy-rejonow">
			
				<ul class="uiList uiForm">
					<li>
						<label for="userid">Użytkownik</label>
						<select id="userid" name="userid" class="select_box">
							<cfoutput query="uzytkownicy">
								<option value="#id#">#givenname# #sn#</option>
							</cfoutput>
						</select>
					</li>
					<li>
						<label for="rejonid">Rejon</label>
						<select id="rejon_def_id" name="rejon_def_id" class="select_box">
							<cfoutput query="rejony">
								<option value="#id#">#nazwa#</option>
							</cfoutput>
						</select>
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


</cfdiv>
