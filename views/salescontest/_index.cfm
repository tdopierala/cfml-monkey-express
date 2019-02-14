				<cfoutput>
                	<cfset counter = 0 /> 
					<cfloop query="salesreport">
						<cfif Round(i_przyrost_netto) gt 0>					
							<cfset counter++ />
							
							<cfif counter gte 1 and counter lt 4>
								<cfset class="contest_winner" />
							<cfelseif counter gte 4 and counter lt 11>
								<cfset class="contest_ok" />
							<cfelseif counter gte 11 and counter lte 70>
								<cfset class="contest_wannabe" />
							<cfelse>
								<cfset class="" />
							</cfif>
							
							<tr class="#class# pos#counter#">
								<td>#counter#</td>
								<td>#b_projekt#</td>
								<td>#c_miejscowosc#</td>
								<td>#Replace(i_przyrost_netto,".",",")#%</td>
								<td class="_right">
									<cfset day1 = ArrayFind(daybefore1report['a_sklep'],a_sklep) />
									#day1#
									<cfif day1 lt counter>
										#imageTag("arrow_down.png")#
									<cfelseif day1 eq counter>
										#imageTag("arrow_equal.png")#
									<cfelse>
										#imageTag("arrow_up.png")#
									</cfif>
								</td>
								<td class="_right">
									<cfset day2 = ArrayFind(daybefore2report['a_sklep'],a_sklep) />
									#day2#
									<cfif day2 lt counter>
										#imageTag("arrow_down.png")#
									<cfelseif day2 eq counter>
										#imageTag("arrow_equal.png")#
									<cfelse>
										#imageTag("arrow_up.png")#
									</cfif>
								</td>
								<td class="_right">
									<cfset day3 = ArrayFind(daybefore3report['a_sklep'],a_sklep) />
									#day3#
									<cfif day3 lt counter>
										#imageTag("arrow_down.png")#
									<cfelseif day3 eq counter>
										#imageTag("arrow_equal.png")#
									<cfelse>
										#imageTag("arrow_up.png")#
									</cfif>
								</td>
									
									<cfif counter eq 1>
										<td class="_message" rowspan="3"><span>Tak trzymaj, nie odpuszczaj. Egipt czeka na ciebie!</span></td>
									<cfelseif counter eq 4>
										<td class="_message" rowspan="7"><span>Świetnie, voucher na wyjątkowy weekend czeka na ciebie!</span></td>
									<cfelseif counter gte 11 and (counter) mod 5 eq 1>
										<td class="_message" rowspan="5"><span>Brawo! Masz bon do Merlina, a twoi ludzie idą do kina!</span>
									</cfif>
									
								
							</tr>
						</cfif>
					</cfloop>
                </cfoutput>