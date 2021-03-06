<div class="group_step_workflow_modal_close close_curtain">[zamknij]</div>

<div class="group_step_workflow_modal">

	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Odrzuć dokument</h3>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			<div class="uiWorkflow">

				<!---<cfinclude template="steps/#params.workflowstep#.cfm" />--->

				<cfform
					name="workflow_edit_form"
					action="#URLFor(controller='Workflows',action='rejectStep')#" >
				
					<!---
						Pola ukryte potrzebne do prawidłowego zapisania etapu obiegu dokumentów.
					--->
					<cfinput name="workflowid" type="hidden" value="#workflowid#" />
					<cfinput name="documentid" type="hidden" value="#documentid#" />
					<cfinput name="workflowstepid" type="hidden" value="#id#" />
					<cfinput name="prev" type="hidden" value="#prev#" />
					<cfinput name="next" type="hidden" value="#next#" />
				
					<table class="uiTable uiWorkflowTable">
						<thead>
							<tr>
								<th>&nbsp;</th>
								<th>&nbsp;</th>
								<th>&nbsp;</th>
								<th>&nbsp;</th>
								<th>&nbsp;</th>
							</tr>
						</thead>
						<tbody>
							<cfif params.workflowstep eq 'dyrektor' or params.workflowstep eq 'ksiegowosc'>
								<tr>
									<td class="uiLabel">Odrzuć do</td>
									<td>
										<select name="custom_stepstatusid" class="select_box" id="custom_stepstatusid">
											<option value="">[wybierz]</option>
											<cfloop query="workflowStepStatuses">
												<cfif params.workflowstepstatusid GT id>
													<cfoutput><option value="#id#">#workflowstepstatusname#</option></cfoutput>
												</cfif>
											</cfloop>
										</select>
									</td>
								</tr>
							</cfif>
							<tr>
								<td class="uiLabel">Użytkownik</td> 
								<td class="move_to_user_search_input">
									<cfinput
										name="move_to_user"
										type="text"
										class="input full move_to_user" />
								<!---</td>
								<td colspan="2" class="move_to_user_search_result">--->
									<select name="userid" class="select_box select_box_small user_select_box required">
				
									</select>
								</td>
							</tr>
							<tr>
								<td class="uiLabel">Komentarz</td>
								<td>
									<cfinput
										type="text"
										name="workflowsteptransfernote"
										class="input full" />
								</td>
							</tr>
							<tr>
								<td colspan="2" class="r">
									<!---<cfinput
										type="submit"
										name="workflow_edit_form_submit"
										class="uiSubmitInvoice submitRed"
										value="Odrzucam" />--->
										
									<cfinput type="hidden" name="workflow_edit_form_submit" value="Odrzucam" />
									<a	href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Workflows",action="rejectStep")#</cfoutput>', 'intranet_left_content', curtainClose, null, 'POST', 'workflow_edit_form');"
										title="Odrzucam"
										class="uiSubmitInvoice submitRed hide_curtain">
											<span>Odrzucam</span>
									</a>
								</td>
							</tr>
						</tbody>
					</table>
				
				</cfform>
				
			</div>
		</div>
	</div>

	<div class="footerArea clearfix">
	</div>

</div>