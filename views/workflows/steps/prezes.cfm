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
			<tr>
				<td>Przypisz do</td>
				<td>
					<cfinput
						name="move_to_user"
						type="text"
						class="input full"
						placeholder="Wyszukaj użytkownika..." />
				</td>
				<td class="move_to_user_search_result">
					<select name="userid" class="select_box user_select_box required">

					</select>
				</td>
				<td>
					Odrzuć do
				</td>
				<td>
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
			<tr>
				<td>
					Komentarz
				</td>
				<td>
					<cfinput
						type="text"
						name="workflowsteptransfernote"
						class="input full" />
				</td>
				<td colspan="3" class="r">
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
						value="Akceptuje" />
				</td>
			</tr>
		</tbody>
	</table>

</cfform>

<cfset AjaxOnLoad("initWorkflow") />