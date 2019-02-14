					<li>
						<a
							href="<cfoutput>#URLFor(controller='Proposals',action='view',key=proposalid)#</cfoutput>"
							<!--- href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Proposals",action="view",key=proposalid)#</cfoutput>', 'user_profile_cfdiv');" --->
							title="Szczegóły wniosku"
							<!--- target="_blank" --->
							class="uiListLink clearfix">
								<h3 class="uiListItemLabel">
									<cfoutput>#proposaltypename# (#proposalnum#)</cfoutput>
								</h3>
								
								<cfif proposalstep1status eq 2>
									<span class="uiListItemContent"><cfoutput>#proposalstatusname# (#proposaldate#)</cfoutput></span>
								</cfif>
						</a>
						
						<div class="uiListOptions">
							
							<cfif proposalstep1status eq 2>
								
								<a
									href="<cfoutput>#URLFor(controller='Proposals',action='proposalToPdf',key=proposalid,params='format=pdf')#</cfoutput>"
									title="Pobierz jako PDF"
									target="_blank"
									class="uiListLinkOptions">
									
										<span>Pobierz jako PDF</span>
								</a>
							
							</cfif>
							
							<cfif proposaltypeid eq 2 and proposalstep2status eq 2 and proposalstep1status eq 2>
								
								<cfswitch expression="#tripstatus#" >
									<cfcase value="1">									
										<a 
											href="<cfoutput>#URLFor(controller='Proposals',action='getProposalCheckForm',key=proposalid,params='view=edit')#</cfoutput>"
											title="Rozlicz wyjazd służbowy"
											class="uiListLinkOptions">
												<!---<cfoutput>#imageTag("icon_table.png")#</cfoutput>--->
												<span>Dokończ rozliczanie</span>
										</a>
									</cfcase>
									<cfcase value="2">
										<a 
											href="<cfoutput>#URLFor(controller='Proposals',action='getProposalCheckForm',key=proposalid,params='view=view')#</cfoutput>"
											title="Podgląd rozliczenia wyjazdu służbowego"
											class="uiListLinkOptions">
												<!---<cfoutput>#imageTag("icon_table-accept.png")#</cfoutput>--->
												<span>Podgląd rozliczenia</span>
												
										</a>
									</cfcase>
									<cfdefaultcase>
										<a 
											href="<cfoutput>#URLFor(controller='Proposals',action='getProposalCheckForm',key=proposalid,params='view=edit')#</cfoutput>"
											title="Rozlicz wyjazd służbowy"
											class="uiListLinkOptions">
												<!---<cfoutput>#imageTag("icon_table-blank.png")#</cfoutput>--->
												<span>Rozlicz delegacje</span>
										</a>
									</cfdefaultcase>
								</cfswitch>
							
							<cfelseif proposalstep1status eq 1>
								
								<a
									href="<cfoutput>#URLFor(controller='Proposals',action='edit',key=proposalid)#</cfoutput>"
									title="Dokończ wypełnianie wniosku"
									class="uiListLinkOptions">
										<span>Dokończ wypełnianie wniosku</span>
								</a>
								
							</cfif>
							
						</div>
					</li>