<cfoutput>

	<div class="wrapper">
	
		<h3>Podgląd dokumentu</h3>
	
		<div class="wrapper">
		
			<cfoutput>#includePartial(partial="/workflows/subnav")#</cfoutput>
		
		</div>
			
		<div class="documentDetailsList">
		
			<div class="documentDetailsThumb"> <!--- Miniaturka faktury --->
				<div class="documentDetailsAttrThumb">Faktura</div>
				<div class="documentDetailsAttrThumbVal">
					#linkTo(
						controller="Documents",
						action="getDocument",
						key=workflowstep.documentid,
						text="<img src='./index.cfm?controller=documents&action=get-thumbnail&key=#workflowstep.documentid#' title='Kliknij any pobrać dokumen' />",
						target="_blank")#
				</div>
			</div> <!--- Koniec miniaturki faktury --->
			
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
		
			<div class="clear"></div>
			
			<!--- Tutaj znajdują się informacje o Kontrahencie pobrane z lokalnej bazy --->
			<div class="documentBasicInformation" style="width:100%;">
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
			
			<div class="clear"></div>
			
			<!--- Opis faktury dodany w pierwszym kroku --->
			<div class="description" style="width: 100%">
				<table class="smallTable" id="descriptionNoteTable">
					<thead>
						<tr>
							<th class="c leftBorder rightBorder topBorder bottomBorder">Opis merytoryczny</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="leftBorder rightBorder bottomBorder">
								<cfif Len(workflowstepdecreenote.workflowstepnote)>
									#workflowstepdecreenote.workflowstepnote#
								</cfif>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!--- Koniec opisu dodanego w pierwszym kroku --->
			
			<!--- Tabelka z mpk, projekt i netto --->
			<div class="description entirePage">
				<table class="smallTable" id="descriptionTable">
					<thead>
						<tr>
							<th class="leftBorder bottomBorder topBorder">MPK</th>
							<th class="leftBorder bottomBorder topBorder">Projekt</th>
							<th class="leftBorder bottomBorder rightBorder topBorder">Kwota netto</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="workflowstepdescription">
							<tr>
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
			
		</div> <!--- koniec documentDetailsList --->
		
	</div> <!--- koniec wrapper --->

</cfoutput>