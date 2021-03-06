<cfoutput>
	<div class="wrapper">
	
		<h3>Lista dokumentów w obiegu</h3>
		
		<div class="wrapper">
				
			<cfoutput>#includePartial(partial="workflow_filter")#</cfoutput>
		
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
				
					<cfloop query="myworkflow">
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
								<cfelseif stepdescriptionid eq 2>
									#imageTag(source="yes.png")#
								<cfelseif stepdescriptionid eq 3>
									#imageTag(source="no.png")#
								<cfelseif stepdescriptionid eq 4>
									#imageTag(source="move.png")#
								<cfelse>
									&nbsp;
								</cfif>								
							</td>
							<td class="bottomBorder step">
								<cfif stepcontrollingdraft eq 1>
									#imageTag(source="draft.png")#
								</cfif>
								<cfif stepcontrollingid eq 1>
									#imageTag(source="progress-bar.png")#
								<cfelseif stepcontrollingid eq 2>
									#imageTag(source="yes.png")#
								<cfelseif stepcontrollingid eq 3>
									#imageTag(source="no.png")#
								<cfelseif stepcontrollingid eq 4>
									#imageTag(source="move.png")#
								<cfelse>
									&nbsp;
								</cfif>		
							</td>
							<td class="bottomBorder step">
								<cfif stepapproveddraft eq 1>
									#imageTag(source="draft.png")#
								</cfif>
								<cfif stepapproveid eq 1>
									#imageTag(source="progress-bar.png")#
								<cfelseif stepapproveid eq 2>
									#imageTag(source="yes.png")#
								<cfelseif stepapproveid eq 3>
									#imageTag(source="no.png")#
								<cfelseif stepapproveid eq 4>
									#imageTag(source="move.png")#
								<cfelse>
									&nbsp;
								</cfif>		
							</td>
							<td class="bottomBorder step">
								<cfif stepaccountingdraft eq 1>
									#imageTag(source="draft.png")#
								</cfif>
								<cfif stepaccountingid eq 1>
									#imageTag(source="progress-bar.png")#
								<cfelseif stepaccountingid eq 2>
									#imageTag(source="yes.png")#
								<cfelseif stepaccountingid eq 3>
									#imageTag(source="no.png")#
								<cfelseif stepaccountingid eq 4>
									#imageTag(source="move.png")#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td class="bottomBorder step">
								<cfif stepacceptdraft eq 1>
									#imageTag(source="draft.png")#
								</cfif>
								<cfif stepacceptid eq 1>
									#imageTag(source="progress-bar.png")#
								<cfelseif stepacceptid eq 2>
									#imageTag(source="yes.png")#
								<cfelseif stepacceptid eq 3>
									#imageTag(source="no.png")#
								<cfelseif stepacceptid eq 4>
									#imageTag(source="move.png")#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		
		</div> <!--- koniec wrapper dla tabeli --->
			
		<div class="workflow_pagination_box"> <!--- okienko paginacji --->
			
			<cfset paginator = 1 />
			<cfset pages_count = Ceiling(myworkflow_count.c/session.workflow_filter.elements) />
			<cfloop condition="paginator LESS THAN OR EQUAL TO pages_count" >
				
				<cfif paginator eq session.workflow_filter.page>
				
					#linkTo(
						text="<span>#paginator#</span>",
						controller="Workflows",
						action="index",
						key=session.user.id,
						class="active",
						params="page=#paginator#&elements=#session.workflow_filter.elements#&year=#session.workflow_filter.year#&month=#session.workflow_filter.month#&typeid=#session.workflow_filter.type#")#
				
				<cfelse>
					
					#linkTo(
						text="<span>#paginator#</span>",
						controller="Workflows",
						action="index",
						key=session.user.id,
						params="page=#paginator#&elements=#session.workflow_filter.elements#&year=#session.workflow_filter.year#&month=#session.workflow_filter.month#&typeid=#session.workflow_filter.type#")#
					
				</cfif>
				
				<cfset paginator++ />
				
			</cfloop>
			
		</div> <!--- koniec okienka paginacji --->
		
	</div> <!--- koniec wrapper dla całej strony --->
</cfoutput>
