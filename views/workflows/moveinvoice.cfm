<div class="group_move_workflow_modal_close close_curtain">[zamknij]</div>

<div class="group_move_workflow_modal">

	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Przekaż dokument</h3>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			<div class="uiWorkflow">

				<table class="uiTable uiWorkflowTable" id="groupMove">
					<tbody>
						<tr>
							<td>
								<input
									type="hidden"
									name="workflowid_modal"
									id="workflowid_modal"
									value="<cfoutput>#workflowid#</cfoutput>" />

								<input
									name="move_to_user_modal"
									id="move_to_user_modal"
									type="text"
									class="input full"
									placeholder="Przekaż do użytkownika..." />
							</td>
							<td class="move_to_user_search_result">
								<select name="userid_modal" class="select_box user_select_box_modal required" id="userid_modal" style="max-width:200px;">

								</select>
							</td>
							<td>
								<a href="#"
									class="uiSubmit actionMoveWorkflow"
									title="Przekaż">

									<span>Przekaż dokument</span>

								</a>
							</td>
						</tr>
					</tbody>
				</table>

			</div>
		</div>
	</div>

	<div class="footerArea clearfix">
	</div>

</div>