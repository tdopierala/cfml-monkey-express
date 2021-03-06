<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Aktywne dokumenty</h3>
	</div>
</div>

<div class="headerNavArea">
	<div class="headerNavArea uiHeaderNavArea">
		<ul class="uiHeaderNavAreaList">
			<li>
				<a
					href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserActiveWorkflow",key=session.user.id)#</cfoutput>', 'intranet_left_content');"
					title="Aktywne okumenty"
					class="active">
					Aktywne dokumenty
					<span></span>
				</a>
			</li>

			<li>
				<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserWorkflow",key=session.user.id)#</cfoutput>', 'intranet_left_content');"
					title="Archiwalne dokumenty">
					Archiwalne dokumenty
					<span></span>
				</a>
			</li>
			
			<li>
				<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserAutomatedWorkflow",key=session.user.id,params="automated=1")#</cfoutput>', 'intranet_left_content');"
					title="Obieg automatyczny">
					Obieg automatyczny
					<span></span>
				</a>
			</li>

			<cfinvoke
				component="controllers.Tree_groupusers"
				method="checkUserTreeGroup"
				returnvariable="privPrezes" >

				<cfinvokeargument
					name="groupname"
					value="Prezes" />

			</cfinvoke>

			<cfif privPrezes is true>

				<li>
					<a href="<cfoutput>#URLFor(controller="Workflows",action="closeInvoice",key=session.user.id)#</cfoutput>"
						title="Zamknij zaznaczone"
						class="groupCloseWorkflow {userid:<cfoutput>#session.user.id#</cfoutput>}">
						Zamknij zaznaczone
						<span></span>
					</a>
				</li>

			</cfif>

			<cfif privPrezes is false>
				
				<li>
					<a href="<cfoutput>#URLFor(controller="Workflows",action="groupMove",key=session.user.id)#</cfoutput>"
						title="Przekaż zaznaczone"
						class="groupMoveWorkflow">
						Przekaż zaznaczone
						<span></span>
					</a>
				</li>
				
			</cfif>

			<cfinvoke
				component="controllers.Tree_groupusers"
				method="checkUserTreeGroup"
				returnvariable="privDyrektorzy" >

				<cfinvokeargument
					name="groupname"
					value="Dyrektorzy" />

			</cfinvoke>
			
			<cfinvoke
				component="controllers.Tree_groupusers"
				method="checkUserTreeGroup"
				returnvariable="privPrezes" >

				<cfinvokeargument
					name="groupname"
					value="Prezes" />

			</cfinvoke>
			
			<cfinvoke
				component="controllers.Tree_groupusers"
				method="checkUserTreeGroup"
				returnvariable="privGrupowe" >

				<cfinvokeargument
					name="groupname"
					value="Akceptowanie grupowe" />

			</cfinvoke>

			<cfif (privDyrektorzy is true and privPrezes is not true) or privGrupowe is true>

				<li class="rborder">
					<a href="<cfoutput>#URLFor(controller="Workflows",action="groupAccept",key=session.user.id)#</cfoutput>"
						title="Zaakceptuj zaznaczone"
						class="groupAcceptWorkflow">
						Zaakceptuj zaznaczone
						<span></span>
					</a>
				</li>

			</cfif>
			
			<cfinvoke
				component="controllers.Tree_groupusers"
				method="checkUserTreeGroup"
				returnvariable="privKsiegowanie" >

				<cfinvokeargument
					name="groupname"
					value="Księgowanie grupowe" />

			</cfinvoke>
			
			<cfif privKsiegowanie is true>

				<li class="rborder">
					<a href="<cfoutput>#URLFor(controller="Workflows",action="acceptInvoiceToChairman")#</cfoutput>"
						title="Księguj zaznaczone"
						class="actionGroupAcceptToChairman">
						Księguj<br />zaznaczone
						<span></span>
					</a>
				</li>

			</cfif>

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
								<th class="leftBorder topBorder rightBorder bottomBorder">&nbsp;</th>
								<th class="topBorder rightBorder bottomBorder">
									<input
										type="checkbox"
										name="check_all_invoices"
										class="check_all_invoices"
										id="check_all_invoices" />
								</th>
								<th class="topBorder rightBorder bottomBorder"><span>Nr dok</span></th>
								<th class="topBorder rightBorder bottomBorder"><span>Data</span></th>
								<th class="topBorder rightBorder bottomBorder"><span>Kontrahent</span></th>
								<th class="topBorder rightBorder bottomBorder"><span>Brutto</span></th>
								<th class="topBorder rightBorder bottomBorder">Opis</th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="myworkflow">
								
								<cfif stepdescriptionid eq 1>
									<cfset stepname="step_description" />
								<cfelseif stepcontrollingid eq 1>
									<cfset stepname="step_controlling" />
								<cfelseif stepapproveid eq 1>
									<cfset stepname="step_approve" />
								<cfelseif stepaccountingid eq 1>
									<cfset stepname="step_accounting" />
								<cfelseif stepacceptid eq 1>
									<cfset stepname="step_accept" />
								<cfelse>
									<cfset stepname="" />
								</cfif>
								
								<tr class="<cfoutput>#stepname# #workflowid#</cfoutput> <cfif todelete EQ 1>strikethrough</cfif> ">
									<td class="leftBorder rightBorder bottomBorder">
										<a href="<cfoutput>#URLFor(controller='Workflows',action='tooltip',key=workflowid)#</cfoutput>"
										class="tTip"
										title="Podgląd faktury">

											<span>&nbsp;</span>

										</a>
									</td>
									<td class="rightBorder bottomBorder">
										<!---<cfif stepdescriptionid eq 2>--->
											<input
												type="checkbox"
												name="row-<cfoutput>#workflowid#</cfoutput>"
												value="<cfoutput>#workflowid#</cfoutput>"
												class="<cfoutput>#workflowid#</cfoutput>" />
										<!---</cfif>--->
									</td>
									<td class="rightBorder bottomBorder">
										<a
											href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Workflows",action="edit",key=workflowid)#</cfoutput>', 'intranet_left_content');"
											title="Edytuj dokument">

											<cfoutput>#documentname#</cfoutput>

										</a>
									</td>
									<td class="rightBorder bottomBorder"><cfoutput>#DateFormat(workflowcreated, "yyyy/mm/dd")#</cfoutput></td>
									<td class="rightBorder bottomBorder"><cfoutput>#contractorname#</cfoutput></td>
									<td class="rightBorder bottomBorder"><cfoutput>#brutto#</cfoutput></td>
									<td class="rightBorder bottomBorder"><cfoutput>#workflowstepnote#</cfoutput></td>
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

					<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller='Users',action='getUserActiveWorkflow',key=session.user.id,params='page=#paginator#&elements=#session.workflow_filter.elements#&year=#session.workflow_filter.year#&month=#session.workflow_filter.month#&categoryid=#session.workflow_filter.categoryid#')#</cfoutput>', 'intranet_left_content');"
						class="active">
						<span><cfoutput>#paginator#</cfoutput></span>
					</a>

				<cfelse>

					<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserActiveWorkflow",key=session.user.id,params="page=#paginator#&elements=#session.workflow_filter.elements#&year=#session.workflow_filter.year#&month=#session.workflow_filter.month#&categoryid=#session.workflow_filter.categoryid#")#</cfoutput>', 'intranet_left_content');">
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
<cfset AjaxOnLoad("initWorkflowActions") />
<cfif session.user.id eq 345>
	<div style="clear:both;"></div>
	<cfdump var="#myworkflow#" expand="false" />
	<cfdump var="#request#" expand="false" />
</cfif>