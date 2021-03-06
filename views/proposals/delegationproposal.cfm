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
  @import url("stylesheets/pdfdocument.css");

-->
</style>

	<div class="wrapper pdf">
	
		<table class="delegation" cellspacing="0">
		
			<thead>
				<tr>
					<th style="width: 50%"></th>
					<th style="width: 50%; border-top: 1px solid #000; border-right: 1px solid #000; border-left: 1px solid #000; text-align: left;">STWIERDZENIE POBYTU SŁUŻBOWEGO<br/>(Podać daty przybycia i wyjazdu oraz noclegów bezpłatnych lub tańszych niż ryczałt). Adnotacje te zaopatrzyć pieczęcią i podpisem.</th>
				</tr>
			</thead>
			
			<tbody>
				<tr>
					<td style="border-left: 1px solid #000; border-top: 1px solid #000; border-bottom: 1px solid #000; text-align: center;">
					
						<span class="h3" style="margin-bottom: 20px;">POLECENIE WYJAZDU SŁUŻBOWEGO <br/>Nr <cfoutput>#proposal.proposalnum#</cfoutput></span>na wezwanie - zaproszenie *)<br/>
						<span style="display: block; margin-top: 20px;">nr…………………………………</span><br/>
						<span style="display: block;">z dnia…………………………</span>
						<span style="display:block; margin-top: 18px;">dla 
							<cfoutput>
								<cfloop query="proposalattributes">
									<cfif attributeid eq 132>
										<span style="font-size: 14px;">#UCase(proposalattributevaluetext)#</span>
									</cfif>
								</cfloop>
							</cfoutput>
						</span><br/>
						<span style="display: block; font-size: 14px;">
							<cfoutput>
							
							<cfloop query="proposalattributes">
								<cfif attributeid eq 131>
									#UCase(proposalattributevaluetext)#
								</cfif>
							</cfloop>
							
							</cfoutput>
						</span>
						<span style="display: block; margin-top: 20px;">do
							<cfoutput>
								<cfloop query="proposalattributes">
									<cfif attributeid eq 136>
										<span style="font-size:14px; margin-top: 20px;">#UCase(proposalattributevaluetext)#</span>
									</cfif>
								</cfloop>
							</cfoutput>
						</span>
						<span style="display: block; margin-top: 10px;">
							na czas od
							<cfoutput>
								<cfloop query="proposalattributes">
									<cfif attributeid eq 127>
										<span style="font-size: 14px;">#proposalattributevaluetext#</span>
									</cfif>
								</cfloop>
							do
								<cfloop query="proposalattributes">
									<cfif attributeid eq 128>
										<span style="font-size: 14px;">#proposalattributevaluetext#</span>
									</cfif>
								</cfloop>
							</cfoutput>
						</span>
						<span style="display: block; margin-top: 10px;">
							w celu 
							<cfoutput>
								<cfloop query="proposalattributes">
									<cfif attributeid eq 137>
										<span style="font-size: 14px;">#proposalattributevaluetext#</span>
									</cfif>
								</cfloop>
							</cfoutput>
						</span>
					</td>
					
					<td style="border-left: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000;"></td>
				</tr>
				
				<tr>
					<td style="border-left: 1px solid; border-bottom: 1px solid #000;">
						<span style="display: block;">
							Środki lokomocji:<br/>
							<cfoutput>
								<cfloop query="proposalattributes">
									<cfif attributeid eq 138>
										<span style="font-size: 14px;">#proposalattributevaluetext#</span>
									</cfif>
								</cfloop>
							</cfoutput>
						</span>
					</td>
					<td style="border-left: 1px solid #000; border-right: 1px solid #000;"></td>
				</tr>
				
				<tr>
					<td style="height: 100px; border-left: 1px solid #000; border-bottom: 1px solid #000;">
					
						<span style="float: left;">……………….………<br/>data</span>
						<span style="float: right;">……………….……..…<br/>podpis zlec. wyjazd.</span>
					
					</td>
					<td style="border-left: 1px solid #000; border-right: 1px solid #000; border-bottom: 1px solid #000;"></td>
				</tr>
				
				<tr>
					<td colspan="2" style="height:20px; border-bottom: 1px dashed #000;"></td>
				</tr>
				
				<tr>
					<td colspan="2" style="height: 20px;"></td>
				</tr>
				
				<tr>
					<td colspan="2" style="line-height: 22px;">
					Proszę o wypłacenie zaliczki w kwocie zł ………………………………. słownie …………………………………………….………………….….<br/>na pokrycie wydatków zgodnie z poleceniem wyjazdu służbowego nr ……………………………….<br/><br/>
					<span style="float:right; text-align: center;">……………………………………………….<br/>podpis delegowanego</span>
					
					<span style="display: block; clear: both; float: none;">&nbsp;</span>
					Zatwierdzono na zł ……………………………………………… słownie ………………………………………………………………………………<br/>
					do wypłaty z sum ……………………………….<br/>
					
					<table cellspacing="0">
						<tr>
							<td colspan="2" style="border-left: 1px solid #000; border-top: 1px solid #000; border-right: 1px solid #000; text-align: center;">Konto</td>
							<td style="border-top: 1px solid #000; border-right: 1px solid #000; text-align: center;">Nr dowodu</td>
						</tr>
						<tr>
							<td style="border-left: 1px solid #000; border-bottom: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000;">Wn</td>
							<td style="border-bottom: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000;">Ma</td>
							<td style="border-bottom: 1px solid #000; border-right: 1px solid #000; border-top: 1px solid #000;"></td>
						</tr>
					</table>
					<br/>
					<table cellspacing="0">
						<tr>
							<td style="text-align: center; border-left: 1px solid #000; border-top: 1px solid #000;">Część</td>
							<td style="text-align: center; border-left: 1px solid #000; border-top: 1px solid #000;">Dział</td>
							<td style="text-align: center; border-left: 1px solid #000; border-top: 1px solid #000;">Rozdz.</td>
							<td style="text-align: center; border-left: 1px solid #000; border-top: 1px solid #000;">§</td>
							<td style="text-align: center; border-left: 1px solid #000; border-top: 1px solid #000; border-right: 1px solid #000;">Poz.</td>
						</tr>
						<tr>
							<td style="text-align: center; border-left: 1px solid #000; border-top: 1px solid #000; border-bottom: 1px solid #000;">&nbsp;</td>
							<td style="text-align: center; border-left: 1px solid #000; border-top: 1px solid #000; border-bottom: 1px solid #000;">&nbsp;</td>
							<td style="text-align: center; border-left: 1px solid #000; border-top: 1px solid #000; border-bottom: 1px solid #000;">&nbsp;</td>
							<td style="text-align: center; border-left: 1px solid #000; border-top: 1px solid #000; border-bottom: 1px solid #000;">&nbsp;</td>
							<td style="text-align: center; border-left: 1px solid #000; border-top: 1px solid #000; border-bottom: 1px solid #000; border-right: 1px solid #000;">&nbsp;</td>
						</tr>
					</table>
					
					<br/>
					<span style="float:left; text-align: center;">……………………………<br/>data</span>
					<span style="float:right; text-align: center;">…………………………………………<br/>podpisy zatwierdzających</span>
					<span style="display: block; clear: both;">&nbsp;</span>
					</td>
				</tr>
			</tbody>
		
		</table>
		
	</div>

</cfdocument>

<cfpdf 
    action = "write" 
    source = "protocolpdf" 
    destination="#filename#" />

<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
<cfheader name="Expires" value="#Now()#" />
<cfcontent type="application/pdf" file="#filename#" />
