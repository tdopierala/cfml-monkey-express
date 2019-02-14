<cfset filename = "#ExpandPath('files/proposals/')#WNIOSEK_ID-#proposal.id#_UTWORZONO-#DateFormat(proposal.proposalcreated, 'dd-mm-yyyy')#.pdf" />

<cfset savefilename = "WNIOSEK_ID-#proposal.id#_UTWORZONO-#DateFormat(proposal.proposalcreated, 'dd-mm-yyyy')#.pdf" />

<cfif FileExists(filename)> <!--- Jeśli plik już istnieje to go usuwam i generuje nowy --->

	<!---
	<cffile  
		action = "delete" 
		file = "#filename#">
	--->

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

-->
</style>

	<div class="wrapper pdf">
	
		<cfoutput>#imageTag("logo.png")#</cfoutput>
		
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
				</cfloop>
			</ul>
		</div>
		
		
		<span class="h1">
			<cfloop query="proposalattributes">
				<cfif attributeid eq 135>
					<cfoutput>#proposalattributevaluetext#</cfoutput>
				</cfif>
			</cfloop>
		</span>	
		
		<div class="proposalcontent">
Proszę o udzielenie urlopu wypoczynkowego w dniach od 
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
						<cfif InName.recordCOunt GT 0 and InName.id NEQ userid>
						
							<li>
								Wniosek zaakceptowany przez <cfoutput>#InName.givenname# #InName.sn#</cfoutput> dnia <cfoutput>#DateFormat(proposalstepended, "dd.mm.yyyy")# o godzinie #TimeFormat(proposalstepended, "HH:mm")# z upoważnienia #givenname# #sn#</cfoutput>
							</li>
						
						<cfelse>
						
							<li>Wniosek zaakceptowany przez <cfoutput>#givenname# #sn#</cfoutput> dnia <cfoutput>#DateFormat(proposalstepended, "dd.mm.yyyy")# o godzinie #TimeFormat(proposalstepended, "HH:mm")#</cfoutput>.</li>
							
						</cfif>
						
					</cfif>
					
					<cfif proposalstepstatusid eq 2 and proposalstatusid eq 3>
						
						<cfif InName.recordCount GT 0 and InName.id NEQ userid>
						
							<li>
								Wniosek odrzucony przez <cfoutput>#InName.givenname# #InName.sn#</cfoutput> dnia <cfoutput>#DateFormat(proposalstepended, "dd.mm.yyyy")# o godzinie #TimeFormat(proposalstepended, "HH:mm")# z upoważnienia #givenname# #sn#</cfoutput>
							</li>
						
						<cfelse>
							
							<li>Wniosek odrzucony przez <cfoutput>#givenname# #sn#</cfoutput> dnia <cfoutput>#DateFormat(proposalstepended, "dd.mm.yyyy")# o godzinie #TimeFormat(proposalstepended, "HH:mm")#</cfoutput>.</li>
						</cfif>
						
					</cfif>
				
				</cfloop>
			</ul>
		
		</div>	
		
	</div>

</cfdocument>

<cfpdf 
    action = "write" 
    source = "protocolpdf" 
    destination="#filename#"
	overwrite="yes" />

<cfheader name="Content-Disposition" value="attachment;filename=#savefilename#">
<cfcontent type="application/octet-stream" file="#filename#" deletefile="Yes">

<!---
<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
<cfheader name="Expires" value="#Now()#" />
<cfcontent type="application/pdf" file="#filename#" />
--->