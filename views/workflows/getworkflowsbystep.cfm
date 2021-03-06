<cfoutput>
	<div class="wrapper">
	
		<h3>#title#</h3>
		
		<div class="wrapper">
				
			<cfoutput>#includePartial(partial="/workflows/workflowstatusessubnav")#</cfoutput>
		
		</div>
			
		<div class="wrapper">
		
			<table class="newtables" id="userWorkflowTable">
				<thead>
					<tr class="top">
						<th class="bottomBorder">NUMER FAKTURY</th>
						<th class="bottomBorder">DATA DODANIA</th>
						<th class="bottomBorder">W OBIEGU</th>
						<th class="bottomBorder step">OPIS</th>
						<th class="bottomBorder step">CONTROLLING</th>
						<th class="bottomBorder step">ZATWIERDZONO</th>
						<th class="bottomBorder step">KSIĘGOWOŚĆ</th>
						<th class="bottomBorder step">ZAAKCEPTOWANO</th>
					</tr>
				</thead>
				<tbody>
				
					<cfloop query="workflows">
						<tr>
							<td class="bottomBorder">
							
								#linkTo(
									text=documentname,
									controller="Workflows",
									action="preview",
									key=workflowid)#
							
							</td>
							<td class="bottomBorder">#DateFormat(workflowcreated, "dd/mm/yyyy")#</td>
							<td class="bottomBorder">
								<cfif Len(endeddate)>
								
									#DayOfYear(endeddate) - DayOfYear(workflowcreated)# (zamknięto)
									
								<cfelse>
									
									<cfset howlong = DayOfYear(Now()) - DayOfYear(workflowcreated) />
									
									<cfif howlong gt 3>
									
										<span class="urgent">#howlong# (w trakcie)</span>
									
									</cfif>
								
								</cfif>
							
							</td>
							<td class="bottomBorder step">
								<cfif stepdescriptiondraft eq 1>
									#imageTag(source="draft.png")#
								</cfif>
								<cfif stepdescriptionid eq 1>
									#imageTag(source="progress-bar.png")#
								</cfif>
								<cfif stepdescriptionid eq 2>
									#imageTag(source="yes.png")#
								</cfif>
								<cfif stepdescriptionid eq 3>
									#imageTag(source="no.png")#
								</cfif>
								<cfif stepdescriptionid eq 4>
									#imageTag(source="move.png")#
								</cfif>								
							</td>
							<td class="bottomBorder step">
								<cfif stepcontrollingdraft eq 1>
									#imageTag(source="draft.png")#
								</cfif>
								<cfif stepcontrollingid eq 1>
									#imageTag(source="progress-bar.png")#
								</cfif>
								<cfif stepcontrollingid eq 2>
									#imageTag(source="yes.png")#
								</cfif>
								<cfif stepcontrollingid eq 3>
									#imageTag(source="no.png")#
								</cfif>
								<cfif stepcontrollingid eq 4>
									#imageTag(source="move.png")#
								</cfif>
							</td>
							<td class="bottomBorder step">
								<cfif stepapproveddraft eq 1>
									#imageTag(source="draft.png")#
								</cfif>
								<cfif stepapproveid eq 1>
									#imageTag(source="progress-bar.png")#
								</cfif>
								<cfif stepapproveid eq 2>
									#imageTag(source="yes.png")#
								</cfif>
								<cfif stepapproveid eq 3>
									#imageTag(source="no.png")#
								</cfif>
								<cfif stepapproveid eq 4>
									#imageTag(source="move.png")#
								</cfif>
							</td>
							<td class="bottomBorder step">
								<cfif stepaccountingdraft eq 1>
									#imageTag(source="draft.png")#
								</cfif>
								<cfif stepaccountingid eq 1>
									#imageTag(source="progress-bar.png")#
								</cfif>
								<cfif stepaccountingid eq 2>
									#imageTag(source="yes.png")#
								</cfif>
								<cfif stepaccountingid eq 3>
									#imageTag(source="no.png")#
								</cfif>
								<cfif stepaccountingid eq 4>
									#imageTag(source="move.png")#
								</cfif>
							</td>
							<td class="bottomBorder step">
								<cfif stepacceptdraft eq 1>
									#imageTag(source="draft.png")#
								</cfif>
								<cfif stepacceptid eq 1>
									#imageTag(source="progress-bar.png")#
								</cfif>
								<cfif stepacceptid eq 2>
									#imageTag(source="yes.png")#
								</cfif>
								<cfif stepacceptid eq 3>
									#imageTag(source="no.png")#
								</cfif>
								<cfif stepacceptid eq 4>
									#imageTag(source="move.png")#
								</cfif>
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		
		</div>
		
	</div>
</cfoutput>