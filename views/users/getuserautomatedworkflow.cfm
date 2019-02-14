<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Obieg automatyczny</h3>
	</div>
</div>

<div class="headerNavArea">
	<div class="headerNavArea uiHeaderNavArea">
		<ul class="uiHeaderNavAreaList">
			<li>
				<a
					href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserActiveWorkflow",key=session.user.id)#</cfoutput>', 'user_profile_cfdiv');"
					title="Aktywne okumenty">
					Aktywne dokumenty
					<span></span>
				</a>
			</li>

			<li>
				<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserWorkflow",key=session.user.id)#</cfoutput>', 'user_profile_cfdiv');"
					title="Archiwalne dokumenty">
					Archiwalne dokumenty
					<span></span>
				</a>
			</li>
			
			<li class="rborder">
				<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserAutomatedWorkflow",key=session.user.id,params="automated=1")#</cfoutput>', 'user_profile_cfdiv');"
					title="Obieg automatyczny"
					class="active">
					Obieg automatyczny
					<span></span>
				</a>
			</li>
			
		</ul>
	</div>
</div>

<div class="headerNavArea">
	<div class="headerNavArea uiHeaderNavArea">
		<cfinclude template="_active_workflow_filter.cfm" />
	</div>
</div>


<div class="contentArea">
	<div class="contentArea uiContent">
	
		<div class="uiWorkflow">
	
			<div class="uiWorkflowBigBox clearfix">
	
				<div class="uiWorkflowBigBoxStepContent workflowTable">
					<table class="uiTable uiWorkflowTable" id="userWorkflowTable">
						<thead>
							<tr>
								<th>&nbsp;</th>
								<th>
									<input
										type="checkbox"
										name="check_all_invoices"
										class="check_all_invoices"
										id="check_all_invoices" />
								</th>
								<th>Nr dok.</th>
								<th>Kontrahent</th>
								<th>W obiegu</th>
								<th class="step">Opis</th>
								<th class="step">Controlling</th>
								<th class="step">Zatwierdzono</th>
								<th class="step">Księgowość</th>
								<th class="step">Zaakceptowano</th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="myworkflow">
								<tr class="<cfoutput>#workflowid#</cfoutput>">
									<td>
										<a href="<cfoutput>#URLFor(controller='Workflows',action='tooltip',key=workflowid)#</cfoutput>"
										class="tTip"
										title="Podgląd faktury">

											<span>&nbsp;</span>

										</a>
									</td>
									<td>
										<input
											type="checkbox"
											name="row-<cfoutput>#workflowid#</cfoutput>"
											value="<cfoutput>#workflowid#</cfoutput>"
											class="<cfoutput>#workflowid#</cfoutput>" />
									</td>
									<td>
										<a
											href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Workflows",action="edit",key=workflowid)#</cfoutput>', 'user_profile_cfdiv');"
											title="Edytuj dokument">
	
											<cfoutput>#documentname#</cfoutput>
	
										</a>
									</td>
									<td><cfoutput>#contractorname#</cfoutput></td>
									<td class="step"></td>
									<td class="step">
										<cfif stepdescriptiondraft eq 1>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/draft.png')#" />
										</cfif>

										<cfif stepdescriptionid eq 1>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/progress-bar.png')#" />
										<cfelseif stepdescriptionid eq 2>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/yes.png')#" />
										<cfelseif stepdescriptionid eq 3>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/no.png')#" />
										<cfelseif stepdescriptionid eq 4>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/move.png')#" />
										<cfelse>
											&nbsp;
										</cfif>
									</td>
									<td class="step">
										<cfif stepcontrollingdraft eq 1>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/draft.png')#" />
										</cfif>

										<cfif stepcontrollingid eq 1>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/progress-bar.png')#" />
										<cfelseif stepcontrollingid eq 2>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/yes.png')#" />
										<cfelseif stepcontrollingid eq 3>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/no.png')#" />
										<cfelseif stepcontrollingid eq 4>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/move.png')#" />
										<cfelse>
											&nbsp;
										</cfif>
									</td>
									<td class="step">
										<cfif stepapproveddraft eq 1>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/draft.png')#" />
										</cfif>

										<cfif stepapproveid eq 1>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/progress-bar.png')#" />
										<cfelseif stepapproveid eq 2>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/yes.png')#" />
										<cfelseif stepapproveid eq 3>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/no.png')#" />
										<cfelseif stepapproveid eq 4>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/move.png')#" />
										<cfelse>
											&nbsp;
										</cfif>
									</td>
									<td class="step">
										<cfif stepaccountingdraft eq 1>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/draft.png')#" />
										</cfif>

										<cfif stepaccountingid eq 1>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/progress-bar.png')#" />
										<cfelseif stepaccountingid eq 2>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/yes.png')#" />
										<cfelseif stepaccountingid eq 3>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/no.png')#" />
										<cfelseif stepaccountingid eq 4>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/move.png')#" />
										<cfelse>
											&nbsp;
										</cfif>
									</td>
									<td class="step">
										<cfif stepacceptdraft eq 1>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/draft.png')#" />
										</cfif>

										<cfif stepacceptid eq 1>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/progress-bar.png')#" />
										<cfelseif stepacceptid eq 2>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/yes.png')#" />
										<cfelseif stepacceptid eq 3>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/no.png')#" />
										<cfelseif stepacceptid eq 4>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/move.png')#" />
										<cfelse>
											&nbsp;
										</cfif>
									</td>
								</tr>
							</cfloop>
						</tbody>
					</table>
				</div>
	
			</div>
	
		</div>
	
		<div class="uiFooter">
			<cfset paginator = 1 />
			<cfset pages_count = Ceiling(myworkflowcount.c/session.workflow_filter.elements) />
	
			<cfloop condition="paginator LESS THAN OR EQUAL TO pages_count" >
	
				<cfif paginator eq session.workflow_filter.page>
	
					<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserAutomatedWorkflow",key=session.user.id,params="page=#paginator#&elements=#session.workflow_filter.elements#&year=#session.workflow_filter.year#&month=#session.workflow_filter.month#&categoryid=#session.workflow_filter.categoryid#")#</cfoutput>', 'user_profile_cfdiv');"
						class="active">
						<span><cfoutput>#paginator#</cfoutput></span>
					</a>
	
				<cfelse>
	
					<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserAutomatedWorkflow",key=session.user.id,params="page=#paginator#&elements=#session.workflow_filter.elements#&year=#session.workflow_filter.year#&month=#session.workflow_filter.month#&categoryid=#session.workflow_filter.categoryid#")#</cfoutput>', 'user_profile_cfdiv');">
						<span><cfoutput>#paginator#</cfoutput></span>
					</a>
	
				</cfif>
	
				<cfset paginator++ />
	
			</cfloop>
		</div>
	</div>
</div>

<div class="footerArea">

</div>

<cfset AjaxOnLoad("initWorkflowTooltip") />