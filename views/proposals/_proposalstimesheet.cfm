<cfoutput>
					<cfloop query="userproposals">
						<tr>
							<td>#userproposals.proposalnum#</td>
							<td>#DateFormat(userproposals.proposalstep1ended, "yyyy-mm-dd")#</td>
							
							<cfloop query="proposalsattr">
								<cfif proposalsattr.proposalid eq userproposals.proposalid>
									<cfswitch expression="#proposalsattr.attributeid#">
										
										<cfcase value="212">
											<td>#proposalsattr.proposalattributevaluetext#</td>
										</cfcase>
										
										<cfcase value="222">
											<td>#DateFormat(proposalsattr.proposalattributevaluetext, "yyyy-mm-dd")#</td>
										</cfcase>
										
									</cfswitch>
								</cfif>
							</cfloop>
						</tr>
					</cfloop>
</cfoutput>
