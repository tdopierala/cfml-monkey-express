<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Wyślij wiadomość SMS</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<cfif IsDefined("session.results")>
				<div class="uiMessage <cfif session.results.success is true> uiConfirmMessage <cfelse> uiErrorMessage </cfif>">
					<cfoutput>#session.results.message#</cfoutput>
				</div>
				<cfset structDelete(session, "results") />
			</cfif>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfform name="komunikatorSmsForm" action="index.cfm?controller=komunikator_sms&action=wyslij">
				<ol class="horizontal">
					<li>
						<label for="listaOdbiorcow">Lista odbiorców</label>
						<cfinput type="text" name="listaOdbiorcow" class="input" />
						<span class="legend">Wpisz numery telefonów oddzielone przecinkiem (,)</span>
					</li>
					<li>
						<label for="grupyUzytkownikow">Grupy użytkowników</label>
						<div class="formBlock">
							<span class="elementGrupUzytkownikow">
								<cfinput type="checkbox" name="grupyUzytkownikow" value="sklepy" />Sklepy
							</span> 
							
							<span class="elementGrupUzytkownikow">
								<cfinput type="checkbox" name="grupyUzytkownikow" value="kos" />KOS
							</span> 
						</div>
					</li>
					<li>
						<label for="trescWiadomosci">Treść wiadomosci</label>
						<textarea name="trescWiadomosci" class="textarea"></textarea>
					</li>
					<li>
						<span class="labelSpacer"></span>
						<cfinput type="submit" class="btn" value="Wyślij" name="komunikatorSmsForm" />
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

