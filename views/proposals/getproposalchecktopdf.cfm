<cfset filename = "#ExpandPath('files/proposals/')#proposal_delegationcheck_#params.key#_#DateFormat(proposal.proposalcreated, 'dd-mm-yyyy')#.pdf" />
<cfset savefilename = "proposal_delegationcheck_#proposal.id#_#DateFormat(proposal.proposalcreated, 'dd-mm-yyyy')#.pdf" />

<cfif FileExists(filename)>
	<cffile action="delete" file="#filename#">
</cfif>

<cfdocument format="PDF" fontembed="true" pagetype="A4" name="protocolpdf">
	
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
		td.th, td.value { padding: 6px 4px; }
		td.th { font-weight: bold; font-size: 12px; }
		.bright { border-right: 1px solid #000000; }
		.top { border-top: 1px solid #000000; text-align: center; }
		.attrhead { width: 215px; }
		.triproutes td, .triproutes th { border-bottom: 1px solid #000000; border-left: 1px solid #000000; }
		.attributes td, .attributes th { border: none; border-right: 1px solid #000000; border-bottom: 1px solid #000000; }
		.attributes th { text-align: left; }
		.number { text-align: right; width: 88px; }
		.celltitle { font-size: 12px; font-weight: bold; }
		.cellnormal { font-size: 11px; }
		.cellsmall { font-size: 10px; }
		.innertable { font-size: 10px; }
		.innertable td { padding: 2px; width: 50px; height: 30px; border: 1px solid #000000; text-align: center; font-weight: bold; font-size: 11px; }
		.subtext { margin-top: 30px; font-size: 12px; line-height: 150%; }
		.column { margin-top: 50px; float: left; width: 300px; text-align: center; }
		.costsv { font-style: italic; padding: 15px 10px; height: 20px; }
		.sum { font-weight: bold; }
	-->
	</style>
	
	<div class="container">
		<div class="caption">RACHUNEK KOSZTÓW PODRÓZY</div>
		<table class="triproutes" cellspacing="0">
			<thead>
				<tr>
					<td colspan="3" class="th top">WYJAZD</td>
					<td colspan="3" class="th top">PRZYJAZD</td>
					<td rowspan="2" class="th top">srodki lokomocji</td>
					<td rowspan="2" class="th top bright">koszty przejazdu</td>
				</tr>
				<tr>
					<td class="th">miejscowosc</td>
					<td class="th">data</td>
					<td class="th">godz.</td>
					<td class="th">miejscowosc</td>
					<td class="th">data</td>
					<td class="th">godz.</td>
				</tr>	
			</thead>
			
			<tbody>
				
				<cfloop query="businesstriproute">
					<cfoutput>	
						<tr>
							<td class="value autotext">#businesstriproute.begincity#</td>
							<td class="value datebox">#DateFormat(businesstriproute.begindate, 'dd-mm-yyyy')#</td>
							<td class="value timebox">#TimeFormat(businesstriproute.begintime, 'HH:mm')#</td>
							
							<td class="value autotext">#businesstriproute.endcity#</td>
							<td class="value datebox">#DateFormat(businesstriproute.enddate, 'dd-mm-yyyy')#</td>
							<td class="value timebox">#TimeFormat(businesstriproute.endtime, 'HH:mm')#</td>
							
							<td class="value select">
								<cfswitch expression="#businesstriproute.transport#">
									<cfcase value="pkp">PKP</cfcase>
									<cfcase value="samolot">Samolot</cfcase>
									<cfcase value="samochod">Samochód</cfcase>
								</cfswitch>
							</td>
							<td class="value cost bright number">#NumberFormat(businesstriproute.cost,'_-___.__')&' zł'#</td>
						</tr>
					</cfoutput>
				</cfloop>
				
				<tr>
					
					<td colspan="4" valign="top" align="center">
						<br />
						<span class="celltitle">Rachunek sprawdzono pod wzgldem</span>
						<p>
							<span class="cellnormal">formalnym i rachunkowym</span><br />
							<br /><br />
							........................................................<br />
							<span class="cellsmall">data i podpis</span>
						</p>
						<p>
							<span class="cellnormal">merytorycznym łącznie z potwierdzeniem wykonania polecenia służbowego</span><br />
							<br /><br />
							........................................................<br />
							<span class="cellsmall">data i podpis</span>
						</p>
					</td>
					<td colspan="4" rowspan="2">
						
						<table class="attributes" cellspacing="0">
							<tr>
								<td class="th attrhead">Ryczałty za dojazd</td>
								<td class="value number"><cfoutput>#NumberFormat(businesstrip.tripcost1,'_-___.__')&' zł'#</cfoutput></td>
							</tr>
							<tr>
								<td class="th attrhead">Dojazdy udokumentowane</td>
								<td class="value number"><cfoutput>#NumberFormat(businesstrip.tripcost2,'_-___.__')&' zł'#</cfoutput></td>
							</tr>
							<tr>
								<td class="th attrhead">Razem przejazdy, dojazdy</td>
								<td class="value number"><cfoutput>#NumberFormat(businesstrip.tripcost3,'_-___.__')&' zł'#</cfoutput></td>
							</tr>
							<tr>
								<td class="th attrhead">Diety</td>
								<td class="value number"><cfoutput>#NumberFormat(businesstrip.tripcost4,'_-___.__')&' zł'#</cfoutput></td>
							</tr>
							<tr>
								<td class="th attrhead">Noclegi - ryczałt</td>
								<td class="value number"><cfoutput>#NumberFormat(businesstrip.tripcost5,'_-___.__')&' zł'#</cfoutput></td>
							</tr>
							<tr>
								<td class="th attrhead">Noclegi wg rach.</td>
								<td class="value number"><cfoutput>#NumberFormat(businesstrip.tripcost6,'_-___.__')&' zł'#</cfoutput></td>
							</tr>
							<tr>
								<td class="th attrhead">Inne wydatki wg zal.</td>
								<td class="value number"><cfoutput>#NumberFormat(businesstrip.tripcost7,'_-___.__')&' zł'#</cfoutput></td>
							</tr>
							<tr>
								<td class="th attrhead">Firmowa karta kredytowa</td>
								<td class="value number"><cfoutput>#NumberFormat(businesstrip.tripcost8,'_-___.__')&' zł'#</cfoutput></td>
							</tr>
							<tr>
								<td class="attrhead">
									<div class="costsv"><cfoutput>#_costs#</cfoutput></div>
								</td>
								<td class="value number sum">
									<cfoutput>#NumberFormat(businesstrip.tripcost10,'_-___.__')&' zl'#</cfoutput>
								</td>
							</tr>
							<tr>
								<td class="th attrhead">Pobrano zaliczke</td>
								<td class="value number"><cfoutput>#NumberFormat(businesstrip.tripcost9,'_-___.__')&' zl'#</cfoutput></td>
							</tr>
							<tr>
								<td class="th attrhead">Do wypłaty</td>
								<td class="value number sum"><cfoutput>#NumberFormat(businesstrip.tripcost10,'_-___.__')&' zl'#</cfoutput></td>
							</tr>
							<tr>
								<td colspan="3" align="center" class="value">
									<span class="cellnormal">Niniejszym rachunek przedkładam</span><br />
									<cfoutput>#DateFormat(Now(), 'dd-mm-yyyy')#</cfoutput><br /><br />........................................................<br />
									<span class="cellsmall">data i podpis</span>
								</td>
							</tr>
						</table>
						
					</td>
					
				</tr>
				
				<tr>
					<td colspan="4" valign="top" align="center">
						<br />
						<span class="cellnormal">Zatwierdzono na zł ......... słownie</span><br />
						<br />
						<span class="cellnormal">do wypłaty z sum</span>
						<table class="innertable" cellspacing="0">
							<tr>
								<td>Część</td>
								<td>Dział</td>
								<td>Rozdz.</td>
								<td>&sect;</td>
								<td>Poz.</td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</table>
						<br />
						<br />
						........................................................<br />
						<span class="cellsmall">data i podpisy zatwierdzających</span>
					</td>
				</tr>
				
				<tr>
					<td colspan="8" class="bright" style="padding: 10px;">
						<span class="cellnormal">Kwietuje odbiór zł .............................................. słownie <br />
						<br />
						...................................................................................................<br />
						<span class="cellsmall">data i podpisy zatwierdzających</span>
					</td>
				</tr>
				
			</tbody>
		</table>
		
		<div class="subtext">
			<p>
				<br />Zaliczkę w kwocie zł ...........................
				słownie .........................................................................................<br />
			</p>
			<p>
				<br />
				otrzymałem i zobowiązuję się rozliczyć z niej w terminie 14 dni po zakończonej podróży, upoważniając
				równocześnie zakład pracy do potrącenia kwoty nierozliczonej zaliczki z najbliższej wypłaty wynagrodzenia.
				<br />
			</p>
			<div class="column">
				.................................................................<br />
				imię i nazwisko delgowanego
			</div>
			<div class="column">
				.................................................................<br />
				data i podpis delgowanego
			</div>
		</div>
	</div>
	
</cfdocument>

<cfpdf action = "write" source = "protocolpdf" destination="#filename#" />

<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
<cfheader name="Expires" value="#Now()#" />
<cfcontent type="application/pdf" file="#filename#" />