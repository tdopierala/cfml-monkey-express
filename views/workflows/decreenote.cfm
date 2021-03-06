<cfoutput>
	<div class="wrapper">
	
		<h3>Dekret</h3>
		
		<div class="wrapper">
		
			<cfoutput>#includePartial(partial="/workflows/previewsubnav")#</cfoutput>
		
		</div>
				
		<div class="wrapper"> <!--- Wrapper notki dekretacyjnej --->
		
			<div class="decreeNotes"> <!--- Notka dekretacyjne --->
			
				<div class="decreeNoteElement">
					
					<h5>Wprowadzenie dokumentu do obiegu</h5>
					<p>#DateFormat(workflowcreated.workflowcreated, "dd/mm/yyyy")# #TimeFormat(workflowcreated.workflowcreated, "HH:mm")# przez #workflowcreated.givenname# #workflowcreated.sn#</p>
					
					<!--- Informacje o dokumencie, cena, daty dodania, wystawienia, itp --->
					<div class="documentBasicInformation">
						<div class="documentDetailsElements"> <!--- podgląd factory i wpisanych informacji --->
						
							<!--- Numer faktury wyświetlany w nagłówku --->
							<div class="documentDetailsElementName">Faktura numer 
								<cfloop query="documentattributes">
									<cfif attributename eq 'Numer faktury'>
										#documentattributetextvalue#
										<cfbreak>
									</cfif>	
								</cfloop>
							</div>
							
							<div class="documentDetailsElementItems">
								<cfset index = 1>
								<ul>
								<cfloop query="documentattributes">
									
									<cfif attributename eq 'Numer faktury'>
										<cfcontinue>
									</cfif>
									
										<li><span class="b">#attributename#</span> #documentattributetextvalue# </li>
									
								<cfset index++>
								</cfloop>
								</ul>
							</div>
						</div><!--- koniec podglądu faktury i wszystkich wpisanych informacji --->
					</div>
					<!--- Koniec informacji o dokumencie, cenie, dacie, wystawieniu, itp. --->
					
					<!--- Tutaj znajdują się informacje o Kontrahencie pobrane z lokalnej bazy --->
					<div class="documentBasicInformation" style="margin-bottom: 40px;">
						<div class="documentDetailsElements"> <!--- podgląd faktury i wpisanych informacji --->
						
							<!--- Numer faktury wyświetlany w nagłówku --->
							<div class="documentDetailsElementName">Kontrahent</div>
							
							<div class="documentDetailsElementItems">
								<ul>
									<li><span class="">#contractor.nazwa1#</span></li>
									<li><span class="">#contractor.typulicy# #contractor.ulica# <cfif Len(contractor.nrdomu)>nr. domu #contractor.nrdomu#</cfif> <cfif Len(contractor.nrlokalu)> nr. lokalu #contractor.nrlokalu#</cfif></span></li>
									<li><span class="">#contractor.kodpocztowy# #contractor.miejscowosc#</span></li>
									<li><span class="">#contractor.nip#</span></li>
									<li><span class="">#contractor.regon#</span></li>
								</ul>
							</div>
						</div>
					</div>
					<!--- Koniec informacji o Kontrahencie --->
							
					
				</div> <!--- end decreeNoteElement --->
				
				<div class="clear"></div>
				
				<cfloop query="workflowsteps">
					
					<!--- Jeśli krokiem jest opisywanie dokumentu --->
					<cfif workflowstepstatusid eq 1>
						
						<div class="decreeNoteElement">
						
							<h5>Opisywanie dokumentu</h5>
							<p>#DateFormat(workflowstepended, "dd/mm/yyyy")# #TimeFormat(workflowstepended, "HH:mm")# przez #givenname# #sn#</p>
							
							<!--- Opis faktury dodany w pierwszym kroku --->
							<div class="description">
								<table class="smallTable" id="descriptionNoteTable">
									<thead>
										<tr>
											<th class="c leftBorder rightBorder topBorder bottomBorder">Opis merytoryczny</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td class="leftBorder rightBorder bottomBorder">
												<cfif Len(workflowstepnote)>
													#workflowstepnote#
												</cfif>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<!--- Koniec opisu dodanego w pierwszym kroku --->
			
							<!--- Tabelka z mpk, projekt i netto --->
							<div class="description">
								<table class="smallTable" id="descriptionTable">
									<thead>
										<tr>
											<th class="leftBorder bottomBorder topBorder c">MPK</th>
											<th class="leftBorder bottomBorder topBorder c">Projekt</th>
											<th class="leftBorder bottomBorder rightBorder topBorder c">Kwota netto</th>
										</tr>
									</thead>
									<tbody>
										<cfloop query="workflowstepdescription">
											<tr class="workflowstepdescription-#id#">
												<td class="leftBorder bottomBorder">#mpk# - #m_nazwa#</td>
												<td class="leftBorder bottomBorder">#projekt# - #p_nazwa#; #p_opis#; #miejscerealizacji#</td>
												<td class="leftBorder bottomBorder rightBorder">#workflowstepdescription#</td>
											</tr>
										</cfloop>
									</tbody>
									<tfoot></tfoot>
								</table>
							</div>
							<!--- Koniec tabelki mpk, projekt, netto --->
						
						</div>
						
						<cfbreak>
						
					</cfif>	
				
				</cfloop>
			
				<cfloop query="workflowsteps">
					
					<!--- Jeśli krokiem jest opisywanie dokumentu --->
					<cfif workflowstepstatusid eq 2>
						
						<div class="decreeNoteElement">
						
							<h5>Controlling</h5>
							<p>#DateFormat(workflowstepended, "dd/mm/yyyy")# #TimeFormat(workflowstepended, "HH:mm")# przez #givenname# #sn#</p>
							<p>#workflowstepnote#</p>
						
						</div>
						
						<cfbreak>
						
					</cfif>	
				
				</cfloop>
				
				<cfloop query="workflowsteps">
					
					<!--- Jeśli krokiem jest opisywanie dokumentu --->
					<cfif workflowstepstatusid eq 3>
						
						<div class="decreeNoteElement">
						
							<h5>Zatwierdzenie</h5>
							<p>#DateFormat(workflowstepended, "dd/mm/yyyy")# #TimeFormat(workflowstepended, "HH:mm")# przez #givenname# #sn#</p>
							<p>#workflowstepnote#</p>
						
						</div>
						
						<cfbreak>
						
					</cfif>	
				
				</cfloop>
				
				<cfloop query="workflowsteps">
					
					<!--- Jeżeli krokiem jest księgowość --->
					<cfif workflowstepstatusid eq 4>
						
						<div class="decreeNoteElement">
						
							<h5>Księgowość</h5>
							<p>#DateFormat(workflowstepended, "dd/mm/yyyy")# #TimeFormat(workflowstepended, "HH:mm")# przez #givenname# #sn#</p>
							<p>#workflowstepnote#</p>
							
							<div class="description">
							
								<!--- Notka dekretacyjna pobierana z Acceso --->
								<table cellspacing="0" border="0" class="smallTable">
									<thead>
										<tr>
											<th colspan="6">
												<cfloop query="documentattributes">
													<cfif attributename eq 'Numer faktury'>
														#documentattributetextvalue#
														<cfbreak>
													</cfif>	
												</cfloop>
											</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td rowspan="2" class="leftBorder rightBorder bottomBorder c">Kwota</td>
											<td colspan="2" class="bottomBorder rightBorder c">Konto</td>
											<td colspan="3" class="bottomBorder rightBorder c">Wymiary</td>
										</tr>
										<tr>
											<td class="rightBorder bottomBorder c">WN</td>
											<td class="rightBorder bottomBorder c">MA</td>
											<td class="rightBorder bottomBorder c">PR</td>
											<td class="rightBorder bottomBorder c">MPK</td>
											<td class="rightBorder bottomBorder c">PP</td>
										</tr>
										<cfloop query="assecodecreenote">
											<tr>
												<td class="leftBorder bottomBorder rightBorder">#KWOTA#</td>
												<td class="bottomBorder rightBorder">#KONTO_WN#</td>
												<td class="bottomBorder rightBorder">#KONTO_MA#</td>
												<td class="bottomBorder rightBorder">#PROJEKT#</td>
												<td class="bottomBorder rightBorder">#MPK#</td>
												<td class="bottomBorder rightBorder">#PPROJEKT#</td>
											</tr>
										</cfloop>
									</tbody>
								</table>
								<!--- Koniec notki dekretacyjnej pobieranej z Asseco --->
							
							</div>
						
						</div>
						
						<cfbreak>
						
					</cfif>	
				
				</cfloop>
				
				<cfloop query="workflowsteps">
					
					<!--- Jeśli krokiem jest akceptacja przez Pana Prezesa --->
					<cfif workflowstepstatusid eq 5>
						
						<div class="decreeNoteElement">
						
							<h5>Akceptacja</h5>
							<p>#DateFormat(workflowstepended, "dd/mm/yyyy")# #TimeFormat(workflowstepended, "HH:mm")# przez #givenname# #sn#</p>
							<p>#workflowstepnote#</p>
						
						</div>
						
						<cfbreak>
						
					</cfif>	
				
				</cfloop>
			
			</div> <!--- Notka dekretacyjna --->
		
		</div> <!--- Wrapper notki dekretacyjnej --->
	
	</div> <!--- koniec wrapper dla całego widoku --->
	
</cfoutput>
