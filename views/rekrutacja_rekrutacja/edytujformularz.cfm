<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Edytuj formularz</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			<cfdiv id="edytujFormularz#idFormularza#">
				<cfform name="edytujFormularz" action="index.cfm?controller=rekrutacja_rekrutacja&action=zapisz-formularz">
					<cfinput type="hidden" name="idFormularza" value="#idFormularza#" />
					
					<ol class="horizontal_right">
						<cfoutput query="polaFormularza">
							<li>
								<cfswitch expression="#idTypuPola#">
									<cfcase value="1">
										<label for="idWartosciFormularza#idWartosciFormularza#">#nazwaPola#</label>
										<cfinput type="text" class="input" name="idWartosciFormularza-#idWartosciFormularza#" value="#polaFormularza.wartoscPolaFormularza#" />
									</cfcase>
								</cfswitch> 
							</li>
						</cfoutput>
						
						<li>
							<span class="labelBlock">&nbsp;</span>
							<cfinput name="edytujFormularz" type="submit" value="Zapisz" class="btn btn-green" />
						</li>
						
					</ol>
					
				</cfform>
			</cfdiv>
			
			<div class="uiFooter">
				<ol class="vertical inline">
					<li><a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_rekrutacja&action=ankiety&idFormularza=<cfoutput>#idFormularza#</cfoutput>', 'rekrutacja_suplementy')" class="web-button-orange web-button--with-hover" title="Ankiety">Ankiety</a></li>
					<li><a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_rekrutacja&action=plikiFormularza&idFormularza=<cfoutput>#idFormularza#</cfoutput>', 'rekrutacja_suplementy')" class="web-button-orange web-button--with-hover" title="Pliki">Pliki</a></li>
				</ol>
				
				<cfdiv id="rekrutacja_suplementy"></cfdiv>
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
