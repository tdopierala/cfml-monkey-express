<cfoutput>
		<div class="wrapper">
			<h3 class="uiHeaderTitle">#proposal.proposaltypename#</h3>	
			<!--- <h3>#proposal.proposaltypename#</h3> --->
		
			<!--- <div class="wrapper">
				<cfoutput>#includePartial(partial="/users/subnav",cache=0)#</cfoutput>
			</div> --->
		
			<div class="wrapper proposalpreview">
				
				<cfif proposal.RecordCount is 0>
					<span class="error">Wniosek o numerze #params.key# nie istnieje!</span>
				</cfif>
					
				<ol>
					<cfloop query="proposal">
					
						<cfif attributetypeid eq 3>
							<cfif proposalattributevaluetext neq ''>
								<li>
									<span>#attributename#</span>
									<a href="./files/proposals/#proposalattributevaluetext#">
										
										<cfset ext = Trim(ListLast(proposalattributevaluetext, ".")) />
										<cfswitch expression="#ext#">
											<cfcase value="pdf" >
												<img src="./images/file-pdf.png" alt="#proposalattributevaluetext#" /> #proposalattributevaluetext#
											</cfcase>
											<cfcase value="doc" >
												<img src="./images/file-word.png" alt="#proposalattributevaluetext#" /> #proposalattributevaluetext#
											</cfcase>
											<cfcase value="docx" >
												<img src="./images/file-word.png" alt="#proposalattributevaluetext#" /> #proposalattributevaluetext#
											</cfcase>
											
											<cfdefaultcase>
												<img src="./images/blank.png" alt="#proposalattributevaluetext#" /> #proposalattributevaluetext#
											</cfdefaultcase>
										</cfswitch>									
										
									</a>
								</li>
							</cfif>
						<cfelse>
							
							<cfif Len(Trim(proposalattributevaluetext)) eq 0>
								<li><span>#attributename#</span>--</li>
							<cfelse>
								<li><span>#attributename#</span>#proposalattributevaluetext#</li>
							</cfif>
							
							
						</cfif>
					
					</cfloop>
				</ol>
			
			</div>
		
			<div class="clear"></div>
		</div>
</cfoutput>
<!---<cfdump var="#proposal#">--->