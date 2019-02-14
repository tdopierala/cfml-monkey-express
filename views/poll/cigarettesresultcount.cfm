
	
	<div class="wrapper polls">
		<h3>Ankieta - papierosy, wyniki wg indeksu</h3>
		
		<ul class="intranet-tab-index">
			<li class="chosen">
				<cfoutput>#linkTo(text="Wyniki wg indeksu", action="cigarettesresultcount", class="")#</cfoutput>
			</li>
			<li>
				<cfoutput>#linkTo(text="Wyniki wg sklepu", action="cigarettesresult", class="")#</cfoutput>
			</li>
		</ul>
		
		<div class="wrapper">
			
				<!---<form method="post" action="#URLFor(action='cigarettesAction')#">--->
					
					<table class="pollTable">
						<thead>
							<tr>
								<th class="btop bleft">Ilość</th>
								<th class="btop">Nazwa</th>
							</tr>
						</thead>
						<tbody>
							<cfset idx=0 />
							<cfset max=200 />
							<cfloop query="pollresult">
								<cfset idx++ />
								
								<cfquery dbtype="query" name="cigarettes"> 
							    	SELECT opikar1 FROM qCigarettes
							    	WHERE symkar=<cfqueryparam value="#symkar#" cfsqltype="cf_sql_char" maxLength="20">
								</cfquery>
								
								<cfoutput query=cigarettes>
									<cfset opikar = opikar1 />
								</cfoutput>
								
								<cfoutput>
                                	<tr>
										<td class="bleft center" style="width:320px;">
											
											<cfif idx eq 1>
												<cfset max = Round(count*1.5) />
											</cfif>
										
											<cfset w = Round((count/max)*100) />
											<div class="pollBarOuther">
												<div class="pollBarInner" style="width:#w#%;">#count#</div>
											</div>
											<!---#count#/#cigarettesCount.c#--->
										</td>
										<td>#opikar# (#symkar#)</td>
									</tr>
                                </cfoutput>
							</cfloop>
							
						</tbody>
					</table>
					
				<!---</form>--->

		</div>
	</div>
	
<!---<cfdump var="#cigtab#" />--->