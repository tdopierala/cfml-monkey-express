<cfform
	name="workflow_edit_form"
	action="#URLFor(controller='Workflows',action='actionStep')#" >

	<!---
		Pola ukryte potrzebne do prawidłowego zapisania etapu obiegu dokumentów.
	--->
	<cfinput
		name="workflowid"
		type="hidden"
		value=#workflowid# />

	<cfinput
		name="documentid"
		type="hidden"
		value="#documentid#" />

	<cfinput
		name="workflowstepid"
		type="hidden"
		value="#id#" />

	<cfinput
		name="prev"
		type="hidden"
		value="#prev#" />

	<cfinput
		name="next"
		type="hidden"
		value="#next#" />

	<cfinput
		type="hidden"
		name="chairmanid"
		value="#chairmanId[1]#" />

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
			<cfif params.action neq 'acceptInvoice'>
				<tr>
					<td class="uiLabel">Odrzuć do</td>
					<td class="l">
						<select name="custom_stepstatusid" class="select_box">
							<option value="">[wybierz]</option>
							<cfloop query="workflowStepStatuses">
								<cfif tmp GT id>
									<option value="<cfoutput>#id#</cfoutput>"><cfoutput>#workflowstepstatusname#</cfoutput></option>
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
						class="input full move_to_user"
						data-step="4"
						placeholder="Wyszukaj użytkownika..." />
				<!---</td>
				<td class="move_to_user_search_result">--->
					<select name="userid" class="select_box select_box_small user_select_box">

					</select>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td class="uiLabel">Komentarz</td>
				<td>
					<cfinput
						type="text"
						name="workflowsteptransfernote"
						class="input full" />
				</td>
				<td colspan="3" class="r">
					<cfif params.action eq 'acceptInvoice'>
						<!---<cfinput
								type="submit"
								name="workflow_edit_form_submit"
								class="uiSubmit submitRed"
								value="Księguje" />--->
								
						<cfinput type="hidden" name="workflow_edit_form_submit" value="Księguje" />
						<a	href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Workflows",action="actionStep")#</cfoutput>', 'intranet_left_content', curtainClose, null, 'POST', 'workflow_edit_form');"
							title="Księguje"
							class="uiSubmitInvoice submitRed hide_curtain">
								<span>Księguje</span>
						</a>
					<cfelse>
						<a
							href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Workflows",action="rejectStep")#</cfoutput>', 'intranet_left_content', null, null, 'POST', 'workflow_edit_form');"
							title="Odrzucam"
							class="uiSubmit submitGray">
								<span>Odrzucam</span>
						</a>
	
						<cfinput
								type="submit"
								name="workflow_edit_form_submit"
								class="uiSubmit submitRed"
								value="Księguje" />
					</cfif>
				</td>
			</tr>
		</tbody>
	</table>

</cfform>