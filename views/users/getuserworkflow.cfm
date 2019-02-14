<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Archiwalne dokumenty</h3>
	</div>
</div>

<div class="headerNavArea">
	<div class="headerNavArea uiHeaderNavArea">
		<ul class="uiHeaderNavAreaList">
			<li>
				<a
					href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserActiveWorkflow",key=session.user.id)#</cfoutput>', 'intranet_left_content');"
					title="Aktywne okumenty">
						Aktywne dokumenty
						<span></span>
				</a>
			</li>

			<li>
				<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserWorkflow",key=session.user.id)#</cfoutput>', 'intranet_left_content');"
					title="Archiwalne dokumenty"
					class="active">
					Archiwalne dokumenty
					<span></span>
				</a>
			</li>

			<li class="rborder">
				<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserAutomatedWorkflow",key=session.user.id,params="automated=1")#</cfoutput>', 'intranet_left_content');"
					title="Obieg automatyczny">
					Obieg automatyczny
					<span></span>
				</a>
			</li>

		</ul>
	</div>
</div>

<div class="headerNavArea">
	<div class="headerNavArea uiHeaderNavArea">
		<cfinclude template="_workflow_filter.cfm" />
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">

		<div class="uiWorkflow">

			<div class="uiWorkflowBigBox clearfix">

				<div class="uiWorkflowBigBoxStepContent workflowTable">
					<table class="uiTable uiWorkflowTable">
						<thead>
							<tr>
								<th class="leftBorder topBorder rightBorder bottomBorder">&nbsp;</th>
								<th class="topBorder rightBorder bottomBorder"><span>Nr dok.</span></th>
								<th class="topBorder rightBorder bottomBorder"><span>Kontrahent</span></th>
								<th class="topBorder rightBorder bottomBorder"><span>W obiegu</span></th>
								<th class="topBorder rightBorder bottomBorder step"><span>Opis</span></th>
								<th class="topBorder rightBorder bottomBorder step"><span>Controlling</span></th>
								<th class="topBorder rightBorder bottomBorder step"><span>Zatwierdzono</span></th>
								<th class="topBorder rightBorder bottomBorder step"><span>Księgowość</span></th>
								<th class="topBorder rightBorder bottomBorder step"><span>Zaakceptowano</span></th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="userworkflow">
								<tr class="<cfif todelete EQ 1>strikethrough</cfif>">
									<td class="leftBorder rightBorder bottomBorder">
										<a href="<cfoutput>#URLFor(controller='Workflows',action='tooltip',key=workflowid)#</cfoutput>"
										class="tTip"
										title="Podgląd faktury">

											<span>&nbsp;</span>
										</a>
									</td>
									<td class="rightBorder bottomBorder">
										<a
											href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Workflows",action="edit",key=workflowid)#</cfoutput>', 'intranet_left_content');"
											title="Edytuj dokument">

											<cfoutput>#documentname#</cfoutput>

										</a>
									</td>
									<td class="rightBorder bottomBorder"><cfoutput>#contractorname#</cfoutput></td>
									<td class="rightBorder bottomBorder step"></td>
									<td class="rightBorder bottomBorder step">
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
									<td class="rightBorder bottomBorder step">
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
									<td class="rightBorder bottomBorder step">
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
									<td class="rightBorder bottomBorder step">
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
									<td class="rightBorder bottomBorder step">
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
			<cfset pages_count = Ceiling(userworkflowcount.c/session.workflow_filter.elements) />
			<cfloop condition="paginator LESS THAN OR EQUAL TO pages_count" >

				<cfif paginator eq session.workflow_filter.page>

					<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserWorkflow",key=session.user.id,params="page=#paginator#&elements=#session.workflow_filter.elements#&year=#session.workflow_filter.year#&month=#session.workflow_filter.month#&categoryid=#session.workflow_filter.categoryid#")#</cfoutput>', 'user_profile_cfdiv');"
						class="active">
						<span><cfoutput>#paginator#</cfoutput></span>
					</a>

				<cfelse>

					<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserWorkflow",key=session.user.id,params="page=#paginator#&elements=#session.workflow_filter.elements#&year=#session.workflow_filter.year#&month=#session.workflow_filter.month#&categoryid=#session.workflow_filter.categoryid#")#</cfoutput>', 'user_profile_cfdiv');"
						class="active">
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