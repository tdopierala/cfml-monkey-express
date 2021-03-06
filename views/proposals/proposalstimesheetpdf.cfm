<cfset filename = "#ExpandPath('files/proposals/')#proposal_timesheet_.pdf" />
<cfset savefilename = "proposal_timesheet_.pdf" />

<cfif FileExists(filename)>
	<cffile action="delete" file="#filename#">
</cfif>

<cfdocument format="PDF" fontembed="true" pagetype="A4" name="protocolpdf" orientation="landscape" >
	
	<style type="text/css" media="screen">
	<!--
		.pdf { font-family: "Arial"; font-size: 12px; line-height: 1.3em; }
		.contactincofmation { font-size: 12px; color: #eb0f0f; margin: 10px 0; line-height: 1.3em; }
		.h0 { color: #eb0f0f; font-size: 16px; display: block; margin-bottom: 2px; }
		.h1 { display: block; font-size: 18px; text-align: center; margin: 40px 0; }
		.h2 { display: block; font-size: 16px; text-align: left; margin: 50px 0 10px; }
		td { font-size: 12px; }
		div.container { font-family: Arial, Helvetica, sans-serif; font-size: 12px; }
		div.caption { font-size: 18px; padding: 10px 0; font-weight: bold; }
		.proposaltimesheettable { border-right: 1px solid #000000; border-bottom: 1px solid #000000; }
		.proposaltimesheettable td { padding: 5px 2px; }
		.proposaltimesheettable .th { font-weight: bold; }
		.proposaltimesheettable .top { border-top: 1px solid #000000; }
		.proposaltimesheettable .left { border-left: 1px solid #000000; }
	-->
	</style>
	
	<div class="container">
		<div class="caption">Lista obecności na szkoleniu</div>
		<table class="proposaltimesheettable" cellspacing="0" cellpadding="0" border="0">
			<thead>
				<tr>
					<td class="th top left">Imie i nazwisko</td>
					<td class="th top left">Rodzaj</td>
					<td class="th top left">Miejscowosc</td>
					<td class="th top left">Ulica</td>
					<td class="th top left">E-mail</td>
					<td class="th top left">Nr telefonu</td>
					<td class="th top left">Data szkolenia</td>
					<td class="th top left">KOS</td>
				</tr>
			</thead>
			
			<tbody>
					<cfloop query="userproposals">
						<tr>
							<!---<td><cfoutput>#userproposals.proposalnum#</cfoutput></td>--->
							<!---<td><cfoutput>#DateFormat(userproposals.proposalstep1ended, "yyyy-mm-dd")#</cfoutput></td>--->
							
							<cfloop query="proposalsattr">
								<cfif proposalsattr.proposalid eq userproposals.proposalid>
									<cfswitch expression="#proposalsattr.attributeid#">
										
										<cfcase value="218">
											<td class="top left"><cfoutput>#proposalsattr.proposalattributevaluetext#</cfoutput></td>
										</cfcase>
													
										<cfcase value="222">
											<td class="top left"><cfoutput>#DateFormat(proposalsattr.proposalattributevaluetext, "yyyy-mm-dd")#</cfoutput></td>
										</cfcase>
										
										<cfdefaultcase>
											<td class="top left"><cfoutput>#CapFirst(LCase(proposalsattr.proposalattributevaluetext))#</cfoutput></td>
										</cfdefaultcase>
										
									</cfswitch>
								</cfif>
							</cfloop>
						</tr>
					</cfloop>
			</tbody>
		</table>
		
		
	</div>
	
</cfdocument>

<cfpdf action = "write" source = "protocolpdf" destination="#filename#" />

<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
<cfheader name="Expires" value="#Now()#" />
<cfcontent type="application/pdf" file="#filename#" />