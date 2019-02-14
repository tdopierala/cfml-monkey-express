<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">
<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Dodaj rejon</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfform name="rejonizacja_formularz_dodawania_rejonu"
					action="index.cfm?controller=rejonizacja&action=dodaj-rejon">
			
				<ul class="uiList uiForm">
					<li>
						<label for="nazwa">Nazwa rejonu</label>
						<cfinput type="text" name="nazwa" class="input" />
					</li>
					<li>
						<label for="wojewodztwoid">Województwo</label>
						<select id="wojewodztwoid" name="wojewodztwoid" class="select_box">
							<option value="0">[wybierz]</option>
							<cfoutput query="wojewodztwa">
								<option value="#id#">#UCase(Left(wojewodztwo, 1))&LCase(Mid(wojewodztwo, 2, Len(wojewodztwo)))#</option>
							</cfoutput>
						</select>
					</li>
					<li>
						<div class="box lista_powiatow">
							
						</div>
					</li>
					<li>
						<div class="box dodane_powiaty">
							
						</div>
					</li>
					<li>
						<label for="rejonizacja_formularz_dodawania_rejonu_submit"></label>
						<cfinput type="submit" name="rejonizacja_formularz_dodawania_rejonu_submit" 
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
