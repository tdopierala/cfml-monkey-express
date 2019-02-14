<cfsilent>
	
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Dodaj nieobecność</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfform name="formularz_dodawania_nieobecnosci"
					action="index.cfm?controller=partners&action=new-absence">
				
				<ol class="uiList uiForm">
					<li>
						<label for="date_from">Od dnia</label>
						<div class="uiFormElement">
							<cfinput type="datefield" name="date_from" class="input" 
									 placeholder="Od dnia"
									 validate="eurodate" 
									 mask="dd/mm/yyyy"/>
						</div> 
					</li>
					<li>
						<label for="date_to">Do dnia</label>
						<div class="uiFormElement">
							<cfinput type="datefield" name="date_to" class="input" 
									 placeholder="Do dnia"
									 validate="eurodate" 
								 	mask="dd/mm/yyyy"/>
						</div>
					</li>
					<li>
						<label for="note">Notatka</label>
						<cftextarea name="note" class="textarea" />
					</li>
					<li>
						<label for="formularz_dodawania_nieobecnosci_submit"></label>
						<cfinput type="submit" name="formularz_dodawania_nieobecnosci_submit"
								 class="admin_button green_admin_button" value="Zapisz" />
					</li>
				</ol>
				
			</cfform>
			
			<div class="uiFooter">
				
				<a href="javascript:ColdFusion.navigate('index.cfm?controller=partners&action=absences&t=1', 'left_site_column')" tite="Wróć do kalendarza nieobecności">Wróć do kalendarza nieobecności.</a>
				
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
</cfdiv>
