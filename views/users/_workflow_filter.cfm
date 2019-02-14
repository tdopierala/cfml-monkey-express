<cfoutput>

	<div class="workflow_filter_div">

	<cfform
		name="user_workflow_filter_form"
		action="#URLFor(controller='Users',action='getUserWorkflow',key=session.user.id)#"
		onsubmit="javascript:ColdFusion.navigate('#URLFor(controller='Users',action='getUserWorkflow',key=session.user.id)#', 'intranet_left_content', null, null, 'POST', 'user_workflow_filter_form');return false;" >

		<table class="workflow_filter_table">
			<tbody>
				<tr>
					<td class="label_column">
						Rok
					</td>
					<td class="value_column">
						<select id="workflow_filter_year" name="workflow_filter_year">
							<cfloop collection="#years#" item="year" >
								<option value="#year#" <cfif year eq session.workflow_filter.year> selected</cfif>>#years[year]#</option>
							</cfloop>
						</select>
					</td>
					<td class="label_column">
						Miesiąc
					</td>
					<td class="value_column">
						<select id="workflow_filter_month" name="workflow_filter_month">
							<cfset index = 1 />
							<cfloop array="#months#" index="i" >
								<option value="#index#" <cfif index eq session.workflow_filter.month> selected</cfif>>#i#</option>
							<cfset index++ />
							</cfloop>
						</select>
					</td>
					<td class="label_column">
						Typ
					</td>
					<td class="value_column">
						<select id="categoryid" name="categoryid">
							<option value="0">[wszystkie]</option>
							<cfloop query="categories">
								<option value="#id#" <cfif id eq session.workflow_filter.categoryid> selected</cfif>>#categoryname#</option>
							</cfloop>
						</select>
					</td>
					<td class="label_column">
						<cfinput
							name="submit_workflow_filter"
							type="submit"
							value="Filtruj"
							class="admin_button small_green_admin_button" />
					</td>
					<td class="label_column" style="text-align:center;">
						<a
							href="javascript:ColdFusion.navigate('#URLFor(controller="Users",action="getUserWorkflow",key=session.user.id,params="all=1")#', 'intranet_left_content');"
							class="all_link"
							title="Wszystkie">
								<span>Wszystkie</span>
						</a>
					</td>
				</tr>
			</tbody>
		</table>

	</cfform>

	</div>

</cfoutput>