<cfoutput>
	<div class="wrapper proposalcheck">
		<h3>Rozliczenie wyjazdu służbowego - podgląd</h3>
		
		<!---<cfdump var="#tabl#" >--->
		
		<div class="wrapper proposalpreview">
			<div class="actionMenu">
				#linkTo(
					text=imageTag("icon_table.png"),
					controller="Proposals",
					action="getProposalCheckForm",
					key=proposal.id,
					params="&view=edit",
					title="Edycja rozliczenia wyjazdu służbowego")#
					
				#linkTo(
					text=imageTag("file-pdf.png"),
					controller="Proposals",
					action="getProposalCheckForm",
					key=proposal.id,
					target="_blank",
					params="&view=pdf",
					title="Eksportuj do PDF")#
			</div>
			<ol>
				<cfloop query="proposalattr">
			
					<li><span>#attributename#</span>#proposalattributevaluetext#</li>
				
				</cfloop>
			</ol>
		</div>
		
		<!---<cfdump var="#businesstriproute#" >--->
		
		<form action="#URLFor(controller='Proposals',action='sendProposalCheckForm')#" method="post" id="form-body">
			<input type="hidden" name="proposalid" value="#proposal.id#" />
			<input type="hidden" name="businesstripid" value="#businesstrip.id#" />
			<table class="tables travels">
			
			<thead>
				<tr>
					<th class="btop" colspan="3">wyjazd</th>
					<th class="btop" colspan="3">przyjazd</th>
					<th class="btop" rowspan="2">środki lokomocji</th>
					<th class="btop bright" rowspan="2">koszty przejazdu</th>
				</tr>
				<tr>
					<th>miejscowość</th>
					<th>data</th>
					<th>godz.</th>
					<th>miejscowość</th>
					<th>data</th>
					<th>godz.</th>
				</tr>
			</thead>
			
			<tbody>

					<cfloop query="businesstriproute">
						
						<tr>
							<td class="autotext">
								<cfif StructKeyExists(businesstriproute,'begincity') and businesstriproute.begincity neq "">
									#businesstriproute.begincity#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td class="datebox">
								<cfif StructKeyExists(businesstriproute,'begindate') and businesstriproute.begindate neq "">
									#DateFormat(businesstriproute.begindate, 'dd-mm-yyyy')#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td class="timebox">
								<cfif StructKeyExists(businesstriproute,'begintime') and businesstriproute.begintime neq "">
									#TimeFormat(businesstriproute.begintime, 'HH:mm')#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							
							<td class="autotext">
								<cfif StructKeyExists(businesstriproute,'endcity') and businesstriproute.endcity neq "">
									#businesstriproute.endcity#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td class="datebox">
								<cfif StructKeyExists(businesstriproute,'enddate') and businesstriproute.enddate neq "">
									#DateFormat(businesstriproute.enddate, 'dd-mm-yyyy')#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td class="timebox">
								<cfif StructKeyExists(businesstriproute,'endtime') and businesstriproute.endtime neq "">
									#TimeFormat(businesstriproute.endtime, 'HH:mm')#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td class="select">
								<cfswitch expression="#businesstriproute.transport#">
									<cfcase value="pkp">PKP</cfcase>
									<cfcase value="samolot">Samolot</cfcase>
									<cfcase value="samochod">Samochód</cfcase>
									<cfdefaultcase>&nbsp;</cfdefaultcase>
								</cfswitch>
							</td>
							<td class="cost bright">
								<cfif StructKeyExists(businesstriproute,'cost') and businesstriproute.cost neq "">
									#NumberFormat(businesstriproute.cost,'_-___.__') & ' zł'#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
						</tr>
						
					</cfloop>
				
			</tbody>
			
		</table>
		
		<table class="tables summary">
			<tr>
				<th class="btop">Ryczałty za dojazd</th>
				<td class="btop bright cost">
					<cfif StructKeyExists(businesstrip, "tripcost1")>
						#NumberFormat(businesstrip.tripcost1,'_-___.__') & ' zł'#
					<cfelse>
						0.00 zł
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Dojazdy udokumentowane</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost2")>
						#NumberFormat(businesstrip.tripcost2,'_-___.__') & ' zł'#
					<cfelse>
						0.00 zł
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Razem przejazdy, dojazdy</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost3")>
						#NumberFormat(businesstrip.tripcost3,'_-___.__') & ' zł'#
					<cfelse>
						0.00 zł
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Diety</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost4")>
						#NumberFormat(businesstrip.tripcost4,'_-___.__') & ' zł'#
					<cfelse>
						0.00 zł
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Noclegi - ryczałt</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost5")>
						#NumberFormat(businesstrip.tripcost5,'_-___.__') & ' zł'#
					<cfelse>
						0.00 zł
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Noclegi wg rach.</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost6")>
						#NumberFormat(businesstrip.tripcost6,'_-___.__') & ' zł'#
					<cfelse>
						0.00 zł
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Inne wydatki wg zał.</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost7")>
						#NumberFormat(businesstrip.tripcost7,'_-___.__') & ' zł'#
					<cfelse>
						0.00 zł
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Firmowa karta kredytowa</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost8")>
						#NumberFormat(businesstrip.tripcost8,'_-___.__') & ' zł'#
					<cfelse>
						0.00 zł
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Pobrana zaliczka</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost9")>
						#NumberFormat(businesstrip.tripcost9,'_-___.__') & ' zł'#
					<cfelse>
						0.00 zł
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Suma</th>
				<td class="bright">
					<cfif StructKeyExists(businesstrip, "tripcost10")>
						#NumberFormat(businesstrip.tripcost10,'_-___.__') & ' zł'#
					<cfelse>
						0.00 zł
					</cfif>
				</td>
			</tr>
			<tr>
				<td colspan="4" class="bright">#_costs#</td>
			</tr>
		</table>
		</form>

	</div>
</cfoutput>