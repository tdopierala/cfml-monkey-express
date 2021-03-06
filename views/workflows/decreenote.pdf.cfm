<cfdocument format="pdf" fontEmbed="yes" pageType="A4">

<STYLE TYPE="text/css" MEDIA="screen, projection">
<!--
  @import url("stylesheets/pdf.css");

-->
</STYLE>

<cfoutput>
	<div class="wrapper pdf">

		<div class="decreeNotes"> <!--- Notka dekretacyjne --->
			
			<div class="decreeNoteElement">
				
				<span class="h2">Wprowadzenie dokumentu do obiegu</span>
				<p>#DateFormat(workflowcreated.workflowcreated, "dd-mm-yyyy")# #TimeFormat(workflowcreated.workflowcreated, "HH:mm")# przez #workflowcreated.givenname# #workflowcreated.sn#</p>
				
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
							<table>
								<cfloop query="documentattributes">
									
									<cfif attributename eq 'Numer faktury'>
										<cfcontinue>
									</cfif>
									
									<tr>
										<td>#attributename#</td>
										<td>#documentattributetextvalue#</td>
									</tr>

								<cfset index++>
								</cfloop>
							</table>
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
								<li><span class="contractor">#contractor.nazwa1#</span></li>
								<li><span class="contractor">#contractor.typulicy# #contractor.ulica# <cfif Len(contractor.nrdomu)>nr. domu #contractor.nrdomu#</cfif> <cfif Len(contractor.nrlokalu)> nr. lokalu #contractor.nrlokalu#</cfif></span></li>
								<li><span class="contractor">#contractor.kodpocztowy# #contractor.miejscowosc#</span></li>
								<li><span class="contractor">#contractor.nip#</span></li>
								<li><span class="contractor">#contractor.regon#</span></li>
							</ul>
						</div>
					</div>
				</div>
				<!--- Koniec informacji o Kontrahencie --->
						
				
			</div> <!--- end decreeNoteElement --->
			
			<div class="clear">&nbsp;</div>
			
			<cfloop query="workflowsteps">
				
				<!--- Jeśli krokiem jest opisywanie dokumentu --->
				<cfif workflowstepstatusid eq 1>
					
					<div class="decreeNoteElement">
					
						<span class="h2">Opisywanie dokumentu</span>
						<p>#DateFormat(workflowstepended, "dd-mm-yyyy")# #TimeFormat(workflowstepended, "HH:mm")# przez #givenname# #sn#</p>
						
						<!--- Opis faktury dodany w pierwszym kroku --->
						<div>
							<table class="smallTable" id="descriptionNoteTable" cellspacing="0">
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
						
						<div class="clear">&nbsp;</div>
						
						<!--- Tabelka z mpk, projekt i netto --->
						<div>
							<table class="smallTable" id="descriptionTable" cellspacing="0">
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
		
			<div class="clear">&nbsp;</div>
			
			<cfloop query="workflowsteps">
				
				<!--- Jeśli krokiem jest controlling --->
				<cfif workflowstepstatusid eq 2>
					
					<div class="decreeNoteElement">
					
						<span class="h2">Controlling</span>
						<p>#DateFormat(workflowstepended, "dd-mm-yyyy")# #TimeFormat(workflowstepended, "HH:mm")# przez #givenname# #sn#</p>
						<p>#workflowstepnote#</p>
					
					</div>
					
					<cfbreak>
					
				</cfif>	
			
			</cfloop>
			
			<div class="clear">&nbsp;</div>
			<cfloop query="workflowsteps">
				
				<!--- Jeśli krokiem jest opisywanie dokumentu --->
				<cfif workflowstepstatusid eq 3>
					
					<div class="decreeNoteElement">
					
						<span class="h2">Zatwierdzenie</span>
						<p>#DateFormat(workflowstepended, "dd-mm-yyyy")# #TimeFormat(workflowstepended, "HH:mm")# przez #givenname# #sn#</p>
						<p>#workflowstepnote#</p>
					
					</div>
					
					<cfbreak>
					
				</cfif>	
			
			</cfloop>
			
			<cfloop query="workflowsteps">
				
				<!--- Jeżeli krokiem jest księgowość --->
				<cfif workflowstepstatusid eq 4>
					
					<div class="decreeNoteElement">
					
						<span class="h2">Księgowość</span>
						<p>#DateFormat(workflowstepended, "dd-mm-yyyy")# #TimeFormat(workflowstepended, "HH:mm")# przez #givenname# #sn#</p>
						<p>#workflowstepnote#</p>
						
						<div>
						
							<!--- Notka dekretacyjna pobierana z Asseco --->
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
					
						<span class="h2">Akceptacja</span>
						<p>#DateFormat(workflowstepended, "dd-mm-yyyy")# #TimeFormat(workflowstepended, "HH:mm")# przez #givenname# #sn#</p>
						<p>#workflowstepnote#</p>
					
					</div>
					
					<cfbreak>
					
				</cfif>	
			
			</cfloop>
		
		</div> <!--- Notka dekretacyjna --->
			
	</div> <!--- koniec wrapper dla całego widoku --->
	
</cfoutput>

</cfdocument>