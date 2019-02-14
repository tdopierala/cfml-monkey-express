<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfloop collection="#ankietyFormularza#" item="ankieta" >
				<cfdiv id="idAnkiety#ankieta#" class="rekrutacjaAnkieta">
					<div class="inner">
						<h5 class="uiRekrutacjaAnkietaTitle"><cfoutput>#ankietyFormularza[ankieta]["NAZWAANKIETY"]#</cfoutput></h5>
						
						<cfform name="rekrutacjaAnkieta#ankieta#" action="index.cfm?controller=rekrutacja_rekrutacja&action=zapisz-ankiete">
							<cfinput type="hidden" name="idFormularza" value="#idFormularza#" />
							<cfinput type="hidden" name="idAnkiety" value="#ankieta#" />
							
							<ol class="horizontal">
							<cfset polaAnkiety = ankietyFormularza[ankieta]["POLAANKIETY"] />
							<cfloop query="polaAnkiety">
								<li>
									<cfswitch expression="#polaAnkiety.idTypuPola#" >
										<cfcase value="1">
											<label for="idWartosciAnkiety-<cfoutput>#polaAnkiety.idWartosciAnkiety#</cfoutput>"><cfoutput>#polaAnkiety.nazwaPola#</cfoutput></label>
											<cfinput type="text" name="idWartosciAnkiety-#polaAnkiety.idWartosciAnkiety#" class="input" value="#polaAnkiety.wartoscPolaAnkiety#" /> 
										</cfcase>
										
										<cfcase value="2">
											<label for="idWartosciAnkiety-<cfoutput>#polaAnkiety.idWartosciAnkiety#</cfoutput>"><cfoutput>#polaAnkiety.nazwaPola#</cfoutput></label>
											<cfquery name="podpowiedzi" dbtype="query" >
												select * from wartosciPol
												where idDefinicjiPola = #polaAnkiety.idDefinicjiPola#;
											</cfquery>
											<select name="idWartosciAnkiety-<cfoutput>#polaAnkiety.idWartosciAnkiety#</cfoutput>" class="select_box">
												<option value=""></option>
												<cfloop query="podpowiedzi">
													<option value="<cfoutput>#podpowiedzi.wartoscTypuPola#</cfoutput>" <cfif podpowiedzi.wartoscTypuPola IS polaAnkiety.wartoscPolaAnkiety> selected="selected" </cfif> ><cfoutput>#podpowiedzi.wartoscTypuPola#</cfoutput></option>
												</cfloop>
											</select>
										</cfcase>
									</cfswitch>
								</li>
							</cfloop>
							
							<li><cfinput type="submit" name="rekrutacjaAnkieta#ankieta#Submit" value="Zapisz" class="btn btn-green" /></li>
							
							</ol>
						</cfform>
					</div>
				</cfdiv>
			</cfloop>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>