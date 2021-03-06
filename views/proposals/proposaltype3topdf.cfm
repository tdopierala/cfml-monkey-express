<cfset filename = "#ExpandPath('files/proposals/')#proposal_#proposal.id#_#DateFormat(proposal.proposalcreated, 'dd-mm-yyyy')#.pdf" />
<cfset savefilename = "proposal_#proposal.id#_#DateFormat(proposal.proposalcreated, 'dd-mm-yyyy')#.pdf" />

<cfif FileExists(filename)> <!--- Jeśli plik już istnieje to go usuwam i generuje nowy --->

	<cffile  
	    action = "delete" 
	    file = "#filename#">

<!---
	<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
	<cfheader name="Expires" value="#Now()#" />
	<cfcontent type="application/pdf" file="#filename#" />
--->
</cfif>

<cfdocument format="pdf" fontEmbed="yes" pageType="A4" name="protocolpdf">

<style type="text/css" media="screen">
<!--
  @import url("stylesheets/proposalpdf.css");
	.proposalcontent ul { list-style: none; }
	.proposalcontent div { padding: 5px; clear:both; }
	.proposalcontent div span { width: 500px; float: left; }
	.proposalcontent div span.name { width: 150; }
-->
</style>

	<div class="wrapper pdf">
	
		<cfoutput>#imageTag("logo_monkey_RGB.png")#</cfoutput>
		
		<div class="contactincofmation">
			<span class="h0">Monkey Group</span>ul. Wojskowa 6, 60-792 Poznań
		</div>
		<div class="wherewhen">
			<cfloop query="proposalattributes">
			
				<cfif attributeid eq 133>
					<cfoutput>#proposalattributevaluetext#</cfoutput>
				</cfif>
			
			</cfloop>
		</div>
		
		<div class="user">
			<ul>
				<cfloop query="proposalattributes">
					<cfif attributeid eq 132>
						<li><span>Imię i nazwisko</span> <cfoutput>#proposalattributevaluetext#</cfoutput></li>
					</cfif>
					
					<cfif attributeid eq 130>
						<li><span>Departament</span> <cfoutput>#proposalattributevaluetext#</cfoutput></li>
					</cfif>
					
					<cfif attributeid eq 131>
						<li><span>Stanowisko</span> <cfoutput>#proposalattributevaluetext#</cfoutput></li>
					</cfif>
					
					<cfif attributeid eq 135>
						<li><span>Rodzaj wniosku</span> <cfoutput>#proposalattributevaluetext#</cfoutput></li>
					</cfif>
					
					<cfif attributeid eq 202>
						<cfset eventname = proposalattributevaluetext />
					</cfif>
				</cfloop>
			</ul>
		</div>
		
		
		<span class="h1"><cfoutput>#proposal.proposaltypename#</cfoutput></span>	
		
		<div class="proposalcontent">
Zgłaszam wniosek o udział w <cfoutput>#eventname#</cfoutput> w dniach od 
			<cfloop query="proposalattributes">
			
				<cfif attributeid eq 127>
					<span class="b"><cfoutput>#proposalattributevaluetext#</cfoutput></span>
				</cfif>
			
			</cfloop>
			
			do
			 
			<cfloop query="proposalattributes">
			
				<cfif attributeid eq 128>
					<span class="b"><cfoutput>#proposalattributevaluetext#</cfoutput></span>
				</cfif>
			
			</cfloop>.
			
			<cfloop query="proposalattributes">
			
				<cfif attributeid eq 200 and Len(proposalattributevaluetext)>
					<br />Urlop za dzień <span class="b"><cfoutput>#DateFormat(proposalattributevaluetext, "dd-mm-yyyy")#</cfoutput></span>.
				</cfif>
			
			</cfloop>
			
			<br/>Ogółem dni robocze: 

			<cfloop query="proposalattributes">
			
				<cfif attributeid eq 129>
					<span class="b"><cfoutput>#proposalattributevaluetext#</cfoutput></span>
				</cfif>
			
			</cfloop>
			
		</div>
		
		<div class="proposalcontent">
			
			<span class="h2">Szczegóły</span>
			
				<cfloop query="proposalattributes">
					<cfif attributeid eq 203>
						<div><span class="name">Nazwa:</span> <span><cfoutput>#proposalattributevaluetext#</cfoutput></span></div>
					</cfif>
					
					<cfif attributeid eq 204 and proposalattributevaluetext neq ''>
						<div><span class="name">Opis:</span> <span><cfoutput>#proposalattributevaluetext#</cfoutput></span></div>
					</cfif>
					
					<cfif attributeid eq 206>
						<div><span class="name">Miejsce:</span> <span><cfoutput>#proposalattributevaluetext#</cfoutput></span></div>
					</cfif>
					
					<cfif attributeid eq 211>
						<div><span class="name">Koszt:</span> <span><cfoutput>#proposalattributevaluetext#</cfoutput></span></div>
					</cfif>
					
					<cfif attributeid eq 208>
						<div><span class="name">Rodzaj transportu:</span> <span><cfoutput>#proposalattributevaluetext#</cfoutput></span></div>
					</cfif>
					
					<cfif attributeid eq 209>
						<div><span class="name">Koszt transportu:</span> <span><cfoutput>#proposalattributevaluetext#</cfoutput></span></div>
					</cfif>
					
					<cfif attributeid eq 207>
						<div><span class="name">Koszt noclegu:</span> <span><cfoutput>#proposalattributevaluetext#</cfoutput></span></div>
					</cfif>
					
					<cfif attributeid eq 210 and proposalattributevaluetext neq ''>
						<div><span class="name">Uwagi dodatkowe:</span> <span><cfoutput>#proposalattributevaluetext#</cfoutput></span></div>
					</cfif>
				</cfloop>
			</ul>
		</div>
		
		<div class="proposalhistory">
		
			<span class="h2">Historia dokumentu</span>
			
			<ul>
				<cfloop query="proposalsteps">

					<cfif proposalstepstatusid eq 1>
						<li>Wniosek sporządzony przez <cfoutput>#givenname# #sn#</cfoutput> dnia <cfoutput>#DateFormat(proposalstepcreated, "dd.mm.yyyy")# o godzinie #TimeFormat(proposalstepcreated, "HH:mm")#</cfoutput>.</li>
					</cfif>
				
				</cfloop>
				
				<cfloop query="proposalsteps">
				
					<cfif proposalstepstatusid eq 2 and proposalstatusid eq 2>
						<li>Wniosek zaakceptowany przez <cfoutput>#givenname# #sn#</cfoutput> dnia <cfoutput>#DateFormat(proposalstepended, "dd.mm.yyyy")# o godzinie #TimeFormat(proposalstepended, "HH:mm")#</cfoutput>.</li>
					</cfif>
					
					<cfif proposalstepstatusid eq 2 and proposalstatusid eq 3>
						<li>Wniosek odrzucony przez <cfoutput>#givenname# #sn#</cfoutput> dnia <cfoutput>#DateFormat(proposalstepended, "dd.mm.yyyy")# o godzinie #TimeFormat(proposalstepended, "HH:mm")#</cfoutput>.</li>
					</cfif>
				
				</cfloop>
			</ul>
		
		</div>	
		
	</div>
	
<!---<cfdump var="#proposal#" >--->
<!---<cfdump var="#proposalsteps#" >--->
<!---<cfdump var="#proposalattributes#" >--->

</cfdocument>

<cfpdf 
    action = "write" 
    source = "protocolpdf" 
    destination="#filename#" />

<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
<cfheader name="Expires" value="#Now()#" />
<cfcontent type="application/pdf" file="#filename#" />
