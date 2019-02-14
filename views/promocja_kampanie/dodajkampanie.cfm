<cfsilent>
	<cfparam name="FORM.PRZEWIDZIANYBUDZET" default="0" />
	<cfparam name="FORM.NAZWAKAMPANII" default="" />
	<cfparam name="FORM.DATAKAMPANIIOD" default="#DateFormat( Now(), 'dd/mm/yyyy' )#" />
	<cfparam name="FORM.DATAKAMPANIIDO" default="#DateFormat( Now(), 'dd/mm/yyyy' )#" />
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Dodawanie nowej kampanii</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfform name="dodajKampanieForm" action="index.cfm?controller=promocja_kampanie&action=dodaj-kampanie">
				<ol class="horizontal">
					<li>
						<label for="nazwaKampanii">Nazwa kampanii</label>
						<cfinput type="text" name="nazwaKampanii" class="input" />
					</li>
					<li>
						<label for="dataKampaniiOd">Data rozpoczęcia kampanii</label>
						<div class="dateSelect">
							<cfinput type="datefield" validate="eurodate" mask="D/M/YYYY" name="dataKampaniiOd" class="input" />
						</div>
					</li>
					<li>
						<label for="dataKampaniiDo">Data zakończenia kampanii</label>
						<div class="dateSelect">
							<cfinput type="datefield" validate="eurodate" mask="D/M/YYYY" name="dataKampaniiDo" class="input" />
						</div>
					</li>
					<li>
						<label for="przewidzianyBudzet">Przewidziany budżet</label>
						<cfinput type="text" name="przewidzianyBudzet" class="input" />
					</li>
					<li>
						<span class="labelSpacer"></span>
						<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=dodaj-kampanie', 'promocjaKampanie', false, false, 'POST', 'dodajKampanieForm')" class="btn" title="Dodaj kampanię">Zapisz</a>
						<!---<cfinput name="dodajKampanieFormSubmit" type="submit" class="btn" value="Zapisz" />--->
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
